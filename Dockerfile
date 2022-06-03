FROM node:16.15.0-buster-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-terraform"
LABEL org.opencontainers.image.description="Docker image for running Terraform commands in an Azure Pipelines container job"
LABEL org.opencontainers.image.url="https://github.com/swissgrc/docker-azure-pipelines-terraform"
LABEL org.opencontainers.image.source="https://github.com/swissgrc/docker-azure-pipelines-terraform"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-terraform"

# Required for Azure Pipelines Container Jobs
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"

# Install Azure CLI

# renovate: datasource=github-releases depName=Azure/azure-cli extractVersion=^Azure CLI (?<version>.*)$
ENV AZURECLI_VERSION=2.37.0

RUN apt update -y && \
  apt install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list && \
  apt update && apt install -y azure-cli=${AZURECLI_VERSION}-1~buster && \
  apt clean all && \
  # Smoke test
  az version

# Install Terraform

# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
ENV TERRAFORM_VERSION=1.2.2

RUN apt update -y && \
  apt install -y wget unzip && \
  cd /tmp && \
  wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
  rm -rf /tmp/* && \
  apt clean all && \
  # Smoke test
  terraform version

CMD [ "node" ]
