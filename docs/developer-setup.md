# Developer setup

Read the commands carefully before running them! Some are only for Ubuntu Linux, some are only for Apple OSX!

## Configure Git on your machine

For first time git users there is a need to do some set up to get their git account configured and authenticated with github.

You can follow the instructions [here.](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/set-up-git)

### Install GPG

There is also a need to install GPG if you don't already have it. (see getting ASDF below)
**_Make sure that you are in the kalda project directory when running asdf install for GPG_**

## Setup the Postgresql database

Install the Postgresql database though a means of your chosing. OSX
developers may want to use `brew`, Ubuntu Linux developers may want to use
`apt`.

```sh
# Ubuntu Linux
sudo apt install postgresql
# Apple OSX
brew install postgres
```

```sh
# On Mac check installation and set postgres to run at startup
pg_ctl -D /usr/local/var/postgres start && brew services start postgresql
# check it works
postgres -V
# Connect to database with your username 'whoami'
# This is because on Mac the default user is you.
psql -U 'whoami' postgres
# If this fails
cd /usr/local/var/postgres
initdb postgres
# now repeat
psql -U 'whoami' postgres
# view users
\du
```

### Ensuring there is a `postgres` user

Ensure there is a Postgresql user called `postgres` with the password
`postgres`.

#### ON MAC

```sh
createuser -s --replication postgres -P
```

This will run the command to create the postgres user.

-s means it will be created as a super user.
--replication means it will be given the replication privilege.
-P prompts for the password. Then you only need to enter postgres for the password.
Instructions in the documentation [here.](https://www.postgresql.org/docs/13/app-createuser.html

OR (if that didnt work for you) more instructions [here](https://www.codementor.io/@engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb#a1-create-role-with-psql)

#### ON LINUX

```sh
# On Ubuntu Linux
sudo -u postgres psql
\password postgres
# Now type in the password `postgres`
```

## Clone the project locally

You will need to have created an SSH key and added it to your GitHub account
before cloning the repo. See the [GitHub documentation][gh-ssh] for instructions.

[gh-ssh]: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh

```sh
cd to/directory/where/you/keep/your/projects
git clone git@github.com:kalda-co/kalda.git
cd kalda
```

## Get the developer secrets

There are some values (API keys, etc) that we use in dev but cannot be kept
in the repo because they are secret or sensitive. Ask a member of the dev team
for a copy and then place this file at `config/dev_secrets.exs` in the cloned
folder.

## Set up Elixir, Erlang, and NodeJS (and verion management generally with ASDF)

We use [asdf](https://github.com/asdf-vm/asdf) to install and manage
programming languages versions.

Install the deps

```sh
# Ubuntu Linux
sudo apt install curl git
# Apple OSX
brew install coreutils curl git
```

## Install asdf.

```sh
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
```

Add the asdf config to your shell.

- If you use bash add `. $HOME/.asdf/asdf.sh` to your `~/.bashrc`
- If you use fish add `source ~/.asdf/asdf.fish` to your `~/.config/fish/config.fish`
- If you use zsh add `. ~/.asdf/asdf.sh` to your `~/.zshrc`

Now restart your shell so the config takes effect. Be sure to `cd` back to
the Kalda project directory.

Add the language plugins and their deps

```sh
asdf plugin-add erlang
# Ubuntu Linux
sudo apt install build-essential autoconf m4 libncurses5-dev libpng-dev libssh-dev unixodbc-dev xsltproc libxml2-utils libncurses-dev
# Apple OSX
brew install autoconf wxmac
```

```sh
asdf plugin-add elixir
```

```sh
asdf plugin-add nodejs
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
```

Install Elixir, Erlang, and NodeJS using asdf.

This compiles Erlang from scratch and will take up to tens of minutes, so
this is a good time for a tea break ☕

```sh
asdf install
```

## Install application deps

```sh
mix deps.get
npm install
```

## Setup the Kalda database

```sh
mix ecto.setup
```

## Run the app locally

```sh
npm start
```

Now you can visit the application running locally by going to
<http://localhost:4000> in your browser.

Any front-end changes will be automatically synced with the browser, no need
to hit refresh.

You're now ready to developer Kalda!
