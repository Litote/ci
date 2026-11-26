# Changelog

## [0.16.0](https://github.com/Litote/ci/compare/v0.15.0...v0.16.0) (2026-11-26)


### Features

* gradle-verification commits the ABI dumps of backward compatible additions ([#64](https://github.com/Litote/ci/issues/64)) ([1f0842b](https://github.com/Litote/ci/commit/1f0842be0a5d523eec9b25cd5f82e909116b9b2d))


### Bug Fixes

* check-bot-commits fails when the API call on a commit fails ([#55](https://github.com/Litote/ci/issues/55)) ([5473155](https://github.com/Litote/ci/commit/54731556b7a6ca6ae950233567ee15c83778189f))
* commit-via-api handles a branch that moves during the commit, and a test for sonar-gradle ([#59](https://github.com/Litote/ci/issues/59)) ([8070412](https://github.com/Litote/ci/commit/8070412b4f3af718f48ee82cd4dd5ff5d19c2355))
* flutter-update-goldens runs the tests in a job without write access ([#58](https://github.com/Litote/ci/issues/58)) ([130bf39](https://github.com/Litote/ci/commit/130bf3910fe50b3b776c5ffe62e558874f95da75))
* gradle-check sees the Gradle wrapper and properties, and never loses jvm-args ([#56](https://github.com/Litote/ci/issues/56)) ([353f428](https://github.com/Litote/ci/commit/353f4282f6e917cdf38bf42d01e9fd826303525d))

## [0.15.0](https://github.com/Litote/ci/compare/v0.14.0...v0.15.0) (2026-11-24)


### Features

* app-token action, a GitHub App token for the current repository only ([#49](https://github.com/Litote/ci/issues/49)) ([7e05946](https://github.com/Litote/ci/commit/7e059463ab447a533f3db212e7961d92c8cc8abc))
* timeouts on every job, set by inputs in gradle-check ([#54](https://github.com/Litote/ci/issues/54)) ([28b9392](https://github.com/Litote/ci/commit/28b939228eee6f6eba44ef92c9ac57f53cdfc0ec))


### Bug Fixes

* check-bot-commits requires signed commits, and checks the previous name of a renamed file ([#52](https://github.com/Litote/ci/issues/52)) ([66d0169](https://github.com/Litote/ci/commit/66d01690ed39008d5990ef8c6f7014e93d4613b0))
* commit-via-api keeps the executable bit and the symbolic links, and passes the message as is ([#51](https://github.com/Litote/ci/issues/51)) ([2356559](https://github.com/Litote/ci/commit/235655912d0a3e51013f905c4c1d1f47e409e9a4))
* detect-changes sees every commit of a push, and a match in a long list of changed files ([#50](https://github.com/Litote/ci/issues/50)) ([a7fe352](https://github.com/Litote/ci/commit/a7fe3527021b1d8324f769f4a21c83ff2d974a09))
* the GitHub App tokens created with client-id, app-id being deprecated ([#47](https://github.com/Litote/ci/issues/47)) ([aaa1a96](https://github.com/Litote/ci/commit/aaa1a9694f6d0e3d8b30780068aba162d6f29d63))
* the jvm-args of set-release-version and gradle-check written as is, even with & or | ([#53](https://github.com/Litote/ci/issues/53)) ([d3c22f0](https://github.com/Litote/ci/commit/d3c22f0ad707f3fe7cdcd90366771c524407ad2b))

## [0.14.0](https://github.com/Litote/ci/compare/v0.13.0...v0.14.0) (2026-11-24)


### Features

* upload-regenerated-files leaves out the files that git ignores ([#43](https://github.com/Litote/ci/issues/43)) ([dc33621](https://github.com/Litote/ci/commit/dc336212400a0871c92e01ecbee9162c9efb946d))

## [0.13.0](https://github.com/Litote/ci/compare/v0.12.0...v0.13.0) (2026-11-23)


### Features

* add setup-graalvm and check-native-arch actions for the native image builds ([#38](https://github.com/Litote/ci/issues/38)) ([d9fd2d5](https://github.com/Litote/ci/commit/d9fd2d5a3db8e32c89057924de692f1de42fb0b8))
* dependabot-auto-merge merges the Docker digest bumps of the same tag ([#39](https://github.com/Litote/ci/issues/39)) ([6a62ca8](https://github.com/Litote/ci/commit/6a62ca833411b43548b9aaaa5795202a6af7eefb))

## [0.12.0](https://github.com/Litote/ci/compare/v0.11.0...v0.12.0) (2026-11-19)


### Features

* add a setup-mkdocs action that installs MkDocs Material pinned with hashes ([#36](https://github.com/Litote/ci/issues/36)) ([cf7492d](https://github.com/Litote/ci/commit/cf7492d85074b177951cb358d3f8e4db54fd4bfb))

## [0.11.0](https://github.com/Litote/ci/compare/v0.10.0...v0.11.0) (2026-11-16)


### Features

* add a docker-publish action that builds multi-platform images with provenance and SBOM ([#32](https://github.com/Litote/ci/issues/32)) ([015fbdd](https://github.com/Litote/ci/commit/015fbdd7822f585947030538e1bc95331784ad72))

## [0.10.0](https://github.com/Litote/ci/compare/v0.9.0...v0.10.0) (2026-11-07)


### Features

* add a setup-terraform action pinned to an exact version ([#26](https://github.com/Litote/ci/issues/26)) ([b0cf1c1](https://github.com/Litote/ci/commit/b0cf1c1a7cf70a9d92a40e16dc1216064c0e083a))

## [0.9.0](https://github.com/Litote/ci/compare/v0.8.1...v0.9.0) (2026-11-06)


### Features

* add a guard on the commits of Dependabot pull requests ([#24](https://github.com/Litote/ci/issues/24)) ([9e64100](https://github.com/Litote/ci/commit/9e641009961c8fee753505ceb8ff95f17f606925))

## [0.8.1](https://github.com/Litote/ci/compare/v0.8.0...v0.8.1) (2026-11-06)


### Bug Fixes

* keep the pull request files off the disk of the commit job ([#22](https://github.com/Litote/ci/issues/22)) ([4a97520](https://github.com/Litote/ci/commit/4a97520fab14a1a56908f3b541d4a91a74215787))

## [0.8.0](https://github.com/Litote/ci/compare/v0.7.0...v0.8.0) (2026-11-06)


### Features

* run the Gradle verification build without secrets ([#20](https://github.com/Litote/ci/issues/20)) ([321a3d6](https://github.com/Litote/ci/commit/321a3d6fe8d5e63e7b98a1f0e2a08f83af9e2d4d))

## [0.7.0](https://github.com/Litote/ci/compare/v0.6.0...v0.7.0) (2026-11-05)


### Features

* add the options needed by kmongo-dsl ([#18](https://github.com/Litote/ci/issues/18)) ([160d972](https://github.com/Litote/ci/commit/160d972e1e9daab0a746731c24da9f755be7db67))

## [0.6.0](https://github.com/Litote/ci/compare/v0.5.0...v0.6.0) (2026-11-05)


### Features

* add setup-flutter and the Flutter goldens workflow ([#14](https://github.com/Litote/ci/issues/14)) ([1e73d1b](https://github.com/Litote/ci/commit/1e73d1bb651821cd116157bac189f39f111020d6))

## [0.5.0](https://github.com/Litote/ci/compare/v0.4.1...v0.5.0) (2026-11-04)


### Features

* add the release composite actions ([#12](https://github.com/Litote/ci/issues/12)) ([935eebc](https://github.com/Litote/ci/commit/935eebc1380d655c8e34ed815bb643eb32d96c9f))

## [0.4.1](https://github.com/Litote/ci/compare/v0.4.0...v0.4.1) (2026-11-04)


### Bug Fixes

* skip stale commits when the branch moved during regeneration ([#10](https://github.com/Litote/ci/issues/10)) ([f578378](https://github.com/Litote/ci/commit/f5783783eb43012f5867ce1088b99b382f74b05f))

## [0.4.0](https://github.com/Litote/ci/compare/v0.3.0...v0.4.0) (2026-11-04)


### Features

* add the Dependabot auto-merge workflow ([#8](https://github.com/Litote/ci/issues/8)) ([1e8b13b](https://github.com/Litote/ci/commit/1e8b13bd71894464ae2dd2c477b84c3cf2c39775))

## [0.3.0](https://github.com/Litote/ci/compare/v0.2.0...v0.3.0) (2026-11-04)


### Features

* add the Gradle verification workflow and the commit-via-api action ([#6](https://github.com/Litote/ci/issues/6)) ([24ddc59](https://github.com/Litote/ci/commit/24ddc5910a3465683c89a064223d96cbdc0a4215))

## [0.2.0](https://github.com/Litote/ci/compare/v0.1.0...v0.2.0) (2026-11-04)


### Features

* add the reusable Gradle check workflow and its composite actions ([#4](https://github.com/Litote/ci/issues/4)) ([91550a9](https://github.com/Litote/ci/commit/91550a9e7eb8e0cd9268c56b13b0427d7544ee23))

## 0.1.0 (2026-11-04)


### Documentation

* describe the releases ([#2](https://github.com/Litote/ci/issues/2)) ([4bd493f](https://github.com/Litote/ci/commit/4bd493fcd4448aa338c7c5f5de949b695d58ae83))
