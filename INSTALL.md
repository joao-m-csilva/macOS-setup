# MacBook Setup - Installation Guide

Este documento descreve o processo de configuração de um Mac recém-formatado para desenvolvimento.

O objetivo deste repositório é automatizar a instalação das ferramentas e manter documentadas apenas as etapas que exigem intervenção manual.

---

# 1. Preparação inicial do macOS

Após a instalação limpa do macOS:

- Atualizar o sistema operacional.
- Fazer login no iCloud.
- Ativar sincronização de senhas e configurações desejadas.
- Configurar Touch ID.
- Configurar idioma, teclado e preferências pessoais.

---

# 2. Instalar o Homebrew

Instalar o Homebrew utilizando o comando oficial:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Validar a instalação:

```bash
brew --version
```

---

# 3. Clonar este repositório

Criar uma pasta para armazenar projetos:

```bash
mkdir ~/Projects
cd ~/Projects
```

Clonar o repositório:

```bash
git clone git@github.com:usuario/macbook-setup.git
```

Acessar a pasta:

```bash
cd macbook-setup
```

---

# 4. Configurar SSH

Executar o script responsável pela criação da chave SSH:

```bash
./scripts/setup-ssh.sh seu-email@email.com
```

O script irá:

- Gerar uma chave SSH utilizando ED25519.
- Configurar o ssh-agent.
- Adicionar a chave ao Keychain do macOS.
- Copiar a chave pública para a área de transferência.

Após a execução:

1. Acessar as configurações de SSH Keys do GitHub.
2. Criar uma nova SSH Key.
3. Colar a chave copiada.

Testar a conexão:

```bash
ssh -T git@github.com
```

---

# 5. Executar instalação automatizada

Executar o script principal de instalação:

```bash
./install.sh
```

O script será responsável por:

- Instalar pacotes definidos no Brewfile.
- Configurar ferramentas necessárias para desenvolvimento.

---

# 6. Configurações manuais pós-instalação

Algumas configurações não são automatizadas e precisam ser feitas manualmente.

## VS Code

- Fazer login utilizando a conta GitHub/Microsoft.
- Ativar ou verificar o Settings Sync.
- Confirmar sincronização das extensões, configurações e atalhos.

## Docker Desktop

- Abrir o Docker pela primeira vez.
- Aceitar permissões solicitadas pelo macOS.
- Fazer login caso necessário.

## Aplicativos

Realizar login nos aplicativos instalados que utilizam conta pessoal ou licença.

Exemplos:

- GitHub
- Google Chrome
- DBeaver
- IntelliJ IDEA

---

# 7. Validar ambiente

Verificar se as principais ferramentas foram instaladas corretamente:

```bash
git --version

node --version

npm --version

docker --version

psql --version

brew --version
```

Verificar o estado do Homebrew:

```bash
brew doctor
```

---

# 8. Restaurar projetos

Clonar os projetos pessoais:

```bash
git clone git@github.com:usuario/projeto.git
```

Instalar dependências conforme cada projeto:

```bash
npm install
```

ou o comando específico utilizado pelo projeto.

---

# Finalização

Após completar estas etapas, o ambiente de desenvolvimento estará configurado.

O objetivo deste repositório é manter o processo de reinstalação simples, reproduzível e documentado.
