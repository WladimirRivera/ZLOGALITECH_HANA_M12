CLASS zcl_03_06_parameters DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_06_parameters IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 6: PARAMETERIZED CDS VIEWS ===' ).
    out->write( ' ' ).
    out->write( 'Parameters let the consumer customize view results at query time' ).
    out->write( ' ' ).
    out->write( 'Example: Filter flights by currency' ).
    out->write( 'define view Z_Flight_By_Currency' ).
    out->write( '  with parameters' ).
    out->write( '    p_currency : abap.cuky( 5 )' ).
    out->write( '  as select from sflight' ).
    out->write( '  {' ).
    out->write( '    key carrid,' ).
    out->write( '    key connid,' ).
    out->write( '    key fldate,' ).
    out->write( '    $parameters.p_currency as Currency,' ).
    out->write( '    price as Price' ).
    out->write( '  }' ).
    out->write( '  where currency = $parameters.p_currency' ).
    out->write( ' ' ).
    out->write( 'Consuming from ABAP SQL:' ).
    out->write( 'SELECT FROM z_flight_by_currency(' ).
    out->write( '  p_currency = ''USD'' )' ).
    out->write( '  INTO TABLE @DATA(lt_flights)' ).
    out->write( '  UP TO 20 ROWS.' ).
    out->write( ' ' ).
    out->write( 'Consuming from another CDS view:' ).
    out->write( 'define view Z_Flight_USD' ).
    out->write( '  as select from Z_Flight_By_Currency(' ).
    out->write( '    p_currency: ''USD'' )' ).
    out->write( '  { carrid, connid, fldate, price }' ).
    out->write( ' ' ).
    out->write( 'Parameters = one model, many consumers!' ).
  ENDMETHOD.

ENDCLASS.
