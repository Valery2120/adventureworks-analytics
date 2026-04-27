with source as (
    select * from {{ source('production', 'unitmeasure') }}
),

renamed as (
    select
        nullif(trim(unitmeasurecode), '') as unit_measure_code,
        name as unit_measure_name,
        modifieddate as modified_date
        
    from source
)

select * from renamed