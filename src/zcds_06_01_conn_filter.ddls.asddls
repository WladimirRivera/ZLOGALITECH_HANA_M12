@EndUserText.label: 'Class 6.01: Connections - APPLY_FILTER'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function ZCDS_06_01_CONN_FILTER
  with parameters
    p_where : abap.char( 1000 )
returns
{
  client        : abap.clnt;
  CarrierId     : /dmo/carrier_id;
  ConnectionId  : /dmo/connection_id;
  AirportFromId : /dmo/airport_from_id;
  AirportToId   : /dmo/airport_to_id;
  Distance      : /dmo/flight_distance;
  DistanceUnit  : msehi;
}
implemented by method
  zcl_06_01_flight_amdp=>get_filtered_connections;
