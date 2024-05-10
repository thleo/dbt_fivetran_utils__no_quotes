# Fivetran Utilities for dbt

> ## ⚠️ Warning! ⚠️
>
> You are viewing a deprecated branch, which is no longer maintained and not recommended for use. This branch remains the default branch to prevent breaking changes to any existing dbt projects that use this package. 
>
> To view the current release branch, please refer to the [release list](https://github.com/fivetran/dbt_fivetran_utils/releases).

This package includes macros that are used in Fivetran's dbt packages.

## Macros
### _get_utils_namespaces ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/_get_utils_namespaces.sql))
This macro allows for namespacing macros throughout a dbt project. The macro currently consists of two namespaces:
- `dbt_utils`
- `fivetran_utils__no_quotes`

----
### add_pass_through_columns ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/add_pass_through_columns.sql))
This macro creates the proper name, datatype, and aliasing for user defined pass through column variable. This
macro allows for pass through variables to be more dynamic and allow users to alias custom fields they are 
bringing in. This macro is typically used within staging models of a fivetran dbt source package to pass through
user defined custom fields.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.add_pass_through_columns(base_columns=columns, pass_through_var=var('hubspot__deal_pass_through_columns')) }}
```
**Args:**
* `base_columns` (required): The name of the variable where the base columns are contained. This is typically `columns`.
* `pass_through_var` (required): The variable which contains the user defined pass through fields.

----
### array_agg ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/array_agg.sql))
This macro allows for cross database field aggregation. The macro contains the database specific field aggregation function for 
BigQuery, Snowflake, Redshift, and Postgres. By default a comma `,` is used as a delimiter in the aggregation.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.array_agg(field_to_agg="teams") }}
```
**Args:**
* `field_to_agg` (required): Field within the table you are wishing to aggregate.

----
### ceiling ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/ceiling.sql))
This macro allows for cross database use of the ceiling function. The ceiling function returns the smallest integer greater 
than, or equal to, the specified numeric expression. The ceiling macro is compatible with BigQuery, Redshift, Postgres, and Snowflake.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.ceiling(num="target/total_days") }}
```
**Args:**
* `num` (required): The integer field you wish to apply the ceiling function.

----
### collect_freshness ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/collect_freshness.sql))
This macro overrides dbt's default [`collect_freshness` macro](https://github.com/fishtown-analytics/dbt/blob/0.19.latest/core/dbt/include/global_project/macros/adapters/common.sql#L257-L273) that is called when running `dbt source snapshot-freshness`. It allows you to incorporate model enabling/disabling variables into freshness tests, so that, if a source table does not exist, dbt will not run (and error on) a freshness test on the table. **Any package that has a dependency on fivetran_utils__no_quotes will use this version of the macro. If no `meta.is_enabled` field is provided, the `collect_freshness` should run exactly like dbt's default version.**

**Usage:**
```yml
# in the sources.yml
sources:
  - name: source_name
    freshness:
      warn_after: {count: 84, period: hour}
      error_after: {count: 168, period: hour}
    tables:
      - name: table_that_might_not_exist
        meta:
          is_enabled: "{{ var('package__using_this_table', true) }}"
```
**Args (sorta):**
* `meta.is_enabled` (optional): The variable(s) you would like to reference to determine if dbt should include this table in freshness tests.

----
### dummy_coalesce_value ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/dummy_coalesce_value.sql))
This macro creates a dummy coalesce value based on the data type of the field. See below for the respective data type and dummy values:
- String    = 'DUMMY_STRING'
- Boolean   = null
- Int       = 999999999
- Float     = 999999999.99
- Timestamp = cast("2099-12-31" as timestamp)
- Date      = cast("2099-12-31" as date)
**Usage:**
```sql
{{ fivetran_utils__no_quotes.dummy_coalesce_value(column="user_rank") }}
```
**Args:**
* `column` (required): Field you are applying the dummy coalesce.

----
### empty_variable_warning ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/empty_variable_warning.sql))
This macro checks a declared variable and returns an error message if the variable is empty before running the models within the `dbt_project.yml` file.

**Usage:**
```yml
on-run-start: '{{ fivetran_utils__no_quotes.empty_variable_warning(variable="ticket_field_history_columns", downstream_model="zendesk_ticket_field_history") }}'
```
**Args:**
* `variable`            (required): The variable you want to check if it is empty.
* `downstream_model`    (required): The downstream model that is affected if the variable is empty.

----
### enabled_vars_one_true ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/enabled_vars_one_true.sql))
This macro references a set of specified boolean variable and returns `true` if any variable value is equal to true.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.enabled_vars_one_true(vars=["using_department_table", "using_customer_table"]) }}
```
**Args:**
* `vars` (required): Variable(s) you are referencing to return the declared variable value.

----

### enabled_vars ([source](https://github.com/fivetran/dbt_fivetran_utils/edit/master/macros/enabled_vars.sql))
This macro references a set of specified boolean variable and returns `false` if any variable value is equal to false.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.enabled_vars(vars=["using_department_table", "using_customer_table"]) }}
```
**Args:**
* `vars` (required): Variable you are referencing to return the declared variable value.

----

### fill_pass_through_columns ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/fill_pass_through_columns.sql))
This macro is used to generate the correct sql for package staging models for user defined pass through columns.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.fill_pass_through_columns(pass_through_variable='hubspot__contact_pass_through_columns') }}
```
**Args:**
* `pass_through_variable` (required): Name of the variable which contains the respective pass through fields for the staging model.

----
### fill_staging_columns ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/fill_staging_columns.sql))
This macro is used to generate the correct SQL for package staging models. It takes a list of columns that are expected/needed (`staging_columns`) 
and compares it with columns in the source (`source_columns`). 

**Usage:**
```sql
select

    {{
        fivetran_utils__no_quotes.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(ref('stg_twitter_ads__account_history_tmp')),
            staging_columns=get_account_history_columns()
        )
    }}

from source
```
**Args:**
* `source_columns`  (required): Will call the [get_columns_in_relation](https://docs.getdbt.com/reference/dbt-jinja-functions/adapter/#get_columns_in_relation) macro as well requires a `ref()` or `source()` argument for the staging models within the `_tmp` directory.
* `staging_columns` (required): Created as a result of running the [generate_columns_macro](https://github.com/fivetran/dbt_fivetran_utils#generate_columns_macro-source) for the respective table.

----
### first_value ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/first_value.sql))
This macro returns the value_expression for the first row in the current window frame with cross db functionality. This macro ignores null values. The default first_value calculation within the macro is the `first_value` function. The Redshift first_value calculation is the `first_value` function, with the inclusion of a frame_clause `{{ partition_field }} rows unbounded preceding`.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.first_value(first_value_field="created_at", partition_field="id", order_by_field="created_at", order="asc") }}
```
**Args:**
* `first_value_field` (required): The value expression which you want to determine the first value for.
* `partition_field`   (required): Name of the field you want to partition by to determine the first_value.
* `order_by_field`    (required): Name of the field you wish to sort on to determine the first_value.
* `order`             (optional): The order of which you want to partition the window frame. The order argument by default is `asc`. If you wish to get the last_value, you may change the argument to `desc`.

----
### generate_columns_macro ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/generate_columns_macro.sql))
This macro is used to generate the macro used as an argument within the [fill_staging_columns](https://github.com/fivetran/dbt_fivetran_utils#fill_staging_columns-source) macro which will list all the expected columns within a respective table. The macro output will contain `name` and `datatype`; however, you may add an optional argument for `alias` if you wish to rename the column within the macro. 

The macro should be run using dbt's `run-operation` functionality, as used below. It will print out the macro text, which can be copied and pasted into the relevant `macro` directory file within the package.

**Usage:**
```
dbt run-operation fivetran_utils__no_quotes.generate_columns_macro --args '{"table_name": "promoted_tweet_report", "schema_name": "twitter_ads", "database_name": "dbt-package-testing"}'
```
**Output:**
```sql
{% macro get_admin_columns() %}

{% set columns = [
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "admin_id"},
    {"name": "job_title", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
```
**Args:**
* `table_name`    (required): Name of the schema which the table you are running the macro for resides in.
* `schema_name`   (required): Name of the schema which the table you are running the macro for resides in.
* `database_name` (optional): Name of the database which the table you are running the macro for resides in. If empty, the macro will default this value to `target.database`.

----
### get_columns_for_macro ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/get_columns_for_macro.sql))
This macro returns all column names and datatypes for a specified table within a database and is used as part of the [generate_columns_macro](macros/generate_columns_macro.sql).

**Usage:**
```sql
{{ fivetran_utils__no_quotes.get_columns_for_macro(table_name="team", schema_name="my_teams", database_name="my_database") }}
```
**Args:**
* `table_name`    (required): Name of the table you are wanting to return column names and datatypes.
* `schema_name`   (required): Name of the schema where the above mentioned table resides.
* `database_name` (optional): Name of the database where the above mentioned schema and table reside. By default this will be your target.database.

----
### json_extract ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/json_extract.sql))
This macro allows for cross database use of the json extract function. The json extract allows the return of data from a json object.
The data is returned by the path you provide as the argument. The json_extract macro is compatible with BigQuery, Redshift, Postgres, and Snowflake.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.json_extract(string="value", string_path="in_business_hours") }}
```
**Args:**
* `string` (required): Name of the field which contains the json object.
* `string_path`  (required): Name of the path in the json object which you want to extract the data from.

----
### json_parse ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/json_parse.sql))
This macro allows for cross database use of the json extract function, specifically used to parse and extract a nested value from a json object.
The data is returned by the path you provide as the list within the `string_path` argument. The json_parse macro is compatible with BigQuery, Redshift, Postgres, Snowflake and Databricks.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.json_parse(string="receipt", string_path=["charges","data",0,"balance_transaction","exchange_rate"]) }}
```
**Args:**
* `string` (required): Name of the field which contains the json object.
* `string_path`  (required): List of item(s) that derive the path in the json object which you want to extract the data from.

----
### pivot_json_extract ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/pivot_json_extract.sql))
This macro builds off of the `json_extract` macro in order to extract a list of fields from a json object and pivot the fields out into columns. The `pivot_json_extract` macro is compatible with BigQuery, Redshift, Postgres, and Snowflake.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.pivot_json_extract(string="json_value", list_of_properties=["field 1", "field 2"]) }}
```
**Args:**
* `string` (required): Name of the field which contains the json object.
* `list_of_properties`  (required): List of the fields that you want to extract from the json object and pivot out into columns. Any spaces will be replaced by underscores in column names.

----
### max_bool ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/max_bool.sql))
This macro allows for cross database use of obtaining the max boolean value of a field. This macro recognizes true = 1 and false = 0. The macro will aggregate the boolean_field and return the max boolean value. The max_bool macro is compatible with BigQuery, Redshift, Postgres, and Snowflake.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.max_bool(boolean_field="is_breach") }}
```
**Args:**
* `boolean_field` (required): Name of the field you are obtaining the max boolean record from.

----
### percentile ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/percentile.sql))
This macro is used to return the designated percentile of a field with cross db functionality. The percentile function stems from percentile_cont across db's. For Snowflake and Redshift this macro uses the window function opposed to the aggregate for percentile.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.percentile(percentile_field='time_to_close', partition_field='id', percent='0.5') }}
```
**Args:**
* `percentile_field` (required): Name of the field of which you are determining the desired percentile.
* `partition_field`  (required): Name of the field you want to partition by to determine the designated percentile.
* `percent`          (required): The percent necessary for `percentile_cont` to determine the percentile. If you want to find the median, you will input `0.5` for the percent. 

----
### remove_prefix_from_columns ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/remove_prefix_from_columns.sql))
This macro removes desired prefixes from specified columns. Additionally, a for loop is utilized which allows for adding multiple columns to remove prefixes.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.remove_prefix_from_columns(columns="names", prefix='', exclude=[]) }}
```
**Args:**
* `columns` (required): The desired columns you wish to remove prefixes.
* `prefix`  (optional): The prefix the macro will search for and remove. By default the prefix = ''.
* `exclude` (optional): The columns you wish to exclude from this macro. By default no columns are excluded.

----
### snowflake_seed_data ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/snowflake_seed_data.sql))
This macro is intended to be used when a source table column is a reserved keyword in Snowflake, and Circle CI is throwing a fit.
It simply chooses which version of the data to seed (the Snowflake copy should capitalize and put three pairs of quotes around the problematic column).

***Usage:**
```yml
    # in integration_tests/dbt_project.yml
    vars:
        table_name: "{{ fivetran_utils__no_quotes.snowflake_seed_data(seed_name='user_data') }}"
```
**Args:**
* `seed_name` (required): Name of the seed that has separate snowflake seed data.

----
### seed_data_helper ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/seed_data_helper.sql))
This macro is intended to be used when a source table column is a reserved keyword in a warehouse, and Circle CI is throwing a fit.
It simply chooses which version of the data to seed. Also note the `warehouses` argument is a list and multiple warehouses may be added based on the number of warehouse
specific seed data files you need for integration testing.

***Usage:**
```yml
    # in integration_tests/dbt_project.yml
    vars:
        table_name: "{{ fivetran_utils__no_quotes.seed_data_helper(seed_name='user_data', warehouses=['snowflake', 'postgres']) }}"
```
**Args:**
* `seed_name` (required): Name of the seed that has separate postgres seed data.
* `warehouses` (required): List of the warehouses for which you want CircleCi to use the helper seed data.

----
### staging_models_automation ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/staging_models_automation.sql))
This macro is intended to be used as a `run-operation` when generating Fivetran dbt source package staging models/macros. This macro will receive user input to create all necessary ([bash commands](columns_setup.sh)) appended with `&&` so they may all be ran at once. The output of this macro within the CLI will then be copied and pasted as a command to generate the staging models/macros.
**Usage:**
```bash
dbt run-operation staging_models_automation --args '{package: asana, source_schema: asana_source, source_database: database-source-name, tables: ["user","tag"]}'
```
**CLI Output:**
```bash
source dbt_modules/fivetran_utils__no_quotes/columns_setup.sh '../dbt_asana_source' stg_asana dbt-package-testing asana_2 user && 
source dbt_modules/fivetran_utils__no_quotes/columns_setup.sh '../dbt_asana_source' stg_asana dbt-package-testing asana_2 tag
```
**Args:**
* `package`         (required): Name of the package for which you are creating staging models/macros.
* `source_schema`   (required): Name of the source_schema from which the bash command will query.
* `source_database` (required): Name of the source_database from which the bash command will query.
* `tables`          (required): List of the tables for which you want to create staging models/macros.

----
### string_agg ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/string_agg.sql))
This macro allows for cross database field aggregation and delimiter customization. Supported database specific field aggregation functions include 
BigQuery, Snowflake, Redshift.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.string_agg(field_to_agg="issues_opened", delimiter='|') }}
```
**Args:**
* `field_to_agg` (required): Field within the table you are wishing to aggregate.
* `delimiter`    (required): Character you want to be used as the delimiter between aggregates.
----
### timestamp_add ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/timestamp_add.sql))
This macro allows for cross database addition of a timestamp field and a specified datepart and interval for BigQuery, Redshift, Postgres, and Snowflake.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.timestamp_add(datepart="day", interval="1", from_timestamp="last_ticket_timestamp") }}
```
**Args:**
* `datepart`       (required): The datepart you are adding to the timestamp field.
* `interval`       (required): The interval in relation to the datepart you are adding to the timestamp field.
* `from_timestamp` (required): The timestamp field you are adding the datepart and interval.

----
### timestamp_diff ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/timestamp_diff.sql))
This macro allows for cross database timestamp difference calculation for BigQuery, Redshift, Postgres, and Snowflake.

**Usage:**
```sql
{{ fivetran_utils__no_quotes.timestamp_diff(first_date="first_ticket_timestamp", second_date="last_ticket_timestamp", datepart="day") }}
```
**Args:**
* `first_date`       (required): The first timestamp field for the difference calculation.
* `second_date`      (required): The second timestamp field for the difference calculation.
* `datepart`         (required): The date part applied to the timestamp difference calculation.

----
### union_relations ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/union_relations.sql))
This macro unions together an array of [Relations](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation),
even when columns have differing orders in each Relation, and/or some columns are
missing from some relations. Any columns exclusive to a subset of these
relations will be filled with `null` where not present. An new column
(`_dbt_source_relation`) is also added to indicate the source for each record.

**Usage:**
```sql
{{ dbt_utils.union_relations(
    relations=[ref('my_model'), source('my_source', 'my_table')],
    exclude=["_loaded_at"]
) }}
```
**Args:**
* `relations`          (required): An array of [Relations](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation).
* `aliases`            (optional): An override of the relation identifier. This argument should be populated with the overwritten alias for the relation. If not populated `relations` will be the default.
* `exclude`            (optional): A list of column names that should be excluded from the final query.
* `include`            (optional): A list of column names that should be included in the final query. Note the `include` and `exclude` parameters are mutually exclusive.
* `column_override`    (optional): A dictionary of explicit column type overrides, e.g. `{"some_field": "varchar(100)"}`.``
* `source_column_name` (optional): The name of the column that records the source of this row. By default this argument is set to `none`.

----
### union_data ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/union_data.sql))
This macro unions together tables of the same structure so that users can treat data from multiple connectors as the 'source' to a package.
Depending on which macros are set, it will either look for schemas of the same name across multiple databases, or schemas with different names in the same database.

If the `var` with the name of the `schema_variable` argument is set, the macro will union the `table_identifier` tables from each respective schema within the target database (or source database if set by a variable).
If the `var` with the name of the `database_variable` argument is set, the macro will union the `table_identifier` tables from the source schema in each respective database.

When using this functionality, every `_tmp` table should use this macro as described below.

**Usage:**
```sql
{{
    fivetran_utils__no_quotes.union_data(
        table_identifier='customer', 
        database_variable='shopify_database', 
        schema_variable='shopify_schema', 
        default_database=target.database,
        default_schema='shopify',
        default_variable='customer_source'
    )
}}
```
**Args:**
* `table_identifier`: The name of the table that will be unioned.
* `database_variable`: The name of the variable that users can populate to union data from multiple databases.
* `schema_variable`: The name of the variable that users can populate to union data from multiple schemas.
* `default_database`: The default database where source data should be found. This is used when unioning schemas.
* `default_schema`: The default schema where source data should be found. This is used when unioning databases.
* `default_variable`: The name of the variable that users should populate when they want to pass one specific relation to this model (mostly used for CI)

----
### source_relation ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/macros/source_relation.sql))
This macro creates a new column that signifies with database/schema a record came from when using the `union_data` macro above. 
It should be added to all non-tmp staging models when using the `union_data` macro. 

**Usage:**
```sql
{{ fivetran_utils__no_quotes.source_relation() }}
```

## Bash Scripts
### columns_setup.sh ([source](https://github.com/fivetran/dbt_fivetran_utils/blob/master/columns_setup.sh))

This bash file can be used to setup or update packages to use the `fill_staging_columns` macro above. The bash script does the following three things:

* Creates a `.sql` file in the `macros` directory for a source table and fills it with all the columns from the table.
    * Be sure your `dbt_project.yml` file does not contain any **Warnings** or **Errors**. If warnings or errors are present, the messages from the terminal will be printed above the macro within the `.sql` file in the `macros` directory.
* Creates a `..._tmp.sql` file in the `models/tmp` directory and fills it with a `select * from {{ var('table_name') }}` where `table_name` is the name of the source table.
* Creates or updates a `.sql` file in the `models` directory and fills it with the filled out version of the `fill_staging_columns` macro as shown above. You can then write whatever SQL you want around the macro to finishing off the staging file.

The usage is as follows, assuming you are executing via a `zsh` terminal and in a dbt project directory that has already imported this repo as a dependency:
```bash
source dbt_modules/fivetran_utils__no_quotes/columns_setup.sh "path/to/directory" file_prefix database_name schema_name table_name
```

As an example, assuming we are in a dbt project in an adjacent folder to `dbt_marketo_source`:
```bash
source dbt_modules/fivetran_utils__no_quotes/columns_setup.sh "../dbt_marketo_source" stg_marketo "digital-arbor-400" marketo_v3 deleted_program_membership
```

In that example, it will:
* Create a `get_deleted_program_membership_columns.sql` file in the `macros` directory, with the necessary macro within it.
* Create a `stg_marketo__deleted_program_membership_tmp.sql` file in the `models/tmp` directory, with `select * from {{ var('deleted_program_membership') }}` in it.
* Create or update a `stg_marketo__deleted_program_membership.sql` file in the `models` directory with the pre-filled out `fill_staging_columns` macro.
