with products as (
    select * from {{ ref('stg_production__products') }}
),
subcategories as (
    select * from {{ ref('stg_production__product_subcategories') }}
),
categories as (
    select * from {{ ref('stg_production__product_categories') }}
)

select
    p.product_id,
    p.product_name,
    p.product_number,
    p.color,
    p.size,
    p.standard_cost,
    p.list_price,
    p.is_manufactured_flag,
    coalesce(c.category_name, 'No Category') as category_name,
    coalesce(s.subcategory_name, 'No Subcategory') as subcategory_name,
    -- Product-level potential margin calculation
    (p.list_price - p.standard_cost) as potential_unit_profit
from products p
left join subcategories s on p.product_subcategory_id = s.product_subcategory_id
left join categories c on s.product_category_id = c.product_category_id