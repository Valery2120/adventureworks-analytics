with source as (
    select * from {{ source('purchasing', 'shipmethod') }}
),

renamed as (
    select
        shipmethodid as ship_method_id,
        name as ship_method_name,
        shipbase as shipping_base_cost,
        shiprate as shipping_rate_per_unit,
        modifieddate as modified_date

    from source
)

select * from renamed