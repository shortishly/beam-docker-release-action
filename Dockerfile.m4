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
ARG GITHUB_REPOSITORY
FROM erlang:${OTP_VERSION} AS build

LABEL org.opencontainers.image.authors="peter.james.morgan@gmail.com"
LABEL org.opencontainers.image.description="BEAM docker release from scratch"

RUN mkdir -p /${GITHUB_REPOSITORY}
WORKDIR /${GITHUB_REPOSITORY}
ADD / /${GITHUB_REPOSITORY}/
RUN ls /${GITHUB_REPOSITORY}
RUN make
RUN beam-docker-release-action/mkimage REL_NAME


FROM scratch

ENV BINDIR /erts-ERTS_VSN/bin
ENV TZ=GMT

ENTRYPOINT ["/erts-ERTS_VSN/bin/erlexec", "-boot_var", "ERTS_LIB_DIR", "/lib", "-boot", "/releases/REL_VSN/start", "-noinput", "-no_epmd", "-proto_dist", "inet_tls", "-config", "/releases/REL_VSN/sys.config", "-args_file", "/releases/REL_VSN/vm.args"]

COPY --from=build _rel/REL_NAME/ /
