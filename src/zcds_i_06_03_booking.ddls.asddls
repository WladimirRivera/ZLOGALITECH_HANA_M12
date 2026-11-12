@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.03: Booking - interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_I_06_03_BOOKING
  as select from /dmo/booking
  association [0..1] to ZCDS_06_03_CUSTOMER_VH as _Customer on $projection.CustomerId = _Customer.CustomerId
  association [1..1] to /DMO/I_Carrier         as _Carrier  on $projection.CarrierId = _Carrier.AirlineID
{
  key travel_id     as TravelId,
  key booking_id    as BookingId,
      booking_date  as BookingDate,
      customer_id   as CustomerId,
      carrier_id    as CarrierId,
      connection_id as ConnectionId,
      flight_date   as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price  as FlightPrice,
      currency_code as CurrencyCode,
      _Customer,
      _Carrier
}
