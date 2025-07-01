# Dotfiles

This is a collection of useful functions, aliases, git config for an easy setup of a new machine.

## Usage

My OS of choice is macOS. At the moment, macOS is the only config available.

### macOS

1. Ensure your system is up to date:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

And finally, log-in into the AppStore.

2. Install the dotfiles by cloning this repo:

```bash
git clone https://github.com/gripep/dotfiles.git ~/.dotfiles
```

3. Update the dotfiles environment:

```bash
# Copy the `.env.example` content to a `.env` file
# Then update the `.env` file with your information
cp ~/.dotfiles/sys/.env.example ~/.dotfiles/sys/.env
```

4. Run the installation script:

```bash
source ~/.dotfiles/install.sh
```

5. Update the Dock and System Settings:

```bash
source ~/.dotfiles/macos/dock.sh
source ~/.dotfiles/macos/defaults.sh
```

N.B.

The configuration files will live under the `.config/` directory.

```bash
.config
├── ...
└── zsh
```

All development-related files will live under the `Developer/` directory. Inside, there will be a Linux-style structure to keep things tidy, e.g. `opt/`, `src/`, `tmp/`, etc.

```bash
Developer
├── opt  # for optional installations, e.g. go, etc.
├── src  # for projects
├── ...
└── tmp  # for any temp or throwaway stuff
```

# Thanks to...

- The [dotfiles community](https://dotfiles.github.io/)
- [jm96441n](https://github.com/jm96441n) and his [dotfiles repo](https://github.com/jm96441n/dotfiles)
- [driesvints](https://github.com/driesvints) and his [dotfiles repo](https://github.com/driesvints/dotfiles)
