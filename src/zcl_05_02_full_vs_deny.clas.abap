CLASS zcl_05_02_full_vs_deny DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_access_result,
        view_name       TYPE string,
        strategy        TYPE string,
        rows_with_dcl   TYPE i,
        rows_privileged TYPE i,
      END OF ty_access_result,
      tt_access_result TYPE STANDARD TABLE OF ty_access_result WITH EMPTY KEY,
      tt_carrier       TYPE STANDARD TABLE OF zcds_05_02_carrier_priv WITH EMPTY KEY.

    METHODS compare_strategies
      RETURNING VALUE(rt_result) TYPE tt_access_result.

    METHODS read_privileged_only
      RETURNING VALUE(rt_carrier) TYPE tt_carrier.

ENDCLASS.


CLASS zcl_05_02_full_vs_deny IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( data = compare_strategies( )
                name = 'Full access (where true) vs. no access (where false)' ).

    out->write( data = read_privileged_only( )
                name = 'ZCDS_05_02_CARRIER_PRIV read WITH PRIVILEGED ACCESS' ).
  ENDMETHOD.


  METHOD compare_strategies.
    SELECT COUNT(*) FROM zcds_05_02_carrier_full
      INTO @DATA(lv_full_dcl).
    SELECT COUNT(*) FROM zcds_05_02_carrier_full WITH PRIVILEGED ACCESS
      INTO @DATA(lv_full_priv).

    SELECT COUNT(*) FROM zcds_05_02_carrier_deny
      INTO @DATA(lv_deny_dcl).
    SELECT COUNT(*) FROM zcds_05_02_carrier_deny WITH PRIVILEGED ACCESS
      INTO @DATA(lv_deny_priv).

    DATA lv_priv_dcl TYPE i.
    DATA lv_priv_note TYPE string VALUE '#PRIVILEGED_ONLY, no role'.
    TRY.
        SELECT COUNT(*) FROM zcds_05_02_carrier_priv
          INTO @lv_priv_dcl.
      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        lv_priv_note = |#PRIVILEGED_ONLY: { lx_sql->get_text( ) }|.
    ENDTRY.
    SELECT COUNT(*) FROM zcds_05_02_carrier_priv WITH PRIVILEGED ACCESS
      INTO @DATA(lv_priv_priv).

    rt_result = VALUE #(
      ( view_name       = 'ZCDS_05_02_CARRIER_FULL'
        strategy        = 'Role: where true'
        rows_with_dcl   = lv_full_dcl
        rows_privileged = lv_full_priv )
      ( view_name       = 'ZCDS_05_02_CARRIER_DENY'
        strategy        = 'Role: where false'
        rows_with_dcl   = lv_deny_dcl
        rows_privileged = lv_deny_priv )
      ( view_name       = 'ZCDS_05_02_CARRIER_PRIV'
        strategy        = lv_priv_note
        rows_with_dcl   = lv_priv_dcl
        rows_privileged = lv_priv_priv ) ).
  ENDMETHOD.


  METHOD read_privileged_only.
    SELECT FROM zcds_05_02_carrier_priv WITH PRIVILEGED ACCESS
      FIELDS *
      ORDER BY CarrierId
      INTO TABLE @rt_carrier.
  ENDMETHOD.

ENDCLASS.

