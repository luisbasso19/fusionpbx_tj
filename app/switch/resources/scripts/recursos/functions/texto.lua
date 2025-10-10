function split (inputstr, sep)
        if (sep == nil) then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end

        return t
end

function parse_contact (unparsed)
        local args = {}
        valor = split(unparsed, "=")
        if valor[1] ~= nil and valor[2] ~= nil then
                args[valor[1]] = valor[2]
        end
        return args
end

