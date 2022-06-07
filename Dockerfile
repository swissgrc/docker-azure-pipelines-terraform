FROM node:16.15.1-buster-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-terraform"
LABEL org.opencontainers.image.description="Docker image for running Terraform commands in an Azure Pipelines container job"
LABEL org.opencontainers.image.url="https://github.com/swissgrc/docker-azure-pipelines-terraform"
LABEL org.opencontainers.image.source="https://github.com/swissgrc/docker-azure-pipelines-terraform"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-terraform"

# Required for Azure Pipelines Container Jobs
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Azure CLI

# renovate: datasource=github-releases depName=Azure/azure-cli extractVersion=^Azure CLI (?<version>.*)$
ENV AZURECLI_VERSION=2.37.0
# renovate: datasource=repology depName=debian_10/ca-certificates versioning=loose
ENV CACERTIFICATES_VERSION=20200601~deb10u2
# renovate: datasource=repology depName=debian_10/curl versioning=loose
ENV CURL_VERSION=7.64.0-4+deb10u2
# renovate: datasource=repology depName=debian_10/lsb-release versioning=loose
ENV LSBRELEASE_VERSION=10.2019051400
# renovate: datasource=repology depName=debian_10/gnupg2 versioning=loose
ENV GNUPG_VERSION=2.2.12-1+deb10u1

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends ca-certificates=${CACERTIFICATES_VERSION} curl=${CURL_VERSION} lsb-release=${LSBRELEASE_VERSION} gnupg=${GNUPG_VERSION} && \
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list && \
  apt-get update && apt-get install -y --no-install-recommends azure-cli=${AZURECLI_VERSION}-1~buster && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  az version

# Install Terraform

# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
ENV TERRAFORM_VERSION=1.2.2
# renovate: datasource=repology depName=debian_10/unzip versioning=loose
ENV UNZIP_VERSION=6.0-23+deb10u2

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends unzip=${UNZIP_VERSION} && \
  curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip /tmp/terraform.zip -d /usr/bin && \
  rm -rf /tmp/* && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  terraform version

CMD [ "node" ]
