# Base image containing dependencies used in builder and final image
FROM swissgrc/azure-pipelines-azurecli:2.44.1 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Terraform

# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
ENV TERRAFORM_VERSION=1.3.8
# renovate: datasource=repology depName=debian_11/unzip versioning=loose
ENV UNZIP_VERSION=6.0-26+deb11u1

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends unzip=${UNZIP_VERSION} && \
  curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip /tmp/terraform.zip -d /tmp && \
  rm /tmp/terraform.zip


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

# Install Git

# renovate: datasource=repology depName=debian_11/git versioning=loose
ENV GIT_VERSION=1:2.30.2-1

RUN apt-get update -y && \
  # Install Git
  apt-get install -y --no-install-recommends git=${GIT_VERSION} && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  git version

# Install Terraform

RUN cp /tmp/terraform /usr/bin/terraform && \
  rm -rf /tmp/* && \
  # Smoke test
  terraform version