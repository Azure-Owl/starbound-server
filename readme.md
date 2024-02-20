# AzureOwl/Starbound-server

Dockerized starbound server with mod support

# How to use

The preferred way to use this image is docker-compose:

```yaml
version: '2'
  services:
    starbound-server:
      image: azureowl/starbound-server
      container_name: starbound
      environment:
        - STEAM_ACCOUNT=<steamaccountname>
        - STEAM_PASSWORD=<steampassword>
        - MOD_IDS=()
      volumes:
        - /path/to/folder:/starbound
      ports:
        - 21025:21025/tcp #default game port
      restart: unless-stopped
```

In order to install mods, add the workshop ids to the MOD_IDS environment variable separated by a space.

Example: MOD_IDS=729480149 753790671

In order to launch the container, fill in your steam account name and password in the STEAM_ACCOUNT and STEAM_PASSWORD variables. This account must have Steam Guard disabled.

# Configure the Starbound server

The server can be configured by editing the starbound_server.config file in the /starbound/storage directory. The container needs to be restarted for the changes to take effect

# Updating the server

In order to update the server or mods restart the container with 

`docker restart starbound`

