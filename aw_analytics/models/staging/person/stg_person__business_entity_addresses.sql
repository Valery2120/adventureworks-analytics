with source as (
    select * from {{ source('person', 'businessentityaddress') }}
),

renamed as (
    select
        businessentityid as business_entity_id,
        addressid as address_id,
        addresstypeid as address_type_id,
        modifieddate as modified_date
        
    from source
)

select * from renamed