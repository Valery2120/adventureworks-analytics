with source as (
    select * from {{ source('production', 'product') }}
),

renamed as (
    select
        productid as product_id,
        name as product_name,
        productnumber as product_number,
        makeflag as is_manufactured_flag,
        finishedgoodsflag as is_finished_good_flag,
        color,
        size,
        nullif(trim(sizeunitmeasurecode), '') as size_unit_code,
        weight,
        nullif(trim(weightunitmeasurecode), '') as weight_unit_code,
        standardcost as standard_cost,
        listprice as list_price,
        productsubcategoryid as product_subcategory_id,
        sellstartdate as sell_start_date,
        sellenddate as sell_end_date,
        daystomanufacture as days_to_manufacture,
        modifieddate as modified_date

    from source
)

select * from renamed