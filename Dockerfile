FROM java:openjdk-8-jre
MAINTAINER leo.lee "lis85@163.com"

ENV SOLR_GROUP solr
ENV SOLR_USER solr
ENV SOLE_UID 8983
ENV HOME /home/${SOLR_USER}
ENV USER_BIN /usr/local/bin/

RUN apt-get update && \
    apt-get install -y iproute netcat lsof jq libxml2-utils xmlstarlet tar && \
    apt-get clean && \
    mkdir ${HOME} && \
    groupadd -r ${SOLR_GROUP} && \
    useradd -u ${SOLE_UID} -g ${SOLR_GROUP} -d ${HOME} ${SOLR_USER} && \
    chown -R ${SOLR_USER}:${SOLR_GROUP} ${HOME} && \
    chown -R ${SOLR_USER}:${SOLR_GROUP} ${USER_BIN}

USER ${SOLR_USER}
WORKDIR ${HOME}

ENV SOLR_VERSION 6.5.0
RUN curl -L -o ${HOME}/solr-${SOLR_VERSION}.tgz http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz && \
    tar -C ${HOME} -xf ${HOME}/solr-${SOLR_VERSION}.tgz && \
    rm ${HOME}/solr-${SOLR_VERSION}.tgz

ENV SOLR_PREFIX ${HOME}/solr-${SOLR_VERSION}

ADD docker-run.sh ${USER_BIN}
ADD docker-stop.sh ${USER_BIN}
RUN chmod +x ${USER_BIN}/docker-run.sh && \
    chmod +x ${USER_BIN}/docker-stop.sh

EXPOSE 8983 7983 18983

CMD ["/usr/local/bin/docker-run.sh"]
