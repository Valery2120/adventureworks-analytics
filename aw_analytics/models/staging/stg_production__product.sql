with source as (
    select * from {{ source('production', 'product') }}
),

renamed as (
    select
        productid as product_id,
        name as product_name,
        productnumber as product_number,
        makeflag as is_make_item,
        finishedgoodsflag as is_finished_good,
        color,
        safetystocklevel as safety_stock_level,
        reorderpoint as reorder_point,
        standardcost as standard_cost,
        listprice as list_price,
        size,
        weight,
        daystomanufacture as days_to_manufacture,
        productline as product_line,
        class,
        style,
        sellstartdate as sell_start_date,
        sellenddate as sell_end_date,
        modifieddate as modified_date
    from source
)

select * from renamed