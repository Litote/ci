# Litote CI

Reusable GitHub Actions workflows shared by the Litote repositories.

## Workflows

| Workflow | Purpose | Required permissions |
|---|---|---|
| `zizmor.yml` | Audits the GitHub workflows of the caller with [zizmor](https://docs.zizmor.sh) | `contents: read` |
| `pr-title.yml` | Checks that the pull request title follows Conventional Commits | `pull-requests: read` |

## Releases

Releases are created by release-please from Conventional Commits. Only `feat` and `fix` commits trigger a release.

## Usage

Pin the workflows by SHA, with the tag in a comment, so that Dependabot can update them:

```yaml
jobs:
  zizmor:
    permissions:
      contents: read
    uses: Litote/ci/.github/workflows/zizmor.yml@<sha> # vX.Y.Z

  pr-title:
    if: github.event_name == 'pull_request'
    permissions:
      pull-requests: read
    uses: Litote/ci/.github/workflows/pr-title.yml@<sha> # vX.Y.Z
```

`zizmor.yml` takes an optional `config` input, the path of a zizmor configuration file.

A check of a reusable workflow is named `<caller job> / <called job>`, for example `zizmor / zizmor`.
Required status checks must use that name.
