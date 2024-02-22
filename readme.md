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
        - UID=1000
        - GID=1000
      volumes:
        - /path/to/folder:/starbound
      ports:
        - 21025:21025/tcp #default game port
      restart: unless-stopped
```
# Start the container

Before running the container first create the folder containing the volume and assign ownership to the UID and GID you enter into the `docker-compose` file.

```shell
sudo mkdir -p /opt/starbound
sudo chown 1000:1000 /opt/starbound
```
The `chown` command is required because server is not run as root but as the starbound user with default user id 1000. The same write permissions must also be present on the host folder.

To launch the container, fill in your steam account name and password in the STEAM_ACCOUNT and STEAM_PASSWORD variables. This account must have Steam Guard disabled.

Launch the container with 

```shell
docker-compose -f starbound.yml up -d
```

# Mods

In order to install mods, add the workshop ids to the MOD_IDS environment variable separated by a space.

Example: MOD_IDS=729480149 753790671

# Configure the Starbound server

The server can be configured by editing the starbound_server.config file in the /starbound/storage directory. The container needs to be restarted for the changes to take effect

# Updating the server

In order to update the server or mods restart the container with

`docker restart starbound`
