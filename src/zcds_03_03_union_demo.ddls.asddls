@AbapCatalog.sqlViewName: 'ZCDS_03_03_UD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.03: UNION Demo'
define view ZCDS_03_03_UNION_DEMO
  as select from /dmo/connection
  {
    key carrier_id as CarrierId,
    key connection_id as ConnectionId,
    airport_from_id as AirportFrom
  }
  union
  select from /dmo/connection
  {
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    airport_to_id as AirportFrom
  }
