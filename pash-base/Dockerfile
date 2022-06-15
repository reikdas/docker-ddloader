FROM ubuntu:18.04
ARG RELEASE=latest

RUN apt-get update -y && apt-get update --fix-missing
RUN apt-get install -y git vim iputils-ping
ENV PASH_HOST="docker"
ENV PASH_TOP="/opt/pash"
# download PaSh
RUN git clone https://github.com/binpash/pash.git /opt/pash -b dspash-future
# install PaSh and setup shell paths
RUN bash /opt/pash/scripts/distro-deps.sh
RUN yes | bash /opt/pash/scripts/setup-pash.sh
RUN yes | bash /opt/pash/scripts/setup-dspash.sh

RUN if [ "$RELEASE" = "eval" ]; then \
        apt-get update && cd /opt/pash/evaluation/distr_benchmarks && ./install_all_deps.sh; \
    fi

# append for unicode issues
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_COLLATE C
