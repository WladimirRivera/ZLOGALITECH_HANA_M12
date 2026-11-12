@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.04: Customer fuzzy search'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@UI.headerInfo: { typeName:       'Customer',
                  typeNamePlural: 'Customers',
                  title:          { type: #STANDARD, value: 'LastName' } }
define view entity ZCDS_06_04_CUSTOMER_FUZZY
  as select from /dmo/customer
{
      @UI.lineItem: [{ position: 10 }]
  key customer_id  as CustomerId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      @UI.lineItem: [{ position: 20 }]
      last_name    as LastName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @UI.lineItem: [{ position: 30 }]
      first_name   as FirstName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #LOW
      @UI.lineItem: [{ position: 40 }]
      city         as City,

      @UI.lineItem: [{ position: 50 }]
      country_code as CountryCode
}
