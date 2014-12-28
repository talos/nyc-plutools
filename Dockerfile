#
# NYC PLUTO Tools Dockerfile
#
# https://github.com/talos/nyc-pluto-tools
#

FROM debian:wheezy
MAINTAINER John Krauss <irving.krauss@gmail.com>

# utility installs
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -yqq wget openssl ca-certificates apt-transport-https unzip
