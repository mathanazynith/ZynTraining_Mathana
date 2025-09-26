pageextension 50137 PostedSalesMemoExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Standard Code"; Rec."Begin Text Code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption='standard code';
            }
        }
    }
}

pageextension 50143 PostedSalesMemoEndeExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Ending Code"; Rec."End Text Code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption='Ending code';
            }
        }
    }
}