CLASS zcl_02_02_path_expressions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PRIVATE SECTION.
    METHODS single_association    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS filter_by_association IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS chained_association   IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_02_02_path_expressions IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== SECTION 2: ASSOCIATIONS AND PATH EXPRESSIONS ===' ).
    out->write( 'Own views ZI_HANA_CONNECTION / ZI_HANA_AIRPORT / ZI_HANA_FLIGHT are used' ).
    out->write( 'here because /DMO/I_* views are not API-released on this system.' ).
    out->write( 'On this system, Open SQL path expressions require a backslash before' ).
    out->write( 'each association: \_Assoc-Field, or \_Assoc1\_Assoc2-Field when chained.' ).

    single_association( out ).
*    filter_by_association( out ).
*    chained_association( out ).
  ENDMETHOD.


  METHOD single_association.
    out->write( '--- 2.1 / 2.3 Path expression: navigate an association without a JOIN ---' ).

*    SELECT FROM zi_hana_connection
*      FIELDS AirlineID, ConnectionID,
*             \_DepartureAirport-AirportName    AS departure_airport_name,
*             \_DestinationAirport-AirportName  AS destination_airport_name,
*             \_DestinationAirport-CountryCode  AS destination_country
*      INTO TABLE @DATA(lt_connections)
*      UP TO 20 ROWS.

    SELECT FROM ZCDS_04_01_ASSOCIATIONS
      FIELDS CustomerId, TravelId,
*             \_Booking-carrier_id,
             \_Customer-city
      INTO TABLE @DATA(lt_connections).

    out->write( lt_connections ).
  ENDMETHOD.


  METHOD filter_by_association.
    out->write( '--- 2.2 Path expression used inside the WHERE condition ---' ).

    SELECT FROM zi_hana_connection
      FIELDS AirlineID, ConnectionID,
             \_DestinationAirport-AirportName AS destination_airport_name
      WHERE \_DestinationAirport-CountryCode = 'DE'
      INTO TABLE @DATA(lt_connections_germany)
      UP TO 20 ROWS.

    out->write( lt_connections_germany ).
  ENDMETHOD.


  METHOD chained_association.
    out->write( '--- 2.1 Chained path expression: _Connection then _DepartureAirport / _DestinationAirport ---' ).

    SELECT FROM zi_hana_flight
      FIELDS AirlineID, ConnectionID, FlightDate, Price, CurrencyCode,
             \_Connection\_DepartureAirport-AirportName   AS departure_airport_name,
             \_Connection\_DestinationAirport-AirportName AS destination_airport_name
      WHERE Price > 0
      INTO TABLE @DATA(lt_flights_with_airports)
      UP TO 20 ROWS.

    out->write( lt_flights_with_airports ).
  ENDMETHOD.

ENDCLASS.
