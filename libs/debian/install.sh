rm .bashrc
ln -s /mnt/c/Users/phil.boyd/.ssh $HOME/.ssh
ln -s /mnt/c/Users/phil.boyd/.kube $HOME/.kube
ln -s /mnt/c/Users/phil.boyd/.bashrc $HOME/.bashrc
ln -s /mnt/c/Users/phil.boyd/.bash_aliases $HOME/.bash_aliases
ln -s /mnt/c/Users/phil.boyd/.bash_profile $HOME/.bash_profile

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
    # echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    # | tee /etc/apt/sources.list.d/vscode.list > /dev/null && \
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

# install VSCode Insiders
# apt-get update && apt-get upgrade -y && \
#     apt-get install -y --no-install-recommends code-insiders

export DC_VERSION=2.3.0
apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    pass && \
    apt-get clean

# export PATH="/usr/local/lib/docker/cli-plugins:$PATH"

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
# export KUBECTL_VERSION=1.24.0
# curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
#     mv kubectl /usr/bin/kubectl && \
#     chmod +x /usr/bin/kubectl
apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends kubectl

# Install kustomize (latest release)
# https://github.com/kubernetes-sigs/kustomize/releases
export KUSTOMIZE_VERSION=v4.5.5
curl -sLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    tar xvzf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    sudo mv kustomize /usr/bin/kustomize && \
    sudo chmod +x /usr/bin/kustomize && \
    rm kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

# Install kubeseal
# https://github.com/bitnami-labs/sealed-secrets/releases
export KUBESEAL_VERSION=0.18.0
curl -sL https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz -o kubeseal.tar.gz && \
    tar xvzf kubeseal.tar.gz && \
    sudo mv kubeseal /usr/bin/kubeseal && \
    sudo chmod +x /usr/bin/kubeseal && \
    rm kubeseal.tar.gz LICENSE README.md

# python
sudo apt-get install python python3-pip && \
  sudo pip install --upgrade pip setuptools wheel && \
  sudo apt-get clean

# terratest requires go
export GO_VERSION=1.18.3
sudo curl -O https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    sudo tar xvf go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local && \
    sudo rm -rf go${GO_VERSION}.linux-amd64.tar.gz

# install sops
# https://github.com/mozilla/sops
export SOPS_VERSION=3.7.3
sudo /usr/local/go/bin/go install go.mozilla.org/sops/cmd/sops@latest

# install gomplate
# https://github.com/hairyhenderson/gomplate
export GOMPLATE_VERSION=3.11.1
sudo curl -sLO https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-arm64-slim && \
    sudo mv gomplate_linux-arm64-slim /usr/bin/gomplate && \
    sudo chmod +x /usr/bin/gomplate

# terraform
export TF_VERSION=1.2.4
sudo apt-get install -y --no-install-recommends terraform=${TF_VERSION} && \
    sudo apt-get clean

export TG_VERSION=0.38.4
sudo wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TG_VERSION}/terragrunt_linux_amd64 && \
    # Move to local bin
    sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
    # Make it executable
    sudo chmod +x /usr/local/bin/terragrunt && \
    # Check that it's installed
    terragrunt --version

# azure-cli
sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get install -y --no-install-recommends azure-cli \
    && sudo apt-get clean

# nvm

# install Net
# export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:${PATH}"

sudo wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && sudo dpkg -i packages-microsoft-prod.deb \
    && sudo rm packages-microsoft-prod.deb \
    && sudo apt-get update \
    && sudo apt-get install -y aspnetcore-runtime-3.1 aspnetcore-runtime-5.0 dotnet-sdk-6.0 \
    && sudo apt clean

dotnet tool install --global dotnet-ef && \
    dotnet tool install --global GitVersion.Tool && \
    dotnet tool install --global dotnet-outdated-tool && \
    dotnet tool install --global dotnet-tools-outdated
# issue with EF Core https://github.com/dotnet/SqlClient/issues/220
# ENV DOTNET_ROOT="/usr/bin"

# git - gcmcore is dependent on .Net
sudo wget https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.779/gcm-linux_amd64.2.0.779.deb && \
    sudo dpkg -i gcm-linux_amd64.2.0.779.deb && \
    sudo rm gcm-linux_amd64.2.0.779.deb && \
    sudo git config --global credential.credentialStore cache

# Powershell
sudo apt-get install -y powershell && sudo apt-get clean

# dart-sass
SASS_VERSION=1.53.0
sudo curl -sLO https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/dart-sass-${SASS_VERSION}-linux-x64.tar.gz && \
    sudo tar xvzf dart-sass-${SASS_VERSION}-linux-x64.tar.gz -C /usr/bin && \
    # mv ./dart-sass /usr/bin/ && \
    sudo chmod +x /usr/bin/dart-sass/sass && \
    sudo rm dart-sass-${SASS_VERSION}-linux-x64.tar.gz

cd /tmp && sudo rm -rf ./*
