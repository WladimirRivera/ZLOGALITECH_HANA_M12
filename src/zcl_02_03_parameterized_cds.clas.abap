CLASS zcl_02_03_parameterized_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS consume_with_literal    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS consume_with_variable   IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_02_03_parameterized_cds IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 3: PARAMETERIZED CDS VIEWS CONSUMED FROM ABAP SQL ===' ).
    out->write( 'View: ZI_HANA_FLIGHT_MAXPRICE( p_max_price ) filters /DMO/I_FLIGHT by price.' ).

    consume_with_literal( out ).
    consume_with_variable( out ).
  ENDMETHOD.


  METHOD consume_with_literal.
    out->write( '--- 3.2 Consuming a parameterized CDS view: literal parameter value ---' ).

    SELECT FROM zi_hana_flight_maxprice( p_max_price = '300.00' )
      FIELDS airlineid, connectionid, flightdate, price, currencycode
      ORDER BY price ASCENDING
      INTO TABLE @DATA(lt_cheap_flights)
      UP TO 20 ROWS.

    out->write( lt_cheap_flights ).
  ENDMETHOD.


  METHOD consume_with_variable.
    out->write( '--- 3.2 Consuming a parameterized CDS view: host variable as parameter ---' ).

    DATA lv_max_price TYPE p LENGTH 8 DECIMALS 2 VALUE '600.00'.

    SELECT FROM zi_hana_flight_maxprice( p_max_price = @lv_max_price )
      FIELDS airlineid, connectionid, flightdate, price, currencycode
      WHERE currencycode = 'EUR'
      ORDER BY price DESCENDING
      INTO TABLE @DATA(lt_flights_eur)
      UP TO 20 ROWS.

    out->write( lt_flights_eur ).
  ENDMETHOD.

ENDCLASS.
