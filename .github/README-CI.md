Add TFC_TOKEN secret (if using Terraform Cloud)
Create and protect production environment (if using self-hosted apply)
How to register a self-hosted runner with VirtualBox installed (link to GitHub docs)
Security & secrets

Never commit real credentials. Use GitHub Secrets for:
TFC_TOKEN (Terraform Cloud)
Cloud provider creds if you switch to AWS/GCP/Azure
Use GitHub Environments to require manual approvals for apply jobs.