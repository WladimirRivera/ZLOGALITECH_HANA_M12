@EndUserText.label: 'Class 6.01: Flight revenue ranking'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function ZCDS_06_01_FLIGHT_RANKING
  with parameters
    p_carrier_id : /dmo/carrier_id
returns
{
  client           : abap.clnt;
  CarrierId        : /dmo/carrier_id;
  ConnectionId     : /dmo/connection_id;
  FlightDate       : /dmo/flight_date;
  SeatsMax         : /dmo/plane_seats_max;
  SeatsOccupied    : /dmo/plane_seats_occupied;
  OccupancyPercent : abap.dec( 5, 2 );
  Revenue          : abap.dec( 17, 2 );
  CurrencyCode     : /dmo/currency_code;
  RevenueRank      : abap.int4;
}
implemented by method
  zcl_06_01_flight_amdp=>get_flight_ranking;
