@AbapCatalog.sqlViewName: 'ZCDS_03_05_SEM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.05: Semantics'
define view ZCDS_03_05_SEMANTICS
  as select from /dmo/flight as f
  inner join /dmo/carrier as c
    on c.carrier_id = f.carrier_id
  {
    key f.carrier_id as CarrierId,
    key f.connection_id as ConnectionId,
    key f.flight_date as FlightDate,
    @Semantics.currencyCode: true
    f.currency_code as Currency,
    @Semantics.amount.currencyCode: 'Currency'
    f.price as Price,
    c.name as CarrierName
  }
