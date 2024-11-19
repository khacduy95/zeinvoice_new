@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_TB_EINVOICE
  provider contract transactional_query
  as projection on ZR_TB_EINVOICE
{
  key Uuid,
      Stax,
      Sid,
      eFormat,
      Action,
      Company,
      DocIc,
      DocId,
      DocOn,
      DocOt,
      DocOu,
      DocUc,
      DocAdt,
      DocAun,
      DocIdt,
      OrgOn,
      OrgOt,
      OrgAcc,
      OrgAdd,
      OrgSeq,
      OrgTel,
      OrgAddr,
      OrgBank,
      OrgMail,
      OrgPaxo,
      OrgSign,
      OrgTaxo,
      OrgPaxoname,
      OrgTaxoname,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt

}
