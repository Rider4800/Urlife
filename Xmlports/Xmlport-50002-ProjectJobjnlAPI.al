xmlport 50002 "Project Job jnl API"
{
    Direction = Both;
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Job Journal Line"; "Job Journal Line")
            {
                XmlName = 'JobJnl';
                fieldelement(JobNo; "Job Journal Line"."Job No.")
                {
                }
                fieldelement(JobTaskNo; "Job Journal Line"."Job Task No.")
                {
                }
                fieldelement(PostingDate; "Job Journal Line"."Posting Date")
                {
                }
                fieldelement(Desc; "Job Journal Line".Description)
                {
                }
                fieldelement(Qty; "Job Journal Line".Quantity)
                {
                }
                fieldelement(UOM; "Job Journal Line"."Unit of Measure Code")
                {
                }
                fieldelement(LocationCode; "Job Journal Line"."Location Code")
                {
                }
                fieldelement(ProjectCode; "Job Journal Line"."Shortcut Dimension 1 Code")
                {
                }
                fieldelement(DeptCode; "Job Journal Line"."Shortcut Dimension 2 Code")
                {
                }
            }
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

    var
        DimensionValue: Record "Dimension Value";

    local procedure ProjectDimFilter(DimensionValue: Record "Dimension Value")
    begin
        // DimensionValue.RESET;
        // DimensionValue.SETRANGE(DimensionValue."Dimension Code",'PROJECTS');
        // DimensionValue.SETRANGE(DimensionValue."Global Dimension No.",2);
        // IF DimensionValue.FINDSET THEN
        //  REPEAT
        //    IF (DimensionValue."Creation Date" = TODAY) OR (DimensionValue."Last Modified date" = TODAY) THEN
        //      DimensionValue.MARK:= TRUE;
        //  UNTIL DimensionValue.NEXT = 0;
        //"Dimension Value".SETRANGE("Dimension Value"."Creation Date",TODAY);
        //"Dimension Value".SETRANGE("Dimension Value"."Last Modified date",TODAY);
    end;
}

