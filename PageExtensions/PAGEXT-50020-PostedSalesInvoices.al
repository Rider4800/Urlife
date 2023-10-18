// pageextension 50020 "Posted-Sales-Invoices" extends "Posted Sales Invoices"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         addafter("&Invoice")
//         {
//             action("Print Invoice Report")
//             {
//                 Caption = 'Print Invoice Report';
//                 Image = Invoice;
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 var
//                     SIH: Record "Sales Invoice Header";
//                 begin
//                     SIH.RESET;
//                     SIH.SETRANGE("No.", Rec."No.");
//                     REPORT.RUNMODAL(50000, TRUE, TRUE, SIH);
//                 end;
//             }
//         }
//     }
// }