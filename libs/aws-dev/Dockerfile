FROM prbservicesllc/aws:latest

# nodejs tools
# https://github.com/sass/dart-sass
ARG SASS_VERSION=1.49.9
LABEL SASS_VERSION=${SASS_VERSION}
RUN curl -sLO https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/dart-sass-${SASS_VERSION}-linux-x64.tar.gz && \
    tar xvzf dart-sass-${SASS_VERSION}-linux-x64.tar.gz && \
    mv ./dart-sass /usr/bin/ && \
    chmod +x /usr/bin/dart-sass/sass && \
    rm dart-sass-${SASS_VERSION}-linux-x64.tar.gz
ENV PATH="/usr/bin/dart-sass/:${PATH}"

# install Net
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install -y aspnetcore-runtime-3.1 dotnet-sdk-5.0 dotnet-sdk-6.0 && \
    apt clean

ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_HTTPS_PORT=https://+:5001

ENV PATH="/root/.dotnet:/root/.dotnet/tools:${PATH}"
RUN dotnet tool install --global dotnet-ef && \
    dotnet tool install --global GitVersion.Tool && \
    dotnet tool install --global dotnet-outdated-tool && \
    dotnet tool install --global dotnet-tools-outdated
# issue with EF Core https://github.com/dotnet/SqlClient/issues/220
# ENV DOTNET_ROOT="/usr/bin"
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
VOLUME [ "/root/.nuget" ]

# # git - gcmcore is dependent on .Net
RUN wget https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.632/gcmcore-linux_amd64.2.0.632.34631.deb && \
    dpkg -i gcmcore-linux_amd64.2.0.632.34631.deb && \
    rm gcmcore-linux_amd64.2.0.632.34631.deb && \
    git config --global credential.credentialStore cache

# https://mkcert.dev/
# https://medium.com/@ma1f/docker-dotnet-3d979f56efe6
# dotnet kestrel env vars
ENV Kestrel:Certificates:Default:Path=/etc/ssl/private/cert.pfx
ENV Kestrel:Certificates:Default:Password=changeit
ENV Kestrel:Certificates:Default:AllowInvalid=true
ENV Kestrel:EndPointDefaults:Protocols=Http1AndHttp2

# copy certificate authority certs from local file system
ENV CA_KEY=./mkcert/rootCA-key.pem
ENV CA_CERT=./mkcert/rootCA.pem
# default ca cert location (mkcert)
COPY ${CA_KEY} /root/.local/share/mkcert/
COPY ${CA_CERT} /root/.local/share/mkcert/

ENV DOMAINS='prb-services-llc.com localhost 127.0.0.1'
# install CA and SSL cert
RUN apt-get install libnss3-tools -y && \
    curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64 > /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert && \
    mkcert -install && \
    mkcert -p12-file /etc/ssl/private/cert.pfx -pkcs12 $DOMAINS

RUN cd /tmp && rm -rf ./*

# kubectl
EXPOSE 8080
# react
EXPOSE 3000
# angular
EXPOSE 4200
# Net
EXPOSE 5000
EXPOSE 5001

ENTRYPOINT [ "/bin/bash", "-c" ]