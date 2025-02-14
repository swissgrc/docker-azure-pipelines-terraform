# Docker image for running Terraform commands in Azure Pipelines container job

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-terraform/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/actions/workflows/publish.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=swissgrc_docker-azure-pipelines-terraform&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=swissgrc_docker-azure-pipelines-terraform) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform)
<!-- markdownlint-restore -->

Docker image to run Terraform commands in [Azure Pipelines container jobs].

## Usage

This image can be used to run Terraform commands in [Azure Pipelines container jobs].

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

## Included Software
- [swissgrc/azure-pipelines-azurecli:net9](https://github.com/swissgrc/docker-azure-pipelines-azurecli-net9) as base image
- Terraform
- TfLint

## Tags

| Tag      | Description                                               | Size                                                                                                                               |
|----------|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)           | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/unstable?style=flat-square) |
| x.y.z    | Image for a specific version of Terraform                 |                                                                                                                                    |

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
