# Litote CI

Reusable GitHub Actions workflows and composite actions shared by the Litote repositories.

## Workflows

| Workflow | Purpose | Required permissions |
|---|---|---|
| `zizmor.yml` | Audits the GitHub workflows of the caller with [zizmor](https://docs.zizmor.sh) | `contents: read` |
| `pr-title.yml` | Checks that the pull request title follows Conventional Commits | `pull-requests: read` |
| `gradle-check.yml` | Builds and tests a Gradle project, runs SonarCloud, and optionally runs a macOS job | `contents: read` |
| `gradle-verification.yml` | Regenerates the Gradle verification metadata of a Dependabot pull request | `contents: read` |
| `flutter-update-goldens.yml` | Regenerates the Flutter golden files on macOS, opens a pull request and runs the CI on it | `actions: write`, `contents: write`, `pull-requests: write` |
| `dependabot-commit-guard.yml` | Fails when a commit added to a Dependabot pull request does not come from the bot, or changes other paths than the given ones | `contents: read`, `pull-requests: read` |
| `dependabot-auto-merge.yml` | Approves and merges the minor and patch updates of the given Dependabot ecosystems, once the required checks pass | `contents: read`, `pull-requests: read` |

## Composite actions

| Action | Purpose |
|---|---|
| `setup-gradle` | Sets up the JDK and Gradle with the shared cache settings |
| `detect-changes` | Tells whether the pull request or the last commit changes code. Needs a checkout with `fetch-depth: 0` |
| `sonar-gradle` | Runs the aggregated JaCoCo report and the SonarCloud analysis. Does nothing without a token |
| `commit-via-api` | Commits local changes through the GitHub API, so that GitHub signs the commit. Does nothing when the branch already has this content, or when it no longer matches `expected-head` |
| `upload-regenerated-files` | Hands regenerated files over to another job, so that the job that runs the build needs no secret |
| `apply-regenerated-files` | Copies the given paths of `upload-regenerated-files` to the working directory, in the job that commits them |
| `check-bot-commits` | Checks the commits of a Dependabot pull request. Does nothing on another pull request |
| `setup-flutter` | Sets up Flutter, pinned to the exact version of `.flutter-version` |
| `release-please` | Runs release-please with a GitHub App token, and exposes `release_created` and `tag_name` |
| `set-release-version` | Writes the version of a release tag to `VERSION_NAME` in `gradle.properties`, on Linux and macOS |
| `maven-central-publish` | Runs Gradle with the Maven Central credentials and the signing key |
| `publish-draft-release` | Publishes a draft GitHub release as the latest one |

A project that needs services or steps between the build and the analysis uses the composite actions in its own job,
instead of `gradle-check.yml`.

Release workflows stay in each repository, because their jobs differ: Apple targets, the Gradle Plugin Portal, binaries
and documentation come between the shared steps. They are built from these composite actions.

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

`gradle-verification.yml` is called from a `pull_request_target` workflow, which keeps the filter on Dependabot:

```yaml
on:
  pull_request_target:
    branches: [main]
    paths:
      - 'gradle/libs.versions.toml'
      - 'gradle/wrapper/gradle-wrapper.properties'

jobs:
  update-verification-metadata:
    if: github.event.pull_request.user.login == 'dependabot[bot]' && github.event.pull_request.head.repo.full_name == github.repository
    permissions:
      contents: read
    uses: Litote/ci/.github/workflows/gradle-verification.yml@<sha> # vX.Y.Z
    secrets:
      RELEASE_PLEASE_APP_ID: ${{ secrets.RELEASE_PLEASE_APP_ID }}
      RELEASE_PLEASE_APP_PRIVATE_KEY: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}
```

A version bump is a code change: a `pull_request_target` job that runs a build with the versions of a pull request runs their code, before any review. Such a job must have no secret and no write access, and must not write the Gradle cache (`cache-read-only: 'true'` on `setup-gradle`). It hands its result over with `upload-regenerated-files`, and a second job, which runs no build, commits it with `apply-regenerated-files` and `commit-via-api`. Secrets go to that second job only. That job checks out the base branch and only moves the index to the pull request head (`git fetch --depth 1 origin <head sha>`, then `git reset FETCH_HEAD`), so that the files of the pull request stay off its disk.

`dependabot-commit-guard.yml` closes a gap of the auto-merge: the approval of a Dependabot pull request survives its next commits. Make its check required, and call it on every pull request: a required check of a job skipped by the caller stays pending.

```yaml
  commit-guard:
    if: github.event_name == 'pull_request'
    permissions:
      contents: read
      pull-requests: read
    uses: Litote/ci/.github/workflows/dependabot-commit-guard.yml@<sha> # vX.Y.Z
    with:
      allowed-paths: ^gradle/verification-metadata\.xml$
```

`dependabot-auto-merge.yml` relies on the required checks of the ruleset: without them, a pull request is merged without waiting for the CI. It needs `allow_auto_merge` on the repository:

```yaml
on:
  pull_request_target:
    branches: [main]
    types: [opened, reopened]

jobs:
  auto-merge:
    if: github.event.pull_request.user.login == 'dependabot[bot]'
    permissions:
      contents: read
      pull-requests: read
    uses: Litote/ci/.github/workflows/dependabot-auto-merge.yml@<sha> # vX.Y.Z
    with:
      ecosystems: gradle,pub
      # optional: these dependencies stay manual
      exclude-dependencies: org.mongodb:*
    secrets:
      RELEASE_PLEASE_APP_ID: ${{ secrets.RELEASE_PLEASE_APP_ID }}
      RELEASE_PLEASE_APP_PRIVATE_KEY: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}
```

The build must set `sonar.qualitygate.wait`, so that the analysis fails when the quality gate does.

`zizmor.yml` takes an optional `config` input, the path of a zizmor configuration file.

A check of a reusable workflow is named `<caller job> / <called job>`, for example `zizmor / zizmor`.
Required status checks must use that name.
