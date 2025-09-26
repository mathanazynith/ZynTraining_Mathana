pageextension 50126 SalesCreditmemoCardExt extends "Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Begin Text Code"; Rec."Begin Text Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an End Text Code for this sales invoice.';
                trigger OnValidate()
                begin
                    Rec.Modify();
                    CopybegTextFromStandardText(Rec."Begin Text Code", Rec);
                end;
            }
        }

        addlast(Content)
        {
            part(Textd; "ZYN_Text Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("Begin Text Code ");
            }
        }
    }

    
    procedure CopybegTextFromStandardText(BeginTextCode: Code[20]; SalesHeader: Record "Sales Header")
    var
        StdText: Record "Extended Text Line";
        TargetText: Record "ZYN_Extended Table";
        Customer: Record Customer;
        HasCopiedLines: Boolean;
    begin
        TargetText.SetRange("Document Type", SalesHeader."Document Type");
        TargetText.SetRange("Document No.", SalesHeader."No.");
        TargetText.SetRange("Text Code Type",TargetText."Text Code Type"::"Begin Text Code " );
        TargetText.DeleteAll();

        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        if SalesHeader."Language Code" = '' then
            exit;

        StdText.SetRange("No.", BeginTextCode);
        StdText.SetRange("Language Code", SalesHeader."Language Code");

        if StdText.FindSet() then begin
            HasCopiedLines := true;
            repeat
                TargetText.Init();
                TargetText."Document Type" := SalesHeader."Document Type";
                TargetText."Document No." := SalesHeader."No.";
                TargetText."Line No." := StdText."Line No.";
                TargetText.Text := StdText.Text;
                TargetText."Language code" := SalesHeader."Language Code";
                TargetText."Text Code Type" := "ZYN_Text Code Enum"::"Begin Text Code ";
                TargetText.Insert();
            until StdText.Next() = 0;
        end;
    end;
}
