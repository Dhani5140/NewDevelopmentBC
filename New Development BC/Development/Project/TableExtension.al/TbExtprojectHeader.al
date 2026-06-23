tableextension 70100 MIITbExtJob extends Job
{
    fields
    {
        field(70001; "project type"; Option)
        {
            OptionMembers = "Internal","External";
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