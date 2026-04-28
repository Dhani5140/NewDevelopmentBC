pageextension 50116 EMP extends "Employee Card"
{
    layout
    {
        addafter("Company E-Mail")
        {
            field("Sign In"; Rec."Sign In")
            {
                ApplicationArea = basic, suite;
                Caption = 'Sign In';
            }
        }
    }
}