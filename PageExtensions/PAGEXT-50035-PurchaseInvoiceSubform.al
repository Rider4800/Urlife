// pageextension 50035 "Purchase Order Ext1" extends "Purchase Order"
// {
//     layout
//     {
//         addafter("Vendor Invoice No.")
//         {
//             field("PO Expense Type"; Rec."PO Expense Type")
//             {
//                 ApplicationArea = All;
//             }
//             field("Special Instruction"; Rec."Special Instruction")
//             {
//                 ApplicationArea = All;
//             }
//         }
//     }

//     actions
//     {
//         // Add changes to page actions here
//     }
// }