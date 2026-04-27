with source as (
    select * from {{ source('production', 'productsubcategory') }}
),

renamed as (
    select
        productsubcategoryid as product_subcategory_id,
        productcategoryid as product_category_id,
        name as subcategory_name,
        modifieddate as modified_date

    from source
)

select * from renamed