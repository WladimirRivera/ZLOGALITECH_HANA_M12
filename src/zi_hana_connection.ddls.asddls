@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Path expression demo: Connection'
define view entity zi_hana_connection
  as select from /dmo/connection as Connection

  association [0..1] to zi_hana_airport as _DepartureAirport   on $projection.DepartureAirport = _DepartureAirport.AirportID
  association [0..1] to zi_hana_airport as _DestinationAirport on $projection.DestinationAirport = _DestinationAirport.AirportID

{
  key Connection.carrier_id     as AirlineID,
  key Connection.connection_id  as ConnectionID,
      Connection.airport_from_id as DepartureAirport,
      Connection.airport_to_id   as DestinationAirport,
      Connection.distance        as Distance,
      Connection.distance_unit   as DistanceUnit,

      _DepartureAirport,
      _DestinationAirport
}
