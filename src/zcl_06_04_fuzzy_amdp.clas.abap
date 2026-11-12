CLASS zcl_06_04_fuzzy_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    TYPES ty_threshold TYPE p LENGTH 3 DECIMALS 2.
    TYPES ty_score     TYPE p LENGTH 5 DECIMALS 3.

    TYPES:
      BEGIN OF ty_match,
        last_name TYPE /dmo/last_name,
        customers TYPE i,
        score     TYPE ty_score,
      END OF ty_match,
      tt_matches TYPE STANDARD TABLE OF ty_match WITH EMPTY KEY.

    CLASS-METHODS search_exact
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_term)    TYPE /dmo/last_name
      EXPORTING VALUE(et_matches) TYPE tt_matches.

    CLASS-METHODS search_fuzzy
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_term)      TYPE /dmo/last_name
                VALUE(iv_threshold) TYPE ty_threshold
      EXPORTING VALUE(et_matches)   TYPE tt_matches.

ENDCLASS.


CLASS zcl_06_04_fuzzy_amdp IMPLEMENTATION.

  METHOD search_exact BY DATABASE PROCEDURE FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING /dmo/customer.
    lt_hits = SELECT last_name, SCORE( ) AS score
                FROM "/DMO/CUSTOMER"
               WHERE client = SESSION_CONTEXT( 'CLIENT' )
                 AND CONTAINS( last_name, :iv_term, EXACT );

    et_matches = SELECT last_name,
                        CAST( COUNT( * ) AS INTEGER )            AS customers,
                        CAST( MAX( score ) AS DECIMAL( 5, 3 ) ) AS score
                   FROM :lt_hits
                  GROUP BY last_name
                  ORDER BY score DESC, last_name;
  ENDMETHOD.


  METHOD search_fuzzy BY DATABASE PROCEDURE FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING /dmo/customer.
    lt_hits = SELECT last_name, SCORE( ) AS score
                FROM "/DMO/CUSTOMER"
               WHERE client = SESSION_CONTEXT( 'CLIENT' )
                 AND CONTAINS( last_name, :iv_term, FUZZY( :iv_threshold ) );

    et_matches = SELECT last_name,
                        CAST( COUNT( * ) AS INTEGER )            AS customers,
                        CAST( MAX( score ) AS DECIMAL( 5, 3 ) ) AS score
                   FROM :lt_hits
                  GROUP BY last_name
                  ORDER BY score DESC, last_name;
  ENDMETHOD.

ENDCLASS.

