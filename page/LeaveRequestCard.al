page 50177 "ZYN_Leave Request Card"
{
    PageType = Card;
    SourceTable = "ZYN_Leave Request";
    ApplicationArea = All;
    Caption = 'Leave Request Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Request Id"; Rec."RequestId")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Category"; Rec."Leave Category")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        LoadRemainingLeaves();
                        CurrPage.Update();
                    end;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Leaves"; RemainingTemp)
                {
                    ApplicationArea = All;
                    Editable = false; 
                }
            }
        }
    }

    var
        HiddenRec: Record "ZYN_Hidden Table";
        RemainingTemp: Integer;

    trigger OnAfterGetRecord()
    begin
        LoadRemainingLeaves();
    end;

    local procedure LoadRemainingLeaves()
    begin
        Clear(RemainingTemp);

        HiddenRec.Reset();
        HiddenRec.SetRange("Employee Id", Rec."Employee");
        HiddenRec.SetRange("Category Name", Rec."Leave Category");

        if HiddenRec.FindFirst() then
            RemainingTemp := HiddenRec."Remaining Leaves"
        else
            RemainingTemp := 0;
    end;
}
