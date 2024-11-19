CLASS zcl_einvoice_call_api DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_rap_query_provider.

    METHODS get_eInvoice
      IMPORTING stax    TYPE string
                sid     TYPE string
                eformat TYPE string
                eaction TYPE string
                company TYPE string
      EXPORTING lt_data TYPE ztt_einvoice
                lv_msg  TYPE string
                lv_type TYPE string.

ENDCLASS.



CLASS ZCL_EINVOICE_CALL_API IMPLEMENTATION.


  METHOD get_einvoice.
    DATA lt_fields TYPE if_web_http_request=>name_value_pairs.

    lt_fields = VALUE #( ( name = 'stax' value = stax )
                         ( name = 'sid' value = sid )
                         ( name = 'format' value = eformat )
                         ( name = 'action' value = eaction )
                         ( name = 'companycode' value = company ) ).

    TRY.

        FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario  = 'Z_OUTBOUND_CSCEN_EINVOICE'
                                    service_id     = 'Z_OUTBOUND_EINVOICE_REST'
                                    comm_system_id = 'TO_FPT_EINVOICE' ).

        FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = lo_destination ).
        FINAL(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_form_fields( i_fields = lt_fields ).

        FINAL(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).
        FINAL(lv_json_results) = lo_response->get_text( ).

      CATCH cx_root INTO FINAL(lx_exception).
        lv_type = 'E'.
        lv_msg = lx_exception->get_text( ).
    ENDTRY.

    IF lv_type = 'E'.
      RETURN.
    ELSE.
      CLEAR lt_data.
    ENDIF.

    TRY.

        xco_cp_json=>data->from_string( iv_string = lv_json_results )->apply(
            VALUE #( ( xco_cp_json=>transformation->boolean_to_abap_bool ) )
        )->write_to( ia_data = REF #( lt_data ) ).

        lv_type = 'S'.
        CLEAR lv_msg.

      CATCH cx_root INTO FINAL(lx_root).
        lv_type = 'E'.
        lv_msg = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ts_org,
             on                     TYPE string,
             ot                     TYPE string,
             acc                    TYPE string,
             add                    TYPE string,
             seq                    TYPE string,
             tel                    TYPE string,
             addr                   TYPE string,
             bank                   TYPE string,
             mail                   TYPE string,
             paxo                   TYPE string,
             sign                   TYPE string,
             taxo                   TYPE string,
             paxoname               TYPE string,
             seq_pitd               TYPE string,
             taxoname               TYPE string,
             sign_pitd              TYPE string,
             use_petro              TYPE string,
             on_has_taxc            TYPE string,
             seq_receipt            TYPE string,
             tel_has_taxc           TYPE string,
             addr_has_taxc          TYPE string,
             degree_config          TYPE string,
             pwd_hard_rule          TYPE string,
             inv_authorization      TYPE string,
             receipt_degree_config  TYPE string,
             cfpitd_sign_coordinate TYPE string,
           END OF ts_org.

    TYPES: BEGIN OF ts_doc_data,
             ic  TYPE string,
             id  TYPE string,
             on  TYPE string,
             ot  TYPE string,
             ou  TYPE string,
             uc  TYPE string,
             adt TYPE string,
             aun TYPE string,
             idt TYPE string,
             org TYPE ts_org,
           END OF ts_doc_data.

    TYPES: BEGIN OF ts_doc,
             doc TYPE ts_doc_data,
           END OF ts_doc.

    DATA lt_fields TYPE if_web_http_request=>name_value_pairs.

    DATA lt_json   TYPE STANDARD TABLE OF ts_doc.

    TRY.

        FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario  = 'Z_OUTBOUND_CSCEN_EINVOICE'
                                    service_id     = 'Z_OUTBOUND_EINVOICE_REST'
                                    comm_system_id = 'TO_FPT_EINVOICE' ).

        FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = lo_destination ).
        FINAL(lo_request) = lo_http_client->get_http_request( ).

        lt_fields = VALUE #( ( name = 'stax' value = '0309829522' )
                             ( name = 'sid' value = '310024300324352024' )
                             ( name = 'format' value = 'json' )
                             ( name = 'action' value = 'G_I' )
                             ( name = 'companycode' value = '3100' ) ).

        lo_request->set_form_fields( i_fields = lt_fields ).

        FINAL(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).
        FINAL(lv_json_results) = lo_response->get_text( ).

      CATCH cx_root INTO FINAL(lx_exception).
        out->write( lx_exception->get_text( ) ).
    ENDTRY.

    TRY.

        xco_cp_json=>data->from_string( lv_json_results )->apply(
                                                            VALUE #(
                                                                "  ( xco_cp_json=>transformation-> )
                                                                ( xco_cp_json=>transformation->boolean_to_abap_bool ) )
        )->write_to( REF #( lt_json ) ).

      " catch any error
      CATCH cx_root INTO FINAL(lx_root).
        out->write( lx_root->get_text( ) ).
    ENDTRY.

    IF lt_json IS NOT INITIAL.
      out->write( lt_json ).
    ENDIF.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
  ENDMETHOD.
ENDCLASS.
