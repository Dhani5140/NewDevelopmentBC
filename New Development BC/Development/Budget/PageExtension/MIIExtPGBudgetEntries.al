pageextension 60102 Budget extends Budget
{
    layout
    {
        addafter(ShowColumnName)
        {
            field(status; status)
            {

            }
        }
    }

    var
        status: Enum StatusBR;
}