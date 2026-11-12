@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.03: Customer dimension'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'CustomerId'
define view entity ZCDS_I_07_03_CUSTOMER_DIM
  as select from /dmo/customer
{
      @ObjectModel.text.element: ['CustomerName']
  key customer_id                                   as CustomerId,
      @Semantics.text: true
      concat_with_space( first_name, last_name, 1 ) as CustomerName,
      city                                          as City,
      country_code                                  as CountryCode
}
