CLASS zcl_06_01_table_function_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES tt_airport_range TYPE RANGE OF /dmo/airport_id.

    METHODS build_filter
      IMPORTING iv_column        TYPE string
                it_range         TYPE tt_airport_range
      RETURNING VALUE(rv_filter) TYPE string.

ENDCLASS.


CLASS zcl_06_01_table_function_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 6.01: CDS TABLE FUNCTIONS IMPLEMENTED WITH AMDP ===' ).
    out->write( ' ' ).

    out->write( '--- Example 1: Table function with a parameter ---' ).
    SELECT FROM zcds_06_01_flight_ranking( p_carrier_id = 'LH' )
      FIELDS CarrierId, ConnectionId, FlightDate, OccupancyPercent, Revenue, CurrencyCode, RevenueRank
      ORDER BY RevenueRank
      INTO TABLE @DATA(lt_lh_ranking).
    out->write( lt_lh_ranking ).
    out->write( ' ' ).

    out->write( '--- Example 2: Same table function for all airlines (empty parameter) ---' ).
    SELECT FROM zcds_06_01_flight_ranking( p_carrier_id = ' ' )
      FIELDS CarrierId, ConnectionId, FlightDate, Revenue, CurrencyCode
      WHERE RevenueRank = 1
      ORDER BY CarrierId
      INTO TABLE @DATA(lt_best_per_airline).
    out->write( lt_best_per_airline ).
    out->write( ' ' ).

    out->write( '--- Example 3: Dynamic filter with APPLY_FILTER ---' ).
    DATA(lt_airports) = VALUE tt_airport_range( ( sign = 'I' option = 'EQ' low = 'FRA' )
                                                ( sign = 'I' option = 'EQ' low = 'JFK' ) ).
    DATA(lv_filter) = build_filter( iv_column = `AIRPORT_FROM_ID` it_range = lt_airports ).
    out->write( |p_where = { lv_filter }| ).
    DATA lv_where TYPE c LENGTH 1000.
    lv_where = lv_filter.
    SELECT FROM zcds_06_01_conn_filter( p_where = @lv_where )
      FIELDS CarrierId, ConnectionId, AirportFromId, AirportToId, Distance, DistanceUnit
      ORDER BY AirportFromId, CarrierId, ConnectionId
      INTO TABLE @DATA(lt_connections).
    out->write( lt_connections ).
    out->write( ' ' ).

    out->write( '--- Example 4: CDS view entity that reads a table function ---' ).
    SELECT FROM zcds_06_01_top_flights( p_carrier_id = 'SQ' )
      FIELDS *
      ORDER BY RevenueRank
      INTO TABLE @DATA(lt_top_flights).
    out->write( lt_top_flights ).
    out->write( ' ' ).

    out->write( '--- Example 5: AMDP procedure called from ABAP ---' ).
    zcl_06_01_flight_amdp=>get_customer_bookings( EXPORTING iv_customer_id = '000253'
                                                  IMPORTING et_bookings    = DATA(lt_bookings) ).
    out->write( |Bookings of customer 000253: { lines( lt_bookings ) }| ).
    out->write( ' ' ).

    out->write( '--- Example 6: AMDP procedure that calls another AMDP procedure ---' ).
    zcl_06_01_flight_amdp=>get_last_bookings( EXPORTING iv_customer_id = '000253'
                                                        iv_max_rows    = 3
                                              IMPORTING et_bookings    = DATA(lt_last_bookings) ).
    out->write( lt_last_bookings ).
  ENDMETHOD.


  METHOD build_filter.
    DATA(lt_conditions) = VALUE string_table( ).

    LOOP AT it_range INTO DATA(ls_range) WHERE sign = 'I'.
      DATA(lv_low)  = replace( val = CONV string( ls_range-low )  sub = `'` with = `''` occ = 0 ).
      DATA(lv_high) = replace( val = CONV string( ls_range-high ) sub = `'` with = `''` occ = 0 ).
      CASE ls_range-option.
        WHEN 'EQ'.
          APPEND |{ iv_column } = '{ lv_low }'| TO lt_conditions.
        WHEN 'BT'.
          APPEND |{ iv_column } BETWEEN '{ lv_low }' AND '{ lv_high }'| TO lt_conditions.
        WHEN 'CP'.
          APPEND |{ iv_column } LIKE '{ replace( val = lv_low sub = `*` with = `%` occ = 0 ) }'| TO lt_conditions.
      ENDCASE.
    ENDLOOP.

    rv_filter = concat_lines_of( table = lt_conditions sep = ` OR ` ).
  ENDMETHOD.

ENDCLASS.

