CLASS zcl_06_01_flight_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    TYPES:
      BEGIN OF ty_customer_booking,
        travel_id     TYPE /dmo/travel_id,
        booking_id    TYPE /dmo/booking_id,
        carrier_id    TYPE /dmo/carrier_id,
        connection_id TYPE /dmo/connection_id,
        flight_date   TYPE /dmo/flight_date,
        flight_price  TYPE /dmo/flight_price,
        currency_code TYPE /dmo/currency_code,
      END OF ty_customer_booking,
      tt_customer_bookings TYPE STANDARD TABLE OF ty_customer_booking WITH EMPTY KEY.

    CLASS-METHODS get_flight_ranking FOR TABLE FUNCTION zcds_06_01_flight_ranking.

    CLASS-METHODS get_filtered_connections FOR TABLE FUNCTION zcds_06_01_conn_filter.

    CLASS-METHODS get_customer_bookings
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_customer_id) TYPE /dmo/customer_id
      EXPORTING VALUE(et_bookings)    TYPE tt_customer_bookings.

    CLASS-METHODS get_last_bookings
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_customer_id) TYPE /dmo/customer_id
                VALUE(iv_max_rows)    TYPE i
      EXPORTING VALUE(et_bookings)    TYPE tt_customer_bookings.

ENDCLASS.


CLASS zcl_06_01_flight_amdp IMPLEMENTATION.

  METHOD get_flight_ranking BY DATABASE FUNCTION FOR HDB
                            LANGUAGE SQLSCRIPT
                            OPTIONS READ-ONLY
                            USING /dmo/flight.
    RETURN
      SELECT client,
             carrier_id     AS carrierid,
             connection_id  AS connectionid,
             flight_date    AS flightdate,
             seats_max      AS seatsmax,
             seats_occupied AS seatsoccupied,
             CAST( seats_occupied * 100.0 / NULLIF( seats_max, 0 ) AS DECIMAL( 5, 2 ) ) AS occupancypercent,
             CAST( price * seats_occupied AS DECIMAL( 17, 2 ) )                          AS revenue,
             currency_code  AS currencycode,
             CAST( RANK( ) OVER ( PARTITION BY carrier_id
                                  ORDER BY price * seats_occupied DESC ) AS INTEGER )   AS revenuerank
        FROM "/DMO/FLIGHT"
       WHERE client = SESSION_CONTEXT( 'CLIENT' )
         AND ( :p_carrier_id = '' OR carrier_id = :p_carrier_id );
  ENDMETHOD.


  METHOD get_filtered_connections BY DATABASE FUNCTION FOR HDB
                                  LANGUAGE SQLSCRIPT
                                  OPTIONS READ-ONLY
                                  USING /dmo/connection.
    lt_connections = SELECT client, carrier_id, connection_id, airport_from_id,
                            airport_to_id, distance, distance_unit
                       FROM "/DMO/CONNECTION"
                      WHERE client = SESSION_CONTEXT( 'CLIENT' );

    lt_filtered = APPLY_FILTER( :lt_connections, :p_where );

    RETURN
      SELECT client,
             carrier_id      AS carrierid,
             connection_id   AS connectionid,
             airport_from_id AS airportfromid,
             airport_to_id   AS airporttoid,
             distance,
             distance_unit   AS distanceunit
        FROM :lt_filtered;
  ENDMETHOD.


  METHOD get_customer_bookings BY DATABASE PROCEDURE FOR HDB
                               LANGUAGE SQLSCRIPT
                               OPTIONS READ-ONLY
                               USING /dmo/booking.
    et_bookings = SELECT travel_id, booking_id, carrier_id, connection_id,
                         flight_date, flight_price, currency_code
                    FROM "/DMO/BOOKING"
                   WHERE client      = SESSION_CONTEXT( 'CLIENT' )
                     AND customer_id = :iv_customer_id
                   ORDER BY flight_date DESC;
  ENDMETHOD.


  METHOD get_last_bookings BY DATABASE PROCEDURE FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zcl_06_01_flight_amdp=>get_customer_bookings.
    CALL "ZCL_06_01_FLIGHT_AMDP=>GET_CUSTOMER_BOOKINGS"( iv_customer_id => :iv_customer_id,
                                                         et_bookings    => :lt_all_bookings );

    et_bookings = SELECT * FROM :lt_all_bookings
                   ORDER BY flight_date DESC
                   LIMIT :iv_max_rows;
  ENDMETHOD.

ENDCLASS.

