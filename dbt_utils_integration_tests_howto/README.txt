This file contains instructions on how to run the integration tests found in dbt-utils repository (https://github.com/dbt-labs/dbt-utils)
against the code in dbt-teradata-utils
The patches in the folder are necessary for running the tests against dbt-utils 1.2.0

Prerequisites for running the tests:

1. Teradata instance with grants configured for GLOBAL_FUNCTIONS.hash_md5 for the tests executing user
2. dbt configured with dbt-teradata (see listing)
-------------------------------------------------
$ dbt -v
Core:
  - installed: 1.7.16
  - latest:    1.8.2  - Update available!

  Your version of dbt-core is out of date!
  You can find instructions for upgrading here:
  https://docs.getdbt.com/docs/installation

Plugins:
  - teradata: 1.7.3 - Up to date!

-----------------------------------------------------------------
3. proper entries in ~/.dbt/profiles.yml for the Teradata instance (see listing)
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
$DBT_TB_UTILS refers to the dbt-teradata-utils repository on the local machine - the repository under test
$DBT_UTILS refers to the https://github.com/dbt-labs/dbt-utils repository on the local machine

1. Download the dbt-utils repo:
   git clone https://github.com/dbt-labs/dbt-utils.git $DBT_UTILS
2. Checkout the relevant code version in a new branch:
   cd $DBT_UTILS
   git checkout tags/1.2.0 -b main_1_2_0
3. Apply the patches in the new branch in the integration-tests folder
   cd $DBT_UTILS/integration_tests
   git apply $DBT_TB_UTILS/dbt_utils_integration_tests_howto/*patch
   !!!OBS The patches must successfully apply
4. Update $DBT_UTILS/integration_tests/packages.yml with the actual value of $DBT_TD_UTILS (see listing)
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
