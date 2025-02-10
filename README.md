# DevOps Engineer Take-Home Assignment: Enhancing Your Cloud Deployment Skills

This repository corresponds to Krystsian Shevando's application to Buddywise (position: Cloud Architect/DevOps Engineer, stage: CASE)

## Assignment Objectives

### 1. Preparing the Application for Deployment
- **Containerization:**
  - Dockerfiles for both backend and frontend components are provided.
  - A `docker-compose.yml` file is included to allow running the application locally.
  - Each component has a dedicated `README.md` with instructions on how to build and run the application using Docker Compose.

### 2. Automating the CI/CD Pipeline
- **Continuous Deployment:**
  - GitHub Actions workflow is configured to automate deployment to a container registry.
  - The pipeline runs when changes are merged into the `master` branch.
  - The CI/CD setup ensures that the application is built, tested, and pushed automatically.

### 3. Designing for Production in the Cloud
- **Production System Architecture:**
  - The repository includes a proposed cloud-based production architecture focusing on scalability and security.
  - Network configurations, including Virtual Networks (VNets), subnets, and security rules for traffic management, are documented.
  - This is located in the `3_architecture` directory.

### 4. Demonstrating Kubernetes or Terraform Expertise
- **Terraform Infrastructure:**
  - Terraform scripts for provisioning cloud infrastructure are included.
  - Instructions for deploying and managing the infrastructure are provided.
  - Terraform setup ensures security and scalability.

## Repository Structure

| Folder            | Description |
|------------------|-------------|
| `1_docker`       | Contains the Dockerfiles for backend and frontend, along with the `docker-compose.yml` for local deployment. It includes a dedicated `README.md` with setup instructions. |
| `2_cicd`         | Houses the GitHub Actions workflows and other CI/CD configuration files. No separate `README.md` is provided. |
| `3_architecture` | Contains the system architecture diagrams and documentation for production deployment. No separate `README.md` is provided. |
| `4_terraform`    | Contains Terraform scripts for provisioning cloud infrastructure. A `README.md` explains how to apply and destroy Terraform configurations. |
| `README.md`      | The main documentation file (this file), providing an overview of the repository and instructions for each section. |
| `task.txt`       | Contains the original task description for reference. |

## Instructions for Running the Application
Each component has its own `README.md` with specific instructions, except 3_architecture

---