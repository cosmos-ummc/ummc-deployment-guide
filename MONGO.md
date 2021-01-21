# MongoDB Installation

## Quick Installation

```sh
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64  ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
```

Note: MongoDB uses port 27017, the firewall should be configured to allow inbound traffic to the port

## Enable authentication

Connect to the db using mongo shell

```sh
mongo --port 27017
```

Add an admin user

```mongo
use admin
db.createUser(
    {
        user: "myUserAdmin",
        pwd: passwordPrompt(), // or cleartext password
        roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
    }
)
exit
```

Restart the MongoDB

```sh
sudo systemctl restart mongod
```
