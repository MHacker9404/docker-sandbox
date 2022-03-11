# ARG PYTHON_VERSION=3.10.0rc2
# FROM python:${PYTHON_VERSION}-slim-bullseye
FROM python:slim-bullseye

# Prevent dialog during apt install
ENV DEBIAN_FRONTEND noninteractive

# RUN addgroup --gid 1000 node && \
#     adduser --uid 1000 --ingroup node --shell /bin/sh --home /home/node node && \
#     mkdir /home/node/.azure && \
#     mkdir /home/node/.ssh  && \
#     chown -R node:node /home/node

ARG NODE_VERSION=16.9.0
LABEL NODE_VERSION=${NODE_VERSION}
# tools
RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
        apt-transport-https \
        curl \
        gnupg \
        libssl-dev \
        lsb-release \
    # Get all of the signatures we need all at once.
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key  | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg              | gpg --dearmor -o /usr/share/keyrings/yarnpkg.gpg \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/apt-key.gpg \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc     | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg \
    && curl -fsSL https://download.docker.com/linux/debian/gpg          | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    # Add additional apt repos all at once
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" \
        | tee /etc/apt/sources.list.d/node.list \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
        | tee /etc/apt/sources.list.d/docker.list           \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/apt-key.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" \
        | tee /etc/apt/sources.list.d/kubernetes.list \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" \
        | tee /etc/apt/sources.list.d/microsoft.list \
    && apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        git-flow \
        grep \
        snapd \
        software-properties-common \
        sudo \
        tar \
        unzip \
        vim \
        wget \
    && wget https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.567/gcmcore-linux_amd64.2.0.567.18224.deb \
    && dpkg -i gcmcore-linux_amd64.2.0.567.18224.deb \
    && rm gcmcore-linux_amd64.2.0.567.18224.deb \
    && git config --global credential.credentialStore cache \
    && apt clean

# Docker
RUN apt update \
    && apt install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        kubectl \
        containerd.io \
    && apt clean

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt update \
    && apt install -y --no-install-recommends \
        nodejs \
    && apt clean

# nodejs tools
ARG YARN_VERSION=1.22.5
ARG TSC_VERSION=4.4.2
ARG NX_VERSION=12.9.0
ARG NCU_VERSION=11.8.5
LABEL YARN_VERSION=${YARN_VERSION}
LABEL TSC_VERSION=${TSC_VERSION}
LABEL NX_VERSION=${NX_VERSION}
LABEL NCU_VERSION=${NCU_VERSION}
RUN npm install -g \
        yarn@$YARN_VERSION \
    && yarn --version \
    && npm install -g \
        typescript@$TSC_VERSION \
    && tsc --version \
    && npm install -g \
        @nrwl/workspace@$NX_VERSION \
        @nrwl/cli@$NX_VERSION \
        nx@$NX_VERSION \
    && npm install -g \
        npm-check-updates@$NCU_VERSION \
    && ncu --version 

# pulumi
WORKDIR /root
ARG PULUMI_VERSION=3.18.0
LABEL PULUMI_VERSION=${PULUMI_VERSION}
RUN curl -fsSL https://get.pulumi.com/ | bash -s -- --version ${PULUMI_VERSION} \
    && mv .pulumi/bin/* /usr/bin
WORKDIR /

# terraform
ARG TF_VERSION=1.0.11
LABEL TF_VERSION=${TF_VERSION}
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
	# Move to local bin
	&& mv terraform /usr/local/bin/ \
	# Make it executable
	&& chmod +x /usr/local/bin/terraform \
	# Check that it's installed
	&& terraform --version \
    && rm terraform_${TF_VERSION}_linux_amd64.zip

# LABEL TG_VERSION=${TG_VERSION}
# RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TG_VERSION}/terragrunt_linux_amd64 \
# 	# Move to local bin
# 	&& mv terragrunt_linux_amd64 /usr/local/bin/terragrunt \
# 	# Make it executable
# 	&& chmod +x /usr/local/bin/terragrunt \
# 	# Check that it's installed
# 	&& terragrunt --version

# azure-cli
RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
        powershell \
        azure-cli \
    && apt clean

# python3 stuff
RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
        python3-pip \
    && apt clean

# install Net
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt update \
    && apt install -y apt-transport-https \
    && apt install -y aspnetcore-runtime-3.1 dotnet-sdk-5.0 dotnet-sdk-6.0 \
    && apt clean

VOLUME [ "/root/.azure" ]
VOLUME [ "/root/.ssh" ]
VOLUME [ "/workspace" ]

# Allow for caching python modules
VOLUME ["/usr/lib/python3.10/site-packages/"]

WORKDIR /workspace

CMD ["/bin/bash"]