@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Path expression demo: Flight'
define view entity zi_hana_flight
  as select from /dmo/flight as Flight

  association [0..1] to zi_hana_connection as _Connection
    on  $projection.AirlineID    = _Connection.AirlineID
    and $projection.ConnectionID = _Connection.ConnectionID

{
  key Flight.carrier_id    as AirlineID,
  key Flight.connection_id as ConnectionID,
  key Flight.flight_date   as FlightDate,
      Flight.price         as Price,
      Flight.currency_code as CurrencyCode,

      _Connection
}
