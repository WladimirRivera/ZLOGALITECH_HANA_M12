@AbapCatalog.sqlViewName: 'ZCDS_03_04_AGG'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.04: Aggregations'
define view ZCDS_03_04_AGGREGATIONS
  as select from /dmo/flight
  {
    key carrier_id as CarrierId,
    key currency_code as Currency,
    count( * ) as NumFlights,
    sum( seats_occupied ) as TotalOccupiedSeats,
    avg( seats_occupied ) as AvgOccupancy,
    max( price ) as MaxPrice
  }
  group by carrier_id, currency_code
  having count( * ) > 0
