CLASS zcl_07_04_live_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_07_04_live_report IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 7.04: LIVE ANALYTICAL REPORT - NO REPLICATION, NO EXTRACTORS ===' ).
    out->write( ' ' ).

    out->write( '--- Example 1: Cube vs. database table at the same moment ---' ).
    GET TIME STAMP FIELD DATA(lv_now).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS SUM( NumberOfBookings ) AS bookings
      INTO @DATA(lv_cube_bookings).
    SELECT FROM /dmo/booking
      FIELDS COUNT(*)
      INTO @DATA(lv_table_bookings).
    out->write( |Read at          : { lv_now TIMESTAMP = ISO }| ).
    out->write( |Bookings in cube : { lv_cube_bookings }| ).
    out->write( |Rows in table    : { lv_table_bookings }| ).
    out->write( ' ' ).

    out->write( '--- Example 2: Top 5 connections by number of bookings ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             \_Airline-CarrierName    AS CarrierName,
             ConnectionId,
             \_Connection-Route       AS Route,
             SUM( NumberOfBookings ) AS NumberOfBookings
      GROUP BY CarrierId, \_Airline-CarrierName, ConnectionId, \_Connection-Route
      ORDER BY NumberOfBookings DESCENDING
      INTO TABLE @DATA(lt_top_connections)
      UP TO 5 ROWS.
    out->write( lt_top_connections ).
    out->write( ' ' ).

    out->write( '--- Example 3: Revenue per airline and month (current data) ---' ).
    SELECT FROM zcds_i_07_03_booking_cube
      FIELDS CarrierId,
             FlightYear,
             FlightMonth,
             CurrencyCode,
             SUM( FlightPrice ) AS FlightPrice
      WHERE CarrierId IN ( 'LH', 'AA' )
      GROUP BY CarrierId, FlightYear, FlightMonth, CurrencyCode
      ORDER BY CarrierId, FlightYear, FlightMonth
      INTO TABLE @DATA(lt_monthly).
    out->write( lt_monthly ).
    out->write( ' ' ).

    out->write( '--- Example 4: Published service ---' ).
    out->write( 'Service definition: ZSD_07_04_BOOKING_ANALYTICS  -  Entity set: BookingAnalytics' ).
    out->write( 'Service binding   : ZSB_07_04_BOOKING_ANALYTICS (OData V4 - UI)' ).
  ENDMETHOD.

ENDCLASS.

