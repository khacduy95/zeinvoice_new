@EndUserText.label: 'eInvoice information'
define abstract entity ZA_EINVOICE_NO
{
  @EndUserText.label: 'Stax'
  @UI.defaultValue: '0309829522'
  // @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_EINVOICE_FETCH'
  stax    : abap.char( 60 );
  @EndUserText.label: 'Sid'
  @UI.defaultValue: '310024300324352024'
  //  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_EINVOICE_FETCH'
  sid     : abap.char( 60 );
  @EndUserText.label: 'Format'
  @UI.defaultValue: 'json'
  @UI.hidden: true
  eformat : abap.char( 10 );
  @EndUserText.label: 'Action'
  @UI.defaultValue: 'G_I'
  @UI.hidden: true
  action  : abap.char( 10 );
  @EndUserText.label: 'Company'
  @UI.defaultValue: '3100'
  //  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_EINVOICE_FETCH'
  Company : abap.char( 10 );
}
