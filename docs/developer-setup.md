# Developer setup

Read the commands carefully before running them! Some are only for Ubuntu Linux, some are only for Apple OSX!

## Configure Git on your machine

For first time git users there is a need to do some set up to get their git account configured and authenticated with github.

You can follow the instructions [here.](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/set-up-git)

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

#### On OSX

```sh
# Start postgres
brew services start postgresql

# Create postgres user with password postgres
createuser --username=$USER --superuser --pwprompt postgres
```

#### On Debian/Ubuntu Linux

Set the postgres user's username to postgres

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
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
```

Add the asdf config to your shell.

- If you use bash add `. $HOME/.asdf/asdf.sh` to your `~/.bashrc`
- If you use fish add `source ~/.asdf/asdf.fish` to your `~/.config/fish/config.fish`
- If you use zsh add `. ~/.asdf/asdf.sh` to your `~/.zshrc`

Now restart your shell so the config takes effect. Be sure to `cd` back to
the Kalda project directory.

Add the language plugins and their deps. If you have any problems with these see the READMEs of the plugins on GitHub for installation instructions.

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
# If on OSX
brew install gnupg

asdf plugin-add nodejs
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
asdf reshim nodejs
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

## Getting your local environment up to date

If it has been a while since you did any coding locally, you might struggle to get your environments and branches working correctly, here are a few steps that might help:

NB!!! Make sure you are always working on a branch, and that it is up to date with main (the Kalda codebase in production):

- Your local environment or branch is not up to date 

## OPTION A: you haven't started any new work on a new branch:

```sh
# ALWAYS MAKE SURE YOU ARE ON MAIN
git checkout main
# ALWAYS MAKE SURE MAIN IS UP TO DATE BEFORE YOU START
git pull
# Make a new branch off of main, to work on:
git checkout -b nameofmynewbranch
# start coding!
```
## OPTION B: IF you already have a branch (called, e.g.  mybranch)

```sh
#check out the main branch
git checkout main
# get the latest version locally
git pull
# make sure your branch is up to date, i.e. it has the latest version of main 'behind' it.
git checkout mybranch
git fetch origin
git rebase origin/main
# IF there are CONFLICTS, please contact a developer, DO NOT DO `git push --force`
# IF this works and there are no conflicts, it will say "... rebase successful":
git push --force
```

If you have merge conflicts, it is best to grab one of the dev team to help you resolve them.

- You get a postgres error AND/OR
- The app doesn't work locally/at localhost:4000

```sh
# make sure you have all the latest npm dependencies
mix deps.get
# install them
npm install
# make sure the new installations are all in the right place
asdf reshim nodejs
# make sure all the migrations have run
mix ecto.reset
```

- You did all of the above and the tests still fail

```sh
mix test
# lots of tests fail that you don't expect them to
# this means your test migrations are out of sync with the app migrations
mix ecto.reset
# This can take a while.
MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate end
# This runs the migrations for the test environment
# This should now behave as you expect, run it to check:
mix test
```
