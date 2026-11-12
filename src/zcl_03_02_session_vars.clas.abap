CLASS zcl_03_02_session_vars DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_03_02_session_vars IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CDS BLOCK 2: SESSION VARIABLES AND @CLIENTHANDLING ===' ).
    out->write( ' ' ).
    out->write( 'Session variables: pre-defined context values from the database' ).
    out->write( ' ' ).
    out->write( 'Available session variables:' ).
    out->write( '* $session.user - Current user name' ).
    out->write( '* $session.client - Current client/mandant' ).
    out->write( '* $session.system_language - Session language' ).
    out->write( '* $session.system_date - System date' ).
    out->write( ' ' ).
    out->write( 'Example: Filter future flights' ).
    out->write( 'define view Z_Flight_Session' ).
    out->write( '  as select from sflight' ).
    out->write( '  {' ).
    out->write( '    key carrid,' ).
    out->write( '    key connid,' ).
    out->write( '    key fldate,' ).
    out->write( '    $session.user as CurrentUser,' ).
    out->write( '    $session.system_date as SystemDate' ).
    out->write( '  }' ).
    out->write( '  where fldate >= $session.system_date' ).
    out->write( ' ' ).
    out->write( '@ClientHandling annotation:' ).
    out->write( '* Controls how the view filters by mandant' ).
    out->write( '* Type: #CLIENT_DEPENDENT (this mandant only)' ).
    out->write( '* Algorithm: #SESSION_VARIABLE (automatic via $session.client)' ).
    out->write( ' ' ).
    out->write( 'Important: Do NOT manually filter by client!' ).
    out->write( 'The CDS view manages this automatically.' ).
  ENDMETHOD.

ENDCLASS.
