@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.03: Airline dimension'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'CarrierId'
define view entity ZCDS_I_07_03_AIRLINE_DIM
  as select from /dmo/carrier
{
      @ObjectModel.text.element: ['CarrierName']
  key carrier_id    as CarrierId,
      @Semantics.text: true
      name          as CarrierName,
      currency_code as CurrencyCode
}
