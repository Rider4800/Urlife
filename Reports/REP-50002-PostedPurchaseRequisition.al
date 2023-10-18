report 50002 "Posted Purchase Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\PostedPurchaseRequisition.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Material Req Header"; "Material Req Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(IssuedBy_MaterialReqHeader; "Material Req Header"."Issued By")
            {
            }
            column(ApproverID_MaterialReqHeader; "Material Req Header"."Department Head Approver")
            {
            }
            column(DocumentType_MaterialReqHeader; "Material Req Header"."Document Type")
            {
            }
            column(Quantity_MaterialReqHeader; "Material Req Header".Quantity)
            {
            }
            column(ResponsibilityCenter_MaterialReqHeader; "Material Req Header"."Responsibility Center")
            {
            }
            column(ItemNo_MaterialReqHeader; "Material Req Header"."Item No.")
            {
            }
            column(CreatedBy_MaterialReqHeader; "Material Req Header"."Created By")
            {
            }
            column(CreationDate_MaterialReqHeader; FORMAT("Material Req Header"."Creation Date"))
            {
            }
            column(ShortcutDimension2Code_MaterialReqHeader; "Material Req Header"."Shortcut Dimension 2 Code")
            {
            }
            column(LocationCode_MaterialReqHeader; "Material Req Header"."Location Code")
            {
            }
            column(ShortcutDimension1Code_MaterialReqHeader; "Material Req Header"."Shortcut Dimension 1 Code")
            {
            }
            column(Cmp_name; CompanyInfo.Name)
            {
            }
            column(C_GSTIN; CompanyInfo."GST Registration No.")
            {
            }
            column(PAN; CompanyInfo."P.A.N. No.")
            {
            }
            column(L_Name; LocationRec.Name)
            {
            }
            column(L_add; LocationRec.Address)
            {
            }
            column(GSTIN_CompanyInfo; LocationRec."GST Registration No.")
            {
            }
            column(State_l; LocationRec."State Code")
            {
            }
            column(L_add2; LocationRec."Address 2")
            {
            }
            column(L_city; LocationRec.City)
            {
            }
            column(L_phn; LocationRec."Phone No.")
            {
            }
            column(L_postcode; LocationRec."Post Code")
            {
            }
            column(L_country; LocationRec.County)
            {
            }
            column(L_Email; LocationRec."E-Mail")
            {
            }
            column(No_SalesInvoiceHeader; "Material Req Header"."No.")
            {
            }
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            {
            }
            column(Name_CompanyInfo; CompanyInfo.Name)
            {
            }
            column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
            {
            }
            column(FaxNo_CompanyInfo; CompanyInfo."Fax No.")
            {
            }
            column(LocStateName; LocStateName)
            {
            }
            column(Address_CompanyInfo; LocationRec.Address)
            {
            }
            column(Address2_CompanyInfo; LocationRec."Address 2")
            {
            }
            column(LocStateCode; LocStateCode1)
            {
            }
            column(PANNo_CompanyInfo; CompanyInfo."P.A.N. No.")
            {
            }
            column(Authority; Authority)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(TxtAmt; TxtAmt[1])
            {
            }
            column(DocumentCaptionCopyText; STRSUBSTNO(Text004, CopyText))
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(txt; txt)
                {
                }
                column(NoO_fLoops; NoOfLoops)
                {
                }
                column(Output; Output)
                {
                }
                dataitem("Material Req. Line"; "Material Req. Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemLinkReference = "Material Req Header";
                    DataItemTableView = SORTING("Document No.", "Line No.");
                    column(Transfer_To_Location; TransferLoc)
                    {
                    }
                    column(IssuedQuantity_MaterialReqLine; "Material Req. Line"."Issued Quantity")
                    {
                    }
                    column(ApprovedQuantity_MaterialReqLine; "Material Req. Line"."Approved Quantity")
                    {
                    }
                    column(OutstandingQuantity_MaterialReqLine; "Material Req. Line"."Outstanding Quantity")
                    {
                    }
                    column(UnitPrice_MaterialReqLine; "Material Req. Line"."Unit Price")
                    {
                    }
                    column(Amount_MaterialReqLine; "Material Req. Line".Amount)
                    {
                    }
                    column(Quantity_MaterialReqLine; "Material Req. Line".Quantity)
                    {
                    }
                    column(Description_MaterialReqLine; "Material Req. Line".Description)
                    {
                    }
                    column(Description2_MaterialReqLine; "Material Req. Line"."Description 2")
                    {
                    }
                    column(ItemNo_MaterialReqLine; "Material Req. Line"."Item No.")
                    {
                    }
                    column(SerialNo; SerialNo)
                    {
                    }
                    column(GrandTotal1; GrandTotal1)
                    {
                    }
                    column(GrandTotal2s; GrandTotal2)
                    {
                    }
                    column(NoText; NoText[1])
                    {
                    }
                    column(TExtSpc; TExtSpc)
                    {
                    }
                    column(InWords; InWords)
                    {
                    }
                    column(Challan_no; GateENtryNo)
                    {
                    }
                    column(BatchNo; BatchNo)
                    {
                    }
                    column(SNo1; SNo1)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        /*
                        SerialNo += 1;
                        IF SerialNo<5 THEN
                           TExtSpc:='4cm';
                        
                        CheckRep.InitTextVariable;
                        CheckRep.FormatNoText(ConvertToText,ROUND("Service Header"."Amount to Customer"),'');
                        
                        InWords := ConvertToText[1];
                        */
                        SNo1 += 1;

                        CLEAR(TransferLoc);
                        ILE.RESET;
                        ILE.SETRANGE("Document No.", "Document No.");
                        ILE.SETRANGE(Open, TRUE);
                        IF ILE.FINDFIRST THEN
                            TransferLoc := ILE."Location Code";

                    end;

                    trigger OnPreDataItem()
                    begin
                        //SerialNo:=0;
                        SNo1 := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN BEGIN
                        CopyText := 'ORIGINAL FOR RECIPIENT ';
                        Output += 1;
                    END;
                    IF Number = 2 THEN BEGIN
                        CopyText := ' DUPLICATE FOR TRANSPORTER';
                        Output += 1;
                    END;
                    IF Number = 3 THEN BEGIN
                        CopyText := ' TRIPLICATE FOR CONSIGNOR';
                        Output += 1;
                    END;
                    IF Number = 4 THEN BEGIN
                        CopyText := ' EXTRA - COPY';
                        Output += 1;
                    END;
                end;

                trigger OnPreDataItem()
                begin

                    NoOfLoops := ABS(NoOfCopies);
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    Output := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF LocationRec.GET("Location Code") THEN;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
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
            NoOfCopies := 4;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
    end;

    var
        Vend: Record Vendor;
        Cust: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        CompanyInfo: Record "Company Information";
        RecLoc: Record Location;
        RecState: Record State;
        RecCountry: Record "Country/Region";
        VendStateName: Text[100];
        VendCountry: Text[50];
        VendName: Text[100];
        VendStateCode: Text[100];
        VendAddress: Text[100];
        VendGSTIN: Code[25];
        VendPAN: Code[20];
        LocStateCode: Code[30];
        LocName: Text[50];
        SNo: Integer;
        DChallanLine: Record "Delivery Challan Line";
        POItemNo: Code[30];
        ItemCode: Code[30];
        ItemDescription: Text[100];
        UNITS: Decimal;
        UnitCost: Decimal;
        HSNCode: Code[20];
        BasicAmount: Decimal;
        TaxableAmount: Decimal;
        BasicAmount1: Decimal;
        TaxableAmount1: Decimal;
        TotalAmount1: Decimal;
        DetailGSTLedgerEntry: Record "Detailed GST Entry Buffer";
        CGSTPercent: Decimal;
        CGSTAmt: Decimal;
        SGSTPercent: Decimal;
        SGSTAmt: Decimal;
        IGSTPercent: Decimal;
        IGSTAmt: Decimal;
        CGSTAmt1: Decimal;
        SGSTAmt1: Decimal;
        IGSTAmt1: Decimal;
        NoOfLoops: Integer;
        Output: Integer;
        CopyText: Text;
        NoOfCopies: Integer;
        txt: Text;
        RecPurchHeader: Record "Purchase Header";
        recItem: Record Item;
        LastDirectPrice: Decimal;
        UOM: Code[10];
        RecState1: Record State;
        LocStateName: Text[50];
        RepCheck: Report "Check";
        NoText: array[2] of Text;
        RepText: array[2] of Text;
        TotalTaxAmount: Decimal;
        VendAddress2: Text[100];
        PlaceofSupply: Code[20];
        item: Record Item;
        SerialNo: Integer;
        TotalAmount: Decimal;
        Check1: Report "Check";
        TxtAmt: array[2] of Text[1024];
        UserSetup: Record "User Setup";
        LocationRec: Record Location;
        item1: Record Item;
        TAxper: Code[20];
        RecState2: Record State;
        Text004: Label '%1';
        TotalAmt1: Decimal;
        GrandTotal1: Decimal;
        GrandTotal2: Decimal;
        glaccount1: Record "G/L Account";
        VendStateCode1: Code[20];
        LocStateCode1: Code[20];
        RecState3: Record State;
        RecState4: Record State;
        Authority: Text[100];
        TExtSpc: Text[250];
        FA1: Record 5600;
        Ebill: Code[30];
        Edate: Date;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        DetailedGSTLE: Record "Detailed GST Entry Buffer";
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        BilltoCustomer: Record "Customer";
        BiltoGSTNo: Code[150];
        BiltoName: Text[50];
        BiltoAddress: Text[150];
        BiltoState: Code[150];
        BiltoStateCode: Code[150];
        ShipptoCustomer: Record "Customer";
        ShipptoName: Text[150];
        ShipptoAddress: Text[150];
        ShipptoState: Code[150];
        ShipptoStateCode: Code[150];
        ShipptoGSTNo: Code[150];
        BilltoCity: Code[50];
        Shipptocity: Code[50];
        BiltoStatRegCode: Code[10];
        staterec: Record State;
        CheckRep: Report "Check";
        ConvertToText: array[2] of Text;
        InWords: Text[1024];
        ServiceShipmentLine: Record "Service Shipment Line";
        PostedGateEntryLine: Record "Posted Gate Entry Line";
        ServiceItem: Record "Service Item";
        ServiceShipmentHeader: Record "Service Shipment Header";
        PostedGateEntryHeader: Record "Posted Gate Entry Header";
        GateENtryNo: Code[20];
        PostingDate: Date;
        DocumentNo: Code[20];
        RepairNo: Code[20];
        ServiceItemLine: Record "Service Item Line";
        ServiceItemNo: Code[20];
        ServicePartNo: Code[20];
        ServiceLineDesc: Text[150];
        OrderNo: Code[20];
        BilltoCountry: Text[50];
        CountryRegion: Record "Country/Region";
        ILE: Record "Item Ledger Entry";
        BatchNo: Code[20];
        SNo1: Integer;
        PurchHeader: Record "Purchase Header";
        VendInvoiceNo: Code[40];
        TransferLoc: Code[20];
}