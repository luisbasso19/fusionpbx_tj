api = freeswitch.API()

campon = event:getHeader("variable_campon");
call_uuid = event:getHeader("variable_call_uuid");
uuid = event:getHeader("variable_uuid");
destination_number = event:getHeader("Caller-Destination-Number")
domain_name = event:getHeader("Caller-Context")
signal_bond = event:getHeader("variable_signal_bond")
endpoint_disposition = event:getHeader("variable_endpoint_disposition")

--if campon == "true" then
	---USADO APENAS PARA DEBUG
	freeswitch.consoleLog("notice", "Create_evento campon no atendimento.: ".. tostring(uuid).." "  .. tostring(campon) .. "\n");
	freeswitch.consoleLog("notice", "Create_evento call_uuid no atendimento.: " .. tostring(uuid).." " .. tostring(call_uuid) .. "\n");
	freeswitch.consoleLog("notice", "Create_evento uuid no atendimento.: " .. tostring(uuid) .. "\n");
	freeswitch.consoleLog("notice", "Create_evento destination_number no atendimento.: " .. tostring(uuid) .." " .. tostring(destination_number) .. "\n");
	freeswitch.consoleLog("notice", "Create_evento variavel signal_bond no atendimento.: " .. tostring(uuid) .." " .. tostring(signal_bond) .. "\n");
	freeswitch.consoleLog("notice", "Create_evento variavel endpoint_disposition no atendimento.: ".. tostring(uuid) .." " .. tostring(endpoint_disposition) .. "\n");


       freeswitch.consoleLog("notice", "Create_evento " .. tostring(destination_number) .. " " .. tostring(uuid).."\n");
if string.find(destination_number, "6725") then
        dump = api:execute("uuid_dump", uuid)

        --if session:ready() then
                freeswitch.consoleLog("notice", "Create_evento ".. tostring(destination_number) .." " .. tostring(dump));
        --      session:consoleLog("notice", "Atendimento" .. tostring(dump) .. "\n")
        --end
end     





	--dump = api:execute("uuid_dump", uuid)
        --if session:ready() then
        --        freeswitch.consoleLog("notice", "Atendimento variavel dump no atendimento.: ".. tostring(uuid) .." " .. tostring(dump) .. "\n");
        --      session:consoleLog("notice", "Atendimento" .. tostring(dump) .. "\n")
        --end

	

	---
	--[[	
	local mapping = api:execute("memcache", "get campon:map:"..uuid)
	if mapping == "" then return end
	local tag, id = mapping:match("^(.-)|(%d+)$")
	if tag and id then
		  api:execute("memcache", "delete campon:"..tag..":item:"..id)
	end
	api:execute("memcache", "delete campon:map:"..uuid)
	api:execute("memcache", "delete campon:seen:"..uuid)
	--]]
	
--end


