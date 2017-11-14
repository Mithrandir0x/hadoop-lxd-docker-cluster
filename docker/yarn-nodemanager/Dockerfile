FROM hadoop-base:2.8.1

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042 8040 45454

CMD ["/run.sh"]