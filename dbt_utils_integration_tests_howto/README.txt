This file contains instructions on how to run the integration tests found in dbt-utils repository (https://github.com/dbt-labs/dbt-utils)
against the code in dbt-teradata-utils
The patches in the folder are necessary for running the tests against dbt-utils 1.3.0

Prerequisites for running the tests:

1. Teradata instance with grants configured for GLOBAL_FUNCTIONS.hash_md5 for the tests executing user
2. dbt configured with dbt-teradata (see listing)
-------------------------------------------------
$ dbt -v
Core:
  - installed: 1.8.6
  - latest:    1.8.6 - Up to date!

Plugins:
  - teradata: 1.8.0 - Up to date!

Running the tests:
$DBT_TB_UTILS refers to the dbt-teradata-utils repository on the local machine - the repository under test
$DBT_UTILS refers to the https://github.com/dbt-labs/dbt-utils repository on the local machine

1. Download the dbt-utils repo:
   git clone https://github.com/dbt-labs/dbt-utils.git $DBT_UTILS
2. Checkout the relevant code version in a new branch:
   cd $DBT_UTILS
   git checkout tags/1.3.0 -b main_1_3_0
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
6. check macro namespace search_order is correct in $DBT_UTILS/integration_tests/dbt_project.yml (see listing)
---------------------------------------------------------
dispatch:
  - macro_namespace: 'dbt_utils'
    search_order: ['teradata_utils', 'dbt_utils_integration_tests', 'dbt_utils']
-------------------------------------------------------------
7. configure teradata profile in $DBT_UTILS/integration_tests/profiles.yml
-----------------------------------------------------------------
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

8. Run the tests
   cd $DBT_UTILS/integration_tests
   dbt build --target teradata --full-refresh
9. Verify successful execution output
