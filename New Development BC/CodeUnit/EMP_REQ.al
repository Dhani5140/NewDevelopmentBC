codeunit 50130 req_dept
{
    procedure GetWarehouseEmployeeLocationFilter2(UserName: code[50]): Text
    var
        WarehouseEmployee: Record Employee_Req;
        [SecurityFiltering(SecurityFilter::Filtered)]
        Location: Record "Request Dept";
        AssignedLocations: List of [code[20]];
        WhseEmplLocationBuffer: Codeunit EMP_REQlOC;
        Filterstring: Text;
        LocationAllowed: Boolean;
        FilterTooLong: Boolean;
        HasLocationSubscribers: Boolean;
    begin
        // buffered?
        Filterstring := WhseEmplLocationBuffer.GetWarehouseEmployeeLocationFilter();
        if Filterstring <> '' then
            exit(Filterstring);
        Filterstring := StrSubstNo('%1', ''''''); // All users can see the blank location
        if UserName = '' then
            exit(Filterstring);
        WarehouseEmployee.SetRange("User ID", UserName);
        WarehouseEmployee.SetFilter("Request Dept", '<>%1', '');
        IF WarehouseEmployee.Count > 1000 then  // if more, later filter length will exceed allowed length and it will use all values anyway
            exit(''); // can't filter to that many locations. Then remove filter
        IF WarehouseEmployee.FindSet() then
            REPEAT
                AssignedLocations.Add(WarehouseEmployee."Request Dept");
                LocationAllowed := true;
                OnBeforeLocationIsAllowed(WarehouseEmployee."Request Dept", LocationAllowed);
                if LocationAllowed then
                    Filterstring += '|' + StrSubstNo('''%1''', ConvertStr(WarehouseEmployee."Request Dept", '''', '*'));
            UNTIL WarehouseEmployee.Next() = 0;
        if WhseEmplLocationBuffer.NeedToCheckLocationSubscribers() then
            if Location.FindSet() then
                repeat
                    if not AssignedLocations.Contains(Location.Code) then begin
                        LocationAllowed := false;
                        OnBeforeLocationIsAllowed(Location.Code, LocationAllowed);
                        if LocationAllowed then begin
                            Filterstring += '|' + StrSubstNo('''%1''', ConvertStr(Location.Code, '''', '*'));
                            FilterTooLong := StrLen(Filterstring) > 2000; // platform limitation on length
                            HasLocationSubscribers := true;
                        end;
                    end;
                until (location.Next() = 0) or FilterTooLong;
        WhseEmplLocationBuffer.SetHasLocationSubscribers(HasLocationSubscribers);
        if FilterTooLong then
            Filterstring := '*';
        WhseEmplLocationBuffer.SetWarehouseEmployeeLocationFilter(Filterstring);
        exit(Filterstring);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLocationIsAllowed(RequestDept: Code[10]; var LocationAllowed: Boolean)
    begin
    end;
}