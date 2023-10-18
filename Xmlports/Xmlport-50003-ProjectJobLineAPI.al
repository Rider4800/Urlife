xmlport 50003 "Project Job Line API"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Job Task"; "Job Task")
            {
                AutoUpdate = true;
                XmlName = 'JobTask';
                SourceTableView = WHERE("Job Task Type" = CONST("Job Task Type"::Posting));
                fieldelement(JobNo; "Job Task"."Job No.")
                {
                }
                fieldelement(JobTaskNo; "Job Task"."Job Task No.")
                {
                }
                fieldelement(Desc; "Job Task".Description)
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