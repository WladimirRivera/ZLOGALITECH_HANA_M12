@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.01: Booking - composite'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
define view entity ZCDS_I_07_01_BOOKING_COMP
  as select from ZCDS_I_07_01_BOOKING as Booking
  association [1..1] to ZCDS_I_07_01_CARRIER    as _Carrier    on  $projection.CarrierId = _Carrier.CarrierId
  association [1..1] to ZCDS_I_07_01_CONNECTION as _Connection on  $projection.CarrierId    = _Connection.CarrierId
                                                               and $projection.ConnectionId = _Connection.ConnectionId
{
  key Booking.TravelId,
  key Booking.BookingId,
      Booking.BookingDate,
      Booking.CustomerId,
      @ObjectModel.foreignKey.association: '_Carrier'
      Booking.CarrierId,
      Booking.ConnectionId,
      Booking.FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Booking.FlightPrice,
      Booking.CurrencyCode,
      _Carrier.CarrierName,
      _Connection.AirportFromId,
      _Connection.AirportToId,
      _Carrier,
      _Connection
}
