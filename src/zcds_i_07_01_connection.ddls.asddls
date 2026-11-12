@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.01: Connection - basic'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define view entity ZCDS_I_07_01_CONNECTION
  as select from /dmo/connection
{
  key carrier_id      as CarrierId,
  key connection_id   as ConnectionId,
      airport_from_id as AirportFromId,
      airport_to_id   as AirportToId,
      departure_time  as DepartureTime,
      arrival_time    as ArrivalTime,
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      distance        as Distance,
      distance_unit   as DistanceUnit
}
