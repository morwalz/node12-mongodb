##############################################################################
# Use Ubuntu 18.04
##############################################################################

FROM ubuntu:18.04

##############################################################################
# This forces the image to be build on every push!
##############################################################################

ARG CACHEBUST=0

##############################################################################
# Replace shell with bash so we can source files
##############################################################################

RUN rm /bin/sh && \
	ln -s /bin/bash /bin/sh && \
	mkdir -p /root/.nvm

##############################################################################
# Install dependencies from Ubuntu
##############################################################################

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 12.18.2

RUN apt-get update --fix-missing && \
	apt-get install -y curl && \
	##############################################################################
	# Install: nvm, node and npm
	# @see: http://stackoverflow.com/questions/25899912/install-nvm-in-docker
	##############################################################################
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash && \
	source $NVM_DIR/nvm.sh && \
	nvm install $NODE_VERSION && \
	nvm cache clear && \
	apt-get remove -y curl && \
	rm -rf /var/lib/apt/lists/*

ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN  apt-get update && apt-get install -y gnupg2 && \
     apt-get install -y --no-install-recommends apt-utils && \
     echo node -v && \
     wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list && \
    apt-get update && \
    apt install -y git && \
    apt-get install -y mongodb-org && \
    apt-get install -y libssl-dev && \
    apt-get install -y ruby-full rubygems autogen autoconf libtool make && \
    npm install grunt -g && \
    npm install bower -g && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# This Dockerfile doesn't need to have an entrypoint and a command
# as Bitbucket Pipelines will overwrite it with a bash script.
