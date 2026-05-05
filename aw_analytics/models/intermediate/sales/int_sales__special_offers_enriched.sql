with special_offers as (
    select * from {{ ref('stg_sales__special_offers') }}
),

special_offer_products as (
    select * from {{ ref('stg_sales__special_offer_products') }}
),

enriched as (
    select
        so.special_offer_id,
        sop.product_id, 
        so.offer_description,
        so.discount_percentage,
        so.offer_type,
        so.offer_category,
        so.start_date,
        so.end_date,
        so.min_quantity,
        so.max_quantity

    from special_offers so
    left join special_offer_products sop 
        on so.special_offer_id = sop.special_offer_id
)

select * from enriched