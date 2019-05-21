FROM node:10.15.3-jessie
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y mongodb-org-shell mongodb-org-server mongodb-org-mongos mongodb-org-tools mongodb-org mongodb-server && \
    service mongod start && \
    apt-get install -y libssl-dev && \
    apt-get install -y ruby-full rubygems autogen autoconf libtool make && \
    npm install grunt -g && \
    npm install bower -g && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# This Dockerfile doesn't need to have an entrypoint and a command
# as Bitbucket Pipelines will overwrite it with a bash script.
