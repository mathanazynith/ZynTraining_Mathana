page 50197 "ZYN_Employee Asset Card"
{
    PageType = Card;
    SourceTable = "ZYN_Employee Asset";
    Caption = 'Employee Asset Card';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee ID"; Rec."Employee ID") { ApplicationArea = All; }

                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.CalcAvailability();
                        SetEditableFields();
                        CurrPage.Update(false);
                    end;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.CalcAvailability();
                        SetEditableFields();
                        CurrPage.Update(false);
                    end;
                }

                field("Assigned Date"; Rec."Assigned Date")
                {
                    ApplicationArea = All;
                    Editable = AssignedEditable;
                }

                field("Returned Date"; Rec."Returned Date")
                {
                    ApplicationArea = All;
                    Editable = ReturnedEditable;
                }

                field("Lost Date"; Rec."Lost Date")
                {
                    ApplicationArea = All;
                    Editable = LostEditable;
                }

                field(Availability; Rec.Availability)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    var
        AssignedEditable: Boolean;
        ReturnedEditable: Boolean;
        LostEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcAvailability();
        SetEditableFields();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcAvailability();
        SetEditableFields();
    end;

    local procedure SetEditableFields()
    begin
        AssignedEditable := false;
        ReturnedEditable := false;
        LostEditable := false;

        case Rec.Status of
            Rec.Status::Assigned:
                AssignedEditable := true;
            Rec.Status::Returned:
                begin
                    AssignedEditable := true;
                    ReturnedEditable := true;
                end;
            Rec.Status::Lost:
                begin
                    AssignedEditable := true;
                    LostEditable := true;
                end;
        end;
    end;
}
