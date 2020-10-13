FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MULTITAUTULLI_RELEASE
LABEL build_version="Multi Tautulli"
LABEL maintainer="timekills"

# Inform app this is a docker env
ENV MULTITAUTULLI_DOCKER=True

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl \
#	g++ \
#	gcc \
#	make \
#	python3 \
#	python3-venv \
	py3-pip \
#	python3-all-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
#	jq \
#	py3-openssl \
#	py3-setuptools \
	python3 \
	python3-venv \
	python3-all-dev && \
 echo "**** install pip packages ****" && \
# pip3 install --no-cache-dir -U \
#	mock \
#	plexapi \
#	pycryptodomex && \
 echo "**** install app ****" && \
 cd /opt \
 git clone https://github.com/zSeriesGuy/Tautulli.git \
 addgroup tautulli && adduser --system --no-create-home tautulli --ingroup tautulli \
 chown tautulli:tautulli -R /opt/Tautulli \
 cd Tautulli \
 python3 -m venv /opt/Tautulli \
 source /opt/Tautulli/bin/activate \
 pip3 install -r /opt/Tautulli/requirements.txt \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/* \
 echo "**** Starting Multi Tautulli ****" && \
 cp /opt/Tautulli/init-scripts/init.systemd /lib/systemd/system/tautulli.service \
 systemctl daemon-reload && sudo systemctl enable tautulli.service \
 systemctl start tautulli.service
# /opt/Tautulli/bin/python3 Tautulli.py

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /logs
EXPOSE 8181
