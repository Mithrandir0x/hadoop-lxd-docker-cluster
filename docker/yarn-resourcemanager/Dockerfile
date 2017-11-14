FROM hadoop-base:2.8.1

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD run.sh /run.sh

RUN chmod a+x /run.sh

EXPOSE 8088 8032 8030 8031 8033

CMD ["/run.sh"]