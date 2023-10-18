page 50117 "Requisition Approve/Reject"
{
    PageType = Document;
    SourceTable = "Pre Requisition Header";
    DeleteAllowed = false;
    InsertAllowed = false;

    SourceTableView = sorting("No.") where(Status = filter("Sent for approval"));
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = all;

                }
                field("Required Date"; Rec."Required Date")
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                    ApplicationArea = all;
                    Editable = false;
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                    Editable = true;
                }
            }
            part("Requisition Subfrom"; 50113)
            {
                SubPageLink = "Requisition No." = field("No.");
                ApplicationArea = all;
            }


        }
    }
    actions
    {
        area(Processing)
        {
            action("Approve")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Approve;
                trigger OnAction()
                begin

                    RequisitionLine.Reset();
                    RequisitionLine.setrange("Requisition No.", Rec."No.");
                    if RequisitionLine.FindSet then
                        repeat
                            RequisitionLine.TestField("Approved Qty");
                        until RequisitionLine.Next = 0;

                    IF NOT CONFIRM('Do you want to Approve') THEN
                        EXIT;
                    Clear(EntryNo);
                    if AppEntryRequisitionEntryno.FindLast then
                        EntryNo := AppEntryRequisitionEntryno."Entry No.";

                    ApprovalEntryRequisition.Init;
                    ApprovalEntryRequisition."Entry No." := EntryNo + 1;
                    ApprovalEntryRequisition."Requisition No." := Rec."No.";
                    ApprovalEntryRequisition."Approver UserID" := UserId;
                    ApprovalEntryRequisition."Approval DateTime" := CurrentDateTime;
                    ApprovalEntryRequisition.Status := ApprovalEntryRequisition.Status::Approved;
                    ApprovalEntryRequisition."Sent for approval" := false;
                    ApprovalEntryRequisition.Insert;

                    PostedHeader.Init();
                    PostedHeader.TransferFields(Rec);
                    PostedHeader.Status := PostedHeader.Status::Approved;
                    PostedHeader.Insert();



                    RequisitionLine.Reset();
                    RequisitionLine.SetRange("Requisition No.", rec."No.");
                    RequisitionLine.SetFilter("Approved Qty", '>%1', 0);
                    if RequisitionLine.FindSet then
                        repeat
                            PostedLine.Init();
                            PostedLine."Requisition No." := RequisitionLine."Requisition No.";
                            PostedLine."Line No" := RequisitionLine."Line No";
                            PostedLine.Type := RequisitionLine.Type;
                            PostedLine."No." := RequisitionLine."No.";
                            PostedLine.Description := RequisitionLine.Description;
                            PostedLine.Quantity := RequisitionLine.Quantity;
                            PostedLine."Remaining Quantity" := RequisitionLine."Remaining Quantity";
                            PostedLine."Required Quantity" := RequisitionLine."Required Quantity";
                            PostedLine."Approved Qty" := RequisitionLine."Approved Qty";
                            PostedLine.UOM := RequisitionLine.UOM;
                            PostedLine."HSN/SAC Code" := RequisitionLine."HSN/SAC Code";
                            PostedLine."Full Description" := RequisitionLine."Full Description";
                            PostedLine.Amount := RequisitionLine.Amount;
                            PostedLine.Reamrk := RequisitionLine.Reamrk;
                            PostedLine."Shortcut Dimension 1 Code" := RequisitionLine."Shortcut Dimension 1 Code";
                            PostedLine."Shortcut Dimension 2 Code" := RequisitionLine."Shortcut Dimension 2 Code";
                            PostedLine."Shortcut Dimension 4 Code" := RequisitionLine."Shortcut Dimension 4 Code";
                            PostedLine."Dimension Set ID" := RequisitionLine."Dimension Set ID";
                            PostedLine.Insert();
                            RequisitionLine.Delete();
                        until RequisitionLine.Next = 0;
                    AppEntryRequisitionEntryno.Reset();
                    AppEntryRequisitionEntryno.setrange("Requisition No.", Rec."No.");
                    if AppEntryRequisitionEntryno.FindSet then
                        repeat
                            AppEntryRequisitionEntryno."Sent for approval" := false;
                            AppEntryRequisitionEntryno.Modify;
                        until AppEntryRequisitionEntryno.Next = 0;
                    SendMail(rec);

                    rec.Delete();

                end;
            }

            action("Reject")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Reject;
                trigger OnAction()
                begin
                    Rec.testfield("Rejection Remarks");
                    IF NOT CONFIRM('Do you want to Reject') THEN
                        EXIT;
                    Clear(EntryNo);
                    if AppEntryRequisitionEntryno.FindLast then
                        EntryNo := AppEntryRequisitionEntryno."Entry No.";

                    ApprovalEntryRequisition.Init;
                    ApprovalEntryRequisition."Entry No." := EntryNo + 1;
                    ApprovalEntryRequisition."Requisition No." := Rec."No.";
                    ApprovalEntryRequisition."Rejected UserID" := UserId;
                    ApprovalEntryRequisition."Rejection DateTime" := CurrentDateTime;
                    ApprovalEntryRequisition."Reject Remarks" := Rec."Rejection Remarks";
                    ApprovalEntryRequisition.Status := ApprovalEntryRequisition.Status::Rejected;
                    ApprovalEntryRequisition.Insert;

                    AppEntryRequisitionEntryno.Reset();
                    AppEntryRequisitionEntryno.setrange("Requisition No.", Rec."No.");
                    if AppEntryRequisitionEntryno.FindSet then
                        repeat
                            AppEntryRequisitionEntryno."Sent for approval" := false;
                            AppEntryRequisitionEntryno.Modify;
                        until AppEntryRequisitionEntryno.Next = 0;
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



        }




    }


    procedure SendMail(RequisitionHeader: Record "Pre Requisition Header")
    var
        EmailObj: Codeunit Email;
        EmailMsg: Codeunit "Email Message";
        PostRequisitionLine: Record "Posted Requisition Line";
        CCMailIdList: List of [Text];
        BccMailIdList: List of [Text];
        BodyTxt: Text;
        MailUserIdVar: List of [Text];
        MailSubject: Text;
        MailUserid: Text;
        MailComapnyName: Text;
        DimValue: Record "Dimension Value";
        CompInfo: Record "Company Information";
    begin

        Clear(MailUserIdVar);
        Clear(BccMailIdList);
        Clear(CCMailIdList);
        //RequisitionHeader.Reset;
        // RequisitionHeader.setrange(Status, RequisitionHeader.Status::"Sent for approval");
        // if RequisitionHeader.FindFirst then begin
        MailUserIdVar.Add('gaurav.pandit@teamcomputers.com');
        MailUserIdVar.Add('gaurav.pandit@teamcomputers.com');
        MailUserid := UserId;
        MailComapnyName := CompanyName;
        if DimValue.Get('DEPARTMENT', RequisitionHeader."Shortcut Dimension 4 Code") then;
        MailSubject := 'Requisition Approved No :-' + RequisitionHeader."No." + ' ' + DimValue.Name + ' ' + CompanyName;


        BodyTxt := 'Dear Sir/Madam,';
        BodyTxt += '<br></br>';
        BodyTxt := 'Please find the approval of Requisition raised,';
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
        BodyTxt += '<TH>Approved Quantity</TH>';
        BodyTxt += '<TH>Amount</TH>';
        BodyTxt += '<TH>Remarks</TH>';
        BodyTxt += '<TH>Requisition Status</TH>';
        BodyTxt += '</TR>';

        PostRequisitionLine.Reset;
        PostRequisitionLine.setrange("Requisition No.", Rec."No.");
        if PostRequisitionLine.FindSet then
            repeat
                BodyTxt += '<TR>';
                BodyTxt += '<TD>' + Rec."No." + '</TD>';
                BodyTxt += '<TD>' + Format(Rec."Document Date") + '</TD>';
                BodyTxt += '<TD>' + PostRequisitionLine."No." + '</TD>';
                BodyTxt += '<TD>' + PostRequisitionLine.Description + '</TD>';
                BodyTxt += '<TD>' + PostRequisitionLine."Full Description" + '</TD>';
                BodyTxt += '<TD>' + Format(PostRequisitionLine.Quantity) + '</TD>';
                BodyTxt += '<TD>' + Format(PostRequisitionLine.UOM) + '</TD>';
                BodyTxt += '<TD>' + Format(PostRequisitionLine."Unit Price") + '</TD>';
                BodyTxt += '<TD>' + Format(PostRequisitionLine."Approved Qty") + '</TD>';
                BodyTxt += '<TD>' + format(PostRequisitionLine.Amount) + '</TD>';
                BodyTxt += '<TD>' + PostRequisitionLine.Reamrk + '</TD>';
                BodyTxt += '<TD>' + format(Rec."Requisition Status") + '</TD>';
            until PostRequisitionLine.next = 0;
        BodyTxt += '</TR>';
        BodyTxt += '</table>';
        BodyTxt += '<br></br>';
        BodyTxt += 'Regards';
        BodyTxt += '<br></br>';
        BodyTxt += MailUserid;
        BodyTxt += '<br></br>';
        CompInfo.get();
        BodyTxt += CompInfo.Name;

        //end;
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


}