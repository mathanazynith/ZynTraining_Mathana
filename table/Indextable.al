table 50120 "Index Header"
{
    Caption = 'Index Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            Editable = false;             
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Percentage Increase"; Decimal)
        {
            Caption = 'Percentage Increase';
            DataClassification = CustomerContent;
            
        }
        field(4; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;
        }
        field(5; "Start Year"; Integer)
        {
            Caption = 'Start Year';
            DataClassification = CustomerContent;
        }
        field(6; "End Year"; Integer)
        {
            Caption = 'End Year';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }   
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SeriesCode: Code[20];
    begin
        
        if Code = '' then begin
            SeriesCode := EnsureIndexNoSeriesExists();
            Code := NoSeriesMgt.GetNextNo(SeriesCode, WorkDate(), true);
        end;
    end;

    trigger OnModify()
    begin
        
        GenerateEntries();
    end;

    local procedure GenerateEntries()
    var
        Entry: Record "Index Entry";
        YearLoop: Integer;
        EntryNo: Integer;
        CurrentValue: Decimal;
        Pct: Decimal;
    begin
        if IsTemporary then
            exit;

        if ("Start Year" = 0) or ("End Year" = 0) then
            exit;
        if "End Year" < "Start Year" then
            exit;
        if "Base Amount" = 0 then
            exit;

        
        Entry.Reset();
        Entry.SetRange(Code, Code);
        Entry.DeleteAll();

        
        EntryNo := 1;
        CurrentValue := "Base Amount";
        Pct := "Percentage Increase" / 100;

        for YearLoop := "Start Year" to "End Year" do begin
            Entry.Init();
            Entry.Code := Code;
            Entry."Entry No." := EntryNo;
            Entry.Year := YearLoop;
            Entry.Value := Round(CurrentValue, 0.01);
            Entry.Insert(true);

            CurrentValue := CurrentValue * (1 + Pct);
            EntryNo += 1;
        end;
    end;

    local procedure EnsureIndexNoSeriesExists(): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        SeriesCode: Code[20];
    begin
        SeriesCode := 'INDEXNOSERIES';

        if not NoSeries.Get(SeriesCode) then begin
            
            NoSeries.Init();
            NoSeries.Code := SeriesCode;
            NoSeries.Description := 'Index Header Series (auto-created)';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := false;
            NoSeries.Insert(true);

              
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := SeriesCode;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := 0D;
            NoSeriesLine."Starting No." := 'IDX00001';
            NoSeriesLine."Ending No." := 'IDX99999';
            NoSeriesLine."Warning No." := '';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert(true);
        end;

        exit(SeriesCode);
    end;


    trigger OnDelete()
    var
        Entry: Record "Index Entry";
    begin
        
        Entry.Reset();
        Entry.SetRange(Code, Rec.Code);
        if not Entry.IsEmpty() then
            Entry.DeleteAll();
    end;
}