tableextension 70015 salesLine extends "Sales Line"
{
    fields
    {
        field(50022; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Buss Posting Group";
            trigger OnValidate()
            begin
                // Debug untuk melihat nilai Business Posting Group
                Message('Selected WHT Business Posting Group: %1', "WHT Business Posting Group");

                // Reset Product Posting Group dan WHT % jika Business Posting Group berubah
                if xRec."WHT Business Posting Group" <> Rec."WHT Business Posting Group" then begin
                    "WHT Product Posting Group" := ''; // Kosongkan Product Posting Group
                    "WHT %" := 0; // Reset nilai WHT %
                    "WHT Amount" := 0;
                end;
            end;
        }
        field(50023; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group";
            trigger OnValidate()
            var
                WHTPostingSetup: Record "WHT Posting Setup";
            begin
                // Pastikan Business Posting Group sudah dipilih
                if ("WHT Business Posting Group" = '') then
                    Error('Please select a WHT Business Posting Group first.');

                // Validasi kombinasi dengan SetRange
                WHTPostingSetup.SetRange("WHT Business Posting Group", "WHT Business Posting Group");
                WHTPostingSetup.SetRange("WHT Product Posting Group", "WHT Product Posting Group");

                if WHTPostingSetup.FindFirst() then begin
                    "WHT %" := WHTPostingSetup."WHT %"; // Set nilai WHT %
                    "WHT Amount" := Round((Rec."Line Amount" * WHTPostingSetup."WHT %") / 100);
                end else
                    Error('Invalid combination of WHT Business Posting Group and WHT Product Posting Group. Check table data.');
            end;
        }
        field(50025; "WHT %"; Decimal)
        {
            TableRelation = "WHT Posting Setup"."WHT %";
        }
        field(50026; "WHT Amount"; Decimal)
        {
            //TableRelation = "WHT Posting Setup"."WHT %";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}