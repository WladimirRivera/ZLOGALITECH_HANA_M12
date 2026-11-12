CLASS zcl_01_04_read_and_write DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    METHODS example_2_1 IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_2 IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_3 IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_4 IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_5 IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_2c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_3a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_3b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_3c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_4a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_4b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_2_4c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_01_04_read_and_write IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
*    example_2_1( out ).
*    example_2_2( out ).
*    example_2_3( out ).
*    example_2_4( out ).
    example_2_5( out ).
    example_2_2c( out ).
    example_2_3a( out ).
    example_2_3b( out ).
    example_2_3c( out ).
    example_2_4a( out ).
    example_2_4b( out ).
    example_2_4c( out ).
  ENDMETHOD.

  METHOD example_2_1.
    out->write( 'tabla interna declarada en linea' ).
    SELECT carrier_id, connection_id, flight_date, seats_max, seats_occupied, price, currency_code
     FROM /dmo/flight
     WHERE carrier_id eq 'SQ'
     into table @DATA(lt_flights).

     out->write( lt_flights ).
  ENDMETHOD.

  METHOD example_2_2.
    out->write( 'Estructura declarada en linea con SELECT SINGLE ---' ).

    DATA(lv_carrier)    = 'SQ'.
    DATA(lv_connection)  = '0001'.
    DATA(lv_flightdate) = CONV d( '20260702' ).

    SELECT SINGLE carrier_id, connection_id, flight_date, seats_max, seats_occupied
      FROM /dmo/flight
      WHERE carrier_id = @lv_carrier
        AND connection_id = @lv_connection
        AND flight_date = @lv_flightdate
      INTO @DATA(ls_flight).

    out->write( ls_flight ).
  ENDMETHOD.

  METHOD example_2_3.
    out->write( '--- 2.1c Declaracion en linea dentro de un bucle SELECT ... ENDSELECT ---' ).

    TYPES: BEGIN OF ty_flight_row,
             carrier_id     TYPE /dmo/carrier_id,
             connection_id  TYPE /dmo/connection_id,
             flight_date    TYPE /dmo/flight_date,
             seats_max      TYPE /dmo/plane_seats_max,
             seats_occupied TYPE /dmo/plane_seats_occupied,
           END OF ty_flight_row.

    DATA(lv_carrier) = 'SQ'.
    DATA lt_criticos TYPE STANDARD TABLE OF ty_flight_row.

    SELECT carrier_id, connection_id, flight_date, seats_max, seats_occupied
      FROM /dmo/flight
      WHERE carrier_id = @lv_carrier
      INTO @DATA(ls_flight_line).

      IF ( ls_flight_line-seats_max - ls_flight_line-seats_occupied ) < 100.
        APPEND ls_flight_line TO lt_criticos.
      ENDIF.
    ENDSELECT.

    out->write( lt_criticos ).
  ENDMETHOD.

  METHOD example_2_4.
    out->write( '--- 2.2a FIELDS equivalente a un SELECT clasico ---' ).

    SELECT FROM /dmo/booking
      FIELDS carrier_id, connection_id, flight_date, booking_id, flight_price
      WHERE flight_price > 400
      ORDER BY flight_price DESCENDING
      INTO TABLE @DATA(lt_reservas_caras).

    out->write( lt_reservas_caras ).
  ENDMETHOD.

  METHOD example_2_5.
    out->write( '--- 2.2b FIELDS con una columna calculada (alias) ---' ).

    SELECT FROM /dmo/flight
      FIELDS carrier_id, connection_id, flight_date, seats_max, seats_occupied,
             seats_max - seats_occupied AS seats_available
      WHERE seats_max > 0
      INTO TABLE @DATA(lt_disponibilidad).

    out->write( lt_disponibilidad ).
  ENDMETHOD.

  METHOD example_2_2c.
    out->write( '--- 2.2c FIELDS combinado con GROUP BY y HAVING ---' ).

    SELECT FROM /dmo/booking
      FIELDS carrier_id,
             SUM( flight_price ) AS ingreso_total,
             COUNT(*) AS total_reservas
      GROUP BY carrier_id
      HAVING SUM( flight_price ) > 1000
      INTO TABLE @DATA(lt_resumen_aerolinea).

    out->write( lt_resumen_aerolinea ).
  ENDMETHOD.

  METHOD example_2_3a.
    out->write( '--- 2.3a Dos variables host con nombre ---' ).

    DATA(lv_carrier)    = 'SQ'.
    DATA(lv_connection) = '0001'.

    SELECT carrier_id, connection_id, flight_date, seats_occupied
      FROM /dmo/flight
      WHERE carrier_id = @lv_carrier
        AND connection_id = @lv_connection
      INTO TABLE @DATA(lt_vuelos_sq_0001).

    out->write( lt_vuelos_sq_0001 ).
  ENDMETHOD.

  METHOD example_2_3b.
    out->write( '--- 2.3b Field-symbol como variable host, combinado con un literal ---' ).

    DATA(lv_carrier) = 'SQ'.
    ASSIGN lv_carrier TO FIELD-SYMBOL(<fs_carrier>).

    SELECT carrier_id, connection_id, flight_date, seats_occupied
      FROM /dmo/flight
      WHERE carrier_id = @<fs_carrier>
        AND connection_id = '0001'
      INTO TABLE @DATA(lt_vuelos_0001).

    out->write( lt_vuelos_0001 ).
  ENDMETHOD.

  METHOD example_2_3c.
    out->write( '--- 2.3c Host expression @( ... ) con una operacion ABAP ---' ).

    DATA(lv_carrier)      = 'SQ'.
    DATA(lv_umbral_base)  = 50.

    SELECT carrier_id, connection_id, flight_date, seats_occupied
      FROM /dmo/flight
      WHERE carrier_id = @lv_carrier
        AND seats_occupied > @( lv_umbral_base * 2 )
      INTO TABLE @DATA(lt_vuelos_relevantes).

    out->write( lt_vuelos_relevantes ).
  ENDMETHOD.

  METHOD example_2_4a.
    out->write( '--- 2.4a INTO al final: en este release, INTO ya no puede ir justo despues de FROM ---' ).

    DATA(lv_carrier) = 'UA'.

    SELECT carrier_id, connection_id, flight_date, booking_id
      FROM /dmo/booking
      WHERE carrier_id = @lv_carrier
      ORDER BY flight_date DESCENDING
      INTO TABLE @DATA(lt_reservas_clasico).

    out->write( lt_reservas_clasico ).
  ENDMETHOD.

  METHOD example_2_4b.
    out->write( '--- 2.4b Orden moderno: INTO al final, UP TO n ROWS despues de INTO ---' ).

    DATA(lv_carrier) = 'UA'.

    SELECT FROM /dmo/booking
      FIELDS carrier_id, connection_id, flight_date, booking_id
      WHERE carrier_id = @lv_carrier
      ORDER BY flight_date DESCENDING
      INTO TABLE @DATA(lt_ultimas_reservas)
      UP TO 10 ROWS.

    out->write( lt_ultimas_reservas ).
  ENDMETHOD.

  METHOD example_2_4c.
    out->write( '--- 2.4c BYPASSING BUFFER despues de INTO ---' ).

    DATA(lv_carrier) = 'SQ'.

    SELECT carrier_id, connection_id, flight_date, seats_occupied
      FROM /dmo/flight
      WHERE carrier_id = @lv_carrier
      INTO TABLE @DATA(lt_vuelos_sin_buffer)
      BYPASSING BUFFER.

    out->write( lt_vuelos_sin_buffer ).
  ENDMETHOD.

ENDCLASS.
