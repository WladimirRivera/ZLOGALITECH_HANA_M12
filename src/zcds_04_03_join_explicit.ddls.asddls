@EndUserText.label: 'Explicit JOIN'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDS_04_03_JOIN_EXPLICIT
  as select from ZCDS_04_01_ASSOCIATIONS as Travel
  left outer join /dmo/booking as Booking
    on Booking.travel_id = Travel.TravelId
//    on $projection.TravelId = Travel.TravelId -- No lo permite
{
  key Travel.TravelId as TravelId,
      Travel.CustomerId as CustomerId,
      
      count( distinct Booking.booking_id ) as NumberOfBookings
}
group by Travel.TravelId, Travel.CustomerId
