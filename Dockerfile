FROM python:2.7-alpine3.8
#FROM iron/python:2-dev
#FROM alpine:3.6

RUN apk update && apk upgrade \
  && apk add ca-certificates \
  && rm -rf /var/cache/apk/*

#RUN apk update && apk upgrade

RUN apk add --update make cmake gcc g++ git linux-headers
#RUN apk add --update python2-dev python2 py-pip
RUN apk add --update musl musl-dev
RUN apk add --update zlib


RUN apk add --update libxml2
RUN apk add --update libxml2-dev
RUN apk add --update libxml2-utils

RUN apk add --update libxslt
RUN apk add --update libxslt-dev

RUN apk add --update py-setuptools
RUN apk add --update py-libxml2
RUN apk add --update py-libxslt py-httplib2

RUN apk add --update py-lxml py-jinja2
RUN apk add --update musl libffi libffi-dev libressl-dev py-cffi py-cryptography

# Numpy Stuff
RUN apk add --update gfortran libgfortran libstdc++ libgcc  cython cython-dev

#from the Community alpine repo
RUN apk add --update py-numpy py-numpy-dev  py-scipy  py-netifaces  py-numpy-f2py --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/community

# this command work...need to stream line the other crap...remove dupes and stuff
RUN apk add --no-cache --virtual=build_dependencies g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install pandas==0.23.4  && \
    apk del build_dependencies  && \
    apk add --no-cache libstdc++  && \
    rm -rf /var/cache/apk/*

RUN apk add --update py-cryptography
RUN pip install -U pip

WORKDIR /app
ONBUILD ADD . /app
ADD http://cbd6a0bc973476113c8f-398472c2d78fec93ea34cdff5c856daa.r58.cf2.rackcdn.com/zoho_py_client/v7_m2/ReportClient.py com/adventnet/zoho/client/report/python/


RUN echo '#$Id$' > com/"__init__.py"
RUN echo '#$Id$' > com/adventnet/"__init__.py"
RUN echo '#$Id$' > com/adventnet/zoho/"__init__.py"
RUN echo '#$Id$' > com/adventnet/zoho/client/"__init__.py"
RUN echo '#$Id$' > com/adventnet/zoho/client/report/"__init__.py"
RUN echo '#$Id$' > com/adventnet/zoho/client/report/python/"__init__.py"


ONBUILD ENV PYLOG_CONFIG_DIR defaultConfig
ONBUILD ENV PYTHONPATH $PYTHONPATH:/app/com/adventnet/zoho/client/report/python
ONBUILD RUN echo $PYTHONPATH

# Clean up APT when done
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/ash"]
