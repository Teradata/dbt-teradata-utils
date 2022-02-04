# Release process

## Git
1. Make sure you are on `main` branch:
    ```
    git checkout main
    ```
1. Verify, that `CHANGELOG.md` contains all the changes for the release.
1. Create a tag and push to origin:
    ```
    git tag v0.0.1
    git push origin --tags
    ```

## GitHub

1. Click the [Create a new release](https://github.com/Teradata/dbt-teradata-utils/releases/new) link on the project homepage in GitHub
1. Type `v{semantic_version}` as the "tag version" (e.g., `v0.0.1`)
1. Leave the "target" as `main`
1. Type `dbt-teradata-utils {semantic_version}` as the "release title" (e.g. `dbt-teradata-utils 0.0.1`)
1. Click the "publish release" button
