table 50210 "Subscription Cue"
{
    Caption = 'Subscription Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(2; "Active Subscriptions"; Integer)
        {
            Caption = 'Active Subscriptions';
            FieldClass = FlowField;
            CalcFormula = Count(Subscription WHERE(Status = CONST(Active)));
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
page 50211 "Subscription Cue Page"
{
    PageType = CardPart;
    SourceTable = "Subscription Cue";
    ApplicationArea = All;
    Caption = 'Active Subscriptions';

    layout
    {
        area(content)
        {
            cuegroup(Subscriptions)
            {
                Caption = 'Subscriptions';

                field("Active Subscriptions"; Rec."Active Subscriptions")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Subscription List";

                    trigger OnDrillDown()
                    var
                        SubRec: Record Subscription;
                    begin
                        SubRec.SetRange(Status, SubRec.Status::Active);
                        PAGE.Run(PAGE::"Subscription List", SubRec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SUBS') then begin
            Rec.Init();
            Rec."Primary Key" := 'SUBS';
            Rec.Insert();
        end;
    end;
}
