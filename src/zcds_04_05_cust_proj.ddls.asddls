@EndUserText.label: 'Customer View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDS_04_05_CUST_PROJ
  as select from /dmo/customer
{
  key customer_id as CustomerId,
      first_name as FirstName,
      last_name as LastName
}
