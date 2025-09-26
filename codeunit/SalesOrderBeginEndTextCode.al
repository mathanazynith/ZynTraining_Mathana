codeunit 50131 "ZYN_PostedBeginningTextHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(
        var SalesHeader: Record "Sales Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SalesShptHdrNo: Code[20];
        RetRcpHdrNo: Code[20];
        SalesInvHdrNo: Code[20];
        SalesCrMemoHdrNo: Code[20];
        CommitIsSuppressed: Boolean;
        InvtPickPutaway: Boolean;
        var CustLedgerEntry: Record "Cust. Ledger Entry";
        WhseShip: Boolean;
        WhseReceiv: Boolean;
        PreviewMode: Boolean)
    var
        PostedSalesInvoice: Record "Sales Invoice Header";
        PostedDisp: Record "Standard Text";
    begin
        if SalesInvHdrNo <> '' then begin
            if PostedSalesInvoice.Get(SalesInvHdrNo) then
                
                CopyInvoiceTextToPosted(SalesHeader, PostedSalesInvoice);
 
            ClearUnpostedBeginningText(SalesHeader);
        end;
    end;
 
    local procedure CopyEditedBeginningTextToPosted(SalesHeader: Record "Sales Header"; PostedInvoice: Record "Sales Invoice Header")
    var
        SourceBuffer: Record "ZYN_Extended Table";
        TargetBuffer: Record "ZYN_Extended Table";
        NewLineNo: Integer;
        Customer:Record Customer;
        Textcode: Enum "ZYN_Text Code Enum";
    begin
        
        Textcode := Textcode::"Begin Text Code ";
        repeat
            SourceBuffer.Reset();
            SourceBuffer.SetRange("Document No.", SalesHeader."No.");
            SourceBuffer.SetRange("Text Code Type", TextCode );
 
            if SourceBuffer.FindSet() then begin
                repeat
                    NewLineNo := GetNextLineNo(TargetBuffer, PostedInvoice."No.", PostedInvoice."Sell-to Customer No.", Textcode);
                    TargetBuffer.Init();
                    TargetBuffer."Document No." := PostedInvoice."No.";
                    TargetBuffer."Line No." := NewLineNo;
                    TargetBuffer."Language code" := SourceBuffer."Language code";
                    TargetBuffer."Text Code Type" := SourceBuffer."Text Code Type";
                    TargetBuffer."Description" := SourceBuffer.Description;
                    TargetBuffer.Text := SourceBuffer.Text;
                    TargetBuffer.Insert(true);
                until SourceBuffer.Next() = 0;
            end;
            if Textcode = Textcode::"Begin Text Code " then
                Textcode := Textcode::"End Text Code"
            else
                exit; 
 
        until false;
    end;
 
    local procedure ClearUnpostedBeginningText(SalesHeader: Record "Sales Header")
    var
        SourceBuffer: Record "ZYN_Extended Table";
    begin
        SourceBuffer.SetRange("Document No.", SalesHeader."No.");
        SourceBuffer.SetRange("customer no", SalesHeader."Sell-to Customer No.");
        SourceBuffer.DeleteAll();
    end;
 
    local procedure GetNextLineNo(Buffer: Record "ZYN_Extended Table"; DocNo: Code[20]; CustNo: Code[20]; Sel: Enum "ZYN_Text Code Enum"): Integer
    var
        MaxLineNo: Integer;
    begin
        Buffer.Reset();
        Buffer.SetRange("Document No.", DocNo);
        Buffer.SetRange("Customer no", CustNo);
        Buffer.SetRange("Text Code Type", Sel);
        if Buffer.FindLast() then
            MaxLineNo := Buffer."Line No.";
        exit(MaxLineNo + 10000);
    end;
 
    local procedure CopyInvoiceTextToPosted(SalesHeader: Record "Sales Header"; PostedInvoice: Record "Sales Invoice Header")
    var
        StdText: Record "Extended Text Line";
        Buffer: Record "ZYN_Extended Table";
        Customer: Record Customer;
        NewLineNo: Integer;
        SelectionType: Enum "ZYN_Text Code Enum";
    begin
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;
 
        if SalesHeader."Begin invoice" <> '' then begin
            StdText.SetRange("No.", SalesHeader."Begin invoice");
            StdText.SetRange("Language Code", Customer."Language Code");
 
            SelectionType := SelectionType::"Begin Text Code ";
            if StdText.FindSet() then
                repeat
                    Buffer.Init();
                    Buffer."Text Code Type" := SelectionType;
                    Buffer."Document No." := PostedInvoice."No.";
                    Buffer."customer no" := PostedInvoice."Sell-to Customer No.";
                
                    Buffer."Language code" := Customer."Language Code";
                    Buffer.Description := SalesHeader."Begin invoice";
                    Buffer.Text := StdText."Text";
                    Buffer."Line No." := GetNextLineNo(Buffer, Buffer."Document No.", Buffer."customer no", Buffer."Text Code Type");
                    Buffer.Insert(true);
                until StdText.Next() = 0;
        end;
        if SalesHeader."End invoice" <> '' then begin
            StdText.Reset();
            StdText.SetRange("No.", SalesHeader."End invoice");
            StdText.SetRange("Language Code", Customer."Language Code");
            SelectionType := SelectionType::"End Text Code";
            if StdText.FindSet() then
                repeat
                    Buffer.Init();
                    Buffer."Text Code Type":= SelectionType;
                    Buffer."Document No." := PostedInvoice."No.";
                    Buffer."customer no" := PostedInvoice."Sell-to Customer No.";
                    Buffer."Language code" := Customer."Language Code";
                    Buffer.Description := SalesHeader."End invoice";
                    Buffer.Text := StdText."Text";
                    Buffer."Line No." := GetNextLineNo(Buffer, Buffer."Document No.", Buffer."customer no", Buffer."Text Code Type");
                    Buffer.Insert(true);
                until StdText.Next() = 0;
        end;
    end;
 
 
}
 