# Cohack Project

The **Cohack Project** deploys a set of Azure resources, including a Virtual Network, Managed Identity, Custom Role, and a Virtual Machine. This project uses Azure Developer CLI (AZD) for streamlined deployment and management.

---

## Features

- **Virtual Network**: Configurable address space and subnets.
- **Managed Identity**: Secure identity for automated role-based access.
- **Custom Role**: A tailored role for managing resource policies.
- **Virtual Machine**: A pre-configured Windows 11 virtual machine.

---

## Prerequisites

1. **Azure Account**:
   - Sign up for an Azure account at [Azure Free Account](https://azure.microsoft.com/free/).

2. **Tools**:
   - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - [Azure Developer CLI (AZD)](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
   - [Git](https://git-scm.com/downloads)

3. **Other Requirements**:
   - Bash shell (Linux/macOS or Git Bash/WSL for Windows).

---

## Setup Instructions

### Clone the Repository
git clone <repository-url>
cd <repository-name>

## Log in to Azure
az login

## Initialize the Project
azd init

## Provision Resources
azd provision

## Deploy the Recources
azd deploy

## Monitor Deployment
azd monitor

## Clean Up Resources (Optional)
azd down
