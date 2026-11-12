@AbapCatalog.sqlViewName: 'ZCDS_03_03_JD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.03: JOIN Flights'
define view ZCDS_03_03_JOIN_DEMO
  as select from /dmo/flight as f
  inner join /dmo/carrier as c
    on c.carrier_id = f.carrier_id
  {
    key f.carrier_id as CarrierId,
    key f.connection_id as ConnectionId,
    key f.flight_date as FlightDate,
    c.name as CarrierName,
    f.seats_occupied as OccupiedSeats,
    f.seats_max as MaxSeats,
    f.price as Price,
    f.currency_code as Currency
  }
