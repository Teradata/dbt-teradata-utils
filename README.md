# dbt-teradata-utils

This [dbt](https://github.com/dbt-labs/dbt) package contains macros that:
- define Teradata-specific implementations of [dispatched macros](https://docs.getdbt.com/reference/dbt-jinja-functions/dispatch) from other packages

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.


## Compatibility

This package provides "shims" for:
- [dbt_utils](https://github.com/dbt-labs/dbt-utils)

In order to use these "shims," you should set a `dispatch` config in your root project (on dbt v0.20.0 and newer). For example, with this project setting, dbt will first search for macro implementations inside the `teradata_utils` package when resolving macros from the `dbt_utils` namespace:
```
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['teradata_utils', 'dbt_utils']
```

### Note to maintainers of other packages

The teradata-utils package may be able to provide compatibility for your package, especially if your package leverages dbt-utils macros for cross-database compatibility. This package _does not_ need to be specified as a dependency of your package in `packages.yml`. Instead, you should encourage anyone using your package on Teradata to:
- Install `teradata_utils` alongside your package
- Add a `dispatch` config in their root project, like the one above

### Contributing

We welcome contributions to this repo! To contribute a new feature or a fix, please open a Pull Request with 1) your changes and 2) updated documentation for the `README.md` file.
