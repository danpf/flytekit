ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-buster

MAINTAINER Flyte Team <users@flyte.org>
LABEL org.opencontainers.image.source=https://github.com/flyteorg/flytekit

WORKDIR /root
ENV PYTHONPATH /root

ARG VERSION
ARG DOCKER_IMAGE

RUN apt-get update \
	&& apt-get install build-essential -y \
	&& rm -rf /var/lib/apt/lists/*

# Pod tasks should be exposed in the default image
RUN pip install -U --no-cache-dir flytekit==$VERSION \
	flytekitplugins-pod==$VERSION \
	flytekitplugins-deck-standard==$VERSION \
	scikit-learn \
	&& pip uninstall tangled-up-in-unicode


RUN useradd -u 1000 flytekit
RUN chown flytekit: /root
# Some packages will create config file under /home by default, so we need to make sure it's writable
RUN chown flytekit: /home
USER flytekit

ENV FLYTE_INTERNAL_IMAGE "$DOCKER_IMAGE"
