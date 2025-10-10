api = freeswitch.API()


local userdata = require("recursos.functions.set_userdata");
local Database = require("resources.functions.database");




--DEFINICAO DE VARIAVEIS
local domain_name = session:getVariable("domain_name");
--FIM DEFINICAO DE VARIAVEIS



local destination_number = session:getVariable("destination_number");
if destination_number ~= nil then
	local destination_number_uuid = api:executeString("user_data " .. destination_number .. "@" .. domain_name .. " var extension_uuid")
	if session:ready() then
		if destination_number_uuid ~= nil and destination_number_uuid ~= '' then
    			local Database = require "resources.functions.database"
			local json = require "resources.functions.lunajson"  -- só se quiser logar params

			local dbh = Database.new('system')  -- DB do FusionPBX (Postgres na maioria)
			local rows = {}
			local sql = [[
				SELECT
					vs.extension_setting_type,
					vs.extension_setting_name,
					vs.extension_setting_value,
					ve.extension,
					vd.domain_name
				FROM v_extension_settings vs
				JOIN v_extensions ve ON vs.extension_uuid = ve.extension_uuid
				JOIN v_domains vd ON ve.domain_uuid = vd.domain_uuid
				WHERE extension_setting_value = :extension_uuid
				AND extension_setting_name = 'associated_uuid'
				ORDER BY ve.extension
			]]
			local params = { extension_uuid = destination_number_uuid }

			username_contact = {}
			dbh:query(sql, params, function(row)
				username_contact[#username_contact+1] = row.extension .. "@" .. row.domain_name
			end)

			dbh:release()
			contacts = api:executeString("sofia_contact " .. destination_number .. "@" .. domain_name)
			if #username_contact > 0 then
   				for i,username_uri in ipairs(username_contact) do
					local call_forward_enabled = api:executeString("user_data "..username_uri.." var forward_all_enabled")
					session:consoleLog("info", "USERNAME - call_forward_enabled.: " .. call_forward_enabled .. "\n")
					if call_forward_enabled == "true" then
						local call_direction = "outbound"
						local caller_id = destination_number;
						local domain_name_username = api:executeString("user_data "..username_uri.." var domain_name");
						local domain_uuid = api:executeString("user_data "..username_uri.." var domain_uuid");
						local toll_allow = api:executeString("user_data "..username_uri.." var toll_allow");
						local origination_caller_id_number = destination_number;
                                                local call_forward_destination = api:executeString("user_data "..username_uri.." var forward_all_destination");
						local global_codec = session:getVariable("outbound_codec_prefs");
						session:execute("export", "absolute_codec_string=PCMU,PCMA,OPUS")
						local contact = "[toll_allow=".. toll_allow .. ",call_direction="..call_direction
						contact = contact .. ",origination_caller_id_number="..origination_caller_id_number;
						contact = contact .."]".."loopback/" .. call_forward_destination;
						contacts = contacts .. ":_:" .. contact
					else
						local contact = api:executeString("sofia_contact " .. username_uri)
						contacts = contacts .. "," .. contact
					end				
				end
			end
			session:consoleLog("info", "USERNAME - CONTATOS.: " .. contacts .. "\n")
			session:setVariable("extension_contacts", contacts);
		else
			session:consoleLog("warning", "USERNAME - extension_uuid vazio/nulo.\n")
		end
	end
end

