## Purpose

The purpose of this deployment is to establish a cloud-based infrastructure for a banking application. It involves using Jenkins for automation, Terraform for resource management, Amazon RDS for secure data storage, and Docker for creating and hosting the application image. This deployment streamlines application operations, ensuring efficiency, security, and data continuity.

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

### VPC.tf

VPC.tf is creating AWS resources for setting up a network infrastructure with following resources:
- 2 Availability Zones (AZs)
- 2 Public Subnets
- 2 Private Subnets
- 1 NAT Gateway
- 2 Route Tables
- Security Group Ports: 8000
- Security Group Ports: 80

### ALB.tf

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


### main.tf


The main.tf is used to configure an Amazon ECS (Elastic Container Service) cluster for deploying containerized applications. This Terraform configuration is used for managing ECS services in AWS, providing a foundation for containerized application deployment and management. It includes several components:

**ECS Cluster**

- Creates an ECS cluster named "urlapp-cluster."
- Assigns tags for identification.

**CloudWatch Log Group**

- Defines a CloudWatch log group named "/ecs/bank-logs."
- Tags the log group with the "Application" tag set to "bank-app."

**Task Definition**

- Defines an ECS task definition named "bankapp_d7-task."
- Configures a container within the task definition, specifying:
  - Image source ("saragurunglabs01/bankapp:latest").
  - Logging settings for AWS CloudWatch Logs.
  - Port mapping to container port 8000.
- Specifies compatibility with "FARGATE."
- Sets the network mode to "awsvpc."
- Allocates memory (1024 MB) and CPU (512 units).
- Specifies execution and task roles.

**ECS Service**

- Sets up an ECS service named "bankapp-ecs-service-d7."
- Associates it with the previously defined cluster, task definition, and other parameters.
- Launch type is "FARGATE."
- Scheduling strategy is "REPLICA."
- Desired count is 2 instances.
- Forces a new deployment.
- Defines network configuration for subnets and security groups.
- Configures a load balancer with a target group, container name, and port.


## AWS RDS Database

For a detailed setup guide, please follow the step-by-step instructions provided in the link below:

[How to Create an AWS RDS Database](https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw)

Amazon Relational Database Service (Amazon RDS) is a fully managed web service offered by AWS, simplifying the setup, operation, and scaling of relational databases in the cloud. It plays a crucial role in applications, ensuring the seamless continuity of user data across various tasks. This involves comprehensive integration of the database within the application, covering critical elements such as username, password, and endpoint, to facilitate consistent and reliable interaction with the database in the AWS Cloud environment.

## Jenkins Manager and Agent

Jenkins is an open-source automation server used for continuous integration (CI) and continuous delivery (CD) of software applications. It provides a framework to automate the building, testing, and deployment of software, enabling teams to integrate and deliver code more rapidly and efficiently.

Jenkins agents streamline CI/CD with parallel execution, resource isolation, and cross-platform support. They scale effortlessly, adapt to diverse project needs, and speed up testing. This efficiency reduces infrastructure costs and enhances reliability. Agents also support collaborative work and bolster security by controlling access and permissions.

### Jenkin Agent Nodes 

**awsdeploy2 - Docker Node**
Handles activities like testing the application, building the Docker image, and uploading it to Docker Hub.

**awsdeploy - Terraform Node**
Creates the entire application infrastructure.

[Step-by-Step Guide - Creating an Agent in Jenkins](https://scribehow.com/shared/Step-by-step_Guide_Creating_an_Agent_in_Jenkins__xeyUT01pSAiWXC3qN42q5w)

### Jenkin Credentials

To ensure Terraform's access to AWS, it necessitates both AWS access and secret keys. Given that the terraform files reside on GitHub, where public access should be restricted for security reasons, AWS credentials are created within Jenkins. Configuring AWS credentials within Jenkins is crucial as it fosters the integration of AWS services into your automation workflows, ensuring secure access to resources. Likewise, Docker Hub credentials, encompassing a username and password, are also established. These credentials are essential for secure interactions with Docker Hub, enabling your applications to be efficiently built, tested, and pushed to the container registry. 

**AWS**

To securely configure AWS credentials in Jenkins for the automation purpose, please refer to the following link for step-by-step instructions: [How to Configure AWS credentials in  Jenkins](https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw)https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw

**Docker Hub**

Follow the steps above, just make sure to select username and password for kind and add your dockerhub credentials

## Creating a multibranch pipeline and running the Jenkinsfile

Created a multi branch pipeline to run the Jenkinsfile and deploy the Retail Banking application 

Result: Successful

<img width="1331" alt="Screen Shot 2023-11-06 at 8 07 59 PM" src="https://github.com/SaraGurungLABS01/Deployment_7/assets/140760966/a719b141-5cb0-4e4f-a6d4-67470c4acf64">
<img width="1595" alt="Screen Shot 2023-11-06 at 8 08 42 PM" src="https://github.com/SaraGurungLABS01/Deployment_7/assets/140760966/9d57fe42-04da-427d-9989-b676ae41f727">

## Understanding the stages

**Docker_node:**
1. **Test Stage:** Application testing on an EC2 instance with error identification and resolution.
2. **Build Stage:** Creation of a Docker image using the Dockerfile, ensuring a consistent package for the application.
3. **Login to Docker Hub:** Securely logging into Docker Hub for interactions with Jenkins-installed credentials.
4. **Push to Docker Hub:** Successful image upload to the Docker Hub repository, enabling distribution and deployment.

**Terraform_node:**
1. **Initialize:** Setting the groundwork for Terraform to manage infrastructure.
2. **Plan:** Analyzing and determining resources required for infrastructure provisioning, identifying those to be created or destroyed.
3. **Apply:** Executing provisioning tasks based on the plan, creating the application infrastructure with a detailed summary of successfully created resources.

## Issues

1) Initially did not pass the build stage. 
<img width="1393" alt="Screen Shot 2023-11-06 at 9 17 47 PM" src="https://github.com/SaraGurungLABS01/Deployment_7/assets/140760966/aa9da29a-ec13-43ee-8d7c-4eae021334d8">

It indicates a permission issue while trying to interact with the Docker daemon

Trouble Shooting : Add user to the Docker group: ```bash sudo usermod -aG docker ubuntu``` followed by ```bash newgrp docker ```

## Optimization 

1. **Geographical Redundancy:** Implement Multi-Availability Zone (Multi-AZ) deployments to ensure high availability and disaster recovery. Distribute resources across different AWS regions to maintain service continuity in the event of a region-wide outage. Utilize Amazon Route 53 for intelligent global traffic routing, directing users to the nearest healthy instance for reduced latency.

2. **Auto Scaling:** Set up auto scaling policies for AWS resources, especially the application servers and database instances. This ensures that resources can automatically scale up or down based on workload demands, optimizing performance during peak usage and reducing costs during low traffic periods. Properly configured auto scaling minimizes over-provisioning and underutilization of resources, resulting in cost savings and improved application responsiveness.

## Conclusion

**Is your infrastructure secure? if yes or no, why?**

It is secure as the main infrastructure resides in the private subnet.

**What happens when you terminate 1 instance? Is this infrastructure fault-tolerant?**
Yes, this infrastructure is fault tolerant. The architecture automatically maintains service continuity by leveraging Terraform's configuration settings, setting 'desired_count' to 2, enabling 'force_new_deployment,' and utilizing the 'scheduling_strategy' as 'REPLICA,' ensuring the creation of another container instance upon termination.

**Which subnet were the containers deployed in?**

Containers were deployed in private subnets

## System Diagram

<img width="1261" alt="Screen Shot 2023-11-06 at 10 56 01 PM" src="https://github.com/SaraGurungLABS01/Deployment_7/assets/140760966/881274dd-7ebd-4d3c-9b80-83acfc9c569e">


