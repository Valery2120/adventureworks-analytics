{{ config(materialized='table') }}

with enriched_offers as (
    select * from {{ ref('int_sales__special_offers_enriched') }}
)

select distinct 
    special_offer_id,
    offer_description,
    discount_percentage,
    offer_type,
    offer_category,
    start_date,
    end_date,
    min_quantity,
    max_quantity

from enriched_offers