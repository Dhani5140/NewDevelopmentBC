page 60115 "Vendor Selection List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Vendor Selection';
    CardPageId = "Vendor Selection Header";
    Editable = false;
    PageType = List;
    SourceTable = "Vendor Selection Header";
    RefreshOnActivate = true;
    Permissions = TableData "Vendor Selection Header" = rimd;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Tanggal IN"; Rec."Tanggal IN")
                {
                    ApplicationArea = all;
                }

                field("Nomor PPB"; Rec."Nomor PPB")
                {
                    ApplicationArea = all;
                    Caption = 'No RFQ';
                }

                field(Peruntukan; Rec.Peruntukan)
                {
                    ApplicationArea = All;
                    Caption = 'Peruntukan';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
            }

        }
    }

    actions
    {

    }


}