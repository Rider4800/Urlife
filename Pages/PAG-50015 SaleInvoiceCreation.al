page 50015 SaleInvoiceCreation
{
    PageType = Document;
    // ApplicationArea = All;
    SourceTable = SaleInvoiceCreation;

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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
            }
            part(SalesLinesCreation; SaleInvoiceCreationSubForm)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field(No);
            }
        }

    }

    actions
    {

    }
}