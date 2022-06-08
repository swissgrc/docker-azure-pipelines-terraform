FROM debian:bullseye-slim

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-terraform"
LABEL org.opencontainers.image.description="Docker image for running Terraform commands in an Azure Pipelines container job"
LABEL org.opencontainers.image.url="https://github.com/swissgrc/docker-azure-pipelines-terraform"
LABEL org.opencontainers.image.source="https://github.com/swissgrc/docker-azure-pipelines-terraform"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-terraform"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Git

# renovate: datasource=repology depName=debian_11/git versioning=loose
ENV GIT_VERSION=1:2.30.2-1

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends git=${GIT_VERSION} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  git version

# Install Azure CLI

# renovate: datasource=github-releases depName=Azure/azure-cli extractVersion=^Azure CLI (?<version>.*)$
ENV AZURECLI_VERSION=2.37.0
# renovate: datasource=repology depName=debian_11/ca-certificates versioning=loose
ENV CACERTIFICATES_VERSION=20210119
# renovate: datasource=repology depName=debian_11/curl versioning=loose
ENV CURL_VERSION=7.74.0-1.3+deb11u1
# renovate: datasource=repology depName=debian_11/lsb-release versioning=loose
ENV LSBRELEASE_VERSION=11.1.0
# renovate: datasource=repology depName=debian_11/gnupg2 versioning=loose
ENV GNUPG_VERSION=2.2.27-2+deb11u1

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends ca-certificates=${CACERTIFICATES_VERSION} curl=${CURL_VERSION} lsb-release=${LSBRELEASE_VERSION} gnupg=${GNUPG_VERSION} && \
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list && \
  apt-get update && apt-get install -y --no-install-recommends azure-cli=${AZURECLI_VERSION}-1~bullseye && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  az version

# Install Terraform

# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
ENV TERRAFORM_VERSION=1.2.2
# renovate: datasource=repology depName=debian_11/unzip versioning=loose
ENV UNZIP_VERSION=6.0-26

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends unzip=${UNZIP_VERSION} && \
  curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip /tmp/terraform.zip -d /usr/bin && \
  rm -rf /tmp/* && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  terraform version
