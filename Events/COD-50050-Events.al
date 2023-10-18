codeunit 50050 "Event"
{
    [EventSubscriber(ObjectType::Table, 5612, 'OnAfterSetBookValueFiltersOnFALedgerEntry', '', false, false)]
    local procedure OnAfterSetBookValueFiltersOnFALedgerEntry(var FALedgerEntry: Record "FA Ledger Entry")
    begin
        FALedgerEntry.SETRANGE("FA Posting Category", FALedgerEntry."FA Posting Category"::Disposal);
        FALedgerEntry.SETRANGE("FA Posting Type", FALedgerEntry."FA Posting Type"::"Book Value on Disposal");
    end;


    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, 13, 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line")
    var
        RecPurchPaybleSetup: Record "Purchases & Payables Setup";
        RecGLEntry: Record "G/L Entry";
    begin
        RecPurchPaybleSetup.Get;
        RecPurchPaybleSetup.TestField("GL Account No.");
        RecPurchPaybleSetup.TestField("GL Account Per Day Limit");

        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account" then begin
            if GenJournalLine."Account No." = RecPurchPaybleSetup."GL Account No." then begin
                RecGLEntry.Reset;
                RecGLEntry.SetRange("G/L Account No.", GenJournalLine."Account No.");
                RecGLEntry.SetRange("Posting Date", Today);
                if RecGLEntry.FindSet then begin
                    RecGLEntry.CalcSums(Amount);
                    if ABS(RecGLEntry.Amount) + ABS(GenJournalLine.Amount) > RecPurchPaybleSetup."GL Account Per Day Limit" then
                        Error('You cannot post the Amount more than the daily limit of GL Account %1', GenJournalLine."Account No.");
                end;
            end;
        end;
    end;
}