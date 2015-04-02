
for object = PockelsCell.getComponentArray()
    interference = object.checkInterference();
    if(~isempty(interference(1)))
        display('Oh no! Interference!')
    end
end