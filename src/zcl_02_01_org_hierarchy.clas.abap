CLASS zcl_02_01_org_hierarchy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS basic_hierarchy  IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS depth_limit      IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS orphans_handling IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS cycles_handling  IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_02_01_org_hierarchy IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 1: HIERARCHIES IN SQL (own demo table ZHANA_ORG_UNIT) ===' ).

    basic_hierarchy( out ).
    depth_limit( out ).
    orphans_handling( out ).
    cycles_handling( out ).
  ENDMETHOD.

  METHOD basic_hierarchy.
    out->write( '--- 1.1 / 1.6 Basic HIERARCHY: a clean org chart, no orphans or cycles ---' ).

    DELETE FROM zhana_org_unit.

    DATA lt_org_units TYPE STANDARD TABLE OF zhana_org_unit WITH EMPTY KEY.

    lt_org_units = VALUE #(
      ( org_unit_id = 'CEO'         parent_unit_id = ' '        unit_name = 'Chief Executive Office' cost_center = 'CC-000' )
      ( org_unit_id = 'SALES'       parent_unit_id = 'CEO'      unit_name = 'Sales Division'         cost_center = 'CC-100' )
      ( org_unit_id = 'MARKETING'   parent_unit_id = 'CEO'      unit_name = 'Marketing Division'     cost_center = 'CC-200' )
      ( org_unit_id = 'SALES_EU'    parent_unit_id = 'SALES'    unit_name = 'Sales Europe'           cost_center = 'CC-110' )
      ( org_unit_id = 'SALES_US'    parent_unit_id = 'SALES'    unit_name = 'Sales US'               cost_center = 'CC-120' )
      ( org_unit_id = 'SALES_EU_ES' parent_unit_id = 'SALES_EU' unit_name = 'Sales Spain'            cost_center = 'CC-111' )
    ).

    INSERT zhana_org_unit FROM TABLE @lt_org_units.
    out->write( |Demo rows inserted: { sy-dbcnt }| ).

    SELECT FROM
      HIERARCHY(
        SOURCE zi_hana_org_unit AS org_source
        CHILD TO PARENT ASSOCIATION _ToParent
        START WHERE parent_unit_id = ' '
        SIBLINGS ORDER BY unit_name ASCENDING
        MULTIPLE PARENTS NOT ALLOWED
        ORPHANS IGNORE
      )
      FIELDS org_unit_id, unit_name, hierarchy_rank, hierarchy_tree_size
      INTO TABLE @DATA(lt_org_chart).

    out->write( lt_org_chart ).
  ENDMETHOD.

  METHOD depth_limit.
    out->write( '--- 1.2 DEPTH: limit how many levels are traversed (same clean tree) ---' ).

    SELECT FROM
      HIERARCHY(
        SOURCE zi_hana_org_unit AS org_source
        CHILD TO PARENT ASSOCIATION _ToParent
        START WHERE parent_unit_id = ' '
        DEPTH 1
        ORPHANS IGNORE
      )
      FIELDS org_unit_id, unit_name, hierarchy_rank
      INTO TABLE @DATA(lt_depth_1).

    out->write( 'DEPTH 1 (root + direct children only):' ).
    out->write( lt_depth_1 ).
  ENDMETHOD.

  METHOD orphans_handling.
    out->write( '--- 1.4 ORPHANS: an isolated dataset with one broken parent link ---' ).

    DELETE FROM zhana_org_unit.

    DATA lt_org_units TYPE STANDARD TABLE OF zhana_org_unit WITH EMPTY KEY.

    lt_org_units = VALUE #(
      ( org_unit_id = 'CEO'         parent_unit_id = ' '            unit_name = 'Chief Executive Office' cost_center = 'CC-000' )
      ( org_unit_id = 'SALES'       parent_unit_id = 'CEO'          unit_name = 'Sales Division'         cost_center = 'CC-100' )
      ( org_unit_id = 'ORPHAN_UNIT' parent_unit_id = 'GHOST_PARENT' unit_name = 'Orphan Unit'            cost_center = 'CC-999' )
    ).

    INSERT zhana_org_unit FROM TABLE @lt_org_units.
    out->write( |Demo rows inserted: { sy-dbcnt }| ).
    out->write( 'ORPHAN_UNIT points to GHOST_PARENT, which does not exist as a row.' ).

    out->write( 'Note: ORPHANS ROOT/ERROR are rejected by this system''s HANA engine' ).
    out->write( 'on a custom access-control-independent entity ("Hierarchies cannot be' ).
    out->write( 'used in combination with entities that are dependent on access control' ).
    out->write( 'lists"). ORPHANS IGNORE (the default) is used instead below.' ).

    SELECT FROM
      HIERARCHY(
        SOURCE zi_hana_org_unit AS org_source
        CHILD TO PARENT ASSOCIATION _ToParent
        START WHERE parent_unit_id = ' '
        ORPHANS IGNORE
      )
      FIELDS org_unit_id, unit_name
      INTO TABLE @DATA(lt_orphans_ignored).

    out->write( 'ORPHANS IGNORE (ORPHAN_UNIT is silently excluded from the result):' ).
    out->write( lt_orphans_ignored ).
  ENDMETHOD.

  METHOD cycles_handling.
    out->write( '--- 1.5 CYCLES: an isolated dataset where two nodes point to each other ---' ).

    DELETE FROM zhana_org_unit.

    DATA lt_org_units TYPE STANDARD TABLE OF zhana_org_unit WITH EMPTY KEY.

    lt_org_units = VALUE #(
      ( org_unit_id = 'CYCLE_A' parent_unit_id = 'CYCLE_B' unit_name = 'Cycle Node A' cost_center = 'CC-800' )
      ( org_unit_id = 'CYCLE_B' parent_unit_id = 'CYCLE_A' unit_name = 'Cycle Node B' cost_center = 'CC-801' )
    ).

    INSERT zhana_org_unit FROM TABLE @lt_org_units.
    out->write( |Demo rows inserted: { sy-dbcnt }| ).

    out->write( 'CYCLES ERROR is the default: MULTIPLE PARENTS ALLOWED/LEAVES ONLY cannot' ).
    out->write( 'be combined with a to-one association, so CYCLES BREAKUP is not usable' ).
    out->write( 'on this simple single-parent-per-row model. This shows the default' ).
    out->write( 'behavior instead: the cycle raises a catchable exception.' ).

    TRY.
        SELECT FROM
          HIERARCHY(
            SOURCE zi_hana_org_unit AS org_source
            CHILD TO PARENT ASSOCIATION _ToParent
            START WHERE org_unit_id = 'CYCLE_A'
            ORPHANS IGNORE
            CYCLES ERROR
          )
          FIELDS org_unit_id, unit_name
          INTO TABLE @DATA(lt_cycle_result).

        out->write( lt_cycle_result ).
      CATCH cx_root INTO DATA(lx_cycle_error).
        out->write( 'CYCLES ERROR raised an exception, as expected:' ).
        out->write( lx_cycle_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
