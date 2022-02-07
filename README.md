# BEAM Docker Release action

This is a composite action that:
- Logs into a container repository
- Creates a Docker image of a BEAM release from scratch
- Pushes the image to the container repository


## Inputs

## `registry`

**Required** The container repository being used, e.g., `ghcr.io`.

## `username`

**Required** The username used to authenticate with the container
  repository, e.g., `${{ github.actor }}`.

## `password`

**Required** The password used to authenticate with the container
  repository, e.g., `${{ secrets.GITHUB_TOKEN }}`.

## Outputs

## `name`

The name of the image.

## Example usage

```yaml
uses: shortishly/beam-docker-release-action@v1.15
with:
  registry: ${{ env.REGISTRY }}
  username: ${{ github.actor }}
  password: ${{ secrets.GITHUB_TOKEN }}
```

For a full example: https://github.com/shortishly/hello_world
