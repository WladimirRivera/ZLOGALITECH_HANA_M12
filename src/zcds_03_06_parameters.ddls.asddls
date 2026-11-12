@AbapCatalog.sqlViewName: 'ZCDS_03_06_PAR'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.06: Parameters'
define view ZCDS_03_06_PARAMETERS
  with parameters
    p_airline : abap.char( 3 ),
    p_date : abap.dats
  as select from /dmo/flight
  {
    key carrier_id as CarrierId,
    key connection_id as ConnectionId,
    key flight_date as FlightDate,
    $parameters.p_airline as FilterAirline,
    @Semantics.amount.currencyCode: 'Currency'
    price as Price,
    currency_code as Currency,
    seats_occupied as OccupiedSeats,
    seats_max as MaxSeats
  }
  where carrier_id = $parameters.p_airline
    and flight_date >= $parameters.p_date
