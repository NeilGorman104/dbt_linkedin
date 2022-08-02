with creative as (

    select *
    from {{ var('creative_history') }}
),

campaign as (

    select *
    from {{ var('campaign_history') }}
    where valid_to is null
),

campaign_group as (

    select *
    from {{ var('campaign_group_history') }}
    where valid_to is null -- get latest
),

account as (

    select *
    from {{ var('account_history') }}
    where valid_to is null
),

report as (

    select *
    from {{ var('ad_analytics_by_creative') }}
),

final as (

    select 
        report.date_day,
        creative.click_uri,
        creative.base_url,
        creative.url_host,
        creative.url_path,
        creative.utm_source,
        creative.utm_medium,
        creative.utm_campaign,
        creative.utm_content,
        creative.utm_term,
        creative.creative_id,
        creative.version_tag,
        campaign.campaign_id,
        campaign.campaign_name,
        campaign_group.campaign_group_id,
        campaign_group.campaign_group_name,
        account.account_id,
        account.account_name,
        account.currency,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.cost) as cost

        {{ fivetran_utils.persist_pass_through_columns('linkedin_ads__passthrough_metrics', transform='sum') }}
    
    from report 
    left join creative 
        on report.creative_id = creative.creative_id
    left join campaign 
        on creative.campaign_id = campaign.campaign_id
    left join campaign_group
        on campaign.campaign_group_id = campaign_group.campaign_group_id
    left join account 
        on campaign.account_id = account.account_id

    where creative.click_uri is not null

    {{ dbt_utils.group_by(n=19) }}

)

select *
from final