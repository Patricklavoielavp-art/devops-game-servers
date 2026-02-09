## Developper setup (linting & pre-commit)
Install pre-commit and required tools:

- Install Pyton pre-commit
- Make shell script helper executable (on WSL/Git Bash/Linux/macOS)
- install git hooks for this repo 
- Run all hooks once to fix and validate existing files:
```bash
pip install pre-commit
chmod +x [lint.sh](http://_vscodecontentref_/1)   # on WSL/Git Bash/Linux/macOS
pre-commit install
pre-commit run --all-files



Notes : 
- On Windows , ensure pwsh (Powershell Core) is available in PATH for Powershell hooks.
- if you need to skip hooks for a commit , use git commit --no-verify