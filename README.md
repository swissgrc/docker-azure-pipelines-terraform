# Docker image for running Terraform commands in Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/blob/main/LICENSE) [![Build](https://img.shields.io/docker/cloud/build/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform/builds) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform)
<!-- markdownlint-restore -->

Docker image to run Terraform commands in [Azure Pipelines container jobs].

## Usage

This image can be used to run Terraform commands in [Azure Pipelines container jobs]. For executing Azure commands Azure CLI is included as well.

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job, add one of the following example tasks and use it with the `container` property.

The following example shows the container used for a deployment step with a Terraform command

```yaml
  - stage: deploy
    jobs:
      - deployment: planTerraform
        container: swissgrc/azure-pipelines-terraform:latest
        environment: smarthotel-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - bash: |
                    terraform init -backend-config=./config/dev_backend.tfvars
```

The following example defines a deployment with the container using `az login` before calling Terraform commands.
Note that two secret variables (`Azure.UserName` and `Azure.Password`) are passed to the task by the env block.

```yaml
  - stage: deploy
    jobs:
      - deployment: planTerraform
        container: swissgrc/azure-pipelines-terraform:latest
        environment: smarthotel-dev
        strategy:
          runOnce:
            deploy:
              steps:
                - bash: |
                    az login -u $AZURE_USERNAME -p $AZURE_PASSWORD
                    terraform init -backend-config=./config/dev_backend.tfvars
                    terraform plan -var-file=./config/dev.tfvars
                  env:
                    AZURE_USERNAME: $(Azure.UserName)
                    AZURE_PASSWORD: $(Azure.Password)
```

### Tags

| Tag      | Description                                                                     | Base Image       | Terraform | Git        | Azure CLI | .NET    | Size                                                                                                                               |
|----------|---------------------------------------------------------------------------------|------------------|-----------|------------|-----------|---------|------------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                                      | debian:11.3-slim | 1.2.3     | 1:2.30.2-1 | 2.37.0    | 6.0.301 | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                                 | debian:11.3-slim | 1.2.3     | 1:2.30.2-1 | 2.37.0    | 6.0.301 | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/unstable?style=flat-square) |
| 0.14.6   | [Terraform 0.14.6](https://github.com/hashicorp/terraform/releases/tag/v0.14.6) | azure-cli:2.19.1 | 0.14.6    | N/A        | 2.19.1    | N/A     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.14.6?style=flat-square)   |
| 0.15.0   | [Terraform 0.15.0](https://github.com/hashicorp/terraform/releases/tag/v0.15.0) | azure-cli:2.22.0 | 0.15.0    | N/A        | 2.22.0    | N/A     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.15.0?style=flat-square)   |
| 0.15.1   | [Terraform 0.15.1](https://github.com/hashicorp/terraform/releases/tag/v0.15.1) | azure-cli:2.22.1 | 0.15.1    | N/A        | 2.22.1    | N/A     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.15.1?style=flat-square)   |
| 1.0.8    | [Terraform 1.0.8](https://github.com/hashicorp/terraform/releases/tag/v1.0.8)   | azure-cli:2.28.0 | 1.0.8     | N/A        | 2.28.0    | N/A     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.0.8?style=flat-square)    |
| 1.2.2    | [Terraform 1.2.2](https://github.com/hashicorp/terraform/releases/tag/v1.2.2)   | azure-cli:2.37.0 | 1.2.2     | N/A        | 2.37.0    | N/A     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.2?style=flat-square)    |
| 1.2.3    | [Terraform 1.2.3](https://github.com/hashicorp/terraform/releases/tag/v1.2.3)   | debian:11.3-slim | 1.2.3     | 1:2.30.2-1 | 2.37.0    | 6.0.301 | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.3?style=flat-square)    |

### Configuration

These environment variables are supported:

| Environment variable   | Default value        | Description                                                      |
|------------------------|----------------------|------------------------------------------------------------------|
| TERRAFORM_VERSION      | `1.2.3`              | Version of Terraform installed in the image.                     |
| GIT_VERSION            | `1:2.30.2-1`         | Version of Git installed in the image.                           |
| DOTNET_VERSION         | `6.0.301`            | Version of .NET installed in the image.                          |
| AZURECLI_VERSION       | `2.37.0`             | Version of Azure CLI installed in the image.                     |
| CACERTIFICATES_VERSION | `20210119`           | Version of `ca-certificates` package used to install components. |
| CURL_VERSION           | `7.74.0-1.3+deb11u1` | Version of `curl` package used to install components.            |
| LSBRELEASE_VERSION     | `11.1.0`             | Version of `lsb-release` package used to install components.     |
| GNUPG_VERSION          | `2.2.27-2+deb11u1`   | Version of `gnupg` package used to install components.           |
| UNZIP_VERSION          | `6.0-26`             | Version of `unzip` package used to install components.           |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
