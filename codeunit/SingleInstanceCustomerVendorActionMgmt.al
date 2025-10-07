codeunit 50285 "ZYN_CustomerVendorActContMgmt"
{
    SingleInstance = true;

    var
        FromCreateAs: Boolean;

    internal procedure SetFromCreateAs()
    begin
        FromCreateAs := true;
    end;

    internal procedure GetFromCreateAs(): Boolean
    begin
        exit(FromCreateAs);
    end;

    internal procedure ClearFromCreateAs()
    begin
        FromCreateAs := false;
    end;
}
