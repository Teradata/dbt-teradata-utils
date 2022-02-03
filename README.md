# dbt-teradata-utils

This [dbt](https://github.com/dbt-labs/dbt) package contains macros that:
- define Teradata-specific implementations of [dispatched macros](https://docs.getdbt.com/reference/dbt-jinja-functions/dispatch) from other packages

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

### Additional steps for `surrogate_key` macro

`surrogate_key` macro needs an `md5` function implementation. Teradata doesn't support `md5` natively. You need to install a User Defined Function (UDF):
1. Download the md5 UDF implementation from Teradata (registration required): https://downloads.teradata.com/download/extensibility/md5-message-digest-udf.
1. Unzip the package and go to `src` directory.
1. Start up `bteq` and connect to your database.
1. Create database `GLOBAL_FUNCTIONS` that will host the UDF. You can't change the database name as it's hardcoded in the macro:
    ```sql
    CREATE DATABASE GLOBAL_FUNCTIONS AS PERMANENT = 60e6, SPOOL = 120e6;
    ```
1. Create the UDF. Replace `<CURRENT_USER>` with your current database user:
    ```sql
    GRANT CREATE FUNCTION ON GLOBAL_FUNCTIONS TO <CURRENT_USER>;
    DATABASE GLOBAL_FUNCTIONS;
    .run file = hash_md5.btq
    ```
1. Grant permissions to run the UDF to your dbt user. Replace `<DBT_USER>` with the user id you use in dbt:
    ```sql
    GRANT EXECUTE FUNCTION ON GLOBAL_FUNCTIONS TO <DBT_USER>;
    ```

## Compatibility

This package provides "shims" for:
- [dbt_utils](https://github.com/dbt-labs/dbt-utils)

In order to use these "shims," you should set a `dispatch` config in your root project (on dbt v0.20.0 and newer). For example, with this project setting, dbt will first search for macro implementations inside the `teradata_utils` package when resolving macros from the `dbt_utils` namespace:
```
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['teradata_utils', 'dbt_utils']
```

Current status:

|     Macro Group       |           Macro Name          |         Status        |                                 Comment                                |
|:---------------------:|:-----------------------------:|:---------------------:|:----------------------------------------------------------------------:|
| Schema tests          | equal_rowcount                | :white_check_mark:    | no customization needed                                                |
| Schema tests          | fewer_rows_than               | :white_check_mark:    | custom macro provided                                                  |
| Schema tests          | equality                      | :white_check_mark:    | no customization needed                                                |
| Schema tests          | expression_is_true            | :white_check_mark:    | no customization needed                                                |
| Schema tests          | recency                       | :white_check_mark:    | custom macro provided                                                  |
| Schema tests          | at_least_one                  | :white_check_mark:    | no customization needed                                                |
| Schema tests          | not_constant                  | :white_check_mark:    | no customization needed                                                |
| Schema tests          | cardinality_equality          | :white_check_mark:    | no customization needed                                                |
| Schema tests          | unique_where                  |        :x:            | no longer supported by dbt-utils, use built-in `unique` test instead   |
| Schema tests          | not_null_where                |        :x:            | no longer supported by dbt-utils, use built-in `not_null` test instead |
| Schema tests          | not_null_proportion           | :white_check_mark:    | custom macro provided                                                  |
| Schema tests          | not_accepted_values           | :white_check_mark:    | no customization needed                                                |
| Schema tests          | relationships_where           | :white_check_mark:    | no customization needed                                                |
| Schema tests          | mutually_exclusive_ranges     | :white_check_mark:    | custom macro provided                                                  |
| Schema tests          | sequential_values             | :white_check_mark:    | no customization needed                                                |
| Schema tests          | unique_combination_of_columns | :white_check_mark:    | no customization needed                                                |
| Schema tests          | accepted_range                | :white_check_mark:    | no customization needed                                                |
| Introspective macros  | get_column_values             | :white_check_mark:    | custom macro provided                                                  |
| Introspective macros  | get_relations_by_pattern      | :white_check_mark:    | custom macro provided                                                  |
| Introspective macros  | get_relations_by_prefix       | :white_check_mark:    | custom macro provided                                                  |
| Introspective macros  | get_query_results_as_dict     | :white_check_mark:    | custom macro provided                                                  |
| SQL generators        | date_spine                    | :white_check_mark:    | custom macro provided                                                  |
| SQL generators        | haversine_distance            | :white_check_mark:    | no customization needed                                                |
| SQL generators        | group_by                      | :white_check_mark:    | no customization needed                                                |
| SQL generators        | star                          | :white_check_mark:    | no customization needed                                                |
| SQL generators        | union_relations               | :white_check_mark:    | custom macro provided                                                  |
| SQL generators        | generate_series               | :white_check_mark:    | custom macro provided                                                  |
| SQL generators        | surrogate_key                 | :white_check_mark:    | custom macro provided, additional install steps required               |
| SQL generators        | safe_add                      | :white_check_mark:    | no customization needed                                                |
| SQL generators        | pivot                         |        :question:     |                                                                        |
| SQL generators        | unpivot                       |        :question:     |                                                                        |
| Web macros            | get_url_parameter             |        :question:     |                                                                        |
| Web macros            | get_url_host                  |        :question:     |                                                                        |
| Web macros            | get_url_path                  |        :question:     |                                                                        |
| Cross-database macros | current_timestamp             | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | dateadd                       | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | datediff                      |        :question:     |                                                                        |
| Cross-database macros | split_part                    |        :question:     |                                                                        |
| Cross-database macros | date_trunc                    |        :question:     |                                                                        |
| Cross-database macros | last_day                      |        :question:     |                                                                        |
| Cross-database macros | width_bucket                  |        :question:     |                                                                        |
| Jinja Helpers         | pretty_time                   |        :question:     |                                                                        |
| Jinja Helpers         | pretty_log_format             |        :question:     |                                                                        |
| Jinja Helpers         | log_info                      |        :question:     |                                                                        |
| Jinja Helpers         | slugify                       |        :question:     |                                                                        |
| Materializations      | insert_by_period              |        :question:     |                                                                        |
| Jinja Helpers         | pretty_log_format             |        :question:     |                                                                        |
| Jinja Helpers         | log_info                      |        :question:     |                                                                        |
| Jinja Helpers         | slugify                       |        :question:     |                                                                        |
| Materializations      | insert_by_period              |        :question:     |                                                                        |

### Note to maintainers of other packages

The teradata-utils package may be able to provide compatibility for your package, especially if your package leverages dbt-utils macros for cross-database compatibility. This package _does not_ need to be specified as a dependency of your package in `packages.yml`. Instead, you should encourage anyone using your package on Teradata to:
- Install `teradata_utils` alongside your package
- Add a `dispatch` config in their root project, like the one above

### Contributing

We welcome contributions to this repo! To contribute a new feature or a fix, please open a Pull Request with 1) your changes and 2) updated documentation for the `README.md` file.
