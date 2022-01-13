# docker-minecraft
Small creative Minecraft server for private play which runs inside a Docker container. This is based off the work by [ITZG](https://github.com/itzg/docker-minecraft-server).

## Requirements
* docker
* docker-compose

## Configuration

By default, the docker-compose.yml file will deploy a standard MineCraft Server which will create folders in the current folder to map to volumes on the container. If you have a designated persistent volume or folder for your containers, update the location of the folders in the  "volumes" section of the docker-compose file.

## Launching MineCraft Server

1. Clone this repo to your computer where you wish to run the docker container.
2. Update the environment variable and settings in the docker-compose.yaml file to customize for your use.
3. From your command line run 'docker-compose up -d'
4. Verify your container is starting by running 'docker ps'.
5. Using your Minecraft client, go into Multiplayer and look for your server. 
6. Enjoy!!

## Interacting with the server
RCON is enabled by default, so you can exec into the container to access the Minecraft server console:

`docker exec -i mc_container_name rcon-cli`

#### Note: The -i is required for interactive use of rcon-cli.

To run a simple, one-shot command, such as stopping a Minecraft server, pass the command as arguments to rcon-cli, such as:

`docker exec mc_container_name rcon-cli stop`

The -i is not needed in this case.

If rcon is disabled you can send commands by passing them as arguments to the packaged mc-send-to-console script. For example, a player can be op'ed in the container **_mc_** with:

`docker exec mc mc-send-to-console <minecraft command>`

            
            
For remote access, configure your Docker daemon to use a tcp socket (such as -H tcp://0.0.0.0:2375) and attach from another machine:

`docker -H $HOST:2375 attach mc`

Unless you're on a home/private LAN, you should enable TLS access.
