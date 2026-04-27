with source as (

    -- It refers to the 'salesorderdetail' table defined in our _sources.yml
    select * from {{ source('sales', 'salesorderdetail') }}

),

renamed as (

    select
        salesorderid as sales_order_id,
        salesorderdetailid as sales_order_detail_id,
        productid as product_id,
        specialofferid as special_offer_id,
        orderqty as order_quantity,
        unitprice as unit_price,
        unitpricediscount as unit_price_discount,
        linetotal as line_item_revenue,
        modifieddate as modified_date

    from source

)


select * from renamed