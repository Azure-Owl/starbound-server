# AzureOwl/Starbound-server

Dockerized starbound server with mod support

# How to use

The preferred way to use this image is docker-compose:

```yaml
services:
  starbound_server:
    image: azureowl/starbound-server:latest
    container_name: starbound
    ports:
      - 21025:21025/tcp
    volumes:
      - /path/to/volume:/starbound
    environment:
      - STEAM_ACCOUNT=accountname
      - STEAM_PASSWORD=password
      # Workshop ids separated by spaces
      - MOD_IDS=
    stop_grace_period: 1m
    restart: unless-stopped
```

# Start the container

Before running the container first create the folder containing the volume and assign ownership to UID and GID 1000.

```shell
sudo mkdir -p /opt/starbound
sudo chown 1000:1000 /opt/starbound
```

The `chown` command is required because the server is not run as root but as the starbound user with user id 1000.

Starbound can only be downloaded by a Steam account that owns the game. Fill in the account name and password in the `STEAM_ACCOUNT` and `STEAM_PASSWORD` variables. This account must have Steam Guard disabled.

Launch the container with

```shell
docker-compose -f starbound.yml up -d
```

When the container is stopped, the server is sent a shutdown signal so it can save the universe before exiting. `stop_grace_period` gives it time to finish; without it Docker kills the server after 10 seconds.

# Mods

In order to install mods, add the workshop ids to the `MOD_IDS` environment variable separated by a space.

Example: `MOD_IDS=729480149 753790671`

Mods are downloaded again on every start. Mods removed from `MOD_IDS` are removed from the mods folder on the next start, while mods you place in the mods folder yourself are kept.

# Configure the Starbound server

The server can be configured by editing the starbound_server.config file in the /starbound/storage directory. The container needs to be restarted for the changes to take effect.

# Updating the server

The server and mods are updated every time the container starts. To update, restart the container with

`docker restart starbound`

# Versions

- `1.1` / `latest:`  Updated base OS image of the game to better support headless running of the server. Various tweaks to improve interaction with k8s. Removed several security vulnerabilities.
- `1.0:`Original upload.

# Github
[Link to Github repo](https://github.com/Azure-Owl/starbound-server)