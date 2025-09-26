page 50108 "ZYN_Index Card"
{
    PageType = Card;
    SourceTable = "ZYN_Index Header";
    ApplicationArea = All;
    Caption = 'Index Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; Editable = false; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Percentage Increase"; Rec."Percentage Increase") { ApplicationArea = All; }
                field("Base Amount"; Rec."Base Amount") { ApplicationArea = All; }
                field("Start Year"; Rec."Start Year") { ApplicationArea = All; }
                field("End Year"; Rec."End Year") { ApplicationArea = All; }
            }

            part(IndexEntries; "ZYN_Index Entry Subpage")
            {
                ApplicationArea = All;
                SubPageLink = Code = FIELD(Code);
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Entry: Record "ZYN_Index Entry";
        EntryNo: Integer;
        CurrentValue: Decimal;
        YearLoop: Integer;
        Pct: Decimal;
    begin
        if (Rec."Start Year" <> 0) and (Rec."End Year" <> 0) and (Rec."Base Amount" <> 0) then begin
        
            Entry.Reset();
            Entry.SetRange(Code, Rec.Code);
            Entry.DeleteAll();

            
            EntryNo := 1;
            CurrentValue := Rec."Base Amount";
            Pct := Rec."Percentage Increase" / 100;

            for YearLoop := Rec."Start Year" to Rec."End Year" do begin
                Entry.Init();
                Entry.Code := Rec.Code;
                Entry."Entry No." := EntryNo;
                Entry.Year := YearLoop;
                Entry.Value := Round(CurrentValue, 0.01);
                Entry.Insert();
                CurrentValue := CurrentValue * (1 + Pct);
                EntryNo += 1;
            end;
        end;
    end;
}
