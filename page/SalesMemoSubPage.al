page 50103 "Customer Sales Credit Memos"
{
    PageType = ListPart;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const("Credit Memo")); 
    Caption = 'Sales Credit Memos';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    SalesCreditMemoPage: Page "Sales Credit Memo";
                begin
                SalesCreditMemoPage.SetRecord(rec);
                SalesCreditMemoPage.run();
                end;
                }
                }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Amount"; Rec.Amount) { ApplicationArea = All; }
            }
        }
    }

    

