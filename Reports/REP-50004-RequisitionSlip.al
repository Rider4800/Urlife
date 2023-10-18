report 50004 "Requisition Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\RequisitionSlip.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Requisition Req. Header"; "Requisition Req. Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.";
            column(Service_ItemDesc; ItemDesc)
            {
            }
            column(Comp_Pic; CompInfo.Picture)
            {
            }
            column(Work_Order_Date; FORMAT(ServiceHeader."Order Date"))
            {
            }
            column(DocumentType_RequisitionReqHeader; "Requisition Req. Header"."Document Type")
            {
            }
            column(No_RequisitionReqHeader; "Requisition Req. Header"."No.")
            {
            }
            column(LocationCode_RequisitionReqHeader; "Requisition Req. Header"."Location Code")
            {
            }
            column(ShortcutDimension1Code_RequisitionReqHeader; "Requisition Req. Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_RequisitionReqHeader; "Requisition Req. Header"."Shortcut Dimension 2 Code")
            {
            }
            column(EmployeeCode_RequisitionReqHeader; "Requisition Req. Header"."Employee Code")
            {
            }
            column(EmployeeFirstName_RequisitionReqHeader; "Requisition Req. Header"."Employee First Name")
            {
            }
            column(EmployeeLastName_RequisitionReqHeader; "Requisition Req. Header"."Employee Last Name")
            {
            }
            column(WorkOrderNo_RequisitionReqHeader; "Requisition Req. Header"."Work Order No.")
            {
            }
            column(NoSeries_RequisitionReqHeader; "Requisition Req. Header"."No. Series")
            {
            }
            column(DimensionsetId_RequisitionReqHeader; "Requisition Req. Header"."Dimension set Id")
            {
            }
            column(Status_RequisitionReqHeader; "Requisition Req. Header".Status)
            {
            }
            column(UserId_RequisitionReqHeader; "Requisition Req. Header".UserId)
            {
            }
            column(Posted_RequisitionReqHeader; "Requisition Req. Header".Posted)
            {
            }
            column(ServiceItemPartNo_RequisitionReqHeader; "Requisition Req. Header"."Service Item Part No")
            {
            }
            column(ServiceItemSerialNo_RequisitionReqHeader; "Requisition Req. Header"."Service Item Serial No")
            {
            }
            column(CustomerCode_RequisitionReqHeader; "Requisition Req. Header"."Customer Code")
            {
            }
            column(CustomerName_RequisitionReqHeader; "Requisition Req. Header"."Customer Name")
            {
            }
            dataitem("Requisition Req. Line"; "Requisition Req. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(ReleaseDocNo; ReleaseDocNo)
                {
                }
                column(ReleaseDocDate; FORMAT(ReleaseDocDate))
                {
                }
                column(SerialNo; SerialNo)
                {
                }
                column(LotNo; LotNo)
                {
                }
                column(ExpiryDate; FORMAT(ExpiryDate))
                {
                }
                column(S_No; i)
                {
                }
                column(Description_RequisitionReqLine; "Requisition Req. Line".Description)
                {
                }
                column(Description2_RequisitionReqLine; "Requisition Req. Line"."Description 2")
                {
                }
                column(Quantity_RequisitionReqLine; "Requisition Req. Line".Quantity)
                {
                }
                column(WorkOrderNo_RequisitionReqLine; "Requisition Req. Line"."Work Order No")
                {
                }
                column(PartNo_RequisitionReqLine; "Requisition Req. Line"."Part No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    i += 1;

                    CLEAR(LotNo);
                    CLEAR(ExpiryDate);
                    CLEAR(ReleaseDocDate);
                    CLEAR(ReleaseDocNo);
                    CLEAR(SerialNo);

                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE("Requisition Document No.", "Document No.");
                    ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
                    IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                        ItemApplicationEntry.RESET;
                        ItemApplicationEntry.SETRANGE(ItemApplicationEntry."Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                        IF ItemApplicationEntry.FINDFIRST THEN BEGIN
                            ILE.RESET;
                            ILE.SETRANGE(ILE."Entry No.", ItemApplicationEntry."Inbound Item Entry No.");
                            IF ILE.FINDFIRST THEN BEGIN
                                LotNo := ILE."Lot No.";
                                ExpiryDate := ILE."Expiration Date";
                                ReleaseDocDate := ILE."Released Doc Date";
                                ReleaseDocNo := ILE."Released Doc No.";
                                SerialNo := ILE."Serial No.";
                            END;
                        END;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    CLEAR(i);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ServiceHeader.RESET;
                ServiceHeader.SETRANGE("No.", "Work Order No.");
                IF ServiceHeader.FINDFIRST THEN;

                CLEAR(ItemDesc);
                ServiceItem.RESET;
                ServiceItem.SETRANGE("Serial No.", "Service Item Serial No");
                IF ServiceItem.FINDFIRST THEN
                    ItemDesc := ServiceItem.Description;
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInfo: Record "Company Information";
        ServiceHeader: Record "Service Header";
        i: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ServiceItem: Record "Service Item";
        ItemDesc: Text[250];
        ItemApplicationEntry: Record "Item Application Entry";
        ILE: Record "Item Ledger Entry";
        LotNo: Code[30];
        ExpiryDate: Date;
        WorkOrderILE: Record "Item Ledger Entry";
        ReleaseDocNo: Code[50];
        ReleaseDocDate: Date;
        SerialNo: Code[30];
}