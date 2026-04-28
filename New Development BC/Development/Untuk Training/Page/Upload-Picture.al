pageextension 50110 "Item Card Picture Extension" extends "Item Card"
{
    actions
    {
        addfirst(Processing)
        {
            action(ImportItemPicture)
            {
                Caption = 'Import Item Picture';
                ApplicationArea = All;
                Image = Import;
                ToolTip = 'Import Item Picture';

                trigger OnAction()
                var
                    ImageManagement: Codeunit "Image Management";
                begin
                    ImageManagement.ImportItemPicture(Rec); // Memanggil prosedur ImportItemPicture
                end;
            }
        }
    }
}