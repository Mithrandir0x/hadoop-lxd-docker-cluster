FROM openjdk:8-jdk

ENV HADOOP_VERSION 2.8.1
ENV SPARK_VERSION 2.2.0

ENV HADOOP_CLOSE_URL http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz?as_json=1
ENV HADOOP_ASC_URL https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz.asc
ENV HADOOP_KEYS_URL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

ENV SPARK_CLOSE_URL http://www.apache.org/dyn/closer.cgi/spark/spark-2.2.0/spark-2.2.0-bin-without-hadoop.tgz?as_json=1
ENV SPARK_ASC_URL https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-without-hadoop.tgz.asc
ENV SPARK_KEYS_URL https://www.apache.org/dist/spark/KEYS

ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop
ENV MULTIHOMED_NETWORK 1
ENV USER=root

ENV SPARK_HOME /opt/spark-$SPARK_VERSION
ENV SPARK_CONF_DIR /etc/spark

ENV PATH $HADOOP_HOME/bin/:$SPARK_HOME/bin/:$PATH

ADD entrypoint.sh /etc/entrypoint.sh

RUN set -x \
    && echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends net-tools curl \
    && mkdir -p /hadoop/tmp \
    && echo $HADOOP_CLOSE_URL \
    && echo `python -c "import json, urllib; data = json.loads(urllib.urlopen('$HADOOP_CLOSE_URL').read()); print '%s%s' % ( data['preferred'], data['path_info'] )"` > /hadoop/URL \
    && echo `cat /hadoop/URL` \
    && curl -fSL `cat /hadoop/URL` -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_ASC_URL" -o /tmp/hadoop.tar.gz.asc \
    && curl -fSL "$HADOOP_KEYS_URL" -o /tmp/hadoop_KEYS \
    && gpg --import /tmp/hadoop_KEYS \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && ln -s $HADOOP_HOME/etc/hadoop $HADOOP_CONF_DIR \
    && cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml \
    && rm /tmp/hadoop.tar.gz* \
    && chmod a+x /etc/entrypoint.sh

RUN set -x \
    && echo $SPARK_CLOSE_URL \
    && echo `python -c "import json, urllib; data = json.loads(urllib.urlopen('$SPARK_CLOSE_URL').read()); print '%s%s' % ( data['preferred'], data['path_info'] )"` > /tmp/spark_url \
    && echo `cat /tmp/spark_url` \
    && curl -fSL `cat /tmp/spark_url` -o /tmp/spark.tar.gz \
    && curl -fSL "$SPARK_ASC_URL" -o /tmp/spark.tar.gz.asc \
    && curl -fSL "$SPARK_KEYS_URL" -o /tmp/spark_KEYS \
    && gpg --import /tmp/spark_KEYS \
    && gpg --verify /tmp/spark.tar.gz.asc \
    && tar -xvf /tmp/spark.tar.gz -C /opt/ \
    && mv /opt/spark-2.2.0-bin-without-hadoop ${SPARK_HOME} \
    && ln -s $SPARK_HOME/conf /etc/spark \
    && rm /tmp/spark.tar.gz*

ENTRYPOINT ["/etc/entrypoint.sh"]