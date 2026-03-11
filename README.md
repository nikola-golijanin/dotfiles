# Ubuntu Dev Environment — Complete Summary

## What We Set Up

### 1. System Baseline (`apt`)
Installed foundational utilities that all other installers depend on: `curl`, `wget`, `gpg` (package signature verification), `build-essential` (C compiler — needed by native dependencies), `lsb-release` (distro version detection used by .NET and Docker install scripts), and others.

### 2. Git (`apt` → `/usr/bin/git`)
Installed via apt. Configured `~/.gitconfig` with all aliases from your Windows setup. Key Linux change: `core.autocrlf = input` instead of `true` — strips CRLFs on commit, keeps LF on checkout. Set `core.editor = vim` for commit message editing.

### 3. .NET SDK (Microsoft repo → `apt` → `/usr/share/dotnet/`)
Added Microsoft's GPG key and package repository to apt. SDK installs and updates through `apt upgrade` like any system package. Multiple SDK versions coexist — `global.json` per repo picks the version. NuGet cache lives at `~/.nuget/`.

### 4. Docker Engine (Docker repo → `apt` → `/usr/bin/docker`)
Added Docker's official GPG key and repo (not Ubuntu's outdated `docker.io`). Added user to `docker` group so `docker` commands don't need `sudo`. The `docker` group grants access to `/var/run/docker.sock`. Requires full logout/login after group change.

### 5. VS Code (`.deb` from website or Microsoft repo → `/usr/bin/code`)
Downloaded `.deb` from code.visualstudio.com (auto-adds the Microsoft repo for future updates via apt). Settings and keybindings adjusted for Linux: terminal profile changed from PowerShell to bash, Windows-specific terminal profiles removed. Config lives at `~/.config/Code/User/`.

### 6. JetBrains Rider (Toolbox → `~/.local/share/JetBrains/`)
Installed via JetBrains Toolbox, which self-updates and manages Rider. Adds `rider` symlink to `~/.local/bin/` (already on PATH). Updates are automatic — Toolbox handles everything.

### 7. SSH Key (for GitHub)
Generated an `ed25519` key pair at `~/.ssh/`. Public key added to GitHub. All git remotes use SSH URLs (`git@github.com:...`) instead of HTTPS — GitHub no longer supports password auth for git operations.

### 8. Dotfiles (`~/dotfiles/` → GitHub)
Created a git repo at `~/dotfiles/` containing:
- `gitconfig` → symlinked to `~/.gitconfig`
- `bashrc` → symlinked to `~/.bashrc`
- `vscode/settings.json` → copied to `~/.config/Code/User/settings.json`
- `vscode/keybindings.json` → copied to `~/.config/Code/User/keybindings.json`
- `install.sh` → restore script for new machines

VS Code files use copy instead of symlink because VS Code's atomic write behavior breaks symlinks.

### 9. Project Structure
```
~/
├── projects/
│   ├── company/       # work repos
│   └── personal/      # side projects
├── dotfiles/          # version-controlled configs (pushed to GitHub)
└── .ssh/              # SSH keys (never committed anywhere)
```

---

## How To Manage & Update Everything

### Weekly/biweekly — one command updates almost everything
```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```
This covers: git, .NET SDK, Docker, VS Code, vim, and all system packages.

### Rider — automatic
JetBrains Toolbox handles updates in the background. No action needed.

### New .NET SDK major version
```bash
sudo apt install dotnet-sdk-10.0    # when .NET 10 releases
dotnet --list-sdks                  # verify both versions coexist
```

### VS Code extensions
Auto-update by default, or manually: `code --update-extensions`

### Dotfiles — after any config change
```bash
cd ~/dotfiles
git aa && git cm "description of change" && git p
```

For VS Code settings specifically (copy, not symlink):
```bash
cp ~/.config/Code/User/settings.json ~/dotfiles/vscode/
cp ~/.config/Code/User/keybindings.json ~/dotfiles/vscode/
cd ~/dotfiles && git aa && git cm "sync vscode settings" && git p
```

Or use the `sync-vscode` bash alias if you added it to your bashrc.

### New machine setup
```bash
# 1. Run Phase 1 baseline + install git
# 2. Generate SSH key, add to GitHub
# 3. Clone dotfiles
git clone git@github.com:nikola-golijanin/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
# 4. Install .NET SDK, Docker, VS Code, Rider (phases 3-6)
# 5. Copy VS Code settings
cp ~/dotfiles/vscode/settings.json ~/.config/Code/User/
cp ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/
```

### Check what you have installed
```bash
git --version
dotnet --list-sdks
docker --version
code --version
```

### Check what external repos you've added
```bash
ls /etc/apt/sources.list.d/
```

---

## Key Concepts Learned

### Filesystem
- `~` = `/home/nikola/` = `$HOME` — your home directory
- Files starting with `.` are hidden — `ls -a` to see them (dotfiles)
- `/usr/bin/` — system binaries managed by apt
- `~/.local/bin/` — user-scoped binaries (Toolbox symlinks)
- `~/.config/` — app settings (Linux equivalent of `%APPDATA%`)
- `/etc/apt/sources.list.d/` — external package repo definitions

### Package Management
- `apt` = Ubuntu's package manager. Handles install, update, remove.
- External repos (Microsoft, Docker) add GPG keys for verification + `.list` files so apt knows where to fetch from.
- Snap = sandboxed packages. Fine for consumer apps, problematic for dev tools that need filesystem/toolchain access.

### Permissions & Groups
- `sudo` = run as root. Needed for system dirs, never for `~/`.
- `usermod -aG docker $USER` = add user to group. Requires logout/login.
- `chmod` changes file permissions, `chown` changes ownership.
- `ls -la` shows permissions: `rwx` = read/write/execute for owner/group/others.

### SSH Authentication
- Key pair: private key (`~/.ssh/id_ed25519`) stays on machine, public key (`.pub`) goes to GitHub.
- Git uses SSH to authenticate — no passwords or tokens needed.
- Always use `git@github.com:` URLs, not `https://github.com/`.

### Symlinks
- `ln -sf target link` = create symbolic link (like a Windows shortcut for files).
- Works great for gitconfig, bashrc. Doesn't work reliably for VS Code settings (atomic writes).

### Shell
- `~/.bashrc` runs every time you open a terminal — aliases, PATH, env vars go here.
- `source ~/.bashrc` reloads without opening new terminal.
- `export PATH="$HOME/something:$PATH"` adds to PATH.

---

## Where Everything Lives — Quick Reference

| Thing | Location | Managed by |
|---|---|---|
| Git binary | `/usr/bin/git` | apt |
| Git config | `~/.gitconfig` → `~/dotfiles/gitconfig` | you (dotfiles repo) |
| .NET SDK | `/usr/share/dotnet/` | apt |
| NuGet cache | `~/.nuget/` | dotnet restore |
| Docker binary | `/usr/bin/docker` | apt |
| Docker socket | `/var/run/docker.sock` | docker group |
| VS Code binary | `/usr/bin/code` | apt |
| VS Code settings | `~/.config/Code/User/` | you (copy from dotfiles) |
| VS Code extensions | `~/.vscode/extensions/` | VS Code |
| Rider + Toolbox | `~/.local/share/JetBrains/` | Toolbox (auto) |
| Rider CLI symlink | `~/.local/bin/rider` | Toolbox |
| SSH keys | `~/.ssh/` | you (never commit) |
| Bash config | `~/.bashrc` → `~/dotfiles/bashrc` | you (dotfiles repo) |
| External apt repos | `/etc/apt/sources.list.d/` | you (added during setup) |
| Your projects | `~/projects/` | you |
| Your dotfiles | `~/dotfiles/` | you (GitHub repo) |
