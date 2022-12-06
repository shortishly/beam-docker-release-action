# -*- mode: dockerfile -*-
# Copyright (c) 2012-2022 Peter Morgan <peter.james.morgan@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
ARG BUILD_IMAGE
FROM ${BUILD_IMAGE} as build
ARG GITHUB_REPOSITORY
ARG BUILD_COMMAND

# https://github.com/erlang/otp/pull/6340
ENV ERL_AFLAGS="+JPperf true"

ENV MIX_ENV="prod"

RUN mkdir -p /${GITHUB_REPOSITORY}
WORKDIR /${GITHUB_REPOSITORY}
ADD / /${GITHUB_REPOSITORY}/
RUN ${BUILD_COMMAND}
RUN beam-docker-release-action/mkimage


FROM scratch
ARG GITHUB_REPOSITORY
ARG IMAGE_DESCRIPTION
ARG IMAGE_LICENSES
ARG IMAGE_SOURCE

LABEL org.opencontainers.image.description=${IMAGE_DESCRIPTION}
LABEL org.opencontainers.image.licenses=${IMAGE_LICENSES}
LABEL org.opencontainers.image.source=${IMAGE_SOURCE}

ENV BINDIR /erts/bin
ENV LANG C.UTF-8
ENV TZ GMT

# elixir - note that .config is not present on RELEASE_SYS_CONFIG
ENV RELEASE_SYS_CONFIG /release/sys
ENV RELEASE_VM_ARGS /release/vm.args
ENV RELEASE_ROOT /
ENV PHX_SERVER true


ENTRYPOINT ["/erts/bin/erlexec", "-boot_var", "ERTS_LIB_DIR", "/lib", "-boot_var", "RELEASE_LIB", "/lib", "-boot", "/release/start", "-noinput", "-no_epmd", "-proto_dist", "inet_tls", "-config", "/release/sys.config", "-args_file", "/release/vm.args"]

COPY --from=build /usr/lib/locale/${LANG}/ /usr/lib/locale/${LANG}/
COPY --from=build /${GITHUB_REPOSITORY}/_image/ /
