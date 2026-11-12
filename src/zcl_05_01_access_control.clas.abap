CLASS zcl_05_01_access_control DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_access_result,
        view_name       TYPE string,
        role_type       TYPE string,
        rows_with_dcl   TYPE i,
        rows_privileged TYPE i,
      END OF ty_access_result,
      tt_access_result TYPE STANDARD TABLE OF ty_access_result WITH EMPTY KEY,

      BEGIN OF ty_currency_count,
        currency_code TYPE /dmo/currency_code,
        travels       TYPE i,
      END OF ty_currency_count,
      tt_currency_count TYPE STANDARD TABLE OF ty_currency_count WITH EMPTY KEY.

    METHODS compare_access
      RETURNING VALUE(rt_result) TYPE tt_access_result.

    METHODS get_currencies_with_dcl
      RETURNING VALUE(rt_currencies) TYPE tt_currency_count.

    METHODS get_currencies_privileged
      RETURNING VALUE(rt_currencies) TYPE tt_currency_count.

ENDCLASS.


CLASS zcl_05_01_access_control IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( data = compare_access( )
                name = 'Rows returned: with DCL vs. WITH PRIVILEGED ACCESS' ).

    out->write( data = get_currencies_with_dcl( )
                name = 'ZCDS_05_01_TRAVEL with DCL (only EUR expected)' ).

    out->write( data = get_currencies_privileged( )
                name = 'ZCDS_05_01_TRAVEL WITH PRIVILEGED ACCESS (all currencies)' ).
  ENDMETHOD.


  METHOD compare_access.
    SELECT COUNT(*) FROM zcds_05_01_travel
      INTO @DATA(lv_travel_dcl).
    SELECT COUNT(*) FROM zcds_05_01_travel WITH PRIVILEGED ACCESS
      INTO @DATA(lv_travel_priv).

    SELECT COUNT(*) FROM zcds_05_01_agency
      INTO @DATA(lv_agency_dcl).
    SELECT COUNT(*) FROM zcds_05_01_agency WITH PRIVILEGED ACCESS
      INTO @DATA(lv_agency_priv).

    SELECT COUNT(*) FROM zcds_05_01_travel_inh
      INTO @DATA(lv_inh_dcl).
    SELECT COUNT(*) FROM zcds_05_01_travel_inh WITH PRIVILEGED ACCESS
      INTO @DATA(lv_inh_priv).

    rt_result = VALUE #(
      ( view_name       = 'ZCDS_05_01_TRAVEL'
        role_type       = 'Literal conditions'
        rows_with_dcl   = lv_travel_dcl
        rows_privileged = lv_travel_priv )
      ( view_name       = 'ZCDS_05_01_AGENCY'
        role_type       = 'PFCG aspect /DMO/TRVL'
        rows_with_dcl   = lv_agency_dcl
        rows_privileged = lv_agency_priv )
      ( view_name       = 'ZCDS_05_01_TRAVEL_INH'
        role_type       = 'Inherited conditions'
        rows_with_dcl   = lv_inh_dcl
        rows_privileged = lv_inh_priv ) ).
  ENDMETHOD.


  METHOD get_currencies_with_dcl.
    SELECT FROM zcds_05_01_travel
      FIELDS CurrencyCode AS currency_code,
             COUNT(*)     AS travels
      GROUP BY CurrencyCode
      ORDER BY CurrencyCode
      INTO TABLE @rt_currencies.
  ENDMETHOD.


  METHOD get_currencies_privileged.
    SELECT FROM zcds_05_01_travel WITH PRIVILEGED ACCESS
      FIELDS CurrencyCode AS currency_code,
             COUNT(*)     AS travels
      GROUP BY CurrencyCode
      ORDER BY CurrencyCode
      INTO TABLE @rt_currencies.
  ENDMETHOD.

ENDCLASS.

