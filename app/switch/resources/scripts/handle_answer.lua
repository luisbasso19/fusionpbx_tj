api = freeswitch.API()

campon = event:getHeader("variable_campon");
call_uuid = event:getHeader("variable_call_uuid");
uuid = event:getHeader("variable_uuid");
destination_number = event:getHeader("Caller-Destination-Number")
domain_name = event:getHeader("Caller-Context")
signal_bond = event:getHeader("variable_signal_bond")
endpoint_disposition = event:getHeader("variable_endpoint_disposition")

if campon == "true" then
	---USADO APENAS PARA DEBUG
	freeswitch.consoleLog("notice", "Atendimento campon no atendimento.: ".. tostring(uuid).." "  .. tostring(campon) .. "\n");
	freeswitch.consoleLog("notice", "Atendimento call_uuid no atendimento.: " .. tostring(uuid).." " .. tostring(call_uuid) .. "\n");
	freeswitch.consoleLog("notice", "Atendimento uuid no atendimento.: " .. tostring(uuid) .. "\n");
	freeswitch.consoleLog("notice", "Atendimento destination_number no atendimento.: " .. tostring(uuid) .." " .. tostring(destination_number) .. "\n");
	freeswitch.consoleLog("notice", "Atendimento variavel signal_bond no atendimento.: " .. tostring(uuid) .." " .. tostring(signal_bond) .. "\n");
	freeswitch.consoleLog("notice", "Atendimento variavel endpoint_disposition no atendimento.: ".. tostring(uuid) .." " .. tostring(endpoint_disposition) .. "\n");

--	dump = api:execute("uuid_dump", uuid)
	--if session:ready() then
--		freeswitch.consoleLog("notice", "Atendimento variavel dump no atendimento.: ".. tostring(uuid) .." " .. tostring(dump) .. "\n");
	--	session:consoleLog("notice", "Atendimento" .. tostring(dump) .. "\n")
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
	
end


