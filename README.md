# DevOpsify
This project aims at dockersing the microservices architecture, creating the required infra with help of terraform and deploying the application with help of kubernetes.


Diagram for vpc and subnet design architecture
                    VPC
              10.0.0.0/16
                    │
        ┌───────────┴───────────┐
        │                       │
   Public Subnets          Private Subnets
   10.0.1.0/24             10.0.3.0/24
   10.0.2.0/24             10.0.4.0/24
        │                       │
   Public IP possible       No public IP


Request path flow diagram

                    INTERNET
                       │
                       ▼
                 Internet Gateway
                  /            \
                 /              \
        Public Route Table
               │
        ┌──────┴──────┐
        ▼             ▼
   Public Subnet  Public Subnet
        │             │
      NAT GW        NAT GW
        │             │
        ▼             ▼
   Private RT      Private RT
        │             │
        ▼             ▼
 Private Subnet   Private Subnet

 IGW → public subnet internet access

NAT Gateway → private subnet outbound internet access, NAT Gateway is placed in a public subnet.

NAT Gateway itself needs a route to the internet through the Internet Gateway.


Private Subnet
     ↓
NAT Gateway
     ↓
Public Subnet
     ↓
Internet Gateway
     ↓
Internet
