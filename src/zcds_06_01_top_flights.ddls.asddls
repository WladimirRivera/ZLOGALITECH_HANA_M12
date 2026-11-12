@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.01: Top 3 flights per airline'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_06_01_TOP_FLIGHTS
  with parameters
    p_carrier_id : /dmo/carrier_id
  as select from ZCDS_06_01_FLIGHT_RANKING( p_carrier_id: $parameters.p_carrier_id ) as Ranking
  association [0..1] to /DMO/I_Carrier as _Carrier on $projection.CarrierId = _Carrier.AirlineID
{
  key Ranking.CarrierId,
  key Ranking.ConnectionId,
  key Ranking.FlightDate,
      Ranking.RevenueRank,
      Ranking.Revenue,
      Ranking.CurrencyCode,
      Ranking.OccupancyPercent,
      _Carrier.Name as CarrierName,
      _Carrier
}
where
  Ranking.RevenueRank <= 3
