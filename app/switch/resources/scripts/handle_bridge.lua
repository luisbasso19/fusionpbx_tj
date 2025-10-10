
api = freeswitch.API()


capture_function = require("capture.capture_function")

campon = event:getHeader("variable_campon");
uuid = event:getHeader("variable_uuid");
endpoint_disposition = event:getHeader("variable_endpoint_disposition")
signal_bond = event:getHeader("variable_signal_bond")
destination_number = event:getHeader("Caller-Destination-Number")
--if campon == "true" then
---USADO APENAS PARA DEBUG
freeswitch.consoleLog("notice", "---------------------------------------------------------------------------------------- " .. "\n")
freeswitch.consoleLog("notice", "Bridge_evento variavel campon no bridge.: " ..tostring(uuid) .. " " .. tostring(campon) .. "\n");
freeswitch.consoleLog("notice", "Bridge_evento variavel uuid no bridge.: " .. tostring(uuid) .. "\n");
freeswitch.consoleLog("notice", "Bridge_evento variavel endpoint_disposition no bridge.: " .. tostring(uuid) .. " " .. tostring(endpoint_disposition) .. "\n");
freeswitch.consoleLog("notice", "Bridge_evento variavel signal_bond no atendimento.: " .. tostring(uuid) .." " .. tostring(signal_bond) .. "\n");
freeswitch.consoleLog("notice", "---------------------------------------------------------------------------------------- " .. "\n")
---
--
--if string.find(destination_number, "6725") then
--	dump = api:execute("uuid_dump", uuid)

        --if session:ready() then
--                freeswitch.consoleLog("notice", "Bridge_evento variavel dump no bridge.: ".. tostring(destination_number) .." " .. tostring(dump));
        --      session:consoleLog("notice", "Atendimento" .. tostring(dump) .. "\n")
        --end
--end




if endpoint_disposition == "ANSWER" then
	capture_function.unregister(uuid)
end

if endpoint_disposition == "RINGING" then
	if string.find(destination_number, "6725") then
		session:execute("info")
	end
end
        

--end





