CLASS lhc_zr_tb_einvoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR eInvoice
        RESULT result,

      get_global_features FOR GLOBAL FEATURES
        IMPORTING REQUEST requested_features FOR eInvoice RESULT result.

    METHODS get_eInvoice FOR MODIFY
      IMPORTING keys FOR ACTION eInvoice~get_eInvoice RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR eInvoice RESULT result.

ENDCLASS.


CLASS lhc_zr_tb_einvoice IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_global_features.
    result = VALUE #( %action-get_eInvoice = if_abap_behv=>fc-o-enabled ).
  ENDMETHOD.

  METHOD get_eInvoice.
    DATA: lo_api  TYPE REF TO zcl_einvoice_call_api,
          lt_data TYPE ztt_einvoice,
          lv_msg  TYPE string,
          lv_type TYPE string.
    DATA lt_update TYPE TABLE FOR UPDATE zr_tb_einvoice\\eInvoice.
    DATA lt_create TYPE TABLE FOR CREATE zr_tb_einvoice\\eInvoice.

    DATA(keys_valid) = keys.

    LOOP AT keys_valid ASSIGNING FIELD-SYMBOL(<f_key_valid>)
         WHERE %param-sid IS INITIAL OR %param-stax IS INITIAL.

      APPEND VALUE #( %cid = <f_key_valid>-%cid ) TO failed-einvoice.

      APPEND VALUE #( %cid                     = <f_key_valid>-%cid
                      %msg                     = new_message( id       = 'ZEINVOICE_MSG'
                                                              number   = 001
                                                              severity = if_abap_behv_message=>severity-error )
                      %element-stax            = if_abap_behv=>mk-on
                      %element-sid             = if_abap_behv=>mk-on
                      %op-%action-get_eInvoice = if_abap_behv=>mk-on )
             TO reported-einvoice.

      DELETE keys_valid.

    ENDLOOP.

    IF keys_valid IS INITIAL.
      RETURN.
    ENDIF.

    lo_api = NEW #( ).

    LOOP AT keys_valid
         ASSIGNING FIELD-SYMBOL(<f_key>).

      " Call API to get Invoice Information.
      lo_api->get_einvoice( EXPORTING stax    = CONV string( <f_key>-%param-stax )
                                      sid     = CONV string( <f_key>-%param-sid )
                                      eformat = CONV string( <f_key>-%param-eformat )
                                      eaction = CONV string( <f_key>-%param-action )
                                      company = CONV string( <f_key>-%param-Company )
                            IMPORTING lt_data = lt_data
                                      lv_msg  = lv_msg
                                      lv_type = lv_type ).

      IF lv_type = 'E'.
        EXIT.
      ENDIF.

      SELECT SINGLE uuid FROM ztb_einvoice
        WHERE stax    = @<f_key>-%param-stax
          AND sid     = @<f_key>-%param-sid
          AND eformat = @<f_key>-%param-eformat
          AND action  = @<f_key>-%param-action
          AND company = @<f_key>-%param-Company
        INTO @FINAL(lv_uuid).

      IF sy-subrc = 0.

        LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<f_data>).
          APPEND VALUE #( "%cid_ref           = <f_key>-%cid_ref
                          "  %is_draft          = <f_key>-%is_draft
                          uuid               = lv_uuid
                          Stax               = <f_key>-%param-stax
                          Sid                = <f_key>-%param-sid
                          eFormat            = <f_key>-%param-eformat
                          Action             = <f_key>-%param-action
                          Company            = <f_key>-%param-Company
                          DocIc              = <f_data>-doc-ic
                          DocId              = <f_data>-doc-id
                          DocOn              = <f_data>-doc-on
                          DocOt              = <f_data>-doc-ot
                          DocOu              = <f_data>-doc-ou
                          DocUc              = <f_data>-doc-uc
                          DocAdt             = <f_data>-doc-adt
                          DocAun             = <f_data>-doc-aun
                          DocIdt             = <f_data>-doc-idt
                          OrgOn              = <f_data>-doc-org-on
                          OrgOt              = <f_data>-doc-org-ot
                          OrgAcc             = <f_data>-doc-org-acc
                          OrgAdd             = <f_data>-doc-org-add
                          OrgSeq             = <f_data>-doc-org-seq
                          OrgTel             = <f_data>-doc-org-tel
                          OrgAddr            = <f_data>-doc-org-addr
                          OrgBank            = <f_data>-doc-org-bank
                          OrgMail            = <f_data>-doc-org-mail
                          OrgPaxo            = <f_data>-doc-org-paxo
                          OrgPaxoname        = <f_data>-doc-org-paxoname
                          OrgSign            = <f_data>-doc-org-sign
                          OrgTaxo            = <f_data>-doc-org-taxo
                          OrgTaxoname        = <f_data>-doc-org-taxoname
                          locallastchangedby = sy-uname
                          locallastchangedat = cl_abap_context_info=>get_system_time( ) )

                 TO lt_update.
        ENDLOOP.

      ELSE.
        LOOP AT lt_data ASSIGNING <f_data>.

          APPEND VALUE #( %cid          = sy-tabix
                          "  %is_draft     = <f_key>-%is_draft
                          "   uuid          = cl_system_uuid=>create_uuid_x16_static( )
                          stax          = <f_key>-%param-stax
                          sid           = <f_key>-%param-sid
                          eformat       = <f_key>-%param-eformat
                          action        = <f_key>-%param-action
                          company       = <f_key>-%param-Company
                          docic         = <f_data>-doc-ic
                          docid         = <f_data>-doc-id
                          docon         = <f_data>-doc-on
                          docot         = <f_data>-doc-ot
                          docou         = <f_data>-doc-ou
                          docuc         = <f_data>-doc-uc
                          docadt        = <f_data>-doc-adt
                          docaun        = <f_data>-doc-aun
                          docidt        = <f_data>-doc-idt
                          orgon         = <f_data>-doc-org-on
                          orgot         = <f_data>-doc-org-ot
                          orgacc        = <f_data>-doc-org-acc
                          orgadd        = <f_data>-doc-org-add
                          orgseq        = <f_data>-doc-org-seq
                          orgtel        = <f_data>-doc-org-tel
                          orgaddr       = <f_data>-doc-org-addr
                          orgbank       = <f_data>-doc-org-bank
                          orgmail       = <f_data>-doc-org-mail
                          orgpaxo       = <f_data>-doc-org-paxo
                          orgsign       = <f_data>-doc-org-sign
                          orgtaxo       = <f_data>-doc-org-taxo
                          orgpaxoname   = <f_data>-doc-org-paxoname
                          orgtaxoname   = <f_data>-doc-org-taxoname
                          createdby     = sy-uname
                          createdat     = cl_abap_context_info=>get_system_date( )
                          lastchangedat = cl_abap_context_info=>get_system_time( ) ) TO lt_create.
        ENDLOOP.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_tb_einvoice IN LOCAL MODE
             ENTITY eInvoice
             UPDATE FIELDS ( uuid
                        stax
                        sid
                        eformat
                        action
                        company
                        docic
                        docid
                        docon
                        docot
                        docou
                        docuc
                        docadt
                        docaun
                        docidt
                        orgon
                        orgot
                        orgacc
                        orgadd
                        orgseq
                        orgtel
                        orgaddr
                        orgbank
                        orgmail
                        orgpaxo
                        orgsign
                        orgtaxo
                        orgpaxoname
                        orgtaxoname
                        createdby
                        createdat
                        locallastchangedby
                        locallastchangedat
                        lastchangedat )
             WITH lt_update
             REPORTED reported
             MAPPED mapped
             FAILED failed.

      IF failed IS INITIAL.

        result = VALUE #( FOR ls_key IN keys_valid
                          ( %cid        = ls_key-%cid
                            %param-Uuid = lt_update[ 1 ]-Uuid
                            %param-Stax = ls_key-%param-stax
                            %param-Sid  = ls_key-%param-sid ) ).

      ENDIF.

    ENDIF.

    IF lt_create IS NOT INITIAL.
      MODIFY ENTITIES OF zr_tb_einvoice IN LOCAL MODE
             ENTITY eInvoice
             CREATE
             FIELDS ( " uuid
                      stax
                      sid
                      eformat
                      action
                      company
                      docic
                      docid
                      docon
                      docot
                      docou
                      docuc
                      docadt
                      docaun
                      docidt
                      orgon
                      orgot
                      orgacc
                      orgadd
                      orgseq
                      orgtel
                      orgaddr
                      orgbank
                      orgmail
                      orgpaxo
                      orgsign
                      orgtaxo
                      orgpaxoname
                      orgtaxoname
                      createdby
                      createdat
                      locallastchangedby
                      locallastchangedat
                      lastchangedat )
             WITH lt_create
             REPORTED reported
             MAPPED mapped
             FAILED failed.

      IF failed IS INITIAL.

        result = VALUE #( FOR ls_key IN keys_valid
                          ( %cid        = ls_key-%cid
                            %param-Uuid = mapped-einvoice[ 1 ]-Uuid
                            %param-Stax = ls_key-%param-stax
                            %param-Sid  = ls_key-%param-sid ) ).

      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zr_tb_einvoice IN LOCAL MODE
         ENTITY eInvoice
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         FAILED failed.

    result = VALUE #( FOR ls_header IN lt_header
                      ( %tky         = ls_header-%tky
                        %action-edit = if_abap_behv=>fc-o-disabled ) ).
  ENDMETHOD.
ENDCLASS.
