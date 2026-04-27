with source as (
    select * from {{ source('sales', 'salesorderheader') }}
),

renamed as (
    select
        salesorderid as sales_order_id,
        customerid as customer_id,
        salespersonid as salesperson_id,
        territoryid as territory_id,
        orderdate as order_date,
        duedate as due_date,  
        shipdate as ship_date,
        status as order_status_code,
        onlineorderflag as is_online_order,
        subtotal as revenue_amount,
        taxamt as tax_amount,
        freight as shipping_amount,
        totaldue as total_amount,
        modifieddate as modified_date
        
    from source
)

select * from renamed