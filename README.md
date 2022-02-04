# dbt package `teradata_utils`

This [dbt](https://github.com/dbt-labs/dbt) package provides compatibility with `dbt_utils` package for Teradata Vantage.

## Installation Instructions

1. Add the package as a dependency to your project in `packages.yml`:
    ```
    packages:
    - package: teradata/teradata_utils
      version: 0.1.0
    ```
    For more information about installing packages, see [dbt documentation](https://docs.getdbt.com/docs/package-management).
1. Set the `dispatch` config in your root project (on dbt v0.20.0 and newer) and let `teradata_utils` package intercept macros from the `dbt_utils` namespace:
    ```
    dispatch:
      - macro_namespace: dbt_utils
        search_order: ['teradata_utils', 'dbt_utils']
    ```

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
| SQL generators        | surrogate_key                 | :white_check_mark:    | custom macro provided, [additional install steps required](#additional-steps-for-surrogate_key-macro)               |
| SQL generators        | safe_add                      | :white_check_mark:    | no customization needed                                                |
| SQL generators        | pivot                         | :white_check_mark:    | no customization needed                                                |
| SQL generators        | unpivot                       | :white_check_mark:    | no customization needed, see [compatibility note](#unpivot)            |
| Web macros            | get_url_parameter             | :white_check_mark:    | no customization needed                                                |
| Web macros            | get_url_host                  | :white_check_mark:    | no customization needed                                                |
| Web macros            | get_url_path                  | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | current_timestamp             | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | dateadd                       | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | datediff                      | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | split_part                    | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | date_trunc                    | :white_check_mark:    | custom macro provided                                                  |
| Cross-database macros | last_day                      | :white_check_mark:    | no customization needed, see [compatibility note](#last_day)           |
| Cross-database macros | width_bucket                  | :white_check_mark:    | no customization needed                                                |
| Jinja Helpers         | pretty_time                   | :white_check_mark:    | no customization needed                                                |
| Jinja Helpers         | pretty_log_format             | :white_check_mark:    | no customization needed                                                |
| Jinja Helpers         | log_info                      | :white_check_mark:    | no customization needed                                                |
| Jinja Helpers         | slugify                       | :white_check_mark:    | no customization needed                                                |
| Materializations      | insert_by_period              |        :x:            | no plans to implement, please submit an issue if you need it           |


### <a name="unpivot"></a>unpivot

`unpivot` uses `value` as the default name for the value column. `value` is a reserved word in Teradata. Make sure you specify a different value in `value_name` parameter, e.g.:
```
{{ 
  dbt_utils.unpivot(
    relation=ref('table_name'),
    cast_to='datatype',
    exclude=[<list of columns to exclude from unpivot>],
    remove=[<list of columns to remove>],
    field_name=<column name for field>,
    value_name='_value'
  ) 
}}
```

### <a name="last_day"></a>last_day

`last_day` in `teradata_utils`, unlike the corresponding macro in `dbt_utils`, doesn't support `quarter` datepart.
### Note to maintainers of other packages

The teradata-utils package may be able to provide compatibility for your package, especially if your package leverages dbt-utils macros for cross-database compatibility. This package _does not_ need to be specified as a dependency of your package in `packages.yml`. Instead, you should encourage anyone using your package on Teradata to:
- Install `teradata_utils` alongside your package
- Add a `dispatch` config in their root project, like the one above

### Contributing

We welcome contributions to this repo! To contribute a new feature or a fix, please open a Pull Request with 1) your changes and 2) updated documentation for the `README.md` file.
