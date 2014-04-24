docker-glassfish4
=================

A docker container containing Glassfish4 and Oracle JDK 1.8.0_05

How to use it ?
---------------

After having installed Docker and cloned or downloaded this repository) :

- Build the image : ```docker build -t="GF" .```

- Start the container : ```docker run -i --name glassfish4 -p 4848:4848 -p 8080:8080 GF```

This will create a network redirection from your host's ports 4848 and 8080 to conatiner's ports 4848 and 8080.
You can then connect to GlassFish's admin console http://your.host.ip:4848 (admin / adminadmin)

