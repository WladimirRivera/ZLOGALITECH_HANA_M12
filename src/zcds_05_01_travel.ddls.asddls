@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Class 5.01: Travel - literal DCL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_05_01_TRAVEL
  as select from /dmo/travel
{
  key travel_id     as TravelId,
      agency_id     as AgencyId,
      customer_id   as CustomerId,
      begin_date    as BeginDate,
      end_date      as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price   as TotalPrice,
      currency_code as CurrencyCode,
      status        as Status,
      createdby     as CreatedBy
} 
