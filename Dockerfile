# Glassfish4 + Oracle JDK 1.8.0
#
# VERSION     0.5
# BUILD       20140727

FROM       ubuntu:latest
MAINTAINER "Sebastien Stormacq" "stormacq@amazon.com"

# Install required Linux packages
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install unzip

#Install Java 1.8
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html;oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz"
RUN mv /jdk-8u11-linux-x64.tar.gz /usr/local; cd /usr/local; tar zxvf jdk-8u11-linux-x64.tar.gz ; rm -f jdk-8u11-linux-x64.tar.gz ; cd /

# Install GlassFish 4
RUN wget -q --no-cookies --no-check-certificate "http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip"
RUN mv /glassfish-4.0.zip /usr/local; cd /usr/local; unzip glassfish-4.0.zip ; rm -f glassfish-4.0.zip ; cd /

# Setup environment variables
ENV JAVA_HOME /usr/local/jdk1.8.0_05
ENV GF_HOME /usr/local/glassfish4
ENV PATH $PATH:$JAVA_HOME/bin:$GF_HOME/bin

# Allow Derby to start as daemon (used by some Java EE app, such as Pet Store)
RUN echo "grant { permission java.net.SocketPermission \"localhost:1527\", \"listen\"; };" >> $JAVA_HOME/jre/lib/security/java.policy

# Secure GF installation with a password and authorize network access
ADD password_1.txt /tmp/password_1.txt
ADD password_2.txt /tmp/password_2.txt
RUN asadmin --user admin --passwordfile /tmp/password_1.txt change-admin-password --domain_name domain1 ; asadmin start-domain domain1 ; asadmin --user admin --passwordfile /tmp/password_2.txt enable-secure-admin ; asadmin stop-domain domain1
RUN rm /tmp/password_?.txt

# Add our GF startup script
ADD start-gf.sh /usr/local/bin/start-gf.sh
RUN chmod 755 /usr/local/bin/start-gf.sh

# PORT FORWARD THE ADMIN PORT, HTTP LISTENER-1 PORT, HTTPS LISTENER PORT, PURE JMX CLIENTS PORT, MESSAGE QUEUE PORT, IIOP PORT, IIOP/SSL PORT, IIOP/SSL PORT WITH MUTUAL AUTHENTICATION
#EXPOSE 4848 8080 8181 8686 7676 3700 3820 3920
# ElasticBeanstalk only expose first port
EXPOSE 8080 4848

# deploy an application to the container
# example below - it uses the auto-deploy service of Glassfish
# ADD http://public-sst.s3.amazonaws.com/async-chat.war /usr/local/glassfish4/glassfish/domains/domain1/autodeploy/async-chat.war

CMD ["/usr/local/bin/start-gf.sh"]
