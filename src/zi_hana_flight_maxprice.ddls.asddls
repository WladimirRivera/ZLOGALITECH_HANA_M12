@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flights up to a maximum price (parameterized)'
define view entity zi_hana_flight_maxprice
  with parameters
    p_max_price : abap.dec(15,2)

  as select from /DMO/I_Flight
{
  key AirlineID,
  key ConnectionID,
  key FlightDate,
  Price,
  CurrencyCode,
  PlaneType
}
where
  cast( Price as abap.dec( 15, 2 ) ) <= $parameters.p_max_price
