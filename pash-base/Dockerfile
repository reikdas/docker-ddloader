FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y git vim
ENV PASH_HOST="docker"
# download PaSh
RUN git clone https://github.com/binpash/pash.git /opt/pash
# install PaSh and setup shell paths
RUN yes | bash /opt/pash/scripts/install.sh -p

# append for unicode issues
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_COLLATE C