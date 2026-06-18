# CI/CD Scripts

This document defines the file locations and purpose of:

1. CI/CD scripts within each Git repository
2. Shareable CI/CD scripts (to be `source`d) in the `loopback/cicd` Git repository

## Repository-Specific CI/CD Scripts

### Rationale

<table>
  <thead>
    <tr>
      <td>Rationale</td>
      <td>Description</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Flexibility</td>
      <td>NPM Scripts are useful for one-liners. However, test harnesses are typically more complex, and NPM Scripts designed for test harnesses may not be ideal for developer experience. Discrete CI/CD scripts provide the flexibility and independence needed to accomodate the bespoke requirements of CI/CD pipelines.</td>
    <tr>
      <td>Cross-testing</td>
      <td>
        The LoopBack project has NPM packages that span across several Git repositories. Some of these packages are dependents or dependencies of each other. Hence, there is a need to support cross-testing with each other.<br>
        For example, the dependency chain `loopback-connector-db2`->`loopback-ibmdb`->`loopback-datasource-juggler` means that making a change in one of these packages may break the other packages. Cross-testing is manatory to reduce the likelihood of breakage.<br>
        Furthermore, we have to test both directions of the dependency chain, "upstream" (dependencies) and "downstream" (dependents), and we must test across supported major versions due to the adoption of the Module LTS policy.
      </td>
    </tr>
    <tr>
      <td>CI-agnostism</td>
      <td>LoopBack uses a [mixture of CI/CD services](./cicd-services.md). This is means that usage of CI/CD service-specific configuration should be kept to a minimum to reduce redundant authoring.</td>
    </tr>
    <tr>
      <td>Ease of Bootstrap</td>
      <td>
        Performing certain actions as part of CI/CD actions (e.g. testing) may require setup that's unique for that Git Repository.<br>
        The purpose of repo-specific CI/CD scripts is to perform well-defined actions in a single line. 
      </td>
    </tr>
  </tbody>
</table>

### File Locations

| Location                           | Remarks                                                                                       |
|------------------------------------|-----------------------------------------------------------------------------------------------|
| `/cicd/*`                          | All CI/CD resources (scripts, submodules, supporting files) MUST be stored in this directory  |
| `/cicd/well-known/*.sh`            | MUST contain only scripts defined in this document                                            |
| `/cicd/well-known/*-supplements/*` | Internal supplementary files for well-known scripts                                          |
| `/cicd/well-known/set-env/*.sh`    | MUST contain only scripts defined in this document. Intended to be `source`d to set env vars. |
| `/cicd/vendor/*`                   | Internal Git submodules for well-known scripts                                                |

| Well-Known Scripts          | Input Env Vars              | Required? | Remarks                                                        |
|-----------------------------|-----------------------------|-----------|----------------------------------------------------------------|
| `prepare-autoinstall.sh`    |                             | Yes       |                                                                |
| `test-harness-setup-env.sh` | `CI_NODEJS_AUTOINSTALL_DIR` | Yes       | Setup environment for test harness (database, `npm ci`, etc.)  |
| `test-harness.sh`           |                             | Yes       | MUST NOT be execued before `test-harness-setup-env.sh` script. |
| `test-harness-cleanup.sh`   |                             | No        | Cleanup environment (e.g. database containers)                 |

| Well-Known `set-env` Scripts  | Output Env Vars             | Required? | Remarks                                                    |
|-------------------------------|-----------------------------|-----------|------------------------------------------------------------|
| `post-prepare-autoinstall.sh` | `CI_NODEJS_AUTOINSTALL_DIR` | Yes       | MUST NOT be execued before `prepare-autoinstall.sh` script |

| Env Vars                    | Remarks                                                                               | Producer                 | Consumer |
|-----------------------------|---------------------------------------------------------------------------------------|--------------------------|----------|
| `CI_NODEJS_AUTOINSTALL_DIR` | `PATH`-style list of directories contianing `.tgz` archives generated from `npm pack` | `prepare-autoinstall.sh` |          |

## Shareable CI/CD Scripts

| Script      | Internal Fn/Var Prefix | Public Fn/Var                               |
|-------------|------------------------|---------------------------------------------|
| `common.sh` | `__CI_COMMON`          | `ORIG_DIR`, `BASE_DIR`, `step`, `mktempdir` |
