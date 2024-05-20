FROM alpine:3.19

RUN apk add --no-cache imagemagick potrace bash

ADD convert.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/convert.sh

ENTRYPOINT ["convert.sh"]