# Docker image for running Terraform commands in Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/blob/main/LICENSE) [![Build](https://img.shields.io/github/workflow/status/swissgrc/docker-azure-pipelines-terraform/Build/develop?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/actions/workflows/publish.yml) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform)
<!-- markdownlint-restore -->

Docker image to run Terraform commands in [Azure Pipelines container jobs].

## Usage

This image can be used to run Terraform commands in [Azure Pipelines container jobs].

The following software is additionally available in the image:

| Software   | Included since |
|------------|----------------|
| Azure Cli  | 0.14.6         |
| Git        | 1.2.3          |
| .NET       | 1.2.3          |
| Docker CLI | 1.2.5          |

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

| Tag      | Description                                                                     | Base Image                                 | Terraform | Size                                                                                                                               |
|----------|---------------------------------------------------------------------------------|--------------------------------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                                      | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 1.2.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                                 | swissgrc/azure-pipelines-azurecli:2.40.0   | 1.2.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/unstable?style=flat-square) |
| 0.14.6   | [Terraform 0.14.6](https://github.com/hashicorp/terraform/releases/tag/v0.14.6) | azure-cli:2.19.1                           | 0.14.6    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.14.6?style=flat-square)   |
| 0.15.0   | [Terraform 0.15.0](https://github.com/hashicorp/terraform/releases/tag/v0.15.0) | azure-cli:2.22.0                           | 0.15.0    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.15.0?style=flat-square)   |
| 0.15.1   | [Terraform 0.15.1](https://github.com/hashicorp/terraform/releases/tag/v0.15.1) | azure-cli:2.22.1                           | 0.15.1    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.15.1?style=flat-square)   |
| 1.0.8    | [Terraform 1.0.8](https://github.com/hashicorp/terraform/releases/tag/v1.0.8)   | azure-cli:2.28.0                           | 1.0.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.0.8?style=flat-square)    |
| 1.2.2    | [Terraform 1.2.2](https://github.com/hashicorp/terraform/releases/tag/v1.2.2)   | azure-cli:2.37.0                           | 1.2.2     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.2?style=flat-square)    |
| 1.2.3    | [Terraform 1.2.3](https://github.com/hashicorp/terraform/releases/tag/v1.2.3)   | debian:11.3-slim                           | 1.2.3     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.3?style=flat-square)    |
| 1.2.4    | [Terraform 1.2.4](https://github.com/hashicorp/terraform/releases/tag/v1.2.4)   | debian:11.3-slim                           | 1.2.4     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.4?style=flat-square)    |
| 1.2.5    | [Terraform 1.2.5](https://github.com/hashicorp/terraform/releases/tag/v1.2.5)   | swissgrc/azure-pipelines-azurecli:2.38.0   | 1.2.5     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.5?style=flat-square)    |
| 1.2.6    | [Terraform 1.2.6](https://github.com/hashicorp/terraform/releases/tag/v1.2.6)   | swissgrc/azure-pipelines-azurecli:2.38.0   | 1.2.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.6?style=flat-square)    |
| 1.2.6.1  | [Terraform 1.2.6](https://github.com/hashicorp/terraform/releases/tag/v1.2.6)   | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 1.2.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.6.1?style=flat-square)    |
| 1.2.7    | [Terraform 1.2.7](https://github.com/hashicorp/terraform/releases/tag/v1.2.7)   | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 1.2.7     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.7?style=flat-square)    |
| 1.2.8    | [Terraform 1.2.8](https://github.com/hashicorp/terraform/releases/tag/v1.2.8)   | swissgrc/azure-pipelines-azurecli:2.39.0.1 | 1.2.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.8?style=flat-square)    |

### Configuration

These environment variables are supported:

| Environment variable   | Default value        | Description                                                      |
|------------------------|----------------------|------------------------------------------------------------------|
| TERRAFORM_VERSION      | `1.2.8`              | Version of Terraform installed in the image.                     |
| GIT_VERSION            | `1:2.30.2-1`         | Version of Git installed in the image.                           |
| UNZIP_VERSION          | `6.0-26`             | Version of `unzip` package used to install components.           |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
