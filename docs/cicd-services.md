# CI/CD Services

This document provides informtaion on the CI/CD services available to the LoopBack project.

## CI/CD Service Matrix

These matrixes act as a rough guideline on which CI/CD service is used with what configuration, and rationale for unused configurations.

### Actively Used

| CI             | CPU Arch | OS      | Docker?  | Env             | SSH Access | Remarks                                                                            |
|----------------|----------|---------|----------|-----------------|------------|------------------------------------------------------------------------------------|
| GitHub Actions | x86-64   | Ubuntu  | Yes      | Virtual machine | No         |                                                                                    |
| GitHub Actions | x86-64   | macOS   | No       | Virtual machine | No         | No Docker support OOTB (manual install too slow), hence not used by ORM connectors |
| AppVeyor       | x86-64   | Windows | Yes      | Virtual machine | Unknown    |                                                                                    |
| Travis CI      | arm      | Ubuntu  | Limited^ | LXD             | No         |                                                                                    |
| Travis CI      | ppc64le  | Ubuntu  | Limited^ | LXD             | No         |                                                                                    |
| Travis CI      | s390x    | Ubuntu  | Limited^ | LXD             | No         |                                                                                    |

^LXD containers have stricter limitations such as smaller SUID/GUID pool

### Available but Unused

| CI/CD Service  | CPU Arch | OS      | Remarks                                                    |
|----------------|----------|---------|------------------------------------------------------------|
| GitHub Actions | x86-64   | Windows | No Docker support                                          |
| GitHub Actions | arm      | Ubuntu  | Not available for FOSS yet                                 |
| GitHub Actions | x86-64   | macOS   |                                                            |
| GitHub Actions | arm      | macOS   | No Docker support (No nested virtualisation in M1)         |
| Travis CI      | x86-64   | Any     | Uses credits, which requires Customer Support to replenish |

## Security

### Secrets Management

No long-term secrets are stored in the CI/CD services. However, there is no service to continously prove this as true at this moment.

GitHub Actions exposes `GITHUB_TOKEN` which is restricted with top-level `permisions: {}`. Permissions are added on a as-needed basis. Known cases where elevated permissions are given:

- GitHub CodeQL
- Pipeline publishing (Not ready yet)

### Security Against Untrusted PRs and Forks

Security features:

| Feature \ CI/CD Service                   | GitHub Actions                                                                                                                                                                                                                               | Travis CI (excl. dpl)                                                                    | AppVeyor | Remarks                                                        |
|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|----------|----------------------------------------------------------------|
| Require Approval for outside contributors | Yes                                                                                                                                                                                                                                          | No                                                                                       | No       |                                                                |
| No secrets exposed on fork runs           | [Yes (enforced)](https://github.com/github/docs/blob/bc905e2b1be277e49445aa6ba80a2afc04b2cfc2/content/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions.md#potential-impact-of-a-compromised-runner) | [Yes](https://changelog.travis-ci.com/git-repository-security-settings-for-forks-224005) | ?        |                                                                |
| Ephemeral token                           | Yes (manual) (`GITHUB_TOKEN`)                                                                                                                                                                                                                | No                                                                                       | ?        | Enable verification that a request came from a CI pipeline run |
| Ephemeral GitHub token                    | Yes (enforced)                                                                                                                                                                                                                               | N/A                                                                                      | ?        |                                                                |
| Restricted GitHub token                   | Yes (manual)                                                                                                                                                                                                                                 | N/A                                                                                      | ?        |                                                                |
| Network Restriction                       | Yes (manual) ([Step Security Harden Runner](https://github.com/step-security/harden-runner))                                                                                                                                                 | No                                                                                       | No       | Mitigate data exfiltration                                     |

Legend:
- **?:** Unknown.
- **N/A:** Not applicable to that CI/CD platform; Hence no additional security risk.
- **No:** No such security mechanism available on CI/CD platform.
- **Yes (enforced):** Enforced by the the CI/CD platform without additional configuration.
- **Yes (manual):** Enforced through manual, non-centralised configuration.
- **Yes (centralised):** Enforced through centralised configuration via `loopback/cicd` CI pipelines.

Based on the feature list above, CI/CD services do not provide sufficient security boundaries against secret exfiltration.

### Recommendations

- **Long-term secrets MUST NOT be made available to CI/CD pipeline environments**
- **For non-critical services, use ephemeral tokens for non-critical services** that SHOULD only last for the duration of the CI/CD pipeline run or expire quickly.
- **For critical services (e.g. publishing), use short-lived tokens with out-of-band 2FA** to ensure that an additional, out-of-pipeline authentication factor is required.
