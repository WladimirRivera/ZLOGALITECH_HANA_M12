@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
@EndUserText.label: 'Class 5.02: Carrier - privileged only'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_05_02_CARRIER_PRIV
  as select from /dmo/carrier
{
  key carrier_id    as CarrierId,
      name          as CarrierName,
      currency_code as CurrencyCode
}
