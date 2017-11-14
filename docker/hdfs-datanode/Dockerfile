FROM hadoop-base:2.8.1

HEALTHCHECK CMD curl -f http://localhost:50075/ || exit 1

RUN mkdir -p /hadoop/tmp/dfs/data
VOLUME /hadoop/tmp/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50010 50020 50075

CMD ["/run.sh"]