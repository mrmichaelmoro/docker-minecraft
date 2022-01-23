FROM itzg/minecraft-server

LABEL org.opencontainers.image.authors="mmoro"

## Define packages to install for this container
ENV PACKAGES="apache2 php wget screen"
ENV MCRCON_VERSION="0.7.2"

## Expose & port for minecraft-server-web-console
EXPOSE 8000 80

## Package updates &installations
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y ${PACKAGES} && \
  apt-get clean

## Remove default apache html folder; recreated in future steps
RUN rm -rf /var/www/html git@github.com:SuperPykkon/minecraft-server-web-console.git

## Clone and configure SuperPykkon's minecraft-server-web-console
## Default project requires sudo privs as www-data user (!) and no one 
## has time for a hack. This removes all sudo commands from the source for use
## with a local RCON client instead and grants the www-data user access to the
## minecraft user group. 
RUN cd /var/www && \
    git clone https://github.com/SuperPykkon/minecraft-server-web-console html && \
    sed -i 's/server\//\/data\//' html/config/config.php && \
    sed -i 's/sudo\ //g' html/*.php && \
    usermod -G minecraft www-data 

## Download and install RCON client
RUN cd /tmp && \
    wget https://github.com/Tiiffi/mcrcon/releases/download/v${MCRCON_VERSION}/mcrcon-${MCRCON_VERSION}-linux-x86-64.tar.gz && \
    tar zxvf mcrcon-${MCRCON_VERSION}-linux-x86-64.tar.gz && \
    mv mcrcon /

## Cleanup container for a smaller image
RUN rm -fr /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/* /var/log/apt/* /var/log/*.log

## Configure and start
ADD scripts/initiate.sh /initiate.sh
ADD scripts/apache-watcher.sh /apache-watcher.sh
ADD scripts/mcrcon-watcher.sh /mcrcon-watcher.sh

RUN chmod 755 /initiate.sh /apache-watcher.sh /mcrcon-watcher.sh

ENTRYPOINT [ "/initiate.sh" ]