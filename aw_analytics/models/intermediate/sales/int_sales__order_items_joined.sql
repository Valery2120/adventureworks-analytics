with orders as (
    select * from {{ ref('stg_sales__order_headers') }}
),
details as (
    select * from {{ ref('stg_sales__order_details') }}
),
products as (
    select * from {{ ref('stg_production__products') }}
)

select
    d.sales_order_detail_id,
    o.sales_order_id,
    o.order_date,
    o.customer_id,
    o.salesperson_id,
    o.territory_id,
    d.product_id,
    
    d.order_quantity,
    d.unit_price,
    d.line_item_revenue,
    
    -- Logistics calculations
    extract(day from (ship_date::timestamp - order_date::timestamp))::int as actual_lead_time_days,
    case 
        when o.ship_date > o.due_date then 1 
        else 0 
    end as is_shipped_late,
    
    -- Financial calculations
    (p.standard_cost * d.order_quantity) as total_standard_cost,
    (d.line_item_revenue - (p.standard_cost * d.order_quantity)) as gross_profit
from details d
join orders o on d.sales_order_id = o.sales_order_id
left join products p on d.product_id = p.product_id