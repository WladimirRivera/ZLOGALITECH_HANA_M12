@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.02: Connection - interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_I_06_02_CONNECTION
  as select from /dmo/connection
  association [1..1] to /DMO/I_Carrier as _Carrier          on $projection.CarrierId = _Carrier.AirlineID
  association [0..1] to /DMO/I_Airport as _DepartureAirport on $projection.AirportFromId = _DepartureAirport.AirportID
  association [0..1] to /DMO/I_Airport as _ArrivalAirport   on $projection.AirportToId = _ArrivalAirport.AirportID
{
  key carrier_id      as CarrierId,
  key connection_id   as ConnectionId,
      airport_from_id as AirportFromId,
      airport_to_id   as AirportToId,
      departure_time  as DepartureTime,
      arrival_time    as ArrivalTime,
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      distance        as Distance,
      distance_unit   as DistanceUnit,
      _Carrier,
      _DepartureAirport,
      _ArrivalAirport
}
