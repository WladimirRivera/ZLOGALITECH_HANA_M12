CLASS zcl_03_01_basic_view DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_01_basic_view IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 1: BASIC VIEW - CAST AND CASE ===' ).
    out->write( ' ' ).
    out->write( 'Concept: CAST converts data types; CASE creates conditional fields' ).
    out->write( ' ' ).
    out->write( 'Example DDL:' ).
    out->write( '@AccessControl.authorizationCheck: #NOT_REQUIRED' ).
    out->write( 'define view Z_Flight_Basic' ).
    out->write( '  as select from sflight' ).
    out->write( '  {' ).
    out->write( '    key carrid as AirlineCode,' ).
    out->write( '    key connid as ConnectionId,' ).
    out->write( '    key fldate as FlightDate,' ).
    out->write( '    cast( fldate as abap.char( 8 ) ) as FlightDateText,' ).
    out->write( '    cast( case' ).
    out->write( '      when seatsocc = 0 then ''No bookings''' ).
    out->write( '      when seatsocc < seatsmax then ''Available''' ).
    out->write( '      else ''Full''' ).
    out->write( '    end as abap.char( 12 ) ) as OccupancyStatus' ).
    out->write( '  }' ).
    out->write( ' ' ).
    out->write( 'Key points:' ).
    out->write( '* CAST changes type of a field' ).
    out->write( '* CASE simple: compares one operand against multiple values' ).
    out->write( '* CASE complex: evaluates independent conditions' ).
    out->write( '* KEY fields mark primary key columns' ).
    out->write( '* All calculated fields need an alias (AS ColumnName)' ).
  ENDMETHOD.

ENDCLASS.
