CLASS zcl_03_05_semantics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_05_semantics IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 5: SEMANTIC ANNOTATIONS ===' ).
    out->write( ' ' ).
    out->write( 'Semantics tell consuming apps what data means' ).
    out->write( ' ' ).
    out->write( 'Common semantic annotations:' ).
    out->write( ' ' ).
    out->write( '1. Currency semantics:' ).
    out->write( '   @Semantics.currencyCode: true' ).
    out->write( '   Marks field as currency code (CUKY type)' ).
    out->write( ' ' ).
    out->write( '2. Amount semantics:' ).
    out->write( '   @Semantics.amount.currencyCode: ''Currency''' ).
    out->write( '   Links amount field to its currency field' ).
    out->write( ' ' ).
    out->write( '3. Unit of measure:' ).
    out->write( '   @Semantics.unitOfMeasure: true' ).
    out->write( '   Marks field as unit (UNIT type)' ).
    out->write( ' ' ).
    out->write( '4. Quantity semantics:' ).
    out->write( '   @Semantics.quantity.unitOfMeasure: ''Unit''' ).
    out->write( '   Links quantity to its unit field' ).
    out->write( ' ' ).
    out->write( 'Example:' ).
    out->write( 'define view Z_Flight_Pricing' ).
    out->write( '  as select from sflight' ).
    out->write( '  {' ).
    out->write( '    key carrid,' ).
    out->write( '    @Semantics.currencyCode: true' ).
    out->write( '    currency as Currency,' ).
    out->write( '    @Semantics.amount.currencyCode: ''Currency''' ).
    out->write( '    price as Price' ).
    out->write( '  }' ).
    out->write( ' ' ).
    out->write( 'Fiori and analytics apps use this to format display!' ).
  ENDMETHOD.

ENDCLASS.
