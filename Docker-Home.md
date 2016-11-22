---
search:
   keywords: ['server management', 'Docker']
---

# Installing in a Docker Container

If you have Docker installed in your computer, this is the easiest way to run OrientDB. From the command line type:

```
$ docker run -d --name orientdb -p 2424:2424 -p 2480:2480
   -e ORIENTDB_ROOT_PASSWORD=root orientdb:latest
```

Where instead of "root", type the root's password you want to use.

##  Building the image on your own

Dockerfiles are available on a dedicated [repository](https://github.com/orientechnologies/orientdb-docker). The repository has a folder for each maintained version of OrientDB. Dockerfiles are approved by Docker's team.. This allows to build images on your own or even customize them for your special purpose. 

1. Clone this project to a local folder:
   ```
   git clone https://github.com/orientechnologies/orientdb-docker.git
   ```
2. Build the image for 2.2.x:
   ```
   cd 2.2
   docker build -t <YOUR_DOCKER_HUB_USER>/orientdb:2.2.11 .
   ```
3. Push it to your Docker Hub repository (it will ask for your login credentials):
   ```
   docker push <YOUR_DOCKER_HUB_USER>/orientdb:2.2.11
   ```


