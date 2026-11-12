@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.01: Carrier - basic'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'CarrierId'
define view entity ZCDS_I_07_01_CARRIER
  as select from /dmo/carrier
{
      @ObjectModel.text.element: ['CarrierName']
  key carrier_id    as CarrierId,
      @Semantics.text: true
      name          as CarrierName,
      currency_code as CurrencyCode
}
