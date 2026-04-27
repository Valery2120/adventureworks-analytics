with source as (
    select * from {{ source('sales', 'specialoffer') }}
),

renamed as (
    select
        specialofferid as special_offer_id,
        description as offer_description,
        discountpct as discount_percentage,
        type as offer_type,
        category as offer_category, 
        startdate as start_date,
        enddate as end_date,
        minqty as min_quantity,
        maxqty as max_quantity,
        modifieddate as modified_date
        
    from source
)

select * from renamed