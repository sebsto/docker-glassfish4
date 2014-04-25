#!/usr/bin/env bash 

asadmin start-domain
asadmin start-database
tail -f /usr/local/glassfish4/glassfish/domains/domain1/logs/server.log
