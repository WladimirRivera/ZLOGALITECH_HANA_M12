CLASS zcl_01_01_case_union_with DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS example_3_1a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_1b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_1c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_2a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_2b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_2c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_3a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_3b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_3c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_4a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_4b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_3_4c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_01_01_case_union_with IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== TEMA 3: CASE, UNION Y WITH ===' ).
    out->write( 'Caso: Flight Reference Scenario (/DMO/TRAVEL, /DMO/BOOKING, /DMO/FLIGHT...)' ).

*    example_3_1a( out ).
*    example_3_1b( out ).
*    example_3_1c( out ).
*    example_3_2a( out ).
*    example_3_2b( out ).
*    example_3_2c( out ).
*    example_3_3a( out ).
*    example_3_3b( out ).
*    example_3_3c( out ).
*    example_3_4a( out ).
    example_3_4b( out ).
*    example_3_4c( out ).
  ENDMETHOD.

  METHOD example_3_1a.
    out->write( '--- 3.1a CASE simple: traduce el status del viaje a una descripcion legible ---' ).

    SELECT travel_id, agency_id, customer_id, status,
      CASE status
        WHEN 'N' THEN 'Nuevo'
        WHEN 'P' THEN 'Planificado'
        WHEN 'B' THEN 'Reservado'
        WHEN 'X' THEN 'Cancelado'
        ELSE 'Desconocido'
      END AS status_desc
      FROM /dmo/travel
      INTO TABLE @DATA(lt_travels_desc)
      UP TO 20 ROWS.

    out->write( lt_travels_desc ).
  ENDMETHOD.

  METHOD example_3_1b.
    out->write( '--- 3.1b CASE devuelve un numero usado luego en ORDER BY ---' ).

    SELECT travel_id, agency_id, customer_id, status,
      CASE status
        WHEN 'B' THEN 1
        WHEN 'P' THEN 2
        WHEN 'N' THEN 3
        ELSE 9
      END AS prioridad_orden
      FROM /dmo/travel
      ORDER BY prioridad_orden ASCENDING
      INTO TABLE @DATA(lt_travels_ordenados)
      UP TO 20 ROWS.

    out->write( lt_travels_ordenados ).
  ENDMETHOD.

  METHOD example_3_1c.
    out->write( '--- 3.1c CASE comparado contra una variable host, no un literal ---' ).

    DATA(lv_pais_local) = 'DE'.

    SELECT customer_id, first_name, last_name, country_code,
      CASE country_code
        WHEN @lv_pais_local THEN 'Cliente nacional'
        ELSE 'Cliente internacional'
      END AS ambito
      FROM /dmo/customer
      INTO TABLE @DATA(lt_clientes_ambito)
      UP TO 20 ROWS.

    out->write( lt_clientes_ambito ).
  ENDMETHOD.

  METHOD example_3_2a.
    out->write( '--- 3.2a CASE complejo: clasifica cada viaje segun su importe total ---' ).

    SELECT travel_id, agency_id, customer_id, total_price,
      CASE
        WHEN total_price > 5000 THEN 'Alto valor'
        WHEN total_price BETWEEN 1000 AND 5000 THEN 'Valor medio'
        WHEN total_price < 1000 THEN 'Bajo valor'
        ELSE 'Sin clasificar'
      END AS value_class
      FROM /dmo/travel
      INTO TABLE @DATA(lt_travels_clasificados)
      UP TO 20 ROWS.

    out->write( lt_travels_clasificados ).
  ENDMETHOD.

  METHOD example_3_2b.
    out->write( '--- 3.2b Condiciones combinadas con AND: semaforo de ocupacion del vuelo ---' ).

    SELECT carrier_id, connection_id, flight_date, seats_max, seats_occupied,
      CASE
        WHEN seats_occupied >= seats_max THEN 'Vuelo lleno'
        WHEN seats_occupied >= seats_max - 20 AND seats_occupied < seats_max THEN 'Casi lleno'
        WHEN seats_occupied < seats_max - 100 THEN 'Baja ocupacion'
        ELSE 'Normal'
      END AS estado_ocupacion
      FROM /dmo/flight
      INTO TABLE @DATA(lt_estado_ocupacion)
      UP TO 20 ROWS.

    out->write( lt_estado_ocupacion ).
  ENDMETHOD.

  METHOD example_3_2c.
    out->write( '--- 3.2c Primer WHEN comprueba IS NULL antes de comparar valores ---' ).

    SELECT travel_id, booking_id, booking_supplement_id, price,
      CASE
        WHEN price IS NULL THEN 'Sin importe'
        WHEN price BETWEEN 0 AND 10 THEN 'Economico'
        WHEN price > 50 THEN 'Premium'
        ELSE 'Estandar'
      END AS rango_precio
      FROM /dmo/book_suppl
      INTO TABLE @DATA(lt_rango_precio)
      UP TO 20 ROWS.

    out->write( lt_rango_precio ).
  ENDMETHOD.

  METHOD example_3_3a.
    out->write( '--- 3.3a UNION ALL: aerolineas que cobran en EUR y en USD, sin deduplicar ---' ).

    SELECT carrier_id, name, currency_code FROM /dmo/carrier WHERE currency_code = 'EUR'
    UNION ALL
    SELECT carrier_id, name, currency_code FROM /dmo/carrier WHERE currency_code = 'USD'
    INTO TABLE @DATA(lt_aerolineas_eur_usd).

    out->write( lt_aerolineas_eur_usd ).
  ENDMETHOD.

  METHOD example_3_3b.
    out->write( '--- 3.3b UNION DISTINCT: vuelos con baja ocupacion o con reservas de alto valor ---' ).

    SELECT carrier_id, connection_id as a FROM /dmo/flight WHERE seats_occupied < 150
    UNION DISTINCT
    SELECT carrier_id, connection_id as a FROM /dmo/booking WHERE flight_price > 5000
    INTO TABLE @DATA(lt_vuelos_relevantes_union).

    out->write( lt_vuelos_relevantes_union ).
  ENDMETHOD.

  METHOD example_3_3c.
    out->write( '--- 3.3c Union de tres consultas con etiqueta de origen y ORDER BY sobre el total ---' ).

    SELECT carrier_id, connection_id, 'BAJA_OCUPACION' AS origen FROM /dmo/flight WHERE seats_occupied < 150
    UNION ALL
    SELECT carrier_id, connection_id, 'RESERVA_ALTA' AS origen FROM /dmo/booking WHERE flight_price > 5000
    UNION ALL
    SELECT fl~carrier_id, fl~connection_id, 'VUELO_LLENO' AS origen FROM /dmo/flight AS fl WHERE fl~seats_occupied >= fl~seats_max
    ORDER BY carrier_id, connection_id
    INTO TABLE @DATA(lt_alertas_vuelo).

    out->write( lt_alertas_vuelo ).
  ENDMETHOD.

  METHOD example_3_4a.
    out->write( '--- 3.4a Un solo CTE, filtrado otra vez en la consulta principal ---' ).

    DATA(lv_carrier) = 'SQ'.

    WITH
    +baja_ocupacion AS (
      SELECT carrier_id, connection_id, flight_date, seats_occupied
      FROM /dmo/flight
      WHERE seats_occupied < 200
    )
    SELECT carrier_id, connection_id, flight_date, seats_occupied
    FROM +baja_ocupacion
    WHERE carrier_id = @lv_carrier
    INTO TABLE @DATA(lt_baja_ocupacion_sq).

    out->write( lt_baja_ocupacion_sq ).
  ENDMETHOD.

  METHOD example_3_4b.
    out->write( '--- 3.4b Dos CTE independientes, cruzados con LEFT OUTER JOIN ---' ).

    WITH
    +baja_ocupacion AS (
      SELECT carrier_id, connection_id, flight_date, seats_occupied
      FROM /dmo/flight
      WHERE seats_occupied < 200
    ),
    +ingreso_por_conexion AS (
      SELECT carrier_id, connection_id, SUM( flight_price ) AS ingreso_total
      FROM /dmo/booking
      GROUP BY carrier_id, connection_id
    )
    SELECT baja_ocupacion~carrier_id, baja_ocupacion~connection_id, baja_ocupacion~flight_date,
           baja_ocupacion~seats_occupied, ingreso_por_conexion~ingreso_total
    FROM +baja_ocupacion AS baja_ocupacion
    LEFT OUTER JOIN +ingreso_por_conexion AS ingreso_por_conexion
      ON baja_ocupacion~carrier_id = ingreso_por_conexion~carrier_id
     AND baja_ocupacion~connection_id = ingreso_por_conexion~connection_id
    INTO TABLE @DATA(lt_candidatos_repricing).

    out->write( lt_candidatos_repricing ).
  ENDMETHOD.

  METHOD example_3_4c.
    out->write( '--- 3.4c CTE encadenados: el segundo usa el resultado del primero ---' ).

    WITH
    +ingreso_por_conexion AS (
      SELECT carrier_id, connection_id, SUM( flight_price ) AS ingreso_total
      FROM /dmo/booking
      GROUP BY carrier_id, connection_id
    ),
    +conexiones_top AS (
      SELECT carrier_id, connection_id, ingreso_total
      FROM +ingreso_por_conexion
      WHERE ingreso_total > 1000
    )
    SELECT carrier_id, connection_id, ingreso_total
    FROM +conexiones_top
    ORDER BY ingreso_total DESCENDING
    INTO TABLE @DATA(lt_conexiones_top).

    out->write( lt_conexiones_top ).
  ENDMETHOD.

ENDCLASS.
