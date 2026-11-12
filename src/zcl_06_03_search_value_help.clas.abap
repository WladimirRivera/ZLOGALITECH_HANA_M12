CLASS zcl_06_03_search_value_help DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_06_03_search_value_help IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
*    out->write( '=== CLASS 6.03: SEARCHABLE ENTITIES AND VALUE HELPS ===' ).
*    out->write( ' ' ).
*
*    out->write( '--- Example 1: Own value help ZCDS_06_03_CUSTOMER_VH ---' ).
*    SELECT FROM zcds_06_03_customer_vh
*      FIELDS *
*      ORDER BY CustomerId
*      INTO TABLE @DATA(lt_customer_vh)
*      UP TO 5 ROWS.
*    out->write( lt_customer_vh ).
*    out->write( ' ' ).
*
*    out->write( '--- Example 2: Standard value help /DMO/I_Carrier_StdVH ---' ).
*    SELECT FROM /dmo/i_carrier_stdvh
*      FIELDS AirlineID, Name, CurrencyCode
*      ORDER BY AirlineID
*      INTO TABLE @DATA(lt_carrier_vh).
*    out->write( lt_carrier_vh ).
*    out->write( ' ' ).
*
*    out->write( '--- Example 3: Value help with additionalBinding (CarrierId -> AirlineID) ---' ).
*    SELECT FROM /dmo/i_connection_stdvh
*      FIELDS COUNT(*)
*      INTO @DATA(lv_all_connections).
*
*    SELECT FROM /dmo/i_connection_stdvh
*      FIELDS AirlineID, ConnectionID, DepartureAirport, DestinationAirport
**      WHERE AirlineID = 'LH'
*      WHERE AirlineName = 'Deutsche Lufthansa LG'
*      ORDER BY ConnectionID
*      INTO TABLE @DATA(lt_lh_connections).
*
*    out->write( |Without CarrierId: { lv_all_connections } connections| ).
**    out->write( |With CarrierId = 'LH': { lines( lt_lh_connections ) } connections| ).
*    out->write( |With CarrierName: { lines( lt_lh_connections ) } connections| ).
*    out->write( lt_lh_connections ).
*    out->write( ' ' ).
**
*    out->write( '--- Example 4: Foreign key association and text element ---' ).
*    SELECT FROM zcds_p_06_03_booking
*      FIELDS TravelId, BookingId, CustomerId, CustomerName, CarrierId, ConnectionId
*      ORDER BY TravelId, BookingId
*      INTO TABLE @DATA(lt_bookings)
*      UP TO 5 ROWS.
*    out->write( lt_bookings ).
*    out->write( ' ' ).

    out->write( `--- Example 5: Booking?$search=Kirk ---` ).
    SELECT FROM zcds_p_06_03_booking
      FIELDS TravelId, BookingId, CustomerId, CustomerName, FlightDate
      WHERE CustomerName = 'Kirk'
      ORDER BY FlightDate
      INTO TABLE @DATA(lt_kirk)
      UP TO 5 ROWS.

    SELECT FROM zcds_p_06_03_booking
      FIELDS COUNT(*)
      WHERE CustomerName = 'Kir'
      INTO @DATA(lv_kirk_total).
    out->write( |Bookings: { lv_kirk_total }| ).
    out->write( lt_kirk ).
  ENDMETHOD.

ENDCLASS.

