with source as (
    select * from {{ source('person', 'person') }}
),

renamed as (
    select
        businessentityid as person_id,
        persontype as person_type_code,
        nullif(trim(firstname), '') as first_name,
        nullif(trim(middlename), '') as middle_name,
        nullif(trim(lastname), '') as last_name,
        concat(firstname, ' ', nullif(middlename || ' ', ' '), lastname) as full_name,
        modifieddate as modified_date

    from source
)

select * from renamed