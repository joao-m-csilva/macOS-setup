<p align="center">  
    <img src="assets/cat_apple.gif" width="800px" height="400px" alt="Apple cat meme" />
</p>

# macOS Setup

A script created to automate the setup of a new macOS machine for software development.

## Status

Functional and capable of performing the basic macOS development environment setup.

### Planned Improvements

- Additional languages (PT-BR, ES)
- Automatic synchronization of terminal configuration files (`aliases.sh` and `exports.sh`) when changes are detected in the repository

---

## Project Structure

```text
macOS-setup
├── Brewfile
├── LICENSE
├── README.md
├── assets
│   └── cat_apple.gif
├── install.sh
├── lang
│   ├── en-US.sh
│   └── pt-BR.sh
├── scripts
│   ├── cleanup.sh
│   ├── setup-aws.sh
│   ├── setup-dotnet.sh
│   ├── setup-git.sh
│   ├── setup-homebrew.sh
│   ├── setup-java.sh
│   ├── setup-node.sh
│   ├── setup-ssh.sh
│   ├── setup-terminal.sh
│   └── update.sh
├── templates
│   ├── aws
│   │   ├── config.example
│   │   └── credentials.example
│   └── git
└── terminal
    ├── aliases.sh
    └── exports.sh
```

---

## Usage

### 1. Create a directory to store your projects

```bash
mkdir ~/Projects
cd ~/Projects
```

### 2. Clone the repository

```bash
git clone git@github.com:joao-m-csilva/macOS-setup.git
```

### 3. Enter the project directory

```bash
cd macOS-setup
```

### 4. Run the installer

```bash
./install.sh
```

---

## SSH Key Generation

If you prefer, you can generate an SSH key manually after completing the basic setup.

Run the SSH setup script:

```bash
./scripts/setup-ssh.sh your-email@example.com
```

The script will:

- Check whether an ED25519 SSH key already exists. If it does, the public key will be copied to the clipboard.
- Generate a new ED25519 SSH key if none exists.
- Configure the SSH agent.
- Add the SSH key to the macOS Keychain.
- Copy the public key to the clipboard.

After running the script:

1. Open your GitHub SSH Keys settings.
2. Create a new SSH key.
3. Paste the copied public key.

To verify the connection:

```bash
ssh -T git@github.com
```

## AWS CLI setup

After completing the setup:

Verify the AWS CLI installation:

```bash
aws --version
```

Configure your AWS credentials:

```bash
aws configure
```
