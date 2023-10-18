codeunit 50101 CodeunitRequisitionTemplate
{

    procedure TemplateSelectionForRequisition(FormID: Integer; VAR RequisitionHeader: Record "Pre Requisition Header"; VAR JnlSelected: Boolean; VAR GenJnlTemplateCode: Code[10])
    begin

        if usersetup.get(UserId) then;

        JnlSelected := TRUE;
        GenJnlTemplate.RESET;
        GenJnlTemplate.SETRANGE("Page ID", FormID);
        GenJnlTemplate.SETRANGE(Type, GenJnlTemplate.Type::Indent);  //Gaurav (need Discussio)
        // GenJnlTemplate.SetRange("Security Center Codes", usersetup."Security Center Filter"); //Gaurav
        if not GenJnlTemplate.findfirst then
            ERROR('You must first define Template for Requisition')
        else
            JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
        /*     CASE GenJnlTemplate.COUNT OF
                0:
                    ERROR('You must first define Template for Requisition');
                1:
                    GenJnlTemplate.FIND('-');
                ELSE
                    JnlSelected := PAGE.RUNMODAL(0, GenJnlTemplate) = ACTION::LookupOK;
            END;
         */
        IF JnlSelected THEN BEGIN
            RequisitionHeader.FILTERGROUP := 2;
            RequisitionHeader.SETRANGE("Gen. Journal Template Code", GenJnlTemplate.Name);
            RequisitionHeader.FILTERGROUP := 0;
            GenJnlTemplateCode := GenJnlTemplate.Name;
        END;
    end;



    var
        Text0011: Label '%1 ';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenjnlMang: Codeunit GenJnlManagement;
        usersetup: Record 91;
}
