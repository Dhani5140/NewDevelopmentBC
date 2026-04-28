page 70005 PgCompItemSetupList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = TblCompItemSetup;
    Caption = 'Complimentary Item Setup';


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Comp Group Id"; Rec.CompGroupId)
                {
                    ApplicationArea = All;

                }

                field(Description; Rec.CompGroupDesc)
                {
                    ApplicationArea = All;

                }

                field("Main item"; Rec.CompMainItem)
                {
                    ApplicationArea = All;
                }

                field("Main item Qty"; Rec."Main Item Qty")
                {
                    ApplicationArea = All;
                }

                field("Complimentary Item"; Rec.ComplimentaryItem1)
                {
                    ApplicationArea = All;
                }

                field("Complimentary item Qty"; Rec."Complimentary Qty1")
                {
                    ApplicationArea = All;
                }

                field(Method; Rec.CompMethod)
                {
                    ApplicationArea = All;
                }

                field("All Customer"; Rec.CompAllCustomer)
                {
                    ApplicationArea = All;
                }

                field("Enabled"; Rec.CompActive)
                {
                    ApplicationArea = All;
                }
                field(CompBeginDate; Rec.CompBeginDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Begin Date';
                }

                field(CompEndingDate; Rec.CompEndingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}