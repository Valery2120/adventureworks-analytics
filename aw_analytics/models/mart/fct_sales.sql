{{ config(materialized='table') }}

with orders as (
    select * from {{ ref('int_sales__order_items_joined') }}
),
reasons as (
    select * from {{ ref('int_sales__order_reasons_aggregated') }}
)

select
    -- Keys
    o.sales_order_detail_id,
    o.sales_order_id,
    o.order_date,
    o.customer_id,
    o.product_id,
    o.salesperson_id,
    o.territory_id,
    
    -- Metrics
    o.order_quantity,
    o.unit_price,
    o.line_item_revenue,
    o.total_standard_cost,
    o.gross_profit,
    
    -- Logistics
    o.actual_lead_time_days,
    o.is_shipped_late,
    
    -- Enriched data
    coalesce(r.combined_sales_reasons, 'Not Specified') as sales_reasons
from orders o
left join reasons r on o.sales_order_id = r.sales_order_id