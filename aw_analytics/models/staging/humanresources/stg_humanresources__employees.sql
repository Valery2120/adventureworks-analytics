with source as (
    select * from {{ source('humanresources', 'employee') }}
),

renamed as (
    select
        businessentityid as employee_id,
        nationalidnumber as national_id_number,
        jobtitle as job_title,
        birthdate as birth_date,
        maritalstatus as marital_status,
        gender,
        hiredate as hire_date,
        salariedflag as is_salaried,
        modifieddate as modified_date

    from source
)

select * from renamed