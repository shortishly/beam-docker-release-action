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
ARG OTP_VERSION
FROM erlang:${OTP_VERSION}
ARG GITHUB_REPOSITORY
ARG BUILD_COMMAND

LABEL org.opencontainers.image.authors="peter.james.morgan@gmail.com"
LABEL org.opencontainers.image.description="BEAM docker release from scratch"

RUN uname -a
RUN mkdir -p /${GITHUB_REPOSITORY}
WORKDIR /${GITHUB_REPOSITORY}
ADD / /${GITHUB_REPOSITORY}/
ENV V=1
RUN ${BUILD_COMMAND}
RUN beam-docker-release-action/mkimage REL_NAME
RUN beam-docker-release-action/app
