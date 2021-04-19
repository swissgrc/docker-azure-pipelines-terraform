# Docker image for running Terraform commands in Azure Pipelines container job

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/blob/main/LICENSE) [![Build](https://img.shields.io/docker/cloud/build/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform/builds) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform)

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

| Tag      | Description                                                                                                                                                                                              | Size                                                                                                                               |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                                                                                                                                                               | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                                                                                                                                                          | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/unstable?style=flat-square) |
| 0.14.6   | [Terraform 0.14.6](https://github.com/hashicorp/terraform/releases/tag/v0.14.6) & [Azure CLI 2.19.1](https://docs.microsoft.com/en-us/cli/azure/release-notes-azure-cli?tabs=azure-cli#february-10-2021) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/0.14.6?style=flat-square)   |

### Configuration

These environment variables are supported:

| Environment variable | Default value | Description                 |
|----------------------|---------------|-----------------------------|
| TERRAFORM_VERSION    | `0.14.6`      | Version of Terraform to use.|

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases