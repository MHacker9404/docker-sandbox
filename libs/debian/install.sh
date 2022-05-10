apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    libssl-dev \
    libssl-doc \
    lsb-release \
    wget && \
    # Get all of the signatures we need all at once.
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key  | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg              | gpg --dearmor -o /usr/share/keyrings/yarnpkg.gpg && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/apt-key.gpg && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc     | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg && \
    curl -fsSL https://download.docker.com/linux/debian/gpg          | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg                | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg && \
    # Add additional apt repos all at once
    # echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" \
    # | tee /etc/apt/sources.list.d/node.list && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/apt-key.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" \
    | tee /etc/apt/sources.list.d/kubernetes.list > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" \
    | tee /etc/apt/sources.list.d/microsoft.list > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gettext-base \
    git \
    graphviz \
    iputils-ping \
    jq \
    libncurses-dev \
    libffi-dev \
    libsqlite3-dev \
    libreadline-dev \
    libbz2-dev \
    openssh-client \
    software-properties-common \
    sudo \
    tree \
    unzip \
    zip \
    zlib1g-dev && \
    apt-get clean

export DOCKER_CONFIG=$HOME/.docker
export DC_VERSION=2.3.0
apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    pass && \
    apt-get clean

export PATH="/usr/local/lib/docker/cli-plugins:$PATH"
export KUBECONFIG=$HOME/.kube/config

# https://github.com/helm/helm/releases
export HELM_VERSION=v3.9.0-rc.1
curl -1sLf 'https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3' | bash
# add helm-diff
helm plugin install https://github.com/databus23/helm-diff && \
# add helm-unittest
helm plugin install https://github.com/quintush/helm-unittest && \
# add helm-push
helm plugin install https://github.com/chartmuseum/helm-push && \
rm -rf /tmp/helm*

# kubectl
# https://storage.googleapis.com/kubernetes-release/release/stable.txt
export KUBECTL_VERSION=1.23.4
curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install kustomize (latest release)
# https://github.com/kubernetes-sigs/kustomize/releases
export KUSTOMIZE_VERSION=v4.5.2
curl -sLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    tar xvzf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    mv kustomize /usr/bin/kustomize && \
    chmod +x /usr/bin/kustomize && \
    rm kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

# Install kubeseal
# https://github.com/bitnami-labs/sealed-secrets/releases
export KUBESEAL_VERSION=0.17.5
curl -sL https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz -o kubeseal.tar.gz && \
    tar xvzf kubeseal.tar.gz && \
    mv kubeseal /usr/bin/kubeseal && \
    chmod +x /usr/bin/kubeseal && \
    rm kubeseal.tar.gz LICENSE README.md

# python
apt-get install python python3-pip && \
  pip install --upgrade pip setuptools wheel && \
  apt-get clean

# terratest requires go
export GO_VERSION=1.17.8
curl -O https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar xvf go${GO_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local && \
    rm -rf go${GO_VERSION}.linux-amd64.tar.gz
PATH="/usr/local/go/bin:$PATH"

# install sops
# https://github.com/mozilla/sops
export SOPS_VERSION=3.7.1
go install go.mozilla.org/sops/cmd/sops@latest

# install gomplate
# https://github.com/hairyhenderson/gomplate
export GOMPLATE_VERSION=3.10.0
curl -sLO https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-arm64-slim && \
    mv gomplate_linux-arm64-slim /usr/bin/gomplate && \
    chmod +x /usr/bin/gomplate

# terraform
export TF_VERSION=1.1.9
apt-get install -y --no-install-recommends terraform=${TF_VERSION} && \
    apt-get clean

export TG_VERSION=0.36.10
wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TG_VERSION}/terragrunt_linux_amd64 && \
    # Move to local bin
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
    # Make it executable
    chmod +x /usr/local/bin/terragrunt && \
    # Check that it's installed
    terragrunt --version

# azure-cli
apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends azure-cli \
    && apt-get clean

# nvm
export XDG_CONFIG_HOME=$HOME/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# install Net
export ASPNETCORE_URLS=http://+:80
export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:${PATH}"

wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y aspnetcore-runtime-3.1 aspnetcore-runtime-5.0 dotnet-sdk-6.0 \
    && apt clean

dotnet tool install --global dotnet-ef && \
    dotnet tool install --global GitVersion.Tool && \
    dotnet tool install --global dotnet-outdated-tool && \
    dotnet tool install --global dotnet-tools-outdated
# issue with EF Core https://github.com/dotnet/SqlClient/issues/220
# ENV DOTNET_ROOT="/usr/bin"
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# git - gcmcore is dependent on .Net
wget https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.632/gcmcore-linux_amd64.2.0.632.34631.deb && \
    dpkg -i gcmcore-linux_amd64.2.0.632.34631.deb && \
    rm gcmcore-linux_amd64.2.0.632.34631.deb && \
    git config --global credential.credentialStore cache    

# Powershell
apt-get install -y powershell && apt-get clean

cd /tmp && rm -rf ./*