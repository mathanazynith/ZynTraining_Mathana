pageextension 50101 "CompanyCardExt" extends "Companies"
{
    layout{}
    actions
    {
        addlast(Processing)
        {
            group("Custom Tools")
            {
                action(OpenUpdateFieldPage)
                {
                    Caption = 'Update Field';
                    ApplicationArea = All;
                    Image = Log;
                    trigger OnAction()
                    begin
                        RunModal(Page ::ZYN_updateFieldCard);
                    end;
                }
            }
        }
    }
}
