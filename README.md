# Multiwoven Server

[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](https://github.com/Multiwoven/multiwoven-server/blob/main/LICENSE)
[![CI](https://github.com/Multiwoven/multiwoven-server/actions/workflows/ci.yml/badge.svg)](https://github.com/Multiwoven/multiwoven-server/actions/workflows/ci.yml)
[![Docker Build](https://github.com/Multiwoven/multiwoven-server/actions/workflows/docker-build.yml/badge.svg)](https://github.com/Multiwoven/multiwoven-server/actions/workflows/docker-build.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/5f5a5f94f8c86a1fb02b/maintainability)](https://codeclimate.com/repos/657bb07835753500df74ff6a/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5f5a5f94f8c86a1fb02b/test_coverage)](https://codeclimate.com/repos/657bb07835753500df74ff6a/test_coverage)


Welcome to the **Multiwoven Server**  repository! This backend component powers the Multiwoven app, providing a suite of APIs and encompassing the worker logic, business logic, and state management needed for the app's functionality.
## Technology Stack 
- **Backend** : Ruby on Rails 
- **Database** : PostgreSQL, Redis 
- **Containerization** : Docker 
- **CI/CD** : GitHub Actions
## Local Deployment
### System Requirements

Before you begin, make sure your system has Docker and Docker Compose installed. These tools are crucial for creating the development environment.

### Getting Started 

1. **Clone the Repository** :
Begin by cloning the Multiwoven Server repository to your local machine:

```bash
git clone git@github.com:Multiwoven/multiwoven-server.git
``` 
2. **Navigate to the Repository Directory** :

```bash
cd multiwoven-server/
```
### Environment Variables Setup 
1. **File** :
Under the `multiwoven-server/` directory, create a `.env` file:

On Unix/Linux systems, use:

```bash
touch .env
```

Add the following environment variables to the `.env` file:

```env
DB_HOST=your_postgres_host
DB_USERNAME=your_postgres_username
DB_PASSWORD=your_postgres_password
SMTP_ADDRESS=your_smtp_host_address
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password
```

These variables will be utilized by Docker Compose during service setup.
### Docker-Based Service Setup

The use of Docker streamlines the setup process: 
1. **Build Docker Images** :
For development, build the Docker images with:

```bash
docker-compose build
``` 
2. **Start Services** :
To run the development build, start all services with:

```bash
docker-compose up
```

This command leverages the `docker-compose.yml` configurations to initiate all required services.

## Standalone Service for Production

### Dockerfile for Production Deployment

By default, `docker-compose` uses `Dockerfile.dev` for development environments. However, for deploying `multiwoven-server` as a standalone service in a production setting, you should use the `Dockerfile`. This file is optimized for production and ensures better performance and security.

#### Steps for Deployment: 

1. **Dockerfile** :
The `Dockerfile` includes all the necessary instructions to build a Docker image suitable for production. It is tailored to provide an efficient and secure runtime environment. 
2. **Building the Image** :
Build your Docker image using the `Dockerfile` with the following command:

```bash
docker build -t multiwoven-server .
``` 
3. **Running the Image** :
Once the image is built, you can run it as a standalone service:

```bash
docker run -p 3000:3000 multiwoven-server
```

Adjust the port mappings and other runtime parameters as needed for your environment.

### Deploying on Containerized Platforms

This Docker image can be deployed on various containerized platforms of your choice, such as: 
- **Kubernetes** : Utilize a Kubernetes cluster to orchestrate and manage your Docker containers. This is ideal for scalable, distributed systems. 
- **Amazon ECS** : Leverage AWS Elastic Container Service (ECS) for a managed container orchestration service, simplifying deployment and scalability. 
- **Google Cloud Run** : Deploy on Google Cloud Run for a serverless approach, ideal for applications with variable traffic. 
- **Azure Container Instances** : Use Azure Container Instances for quick and easy container deployments in the Azure cloud environment.

When deploying, consider the platform's specific configurations, such as service definitions, load balancing, and auto-scaling to ensure optimal performance and reliability.

## License

Multiwoven Server © 2023 Multiwoven Inc. Released under the [GNU Affero General Public License v3.0](https://github.com/Multiwoven/multiwoven-server/blob/main/LICENSE).