FROM python:2.7-alpine3.8

RUN apk update && apk upgrade \
  && apk add ca-certificates \
  && rm -rf /var/cache/apk/*

RUN apk add --update make cmake gcc g++ git linux-headers

#RUN apk add --update python2-dev python2 py-pip py-setuptools
RUN apk add --update musl musl-dev zlib libxml2 libxml2-dev libxml2-utils libxslt libxslt-dev py-httplib2

RUN apk add --update musl libffi libffi-dev libressl-dev gfortran libgfortran libstdc++ libgcc  cython cython-dev
RUN apk add --update py-lxml py-jinja2 py-cffi py-cryptography py-netifaces

#from the Community alpine repo
#RUN apk add --update py-numpy py-numpy-dev  py-scipy  py-numpy-f2py --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/community

# this command work...need to stream line the other crap...remove dupes and stuff
#RUN apk add --no-cache --virtual=build_dependencies g++ && \
#    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
#    pip install pandas==0.23.4  && \
#    apk del build_dependencies  && \
#    apk add --no-cache libstdc++  && \
#    rm -rf /var/cache/apk/*

RUN pip install -U pip
#RUN pip install pandas

WORKDIR /app
ONBUILD ADD . /app
ADD http://cbd6a0bc973476113c8f-398472c2d78fec93ea34cdff5c856daa.r58.cf2.rackcdn.com/zoho_py_client/v7_m2/ReportClient.py com/adventnet/zoho/client/report/python/

ONBUILD ENV PYLOG_CONFIG_DIR=defaultConfig
ONBUILD ENV PYTHONPATH=$PYTHONPATH:/app/com/adventnet/zoho/client/report/python
ONBUILD RUN echo $PYTHONPATH

# Clean up APT when done
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

CMD ["/bin/ash"]
