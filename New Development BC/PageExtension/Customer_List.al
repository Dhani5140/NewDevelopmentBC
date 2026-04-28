pageextension 53333 customerlIST extends "Customer List"
{

    actions
    {
        addfirst(Reports)
        {
            action(PrintReport)
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;
                trigger OnAction()
                begin
                    Rec.SetRange("No.", Rec."No.");
                    report.run(52225, true, false, Rec);
                end;
            }


        }
    }

    var
        myInt: Integer;
}