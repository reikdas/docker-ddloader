FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y git vim
ENV PASH_HOST="docker"
ENV PASH_TOP="/opt/pash"
# download PaSh
RUN git clone https://github.com/binpash/pash.git /opt/pash --depth 1 -b dspash
# install PaSh and setup shell paths
RUN bash /opt/pash/scripts/distro-deps.sh -o 
RUN yes | bash /opt/pash/scripts/setup-pash.sh -o
RUN bash /opt/pash/scripts/setup-dspash.sh

ADD start_worker.sh /opt/pash/start_worker.sh
RUN chmod a+x /opt/pash/start_worker.sh

# append for unicode issues
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_COLLATE C