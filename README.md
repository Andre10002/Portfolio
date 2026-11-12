# Portfolio Projects

Hands-on cyber security, cloud and database projects built during my BSc (Hons) in Digital Forensics and Cyber Security at TU Dublin, plus personal projects.

**Portfolio website:** https://andre10002.github.io/Portfolio-Projects/  
**LinkedIn:** https://www.linkedin.com/in/andrei-scarevnea-4b263628b/

Each project below has its own folder with a README explaining what I built, how it works and what I learned.

## About me

I'm a third-year student who likes to understand how a system is built, work out how it could be misused, and then stop that. My projects focus on building secure systems (locked-down cloud environments), detecting attacks (log analysis tooling) and designing reliable infrastructure.

I'm looking for an **IT or cyber security internship**.

## Projects

| Project | Area | What it demonstrates | Tools |
|---|---|---|---|
| [Secure Azure Web App Deployment](./Secure_Azure_Web_App_Deployment) | Cloud security | A hardened Azure environment: network segmentation, private endpoints, RBAC, encryption, monitoring and backups | Azure, Ubuntu, Nginx, UFW, fail2ban, AIDE, auditd, Bash |
| [Security Investigation Tool](./Security%20Investigation%20Tool) | Detection and response | A PowerShell tool that analyses raw logs and writes one investigation report | PowerShell, log analysis, IOCs |
| [WinLocal AWS Project](./WinLocal_AWS_Project) | Cloud architecture | Migration of an on-premises platform to a scalable, secure AWS design (proof of concept) | AWS VPC, EC2, Auto Scaling, ALB, RDS, S3 |
| [Machine Learning Cybersecurity](./Machine%20Learning%20Cybersecurity) | Machine learning | Machine learning applied to a security problem | Python |
| [Hospital Database SQL](./Hospital_Database_SQL) | Databases | ER modelling, 3NF design and SQL for a hospital system | MySQL |

## Skills shown across the projects

- **Cloud and infrastructure:** Azure (VMs, NSGs, RBAC, SQL Database, Blob Storage, private endpoints), AWS (VPC, EC2, Auto Scaling, ALB, RDS, S3, Route 53 design)
- **Linux security:** SSH hardening, PAM password policy, UFW, fail2ban, AIDE file integrity monitoring, auditd, logrotate, unattended-upgrades
- **Scripting and automation:** PowerShell, Bash, cron
- **Detection and analysis:** log parsing, IOC matching, brute-force and exfiltration detection
- **Data:** relational design, normalisation, SQL
- **Concepts:** least privilege, network segmentation, encryption in transit and at rest, defence in depth, incident response

## Repository structure

```
Portfolio-Projects/
├── README.md
├── index.html                        # Portfolio website (GitHub Pages)
├── Secure_Azure_Web_App_Deployment/
├── Security Investigation Tool/
├── WinLocal_AWS_Project/
├── Machine Learning Cybersecurity/
└── Hospital_Database_SQL/
```

## A note on the data

All companies, people, patients and logs in these projects are **fictional or simulated**. Reports were sanitised before publishing: IP addresses, account and subscription IDs, endpoints and personal identifiers were removed or masked, and some screenshots were replaced with placeholders.
