CLASS zcl_07_03_analytical_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_07_03_analytical_model IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 7.03: ANALYTICAL MODELING - DIMENSIONS, CUBE AND QUERY ===' ).
    out->write( ' ' ).

    out->write( '--- Example 1: Dimension ZCDS_I_07_03_AIRLINE_DIM ---' ).
    SELECT FROM zcds_i_07_03_airline_dim
      FIELDS CarrierId, CarrierName, CurrencyCode
      ORDER BY CarrierId
      INTO TABLE @DATA(lt_airlines).
    out->write( lt_airlines ).
    out->write( ' ' ).

    out->write( '--- Example 2: Dimension ZCDS_I_07_03_CONN_DIM (with text and parent dimension) ---' ).
    SELECT FROM zcds_i_07_03_conn_dim
      FIELDS CarrierId,
             \_Airline-CarrierName AS CarrierName,
             ConnectionId,
             Route
      ORDER BY CarrierId, ConnectionId
      INTO TABLE @DATA(lt_connections).
    out->write( lt_connections ).
    out->write( ' ' ).

    out->write( '--- Example 3: Dimension ZCDS_I_07_03_CUSTOMER_DIM ---' ).
    SELECT FROM zcds_i_07_03_customer_dim
      FIELDS CustomerId, CustomerName, City, CountryCode
      ORDER BY CustomerId
      INTO TABLE @DATA(lt_customers)
      UP TO 5 ROWS.
    out->write( lt_customers ).
    out->write( ' ' ).

    out->write( '--- Example 4: Cube ZCDS_I_07_03_BOOKING_CUBE - detail rows ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS TravelId, BookingId, CarrierId, ConnectionId, CustomerId,
             FlightYear, FlightMonth, CustomerCountry,
             NumberOfBookings, FlightPrice, CurrencyCode
      ORDER BY TravelId, BookingId
      INTO TABLE @DATA(lt_cube_rows)
      UP TO 5 ROWS.
    out->write( lt_cube_rows ).
    out->write( ' ' ).

    out->write( '--- Example 5: Cube aggregated by Customer Country ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CustomerCountry,
             SUM( NumberOfBookings ) AS NumberOfBookings
      GROUP BY CustomerCountry
      ORDER BY NumberOfBookings DESCENDING
      INTO TABLE @DATA(lt_by_country)
      UP TO 5 ROWS.
    out->write( lt_by_country ).
  ENDMETHOD.

ENDCLASS.

