# Environment Setup

Opinionated dotfiles and shell helpers for faster workstation setup.

Includes:
- `aliases` — useful shell aliases and helper scripts
- `git` — Git config snippets and a commit-msg hook for Conventional Commits
- `zsh` — Zsh config, Powerlevel10k theme config, and related files

Supported targets
- Ubuntu / Debian based Linux
- WSL on Windows (commands assume a Linux environment)

Prerequisites
- A POSIX shell (bash, sh) available
- `git` installed

Quick install

```bash
# Clone the repo
git clone --depth=1 https://github.com/R0XL91/environment-setup.git && cd environment-setup

# Run the main installer (inspects and links configs)
./install.sh

# (Optional) Make zsh your default shell
chsh -s "$(which zsh)"

# Restart your session or open a new terminal to apply changes
```

Notes
- On Windows use WSL to run the installer and get a full Linux-like experience.
- `install.sh` is idempotent; review it before running if you want custom behavior.

Git config and hooks
- `git/.gitconfig` — example Git settings you can merge into your global config.
- `git/.gitattributes` — helpful repo-level attributes.
- `git/.hooks/commit-msg` — Conventional Commits validation hook (make executable with `chmod +x`).

Using aliases and zsh
- The `aliases` folder contains small scripts and an `install.sh` to add them to your shell.
- The `zsh` folder contains `zshrc` and `custom-p10k.zsh` to configure `oh-my-zsh` + Powerlevel10k.

Troubleshooting
- If prompts or icons look wrong, ensure Powerlevel10k fonts are installed and your terminal supports UTF-8.
- If a hook isn't running, verify `.git/hooks/` contains the executable script (Git may not copy them automatically).

Contributing
- Feel free to open issues or PRs to improve docs, add platforms, or refine install behavior.

License
- See repository for license and author information.
