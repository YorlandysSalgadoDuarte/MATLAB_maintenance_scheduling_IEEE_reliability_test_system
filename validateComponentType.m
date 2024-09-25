function validateComponentType(componentType)
    % List of valid component types
    validTypes = ["Wind", "OilSteam", "OilCT", "Hydro", "CoalSteam", "Nuclear"];    
    % Check if componentType is a string and one of the valid types
    if ~ischar(componentType) && ~isstring(componentType)
        error('componentType must be a string.');
    elseif ~ismember(componentType, validTypes)
        error('componentType is not a valid type. Valid types are: %s', strjoin(validTypes, ', '));
    end
end