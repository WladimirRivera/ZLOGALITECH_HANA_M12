@EndUserText.label: 'Root Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZCDS_04_04_ROOT_ENTITY
  as select from /dmo/travel as Travel
  association [0..1] to /dmo/customer as _Customer
    on $projection.CustomerId = _Customer.customer_id
{
  key Travel.travel_id as TravelId,
      Travel.customer_id as CustomerId,
      Travel.begin_date as BeginDate,
      Travel.status as Status,
      
      _Customer
}
