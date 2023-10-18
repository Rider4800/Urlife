// pageextension 50034 "Purchase Order Subform Ext" extends "Purchase Order Subform"
// {
//     layout
//     {
//         addafter("Line Amount")
//         {
//             field("Requisition Document No."; Rec."Requisition Document No.")
//             {
//                 ApplicationArea = All;
//             }
//             field("Requisition Line No."; Rec."Requisition Line No.")
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