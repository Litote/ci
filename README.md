# Litote CI

Reusable GitHub Actions workflows and composite actions shared by the Litote repositories.

## Workflows

| Workflow | Purpose | Required permissions |
|---|---|---|
| `zizmor.yml` | Audits the GitHub workflows of the caller with [zizmor](https://docs.zizmor.sh) | `contents: read` |
| `pr-title.yml` | Checks that the pull request title follows Conventional Commits | `pull-requests: read` |
| `gradle-check.yml` | Builds and tests a Gradle project, runs SonarCloud, and optionally runs a macOS job | `contents: read` |

## Composite actions

| Action | Purpose |
|---|---|
| `setup-gradle` | Sets up the JDK and Gradle with the shared cache settings |
| `detect-changes` | Tells whether the pull request or the last commit changes code. Needs a checkout with `fetch-depth: 0` |
| `sonar-gradle` | Runs the aggregated JaCoCo report and the SonarCloud analysis. Does nothing without a token |

A project that needs services or steps between the build and the analysis uses the composite actions in its own job,
instead of `gradle-check.yml`.

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

`gradle-check.yml` takes its secrets explicitly:

```yaml
jobs:
  check:
    permissions:
      contents: read
    uses: Litote/ci/.github/workflows/gradle-check.yml@<sha> # vX.Y.Z
    with:
      check-name: Check (JVM / JS / Linux)
      jvm-args: -Xmx3g -Dfile.encoding=UTF-8
      gradle-args: --max-workers=2
      macos-tasks: macosArm64Test iosSimulatorArm64Test compileKotlinIosArm64
    secrets:
      GRADLE_ENCRYPTION_KEY: ${{ secrets.GRADLE_ENCRYPTION_KEY }}
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

The build must set `sonar.qualitygate.wait`, so that the analysis fails when the quality gate does.

`zizmor.yml` takes an optional `config` input, the path of a zizmor configuration file.

A check of a reusable workflow is named `<caller job> / <called job>`, for example `zizmor / zizmor`.
Required status checks must use that name.
