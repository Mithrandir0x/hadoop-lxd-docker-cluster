FROM hadoop-base:2.8.1

# `Z_VERSION` will be updated by `dev/change_zeppelin_version.sh`
ENV Z_VERSION=0.7.3
ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/opt/zeppelin-${Z_VERSION}" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

ENV ZEPPELIN_CLOSE_URL http://www.apache.org/dyn/closer.cgi/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-all.tgz?as_json=1
ENV ZEPPELIN_ASC_URL https://dist.apache.org/repos/dist/release/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-all.tgz.asc
ENV ZEPPELIN_KEYS_URL https://www.apache.org/dist/zeppelin/KEYS

RUN echo "$LOG_TAG update and install basic packages" && \
    apt-get -y update && \
    apt-get install -y locales && \
    locale-gen $LANG && \
    apt-get install -y software-properties-common && \
    apt -y autoclean && \
    apt -y dist-upgrade && \
    apt-get install -y build-essential

RUN echo "$LOG_TAG install tini related packages" && \
    apt-get install -y wget curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb

# should install conda first before numpy, matploylib since pip and python will be installed by conda
RUN echo "$LOG_TAG Install miniconda2 related packages" && \
    apt-get -y update && \
    apt-get install -y bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.3.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

RUN echo "$LOG_TAG Install python related packages" && \
    apt-get -y update && \
    apt-get install -y python-dev python-pip && \
    apt-get install -y gfortran && \
    # numerical/algebra packages
    apt-get install -y libblas-dev libatlas-dev liblapack-dev && \
    # font, image for matplotlib
    apt-get install -y libpng-dev libfreetype6-dev libxft-dev && \
    # for tkinter
    apt-get install -y python-tk libxml2-dev libxslt-dev zlib1g-dev && \
    pip install numpy && \
    pip install matplotlib

RUN echo "$LOG_TAG Download Zeppelin binary from [$ZEPPELIN_CLOSE_URL]" && \
    echo `python -c "import json, urllib; data = json.loads(urllib.urlopen('$ZEPPELIN_CLOSE_URL').read()); print '%s%s' % ( data['preferred'], data['path_info'] )"` > /tmp/zeppelin_url && \
    echo `cat /tmp/zeppelin_url` && \
    curl -fSL `cat /tmp/zeppelin_url` -o /tmp/zeppelin.tar.gz && \
    curl -fSL "$ZEPPELIN_ASC_URL" -o /tmp/zeppelin.tar.gz.asc && \
    curl -fSL "$ZEPPELIN_KEYS_URL" -o /tmp/zeppelin_KEYS && \
    gpg --import /tmp/zeppelin_KEYS && \
    gpg --verify /tmp/zeppelin.tar.gz.asc && \
    tar -xvf /tmp/zeppelin.tar.gz -C /opt/ && \
    mv /opt/zeppelin-0.7.3-bin-all ${Z_HOME}

RUN echo "$LOG_TAG Cleanup" && \
    apt-get autoclean && \
    apt-get clean

EXPOSE 8080

WORKDIR ${Z_HOME}
CMD ["bin/zeppelin.sh"]