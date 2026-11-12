@AbapCatalog.sqlViewName: 'ZCDS_03_02_SV'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.02: Session Variables'
define view ZCDS_03_02_SESSION_VARS
  as select from /dmo/flight
  {
    key carrier_id as CarrierId,
    key connection_id as ConnectionId,
    key flight_date as FlightDate,
    $session.user as CurrentUser,
    $session.system_language as SystemLanguage,
    $session.system_date as SystemDate,
    seats_occupied as OccupiedSeats,
    seats_max as MaxSeats
  }
  where flight_date >= $session.system_date
