CLASS zcl_02_04_sql_func_numeric DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

ENDCLASS.



CLASS zcl_02_04_sql_func_numeric IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 4.1: NUMERIC SQL FUNCTIONS ===' ).
    out->write( '--- CAST, DIVISION, DIV, MOD, ABS, CEIL, FLOOR, ROUND on /DMO/I_FLIGHT ---' ).

    SELECT FROM /dmo/i_flight
      FIELDS airlineid, connectionid, flightdate, price, currencycode,
             maximumseats, occupiedseats,
             DIVISION( price * 116, 100, 2 )            AS price_with_tax,
             DIV( maximumseats, 10 )                    AS full_rows_of_ten,
             MOD( maximumseats, 10 )                    AS remaining_seats,
             DIVISION( occupiedseats, maximumseats, 4 ) AS occupancy_ratio,
             ABS( maximumseats - occupiedseats )         AS free_seats,
             CEIL( price )                               AS price_ceil,
             FLOOR( price )                              AS price_floor,
             CAST( price AS int4 )                       AS price_as_integer
      WHERE maximumseats > 0
      INTO TABLE @DATA(lt_flight_numbers)
      UP TO 20 ROWS.

    out->write( lt_flight_numbers ).
  ENDMETHOD.

ENDCLASS.
