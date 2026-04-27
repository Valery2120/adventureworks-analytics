with source as (
    select * from {{ source('person', 'address') }}
),

renamed as (
    select
        addressid as address_id,
        addressline1,
        addressline2,
        city,
        stateprovinceid as state_province_id,
        postalcode as postal_code,
        modifieddate as modified_date
        
    from source
)

select * from renamed