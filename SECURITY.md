# Security Policy

## Reporting a Vulnerability

**Do not open public issue dor security velnerability**

If you discover a security vulnerability, please email `security@example.com` with:
- Decription of the vulnerability
- Steps to reproduce 
- Potential impact 
- Suggested fix (if available)

We will acknowledge receipt whin 48 hours and begin investigation immediately.

## Supported Versions

| Verion | Supported |
|--------|-----------|
| main   | Yes       |
| older  | No        |

## Security Best Practices

1. **Keep dependencies updated** -- Enable Dependabot norification in GitHub.
2. **Use pre-commit hooks** -- Run linters and security checks before commiting.
3. **Review security scans** -- Check GitHub Security tab for vulnerability.
4. **Never commit secrets** -- Use GitHub Secrets or Vault for credentials.
5. **Container scanning** -- Review Trivy scan results for base image vulnerability.

## Tools & Scans

- **TruffleHog**: Detect secrets (API keys, tokens) in code.
- **Trivy**: Scans Docker images for know CVEs.
- **tfsec**: Audits Terraform for security misconfigurations.
- **ShellCheck**: Find bugs and best-practice violations in shell scripts.
- **Debendabots**: Auto-detects vunerable dependencies.

## Response Procedure

1. Acknowledge
2. Investigate and validate
3. Develop and test a fix
4. Releae fix in a patch version (if critical)
5. Notify reporter of resolution
