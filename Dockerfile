FROM codercom/code-server

# For Now I am switching the USER back to root to make running docker in docker easier
USER root

# Installing Ubuntu Dependancies
RUN apt-get update && apt-get upgrade -y python3 && apt-get install -y python3-pip git

# Install code language dependancies
RUN pip3 install requests bottle

# Docker engine install
RUN apt update && apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# ioxclient install
RUN curl -O https://pubhub.devnetcloud.com/media/iox/docs/artifacts/ioxclient/ioxclient-v1.16.0.0/ioxclient_1.16.0.0_linux_amd64.tar.gz \
    && tar xvzf ioxclient_1.16.0.0_linux_amd64.tar.gz \
    && chmod +x ioxclient_1.16.0.0_linux_amd64/ioxclient \
    && cp ioxclient_1.16.0.0_linux_amd64/ioxclient /usr/local/bin/ioxclient

# Powershell install
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt update && apt install -y powershell


# VS Code Extensions Install for code-server - Powershell Terminal Extension
#RUN apt update && apt install -y libarchive-tools
#RUN apt update && apt install -y bsdutils
#RUN mkdir -p /root/.local/share/code-server/extensions
#RUN curl -JL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/PowerShell/2021.12.0/vspackage | bsdtar -xvf - extension \
#    && mv extension /root/.local/share/code-server/extensions/ms-vscode.powershell

#RUN code --install-extension powershell-2021.12.0.vsix

# Coping start script
COPY start_codedock.sh /usr/local/bin/start_codedock.sh

RUN chmod +x /usr/local/bin/start_codedock.sh

RUN wget -O /usr/bin/k3s https://github.com/rancher/k3s/releases/download/v0.10.0/k3s
RUN chmod +x /usr/bin/k3s


ENTRYPOINT ["/usr/bin/dumb-init", "start_codedock.sh"]
