pageextension 80010 prodorder extends "Prod. Order Routing"
{
    layout
    {
        addafter("Operation No.")
        {
            field("Overhead Rate"; Rec."Overhead Rate")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Indirect Cost %"; Rec."Indirect Cost %")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

}