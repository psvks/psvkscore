local state = {}

-- Initialize the state with a given file
function state:init(stateFile)
    local initial = {}
    initial.file = stateFile

    -- Load existing state from file
    local file = fs.open(stateFile, "r")
    if file then
        local content = file.readAll()
        file.close()

        for line in string.gmatch(content, "[^\r\n]+") do
            -- Using \t as separator instead of space
            local key, value = string.match(line, "([^\t]+)\t(.+)")
            if key and value then
                initial[key] = value
            end
        end
    end

    -- Define functions for manipulating the state
    function initial:GetKey(key)
        return self[key]
    end

    function initial:SetKey(key, value)
        -- Ensure key and value are strings
        if type(key) == "string" and type(value) == "string" then
            self[key] = value
            self:Save()
        else
            error("Both key and value must be strings")
        end
    end

    function initial:RemoveKey(key)
        if type(key) == "string" then
            self[key] = nil
            self:Save()
        else
            error("Key must be a string")
        end
    end

    function initial:Save()
        local file = fs.open(self.file, "w")
        if file then
            for key, value in pairs(self) do
                if type(key) == "string" and type(value) == "string" and key ~= "file" then
                    file.write(key .. "\t" .. value .. "\n")
                end
            end
            file.close()
        else
            error("Unable to open file for writing: " .. self.file)
        end
    end

    return initial
end

return state
