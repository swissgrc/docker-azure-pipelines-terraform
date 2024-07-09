# Base image containing dependencies used in builder and final image
FROM ghcr.io/swissgrc/azure-pipelines-azurecli:2.61.0-net8 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Terraform

# renovate: datasource=repology depName=debian_12/curl versioning=deb
ENV CURL_VERSION=7.88.1-10+deb12u6
# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
ENV TERRAFORM_VERSION=1.9.1
# renovate: datasource=repology depName=debian_12/unzip versioning=deb
ENV UNZIP_VERSION=6.0

RUN apt-get update -y && \
  # Install necessary dependencies
  apt-get install -y --no-install-recommends curl=${CURL_VERSION} unzip=${UNZIP_VERSION}-28 && \
  # Download Terraform
  curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip /tmp/terraform.zip -d /tmp && \
  rm /tmp/terraform.zip

# Install tflint

# renovate: datasource=github-releases depName=terraform-linters/tflint extractVersion=^v(?<version>.*)$
ENV TFLINT_VERSION=0.52.0

RUN curl -Lo /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
  unzip /tmp/tflint.zip -d /tmp && \
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

# Ensure prerequisits are available
RUN git version

# Install Terraform

RUN cp /tmp/terraform /usr/bin/terraform && \
  # Smoke test
  terraform version

# Install tflint

RUN cp /tmp/tflint /usr/local/bin/tflint && \
  # Smoke test
  tflint --version

# Cleanup

RUN rm -rf /tmp/*