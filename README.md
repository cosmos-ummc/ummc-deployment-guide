
# CoSMoS Deployment Guide

CoSMoS contains 4 modules that needs to be install and set up individually.
Each module uses different programming language and libraries.

## Dependencies

Quick installation:

```sh
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install -y git golang-go python3 python3-pip nodejs npm
sudo npm install -g serve
```

Pick a directory to download the modules.
In the following example, the directory is `/home/ummc-user/cosmos`.
Retrieve the modules:

```sh
mkdir -p /home/ummc-user/cosmos
cd /home/ummc-user/cosmos
git clone https://github.com/cosmos-ummc/ummc-backend.git
git clone https://github.com/cosmos-ummc/ummc-bot.git
git clone https://github.com/cosmos-ummc/ummc-admin.git
git clone https://github.com/cosmos-ummc/ummc-notifications.git
git clone https://github.com/cosmos-ummc/ummc-deployement-guide.git
```

## Build

You will need to compile and build the modules before using them.
A few values are required:
The url for api (eg: api.ummc.cosmos.care)
The url for admin dashboard (eg: admin.ummc.cosmos.care)
The url for telegram bot backend (eg: bot.ummc.cosmos.care)

### ummc-backend

The backend module is used to communicate between the db
and the admin dashboard as well as the telegram bot.

```sh
cd /home/ummc-user/comsos/ummc-backend
go mod download
go build -o service ./cmd/server/main.go
```

### ummc-admin

The admin module is responsible for the admin dashboard.
You will need to supply the API url to the env vars.

```sh
cd /home/ummc-user/cosmos/ummc-admin
npm ci
export NODE_ENV=production
export REACT_APP_ENV=production
export REACT_APP_API_URL=https://api.ummc.cosmos.care/v1
npm run build
```

### ummc-bot

```sh
cd /home/ummc-user/cosmos/ummc-bot
npm ci
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
deactivate
```

### ummc-notifications

```sh
cd /home/ummc-user/cosmos/ummc-notifications
npm ci
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
deactivate
```

## Installation

```sh
cd /home/ummc-user/cosmos/ummc-deployment-guide
sudo cp ./cosmos-admin.service /etc/systemd/system/
sudo cp ./cosmos-backend.service /etc/systemd/system/
sudo cp ./cosmos-bot.service /etc/systemd/system/


sudo systemctl start cosmos-admin
sudo systemctl start cosmos-backend
sudo systemctl start cosmos-bot
sudo systemctl enable cosmos-admin
sudo systemctl enable cosmos-backend
sudo systemctl enable cosmos-bot
```

For `cosmos-notifications`, it uses `crontab`.
If there is existing cronjobs, add the content in `cosmos-notifications.crontab` to the crontab.
Else run

```sh
cd /home/ummc-user/cosmos/ummc-deployment-guide
crontab ./cosmos-admin.service
```

## Usage

```sh
# start the service
sudo systemctl start cosmos-admin

# query the service status
sudo systemctl status cosmos-admin

# stop the service
sudo systemctl stop cosmos-admin

sudo systemctl start cosmos-backend
sudo systemctl status cosmos-backend
sudo systemctl stop cosmos-backend

sudo systemctl start cosmos-bot
sudo systemctl status cosmos-bot
sudo systemctl stop cosmos-bot
```

## Uninstallation

```sh
sudo rm /etc/systemd/system/cosmos-admin.service
sudo rm /etc/systemd/system/cosmos-backend.service
sudo rm /etc/systemd/system/cosmos-bot.service
```

## Configuration

Before installing and running the modules, they are a few configuration steps.
In the deployment guide repo, you will find 4 services file,
one for each of the module (eg: cosmos-backend.service).

Go to the repository's directory.

```sh
cd /home/ummc-user/cosmos/ummc-deployment-guide
```

Some of the configuration requires a secret token.
This can be generated with either an [online uuid generator](https://www.uuidgenerator.net/version4)
or using the CLI:

```sh
uuidgen
```

To configure the services, edit each of the service files and crontab file,
and fill in any missing environment variables.

For the services files,
the configurable options are under the `[service]` section, prefixed with `Environment=`.

The following are the list of configurable fields and their purpose:

### `SERVICE_DIR`

The directory of the service module.

### `PORT`

The port used by the service.

### `API_BASE_URL`

The url of the `cosmos-backend` service, with a `/v1` suffix. Eg: `https://api.ummc.cosmos.care/v1`

### `WEB_HOOK_URL`

The url of the `cosmos-bot` service. Eg: `https://bot.ummc.cosmos.care/`

### `ADMIN_URL`

The url of the `cosmos-admin` service. Eg: `https://admin.ummc.cosmos.care`

### `API_AUTHORIZATION_TOKEN`

A randomly generated secret token. Share the same value with `CHATBOT_USER`.
Use by `cosmos-bot` and `cosmos-notifications` to authenticate itself to `cosmos-backend`.

### `CHATBOT_USER`

A randomly generated secret token. Share the same value with `API_AUTHORIZATION_TOKEN`.
Use by `cosmos-backend` to authenticate `cosmos-bot` and `cosmos-notifications`

### `BOT_TOKEN`

Token obtained from creating the telegram bot.

### `ACCESS_SECRET`

A randomly generated secret token. Use to sign JWT token by `cosmos-backend`.

### `REFRESH_SECRET`

A randomly generated secret token. Use to sign JWT token by `cosmos-backend`.

### `BACKEND_USER`

A randomly generated secret token. A secure token for an admin user in the database.

### `MONGODB_URL`

The MongoDB connection string.

### `COSMOS_EMAIL_ADDRESS`

Email address (Gmail) use to send email to users.

### `COSMOS_EMAIL_PASSWORD`

Password to the email address in `COSMOS_EMAIL_ADDRESS`.
Acquired by logging in to the gmail account, go to the settings
and create an app password.

### `SMTP_SERVER_HOST`

The SMTP server used to send emails. Default should be `smtp.gmail.com`.
Should not be changed.

### `SMTP_SERVER_PORT`

The port of the SMTP server. Default should be `587`.
Should not be changed.

### `AUTH_ENABLED`

Toggle authentication mechanic in `cosmos-backend`. Default to `true`.
Should not be changed.
