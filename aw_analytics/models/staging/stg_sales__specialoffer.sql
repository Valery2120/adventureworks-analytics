with source as (
    select * from {{ source('sales', 'specialoffer') }}
),

renamed as (
    select
        specialofferid as special_offer_id,
        description,
        discountpct as discount_percent,
        type as discount_type,
        category as discount_category,
        startdate as start_date,
        enddate as end_date,
        minqty as min_quantity,
        maxqty as max_quantity
    from source
)

select * from renamed