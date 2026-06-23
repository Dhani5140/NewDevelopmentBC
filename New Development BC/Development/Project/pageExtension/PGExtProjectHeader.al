pageextension 70010 MIIProject extends "Job Card"
{
    layout
    {
        modify("Sell-to")
        {
            Visible = false;
        }
        modify("Bill-to")
        {
            Visible = false;
        }
        modify("Ship-to")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            Visible = isinternal;
        }
        modify("Sell-to Customer No.")
        {
            Visible = isinternal;
        }
        addafter(Description)
        {
            field("project type"; Rec."project type")
            {
                ApplicationArea = all;
                Editable = true;
                Caption = 'Project Type';
                trigger OnValidate()
                begin
                    if Rec."project type" = Rec."project type"::internal then begin
                        Clear(Rec."Sell-to Customer Name");
                        Clear(Rec."Sell-to Customer No.");
                    end;

                    SetVisibility();
                    CurrPage.Update();
                end;
            }
        }
    }

    actions
    {
        addlast(Action26)
        {
            action(OpenGantt)
            {
                Caption = 'Visual Scheduler';
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = All;

                trigger OnAction()
                var
                    GanttPage: Page "Visual Job Scheduler";
                begin
                    GanttPage.SetJob(Rec."No.");
                    GanttPage.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        SetVisibility();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetVisibility();
    end;

    procedure SetVisibility()
    begin
        isinternal := Rec."project type" <> Rec."project type"::internal;
    end;

    var
        isinternal: Boolean;
}

