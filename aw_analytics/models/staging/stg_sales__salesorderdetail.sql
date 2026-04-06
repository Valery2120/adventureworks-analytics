with source as (

    -- It refers to the 'salesorderdetail' table defined in our _sources.yml
    select * from {{ source('sales', 'salesorderdetail') }}

),

renamed as (

    select
        -- Primary Key & Foreign Keys
        salesorderid as sales_order_id,
        salesorderdetailid as sales_order_detail_id,
        productid as product_id,
        specialofferid as special_offer_id,
        
        -- Order details
        carriertrackingnumber as carrier_tracking_number,
        orderqty as order_quantity,
        unitprice as unit_price,
        unitpricediscount as unit_price_discount,
        
        -- Calculated column
        (unitprice * (1 - unitpricediscount) * orderqty) as line_total,
        
        -- Metadata
        rowguid as row_guid,
        modifieddate as modified_date

    from source

)


select * from renamed