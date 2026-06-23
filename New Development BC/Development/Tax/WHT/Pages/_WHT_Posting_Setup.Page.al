page 51114 "WHT Posting Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WHT Posting Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
                {
                    ApplicationArea = All;

                }
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }

                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = ALL;
                }
                field("Prepaid WHT Account Code"; Rec."Prepaid WHT Account Code")
                {
                    ApplicationArea = ALL;
                }
                field("Payable WHT Account Code"; Rec."Payable WHT Account Code")
                {
                    ApplicationArea = ALL;
                }
                field("Receivable WHT Account Code"; Rec."Receivable WHT Account Code")
                {
                    ApplicationArea = ALL;
                }
                // field("WHT Report"; Rec."WHT Report")
                // {
                //     ApplicationArea = ALL;
                // }
                // field("WHT Report Line No. Series"; Rec."WHT Report Line No. Series")
                // {
                //     ApplicationArea = ALL;
                // }
                // field("Revenue Type"; Rec."Revenue Type")
                // {
                //     ApplicationArea = all;
                // }

                // field("Bal. Prepaid Account Type"; Rec."Bal. Prepaid Account Type")
                // {
                //     ApplicationArea = all;
                // }
                // field("Bal. Prepaid Account No."; Rec."Bal. Prepaid Account No.")
                // {
                //     ApplicationArea = all;
                // }
                // field("Bal. Payable Account No."; Rec."Bal. Payable Account No.")
                // {
                //     ApplicationArea = all;
                // }
                // field("Bal. Payable Account Type"; Rec."Bal. Payable Account Type")
                // {
                //     ApplicationArea = all;
                // }
                // field("Sales WHT Adj. Account No."; Rec."Sales WHT Adj. Account No.")
                // {
                //     ApplicationArea = all;
                // }
                // field("Realized WHT Type"; Rec."Realized WHT Type")
                // {
                //     ApplicationArea = all;
                // }
                // field("WHT Minimum Invoice Amount"; Rec."WHT Minimum Invoice Amount")
                // {
                //     ApplicationArea = ALL;
                // }
                // field("WHT Calculation Rule"; Rec."WHT Calculation Rule")
                // {
                //     ApplicationArea = ALL;
                // }
                // field(Sequence; Rec.Sequence)
                // {
                //     ApplicationArea = ALL;
                // }
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}