page 80135 "Select PR Consignment Line"
{
    ApplicationArea = All;
    Caption = 'Select PR Consignment Line';
    PageType = Worksheet;
    SourceTable = "PR Consignment Line";
    UsageCategory = None;
    InsertAllowed = FALSE;
    ModifyAllowed = FALSE;
    DeleteAllowed = FALSE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    Editable = false;
                }
                field("Material Req. No."; Rec."Material Req. No.")
                {
                    Editable = false;
                }
                field("BPB No."; Rec."BPB No.")
                {
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
    end;

    var
        gCodePRNo: Code[50];
        gBolNeedIN: Boolean;
}
