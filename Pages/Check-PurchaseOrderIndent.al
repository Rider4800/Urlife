// pageextension 50115 GetIndentFromPO extends "Purchase Order"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         addbefore(CopyDocument)
//         {
//             action(GetIndentLine)
//             {
//                 ApplicationArea = Suite;
//                 Caption = 'Get Indent Lines';
//                 Ellipsis = true;
//                 Image = GetLines;

//                 trigger OnAction()
//                 begin
//                     clear(IndentPage);
//                     PostedIndentLine.reset;
//                     PostedIndentLine.FilterGroup(2);
//                     PostedIndentLine.SetRange("Purchase Created", false);
//                     PostedIndentLine.SetFilter("Approved Qty", '>%1', 0);
//                     PostedIndentLine.FilterGroup(0);
//                     IndentPage.SetTableView(PostedIndentLine);
//                     IndentPage.GetDocNo(Rec."No.");
//                     IndentPage.LookupMode(true);
//                     IndentPage.RunModal();
//                 end;

//             }
//         }


//         // Add changes to page actions here
//     }

//     var
//         PostedIndentLine: Record "Posted Indent Line";
//         IndentPage: page "Posted Indent For PO";

// }