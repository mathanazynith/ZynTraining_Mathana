// codeunit 50273 "ZYN_Synching."
// {
//     var
//         SkipSyncList: Dictionary of [Guid, Boolean];

//     procedure MarkSkipSync(var Rec: Record "ZYN_CustomCompany")
//     begin
//         SkipSyncList.Set(Rec.Id, true);
//     end;

//     procedure ShouldSkipSync(var Rec: Record "ZYN_CustomCompany"): Boolean
//     var
//         Exists: Boolean;
//         Value: Boolean;
//     begin
//         if SkipSyncList.ContainsKey(Rec.Id) then begin
//             Value := SkipSyncList.Get(Rec.Id, Exists);
//             SkipSyncList.Remove(Rec.Id); // Remove after first check
//             exit(Value);
//         end;
//         exit(false);
//     end;
// }
