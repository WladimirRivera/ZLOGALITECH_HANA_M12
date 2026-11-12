CLASS zcl_03_07_integrating_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_07_integrating_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 7: INTEGRATING EXERCISE - DASHBOARD ===' ).
    out->write( ' ' ).
    out->write( 'Combining all concepts: parameters, JOIN, aggregation, semantics' ).
    out->write( ' ' ).
    out->write( 'Define a base view with currency parameter:' ).
    out->write( 'define view Z_Flight_Price_Conv' ).
    out->write( '  with parameters' ).
    out->write( '    p_currency : abap.cuky( 5 ),' ).
    out->write( '    p_date : abap.dats' ).
    out->write( '  as select from sflight' ).
    out->write( '  {' ).
    out->write( '    key carrid,' ).
    out->write( '    key connid,' ).
    out->write( '    key fldate,' ).
    out->write( '    $parameters.p_currency as Currency,' ).
    out->write( '    @Semantics.amount.currencyCode: ''Currency''' ).
    out->write( '    price as Price' ).
    out->write( '  }' ).
    out->write( '  where fldate >= $parameters.p_date' ).
    out->write( ' ' ).
    out->write( 'Then aggregate on top of it:' ).
    out->write( 'define view Z_Flight_Dashboard' ).
    out->write( '  with parameters' ).
    out->write( '    p_currency : abap.cuky( 5 )' ).
    out->write( '  as select from Z_Flight_Price_Conv(' ).
    out->write( '    p_currency: $parameters.p_currency,' ).
    out->write( '    p_date: $session.system_date ) as v' ).
    out->write( '  inner join scarr as a on a.carrid = v.carrid' ).
    out->write( '  {' ).
    out->write( '    key a.carrid as AirlineCode,' ).
    out->write( '    key v.Currency,' ).
    out->write( '    a.carrname as AirlineName,' ).
    out->write( '    count(*) as NumFlights,' ).
    out->write( '    @Semantics.amount.currencyCode: ''Currency''' ).
    out->write( '    sum(v.Price) as TotalPrice' ).
    out->write( '  }' ).
    out->write( '  group by a.carrid, a.carrname, v.Currency' ).
    out->write( ' ' ).
    out->write( 'Result: Multi-layer model, reusable, semantic-rich!' ).
  ENDMETHOD.

ENDCLASS.
