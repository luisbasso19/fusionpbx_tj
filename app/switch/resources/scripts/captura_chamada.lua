--DEFINICAO DA API DO FREESWITCH

api = freeswitch.API()

--DEFINICAO DAS VARIAVEIS

local username_find = require("recursos.functions.find_username")
local usernumber_find = require("recursos.functions.find_usernumber")
local capture_function = require("capture.capture_function")

call_uuid = session:getVariable("uuid")
call_group = session:getVariable("call_group")
domain_name = session:getVariable("domain_name")
associated_uuid = session:getVariable("associated_uuid")
extension_uuid = session:getVariable("extension_uuid")

if session:ready() then
	if extension_uuid ~= nil and associated_uuid == nil then
		user_names = username_find.find_username(extension_uuid)
		username_contacts = {}
		if #user_names > 0 then
			for i, user_contact in ipairs(user_names) do
				username_contacts[#username_contacts+1] = user_contact
			end
		end
	end
	if associated_uuid ~= nil then
		user_number = usernumber_find.find_usernumber(associated_uuid)
		session:consoleLog("INFO", "Numero de ramal contem valores .: " .. tostring(user_number.extension_associated) .. "\n")
		session:consoleLog("INFO", "Numero de ramal contem valores .: " .. tostring(user_number.domain_associated) .. "\n")
		domain_name = user_number.domain_associated

	end
	if call_group == nil and associated_uuid ~= nil then
		if user_number.domain_associated ~= nil and user_number.extension_associated ~= nil then
			call_group = api:execute("user_data", user_number.extension_associated .."@"..user_number.domain_associated.." var call_group")
		end
	end
	session:consoleLog("INFO", "[CAPTURA DE CHAMADA] call_group.: " .. tostring(call_group) .. "\n")
	if call_group ~= nil then
		tag = call_group.."@"..domain_name
		session:consoleLog("INFO", "[CAPTURA DE CHAMADA] tag.: " .. tostring(tag) .. "\n")
		capture_function.captura(tag)
	end
end



--[[
if session:ready() then
	if extension_uuid ~= nil and associated_uuid == nil then
		session:consoleLog("INFO", "contem valores de extension_uuid.: " .. tostring(extension_uuid) .. "\n")
		user_name = username_find.find_username(extension_uuid)
		if #user_name > 0 then
			for i, user_contact in ipairs(user_name) do
				session:consoleLog("INFO", "Username contem valores .: " .. tostring(user_contact) .. "\n")
			end
		end
	end
	if associated_uuid ~= nil then
		user_number = usernumber_find.find_usernumber(associated_uuid)
		session:consoleLog("INFO", "Numero de ramal contem valores .: " .. tostring(user_number.extension_associated) .. "\n")
		session:consoleLog("INFO", "Numero de dominio contem valores .: " .. tostring(user_number.domain_associated) .. "\n")
	end
end
]]--
