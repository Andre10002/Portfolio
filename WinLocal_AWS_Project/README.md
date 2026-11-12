# WinLocal Giveaways: AWS Migration (Proof of Concept)

Migration of a fictional on-premises competition platform to AWS, designed for **availability, scalability and security**, and evaluated against the AWS Well-Architected sustainability pillar.

![Target architecture](./architecture-diagram.png)

*Target architecture across two Availability Zones. Components marked "Additional - Not in PoC" are designed but not built.*

## The problem

The client's on-premises hosting had three recurring problems:

| Problem | How the design addresses it |
|---|---|
| A previous ransomware attack | Private subnets, a bastion host as the only admin entry point, and security groups that allow only the traffic each layer needs |
| Load balancer failures made the site completely unreachable | S3 static failover page, with Route 53 health-check DNS failover designed for production |
| The database server kept running out of storage, causing downtime and loss of entry data | Managed Amazon RDS, with Multi-AZ designed for automatic failover |

## What I built (proof of concept)

| Component | Configuration | Purpose |
|---|---|---|
| **VPC** | `10.0.0.0/16`, public `10.0.1.0/24` and private `10.0.3.0/24` in `us-east-1a` | Isolated network with room to grow |
| **Internet and NAT gateways** | Public subnet routes through the internet gateway; NAT gives private instances outbound-only access | Patching without exposing servers |
| **Bastion host** | EC2 in the public subnet, SSH allowed from a single admin IP | Controlled entry point to private servers |
| **Custom AMI** | Built from the configured web server | Identical, fast-launching instances |
| **Auto Scaling group** | Min 1, max 2, target tracking at 60% average CPU | Scale on demand, avoid idle capacity |
| **Application Load Balancer** | HTTP listener on port 80, target group of the ASG instances | Spreads traffic and removes unhealthy targets |
| **Amazon RDS (MySQL)** | Single-AZ, private subnet, public access disabled | Managed database storage |
| **Security groups** | ALB, web server, bastion and RDS groups chained together | Least-privilege traffic between layers |
| **S3 static website** | "Service temporarily unavailable" page | Failover page without standby servers |

### Security group chain

```
Internet ──HTTP──▶ ALB SG ──HTTP──▶ Web server SG ──3306──▶ RDS SG
                                         ▲
Admin IP ──SSH──▶ Bastion SG ──SSH───────┘
```

- RDS accepts MySQL (3306) **only** from the web server security group.
- Web servers accept HTTP **only** from the load balancer and SSH **only** from the bastion.
- The bastion accepts SSH **only** from the administrator's IP.

## How I tested it

| Test | Result |
|---|---|
| SSH from admin machine, through the bastion, to a private web server | Connected |
| Database test script run from the web server against RDS | "Connected successfully" |
| Browsing the load balancer DNS name repeatedly | Responses alternated between Web Server 1 and Web Server 2 |
| Changing ASG capacity and terminating instances | Activity history showed scale-out, scale-in and replacement of unhealthy instances |
| Opening the S3 website endpoint | Failover page served publicly |

## Beyond the proof of concept (designed, not built)

1. **Route 53 health checks with DNS failover.** Monitors the load balancer; if it fails repeatedly, traffic moves to the S3 failover page automatically.
2. **Multi-AZ RDS.** Enabling Multi-AZ creates a synchronous standby in `us-east-1b` and fails over in about 60 seconds. The DB subnet group already covers both private subnets, so no network changes are needed.

## Sustainability

- Auto Scaling runs one instance normally and adds a second only under load.
- The S3 failover page avoids always-on standby servers.
- Proposed next steps: CloudWatch utilisation monitoring to right-size or remove idle resources, and multi-AZ deployment for resilience.

## Limitations

- The proof of concept runs in a single AZ, so an AZ outage would still cause downtime until the additional services are added.
- HTTP only; production would add HTTPS with a certificate on the load balancer.
- The scaling range (1 to 2) is deliberately small for a lab.

## Files

| File | Description |
|---|---|
| `WinLocal_AWS_PoC_Public.pdf` | Full report: design, implementation evidence, additional services, sustainability (sanitised) |
| `architecture-diagram.png` | Target architecture diagram |

> The public report omits screenshots that contained IP addresses, account IDs, endpoints and resource identifiers.

## Skills demonstrated

AWS networking, high availability, security group design, bastion access, AMI-based standardisation, load balancing and auto scaling, and cost and sustainability trade-offs.
