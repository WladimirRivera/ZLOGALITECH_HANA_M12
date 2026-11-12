CLASS zcl_02_05_sql_func_concat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

ENDCLASS.



CLASS zcl_02_05_sql_func_concat IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 4.2: CONCATENATION SQL FUNCTIONS ===' ).
    out->write( '--- CONCAT, CONCAT_WITH_SPACE, && on /DMO/I_CUSTOMER ---' ).

    SELECT FROM /dmo/i_customer
      FIELDS customerid,
             CONCAT( firstname, lastname )              AS full_name_concat,
             CONCAT_WITH_SPACE( firstname, lastname, 1 ) AS full_name_spaced,
             firstname && ' ' && lastname                AS full_name_operator
      INTO TABLE @DATA(lt_customer_names)
      UP TO 20 ROWS.

    out->write( lt_customer_names ).
  ENDMETHOD.

ENDCLASS.
