with source as (
    select * from {{ source('sales', 'salesperson') }}
),

renamed as (
    select
        businessentityid as salesperson_id,
        territoryid as territory_id,
        salesquota as sales_target,
        bonus,
        commissionpct as commission_percent,
        salesytd as sales_year_to_date,
        modifieddate as modified_date
        
    from source
)

select * from renamed