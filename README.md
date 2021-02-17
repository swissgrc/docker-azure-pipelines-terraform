# Docker image for running Terraform commands in Azure Pipelines container job
Docker image for running Terraform commands in an Azure Pipelines container job

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/blob/main/LICENSE) [![Build](https://img.shields.io/docker/cloud/build/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform/builds) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-terraform.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-terraform)

Docker image to run Terraform commands in [Azure Pipelines container jobs].

## Usage

This container can be used to run Terraform commands in [Azure Pipelines container jobs].

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job add the following task use it with the `container` property.

The following example shows the container used for a deployment step

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
```

### Tags

| Tag      | Description                                                                             | Size                                                                                                                          |
|----------|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)                                              | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)                                         | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-terraform/unstable?style=flat-square) |

### Configuration

These environment variables are supported:

| Environment variable | Default value | Description                 |
|----------------------|---------------|-----------------------------|
| AZURECLI_VERSION     | `2.9.1`       | Version of Azure CLI to use.|
| NODE_VERSION         | `15.8.0`      | Version of Node to use.     |
| YARN_VERSION         | `1.22.5`      | Version of Yarn to use.     |
| TERRAFORM_VERSION    | `0.14.6`      | Version of Terraform to use.|

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases