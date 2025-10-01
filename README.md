# My Docker Web App with Automated Deployment

A modern Node.js web application demonstrating DevOps best practices with automated testing, containerization, and CI/CD deployment to Azure using GitHub Actions.

##  What This Project Demonstrates

- ** Automated CI/CD Pipeline** - Tests and deploys on every code push
- ** Containerization** - Docker-based deployment
- ** Cloud Deployment** - Automated deployment to Azure Container Instances
- ** Automated Testing** - Unit tests run on every commit
- ** Health Monitoring** - Built-in health checks and metrics
- ** Infrastructure as Code** - Azure resources managed via scripts

##  Prerequisites

Before you begin, ensure you have:

- [Node.js](https://nodejs.org/) (version 18 or higher)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- [Git](https://git-scm.com/) for version control
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- GitHub account
- Azure account ([free tier](https://azure.microsoft.com/free/) works!)

## ☁️ Azure Deployment Setup

### 1. Prepare Azure Environment

```bash
# Make the setup script executable
chmod +x azure_setup.sh

# Run the Azure setup (creates resources and secrets)
./azure_setup.sh
```

This script will:
- Create Azure Resource Group
- Set up Azure Container Registry (ACR)
- Create a Service Principal for GitHub Actions
- Output the required GitHub secrets

### 2. Configure GitHub Secrets

After running the setup script, add these secrets to your GitHub repository:

**Repository Settings → Secrets and variables → Actions → New repository secret**

- `AZURE_CREDENTIALS` - JSON output from setup script
- `AZURE_RESOURCE_GROUP` - Your resource group name
- `ACR_NAME` - Your container registry name
- `ACR_USERNAME` - Container registry username
- `ACR_PASSWORD` - Container registry password

### 3. Deploy via GitHub Actions

```bash
# Commit and push to trigger deployment
git add .
git commit -m "Initial deployment"
git push origin main
```

The CI/CD pipeline will:
1.  Run automated tests
2.  Build Docker container
3.  Push to Azure Container Registry
4.  Deploy to Azure Container Instances
5.  Provide live application URL

##  CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/deploy.yml`) includes:

### Test Stage
- Install Node.js dependencies
- Run unit tests
- Build and test Docker image

### Deploy Stage (main branch only)
- Login to Azure
- Build and push Docker image to ACR
- Deploy container to Azure Container Instances
- Output live application URL

## 🛠️ Local Development

### Running with Docker

```bash
# Build the Docker image
docker build -t my-webapp .

# Run the container
docker run -p 3001:3001 my-webapp

# Access at http://localhost:3001
