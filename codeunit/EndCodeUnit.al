codeunit 50147 "End Invoice Posting"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        ExtTextSrc: Record "Extended Table"; 
        ExtTextDest: Record "Extended Table"; 
        LineNo: Integer;
    begin
        
        ExtTextSrc.SetRange("Document Type", SalesHeader."Document Type");
        
        ExtTextSrc.SetRange("Document No.", SalesHeader."No.");

        LineNo := 0;

        if ExtTextSrc.FindSet() then begin
            repeat
                LineNo += 1;
                ExtTextDest.Init();
                ExtTextDest.TransferFields(ExtTextSrc); 
                ExtTextDest."Document Type" := ExtTextDest."Document Type"::"Posted Sales Invoice";
                ExtTextDest."Document No." := SalesInvHdrNo; 
                ExtTextDest."Line No." := LineNo;
                ExtTextDest.SetRange("Text Code Type", "Text Code Enum":: "End Text Code" ); 
                ExtTextDest.Insert();
            until ExtTextSrc.Next() = 0;

           
            ExtTextSrc.DeleteAll();
        end;
    end;
}