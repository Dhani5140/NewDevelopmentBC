table 50123 EmployeeTable
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Employee ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee ID';
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee Name';
        }
        field(3; "Position"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Position';
        }
        field(4; "Department"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Department';
        }
        field(5; "Active"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Active';
            ToolTip = 'Indicates if the employee is currently active.';
        }
        field(6; "Image Blob"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Memo;
        }
        field(7; "Image Media"; Media)
        {
            DataClassification = ToBeClassified;
            Caption = 'Image File';
        }
    }
    keys
    {
        key(PK; "Employee ID")
        {
            Clustered = true;
        }
    }

}