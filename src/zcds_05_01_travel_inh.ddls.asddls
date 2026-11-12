@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Class 5.01: Travel - inherited DCL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_05_01_TRAVEL_INH
  as select from ZCDS_05_01_TRAVEL
{
  key TravelId,
      AgencyId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Status
}
