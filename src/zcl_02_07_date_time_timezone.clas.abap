CLASS zcl_02_07_date_time_timezone DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS date_functions      IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS timestamp_functions IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS timezone_functions  IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_02_07_date_time_timezone IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 5: DATE, TIME AND TIMEZONE SQL FUNCTIONS ===' ).
    out->write( 'All functions run inside the database (HANA); /DMO/I_FLIGHT is used' ).
    out->write( 'only as a one-row anchor for the SELECT (UP TO 1 ROWS).' ).

    date_functions( out ).
    timestamp_functions( out ).
    timezone_functions( out ).
  ENDMETHOD.

  METHOD date_functions.
    out->write( '--- 5.1 Date functions: DATS_IS_VALID, DATS_DAYS_BETWEEN, DATS_ADD_DAYS, DATS_ADD_MONTHS ---' ).

    DATA(lv_start_date) = CONV d( '20260101' ).
    DATA(lv_end_date)   = CONV d( '20260615' ).
    DATA lv_bad_date TYPE d.
    lv_bad_date = '20261332'.

    SELECT FROM /dmo/i_flight
      FIELDS DATS_IS_VALID( @lv_start_date )                   AS start_date_valid,
             DATS_IS_VALID( @lv_bad_date )                     AS bad_date_valid,
             DATS_DAYS_BETWEEN( @lv_start_date, @lv_end_date ) AS days_between,
             DATS_ADD_DAYS( @lv_start_date, 30 )               AS start_plus_30_days,
             DATS_ADD_MONTHS( @lv_start_date, 6 )              AS start_plus_6_months
      INTO TABLE @DATA(lt_date_results)
      UP TO 1 ROWS.

    out->write( lt_date_results ).
  ENDMETHOD.

  METHOD timestamp_functions.
    out->write( '--- 5.2 Timestamp functions: TSTMP_IS_VALID, TSTMP_CURRENT_UTCTIMESTAMP ---' ).

    SELECT FROM /dmo/i_flight
      FIELDS TSTMP_CURRENT_UTCTIMESTAMP( ) AS current_utc_timestamp
      INTO TABLE @DATA(lt_current_tstmp)
      UP TO 1 ROWS.

    out->write( lt_current_tstmp ).

    DATA lv_tstmp_1 TYPE timestamp.
    GET TIME STAMP FIELD lv_tstmp_1.

    SELECT FROM /dmo/i_flight
      FIELDS TSTMP_IS_VALID( @lv_tstmp_1 ) AS timestamp_valid
      INTO TABLE @DATA(lt_tstmp_results)
      UP TO 1 ROWS.

    out->write( lt_tstmp_results ).
  ENDMETHOD.

  METHOD timezone_functions.
    out->write( '--- 5.3 Timezone functions: ABAP_SYSTEM_TIMEZONE ---' ).

    SELECT FROM /dmo/i_flight
      FIELDS ABAP_SYSTEM_TIMEZONE( client = @sy-mandt ) AS system_timezone
      INTO TABLE @DATA(lt_timezones)
      UP TO 1 ROWS.

    out->write( lt_timezones ).
  ENDMETHOD.

ENDCLASS.
