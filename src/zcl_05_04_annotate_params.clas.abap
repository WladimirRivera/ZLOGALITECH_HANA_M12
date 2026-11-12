CLASS zcl_05_04_annotate_params DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES tt_connection TYPE STANDARD TABLE OF zcds_05_04_conn_param WITH EMPTY KEY.

    METHODS get_connections_from
      IMPORTING iv_airport_from      TYPE /dmo/airport_from_id
      RETURNING VALUE(rt_connection) TYPE tt_connection.

ENDCLASS.


CLASS zcl_05_04_annotate_params IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( data = get_connections_from( 'FRA' )
                name = 'ZCDS_05_04_CONN_PARAM( pAirportFrom = FRA )' ).

    out->write( data = get_connections_from( 'JFK' )
                name = 'ZCDS_05_04_CONN_PARAM( pAirportFrom = JFK )' ).
  ENDMETHOD.


  METHOD get_connections_from.
    SELECT FROM zcds_05_04_conn_param( pAirportFrom = @iv_airport_from )
      FIELDS *
      ORDER BY CarrierId, ConnectionId
      INTO TABLE @rt_connection.
  ENDMETHOD.

ENDCLASS.

