{{ config(materialized='table') }}

select
    customer_id,
    customer_name,
    customer_segment,
    territory_id
from {{ ref('int_sales__customers_enriched') }}