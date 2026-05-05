with source as (
    select * from {{ source('sales', 'specialofferproduct') }}
),

renamed as (
    select
        specialofferid as special_offer_id,
        productid as product_id,
        modifieddate as modified_date
        
    from source
)

select * from renamed