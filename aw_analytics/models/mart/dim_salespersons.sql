{{ config(materialized='table') }}

with enriched_salespersons as (
    select * from {{ ref('int_sales__salespersons_enriched') }}
)

select
    salesperson_id,
    salesperson_name,
    job_title,
    commission_percent,
    bonus,
    -- Financial targets and current progressФинансовые цели и текущий прогресс
    current_quota,
    actual_sales_ytd,
    quota_attainment_pct,
    -- Categorization for useful filters
    case 
        when quota_attainment_pct >= 100 then 'Overperformer'
        when quota_attainment_pct >= 80 then 'On Track'
        else 'Underperformer'
    end as performance_tier
from enriched_salespersons