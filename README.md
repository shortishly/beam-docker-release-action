# BEAM Docker Release action

A GitHub action that builds BEAM releases into a `from scratch`
container.

When packaging an application as a [docker][docker-com] container it
is too easy to just be lazy and put `FROM debian` (other distributions
are available, replace `debian` with your distribution of choice). For
sure it is going to work, but you have just included dozens of
libraries and binaries that your application [just does not
need][dockerfile-best-practices]. An image that could be tens of
megabytes is now at least several hundred - we are building containers
not virtual machines here!

We use a [multi-stage build][docker-building-multi-stage], building
the release, and then copying only the release and its dependencies
into a [scratch base image][baseimages-scratch]. Only the release and
any shared libraries it requires to run are present. There is no
shell, or any OS commands.

This is a composite action that:
- Logs into a container repository
- Creates a minimal docker image of a BEAM release from scratch
- Pushes the image to the container repository

Supporting:
- [Elixir][elixir] with the [Phoenix Framework][phoenix] using [mix][mix] to build;
- [Erlang/OTP][erlang] with [erlang.mk][erlang-mk];
- [Erlang/OTP][erlang] with [rebar3][rebar3]

Hello World! Simple examples for both Elixir and Erlang can be found at:
- [Elixir with Phoenix][hello-world-elixir-phx]
- [Erlang/OTP with erlang.mk][hello-world-erlang-mk]
- [Erlang/OTP with rebar3][hello-world-rebar3]

Some real examples:
- [Erlang/OTP memcached server and client][mcd]
- [Erlang/OTP real-time in memory database replication cache, with a memcached and REST API][pgec]

## Typical Usage

### Elixir

The following example is triggered by a [push
event][github-workflow-push-event] to build an [Elixir Mix
Prod Release][mix-release].

```yaml
---
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Beam Docker Release
        uses: shortishly/beam-docker-release-action@v1.23
        with:
          registry: ghcr.io
          username: ${{github.actor}}
          password: ${{secrets.GITHUB_TOKEN}}
          build-command: mix do local.hex --force + deps.get + local.rebar --force + compile + assets.deploy + phx.digest + release --overwrite
          build-image: elixir:1.14.2
          build-platforms: linux/amd64
          build-tags: ghcr.io/${{github.repository}}:elixir-phx
```

### Erlang/OTP with erlang.mk


The following example is triggered by a [push
event][github-workflow-push-event] to build an [Erlang/OTP Release with erlang.mk][erlang-mk-release].


```yaml
---
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Beam Docker Release
        uses: shortishly/beam-docker-release-action@v1.22
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
          build-image: erlang:25.1
          build-platforms: linux/amd64
          build-tags: ghcr.io/${{ github.repository }}:erlang.mk
```


### Erlang/OTP with rebar3


The following example is triggered by a [push
event][github-workflow-push-event] to build an [Erlang/OTP Release with rebar3][rebar3].


```yaml
---
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Beam Docker Release
        uses: shortishly/beam-docker-release-action@v1.22
        with:
          registry: ghcr.io
          username: ${{github.actor}}
          password: ${{secrets.GITHUB_TOKEN}}
          build-command: rebar3 release
          build-platforms: linux/amd64
          build-tags: ghcr.io/${{github.repository}}:rebar3
```



## Inputs

## registry

**Required** The container repository being used, e.g., `ghcr.io`.

## username

**Required** The username used to authenticate with the container
  repository, e.g., `${{ github.actor }}`.

## password

**Required** The password used to authenticate with the container
  repository, e.g., `${{ secrets.GITHUB_TOKEN }}`.
  
## build-image

**Required** The build image used. Typically this should be the
appropriate version of `erlang` or `elixir`.

## build-command

**Required** The command used to build the release. Examples for each
[mix][mix], [erlang.mk][erlang-mk] or [rebar3][rebar3] are above.

## build-platforms

The platforms that are used for the build. This defaults to
`linux/amd64`.

## build-tags

**Required** The tags applied to the release.

## Outputs

None.

[baseimages-scratch]: https://docs.docker.com/engine/userguide/eng-image/baseimages/
[docker-building-multi-stage]: https://docs.docker.com/build/building/multi-stage/
[docker-com]: https://www.docker.com
[dockerfile-best-practices]: https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices
[elixir]: https://elixir-lang.org
[erlang-mk-release]: https://erlang.mk/guide/relx.html
[erlang-mk]: https://erlang.mk
[erlang]: https://www.erlang.org
[github-workflow-push-event]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#push
[hello-world-elixir-phx]: https://github.com/shortishly/hello_world/tree/elixir-phx
[hello-world-erlang-mk]: https://github.com/shortishly/hello_world/tree/erlang-mk
[hello-world-rebar3]: https://github.com/shortishly/hello_world/tree/rebar3
[mcd]: https://github.com/shortishly/mcd/blob/main/.github/workflows/release.yml
[mix-release]: https://hexdocs.pm/mix/1.14/Mix.Tasks.Release.html
[mix]: https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html
[pgec]: https://github.com/shortishly/pgec/blob/main/.github/workflows/release.yml
[phoenix]: https://www.phoenixframework.org
[rebar3]: https://rebar3.org

