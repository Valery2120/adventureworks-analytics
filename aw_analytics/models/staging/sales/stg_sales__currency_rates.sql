with source as (

    select * from {{ source('sales', 'currencyrate') }}

),

renamed as (

    select
        currencyrateid as currency_rate_id,
        currencyratedate as currency_rate_date,
        fromcurrencycode as from_currency_code,
        tocurrencycode as to_currency_code,
        averagerate as average_rate,
        endofdayrate as end_of_day_rate,
        modifieddate as modified_date

    from source

)

select * from renamed