with source as (
    select * from {{ source('sales', 'salespersonquotahistory') }}
),

renamed as (
    select
        businessentityid as salesperson_id,
        quotadate as quota_date,
        salesquota as target_amount,
        modifieddate as modified_date
        
    from source
)

select * from renamed