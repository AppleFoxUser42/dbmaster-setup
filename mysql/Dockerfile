ARG SQL_VERSION=5.7
FROM mysql:${SQL_VERSION}

COPY entrypoint/setup-master.sh /usr/local/bin/
COPY entrypoint/wait-for-it.sh /usr/local/bin/

ENTRYPOINT ["setup-master.sh"]
