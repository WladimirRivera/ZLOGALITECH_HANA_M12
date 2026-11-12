CLASS zcl_02_06_sql_func_string DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS string_functions_carrier IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS string_functions_airport IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS trim_functions            IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_02_06_sql_func_string IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 4.3: STRING SQL FUNCTIONS ===' ).

    string_functions_carrier( out ).
    string_functions_airport( out ).
    trim_functions( out ).
  ENDMETHOD.

  METHOD string_functions_carrier.
    out->write( '--- LEFT, RIGHT, UPPER, LOWER, LENGTH on /DMO/I_CARRIER ---' ).

    SELECT FROM /dmo/i_carrier
      FIELDS airlineid, name,
             UPPER( name )    AS name_upper,
             LOWER( name )    AS name_lower,
             LEFT( name, 3 )  AS name_left3,
             RIGHT( name, 3 ) AS name_right3,
             LENGTH( name )   AS name_length
      INTO TABLE @DATA(lt_carriers)
      UP TO 20 ROWS.

    out->write( lt_carriers ).
  ENDMETHOD.

  METHOD string_functions_airport.
    out->write( '--- LPAD, RPAD, INSTR, REPLACE, SUBSTRING on /DMO/I_AIRPORT ---' ).

    SELECT FROM /dmo/i_airport
      FIELDS airportid, name, city,
             LPAD( airportid, 6, '0' )                 AS airport_id_padded,
             RPAD( city, 15, '.' )                      AS city_padded,
             INSTR( name, 'International' )             AS pos_international,
             REPLACE( name, 'International', 'Intl.' )  AS name_short,
             SUBSTRING( name, 1, 10 )                   AS name_first_10
      INTO TABLE @DATA(lt_airports)
      UP TO 20 ROWS.

    out->write( lt_airports ).
  ENDMETHOD.

  METHOD trim_functions.
    out->write( '--- LTRIM / RTRIM: trimming a single character from a literal value ---' ).

    DATA(lv_padded_code) = '00AB1200'.

    SELECT SINGLE FROM /dmo/i_airport
      FIELDS LTRIM( @lv_padded_code, '0' ) AS code_ltrim,
             RTRIM( @lv_padded_code, '0' ) AS code_rtrim
      INTO @DATA(ls_result).

    out->write( |Original: '{ lv_padded_code }'| ).
    out->write( ls_result ).
  ENDMETHOD.

ENDCLASS.
