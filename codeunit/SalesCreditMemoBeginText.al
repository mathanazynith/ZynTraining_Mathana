codeunit 50143 "ZYN_Sales Credit memo Posting "           
{
    Permissions = tabledata "Sales Cr.Memo Header" = rimd;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfteSalesCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        ExtTextSrc: Record "ZYN_Extended Table"; 
        ExtTextDest: Record "ZYN_Extended Table"; 
        LineNo: Integer;
    begin
        
        ExtTextSrc.SetRange("Document Type", SalesHeader."Document Type");
        ExtTextSrc.SetRange("Document No.", SalesHeader."No.");
        SalesCrMemoHeader.Get(SalesCrMemoHeader."No.");
        SalesCrMemoHeader."Begin Text Code" := SalesHeader."Begin Text Code";
        SalesCrMemoHeader.Modify();

        LineNo := 0;

        if ExtTextSrc.FindSet() then begin
            repeat
                LineNo += 1;
                ExtTextDest.Init();
                ExtTextDest.TransferFields(ExtTextSrc); 
                ExtTextDest."Document Type" := ExtTextDest."Document Type"::"Posted Sales Credit Memo"; 
                ExtTextDest."Line No." := LineNo;
                ExtTextDest.SetRange("Text Code Type", "ZYN_Text Code Enum":: "Begin Text Code "); 
                ExtTextDest.Insert();
            until ExtTextSrc.Next() = 0;
            ExtTextSrc.DeleteAll();
        end;
    end;
}