{{ config(materialized='table') }}

with territories as (
    select * from {{ ref('stg_sales__sales_territories') }}
)

select
    territory_id,
    territory_name,
    country_code,
    territory_group,
    sales_year_to_date,
    sales_last_year,
    cost_year_to_date,
    cost_last_year
from territories