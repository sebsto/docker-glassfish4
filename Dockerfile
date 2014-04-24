# Glassfish4 + Oracle JDK 1.8.0_05
#
# VERSION               0.0.1

FROM      base
MAINTAINER "Sebastien Stormacq" "stormacq@amazon.com"

ADD start-gf.sh /usr/local/bin/start-gf.sh
RUN chmod 755 /usr/local/bin/start-gf.sh

RUN apt-get update

RUN apt-get -y install wget

RUN apt-get -y install unzip

RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html;oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.tar.gz"

RUN mv /jdk-8u5-linux-x64.tar.gz /usr/local; cd /usr/local; tar zxvf jdk-8u5-linux-x64.tar.gz ; rm -f jdk-8u5-linux-x64.tar.gz ; cd /

RUN wget -q --no-cookies --no-check-certificate "http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip"

RUN mv /glassfish-4.0.zip /usr/local; cd /usr/local; unzip glassfish-4.0.zip ; rm -f glassfish-4.0.zip ; cd /

ENV JAVA_HOME /usr/local/jdk1.8.0_05

ENV GF_HOME /usr/local/glassfish4

ENV PATH $PATH:$JAVA_HOME/bin:$GF_HOME/bin

# PORT FORWARD THE ADMIN PORT, HTTP LISTENER-1 PORT, HTTPS LISTENER PORT, PURE JMX CLIENTS PORT, MESSAGE QUEUE PORT, IIOP PORT, IIOP/SSL PORT, IIOP/SSL PORT WITH MUTUAL AUTHENTICATION
EXPOSE 4848 8080 8181 8686 7676 3700 3820 3920

ADD password_1.txt /tmp/password_1.txt
ADD password_2.txt /tmp/password_2.txt
RUN asadmin --user admin --passwordfile /tmp/password_1.txt change-admin-password --domain_name domain1 ; asadmin start-domain domain1 ; asadmin --user admin --passwordfile /tmp/password_2.txt enable-secure-admin ; asadmin stop-domain domain1
RUN rm /tmp/password_?.txt

CMD /usr/local/bin/start-gf.sh
