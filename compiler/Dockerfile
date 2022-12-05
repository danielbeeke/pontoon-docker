FROM node:19 as node

FROM debian:bullseye AS debian

ARG USER_ID=1000
ARG GROUP_ID=1000

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install git \
	&& groupadd -r --gid=${GROUP_ID} pontoon \
	&& useradd --uid=${USER_ID} --no-log-init -r -m -g pontoon pontoon \
	&& printf "Done.\n"

USER pontoon:pontoon
