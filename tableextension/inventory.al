tableextension 50121 itemext extends Item
{
    fields
    {
        field(50121; current_quantity; Decimal)
        {
            Caption = 'current quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("No.")));
        }
    }
}
 
pageextension 50122 itemexten extends "Item List"
{
    layout
    {
        addafter(Type)
        {
            field(current_quantity; Rec.current_quantity) { ApplicationArea = all; }
        }
    }
}