# CI/CD Pipeline Documentation

## Overview
This repository includes a GitHub Actions CI/CD pipeline to automate the build, test, and deployment processes for the backend and frontend components of the application. The pipeline is triggered on pushes to the `master` branch or can be manually triggered using `workflow_dispatch`.

## Pipeline Structure
The pipeline consists of two main jobs:
1. **Build and Test**: Checks out the repository, sets up dependencies, runs tests, and verifies application functionality.
2. **Build and Push**: Builds and pushes Docker images to a container registry after successful tests.

## Workflow Execution Steps

### 1. **Triggering the Pipeline**
The pipeline runs automatically on:
- A push to the `master` branch.
- Manual execution via GitHub Actions `workflow_dispatch`.

### 2. **Build and Test Job**
Runs on `ubuntu-latest` and includes the following steps:
#### **Backend Setup and Testing**
- **Checkout repository**: Clones the repository.
- **Set up Python**: Configures Python 3.11.
- **Install dependencies**: Installs Python dependencies inside a virtual environment.
- **Verify pytest installation**: Ensures `pytest` is correctly installed.
- **Run Backend Tests**: Executes `pytest` with a failure threshold.

#### **Frontend Setup and Testing**
- **Install dependencies**: Runs `npm install` inside the frontend directory.
- **Run Frontend Tests**: Executes frontend unit tests using Jest.

### 3. **Build and Push Job**
Runs on `ubuntu-latest`, starts only if `build-and-test` is successful, and includes:

#### **Container Registry Setup**
- **Set registry variables**: Determines whether to use Azure Container Registry (ACR) or Docker Hub based on repository settings.
- **Login to the container registry**.

#### **Backend Deployment**
- **Build backend image**: Uses Docker to create a backend container image.
- **Test backend container**:
  - Runs the backend container.
  - Waits for the health check to return `healthy` (with a timeout mechanism).
  - Sends a request to `/docs` to validate the backend is working.
  - Stops and removes the test container.
- **Push backend image**: Uploads the built backend image to the registry.

#### **Frontend Deployment**
- **Build frontend image**: Uses Docker to create a frontend container image.
- **Test frontend container**:
  - Runs the frontend container.
  - Waits for the health check to return `healthy` (with a timeout mechanism).
  - Sends a request to `localhost:3000` to ensure the frontend is running.
  - Stops and removes the test container.
- **Push frontend image**: Uploads the built frontend image to the registry.

## Health Check Implementation
Both backend and frontend containers implement health checks to ensure readiness before running tests:

**Backend Health Check (Dockerfile):**
```dockerfile
HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8000/docs || exit 1
```

**Frontend Health Check (Dockerfile):**
```dockerfile
HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:3000 || exit 1
```

## Troubleshooting
- **Build failures**: Check the logs in the GitHub Actions panel for dependency issues.
- **Test failures**: Ensure that the backend and frontend tests run successfully locally before committing changes.
- **Deployment failures**:
  - Check if the container registry credentials are correctly configured.
  - Verify the health check logic and timeout settings.
  - Run `docker logs backend` or `docker logs frontend` to inspect container errors.

---
This pipeline ensures a smooth CI/CD workflow, automating build, testing, and deployment while enforcing application readiness through health checks.

