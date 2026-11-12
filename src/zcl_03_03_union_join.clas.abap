CLASS zcl_03_03_union_join DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_03_union_join IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 3: UNION AND JOIN ===' ).
    out->write( ' ' ).
    out->write( 'UNION: Combine rows from multiple SELECT results' ).
    out->write( ' ' ).
    out->write( 'Example: Combine origin and destination cities' ).
    out->write( 'define view Z_Flight_Cities' ).
    out->write( '  as select from spfli' ).
    out->write( '  {' ).
    out->write( '    key countryfr as Country,' ).
    out->write( '    key cityfrom as City' ).
    out->write( '  }' ).
    out->write( '  union' ).
    out->write( '  select from spfli' ).
    out->write( '  {' ).
    out->write( '    countryto as Country,' ).
    out->write( '    cityto as City' ).
    out->write( '  }' ).
    out->write( ' ' ).
    out->write( 'JOIN: Add columns from related table' ).
    out->write( ' ' ).
    out->write( 'Example: Flights with airline names' ).
    out->write( 'define view Z_Flight_Details' ).
    out->write( '  as select from sflight as f' ).
    out->write( '  inner join scarr as a on a.carrid = f.carrid' ).
    out->write( '  {' ).
    out->write( '    key f.carrid,' ).
    out->write( '    key f.connid,' ).
    out->write( '    key f.fldate,' ).
    out->write( '    a.carrname as AirlineName,' ).
    out->write( '    f.seatsocc as OccupiedSeats' ).
    out->write( '  }' ).
    out->write( ' ' ).
    out->write( 'Key differences:' ).
    out->write( '* UNION stacks rows (no duplicates without ALL)' ).
    out->write( '* JOIN adds columns side-by-side' ).
    out->write( '* Keys in UNION come from first SELECT only' ).
  ENDMETHOD.

ENDCLASS.
