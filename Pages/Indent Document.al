page 79902 "Indent Document"
{
    PageType = Document;
    SourceTable = "Pre Indent Header";
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
                //     Caption = 'Indent Number';
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
                field("Indent Status"; Rec."Indent Status")
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
                field("Indent Remarks"; Rec."Indent Remarks")
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
            part("Indent Subfrom"; 79903)
            {
                SubPageLink = "Indent No." = field("No.");
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
                    IndentLine.Reset();
                    IndentLine.setrange("Indent No.", Rec."No.");
                    if IndentLine.FindFirst() then begin

                        IndentLine.TestField(Quantity);
                        IndentLine.TestField("Unit Price");

                    end;

                    IF NOT CONFIRM('Do you want to send for approval') THEN
                        EXIT;
                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    ApprovalEntryIndent.Init;
                    ApprovalEntryIndent."Entry No." := EntryNo + 1;
                    ApprovalEntryIndent."Indent No." := Rec."No.";
                    ApprovalEntryIndent."Sender UserID" := UserId;
                    usersetup.Get(UserId);
                    usersetup.TestField("Approver ID");
                    if usersetup1.get(usersetup."Approver ID") then begin
                        if rec.Amount <= usersetup1."Indent Approval Limit" then
                            ApprovalEntryIndent."Approver UserID" := usersetup1."User ID"
                        else
                            ApprovalEntryIndent."Approver UserID" := usersetup1."Approver ID";
                    end;


                    ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::"Sent for approval";
                    ApprovalEntryIndent."Sent for approval" := true;
                    ApprovalEntryIndent."Send DateTime" := CurrentDateTime;
                    ApprovalEntryIndent.Insert;
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
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    ApprovalEntryIndent.Init;
                    ApprovalEntryIndent."Entry No." := EntryNo + 1;
                    ApprovalEntryIndent."Indent No." := Rec."No.";
                    ApprovalEntryIndent."Cancel UserID" := UserId;
                    ApprovalEntryIndent."Cancel DateTime" := CurrentDateTime;
                    ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Cancel;
                    ApprovalEntryIndent."Sent for approval" := false;
                    ApprovalEntryIndent.Insert;

                    AppEntryIndentEntryno.Reset();
                    AppEntryIndentEntryno.setrange("Indent No.", Rec."No.");
                    if AppEntryIndentEntryno.FindSet then
                        repeat
                            AppEntryIndentEntryno."Sent for approval" := false;
                            AppEntryIndentEntryno.Modify;
                        until AppEntryIndentEntryno.Next = 0;
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
                    approvalEntryIndent.Reset();
                    approvalEntryIndent.SetRange("Indent No.", Rec."No.");
                    if approvalEntryIndent.FindFirst then
                        Page.RunModal(Page::"Approval History Indent", approvalEntryIndent)
                end;

            }
            action("Indent Report")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Print;
                trigger OnAction()
                var
                    indnetHeader: Record "Pre Indent Header";
                begin
                    indnetHeader.Reset;
                    indnetHeader.setrange("No.", rec."No.");
                    if indnetHeader.FindFirst then
                        Report.RunModal(79901, true, true, indnetHeader);

                end;

            }




        }

    }

    procedure SendMail(IndentHeader: Record "Pre Indent Header")
    var
        EmailObj: Codeunit Email;
        EmailMsg: Codeunit "Email Message";
        PreIndentLine: Record "Pre Indent Line";
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
        VarapproverSetup: Record 91;
        approveremail: Text;
    begin

        Clear(MailUserIdVar);
        Clear(BccMailIdList);
        Clear(CCMailIdList);
        // IndentHeader.Reset;
        // IndentHeader.setrange(Status, IndentHeader.Status::Open);
        // if IndentHeader.FindFirst then begin
        if DimValue.Get('DEPARTMENT', IndentHeader."Shortcut Dimension 4 Code") then;
        // MailUserIdVar.Add('kailash.singh@teamcomputers.com');  //Commented
        // MailUserIdVar.Add('dipti.bisht@teamcomputers.com');
        // CCMailIdList.Add('gaurav.pandit@teamcomputers.com');
        // CCMailIdList.Add('gauravims8@gmail.com'); // Change it to approver ID.
        BccMailIdList.Add('gaurav.pandit@teamcomputers.com');
        MailUserid := UserId;
        VarUserSetup.Reset();
        VarUserSetup.SetRange("User ID", UserId);
        if VarUserSetup.FindFirst() then
            UserEmail := VarUserSetup."E-Mail";


        VarapproverSetup.Reset();
        VarapproverSetup.SetRange("Approver ID", VarUserSetup."User ID");
        if VarapproverSetup.FindFirst() then begin
            approveremail := VarapproverSetup."E-Mail";
            MailUserIdVar.Add(approveremail);
        end;


        MailComapnyName := CompanyName;
        MailSubject := 'Indent No :- ' + IndentHeader."No." + ' ' + DimValue.Name + ' ' + CompanyName;


        BodyTxt := 'Dear Sir/Madam,';
        BodyTxt += '<br></br>';
        BodyTxt := 'Please find the below Indent for approval:';
        BodyTxt += '<br></br>';
        BodyTxt += '<TABLE border = "2">';
        BodyTxt += '<TH>Indent No.</TH>';
        BodyTxt += '<TH>Indent Date</TH>';
        BodyTxt += '<TH>Item No.</TH>';
        BodyTxt += '<TH>Item Description</TH>';
        BodyTxt += '<TH>Full Description</TH>';
        BodyTxt += '<TH>Quantity</TH>';
        BodyTxt += '<TH>UOM</TH>';
        BodyTxt += '<TH>Unit Price</TH>';
        BodyTxt += '<TH>Amount</TH>';
        BodyTxt += '<TH>Remarks</TH>';
        BodyTxt += '<TH>Indent Status</TH>';
        BodyTxt += '</TR>';

        PreIndentLine.Reset;
        PreIndentLine.setrange("Indent No.", Rec."No.");
        if PreIndentLine.FindSet then
            repeat
                BodyTxt += '<TR>';
                BodyTxt += '<TD>' + Rec."No." + '</TD>';
                BodyTxt += '<TD>' + Format(Rec."Document Date") + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine."No." + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine.Description + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine."Full Description" + '</TD>';
                BodyTxt += '<TD>' + Format(PreIndentLine.Quantity) + '</TD>';
                BodyTxt += '<TD>' + Format(PreIndentLine.UOM) + '</TD>';
                BodyTxt += '<TD>' + Format(PreIndentLine."Unit Price") + '</TD>';
                BodyTxt += '<TD>' + format(PreIndentLine.Amount) + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine.Reamrk + '</TD>';
                BodyTxt += '<TD>' + format(Rec."Indent Status") + '</TD>';


            until PreIndentLine.next = 0;
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
        EmailMsg.Create(MailUserIdVar, MailSubject, BodyTxt, true, CCMailIdList, BccMailIdList); //Here Receiver mail id specified
        EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);

    end;

    var
        ApprovalEntryIndent: Record "Approval Entry Indent";
        PostedHeader: Record "Posted Indent Header";
        PostedLine: Record "Posted Indent Line";
        IndentLine: Record "Pre Indent Line";
        EntryNo: Integer;
        usersetup: Record 91;
        AppEntryIndentEntryno: Record "Approval Entry Indent";

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // TemplateIndent.TemplateSelectionForIndent(79902, Rec, JnlSelected, GenJnlTemplateCode);
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
        TemplateIndent: Codeunit 79902;
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        usersetup1: Record 91;

}