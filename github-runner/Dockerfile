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