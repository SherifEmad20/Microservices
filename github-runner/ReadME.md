# Deploying a Github Runner on Kubernetes

This guide explains how to deploy an Github Runner on a Kubernetes cluster using a **custom Docker image**, a **StatefulSet**, and a **startup script**.

## **1. Overview**

A Github self-hosted runner allows you to run your builds and deployments on your own infrastructure. By running the runner process inside a Kubernetes cluster, you can scale efficiently while maintaining control over the environment.

## **2. Prerequisites**

Before proceeding, ensure you have:

- A Kubernetes cluster (k3s, AKS, or any other K8s setup)
- `kubectl` installed and configured
- Docker installed
- An Github Runner token

---

## **3. Creating the `start.sh` Script**

The `start.sh` script initializes and configures the Github Runner inside the container.

### **`start.sh`**

```bash
#!/bin/bash
# Exit immediately if any command fails
set -e

# Validate if GH_URL is set, otherwise exit with an error
if [ -z "$GH_URL" ]; then
  echo 1>&2 "error: missing GH_URL environment variable"
  exit 1
fi

# Create the work directory if it is defined
if [ -n "$GH_WORK" ]; then
  mkdir -p "$GH_WORK"
fi


# Remove any existing runner installation and create a fresh directory
rm -rf /gh/agent
mkdir /gh/agent
cd /gh/agent

# Allow the runner to run as root
export RUNNER_ALLOW_RUNASROOT=1

# Function to print section headers in light cyan color
print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

print_header "1. Setting Github Runner URL..."

# Set GH_Runner Package URL
GH_RUNNERPACKAGE_URL="https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-arm64-2.328.0.tar.gz"

print_header "2. Downloading and installing Github Runner..."
echo "$GH_RUNNERPACKAGE_URL"

# Download and extract the runner package
curl -LsS $GH_RUNNERPACKAGE_URL | tar -xz & wait $!

# Source the environment variables from the runner package
source ./env.sh

print_header "3. Configuring Github Runner..."

# Run the runner configuration script in unattended mode
./config.sh --url "$GH_URL" \
  --token "$GH_TOKEN" \
  --runnergroup "$GH_RUNNERGROUP" \
  --name "$GH_AGENT_NAME" \
  --work "$GH_WORK" \
  --labels workflow-runner-self-hosted \
  --replace \
  --unattended & wait $!

print_header "4. Running Github Runner..."

# Execute runner run script
./run.sh
```

---

## **4. Creating the Github Runner Dockerfile**

The Dockerfile defines the environment where the Github Runner will run and the tools needed for the tech stack.

### **`Dockerfile`**

```dockerfile
FROM amazonlinux:latest

####################################
# Change shell to bash
SHELL ["/bin/bash", "-c", "-l"]

####################################
# Set working Directory
WORKDIR /gh

####################################
# Copy start script
COPY start.sh /tmp/

####################################
# Move Start Script To the Working Directory
RUN mv /tmp/start.sh . \
    && chmod +x start.sh \
    ####################################
    # Install Dependencies
    && yum update -y \
    &&  yum install -y --setopt=install_weak_deps=False \
    wget unzip zip gzip bzip2 tar jq git vim gettext gnupg findutils libicu \
    ####################################
    # Install Docker
    && yum install -y --setopt=install_weak_deps=False docker \
    && ln -s /usr/bin/docker /usr/local/bin/docker \
    ####################################
    # Clean up
    && yum clean packages -y \
    && yum clean all \
    ####################################
    # Install terraform
    && dnf install -y dnf-plugins-core \
    && dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo \
    && dnf -y install terraform \
    ####################################
    # Install az cli
    && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo \
    && yum install -y azure-cli \
    #####################################
    # Install kubectl
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

####################################
# Configure The Volumes Needed For The Runner
VOLUME /var/run/docker.sock 

####################################
# Start The Build Runner
CMD ["./start.sh"]

```

---

## **5. Deploying the Runner Using Kubernetes StatefulSet And ConfigMaps**

The StatefulSet deploys the Runner container on the Kubernetes cluster and the ConfigMap contains the environment variables needed by the StatefulSet.

### **`statefulset.yaml`**

```yaml
# Service account used by the StatefulSet
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gh-runner-sa
  namespace: gh-runner-amazon-linux
---
# ConfigMap for storing environment variables required by the runner
apiVersion: v1
kind: ConfigMap
metadata:
  name: gh-runner-environment
  namespace: gh-runner-amazon-linux
data:
  GH_RUNNERGROUP: default # Using the default group
  GH_TOKEN: <Runner Token> # Used for authentication with github
  GH_URL: <Repository URL>
  GH_WORK: /work # Working directory
---
# StatefulSet for deploying a Github Runner runner in Kubernetes
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: gh-runner-amazon-linux # Generic name for the StatefulSet
  namespace: gh-runner-amazon-linux # Namespace where the StatefulSet is deployed

spec:
  serviceName: gh-runner-amazon-linux # Associated service name
  selector:
    matchLabels:
      app: gh-runner-amazon-linux # Label selector for identifying managed pods

  replicas: 1 # Number of runners instances to deploy (adjust as needed)
  template:
    metadata:
      labels:
        app: gh-runner-amazon-linux # Label to identify the pods

    spec:
      serviceAccountName: gh-runner-sa # Service account for pod permissions
      containers:
        - name: gh-runner-amazon-linux # Name of the container
          securityContext:
            privileged: true # Run container in privileged mode if required
          image: <IMAGE_NAME>:<IMAGE_TAG> # Placeholder for runner image
          imagePullPolicy: Always # Always pull the latest image

          env:
            - name: GH_AGENT_NAME # Assign the pod name as the runner name
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          envFrom:
            - configMapRef:
                name: gh-runner-environment # Load environment variables from ConfigMap

          volumeMounts:
            - name: dockersock # Mount Docker socket for in-container builds
              mountPath: /var/run/docker.sock
            - name: agent-work # Persistent volume for agent workspace
              mountPath: /work

      volumes:
        - name: dockersock
          hostPath:
            path: /var/run/docker.sock # Mount host Docker socket inside the container

  volumeClaimTemplates:
    - metadata:
        name: agent-work # Persistent volume claim for agent workspace
      spec:
        accessModes: ["ReadWriteOnce"] # Single node access mode
        storageClassName: standard # Generic storage class
        resources:
          requests:
            storage: 6Gi # Define required storage capacity

# This StatefulSet can be customized for various CI/CD use cases by modifying the environment variables and storage settings.
```

---

## **6. Deploying to Kubernetes**

1. **Build and push the Docker image**:

   ```bash
   docker build -t <IMAGE_NAME>:<IMAGE_TAG> .
   docker push <IMAGE_NAME>:<IMAGE_TAG>
   ```

2. **Create The Runner Namespace**:

   ```bash
   kubectl create ns gh-runner
   ```

3. **Apply the ServiceAccount**:

   ```bash
   kubectl apply -f serviceaccount.yaml
   ```

4. **Apply the ConfigMap**:

   ```bash
   kubectl apply -f configmap.yaml
   ```

5. **Deploy the StatefulSet**:

   ```bash
   kubectl apply -f statefulset.yaml
   ```

6. **Verify the deployment**:

   ```bash
   kubectl get pods -n gh-runner-amazon-linux
   ```

---

## **7. Conclusion**

This setup allows you to run an Github Runners on a Kubernetes cluster. You can scale the runners by increasing the `replicas` count in the StatefulSet which will allow parallel CI/CD runs and resources utilization if you have only one server, and you can customize the image to fit your CI/CD pipeline needs.

---

### **References**

- [Github Runner Documentation](https://docs.github.com/en/actions/concepts/runners/self-hosted-runners)
