with customers as (
    select * from {{ ref('stg_sales__customers') }}
),
persons as (
    select * from {{ ref('stg_person__persons') }}
)

select
    c.customer_id,
    c.territory_id,
    p.full_name as customer_name,
    case 
        when c.person_id is not null then 'Individual'
        when c.store_id is not null then 'Reseller'
        else 'Unknown'
    end as customer_segment
from customers c
left join persons p on c.person_id = p.person_id