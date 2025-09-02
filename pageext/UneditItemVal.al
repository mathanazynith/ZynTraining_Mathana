pageextension 50130 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Last Sold Price"; LastSoldPriceValue)
            {
                ApplicationArea = All;
                Caption = 'Last Sold Price';
                Editable = false;
            }
        }
    }

    var
        LastSoldPriceValue: Decimal;

    trigger OnAfterGetRecord()
    var
        LastSoldPrice: Record "Last Sold Price";
        Lastdate: Date;
        maxPrice: Decimal;
    begin
        Clear(LastSoldPriceValue);
        if (Rec."Sell-to Customer No." <> '') then begin
            LastSoldPrice.Reset();
            LastSoldPrice.SetCurrentKey("Posting Date");
            LastSoldPrice.SetRange("Customer No.", Rec."Sell-to Customer No.");
            if LastSoldPrice.FindLast() then
                Lastdate:=LastSoldPrice."Posting Date";
                LastSoldPrice.Reset();
            LastSoldPrice.SetRange("Customer No.", Rec."Sell-to Customer No.");
            LastSoldPrice.SetRange("Posting Date", LastDate);
            maxPrice := 0;
            if LastSoldPrice.FindSet() then
                repeat
                    if LastSoldPrice."Item Price" > maxPrice then
                        maxPrice := LastSoldPrice."Item Price";
                until LastSoldPrice.Next() = 0;
            LastSoldPriceValue:= maxPrice;
 
        end;
    end;
}
