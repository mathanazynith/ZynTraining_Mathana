page 50118 "Modify List"
{
    PageType = List;
    SourceTable = "Modify Log";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Modify List';
    InsertAllowed = false;
    Editable = false;
    CardPageId = "Customer Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("entry no."; Rec."Entry No.") { ApplicationArea = All; }
                field("Customer No";Rec."Customer No.") {
                    ApplicationArea = All;}
                field("Field Change.";Rec."Field Change.") {ApplicationArea = All; }
                field("Old Field";Rec."Old Field") { ApplicationArea = All;}
                field("New Field";Rec."New Field") {ApplicationArea = All; }
                field("User Id";Rec."User Id") {ApplicationArea = All; }

                
            }
            
        }
    
    }
    
}