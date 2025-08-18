# Dotfiles

This is a collection of useful functions, aliases, git config for an easy setup of a new machine.

## Install

My OS of choice is macOS.

At the moment, [macOS](#macos) is the only config available.

### macOS

1. Ensure your system is up to date:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

And finally

- Connect your mouse and keyboard
- Log-in into the AppStore

2. Clone this repo:

```bash
git clone https://github.com/gripep/dotfiles.git ~/.dotfiles
```

3. Create and update the dotfiles `.env` file:

```bash
# Copy the `.env.example` content to a `.env` file
# Then update the `.env` file with your information
cp ~/.dotfiles/system/.env.example ~/.dotfiles/system/.env
```

N.B.
You might have to log-in into your GitHub account to set the `GITHUB_TOKEN` env variable.

4. Run the installation script:

```bash
source ~/.dotfiles/install.sh
```

5. Update the Dock and System Settings:

Once installation is complete, the `dotfiles` CLI is available in your shell.  
Run `dotfiles --help` to see all available commands.

To get started, run:

```bash
dotfiles macos
dotfiles update # This will take a while
```

N.B.
Most of the configuration files will live under the `.config/` directory.

```bash
.config
├── ...
└── zsh
```

Everything development-related will live under the `Developer/` directory. Inside, there will be a Linux-style structure to keep things tidy, e.g. `bin/`, `opt/`, `src/`, `tmp/`, etc.

```bash
Developer
├── bin  # for exec files, etc.
├── opt  # for optional installations, e.g. go, etc.
├── src  # for projects
├── ...
└── tmp  # for any temp or throwaway stuff
```

# Thanks to...

- [jm96441n](https://github.com/jm96441n) and his [dotfiles repo](https://github.com/jm96441n/dotfiles)
- [driesvints](https://github.com/driesvints) and his [dotfiles repo](https://github.com/driesvints/dotfiles)
- The [dotfiles community](https://dotfiles.github.io/)
