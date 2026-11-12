CLASS zcl_06_04_fuzzy_search_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_search_result,
        search_term TYPE /dmo/last_name,
        threshold   TYPE zcl_06_04_fuzzy_amdp=>ty_threshold,
        matches     TYPE string,
      END OF ty_search_result,
      tt_search_results TYPE STANDARD TABLE OF ty_search_result WITH EMPTY KEY.

    METHODS run_fuzzy
      IMPORTING iv_term          TYPE /dmo/last_name
                iv_threshold     TYPE zcl_06_04_fuzzy_amdp=>ty_threshold
      RETURNING VALUE(rs_result) TYPE ty_search_result.

ENDCLASS.


CLASS zcl_06_04_fuzzy_search_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '=== CLASS 6.04: FUZZY SEARCH WITH FUZZINESS THRESHOLD ===' ).
    out->write( ' ' ).

    out->write( `--- Example 1: Exact search - 'Schneider' vs 'Shneider' ---` ).
    zcl_06_04_fuzzy_amdp=>search_exact( EXPORTING iv_term = 'Schneider' IMPORTING et_matches = DATA(lt_exact_ok) ).
    zcl_06_04_fuzzy_amdp=>search_exact( EXPORTING iv_term = 'Shneider'  IMPORTING et_matches = DATA(lt_exact_typo) ).
    out->write( data = lt_exact_ok   name = `EXACT 'Schneider'` ).
    out->write( data = lt_exact_typo name = `EXACT 'Shneider'` ).
    out->write( ' ' ).

    out->write( `--- Example 2: Fuzzy search - 'Shneider' with threshold 0.70 ---` ).
    zcl_06_04_fuzzy_amdp=>search_fuzzy( EXPORTING iv_term      = 'Shneider'
                                                  iv_threshold = '0.70'
                                        IMPORTING et_matches   = DATA(lt_fuzzy) ).
    out->write( lt_fuzzy ).
    out->write( ' ' ).

    out->write( `--- Example 3: Same term, different thresholds ---` ).
    DATA(lt_by_threshold) = VALUE tt_search_results( ( run_fuzzy( iv_term = 'Shneider' iv_threshold = '0.95' ) )
                                                     ( run_fuzzy( iv_term = 'Shneider' iv_threshold = '0.80' ) )
                                                     ( run_fuzzy( iv_term = 'Shneider' iv_threshold = '0.70' ) )
                                                     ( run_fuzzy( iv_term = 'Shneider' iv_threshold = '0.50' ) ) ).
    out->write( lt_by_threshold ).
    out->write( ' ' ).

    out->write( `--- Example 4: Typical typing errors with threshold 0.70 ---` ).
    DATA(lt_typos) = VALUE tt_search_results( ( run_fuzzy( iv_term = 'Mueller'  iv_threshold = '0.70' ) )
                                              ( run_fuzzy( iv_term = 'Fisher'   iv_threshold = '0.70' ) )
                                              ( run_fuzzy( iv_term = 'Zimerman' iv_threshold = '0.70' ) )
                                              ( run_fuzzy( iv_term = 'Hofen'    iv_threshold = '0.70' ) )
                                              ( run_fuzzy( iv_term = 'Montera'  iv_threshold = '0.70' ) ) ).
    out->write( lt_typos ).
  ENDMETHOD.


  METHOD run_fuzzy.
    zcl_06_04_fuzzy_amdp=>search_fuzzy( EXPORTING iv_term      = iv_term
                                                  iv_threshold = iv_threshold
                                        IMPORTING et_matches   = DATA(lt_matches) ).

    DATA(lt_texts) = VALUE string_table( FOR ls_match IN lt_matches
                                         ( |{ ls_match-last_name } ({ ls_match-score })| ) ).

    rs_result = VALUE #( search_term = iv_term
                         threshold   = iv_threshold
                         matches     = COND #( WHEN lt_texts IS INITIAL THEN `-`
                                               ELSE concat_lines_of( table = lt_texts sep = `, ` ) ) ).
  ENDMETHOD.

ENDCLASS.

