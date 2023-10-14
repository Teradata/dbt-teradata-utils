This file contains instructions on how to run the integration tests found in dbt-utils repository (https://github.com/dbt-labs/dbt-utils)
against the code in dbt-teradata-utils
The patches in the folder are necessary for running the tests against dbt-utils 1.1.1

Prerequisites for running the tests:

1. Teradata instance with grants configured for the test executing user GLOBAL_FUNCTIONS.hash_md5
2. dbt configured with dbt-teradata as in listing in an python venv
-------------------------------------------------
$ dbt -v
Core:
  - installed: 1.6.2
  - latest:    1.6.6 - Update available!

  Your version of dbt-core is out of date!
  You can find instructions for upgrading here:
  https://docs.getdbt.com/docs/installation

Plugins:
  - teradata: 1.0.0 - Not compatible!

  At least one plugin is out of date or incompatible with dbt-core.
  You can find instructions for upgrading here:
  https://docs.getdbt.com/docs/installation
-----------------------------------------------------------------
3. proper entries in ~/.dbt/profiles.yml for the Teradata instance as in listing
----------------------------------------------------------------
config:
    send_anonymous_usage_stats: False
    use_colors: True

integration_tests:
  target: teradata
  outputs:
    teradata:
      type: teradata
      host: <the host>
      user: <the user>
      password: <the pass>
      logmech: TD2
      schema: <the schema name>
      tmodei: ANSI
      threads: 1
      timeout_seconds: 300
      priority: interactive
      retries: 1
-------------------------------------------------------------------------------

Running the tests:
$DBT_TB_UTILS points to the dbt-teradata-utils repository on the local machine - the repository under test
$DBT_UTILS points to the https://github.com/dbt-labs/dbt-utils repository from the local machine

1. Download the dbt-utils repo:
   git clone https://github.com/dbt-labs/dbt-utils.git $DBT_UTILS
2. Checkout the relevant code version in a new branch:
   cd $DBT_UTILS
   git checkout tags/1.1.1 -b main_1_1_1
3. Apply the patches in the new branch in the integration-tests folder
   cd $DBT_UTILS/integration_tests
   git apply $DBT_TB_UTILS/dbt_utils_integration_tests_howto/*patch
   !!!OBS The patches must successfully apply
4. Update $DBT_UTILS/integration_tests/packages.yml with the actual value of $DBT_TD_UTILS (see listing below)
   cd $DBT_UTILS/integration_tests
-----------------------------------------------------------------------------------------
$ cat packages.yml

packages:
    - local: ../
    - local: $DBT_TD_UTILS
---------------------------------------------------------------------------------------------
5. Install the dbt packages
   cd $DBT_UTILS/integration_tests
   dbt deps
6. check macro namespace search_order is correct in $DBT_UTILS/dbt_project.yml (see listing)
---------------------------------------------------------
dispatch:
  - macro_namespace: 'dbt_utils'
    search_order: ['teradata_utils', 'dbt_utils_integration_tests', 'dbt_utils']
-------------------------------------------------------------
7. Run the tests
   cd $DBT_UTILS/integration_tests
   dbt build --target teradata --full-refresh
8. Verify successful execution output (see listing)
-------------------------------------------------------------
13:44:12  Finished running 36 view models, 11 table models, 67 seeds, 99 tests in 0 hours 1 minutes and 38.71 seconds (98.71s).
13:44:12
13:44:12  Completed successfully
13:44:12
13:44:12  Done. PASS=213 WARN=0 ERROR=0 SKIP=0 TOTAL=213
------------------------------------------------------------