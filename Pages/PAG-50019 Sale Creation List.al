page 50019 "Sale creation List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = 50014;
    UsageCategory = Lists;
    CardPageID = 50018;
    Caption = 'Sale Invoice creation List';
    SourceTableView = where("Created On Sale invoice" = const(false));


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Created On Sale invoice"; Rec."Created On Sale invoice")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension Code 1"; Rec."Global Dimension Code 1")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension Code 2"; Rec."Global Dimension Code 2")
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
            action(ExportData)
            {
                ApplicationArea = All;
                Caption = 'Export data to excel';

                trigger OnAction();
                var
                    CreationXml: Report 50101; // (it's a report)

                begin
                    Report.Run(50101, false, false);
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
                    RecSaleCreationLine: Record 50015;
                    XLineNo: Integer;
                begin
                    RecSaleHeader.Reset();
                    RecSaleHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
                    RecSaleHeader.SetRange("External Document No.", Rec."External Document No.");
                    RecSaleHeader.SetRange("Document Type", RecSaleHeader."Document Type"::Invoice);
                    if RecSaleHeader.FindFirst() then begin
                        Error('This Line is already on the sale invoice');
                    end else begin
                        RecSaleHeader.Init();
                        RecSaleHeader."Document Type" := RecSaleHeader."Document Type"::Invoice;
                        RecSaleHeader.Insert(true);
                        RecSaleHeader.Validate("Sell-to Customer No.", Rec."Customer No.");
                        RecSaleHeader.Validate("External Document No.", Rec."External Document No.");
                        RecSaleHeader.Validate("Posting Date", Rec."Posting Date");
                        RecSaleHeader.Validate("Shortcut Dimension 1 Code", Rec."Global Dimension Code 1");
                        RecSaleHeader.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension Code 2");
                        RecSaleHeader.Modify();
                        //Line insertion//
                        RecSaleCreationLine.Reset();
                        RecSaleCreationLine.SetRange("Document No.", Rec."No.");
                        if RecSaleCreationLine.FindSet() then begin
                            repeat
                                RecSaleLine.Init();
                                RecSaleLine."Line No." := RecSaleCreationLine."Line No.";
                                RecSaleLine.Validate("Document Type", RecSaleHeader."Document Type");
                                RecSaleLine.Validate("Document No.", RecSaleHeader."No.");
                                RecSaleLine.Validate(Type, RecSaleCreationLine.Type);
                                RecSaleLine.Validate("No.", RecSaleCreationLine."No.");
                                RecSaleLine.Validate(Quantity, RecSaleCreationLine.Qunatity);
                                RecSaleLine.Validate("Unit Price", RecSaleCreationLine."Direct Unit Cost");
                                RecSaleLine.Validate("Deferral Code", RecSaleCreationLine."Deferral Code");
                                RecSaleLine.Validate("GST Group Code", RecSaleCreationLine."GST Group Code");
                                RecSaleLine.Validate("HSN/SAC Code", RecSaleCreationLine."HSN/SAC Code");
                                RecSaleLine.Insert();
                                Rec."Created On Sale invoice" := true;
                            until RecSaleCreationLine.Next() = 0;
                        end;
                        Message('Data inserted on "Sale invoice"');
                    end;
                end;
            }
        }
    }
}