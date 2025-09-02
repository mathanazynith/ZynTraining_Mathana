page 50172 "Leave Request List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Leave Request";
    UsageCategory = Lists;
    Caption = 'Leave Requests';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("RequestId"; Rec."RequestId") { ApplicationArea = All; }
                field("Employee"; Rec."Employee") { ApplicationArea = All; }
                field("Leave Category"; Rec."Leave Category") { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    LeaveRequest: Record "Leave Request";
                    Hidden: Record "Hidden Table";
                    DaysRequested: Integer;
                begin
                    CurrPage.SetSelectionFilter(LeaveRequest);

                    if LeaveRequest.FindSet() then
                        repeat
                            
                            if LeaveRequest.Status = LeaveRequest.Status::Rejected then
                                Error('Request %1 is already Rejected and cannot be approved.', LeaveRequest."RequestId");

                            
                            if LeaveRequest.Status <> LeaveRequest.Status::Pending then
                                Error('Only Pending requests can be approved. Request %1 current status: %2',
                                      LeaveRequest."RequestId", LeaveRequest.Status);

                           
                            DaysRequested := 0;
                            if (LeaveRequest."Start Date" <> 0D) and (LeaveRequest."End Date" <> 0D) then
                                DaysRequested := LeaveRequest."End Date" - LeaveRequest."Start Date" + 1;

                           
                            Hidden.Reset();
                            Hidden.SetRange("Employee Id", LeaveRequest."Employee");
                            Hidden.SetRange("Category Name", LeaveRequest."Leave Category");

                            if not Hidden.FindFirst() then
                                Error('No Hidden Table entry found for Employee %1 and Category %2.',
                                      LeaveRequest."Employee", LeaveRequest."Leave Category");

                            Hidden.CalcFields("Days Allotted", "Leaves Taken");
                            if DaysRequested > Hidden."Remaining Leaves" then
                                Error('Insufficient leave balance for Request %1: requested %2 days but only %3 remaining.',
                                      LeaveRequest."RequestId", DaysRequested, Hidden."Remaining Leaves");

                           
                            LeaveRequest.Status := LeaveRequest.Status::Approved;
                            LeaveRequest.Modify(true);

                            Hidden."Remaining Leaves" := Hidden."Remaining Leaves" - DaysRequested;
                            if Hidden."Remaining Leaves" < 0 then
                                Hidden."Remaining Leaves" := 0;
                            Hidden.Modify(true);

                        until LeaveRequest.Next() = 0;

                    Message('Selected leave requests have been approved.');
                end;
                
            }

            action(Reject)
            {
                Caption = 'Reject';
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                var
                    LeaveRequest: Record "Leave Request";
                begin
                    CurrPage.SetSelectionFilter(LeaveRequest);

                    if LeaveRequest.FindSet() then
                        repeat
                            
                            if LeaveRequest.Status = LeaveRequest.Status::Approved then
                                Error('Approved requests cannot be rejected. Request %1 is already Approved.',
                                      LeaveRequest."RequestId");

                            if LeaveRequest.Status = LeaveRequest.Status::Rejected then
                                Error('Request %1 is already Rejected.', LeaveRequest."RequestId");

                           
                            if LeaveRequest.Status = LeaveRequest.Status::Pending then begin
                                LeaveRequest.Status := LeaveRequest.Status::Rejected;
                                LeaveRequest.Modify(true);
                            end;

                        until LeaveRequest.Next() = 0;

                    Message('Selected leave requests have been rejected.');
                end;
            }
        }
    }
}
