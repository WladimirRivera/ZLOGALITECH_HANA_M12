CLASS zcl_03_04_aggregations DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_04_aggregations IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 4: AGGREGATIONS AND GROUP BY ===' ).
    out->write( ' ' ).
    out->write( 'Aggregate functions summarize data over groups of rows' ).
    out->write( ' ' ).
    out->write( 'Available functions:' ).
    out->write( '* COUNT(*) - Count rows' ).
    out->write( '* SUM(field) - Sum numeric values' ).
    out->write( '* AVG(field) - Average values' ).
    out->write( '* MIN/MAX(field) - Minimum and maximum' ).
    out->write( ' ' ).
    out->write( 'Example: Totals by airline' ).
    out->write( 'define view Z_Flight_Summary' ).
    out->write( '  as select from sflight' ).
    out->write( '  {' ).
    out->write( '    key carrid as AirlineCode,' ).
    out->write( '    key currency,' ).
    out->write( '    count(*) as NumFlights,' ).
    out->write( '    sum(seatsocc) as TotalOccupancy,' ).
    out->write( '    max(price) as MaxPrice' ).
    out->write( '  }' ).
    out->write( '  group by carrid, currency' ).
    out->write( '  having count(*) > 1' ).
    out->write( ' ' ).
    out->write( 'Critical rule:' ).
    out->write( '=> Every field NOT in an aggregate function must be in GROUP BY' ).
    out->write( ' ' ).
    out->write( 'HAVING clause filters groups (like WHERE for aggregates)' ).
  ENDMETHOD.

ENDCLASS.
