api = freeswitch.API()


local userdata = require("recursos.functions.set_userdata");
local Database = require("resources.functions.database");


--DEFINICAO DE VARIAVEIS
local domain_name = session:getVariable("domain_name");
local destination_number = session:getVariable("destination_number");
local extension_uuid = session:getVariable("extension_uuid");
local user_context = session:getVariable("user_context");
--FIM DEFINICAO DE VARIAVEIS

if user_context == "fusionpbx.tjpr.jus.br" then
        sip_from_user = session:getVariable("sip_from_user")
	if sip_from_user ~= nil then
        	associated_uuid = api:executeString("user_data " .. sip_from_user .. "@" .. user_context .. " var associated_uuid")
                if  associated_uuid ~= nil then
                	extension_uuid = associated_uuid
                end
        	session:consoleLog("info", "DEBUG - VALOR DE from_user .:" .. tostring(sip_from_user));
	end
end


local dbh = Database.new('system')
local sql = [[
	SELECT
		ve.extension,
		ve.extension_uuid,
		vd.domain_name
	FROM v_extensions ve
	JOIN v_domains vd ON ve.domain_uuid = vd.domain_uuid
	WHERE ve.extension_uuid = :extension_uuid
]]

local params = { extension_uuid = associated_uuid }


data_user = {}

dbh:query(sql, params, function(row)
	extension_associated = row.extension
	domain_associated = row.domain_name
	session:consoleLog("info", "DEBUG - VALOR DE user_associado .:" .. tostring(row.extension) .. "@" .. tostring(row.domain_name));
end)

if extension_associated ~= nil and domain_associated ~= nil then
	--session:setVariable("effective_caller_id_name", extension_associated);
        session:setVariable("effective_caller_id_number", extension_associated);
	session:setVariable("call_direction", "local");
	session:execute("export", "domain_name=" .. domain_associated)
	session:transfer(destination_number, "XML", domain_associated);
end






session:consoleLog("info", "USERNAME - INTERNO.: " .. tostring(destination_number) .. "\n")
