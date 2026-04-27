{{ config(materialized='table') }}

select
    product_id,
    product_name,
    product_number,
    color,
    size,
    standard_cost,
    list_price,
    potential_unit_profit,
    subcategory_name,
    category_name
from {{ ref('int_production__products_enriched') }}