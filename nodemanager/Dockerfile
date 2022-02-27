ARG BASE=hadoop-pash-base
ARG RELEASE=ubnutu-18.04

FROM $BASE:$RELEASE

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/run.sh"]
