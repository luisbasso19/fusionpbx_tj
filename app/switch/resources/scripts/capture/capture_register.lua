
local uuid = argv[1]
local tag  = argv[2]
capture_function = require("capture.capture_function")

if uuid == nil and tag == nil then 
	uuid = session:getVariable("uuid")
	domain_name = session:getVariable("domain_name")
	call_group = session:getVariable("call_group")
	destination_number = session:getVariable("destination_number")

	--session:consoleLog("info", "CAPTURE_REGISTER call_group.: " .. tostring(call_group) .. "\n")
	if call_group ~= nil then
		tag = call_group.."@"..domain_name
	else
		tag = destination_number.."@"..domain_name
	end
end
if session:ready() then
	session:consoleLog("info", "CAPTURE_REGISTER tag.: " .. tostring(tag) .. "\n")
	if call_group ~= nil then
		capture_function.register(tag,uuid)
	end
end



