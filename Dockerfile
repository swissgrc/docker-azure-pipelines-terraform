# Base image containing dependencies used in builder and final image
FROM ghcr.io/swissgrc/azure-pipelines-azurecli:2.67.0-net9 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_12/unzip versioning=deb
ENV UNZIP_VERSION=6.0

# Install necessary dependencies
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends unzip=${UNZIP_VERSION}-28

# Install Terraform

# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
ENV TERRAFORM_VERSION=1.9.8

# Download Terraform
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/terraform.zip
RUN unzip /tmp/terraform.zip -d /tmp && \
  rm /tmp/terraform.zip

# Install tflint

# renovate: datasource=github-releases depName=terraform-linters/tflint extractVersion=^v(?<version>.*)$
ENV TFLINT_VERSION=0.54.0

ADD https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip /tmp/tflint.zip
RUN unzip /tmp/tflint.zip -d /tmp && \
  rm /tmp/tflint.zip


# Final image
FROM base AS final

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-terraform"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-terraform"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /
COPY --from=build /tmp/ /tmp

RUN \
  # Ensure prerequisits are available
  git version && \
  # Install Terraform
  cp /tmp/terraform /usr/bin/terraform && \
  terraform version && \
  # Install tflint
  cp /tmp/tflint /usr/local/bin/tflint && \
  tflint --version && \
  # Cleanup
  rm -rf /tmp/*
