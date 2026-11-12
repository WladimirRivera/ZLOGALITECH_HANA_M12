@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Class 5.02: Carrier - full access'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_05_02_CARRIER_FULL
  as select from /dmo/carrier
{
  key carrier_id    as CarrierId,
      name          as CarrierName,
      currency_code as CurrencyCode
}
