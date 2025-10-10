api = freeswitch.API()
uuid = argv[1]

dialed_extension = session:getVariable("dialed_extension");
domain_name = session:getVariable("domain_name");

if dialed_extension ~= nil and domain_name ~= nil then
	contato = dialed_extension .. "@" .. domain_name;
end

--contact = session:execute("sofia_contact", dialed_extension.."@"..domain_name)

if string.find(dialed_extension, "^6[0-3][0-9][0-9]") then
		cod_dest = 66001;
		numero_teams = '+55413250' .. dialed_extension;
		session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^65[0-9][0-9]") then
		cod_dest = 66001;
		numero_teams = '+55413250' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^67[0-9][0-9]") then
		cod_dest = 66001;
		numero_teams = '+55413250' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^50[5-9][0-9]") then
                cod_dest = 66001;
                numero_teams = '+55413250' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^[2-4][0-9][0-9][0-9]") then
		cod_dest = 66002;
		numero_teams = '+55413200' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^[7-8][0-9][0-9][0-9]") then
		cod_dest = 66003;
		numero_teams = '+55413210' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^5[7-9][0-9][0-9]") then
		cod_dest = 66004;
		numero_teams = '+55413228' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^9[5-8][0-9][0-9]") then
		cod_dest = 66005;
		numero_teams = '+55413221' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams)
	elseif string.find(dialed_extension, "^9[1-4][0-9][0-9]") then
		cod_dest = 66006;
		numero_teams = '+55413309' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^53[0-9][0-9]") then
		cod_dest = 66007;
		numero_teams = '+55413312' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^6[0-2][0-9][0-9]") then
		cod_dest = 66007;
		numero_teams = '+55413312' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^69[0-9][0-9]") then
		cod_dest = 66007;
		numero_teams = '+55413312' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^1[7-8][0-9][0-9]") then
		cod_dest = 66008;
		numero_teams = '+55413250' .. dialed_extension;
                session:setVariable("outbound_caller_id_number", numero_teams);
	elseif string.find(dialed_extension, "^50[5-9][0-9]") then
		cod_dest = 66001;
	end
	if numero_teams ~= nil then
		session:setVariable("numero_teams", numero_teams)
	end



if contato ~= nil then
	freeswitch.consoleLog("notice", "contato de chamada para o TEAMS .: " .. contato .. "\n")
	freeswitch.consoleLog("notice", "UUID de chamada para o TEAMS .: " .. uuid .. "\n")
end
--freeswitch.consoleLog("notice", "domain_name de chamada para o TEAMS .: " .. domain_name .. "\n")
--freeswitch.consoleLog("notice", "UUID de chamada para o TEAMS .: " .. uuid .. "\n")
