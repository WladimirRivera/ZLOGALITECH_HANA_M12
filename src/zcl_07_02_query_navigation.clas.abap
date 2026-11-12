CLASS zcl_07_02_query_navigation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_07_02_query_navigation IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 7.02: TESTING THE ANALYTICAL QUERY (TRANSIENT PROVIDER / QUERY MONITOR) ===' ).
    out->write( 'Query: ZCDS_P_07_03_BOOKING_QUERY  -  Cube: ZCDS_I_07_03_BOOKING_CUBE' ).
    out->write( ' ' ).

    out->write( '--- Example 1: Initial view - rows: Airline, Flight Year / columns: measures ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             FlightYear,
             CurrencyCode,
             SUM( NumberOfBookings ) AS NumberOfBookings,
             SUM( FlightPrice )      AS FlightPrice
      GROUP BY CarrierId, FlightYear, CurrencyCode
      ORDER BY CarrierId, FlightYear
      INTO TABLE @DATA(lt_initial).
    out->write( lt_initial ).
    out->write( ' ' ).

    out->write( '--- Example 2: Drill down - add free characteristic Connection (Airline = LH) ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             FlightYear,
             ConnectionId,
             \_Connection-Route       AS Route,
             CurrencyCode,
             SUM( NumberOfBookings ) AS NumberOfBookings,
             SUM( FlightPrice )      AS FlightPrice
      WHERE CarrierId = 'LH'
      GROUP BY CarrierId, FlightYear, ConnectionId, \_Connection-Route, CurrencyCode
      ORDER BY FlightYear, ConnectionId
      INTO TABLE @DATA(lt_drilldown).
    out->write( lt_drilldown ).
    out->write( ' ' ).

    out->write( '--- Example 3: Filter - Customer Country = DE ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             CurrencyCode,
             SUM( NumberOfBookings ) AS NumberOfBookings,
             SUM( FlightPrice )      AS FlightPrice
      WHERE CustomerCountry = 'DE'
      GROUP BY CarrierId, CurrencyCode
      ORDER BY CarrierId
      INTO TABLE @DATA(lt_filtered).
    out->write( lt_filtered ).
    out->write( ' ' ).

    out->write( '--- Example 4: Remove Flight Year from the rows (aggregate up) ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             \_Airline-CarrierName    AS CarrierName,
             CurrencyCode,
             SUM( NumberOfBookings ) AS NumberOfBookings,
             SUM( FlightPrice )      AS FlightPrice
      GROUP BY CarrierId, \_Airline-CarrierName, CurrencyCode
      ORDER BY CarrierId
      INTO TABLE @DATA(lt_by_airline).
    out->write( lt_by_airline ).
    out->write( ' ' ).

    out->write( '--- Example 5: Calculated measure - Average Price per Booking ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             CurrencyCode,
             SUM( NumberOfBookings ) AS NumberOfBookings,
             division( CAST( SUM( FlightPrice ) AS DEC( 17, 2 ) ), SUM( NumberOfBookings ), 2 ) AS AveragePrice
      GROUP BY CarrierId, CurrencyCode
      ORDER BY CarrierId
      INTO TABLE @DATA(lt_average).
    out->write( lt_average ).
  ENDMETHOD.

ENDCLASS.

