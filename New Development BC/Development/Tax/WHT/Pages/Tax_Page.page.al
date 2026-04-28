page 51110 "Tax Setup3"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    sourceTable = "Tax Setup2";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("WHT Code"; rec."WHT Code")
                { }
                field("WHT Description"; rec."WHT Description") { }
                field("WHT Percent"; rec."WHT Percent") { }
                field("WHT Payable Account"; rec."WHT Payable Account") { }
                field("Expense Account"; rec."Expense Account") { }
            }
        }
    }
}
