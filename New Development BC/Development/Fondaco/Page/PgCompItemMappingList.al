page 70003 PgCompItemMapping
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = TblCompItemMapping;
    Caption = 'Customer Complimentary Item Mapping';


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(CustCode; Rec.CustCode)
                {
                    ApplicationArea = All;

                }
                field("Comp Group Id"; Rec.CompGroupId)
                {
                    ApplicationArea = All;
                    TableRelation = TblCompItemSetup.CompGroupId WHERE(CompAllCustomer = FILTER(= 0));
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        //TblCompItemSetup.CompGroupId WHERE(CompAllCustomer = FILTER(= 0));
                    end;


                }

                field(Description; Rec.CompMappingDesc)
                {
                    ApplicationArea = All;

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