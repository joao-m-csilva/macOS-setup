<a id="en-us"></a>

# macOS Setup

Language: **English (en-US)** | [Português (pt-BR)](#pt-br)

## 1. Overview

`macOS-setup` is a shell-based provisioning tool that automates the configuration of a macOS machine for software development. It installs command-line utilities, GUI applications, fonts, language version managers, shell plugins, and configuration templates for Zsh, Vim, Git, SSH, and AWS CLI.

## 2. Tech Stack and Architecture

- **Runtime:** Bash (`#!/usr/bin/env bash`) and Zsh (target user shell)
- **Package Management:** Homebrew (`Brewfile`), NVM (Node.js), SDKMAN! (Java)
- **Prompt and Shell:** Oh My Zsh, Oh My Posh (`tokyonight_storm`), `fzf`, `zoxide`
- **Testing:** Native Bash unit test runner (`tests/run_tests.sh`) with isolated temporary `HOME` environments

### Directory Structure

```text
macOS-setup
├── Brewfile                        # Declarative Homebrew formulas, casks, and fonts
├── LICENSE                         # MIT License
├── README.md                       # Bilingual technical documentation (en-US / pt-BR)
├── assets
│   └── cat_apple.gif               # Repository banner asset
├── install.sh                      # Interactive entrypoint and orchestrator
├── lang
│   ├── en-US.sh                    # English CLI strings
│   └── pt-BR.sh                    # Brazilian Portuguese CLI strings
├── scripts
│   ├── cleanup.sh                  # Removes unused Homebrew dependencies and cache
│   ├── setup-aws.sh                # Installs AWS CLI and initializes ~/.aws templates
│   ├── setup-dotnet.sh             # Installs .NET SDK and JetBrains Rider
│   ├── setup-git.sh                # Configures ~/.gitconfig and ~/.gitignore_global
│   ├── setup-homebrew.sh           # Installs Homebrew and executes Brewfile bundle
│   ├── setup-java.sh               # Installs Zulu JDK 8 + IntelliJ IDEA or SDKMAN!
│   ├── setup-node.sh               # Installs NVM, latest Node.js LTS, and global npm
│   ├── setup-ssh.sh                # Generates ED25519 SSH key and configures macOS Keychain
│   ├── setup-terminal.sh           # Installs Oh My Zsh, plugins, and symlinks dotfiles
│   └── update.sh                   # Updates and upgrades Homebrew packages
├── templates
│   ├── aws
│   │   ├── config.example          # AWS CLI default profile configuration template
│   │   └── credentials.example     # AWS CLI credentials placeholder template
│   └── git
│       ├── .gitconfig              # Global Git configuration template
│       └── .gitignore_global       # Global Git ignore rules
├── terminal
│   ├── .vimrc                      # Vim configuration with macOS clipboard integration
│   ├── .zshrc                      # Zsh initialization template
│   ├── aliases.sh                  # Navigation, Git, and utility aliases
│   └── exports.sh                  # Default environment variables
└── tests
    ├── run_tests.sh                # Syntax verifier and test suite runner
    ├── test_install.sh             # Unit tests for install.sh language selection
    ├── test_setup_dotnet.sh        # Unit tests for setup-dotnet.sh
    ├── test_setup_git.sh           # Unit tests for setup-git.sh
    ├── test_setup_ssh.sh           # Unit tests for setup-ssh.sh
    └── test_setup_terminal.sh      # Unit tests for setup-terminal.sh
```

## 3. Prerequisites and Environment Variables

### Prerequisites

- macOS on Apple Silicon (`/opt/homebrew` prefix)
- Xcode Command Line Tools (`xcode-select --install`)
- Active internet connection for Homebrew, Oh My Zsh, and SDKMAN! downloads

### Environment Variables

| Variable | Required | Default | Description |
| :--- | :--- | :--- | :--- |
| `ROOT` | No | Repository root directory | Base path used by child scripts to locate templates and configs |
| `SETUP_LANG` | No | `en-US` | Installer display language (`en-US` or `pt-BR`) |
| `BOTH_OPTION` | No | `0` | Internal flag (`1` when installing both Java and .NET stacks) |
| `USER_EMAIL` | No | Prompted interactively | Email address associated with the generated ED25519 SSH key |

## 4. Setup, Development, and Verification Commands

### Clone and Execute Installer

```bash
mkdir -p ~/Developer
cd ~/Developer
git clone git@github.com:joao-m-csilva/macOS-setup.git
cd macOS-setup
./install.sh
```

### Run Individual Modules

```bash
./scripts/setup-homebrew.sh
./scripts/setup-terminal.sh
./scripts/setup-git.sh
./scripts/setup-node.sh
./scripts/setup-aws.sh
./scripts/setup-java.sh
./scripts/setup-dotnet.sh
./scripts/setup-ssh.sh your-email@example.com
```

### Verification and Automated Tests

Run syntax checks and the automated unit test suite:

```bash
chmod +x tests/*.sh
./tests/run_tests.sh
```

## 5. Module Specifications

### Terminal Synchronization (`scripts/setup-terminal.sh`)

- Installs **Oh My Zsh** unattended if `~/.oh-my-zsh` is absent.
- Clones `zsh-autosuggestions` and `zsh-syntax-highlighting` into `~/.oh-my-zsh/custom/plugins`.
- Creates symbolic links (`ln -sf`) from `terminal/exports.sh` and `terminal/aliases.sh` to `~/.config/terminal/`, and from `terminal/.vimrc` to `~/.vimrc` (backing up any pre-existing regular file to `~/.vimrc.backup`). Changes pulled or edited in the repository apply immediately to new shell sessions.

### SSH Key and Keychain Persistence (`scripts/setup-ssh.sh`)

- Generates an `ed25519` key at `~/.ssh/id_ed25519` if none exists.
- Appends `AddKeysToAgent yes`, `UseKeychain yes`, and `IdentityFile ~/.ssh/id_ed25519` under `Host *` in `~/.ssh/config` with `600` permissions.
- Loads the key into the macOS Keychain via `ssh-add --apple-use-keychain` and copies the public key to the clipboard.
- Verify GitHub SSH authentication after registering the key:

```bash
ssh -T git@github.com
```

### AWS CLI Setup (`scripts/setup-aws.sh`)

- Installs `awscli` if missing and copies `config.example` and `credentials.example` to `~/.aws/` without overwriting existing credentials.
- Verify installation and credentials:

```bash
aws --version
aws configure
aws sts get-caller-identity
```

## 6. Deployment

This repository runs directly on target macOS workstations. To apply updates on an already provisioned machine:

```bash
git pull --rebase
./scripts/setup-homebrew.sh
./scripts/setup-terminal.sh
./scripts/update.sh
./scripts/cleanup.sh
```

---

<a id="pt-br"></a>

# macOS Setup

Idioma: [English (en-US)](#en-us) | **Português (pt-BR)**

## 1. Visão Geral

`macOS-setup` é uma ferramenta de provisionamento em shell que automatiza a configuração de uma máquina macOS para desenvolvimento de software. Ela instala utilitários de linha de comando, aplicações gráficas, fontes, gerenciadores de versão de linguagens, plugins de shell e templates de configuração para Zsh, Vim, Git, SSH e AWS CLI.

## 2. Stack Tecnológica e Arquitetura

- **Runtime:** Bash (`#!/usr/bin/env bash`) e Zsh (shell alvo do usuário)
- **Gerenciamento de Pacotes:** Homebrew (`Brewfile`), NVM (Node.js), SDKMAN! (Java)
- **Prompt e Shell:** Oh My Zsh, Oh My Posh (`tokyonight_storm`), `fzf`, `zoxide`
- **Testes:** Executor nativo de testes unitários em Bash (`tests/run_tests.sh`) com ambientes `HOME` temporários isolados

### Estrutura de Diretórios

```text
macOS-setup
├── Brewfile                        # Fórmulas, casks e fontes declarativas do Homebrew
├── LICENSE                         # Licença MIT
├── README.md                       # Documentação técnica bilíngue (en-US / pt-BR)
├── assets
│   └── cat_apple.gif               # Asset de banner do repositório
├── install.sh                      # Ponto de entrada interativo e orquestrador
├── lang
│   ├── en-US.sh                    # Textos de CLI em inglês
│   └── pt-BR.sh                    # Textos de CLI em português brasileiro
├── scripts
│   ├── cleanup.sh                  # Remove dependências não utilizadas e cache do Homebrew
│   ├── setup-aws.sh                # Instala o AWS CLI e inicializa templates em ~/.aws
│   ├── setup-dotnet.sh             # Instala o SDK do .NET e o JetBrains Rider
│   ├── setup-git.sh                # Configura ~/.gitconfig e ~/.gitignore_global
│   ├── setup-homebrew.sh           # Instala o Homebrew e executa o bundle do Brewfile
│   ├── setup-java.sh               # Instala Zulu JDK 8 + IntelliJ IDEA ou SDKMAN!
│   ├── setup-node.sh               # Instala NVM, Node.js LTS mais recente e npm global
│   ├── setup-ssh.sh                # Gera chave SSH ED25519 e configura o Keychain do macOS
│   ├── setup-terminal.sh           # Instala Oh My Zsh, plugins e cria symlinks de dotfiles
│   └── update.sh                   # Atualiza pacotes do Homebrew
├── templates
│   ├── aws
│   │   ├── config.example          # Template de configuração de perfil padrão do AWS CLI
│   │   └── credentials.example     # Template de credenciais do AWS CLI
│   └── git
│       ├── .gitconfig              # Template de configuração global do Git
│       └── .gitignore_global       # Regras globais de ignore do Git
├── terminal
│   ├── .vimrc                      # Configuração do Vim integrada ao clipboard do macOS
│   ├── .zshrc                      # Template de inicialização do Zsh
│   ├── aliases.sh                  # Aliases de navegação, Git e utilitários
│   └── exports.sh                  # Variáveis de ambiente padrão
└── tests
    ├── run_tests.sh                # Verificador de sintaxe e executor da suíte de testes
    ├── test_install.sh             # Testes unitários para seleção de idioma do install.sh
    ├── test_setup_dotnet.sh        # Testes unitários para setup-dotnet.sh
    ├── test_setup_git.sh           # Testes unitários para setup-git.sh
    ├── test_setup_ssh.sh           # Testes unitários para setup-ssh.sh
    └── test_setup_terminal.sh      # Testes unitários para setup-terminal.sh
```

## 3. Pré-requisitos e Variáveis de Ambiente

### Pré-requisitos

- macOS em Apple Silicon (prefixo `/opt/homebrew`)
- Xcode Command Line Tools (`xcode-select --install`)
- Conexão ativa com a internet para downloads do Homebrew, Oh My Zsh e SDKMAN!

### Variáveis de Ambiente

| Variável | Obrigatória | Padrão | Descrição |
| :--- | :--- | :--- | :--- |
| `ROOT` | Não | Diretório raiz do repositório | Caminho base usado pelos scripts filhos para localizar templates e configs |
| `SETUP_LANG` | Não | `en-US` | Idioma de exibição do instalador (`en-US` ou `pt-BR`) |
| `BOTH_OPTION` | Não | `0` | Flag interna (`1` ao instalar ambos os ambientes Java e .NET) |
| `USER_EMAIL` | Não | Solicitado via prompt | Endereço de e-mail vinculado à chave SSH ED25519 gerada |

## 4. Comandos de Configuração, Desenvolvimento e Verificação

### Clonar e Executar o Instalador

```bash
mkdir -p ~/Developer
cd ~/Developer
git clone git@github.com:joao-m-csilva/macOS-setup.git
cd macOS-setup
./install.sh
```

### Executar Módulos Individualmente

```bash
./scripts/setup-homebrew.sh
./scripts/setup-terminal.sh
./scripts/setup-git.sh
./scripts/setup-node.sh
./scripts/setup-aws.sh
./scripts/setup-java.sh
./scripts/setup-dotnet.sh
./scripts/setup-ssh.sh seu-email@exemplo.com
```

### Verificação e Testes Automatizados

Execute a validação de sintaxe e a suíte de testes unitários automatizados:

```bash
chmod +x tests/*.sh
./tests/run_tests.sh
```

## 5. Especificação dos Módulos

### Sincronização do Terminal (`scripts/setup-terminal.sh`)

- Instala o **Oh My Zsh** de forma não interativa caso `~/.oh-my-zsh` não exista.
- Clona `zsh-autosuggestions` e `zsh-syntax-highlighting` em `~/.oh-my-zsh/custom/plugins`.
- Cria links simbólicos (`ln -sf`) de `terminal/exports.sh` e `terminal/aliases.sh` para `~/.config/terminal/`, e de `terminal/.vimrc` para `~/.vimrc` (criando backup em `~/.vimrc.backup` caso já exista um arquivo regular). Alterações feitas no repositório passam a valer imediatamente em novas sessões do terminal.

### Chave SSH e Persistência no Keychain (`scripts/setup-ssh.sh`)

- Gera uma chave `ed25519` em `~/.ssh/id_ed25519` caso não exista.
- Adiciona `AddKeysToAgent yes`, `UseKeychain yes` e `IdentityFile ~/.ssh/id_ed25519` sob `Host *` em `~/.ssh/config` com permissão `600`.
- Carrega a chave no Keychain do macOS via `ssh-add --apple-use-keychain` e copia a chave pública para a área de transferência.
- Verifique a autenticação SSH com o GitHub após cadastrar a chave:

```bash
ssh -T git@github.com
```

### Configuração do AWS CLI (`scripts/setup-aws.sh`)

- Instala o `awscli` caso ausente e copia `config.example` e `credentials.example` para `~/.aws/` sem sobrescrever credenciais existentes.
- Verifique a instalação e as credenciais:

```bash
aws --version
aws configure
aws sts get-caller-identity
```

## 6. Implantação

Este repositório é executado diretamente nas estações de trabalho macOS alvo. Para aplicar atualizações em uma máquina já configurada:

```bash
git pull --rebase
./scripts/setup-homebrew.sh
./scripts/setup-terminal.sh
./scripts/update.sh
./scripts/cleanup.sh
```
