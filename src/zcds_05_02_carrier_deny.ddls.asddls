@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Class 5.02: Carrier - access denied'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_05_02_CARRIER_DENY
  as select from /dmo/carrier
{
  key carrier_id    as CarrierId,
      name          as CarrierName,
      currency_code as CurrencyCode
}
