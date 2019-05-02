function n = my_numel(A)
    n = 0;
    for i=1:numel(A)
        if iscell(A{i})
            n = n + my_numel(A{i});
        else
            n = n + numel(A{i});
        end
    end
end

