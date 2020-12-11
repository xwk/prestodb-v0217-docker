FROM openjdk:8u181-jre-stretch

LABEL MAINTAINER=shawnzhu@users.noreply.github.com

ENV PRESTO_VERSION=0.217
ENV PRESTO_HOME=/home/presto

# extra dependency for running launcher
RUN apt-get update && apt-get install -y --no-install-recommends \
		python2.7-minimal \
	&& rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python2.7 /usr/bin/python

RUN groupadd -g 999 presto && \
    useradd -r -u 999 -g presto --create-home --shell /bin/bash presto
USER presto

RUN curl -L https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz -o /tmp/presto-server.tgz && \
    tar -xzf /tmp/presto-server.tgz --strip 1 -C ${PRESTO_HOME} && \
    mkdir -p ${PRESTO_HOME}/data && \
    rm -f /tmp/presto-server.tgz

USER root
RUN apt-get update
RUN apt-get install -y sudo python3 python3-pip less vim
RUN pip3 install jinja2


COPY --chown=presto:presto etc ${PRESTO_HOME}/etc
COPY --chown=presto:presto scripts ${PRESTO_HOME}/scripts

EXPOSE 8080

VOLUME ["${PRESTO_HOME}/etc", "${PRESTO_HOME}/data"]

WORKDIR ${PRESTO_HOME}
USER presto

ENTRYPOINT ["./scripts/entrypoint.sh"]

CMD ["run"]
