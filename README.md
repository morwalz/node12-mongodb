# Node.js and MongoDB for Bitbucket Pipelines

This repository contains a Dockerfile as well as a simple example that shows how you can run your own Docker container with Node.js and MongoDB on Bitbucket Pipelines.

The Docker image is using node 6.9.4 and MongoDB 3.2

## Quickstart

### Using the image with Bitbucket Pipelines

Just copy/paste the YML below in your bitbucket-pipelines.yml and adapt the script to your needs.

```yaml
# This is a sample build configuration for Javascript.
# Only use spaces to indent your .yml configuration.
# -----
# This is using a custom node image that also contains MongoDB
image: habilelabs/node-mongodb

pipelines:
  default:
    - step:
        script:
          - npm install mongoose     
          - service mongod start     # Run this command to start the Mongo daemon
          - node test.js             # Replace this with any command you need.
```

### Using this in a script

You'll find a sample script in this repository in test.js. It simply connects to MongoDB using the mongoose package and then lists the existing databases.

```javascript
var mongoose = require('mongoose');

/// create a connection to the DB    
mongoose.connect('mongodb://localhost/test_database');

mongoose.connection.on('open', function() {
    // connection established
    new mongoose.mongo.Admin(mongoose.connection.db).listDatabases(function(err, result) {
        console.log('listDatabases succeeded');
        // database list stored in result.databases
        var allDatabases = result.databases;    
        console.log("Databases: " + JSON.stringify(allDatabases));
        mongoose.connection.close();
    });
});
```

## Create your own image

If you want to use a different version of Node.js you can simply create your own image for it. Just copy the content of the Dockerfile and replace the first line.

This image is built from the official Node.js image at https://hub.docker.com/_/node/ and you can find there all the different versions that are supported.

Your Dockerfile won't need to have an ENTRYPOINT or CMD line as Bitbucket Pipelines will run the script commands that you put in your bitbucket-pipelines.yml file instead.

```
FROM node:4.6
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
  && echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
  && apt-get update \
  && apt-get install -y mongodb-org --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# This Dockerfile doesn't need to have an entrypoint and a command
# as Bitbucket Pipelines will overwrite it with a bash script.
```

### Build the image

```bash
docker build -t <your-docker-account>/node-mongodb .
```

### Run the image locally with bash to make some tests

```bash
docker run -i -t <your-docker-account>/node-mongodb /bin/bash
```

### Push the image back to the DockerHub

```bash
docker push <your-docker-account>/node-mongodb
```
