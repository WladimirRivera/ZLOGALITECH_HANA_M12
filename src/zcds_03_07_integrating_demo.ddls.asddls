@AbapCatalog.sqlViewName: 'ZCDS_03_07_DASH'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.07: Dashboard'
define view ZCDS_03_07_INTEGRATING_DEMO
  with parameters
    p_airline : abap.char( 3 )
  as select from ZCDS_03_06_PARAMETERS( p_airline: $parameters.p_airline,
                                         p_date: $session.system_date ) as v
  inner join /dmo/carrier as c
    on c.carrier_id = v.CarrierId
  {
    key c.carrier_id as CarrierId,
    key v.Currency,
    c.name as CarrierName,
    count( * ) as NumFlights,
    @Semantics.amount.currencyCode: 'Currency'
    sum( v.Price ) as TotalPrice,
    avg( v.OccupiedSeats ) as AvgOccupancy
  }
  group by c.carrier_id, c.name, v.Currency
