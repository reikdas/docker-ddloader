ARG BASE=hadoop-pash-base
ARG RELEASE=ubuntu-18.04

FROM $BASE:$RELEASE

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
