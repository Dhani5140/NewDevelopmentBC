page 51113 "WHT Buss Posting Group"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'WHT Business Posting Group';
    UsageCategory = Lists;
    SourceTable = "WHT Buss Posting Group";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Setup';
                Image = Setup;
                RunObject = Page "WHT Posting Setup";
                RunPageLink = "WHT Business Posting Group" = field(Code);
                ToolTip = 'View or edit the withholding tax (WHT) posting setup information. This includes posting groups, revenue types, and accounts.';

            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref("&Setup_Promoted"; "&Setup")
                {

                }
            }
        }
    }
}