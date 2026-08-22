# DevOpsify

This project aims to dockerize a microservices architecture, create the required infrastructure using **Terraform**, and deploy the application using **Kubernetes**.

## Architecture

### VPC and Subnet Design

The project uses a VPC with CIDR `10.0.0.0/16`, divided into public and private subnets.

```text
                         VPC: 10.0.0.0/16
                                │
                 ┌──────────────┴──────────────┐
                 │                             │
          Public Subnets                Private Subnets
          10.0.1.0/24                   10.0.3.0/24
          10.0.2.0/24                   10.0.4.0/24
                 │                             │
          Public IP possible              No public IP
```

### Internet and NAT Gateway Flow

```text
                         INTERNET
                            │
                            ▼
                  Internet Gateway (IGW)
                            │
                  ┌─────────┴─────────┐
                  │                   │
           Public Route Table          
                  │                   
          ┌───────┴───────┐           
          ▼               ▼           
     Public Subnet   Public Subnet    
          │               │           
       NAT GW           NAT GW        
          │               │           
          ▼               ▼           
   Private Route Table  Private Route Table
          │               │
          ▼               ▼
   Private Subnet     Private Subnet
```

### Network Flow

**IGW → Public Subnet**

The Internet Gateway provides internet connectivity to resources in public subnets.

**NAT Gateway → Private Subnet**

NAT Gateways allow resources in private subnets to make outbound internet connections without requiring public IP addresses.

NAT Gateways are placed inside **public subnets** because they themselves need a route to the Internet Gateway.

The private subnet traffic flow is:

```text
Private Subnet
      ↓
NAT Gateway
      ↓
Public Subnet
      ↓
Internet Gateway
      ↓
Internet
```
<img width="800" height="1300" alt="Flwchart Image Aug 22, 2026, 02_45_07 PM" src="https://github.com/user-attachments/assets/4e46dfa5-5a32-47c3-97c7-19b276fe213a" />




<img width="800" height="1000" alt="ChatGPT Image Aug 22, 2026, 03_09_37 PM" src="https://github.com/user-attachments/assets/041adce2-dbc7-42e9-982e-89f4e35f2ea6" />



## Request Path

The application request flow will be documented here as the Kubernetes and microservices architecture is implemented.

## Technologies

* Docker
* Terraform
* Kubernetes
* AWS
* Microservices
