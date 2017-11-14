FROM hadoop-base:2.8.1

HEALTHCHECK CMD curl -f http://localhost:19888/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 19888

CMD ["/run.sh"]