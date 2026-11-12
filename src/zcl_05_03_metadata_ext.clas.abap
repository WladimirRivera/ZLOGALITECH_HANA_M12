CLASS zcl_05_03_metadata_ext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES tt_connection TYPE STANDARD TABLE OF zcds_05_03_connection WITH EMPTY KEY.

    METHODS get_connections
      IMPORTING iv_carrier_id        TYPE /dmo/carrier_id
      RETURNING VALUE(rt_connection) TYPE tt_connection.

    METHODS ddlx_exists
      IMPORTING iv_ddlx_name     TYPE sxco_cds_object_name
      RETURNING VALUE(rv_exists) TYPE abap_bool.

ENDCLASS.


CLASS zcl_05_03_metadata_ext IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( data = get_connections( 'LH' )
                name = 'ZCDS_05_03_CONNECTION - same data, UI lives in the DDLX' ).

    out->write( |ZMDE_05_03_CONN_CORE exists: { ddlx_exists( 'ZMDE_05_03_CONN_CORE' ) }| ).
  ENDMETHOD.


  METHOD get_connections.
    SELECT FROM zcds_05_03_connection
      FIELDS *
      WHERE CarrierId = @iv_carrier_id
      ORDER BY ConnectionId
      INTO TABLE @rt_connection.
  ENDMETHOD.


  METHOD ddlx_exists.
    rv_exists = xco_cp_cds=>metadata_extension( iv_ddlx_name )->exists( ).
  ENDMETHOD.

ENDCLASS.

