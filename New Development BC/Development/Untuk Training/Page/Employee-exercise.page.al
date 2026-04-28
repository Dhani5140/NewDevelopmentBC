page 50124 EmployeeListPage
{
    PageType = List;
    SourceTable = EmployeeTable;
    ApplicationArea = All;
    Caption = 'Employee List';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the employee.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the employee.';
                }
                field("Position"; Rec.Position)
                {
                    ApplicationArea = All;
                    ToolTip = 'Position of the employee within the company.';
                }
                field("Department"; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Department where the employee works.';
                }
                field("Active"; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the employee is currently active.';
                    Editable = false;
                }
                field("Image Media"; Rec."Image Media")
                {
                    ApplicationArea = All;
                    ToolTip = 'Uploaded image of the employee.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SetActive)
            {
                ApplicationArea = All;
                Caption = 'Set as Active';
                ToolTip = 'Mark the employee as active.';

                trigger OnAction()
                begin
                    Rec.Active := true;
                    rec.Modify(true);
                    Message('Employee has been marked as active.');
                end;
            }
            action(nonActive)
            {
                ApplicationArea = All;
                Caption = 'Non Active';
                ToolTip = 'Mark the employee as active.';

                trigger OnAction()
                begin
                    Rec.Active := false;
                    rec.Modify(true);
                    Message('Employee has been marked as active.');
                end;
            }
        }
    }
}
