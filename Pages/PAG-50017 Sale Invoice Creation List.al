page 50017 "Sale Invoice creation"
{
    PageType = List;
    // ApplicationArea = All;
    SourceTable = SaleInvoiceCreation;
    UsageCategory = Lists;
    CardPageID = 50015;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportData)
            {
                ApplicationArea = All;
                Caption = 'Import data from excel';

                trigger OnAction();
                var
                    CreationXml: XmlPort 50005;
                begin
                    CreationXml.Run();
                end;
            }
            action("Create Sale invoice")
            {
                ApplicationArea = all;
                Caption = 'Create Sale invoice';
                trigger OnAction();
                var
                    RecSaleHeader: Record "Sales Header";
                    RecSaleLine: Record "Sales Line";
                    NoSeriesManagement: Codeunit 396;
                    RecSaleRec: Record "Sales & Receivables Setup";
                    NextNo: Code[20];
                    RecSaleCreationLine: Record SaleInvoicecreationLine;
                begin
                    RecSaleHeader.Reset();
                    RecSaleHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
                    RecSaleHeader.SetRange("External Document No.", Rec."Document No.");
                    RecSaleHeader.SetRange("Document Type", RecSaleHeader."Document Type"::Invoice);
                    if RecSaleHeader.FindFirst() then begin
                        Error('This Line is already on the sale invoice');
                    end else begin
                        RecSaleHeader.Reset();
                        RecSaleHeader.Init();
                        NextNo := NoSeriesManagement.GetNextNo(RecSaleRec."Invoice Nos.", WORKDATE, TRUE);
                        RecSaleHeader."Document Type" := RecSaleHeader."Document Type"::Invoice;
                        RecSaleHeader.Validate("No.", NextNo);
                        RecSaleHeader.Validate("Sell-to Customer No.", Rec."Customer No.");
                        RecSaleHeader.Validate("External Document No.", Rec."Document No.");
                        RecSaleHeader.Validate("Posting Date", Rec."Posting Date");
                        RecSaleHeader.Insert();
                        //Line insertion//
                        RecSaleLine.Reset();
                        RecSaleLine.Init();
                        RecSaleCreationLine.Reset();
                        RecSaleCreationLine.SetRange("Document No.", Rec.No);
                        RecSaleCreationLine.SetRange("Line No.", RecSaleCreationLine."Line No.");
                        if RecSaleCreationLine.FindSet() then begin
                            repeat
                                RecSaleLine.Validate("Document No.", NextNo);
                                RecSaleLine.Validate("No.", RecSaleCreationLine."No.");
                                RecSaleLine.Validate(Type, RecSaleCreationLine.Type);
                                RecSaleLine.Validate(Quantity, RecSaleCreationLine.Qunatity);
                                RecSaleLine.Validate("Unit Cost", RecSaleCreationLine."Direct Unit Cost");
                                RecSaleLine.Validate("Deferral Code", RecSaleCreationLine."Deferral Code");
                                RecSaleLine.Insert();
                            until RecSaleCreationLine.Next() = 0;
                        end;
                    end;
                end;
            }
        }
    }
}