CLASS zcl_02_09_secondary_indexes DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS the_problem           IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS how_to_create         IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS composite_index_order IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS best_practices        IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_02_09_secondary_indexes IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 7: SECONDARY INDEXES ===' ).
    out->write( 'No index is created by this class: changing an index on a shared' ).
    out->write( '/DMO/* table is a structural DDIC change, out of scope here.' ).

    the_problem( out ).
    how_to_create( out ).
    composite_index_order( out ).
    best_practices( out ).
  ENDMETHOD.


  METHOD the_problem.
    out->write( '--- 7.1 / 7.2 The problem: filtering by a non-key field ---' ).

    SELECT FROM /dmo/i_connection
      FIELDS airlineid, connectionid, distance, distanceunit
      WHERE distanceunit = 'KM'
      INTO TABLE @DATA(lt_connections_km)
      UP TO 20 ROWS.

    out->write( |Rows found filtering by the non-key field DISTANCEUNIT: { lines( lt_connections_km ) }| ).
    out->write( 'A frequent, selective query like this one, over a high-volume table,' ).
    out->write( 'justifies a secondary index on DISTANCEUNIT (verify first with ST05).' ).
  ENDMETHOD.


  METHOD how_to_create.
    out->write( '--- 7.3 How to create a secondary index (SE11) ---' ).
    out->write( '1. Run SE11, open the transparent table, choose "Indexes".' ).
    out->write( '2. Create icon -> "Create index"; assign a technical name (e.g. Z01).' ).
    out->write( '3. Fill the short description and add, in order, the non-key fields.' ).
    out->write( '4. Save (generates a transport) and activate to create the DB structure.' ).
  ENDMETHOD.


  METHOD composite_index_order.
    out->write( '--- 7.4 Field order in a composite index ---' ).
    out->write( 'An index on (FIELD1, FIELD2) fully accelerates queries filtering by' ).
    out->write( 'both fields, or FIELD1 alone, but helps little for FIELD2-only filters.' ).
    out->write( 'If both patterns are frequent, create a simple index on FIELD1 AND a' ).
    out->write( 'composite index on FIELD1 + FIELD2.' ).
  ENDMETHOD.


  METHOD best_practices.
    out->write( '--- 7.5 Best practices ---' ).
    out->write( '- Every extra index speeds up reads but slows down writes: do not' ).
    out->write( '  create indexes indiscriminately.' ).
    out->write( '- Put the most selective fields first in the index definition.' ).
    out->write( '- Avoid redundant indexes that share the same leading fields.' ).
    out->write( '- Validate impact on a test system before creating one in production.' ).
    out->write( '- An index does not guarantee improvement: the optimizer may skip it.' ).
  ENDMETHOD.

ENDCLASS.
