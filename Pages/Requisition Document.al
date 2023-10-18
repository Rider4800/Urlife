page 50118 "Requisition Document"
{
    PageType = Document;
    SourceTable = "Pre Requisition Header";
    SourceTableView = sorting("No.") where(Status = filter(Open | "Sent for approval"));
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                //  modify("No.")
                // {
                //     Caption = 'Requisition Number';
                // }

                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = all;
                }
                field("Required Date"; Rec."Required Date")
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                    ApplicationArea = all;
                }
                field("Requisition Status"; Rec."Requisition Status")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = all;

                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ShowCaption = true;
                    Caption = 'Department Code';
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Requisition Remarks"; Rec."Requisition Remarks")
                {
                    ApplicationArea = all;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ApplicationArea = all;
                }


            }
            part("Requisition Subfrom"; 50112)
            {
                SubPageLink = "Requisition No." = field("No.");
                ApplicationArea = all;
            }


        }
    }
    actions
    {

        area(Navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Enabled = rec."No." <> '';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
        }
        area(Processing)
        {
            action("Send For Approval")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.testfield("Shortcut Dimension 1 Code");
                    Rec.testfield("Shortcut Dimension 2 Code");
                    Rec.testfield(Status, Rec.Status::Open);
                    Rec.CalcFields(Amount);
                    RequisitionLine.Reset();
                    RequisitionLine.setrange("Requisition No.", Rec."No.");
                    if RequisitionLine.FindFirst() then begin

                        RequisitionLine.TestField(Quantity);
                        RequisitionLine.TestField("Unit Price");

                    end;

                    IF NOT CONFIRM('Do you want to send for approval') THEN
                        EXIT;
                    Clear(EntryNo);
                    if AppEntryRequisitionEntryno.FindLast then
                        EntryNo := AppEntryRequisitionEntryno."Entry No.";

                    ApprovalEntryRequisition.Init;
                    ApprovalEntryRequisition."Entry No." := EntryNo + 1;
                    ApprovalEntryRequisition."Requisition No." := Rec."No.";
                    ApprovalEntryRequisition."Sender UserID" := UserId;
                    usersetup.Get(UserId);
                    usersetup.TestField("Approver ID");
                    if usersetup1.get(usersetup."Approver ID") then begin
                        if rec.Amount <= usersetup1."Requisition Approval Limit" then
                            ApprovalEntryRequisition."Approver UserID" := usersetup1."User ID"
                        else
                            ApprovalEntryRequisition."Approver UserID" := usersetup1."Approver ID";
                    end;  //Gaurav


                    ApprovalEntryRequisition.Status := ApprovalEntryRequisition.Status::"Sent for approval";
                    ApprovalEntryRequisition."Sent for approval" := true;
                    ApprovalEntryRequisition."Send DateTime" := CurrentDateTime;
                    ApprovalEntryRequisition.Insert;
                    SendMail(Rec);
                    Rec.Status := Rec.Status::"Sent for approval";
                end;
            }

            action("Cancel Approval")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.testfield("Rejection Remarks");
                    IF NOT CONFIRM('Do you want to Cancel') THEN
                        EXIT;

                    Clear(EntryNo);
                    if AppEntryRequisitionEntryno.FindLast then
                        EntryNo := AppEntryRequisitionEntryno."Entry No.";

                    ApprovalEntryRequisition.Init;
                    ApprovalEntryRequisition."Entry No." := EntryNo + 1;
                    ApprovalEntryRequisition."Requisition No." := Rec."No.";
                    ApprovalEntryRequisition."Cancel UserID" := UserId;
                    ApprovalEntryRequisition."Cancel DateTime" := CurrentDateTime;
                    ApprovalEntryRequisition.Status := ApprovalEntryRequisition.Status::Cancel;
                    ApprovalEntryRequisition."Sent for approval" := false;
                    ApprovalEntryRequisition.Insert;

                    AppEntryRequisitionEntryno.Reset();
                    AppEntryRequisitionEntryno.setrange("Requisition No.", Rec."No.");
                    if AppEntryRequisitionEntryno.FindSet then
                        repeat
                            AppEntryRequisitionEntryno."Sent for approval" := false;
                            AppEntryRequisitionEntryno.Modify;
                        until AppEntryRequisitionEntryno.Next = 0;
                    Rec.Status := Rec.Status::Open;


                    Rec.Status := Rec.Status::Open;

                end;
            }

            action("Document History")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = History;
                trigger OnAction()
                begin
                    approvalEntryRequisition.Reset();
                    approvalEntryRequisition.SetRange("Requisition No.", Rec."No.");
                    if approvalEntryRequisition.FindFirst then
                        Page.RunModal(Page::"Approval History Requisition", approvalEntryRequisition)
                end;

            }
            action("Requisition Report")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Print;
                trigger OnAction()
                var
                    indnetHeader: Record "Pre Requisition Header";
                begin
                    indnetHeader.Reset;
                    indnetHeader.setrange("No.", rec."No.");
                    if indnetHeader.FindFirst then
                        Report.RunModal(79901, true, true, indnetHeader);

                end;

            }




        }

    }

    procedure SendMail(RequisitionHeader: Record "Pre Requisition Header")
    var
        EmailObj: Codeunit Email;
        EmailMsg: Codeunit "Email Message";
        PreRequisitionLine: Record "Pre Requisition Line";
        CCMailIdList: List of [Text];
        BccMailIdList: List of [Text];
        BodyTxt: Text;
        MailUserIdVar: List of [Text];
        MailSubject: Text;
        MailUserid: Text;
        MailComapnyName: Text;
        DimValue: Record "Dimension Value";
        CompInfo: Record "Company Information";
        VarUserSetup: Record 91; //
        UserEmail: Text;
    begin

        Clear(MailUserIdVar);
        Clear(BccMailIdList);
        Clear(CCMailIdList);
        // RequisitionHeader.Reset;
        // RequisitionHeader.setrange(Status, RequisitionHeader.Status::Open);
        // if RequisitionHeader.FindFirst then begin
        if DimValue.Get('DEPARTMENT', RequisitionHeader."Shortcut Dimension 4 Code") then;
        MailUserIdVar.Add('kailash.singh@teamcomputers.com');  //Commented
        // MailUserIdVar.Add('dipti.bisht@teamcomputers.com');
        // CCMailIdList.Add('gaurav.pandit@teamcomputers.com');
        CCMailIdList.Add('gauravims8@gmail.com'); // Change it to approver ID.
        BccMailIdList.Add('gaurav.pandit@teamcomputers.com');
        MailUserid := UserId;
        // VarUserSetup.Reset();
        // VarUserSetup.SetRange("User ID", UserId);
        // if VarUserSetup.FindFirst() then
        //     UserEmail := VarUserSetup."E-Mail";

        // MailUserIdVar.Add(UserEmail);

        MailComapnyName := CompanyName;
        MailSubject := 'Requisition No :- ' + RequisitionHeader."No." + ' ' + DimValue.Name + ' ' + CompanyName;


        BodyTxt := 'Dear Sir/Madam,';
        BodyTxt += '<br></br>';
        BodyTxt := 'Please find the below Requisition for approval:';
        BodyTxt += '<br></br>';
        BodyTxt += '<TABLE border = "2">';
        BodyTxt += '<TH>Requisition No.</TH>';
        BodyTxt += '<TH>Requisition Date</TH>';
        BodyTxt += '<TH>Item No.</TH>';
        BodyTxt += '<TH>Item Description</TH>';
        BodyTxt += '<TH>Full Description</TH>';
        BodyTxt += '<TH>Quantity</TH>';
        BodyTxt += '<TH>UOM</TH>';
        BodyTxt += '<TH>Unit Price</TH>';
        BodyTxt += '<TH>Amount</TH>';
        BodyTxt += '<TH>Remarks</TH>';
        BodyTxt += '<TH>Requisition Status</TH>';
        BodyTxt += '</TR>';

        PreRequisitionLine.Reset;
        PreRequisitionLine.setrange("Requisition No.", Rec."No.");
        if PreRequisitionLine.FindSet then
            repeat
                BodyTxt += '<TR>';
                BodyTxt += '<TD>' + Rec."No." + '</TD>';
                BodyTxt += '<TD>' + Format(Rec."Document Date") + '</TD>';
                BodyTxt += '<TD>' + PreRequisitionLine."No." + '</TD>';
                BodyTxt += '<TD>' + PreRequisitionLine.Description + '</TD>';
                BodyTxt += '<TD>' + PreRequisitionLine."Full Description" + '</TD>';
                BodyTxt += '<TD>' + Format(PreRequisitionLine.Quantity) + '</TD>';
                BodyTxt += '<TD>' + Format(PreRequisitionLine.UOM) + '</TD>';
                BodyTxt += '<TD>' + Format(PreRequisitionLine."Unit Price") + '</TD>';
                BodyTxt += '<TD>' + format(PreRequisitionLine.Amount) + '</TD>';
                BodyTxt += '<TD>' + PreRequisitionLine.Reamrk + '</TD>';
                BodyTxt += '<TD>' + format(Rec."Requisition Status") + '</TD>';


            until PreRequisitionLine.next = 0;
        BodyTxt += '</TR>';
        BodyTxt += '</table>';
        BodyTxt += '<br></br>';
        BodyTxt += 'Regards';
        BodyTxt += '<br></br>';
        BodyTxt += MailUserid;
        BodyTxt += '<br></br>';
        CompInfo.get();
        BodyTxt += CompInfo.Name;

        // end;
        EmailMsg.Create(MailUserIdVar, MailSubject, BodyTxt, true, CCMailIdList, BccMailIdList);
        EmailObj.Send(EmailMsg);
    end;

    var
        ApprovalEntryRequisition: Record "Approval Entry Requisition";
        PostedHeader: Record "Posted Requisition Header";
        PostedLine: Record "Posted Requisition Line";
        RequisitionLine: Record "Pre Requisition Line";
        EntryNo: Integer;
        usersetup: Record 91;
        AppEntryRequisitionEntryno: Record "Approval Entry Requisition";

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // TemplateRequisition.TemplateSelectionForRequisition(79902, Rec, JnlSelected, GenJnlTemplateCode);
        // IF NOT JnlSelected THEN
        //     ERROR('');
        // rec."Gen. Journal Template Code" := GenJnlTemplateCode;
        if usersetup.Get(UserId) then
            Rec."Shortcut Dimension 4 Code" := usersetup."Department Code";  //Gaurav
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if usersetup.Get(UserId) then
            Rec."Shortcut Dimension 4 Code" := usersetup."Department Code";
    end;


    var
        TemplateRequisition: Codeunit 50101;
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        usersetup1: Record 91;

}