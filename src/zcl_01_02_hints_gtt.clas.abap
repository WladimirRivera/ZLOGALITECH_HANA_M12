CLASS zcl_01_02_hints_gtt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS ejemplo_4_1a    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_4_1b    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_4_1c    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS ejemplo_4_2_gtt IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_01_02_hints_gtt IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== TEMA 4: HINTS (%_HINTS) Y TABLAS TEMPORALES GLOBALES (GTT) ===' ).
    out->write( 'Se aplica sobre ZAXH_BOOK_SUM (tabla propia, Tema 5).' ).
    out->write( 'Ejecuta antes ZCL_01_03_INSERT_MODIFY para tener filas aqui.' ).

    ejemplo_4_1a( out ).
    ejemplo_4_1b( out ).
    ejemplo_4_1c( out ).
    ejemplo_4_2_gtt( out ).
  ENDMETHOD.

  METHOD ejemplo_4_1a.
    out->write( '--- 4.1a Un unico hint sobre la consulta de ZAXH_BOOK_SUM ---' ).

    DATA(lv_hint)     = `IGNORE_PLAN_CACHE`.
    DATA(lv_carrier)  = 'UA'.

    SELECT carrier_id, connection_id, total_bookings, total_revenue
      FROM zaxh_book_sum
      WHERE carrier_id = @lv_carrier
      %_HINTS HDB @lv_hint
      INTO TABLE @DATA(lt_resumen_hint).

    out->write( lt_resumen_hint ).
  ENDMETHOD.

  METHOD ejemplo_4_1b.
    out->write( '--- 4.1b Varios hints encadenados en la misma consulta ---' ).

    DATA(lv_hint1)   = `IGNORE_PLAN_CACHE`.
    DATA(lv_hint2)   = `NO_STATISTICS_UPDATE`.
    DATA(lv_carrier) = 'UA'.

    SELECT carrier_id, connection_id, total_bookings, total_revenue
      FROM zaxh_book_sum
      WHERE carrier_id = @lv_carrier
      %_HINTS HDB @lv_hint1
              HDB @lv_hint2
      INTO TABLE @DATA(lt_resumen_hint2).

    out->write( lt_resumen_hint2 ).
  ENDMETHOD.

  METHOD ejemplo_4_1c.
    out->write( '--- 4.1c Hint aplicado a un DELETE, no solo a un SELECT ---' ).

    DATA(lv_hint)    = `IGNORE_PLAN_CACHE`.
    DATA(lv_carrier) = 'UA'.

    DELETE FROM zaxh_book_sum
      WHERE carrier_id = @lv_carrier
      %_HINTS HDB @lv_hint.

    out->write( |Filas eliminadas (con hint aplicado): { sy-dbcnt }| ).
  ENDMETHOD.

  METHOD ejemplo_4_2_gtt.
    out->write( '--- 4.2 Tablas temporales globales (GTT) ---' ).
    out->write( 'ARC-1 (la herramienta usada para crear estas clases) no puede crear' ).
    out->write( 'objetos DDIC con categoria "tabla temporal global" via API ADT.' ).
    out->write( 'Para ejecutar este bloque en clase, crea manualmente en Eclipse:' ).
    out->write( '  File > New > Other > ABAP Repository Object > Database Table' ).
    out->write( '  Nombre: ZAXH_BOOK_TMP  |  Categoria: Temporary Table (GTT)' ).
    out->write( '  Campos: CARRIER_ID (CHAR 2), CONNECTION_ID (NUMC 4), TOTAL_BOOKINGS (INT4)' ).
    out->write( 'Una vez creada la GTT, descomenta el bloque de codigo debajo de este' ).
    out->write( 'metodo (en el editor ABAP de Eclipse) y ejecutalo (F9).' ).

* ============================================================
* Ejemplo 4.2a - llenar, leer y limpiar antes del COMMIT (ciclo minimo)
* ============================================================
* INSERT zaxh_book_tmp FROM (
*   SELECT carrier_id, connection_id, COUNT(*) AS total_bookings
*   FROM /dmo/booking
*   GROUP BY carrier_id, connection_id
* ).
*
* SELECT carrier_id, connection_id, total_bookings
*   FROM zaxh_book_tmp
*   WHERE total_bookings > 2
*   INTO TABLE @DATA(lt_conexiones_alta_demanda).
*
* DELETE FROM zaxh_book_tmp.
* COMMIT WORK.
*
* out->write( lt_conexiones_alta_demanda ).

* ============================================================
* Ejemplo 4.2b - la misma carga se consulta dos veces con filtros distintos
* ============================================================
* INSERT zaxh_book_tmp FROM (
*   SELECT carrier_id, connection_id, COUNT(*) AS total_bookings
*   FROM /dmo/booking
*   GROUP BY carrier_id, connection_id
* ).
*
* SELECT * FROM zaxh_book_tmp WHERE carrier_id = 'UA'
*   INTO TABLE @DATA(lt_ua).
*
* SELECT * FROM zaxh_book_tmp WHERE total_bookings > 2
*   INTO TABLE @DATA(lt_alta_demanda).
*
* DELETE FROM zaxh_book_tmp.

* ============================================================
* Ejemplo 4.2c - refresco parcial: solo se limpia y recarga una aerolinea
* ============================================================
* DATA(lv_carrier) = 'UA'.
*
* DELETE FROM zaxh_book_tmp WHERE carrier_id = @lv_carrier.
*
* INSERT zaxh_book_tmp FROM (
*   SELECT carrier_id, connection_id, COUNT(*) AS total_bookings
*   FROM /dmo/booking
*   WHERE carrier_id = @lv_carrier
*   GROUP BY carrier_id, connection_id
* ).

  ENDMETHOD.

ENDCLASS.
