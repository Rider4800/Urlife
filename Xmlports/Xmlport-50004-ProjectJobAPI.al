xmlport 50004 "Project Job API"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement(Job; Job)
            {
                AutoUpdate = true;
                XmlName = 'Job';
                fieldelement(JobNo; Job."No.")
                {
                }
                fieldelement(Desc; Job.Description)
                {
                }
                fieldelement(CustNo; Job."Bill-to Customer No.")
                {
                }
                fieldelement(StartingDate; Job."Starting Date")
                {
                }
                fieldelement(EndingDate; Job."Ending Date")
                {
                }
                fieldelement(JobStatus; Job.Status)
                {
                }
                fieldelement(ProjectCode; Job."Global Dimension 1 Code")
                {
                }
                fieldelement(DeptCode; Job."Global Dimension 2 Code")
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