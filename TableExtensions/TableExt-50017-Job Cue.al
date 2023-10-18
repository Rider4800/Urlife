tableextension 50029 tableextension70000052 extends "Job Cue"
{
    fields
    {
        field(50000; "Open Sales Invoice"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice)));
            FieldClass = FlowField;
        }
        field(50001; "Posted Sales Invoice"; Integer)
        {
            CalcFormula = Count("Sales Invoice Header");
            FieldClass = FlowField;
        }
        field(50002; Contact; Integer)
        {
            CalcFormula = Count(Contact);
            FieldClass = FlowField;
        }
    }
}