report 50001 "Explosion of BOM Requisition"
{
    Caption = 'Explosion of BOM Requisition';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Material Req Header"; "Material Req Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            dataitem(Item; Item)
            {
                DataItemLink = "No." = FIELD("Item No.");
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Search Description", "Inventory Posting Group";
                dataitem(BOMLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    dataitem(Integer; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        MaxIteration = 1;

                        trigger OnAfterGetRecord()
                        begin
                            BOMQty := Quantity[Level] * QtyPerUnitOfMeasure * BomComponent[Level].Quantity;


                            MaterialReqLine.INIT;
                            MaterialReqLine."Document No." := "Material Req Header"."No.";
                            MaterialReqLine."Document Type" := "Material Req Header"."Document Type";
                            MaterialReqLine."Line No." := LineNo;
                            MaterialReqLine.Type := MaterialReqLine.Type::Item;
                            MaterialReqLine."Item No." := BomComponent[Level]."No.";
                            MaterialReqLine."Shortcut Dimension 1 Code" := "Material Req Header"."Shortcut Dimension 1 Code";
                            MaterialReqLine."Shortcut Dimension 2 Code" := "Material Req Header"."Shortcut Dimension 2 Code";
                            MaterialReqLine.VALIDATE(Quantity, BOMQty * "Material Req Header".Quantity);
                            IF ItemRec.GET(BomComponent[Level]."No.") THEN BEGIN
                                IF ItemRec."Replenishment System" = ItemRec."Replenishment System"::Purchase THEN BEGIN
                                    MaterialReqLine.Description := ItemRec.Description;
                                    MaterialReqLine."Unit of Measure Code" := ItemRec."Base Unit of Measure";
                                    MaterialReqLine."Description 2" := ItemRec."Description 2";
                                    MaterialReqLine."Bom Quantity" := BOMQty;
                                    LineNo += 10000;
                                    MaterialReqLine.INSERT;
                                END;
                            END;

                        end;

                        trigger OnPostDataItem()
                        begin
                            Level := NextLevel;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        BomItem: Record Item;
                    begin
                        WHILE BomComponent[Level].NEXT = 0 DO BEGIN
                            Level := Level - 1;
                            IF Level < 1 THEN
                                CurrReport.BREAK;
                        END;

                        NextLevel := Level;
                        CLEAR(CompItem);
                        QtyPerUnitOfMeasure := 1;
                        CASE BomComponent[Level].Type OF
                            BomComponent[Level].Type::Item:
                                BEGIN
                                    CompItem.GET(BomComponent[Level]."No.");
                                    IF CompItem."Production BOM No." <> '' THEN BEGIN
                                        ProdBOM.GET(CompItem."Production BOM No.");
                                        IF ProdBOM.Status = ProdBOM.Status::Closed THEN
                                            CurrReport.SKIP;
                                        NextLevel := Level + 1;
                                        IF Level > 1 THEN
                                            IF (NextLevel > 50) OR (BomComponent[Level]."No." = NoList[Level - 1]) THEN
                                                ERROR(ProdBomErr, 50, Item."No.", NoList[Level], Level);
                                        CLEAR(BomComponent[NextLevel]);
                                        NoListType[NextLevel] := NoListType[NextLevel] ::Item;
                                        NoList[NextLevel] := CompItem."No.";
                                        VersionCode[NextLevel] :=
                                          VersionMgt.GetBOMVersion(CompItem."Production BOM No.", CalculateDate, TRUE);

                                        BomComponent[NextLevel].SETRANGE("Production BOM No.", CompItem."Production BOM No.");
                                        BomComponent[NextLevel].SETRANGE("Version Code", VersionCode[NextLevel]);
                                        BomComponent[NextLevel].SETFILTER("Starting Date", '%1|..%2', 0D, CalculateDate);
                                        BomComponent[NextLevel].SETFILTER("Ending Date", '%1|%2..', 0D, CalculateDate);
                                    END;
                                    IF Level > 1 THEN
                                        IF BomComponent[Level - 1].Type = BomComponent[Level - 1].Type::Item THEN
                                            IF BomItem.GET(BomComponent[Level - 1]."No.") THEN
                                                QtyPerUnitOfMeasure :=
                                                  UOMMgt.GetQtyPerUnitOfMeasure(BomItem, BomComponent[Level - 1]."Unit of Measure Code") /
                                                  UOMMgt.GetQtyPerUnitOfMeasure(
                                                    BomItem, VersionMgt.GetBOMUnitOfMeasure(BomItem."Production BOM No.", VersionCode[Level]));
                                END;
                            BomComponent[Level].Type::"Production BOM":
                                BEGIN
                                    ProdBOM.GET(BomComponent[Level]."No.");
                                    IF ProdBOM.Status = ProdBOM.Status::Closed THEN
                                        CurrReport.SKIP;
                                    NextLevel := Level + 1;
                                    IF Level > 1 THEN
                                        IF (NextLevel > 50) OR (BomComponent[Level]."No." = NoList[Level - 1]) THEN
                                            ERROR(ProdBomErr, 50, Item."No.", NoList[Level], Level);
                                    CLEAR(BomComponent[NextLevel]);
                                    NoListType[NextLevel] := NoListType[NextLevel] ::"Production BOM";
                                    NoList[NextLevel] := ProdBOM."No.";
                                    VersionCode[NextLevel] := VersionMgt.GetBOMVersion(ProdBOM."No.", CalculateDate, TRUE);
                                    BomComponent[NextLevel].SETRANGE("Production BOM No.", NoList[NextLevel]);
                                    BomComponent[NextLevel].SETRANGE("Version Code", VersionCode[NextLevel]);
                                    BomComponent[NextLevel].SETFILTER("Starting Date", '%1|..%2', 0D, CalculateDate);
                                    BomComponent[NextLevel].SETFILTER("Ending Date", '%1|%2..', 0D, CalculateDate);
                                END;
                        END;

                        IF NextLevel <> Level THEN
                            Quantity[NextLevel] := BomComponent[NextLevel - 1].Quantity * QtyPerUnitOfMeasure * Quantity[Level];
                    end;

                    trigger OnPreDataItem()
                    begin
                        Level := 1;

                        ProdBOM.GET(Item."Production BOM No.");

                        VersionCode[Level] := VersionMgt.GetBOMVersion(Item."Production BOM No.", CalculateDate, TRUE);
                        CLEAR(BomComponent);
                        BomComponent[Level]."Production BOM No." := Item."Production BOM No.";
                        BomComponent[Level].SETRANGE("Production BOM No.", Item."Production BOM No.");
                        BomComponent[Level].SETRANGE("Version Code", VersionCode[Level]);
                        BomComponent[Level].SETFILTER("Starting Date", '%1|..%2', 0D, CalculateDate);
                        BomComponent[Level].SETFILTER("Ending Date", '%1|%2..', 0D, CalculateDate);
                        NoListType[Level] := NoListType[Level] ::Item;
                        NoList[Level] := Item."No.";
                        Quantity[Level] :=
                          UOMMgt.GetQtyPerUnitOfMeasure(Item, Item."Base Unit of Measure") /
                          UOMMgt.GetQtyPerUnitOfMeasure(
                            Item,
                            VersionMgt.GetBOMUnitOfMeasure(
                              Item."Production BOM No.", VersionCode[Level]));
                    end;
                }

                trigger OnPreDataItem()
                begin
                    ItemFilter := GETFILTERS;

                    SETFILTER("Production BOM No.", '<>%1', '');
                end;
            }

            trigger OnPreDataItem()
            begin
                CLEAR(LineNo);
                LineNo := 10000;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CalculateDate; CalculateDate)
                    {
                        Caption = 'Calculation Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CalculateDate := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        Text000: Label 'As of ';
        ProdBOM: Record "Production BOM Header";
        BomComponent: array[99] of Record "Production BOM Line";
        CompItem: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit "VersionManagement";
        ItemFilter: Text;
        CalculateDate: Date;
        NoList: array[99] of Code[20];
        VersionCode: array[99] of Code[20];
        Quantity: array[99] of Decimal;
        QtyPerUnitOfMeasure: Decimal;
        Level: Integer;
        NextLevel: Integer;
        BOMQty: Decimal;
        QtyExplosionofBOMCaptLbl: Label 'Quantity Explosion of BOM';
        CurrReportPageNoCaptLbl: Label 'Page';
        BOMQtyCaptionLbl: Label 'Total Quantity';
        BomCompLevelQtyCaptLbl: Label 'BOM Quantity';
        BomCompLevelDescCaptLbl: Label 'Description';
        BomCompLevelNoCaptLbl: Label 'No.';
        LevelCaptLbl: Label 'Level';
        BomCompLevelUOMCodeCaptLbl: Label 'Unit of Measure Code';
        NoListType: array[99] of Option " ",Item,"Production BOM";
        ProdBomErr: Label 'The maximum number of BOM levels, %1, was exceeded. The process stopped at item number %2, BOM header number %3, BOM level %4.';
        MaterialReqLine: Record "Material Req. Line";
        ItemRec: Record Item;
        LineNo: Integer;
}