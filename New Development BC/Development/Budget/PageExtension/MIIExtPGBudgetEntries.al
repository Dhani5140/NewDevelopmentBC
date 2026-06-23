pageextension 60102 Budget extends Budget
{
    layout
    {
        addafter(ShowColumnName)
        {
            field(status; status)
            {
                ApplicationArea = all;
            }
        }
    }

    var
        status: Enum StatusBR;
}