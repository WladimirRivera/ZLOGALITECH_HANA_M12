@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.03: Customer value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'CustomerId'
@Search.searchable: true
@Consumption.ranked: true
define view entity ZCDS_06_03_CUSTOMER_VH
  as select from /dmo/customer
{
      @UI.lineItem: [{ position: 10 }]
      @ObjectModel.text.element: ['LastName']
  key customer_id  as CustomerId,

      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Semantics.text: true
      @UI.lineItem: [{ position: 20 }]
      last_name    as LastName,

      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @UI.lineItem: [{ position: 30 }]
      first_name   as FirstName,

      @Search.defaultSearchElement: true
      @Search.ranking: #LOW
      @UI.lineItem: [{ position: 40 }]
      city         as City,

      @UI.lineItem: [{ position: 50 }]
      country_code as CountryCode
}
