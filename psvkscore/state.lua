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
            local key, value = string.match(line, "([^%s]+)%s(.+)")
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
        self[key] = value
        self:Save()
    end

    function initial:RemoveKey(key)
        self[key] = nil
        self:Save()
    end

    function initial:Save()
        local file = fs.open(self.file, "w")
        for key, value in pairs(self) do
            if type(key) == "string" and type(value) == "string" and key ~= "file" then
                file.write(key .. " " .. value .. "\n")
            end
        end
        file.close()
    end

    return initial
end

return state
