tableextension 50115 SalesInvoiceExt extends "Sales Header"
{
    fields
    {
        field(50118; "Begin Text Code"; Code[20])
        {
            Caption = 'Begin Text Code';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
            trigger OnValidate()
                begin
                    Rec.Modify();
                    CopyFromStandardText(Rec."Begin Text Code", Rec);
                end;
          
        }
        field(50126; "End Text Code"; Code[20])
        {
            Caption = 'End Text Code';
            DataClassification = ToBeClassified;       
            TableRelation = "Standard Text";
            
            trigger OnValidate()
                begin
                    Rec.Modify();
                    CopyEndTextFromStandardText(Rec."end Text Code", Rec);
                end;
        }
        field(50127; "Begin invoice"; Code[20])
        {
            Caption = 'Begin invoice';
            DataClassification = ToBeClassified;       
            TableRelation = "Standard Text";

        }
        field(50128; "End invoice"; Code[20])
        {
            Caption = 'End invoice';
            DataClassification = ToBeClassified;       
            TableRelation = "Standard Text";
              
           
        }

    }



procedure CopyFromStandardText(BeginTextCode: Code[20]; SalesHeader: Record "Sales Header")
    var
        StdText: Record "Extended Text Line";
        TargetText: Record "Extended Table";
        Customer: Record Customer;
        HasCopiedLines: Boolean;
    begin
        TargetText.SetRange("Document Type", SalesHeader."Document Type");
        TargetText.SetRange("Document No.", SalesHeader."No.");
        TargetText.SetRange("Text Code Type",TargetText."Text Code Type"::"Begin Text Code ");
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
                TargetText."Language Code" := SalesHeader."Language Code";
                TargetText."Text Code Type" := "Text Code Enum":: "Begin Text Code ";
                TargetText.Insert();
            until StdText.Next() = 0;
        end;
    end;



    procedure CopyEndTextFromStandardText(EndTextCode: Code[20]; SalesHeader: Record "Sales Header")
    var
        StdText: Record "Extended Text Line";
        TargetText: Record "Extended Table";
        Customer: Record Customer;
        HasCopiedLines: Boolean;
    begin
        TargetText.SetRange("Document Type", SalesHeader."Document Type");
        TargetText.SetRange("Document No.", SalesHeader."No.");
        TargetText.SetRange("Text Code Type",TargetText."Text Code Type"::"End Text Code" );
        TargetText.DeleteAll();

        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        if SalesHeader."Language Code" = '' then
            exit;

        StdText.SetRange("No.", EndTextCode);
        StdText.SetRange("Language Code", SalesHeader."Language Code");

        if StdText.FindSet() then begin
            HasCopiedLines := true;
            repeat
                TargetText.Init();
                TargetText."Document Type" := SalesHeader."Document Type";
                TargetText."Document No." := SalesHeader."No.";
                TargetText."Line No." := StdText."Line No.";
                TargetText.Text := StdText.Text;
                TargetText."Language Code" := SalesHeader."Language Code";
                TargetText."Text Code Type" := "Text Code Enum"::"End Text Code";
                TargetText.Insert();
            until StdText.Next() = 0;
        end;
    end;
    trigger OnAfterDelete()
    var
        ExtText: Record "Extended Table";
    begin
       
        ExtText.SetRange("Document Type", Rec."Document Type");
        ExtText.SetRange("Document No.", Rec."No.");

        if ExtText.FindSet() then
            ExtText.DeleteAll();
    end;

}
