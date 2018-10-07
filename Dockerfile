FROM python:2.7-alpine3.8

RUN apk update && apk upgrade \
  && apk add ca-certificates \
  && rm -rf /var/cache/apk/*

RUN apk add --no-cache --virtual=build_dependencies make cmake gcc g++ git linux-headers libstdc++ && \
    apk del build_dependencies  && \
    apk add --no-cache libstdc++  && \
    rm -rf /var/cache/apk/*

#RUN apk add --update python-dev python py-pip py-setuptools
RUN apk add --no-cache --update musl musl-dev zlib libxml2 libxml2-dev libxml2-utils libxslt libxslt-dev py-httplib2 && \
    apk add --no-cache --update musl libffi libffi-dev libressl-dev gfortran libgfortran libstdc++ libgcc  cython cython-dev && \
    apk add --no-cache --update py-lxml py-jinja2 py-cffi py-cryptography py-netifaces py-mock py-markdown py-requests py-requests-oauthlib py-click && \
    rm -rf /var/cache/apk/*


#from the Community alpine repo
RUN apk add --no-cache --update py-numpy py-numpy-dev  py-scipy  py-numpy-f2py --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/community && \
    rm -rf /var/cache/apk/*

ARG PANDAS_VERSION=0.23.4
RUN apk add --no-cache python-dev py-pip libstdc++ && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip install pandas==${PANDAS_VERSION} && \
    apk del .build-deps


WORKDIR /app
ONBUILD ADD . /app
ADD http://cbd6a0bc973476113c8f-398472c2d78fec93ea34cdff5c856daa.r58.cf2.rackcdn.com/zoho_py_client/v7_m2/ReportClient.py com/adventnet/zoho/client/report/python/

ONBUILD ENV PYLOG_CONFIG_DIR=defaultConfig
ONBUILD ENV PYTHONPATH=$PYTHONPATH:/app/com/adventnet/zoho/client/report/python:/usr/lib/python2.7/site-packages/
ONBUILD RUN echo $PYTHONPATH

# Clean up APT when done
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

CMD ["/bin/ash"]
