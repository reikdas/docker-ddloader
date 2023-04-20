ARG BASE=hadoop-pash-base
ARG RELEASE=latest

FROM $BASE:$RELEASE

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
