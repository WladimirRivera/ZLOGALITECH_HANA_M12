@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 5.04: Connection with parameter'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCDS_05_04_CONN_PARAM
  with parameters
    pAirportFrom : /dmo/airport_from_id
  as select from /dmo/connection
{
  key carrier_id      as CarrierId,
  key connection_id   as ConnectionId,
      airport_from_id as AirportFromId,
      airport_to_id   as AirportToId,
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      distance        as Distance,
      distance_unit   as DistanceUnit
}
where
  airport_from_id = $parameters.pAirportFrom
