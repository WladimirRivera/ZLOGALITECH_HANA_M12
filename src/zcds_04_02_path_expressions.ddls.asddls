@EndUserText.label: 'Path Expressions'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDS_04_02_PATH_EXPRESSIONS
  as select from ZCDS_04_01_ASSOCIATIONS as Travel
{
  key Travel.TravelId,
      Travel.CustomerId,
      Travel.BeginDate,
      Travel.EndDate,
      Travel.Status,
      
      Travel._Customer.first_name as CustomerFirstName,
      Travel._Customer.last_name as CustomerLastName,
      Travel._Booking.booking_date as FirstBookingDate
}
