with source as (
    select * from {{ source('sales', 'salesterritory') }}
),

renamed as (
    select
        territoryid as territory_id,
        name as territory_name,
        countryregioncode as country_code,
        "group" as territory_group,
        salesytd as sales_year_to_date,
        saleslastyear as sales_last_year,
        costytd as cost_year_to_date,
        costlastyear as cost_last_year,
        modifieddate as modified_date
        
    from source

)

select * from renamed