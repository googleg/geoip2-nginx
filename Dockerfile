ARG NGINX_TAG=alpine

FROM nginx:$NGINX_TAG

RUN apk add libmaxminddb libmaxminddb-dev --repository=https://pkgs.alpinelinux.org/package/edge/main/x86/libmaxmindd \
    && apk add \
        alpine-sdk \
        wget \
        pcre-dev \
        zlib-dev \
        git

RUN echo "export NGINX_VER=`/usr/sbin/nginx -v 2>&1 | /usr/bin/cut -d / -f2`" >> /envfile
RUN . /envfile; echo $NGINX_VER
RUN cat /envfile

RUN cd /opt \
    && . /envfile \
    && git clone  https://github.com/leev/ngx_http_geoip2_module.git \
    && wget -O - http://nginx.org/download/nginx-$NGINX_VER.tar.gz | tar zxfv - \
    && mv /opt/nginx-$NGINX_VER /opt/nginx \
    && cd /opt/nginx \
    && ./configure --with-compat --add-dynamic-module=/opt/ngx_http_geoip2_module \
    && make modules

FROM nginx:$NGINX_TAG

COPY --from=0 /opt/nginx/objs/ngx_http_geoip2_module.so /etc/nginx/modules

RUN apk add certbot certbot-nginx \
    && apk add  libmaxminddb --repository=https://pkgs.alpinelinux.org/package/edge/main/x86/libmaxmindd


