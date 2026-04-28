pageextension 50101 MIICLE extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Customer)
        {
            action("Print CSV")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                var
                    CsvGenerate: Codeunit CsvGenerate;
                begin
                    CsvGenerate.generatafile(Rec);
                end;
            }
        }
    }


    var
        myInt: Integer;
}