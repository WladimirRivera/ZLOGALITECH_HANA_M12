@EndUserText.label: 'Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDS_04_05_PROJECTION
  as select from ZCDS_04_04_ROOT_ENTITY as Travel
  association [0..1] to ZCDS_04_05_CUST_PROJ as _Customer
    on $projection.CustomerId = _Customer.CustomerId
{
  key Travel.TravelId,
      Travel.CustomerId,
      Travel.BeginDate,
      Travel.Status,
      
      _Customer
}
