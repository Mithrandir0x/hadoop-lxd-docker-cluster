FROM hadoop-base:2.8.1

HEALTHCHECK CMD curl -f http://localhost:50070/ || exit 1

RUN mkdir -p /hadoop/tmp/dfs/name
VOLUME /hadoop/tmp/dfs/name

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50070 8020

CMD ["/run.sh"]