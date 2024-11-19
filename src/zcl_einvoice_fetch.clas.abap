CLASS zcl_einvoice_fetch DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.



CLASS ZCL_EINVOICE_FETCH IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_data TYPE STANDARD TABLE OF za_einvoice_no WITH DEFAULT KEY.

    lt_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      <fs_original_data>-stax    = '0309829522'.
      <fs_original_data>-sid     = '310024300324352024'.
      <fs_original_data>-eformat = 'json'.
      <fs_original_data>-action  = 'G_I'.
      <fs_original_data>-Company = '3100'.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
