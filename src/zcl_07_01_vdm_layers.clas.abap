CLASS zcl_07_01_vdm_layers DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_07_01_vdm_layers IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 7.01: VIRTUAL DATA MODEL (VDM) ARCHITECTURE ===' ).
    out->write( ' ' ).

    out->write( '--- Example 1: Basic interface views (one per table) ---' ).
    SELECT FROM zcds_i_07_01_carrier FIELDS COUNT(*) INTO @DATA(lv_carriers).
    SELECT FROM zcds_i_07_01_connection FIELDS COUNT(*) INTO @DATA(lv_connections).
    SELECT FROM zcds_i_07_01_booking FIELDS COUNT(*) INTO @DATA(lv_bookings).
    out->write( |ZCDS_I_07_01_CARRIER    : { lv_carriers } rows| ).
    out->write( |ZCDS_I_07_01_CONNECTION : { lv_connections } rows| ).
    out->write( |ZCDS_I_07_01_BOOKING    : { lv_bookings } rows| ).
    SELECT FROM zcds_i_07_01_carrier
      FIELDS CarrierId, CarrierName, CurrencyCode
      ORDER BY CarrierId
      INTO TABLE @DATA(lt_carriers).
    out->write( lt_carriers ).
    out->write( ' ' ).

    out->write( '--- Example 2: Composite interface view (basic views combined) ---' ).
    SELECT FROM zcds_i_07_01_booking_comp
      FIELDS TravelId, BookingId, CarrierId, CarrierName, ConnectionId,
             AirportFromId, AirportToId, FlightDate, FlightPrice, CurrencyCode
      ORDER BY TravelId, BookingId
      INTO TABLE @DATA(lt_composite)
      UP TO 5 ROWS.
    out->write( lt_composite ).
    out->write( ' ' ).

    out->write( '--- Example 3: Path expression through an association of the composite view ---' ).
    SELECT FROM zcds_i_07_01_booking_comp
      FIELDS TravelId, BookingId, CarrierId, ConnectionId,
             \_Connection-Distance     AS Distance,
             \_Connection-DistanceUnit AS DistanceUnit
      ORDER BY TravelId, BookingId
      INTO TABLE @DATA(lt_with_distance)
      UP TO 5 ROWS.
    out->write( lt_with_distance ).
    out->write( ' ' ).

    out->write( '--- Example 4: Consumption view (what one app needs) ---' ).
    SELECT FROM zcds_p_07_01_booking
      FIELDS *
      WHERE CarrierId = 'LH'
      ORDER BY FlightDate DESCENDING
      INTO TABLE @DATA(lt_consumption)
      UP TO 5 ROWS.
    out->write( lt_consumption ).
  ENDMETHOD.

ENDCLASS.

