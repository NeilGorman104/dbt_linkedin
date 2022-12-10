# dbt_linkedin_ads v0.6.1
[PR #24](https://github.com/fivetran/dbt_linkedin/pull/24) includes the following changes:
## 🎉 Features 🎉
- Added ability for a user to allow records having nulls in url fields to be included in the `linkedin_ads__url_report` model. This is done by setting one of the variables below to `True` in your `dbt_project.yml` file. 
- Note that using the variable `allow_ad_reporting_null_urls` will allow records with null urls for ALL Fivetran ad packages included in your project.
```yml
vars:
  allow_linkedin_ads_null_urls: True # Use this variable to allow null urls for dbt_linkedin_ads only. Default is False. 
  allow_ad_reporting_null_urls: True # Use this variable to allow null urls for ALL Fivetran ad packages included in your project. Default is False. 
```
- Updated README with this information. 
## 🚘 Under the Hood 🚘
- Disabled the `not_null` test for `linkedin_ads__url_report` when null urls are allowed.

# dbt_linkedin v0.6.0

## 🚨 Breaking Changes 🚨:
[PR #22](https://github.com/fivetran/dbt_linkedin/pull/22) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_linkedin v0.5.0

PR [#21](https://github.com/fivetran/dbt_linkedin/pull/21) includes the following changes:

## 🚨 Breaking Changes 🚨
- **ALL** models and **ALL** variables now have the prefix `linkedin_ads_*`. They previously were prepended with `linkedin_*`. This includes the required schema and database variables. We made this change to better discern between Linkedin Ads and [Linkedin Pages](https://github.com/fivetran/dbt_linkedin_pages/tree/main).
- The following models have been renamed:
  - `linkedin__account_ad_report` -> `linkedin_ads__account_report`
  - `linkedin__campaign_ad_report` -> `linkedin_ads__campaign_report`
  - `linkedin__campaign_group_ad_report` -> `linkedin_ads__campaign_group_report`
- The `linkedin__ad_adapter` model has been renamed and refactored into two separate models:
  - `linkedin_ads__url_report`: Each record in this table represents the daily performance at the url level.
  - `linkedin_ads__creative_report`: Each record in this table represents the daily performance at the creative level.
- The declaration of passthrough variables within your root `dbt_project.yml` has changed. To allow for more flexibility and better tracking of passthrough columns, you will now want to define passthrough columns in the following format:
```yml
vars:
  linkedin_ads__campaign_passthrough_metrics: # this will pass through fields to the account, campaign, and campaign group report models. it pulls from `ad_analytics_by_campaign`
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
  linkedin_ads__creative_passthrough_metrics: # this will pass through fields to the creative and url report models.  it pulls from `ad_analytics_by_creative`
    - name: "my_field_to_include"
      alias: "field_alias"
```
- Staging models are now by default written within a schema titled (`<target_schema>` + `_linkedin_ads_source`) in your destination. Previously, this was titled (`<target_schema>` + `_stg_linkedin`).

## 🎉 Feature Enhancements 🎉
- README updates for easier navigation and use of the package.
- Addition of identifier variables for each of the source tables to allow for further flexibility in source table direction within the dbt project.
- Addition of new columns to `_report` models.
- More complete table and column documentation.
- More robust schema tests.

# dbt_linkedin v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_linkedin_source`. Additionally, the latest `dbt_linkedin_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_linkedin v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!