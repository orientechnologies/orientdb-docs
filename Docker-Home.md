<!-- proofread 2015-11-26 SAM -->
# Installing in a Docker Container

[OrientDB](http://www.orientdb.org) images are available through the dedicated page on [Docker hub site](https://hub.docker.com/_/orientdb/)

##  Building the image on your own

Dockerfiles are available on a dedicated [repository](https://github.com/orientechnologies/orientdb-docker). The repository has a folder for each maintained version of OrientDB. Dockerfiles are approved by Docker's team.. This allows to build images on your own or even customize them for your special purpose. 

1. Clone this project to a local folder:
   ```
   git clone https://github.com/orientechnologies/orientdb-docker.git
   ```
2. Build the image for 2.1.x:
   ```
   cd 2.1
   docker build -t <YOUR_DOCKER_HUB_USER>/orientdb:2.1.16 .
   ```
3. Push it to your Docker Hub repository (it will ask for your login credentials):
   ```
   docker push <YOUR_DOCKER_HUB_USER>/orientdb:2.1.16
   ```


