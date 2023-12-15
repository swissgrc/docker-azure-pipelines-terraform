# Docker image for running Terraform commands in Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-terraform/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/actions/workflows/publish.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=swissgrc_docker-azure-pipelines-terraform&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=swissgrc_docker-azure-pipelines-terraform) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform)
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

| Tag      | Description                                                                     | Base Image                                    | Terraform | Size                                                                                                                               |
|----------|---------------------------------------------------------------------------------|-----------------------------------------------|-----------|------------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                                      | swissgrc/azure-pipelines-azurecli:2.55.0-net8 | 1.6.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                                 | swissgrc/azure-pipelines-azurecli:2.55.0-net8 | 1.6.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/unstable?style=flat-square) |
| 0.14.6   | [Terraform 0.14.6](https://github.com/hashicorp/terraform/releases/tag/v0.14.6) | azure-cli:2.19.1                              | 0.14.6    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.14.6?style=flat-square)   |
| 0.15.0   | [Terraform 0.15.0](https://github.com/hashicorp/terraform/releases/tag/v0.15.0) | azure-cli:2.22.0                              | 0.15.0    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.15.0?style=flat-square)   |
| 0.15.1   | [Terraform 0.15.1](https://github.com/hashicorp/terraform/releases/tag/v0.15.1) | azure-cli:2.22.1                              | 0.15.1    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.15.1?style=flat-square)   |
| 1.0.8    | [Terraform 1.0.8](https://github.com/hashicorp/terraform/releases/tag/v1.0.8)   | azure-cli:2.28.0                              | 1.0.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.0.8?style=flat-square)    |
| 1.2.2    | [Terraform 1.2.2](https://github.com/hashicorp/terraform/releases/tag/v1.2.2)   | azure-cli:2.37.0                              | 1.2.2     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.2?style=flat-square)    |
| 1.2.3    | [Terraform 1.2.3](https://github.com/hashicorp/terraform/releases/tag/v1.2.3)   | debian:11.3-slim                              | 1.2.3     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.3?style=flat-square)    |
| 1.2.4    | [Terraform 1.2.4](https://github.com/hashicorp/terraform/releases/tag/v1.2.4)   | debian:11.3-slim                              | 1.2.4     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.4?style=flat-square)    |
| 1.2.5    | [Terraform 1.2.5](https://github.com/hashicorp/terraform/releases/tag/v1.2.5)   | swissgrc/azure-pipelines-azurecli:2.38.0      | 1.2.5     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.5?style=flat-square)    |
| 1.2.6    | [Terraform 1.2.6](https://github.com/hashicorp/terraform/releases/tag/v1.2.6)   | swissgrc/azure-pipelines-azurecli:2.38.0      | 1.2.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.6?style=flat-square)    |
| 1.2.6.1  | [Terraform 1.2.6](https://github.com/hashicorp/terraform/releases/tag/v1.2.6)   | swissgrc/azure-pipelines-azurecli:2.39.0.1    | 1.2.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.6.1?style=flat-square)  |
| 1.2.7    | [Terraform 1.2.7](https://github.com/hashicorp/terraform/releases/tag/v1.2.7)   | swissgrc/azure-pipelines-azurecli:2.39.0.1    | 1.2.7     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.7?style=flat-square)    |
| 1.2.8    | [Terraform 1.2.8](https://github.com/hashicorp/terraform/releases/tag/v1.2.8)   | swissgrc/azure-pipelines-azurecli:2.39.0.1    | 1.2.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.8?style=flat-square)    |
| 1.2.9    | [Terraform 1.2.9](https://github.com/hashicorp/terraform/releases/tag/v1.2.9)   | swissgrc/azure-pipelines-azurecli:2.40.0      | 1.2.9     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.2.9?style=flat-square)    |
| 1.3.0    | [Terraform 1.3.0](https://github.com/hashicorp/terraform/releases/tag/v1.3.0)   | swissgrc/azure-pipelines-azurecli:2.40.0      | 1.3.0     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.0?style=flat-square)    |
| 1.3.1    | [Terraform 1.3.1](https://github.com/hashicorp/terraform/releases/tag/v1.3.1)   | swissgrc/azure-pipelines-azurecli:2.40.0      | 1.3.1     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.1?style=flat-square)    |
| 1.3.2    | [Terraform 1.3.2](https://github.com/hashicorp/terraform/releases/tag/v1.3.2)   | swissgrc/azure-pipelines-azurecli:2.41.0      | 1.3.2     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.2?style=flat-square)    |
| 1.3.3    | [Terraform 1.3.3](https://github.com/hashicorp/terraform/releases/tag/v1.3.3)   | swissgrc/azure-pipelines-azurecli:2.41.0      | 1.3.3     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.3?style=flat-square)    |
| 1.3.4    | [Terraform 1.3.4](https://github.com/hashicorp/terraform/releases/tag/v1.3.4)   | swissgrc/azure-pipelines-azurecli:2.42.0      | 1.3.4     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.4?style=flat-square)    |
| 1.3.5    | [Terraform 1.3.5](https://github.com/hashicorp/terraform/releases/tag/v1.3.5)   | swissgrc/azure-pipelines-azurecli:2.42.0      | 1.3.5     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.5?style=flat-square)    |
| 1.3.6    | [Terraform 1.3.6](https://github.com/hashicorp/terraform/releases/tag/v1.3.6)   | swissgrc/azure-pipelines-azurecli:2.42.0      | 1.3.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.6?style=flat-square)    |
| 1.3.7    | [Terraform 1.3.7](https://github.com/hashicorp/terraform/releases/tag/v1.3.7)   | swissgrc/azure-pipelines-azurecli:2.43.0      | 1.3.7     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.7?style=flat-square)    |
| 1.3.8    | [Terraform 1.3.8](https://github.com/hashicorp/terraform/releases/tag/v1.3.8)   | swissgrc/azure-pipelines-azurecli:2.45.0      | 1.3.8     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.3.8?style=flat-square)    |
| 1.4.0    | [Terraform 1.4.0](https://github.com/hashicorp/terraform/releases/tag/v1.4.0)   | swissgrc/azure-pipelines-azurecli:2.46.0      | 1.4.0     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.0?style=flat-square)    |
| 1.4.1    | [Terraform 1.4.1](https://github.com/hashicorp/terraform/releases/tag/v1.4.1)   | swissgrc/azure-pipelines-azurecli:2.46.0      | 1.4.1     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.1?style=flat-square)    |
| 1.4.2    | [Terraform 1.4.2](https://github.com/hashicorp/terraform/releases/tag/v1.4.2)   | swissgrc/azure-pipelines-azurecli:2.46.0      | 1.4.2     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.2?style=flat-square)    |
| 1.4.3    | [Terraform 1.4.3](https://github.com/hashicorp/terraform/releases/tag/v1.4.3)   | swissgrc/azure-pipelines-azurecli:2.46.0      | 1.4.3     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.3?style=flat-square)    |
| 1.4.4    | [Terraform 1.4.4](https://github.com/hashicorp/terraform/releases/tag/v1.4.4)   | swissgrc/azure-pipelines-azurecli:2.47.0      | 1.4.4     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.4?style=flat-square)    |
| 1.4.5    | [Terraform 1.4.5](https://github.com/hashicorp/terraform/releases/tag/v1.4.5)   | swissgrc/azure-pipelines-azurecli:2.47.0      | 1.4.5     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.5?style=flat-square)    |
| 1.4.6    | [Terraform 1.4.6](https://github.com/hashicorp/terraform/releases/tag/v1.4.6)   | swissgrc/azure-pipelines-azurecli:2.48.1      | 1.4.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.4.6?style=flat-square)    |
| 1.5.0    | [Terraform 1.5.0](https://github.com/hashicorp/terraform/releases/tag/v1.5.0)   | swissgrc/azure-pipelines-azurecli:2.49.0      | 1.5.0     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.0?style=flat-square)    |
| 1.5.2    | [Terraform 1.5.2](https://github.com/hashicorp/terraform/releases/tag/v1.5.2)   | swissgrc/azure-pipelines-azurecli:2.50.0-net6 | 1.5.2     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.2?style=flat-square)    |
| 1.5.3    | [Terraform 1.5.3](https://github.com/hashicorp/terraform/releases/tag/v1.5.3)   | swissgrc/azure-pipelines-azurecli:2.50.0-net6 | 1.5.3     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.3?style=flat-square)    |
| 1.5.4    | [Terraform 1.5.4](https://github.com/hashicorp/terraform/releases/tag/v1.5.4)   | swissgrc/azure-pipelines-azurecli:2.50.0-net6 | 1.5.4     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.4?style=flat-square)    |
| 1.5.5    | [Terraform 1.5.5](https://github.com/hashicorp/terraform/releases/tag/v1.5.5)   | swissgrc/azure-pipelines-azurecli:2.50.0-net6 | 1.5.5     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.5?style=flat-square)    |
| 1.5.6    | [Terraform 1.5.6](https://github.com/hashicorp/terraform/releases/tag/v1.5.6)   | swissgrc/azure-pipelines-azurecli:2.51.0-net6 | 1.5.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.6?style=flat-square)    |
| 1.5.7    | [Terraform 1.5.7](https://github.com/hashicorp/terraform/releases/tag/v1.5.7)   | swissgrc/azure-pipelines-azurecli:2.52.0-net6 | 1.5.7     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.5.7?style=flat-square)    |
| 1.6.0    | [Terraform 1.6.0](https://github.com/hashicorp/terraform/releases/tag/v1.6.0)   | swissgrc/azure-pipelines-azurecli:2.53.0-net6 | 1.6.0     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.0?style=flat-square)    |
| 1.6.1    | [Terraform 1.6.1](https://github.com/hashicorp/terraform/releases/tag/v1.6.1)   | swissgrc/azure-pipelines-azurecli:2.53.0-net6 | 1.6.1     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.1?style=flat-square)    |
| 1.6.2    | [Terraform 1.6.2](https://github.com/hashicorp/terraform/releases/tag/v1.6.2)   | swissgrc/azure-pipelines-azurecli:2.53.0-net6 | 1.6.2     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.2?style=flat-square)    |
| 1.6.3    | [Terraform 1.6.3](https://github.com/hashicorp/terraform/releases/tag/v1.6.3)   | swissgrc/azure-pipelines-azurecli:2.53.1-net6 | 1.6.3     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.3?style=flat-square)    |
| 1.6.4    | [Terraform 1.6.4](https://github.com/hashicorp/terraform/releases/tag/v1.6.4)   | swissgrc/azure-pipelines-azurecli:2.54.0-net6 | 1.6.4     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.4?style=flat-square)    |
| 1.6.5    | [Terraform 1.6.5](https://github.com/hashicorp/terraform/releases/tag/v1.6.5)   | swissgrc/azure-pipelines-azurecli:2.54.0-net6 | 1.6.5     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.5?style=flat-square)    |
| 1.6.6    | [Terraform 1.6.6](https://github.com/hashicorp/terraform/releases/tag/v1.6.6)   | swissgrc/azure-pipelines-azurecli:2.55.0-net8 | 1.6.6     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/1.6.6?style=flat-square)    |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
