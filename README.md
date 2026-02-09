[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen.svg?logo=pre-commit&logoColor=white)](https://pre-commit.com)
[![CI](https://github.com/Patricklavoielavp-art/DEVOPS-GAME-SERVERS/actions/workflows/ci.yml/badge.svg)](https://github.com/Patricklavoielavp-art/DEVOPS-GAME-SERVERS/actions/workflows/ci.yml)
[![Terraform](https://github.com/Patricklavoielavp-art/DEVOPS-GAME-SERVERS/actions/workflows/terraform-plan.yml/badge.svg)](https://github.com/Patricklavoielavp-art/DEVOPS-GAME-SERVERS/actions/workflows/terraform-plan.yml)

Automated DevOps infrastructure for game servers across multiple platforms (Linux, Windows, Game Server Bootstrap) with CI/CD, security scanning, containerization, and semantic versioning.

## Project Structure
├── game-server-bootstrap/ # Game server installation and bootstrap
│ ├── scripts/ # Installation scripts (SteamCMD, monitoring, etc.)
│ ├── systemd/ # Systemd service files
│ ├── terraform/ # IaC for provisioning VMs
│ └── Dockerfile # Container image for game server
├── linux-bootstrap/ # Hardened Linux base image setup
│ ├── scripts/ # Security hardening scripts (firewall, SSH, etc.)
│ ├── config/ # Configuration templates
│ ├── templates/ # systemd, sshd configs
│ └── Dockerfile # Hardened base image
├── Windows-server-bootstrap/ # Windows server bootstrap
│ ├── scripts/ # PowerShell setup scripts
│ └── config/ # Windows security configs
├── .github/
│ ├── workflows/ # CI/CD automation
│ │ ├── ci.yml # Linting & validation
│ │ ├── terraform-plan.yml # Terraform planning
│ │ ├── docker-build.yml # Container builds
│ │ ├── security-scan.yml # Vulnerability scanning
│ │ ├── code-security.yml # SAST checks
│ │ └── release.yml # Semantic release
│ └── dependabot.yml # Dependency updates
├── docker-compose.yml # Local development environment
├── .releaserc.json # Semantic release config
├── CONTRIBUTING.md # Commit convention guide
├── SECURITY.md # Vulnerability reporting
└── CHANGELOG.md # Auto-generated release notes
**Section 3 : Quick Start**
## Quick Start
### Local Development Setup 
1. **Install dependancies**
 
    # Pre-commit (for linting hooks)
    pip install pre-commit

    #Docker & Docker Compose
    # https://docs.docker.com/get-docker/

    # Terraform ( for infrastructure)
    # https://www.terraform.io/downloads.html

2.**Clone and setup**
git clone https://github.com/Patricklavoielavp-art/DEVOPS-GAME-SERVERS.git
cd DEVOPS_GAME_SERVERS
pre-commit install
chmod +x scripts/lint.sh

3.**Run local linting**
# Shell scripts
./scripts/lint.sh
# PowerShell scripts (Windows)
pwsh ./scripts/lint.ps1

# Or run all pre-commit hooks
pre-commit run --all-files

4. **Start services locally with Docker Compose**
docker-compose up -d
docker-compose logs -f game-server
docker-compose down

5.**Plan infrastructure changes**
cd game-server-bootstrap/terraform
terraform init -backend=false
terraform plan

**Section 4: CI/CD Pipeline**

## CI/CD Pipeline

This repository uses GitHub Actions fo automated testing, building, and releasing.

### Workflows

|     Workflow       |      Trigger     |                           Purpose                         |
!--------------------|------------------|-----------------------------------------------------------|
| **CI**             |     Push / PR    | ShelCheck, PSScriptAnalyzer, Terraform validate           |
| **Terraform Plan** | Push `main`+  PR | Terraform plan & artifact upload                          |
| **Docker Build**   | Push `main`\ Tags| Build & push images to ghcr.io                            |
| **Security Scan**  |    Daily + PR    | Trivy(container), TruffleHog (secret). tfsec (IaC)        |
| **Code Security**  |    Push \ PR     | ShellCheck, tfsec, PSScriptAnalyzer security rules        |
| **Release**        | Puch `main`      | Semantic versioning, changelog, GitHub release, tag images|

**Section 5: Security**

## Security
## Scan & Checks

- **Trivy**: Container image vulnerability scanning
- **TruffleHof**: Detects leaked API keys, tokens, passwords
- **tfsec**: Terraform security misconfiguration audits
- **ShellCheck**: PowerShell code quality & security rules
- **PSScriptAnalyzer**: PowerShell code quality & security rules
- **Dependabot**: Automated dependency update detection

### Reporting Vulnerabilities

**Do not open Public GitHub issues for security vulnerabilities.**

Please email `security@ecample.com` with details. See [SECURITY.md](./SECURITY.md) for full guidelines.

### Best Practices

- Keep dependencies updated (Dependabot PRs)
- Run pre-commit hooks locally before pushing
- Review GitHub Security tab for scanning results
- Never commit secrets (use GitHub Secrets)
- Use HTTPS git URLs only

**Section 6 : Contributing**

## Contributing

1. **Fork** the repository
2. **Create a feature branch** : `git checkout -b feat/my-feature`
3. **Commit with conventional mesages**: `git commit -m feat: add feature` 
4. **Install pre-commit hooks locally**: `pre-commit install && pre-commit run --all-files`
5. **Push** and open a PR 
6. **CI checks must pass** before merge

See [CONTRIBUTING.md](./CONTRIBUTING.md) for commit message conventions and [SECURITY.md](./SECURITY.md) for vulnerability reporting.

**Section 7 : Versioning & Releases**

## Versioning & Releases 

This project follows [Semantic Versoning](https://semver.org) via [Semantic-release](https://semantic-release.gitbook.io).

- **Automatic versioning** on every `main`push
- **CHANGELOG.md** auto-generated from commits
- **Docker images tagged** with release version
- **GitHub releases** created with release notes

All Docker images are published to: `ghcr.io/Patricklavoielavp-art/DEVOPS-GAME-SERVERS/<image>:<version>`

View releases : [GitHub Releases](https://github.com/Patricklavoielavp-art\DEVOPS-GAME-SERVERS/releases)

**Section 8: Platform-Specific READMEs**

## Platform READMEs

- [Game Server BootStrap](./game-server-bootstrap/README.md)
- [Linux Bootstrap](./linux-bootstrap/README.md)
- [Windows Server Bootstrap](./Windows-server-bootstrap/README.md)

**Section 9: License & Support**

## License 

MIT License -- see LICENSE file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/Patricklavoielavp-art/DEVOPS-GAME-SERVERS/issues)
- **Security**: See [SECURITY.md](./SECURITY.md)
- **Contributing**: See [CONTRIBUTING.md](./CONTRIBUTING.md)