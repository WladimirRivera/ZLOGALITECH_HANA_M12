CLASS zcl_06_02_odata_query_options DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_06_02_odata_query_options IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 6.02: CDS VIEWS EXPOSED AS AN ODATA SERVICE ===' ).
    out->write( 'Service binding: ZSB_06_02_FLIGHT_SERVICE_O4 / entity set: Connection' ).
    out->write( ' ' ).

    out->write( `--- Example 1: GET Connection?$top=5 ---` ).
    SELECT FROM zcds_p_06_02_connection
      FIELDS *
      ORDER BY CarrierId, ConnectionId
      INTO TABLE @DATA(lt_top)
      UP TO 5 ROWS.
    out->write( lt_top ).
    out->write( ' ' ).

    out->write( `--- Example 2: GET Connection?$filter=AirportFromId eq 'FRA' ---` ).
    SELECT FROM zcds_p_06_02_connection
      FIELDS CarrierId, ConnectionId, AirportFromId, AirportToId, CarrierName
      WHERE AirportFromId = 'FRA'
      ORDER BY CarrierId, ConnectionId
      INTO TABLE @DATA(lt_filtered).
    out->write( lt_filtered ).
    out->write( ' ' ).

    out->write( `--- Example 3: GET Connection?$orderby=Distance desc&$top=3 ---` ).
    SELECT FROM zcds_p_06_02_connection
      FIELDS CarrierId, ConnectionId, AirportFromId, AirportToId, Distance, DistanceUnit
      ORDER BY Distance DESCENDING
      INTO TABLE @DATA(lt_longest)
      UP TO 3 ROWS.
    out->write( lt_longest ).
    out->write( ' ' ).

    out->write( `--- Example 4: GET Connection?$select=CarrierId,ConnectionId,CarrierName ---` ).
    SELECT FROM zcds_p_06_02_connection
      FIELDS CarrierId, ConnectionId, CarrierName
      ORDER BY CarrierId, ConnectionId
      INTO TABLE @DATA(lt_selected).
    out->write( lt_selected ).
    out->write( ' ' ).

    out->write( `--- Example 5: GET Connection/$count ---` ).
    SELECT FROM zcds_p_06_02_connection
      FIELDS COUNT(*)
      INTO @DATA(lv_count).
    out->write( |$count = { lv_count }| ).
    out->write( ' ' ).

    out->write( `--- Example 6: GET Connection(CarrierId='LH',ConnectionId='0400') ---` ).
    SELECT SINGLE FROM zcds_p_06_02_connection
      FIELDS *
      WHERE CarrierId    = 'LH'
        AND ConnectionId = '0400'
      INTO @DATA(ls_single).
    out->write( ls_single ).
  ENDMETHOD.

ENDCLASS.

