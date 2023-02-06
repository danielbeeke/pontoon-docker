FROM node:19 as node

ENV YUGLIFY_BINARY /app/node_modules/.bin/yuglify
ENV TERSER_BINARY /app/node_modules/.bin/terser

RUN printf "Starting ...\n" \
	&& git clone https://github.com/mozilla/pontoon.git /pontoon \
	&& cd /pontoon \
	&& npm install \
	&& npm run build -w translate \
	&& npx browserslist@latest --update-db \
	&& npm run build -w tag-admin \
	&& printf "Done.\n"

FROM python:3.9-bullseye

ARG USER_ID=1000
ARG GROUP_ID=1000

ENV DEBIAN_FRONTEND=noninteractive
ENV HGPYTHON3=1

RUN mkdir -pv /app/docker \
	&& groupadd -r --gid=${GROUP_ID} pontoon \
	&& useradd --uid=${USER_ID} --no-log-init -r -m -g pontoon pontoon \
	&& printf "Done.\n"

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

COPY --from=node /pontoon/node_modules /app/node_modules
COPY --from=node /pontoon/requirements /app/requirements
COPY --from=node /pontoon/pontoon      /app/pontoon
COPY --from=node /pontoon/docker       /app/docker
COPY --from=node /pontoon/tag-admin    /app/tag-admin
COPY --from=node /pontoon/translate    /app/translate

COPY --from=node /pontoon/manage.py /app/
COPY --from=node /pontoon/docker/server_*.sh /app/docker/

COPY             ./server_run.sh /app/
#COPY             ./server.env /app/.env

RUN sed -i 's/require/disable/g' /app/pontoon/settings/base.py

WORKDIR /app

RUN pip install -U 'pip>=8' && \
    pip install --no-cache-dir --require-hashes -r requirements/default.txt

RUN chown -R pontoon:pontoon /app

USER pontoon
WORKDIR /app

CMD ["/app/server_run.sh"]
