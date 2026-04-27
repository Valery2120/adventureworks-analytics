with sales_persons as (
    select * from {{ ref('stg_sales__salespersons') }}
),
employees as (
    select * from {{ ref('stg_humanresources__employees') }}
),
persons as (
    select * from {{ ref('stg_person__persons') }}
),
quotas as (
    -- Take only the last quota for every employee
    select 
        salesperson_id,
        target_amount,
        quota_date,
        row_number() over (partition by salesperson_id order by quota_date desc) as rn
    from {{ ref('stg_sales__sales_quotas') }}
)

select
    sp.salesperson_id,
    p.full_name as salesperson_name,
    e.job_title,
    sp.commission_percent,
    sp.bonus,
    q.target_amount as current_quota,
    sp.sales_year_to_date as actual_sales_ytd,
    -- Calculation of % of plan completion
    case 
        when q.target_amount > 0 
        then (sp.sales_year_to_date / q.target_amount) * 100 
        else 0 
    end as quota_attainment_pct
from sales_persons sp
left join employees e on sp.salesperson_id = e.employee_id
left join persons p on sp.salesperson_id = p.person_id
left join quotas q on sp.salesperson_id = q.salesperson_id and q.rn = 1