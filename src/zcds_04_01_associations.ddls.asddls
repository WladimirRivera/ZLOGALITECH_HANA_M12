@EndUserText.label: 'Associations - Travel'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDS_04_01_ASSOCIATIONS
  as select from /dmo/travel as Travel
  association [0..1] to /dmo/customer as _Customer
    on $projection.CustomerId = _Customer.customer_id
//    on Travel.customer_id = _Customer.customer_id
  association [0..*] to /dmo/booking as _Booking
    on Travel.travel_id = _Booking.travel_id
{
  key Travel.travel_id as TravelId,
      Travel.customer_id as CustomerId,
      Travel.begin_date as BeginDate,
      Travel.end_date as EndDate,
      Travel.status as Status,
 //     _Customer.city as City,
      
        _Customer,
        _Booking
}
