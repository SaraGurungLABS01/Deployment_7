## Purpose


## Downloading and uploading the files to a new repository

1. **Clone the source repository:**
   - Clone the repository with `git clone https://github.com/kura-labs-org/c4_deployment-7.git`.

2. **Navigate to the cloned directory:**
   - Change to the repository directory with `cd c4_deployment-7`.

3. **Set up a new GitHub repository:**
   - Create a new GitHub repository with the desired settings.

4. **Point your local repository to the new GitHub repository:**
   - Update the remote URL with `git remote set-url origin https://github.com/SaraGurungLABS01/Deployment_7.git`.

5. **Push your local files to the new repository:**
   - Push your local files to the new repository using `git push -u origin main --force`.
  
## Docker and Docker file

A Docker image is a lightweight, standalone, and executable package that contains everything needed to run a piece of software, including the code, runtime, system tools, and libraries. Docker images are created from a set of instructions defined in a Dockerfile. They serve as the blueprint for containers.
For this deployment, a dockerfile is created to build the image of teh banking application. [View Dockerfile](https://github.com/SaraGurungLABS01/Deployment_7/blob/main/dockerfile)

## Terraform and Terraform files

Terraform is an open-source infrastructure as code (IaC) tool that allows you to define and provision infrastructure resources using declarative configuration files. It automates the deployment and management of cloud resources, making it easier to maintain and scale infrastructure in a consistent and repeatable manner.

Terraform was used to create a Jenkins manager and agents architecture within a default VPC.

**Instance 1 (Jenkins Manager) requires the following software:**
    - Jenkins
    - software-properties-common
    - add-apt-repository -y ppa:deadsnakes/ppa
    - python3.7
    - python3.7-venv
    - build-essential
    - libmysqlclient-dev
    - python3.7-dev

**Instance 2 (Jenkins Agent - Docker) requires the following software:**
    - Docker
    - default-jre
    - software-properties-common
    - add-apt-repository -y ppa:deadsnakes/ppa
    - python3.7
    - python3.7-venv
    - build-essential
    - libmysqlclient-dev
    - python3.7-dev
**Instance 2 (Jenkins Agent - Terraform) requires the following software:**
    - Terraform
    - default-jre

# Other terraform files that are used:

**VPC.tf**

VPC.tf is creating AWS resources for setting up a network infrastructure with following resources:
- 2 Availability Zones (AZs)
- 2 Public Subnets
- 2 Private Subnets
- 1 NAT Gateway
- 2 Route Tables
- Security Group Ports: 8000
- Security Group Ports: 80

**ALB.tf**

ALB.tf is creating and configuring resources for setting up an Application Load Balancer (ALB) and a Target Group

**Application Load Balancer (ALB)**

- Configured as an "application" ALB for routing HTTP and HTTPS traffic.
- Linked to the "http" security group for traffic control.
- Listens on port 80.
- Routes incoming requests to a Target Group.

**Target Group**
- Associated with the "url-lb" Application Load Balancer.
- Uses IP-based routing to forward requests to instances based on their IP addresses.
- Port 8000 is the application ingress route.
- Enables health checks, verifying the path "/health."

**ALB Listener**

- Sets up an ALB listener on port 80.
- Forwards incoming requests to the "url-app" Target Group.


**main.tf**


The main.tf is used to configure an Amazon ECS (Elastic Container Service) cluster for deploying containerized applications. It includes several components:

### ECS Cluster

- Creates an ECS cluster named "urlapp-cluster."
- Assigns tags for identification.

### CloudWatch Log Group

- Defines a CloudWatch log group named "/ecs/bank-logs."
- Tags the log group with the "Application" tag set to "bank-app."

### Task Definition

- Defines an ECS task definition named "bankapp_d7-task."
- Configures a container within the task definition, specifying:
  - Image source ("saragurunglabs01/bankapp:latest").
  - Logging settings for AWS CloudWatch Logs.
  - Port mapping to container port 8000.
- Specifies compatibility with "FARGATE."
- Sets the network mode to "awsvpc."
- Allocates memory (1024 MB) and CPU (512 units).
- Specifies execution and task roles.

### ECS Service

- Sets up an ECS service named "bankapp-ecs-service-d7."
- Associates it with the previously defined cluster, task definition, and other parameters.
- Launch type is "FARGATE."
- Scheduling strategy is "REPLICA."
- Desired count is 2 instances.
- Forces a new deployment.
- Defines network configuration for subnets and security groups.
- Configures a load balancer with a target group, container name, and port.

This Terraform configuration is used for managing ECS services in AWS, providing a foundation for containerized application deployment and management.


