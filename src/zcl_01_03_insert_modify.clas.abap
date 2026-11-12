CLASS zcl_01_03_insert_modify DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS example_5_1a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_1b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_1c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_2a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_2b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_2c IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_0a IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS example_5_0b IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_01_03_insert_modify IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== TEMA 5: ESCRITURAS - CRUD BASICO Y INSERT/MODIFY FROM SELECT ===' ).
    out->write( 'Tabla destino: ZAXH_BOOK_SUM (resumen de reservas por conexion)' ).

    example_5_0a( out ).
    example_5_0b( out ).
    example_5_1a( out ).
    example_5_1b( out ).
    example_5_1c( out ).
    example_5_2a( out ).
    example_5_2b( out ).
    example_5_2c( out ).
  ENDMETHOD.

  METHOD example_5_0a.
    out->write( '--- 5.0a CRUD basico sobre una ESTRUCTURA (un solo registro) ---' ).

    DATA(ls_resumen) = VALUE zaxh_book_sum( carrier_id      = 'ZZZ'
                                             connection_id   = '9999'
                                             currency_code   = 'EUR'
                                             total_bookings  = 1
                                             total_revenue   = '100.00' ).

    INSERT zaxh_book_sum FROM @ls_resumen.
    out->write( |INSERT  -> sy-subrc: { sy-subrc } (0 = OK), filas: { sy-dbcnt }| ).

    ls_resumen-total_bookings = 2.
    ls_resumen-total_revenue  = '250.00'.
    MODIFY zaxh_book_sum FROM @ls_resumen.
    out->write( |MODIFY  -> sy-subrc: { sy-subrc }, filas: { sy-dbcnt }| ).

    ls_resumen-total_revenue = '300.00'.
    UPDATE zaxh_book_sum FROM @ls_resumen.
    out->write( |UPDATE  -> sy-subrc: { sy-subrc } (0 = encontrado y actualizado)| ).

    SELECT SINGLE * FROM zaxh_book_sum
      WHERE carrier_id = @ls_resumen-carrier_id
        AND connection_id = @ls_resumen-connection_id
      INTO @DATA(ls_verificacion).
    out->write( ls_verificacion ).

    DELETE FROM zaxh_book_sum
      WHERE carrier_id = @ls_resumen-carrier_id
        AND connection_id = @ls_resumen-connection_id.
    out->write( |DELETE  -> sy-subrc: { sy-subrc }, filas eliminadas: { sy-dbcnt }| ).
  ENDMETHOD.

  METHOD example_5_0b.
    out->write( '--- 5.0b CRUD basico sobre una TABLA INTERNA (varios registros) ---' ).

    DATA lt_resumen TYPE STANDARD TABLE OF zaxh_book_sum WITH EMPTY KEY.

    lt_resumen = VALUE #(
      ( carrier_id = 'ZZZ' connection_id = '9001' currency_code = 'EUR' total_bookings = 1 total_revenue = '50.00' )
      ( carrier_id = 'ZZZ' connection_id = '9002' currency_code = 'EUR' total_bookings = 2 total_revenue = '120.00' )
      ( carrier_id = 'ZZZ' connection_id = '9003' currency_code = 'EUR' total_bookings = 3 total_revenue = '180.00' )
    ).

    INSERT zaxh_book_sum FROM TABLE @lt_resumen.
    out->write( |INSERT (tabla) -> sy-subrc: { sy-subrc }, filas: { sy-dbcnt }| ).

    LOOP AT lt_resumen ASSIGNING FIELD-SYMBOL(<ls_modify>).
      <ls_modify>-total_bookings = <ls_modify>-total_bookings + 1.
    ENDLOOP.

    MODIFY zaxh_book_sum FROM TABLE @lt_resumen.
    out->write( |MODIFY (tabla) -> sy-subrc: { sy-subrc }, filas: { sy-dbcnt }| ).

    LOOP AT lt_resumen ASSIGNING FIELD-SYMBOL(<ls_update>).
      <ls_update>-total_revenue = <ls_update>-total_revenue + 10.
    ENDLOOP.

    UPDATE zaxh_book_sum FROM TABLE @lt_resumen.
    out->write( |UPDATE (tabla) -> sy-subrc: { sy-subrc }, filas: { sy-dbcnt }| ).

    SELECT * FROM zaxh_book_sum WHERE carrier_id = 'ZZZ' INTO TABLE @DATA(lt_verificacion).
    out->write( lt_verificacion ).

    DELETE zaxh_book_sum FROM TABLE @lt_resumen.
    out->write( |DELETE (tabla) -> sy-subrc: { sy-subrc }, filas eliminadas: { sy-dbcnt }| ).
  ENDMETHOD.

  METHOD example_5_1a.
    out->write( '--- 5.1a INSERT ... FROM ( SELECT ... ): agregacion insertada directamente ---' ).

    DELETE FROM zaxh_book_sum.

    INSERT zaxh_book_sum FROM (
      SELECT carrier_id, connection_id, currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( flight_price ) AS total_revenue
      FROM /dmo/booking
      GROUP BY carrier_id, connection_id, currency_code
    ).

    out->write( |Filas insertadas: { sy-dbcnt }| ).
    out->write( 'Sugerencia para clase: ejecuta este metodo una segunda vez (F9 en Eclipse)' ).
    out->write( 'sin borrar antes la tabla para provocar el error de clave duplicada.' ).

    SELECT * FROM zaxh_book_sum ORDER BY total_revenue DESCENDING INTO TABLE @DATA(lt_resumen).
    out->write( lt_resumen ).
  ENDMETHOD.

  METHOD example_5_1b.
    out->write( '--- 5.1b INSERT ... FROM ( SELECT ... ) con un JOIN adicional en la subconsulta ---' ).

    DELETE FROM zaxh_book_sum.

    INSERT zaxh_book_sum FROM (
      SELECT b~carrier_id, b~connection_id, b~currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( b~flight_price ) AS total_revenue
      FROM /dmo/booking AS b
      INNER JOIN /dmo/connection AS c
        ON b~carrier_id = c~carrier_id
       AND b~connection_id = c~connection_id
      WHERE c~distance > 3000
      GROUP BY b~carrier_id, b~connection_id, b~currency_code
    ).

    out->write( |Filas insertadas (solo conexiones de largo alcance, distance > 3000): { sy-dbcnt }| ).

    SELECT * FROM zaxh_book_sum INTO TABLE @DATA(lt_resumen_largo_alcance).
    out->write( lt_resumen_largo_alcance ).
  ENDMETHOD.

  METHOD example_5_1c.
    out->write( '--- 5.1c INSERT ... FROM ( SELECT ... ) alimentado por una subconsulta con dos JOIN ---' ).

    DELETE FROM zaxh_book_sum.

    INSERT zaxh_book_sum FROM (
      SELECT b~carrier_id, b~connection_id, b~currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( b~flight_price ) AS total_revenue
      FROM /dmo/booking AS b
      INNER JOIN /dmo/flight AS f
        ON  b~carrier_id = f~carrier_id
        AND b~connection_id = f~connection_id
        AND b~flight_date = f~flight_date
      INNER JOIN /dmo/carrier AS c
        ON f~carrier_id = c~carrier_id
      WHERE c~currency_code = 'EUR'
      GROUP BY b~carrier_id, b~connection_id, b~currency_code
    ).

    out->write( |Filas insertadas (solo aerolineas que cobran en EUR): { sy-dbcnt }| ).

    SELECT * FROM zaxh_book_sum INTO TABLE @DATA(lt_resumen_eur).
    out->write( lt_resumen_eur ).
  ENDMETHOD.

  METHOD example_5_2a.
    out->write( '--- 5.2a MODIFY ... FROM ( SELECT ... ): upsert basico ---' ).

    MODIFY zaxh_book_sum FROM (
      SELECT carrier_id, connection_id, currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( flight_price ) AS total_revenue
      FROM /dmo/booking
      GROUP BY carrier_id, connection_id, currency_code
    ).

    out->write( |Filas afectadas (insertadas o actualizadas): { sy-dbcnt }| ).
  ENDMETHOD.

  METHOD example_5_2b.
    out->write( '--- 5.2b Misma subconsulta que 5.1a, pero con MODIFY: se puede repetir ---' ).

    MODIFY zaxh_book_sum FROM (
      SELECT carrier_id, connection_id, currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( flight_price ) AS total_revenue
      FROM /dmo/booking
      GROUP BY carrier_id, connection_id, currency_code
    ).

    out->write( |Filas afectadas: { sy-dbcnt }| ).
    out->write( 'Ejecuta este metodo varias veces (F9) para comprobar que nunca falla,' ).
    out->write( 'a diferencia de INSERT en 5.1a.' ).

    SELECT * FROM zaxh_book_sum ORDER BY total_revenue DESCENDING INTO TABLE @DATA(lt_resumen).
    out->write( lt_resumen ).
  ENDMETHOD.

  METHOD example_5_2c.
    out->write( '--- 5.2c La subconsulta de MODIFY tambien admite UNION ---' ).

    MODIFY zaxh_book_sum FROM (
      SELECT carrier_id, connection_id, currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( flight_price ) AS total_revenue
      FROM /dmo/booking
      WHERE flight_price > 400
      GROUP BY carrier_id, connection_id, currency_code
      UNION ALL
      SELECT carrier_id, connection_id, currency_code,
             CAST( COUNT(*) AS int4 ) AS total_bookings,
             SUM( flight_price ) AS total_revenue
      FROM /dmo/booking
      WHERE flight_price <= 400
      GROUP BY carrier_id, connection_id, currency_code
    ).

    out->write( |Filas afectadas: { sy-dbcnt }| ).
  ENDMETHOD.

ENDCLASS.
