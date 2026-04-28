
page 60119 GetppbLine2
{
    PageType = Worksheet;
    Caption = 'Get PPB Line';
    ApplicationArea = All;
    Editable = false;
    SourceTable = PPBLine;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Part Number"; Rec."Part Number")
                {
                    ApplicationArea = all;
                }


                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }


            }

        }
    }
    trigger OnOpenPage()
    begin
    end;

}