with order_reasons_link as (
    select * from {{ ref('stg_sales__order_sales_reasons') }}
),
reason_names as (
    select * from {{ ref('stg_sales__sales_reasons') }}
)

select
    link.sales_order_id,
    -- Consolidate reasons into one line
    string_agg(names.sales_reason_name, ', ') as combined_sales_reasons,
    -- Calculate the number of reasons (useful for analytics)
    count(names.sales_reason_id) as total_reasons_count
from order_reasons_link link
left join reason_names names on link.sales_reason_id = names.sales_reason_id
group by 1