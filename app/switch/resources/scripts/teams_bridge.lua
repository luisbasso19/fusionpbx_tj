api = freeswitch.API()

dialed_extension = session:getVariable("dialed_extension");
domain_name = session:getVariable("domain_name");
numero_teams = session:getVariable("numero_teams");
uuid = session:getVariable("uuid");
--effective_caller_id_number = session:getVariable("effective_caller_id_number")
effective_caller_id_number = argv[1];

dialA = "sofia/gateway/106395dd-109b-4f6e-9e4c-e06c66c8346c/" .. numero_teams

dialB = api:executeString("sofia_contact " .. dialed_extension .. "@" .. domain_name)

connected = false
timeout = 40
originate_base_teams = "{originate_timeout=90,hangup_after_bridge=true,uuid="..uuid..",leg=1, effective_caller_id_number="..effective_caller_id_number.."}";
originate_base_internal = "{ignore_early_media=true,originate_timeout=90,hangup_after_bridge=true,uuid="..uuid..",leg=1, effective_caller_id_number="..effective_caller_id_number.."}";

originate_str_teams = originate_base_teams..dialA;
originate_str_internal = originate_base_internal..dialB;
session_teams = null;
session_internal = null;
retries = 0;

repeat
	retries = retries + 1;
	freeswitch.consoleLog("notice", "######Dialing leg Teams: " .. originate_str_teams .. " - Try: "..retries.." ######\n");
	session_teams = freeswitch.Session(originate_str_teams)
	local hcause_teams = session_teams:hangupCause();
	freeswitch.consoleLog("notice", "######leg Teams: " .. hcause_teams .. " - Try: "..retries.." ######\n");
	freeswitch.consoleLog("notice", "######Dialing leg internal: " .. originate_str_internal .. " - Try: "..retries.." ######\n");
	session_internal = freeswitch.Session(originate_str_internal)
	local hcause_internal = session_internal:hangupCause();
	freeswitch.consoleLog("notice", "######leg internal: " .. hcause_internal .. " - Try: "..retries.." ######\n");
until not (((hcause_teams == 'NO_ROUTE_DESTINATION' or hcause_teams == 'RECOVERY_ON_TIMER_EXPIRE' or hcause_teams == 'INCOMPATIBLE_DESTINATION' or hcause_teams == 'CALL_REJECTED' or hcause_teams == 'NORMAL_TEMPORARY_FAILURE') or (hcause_internal == 'NO_ROUTE_DESTINATION' or hcause_internal == 'RECOVERY_ON_TIMER_EXPIRE' or hcause_internal == 'INCOMPATIBLE_DESTINATION' or hcause_internal == 'CALL_REJECTED' or hcause_internal == 'NORMAL_TEMPORARY_FAILURE')) and (retries < 2))

freeswitch.consoleLog("notice", "###### Saiu do repeat ######\n");

if (session_teams:ready()) then
	local hcause_teams = session_teams:hangupCause()
	freswitch.consoleLog("notice", "######leg Teams: " .. hcause_teams .. " ######\n");
end
if (session_internal:ready()) then
	local hcause_internal = session_internal:hangupCause();
	freswitch.consoleLog("notice", "######leg internal: " .. hcause_internal .. " ######\n");

end

freeswitch.consoleLog("notice", "###### Passou pelo IF ######\n");



--[[if dialA ~= nil then
	freeswitch.consoleLog("notice", "lua bridge para o GW TEAMS .: " .. dialA .. "\n")
	legTeams = freeswitch.Session(dialA)
	dispoTeams = "None"
end

if dialB ~= nil then
	freeswitch.consoleLog("notice", "lua brideg para o sofia TEAMS .: " .. dialB .. "\n")
	legInterna = freeswitch.Session(dialB)
	dispoInterna = "None"
end

while(legTeams:ready() and legInterna:ready() and dispoTeams ~= "ANSWER" and dispoInterna ~= "ANSWER") do
	dispoTeams = legTeams:getVariable("endpoint_disposition")
	dispoInterna = legInterna:getVariable("endpoint_disposition")
	uuidTeams = legTeams:getVariable("uuid")
	uuidInterna = legInterna:getVariable("uuid")
	if dispoTeams == "EARLY" then
		freeswitch.consoleLog("notice", "lua session early para o sofia TEAMS .: " .. dispoTeams .. "\n")
		legTeams:preAnswer()
	end
end

--legA = session:answer()
if dispoTeams == "ANSWER" then
	--freeswitch.bridge(legA, legTeams)
	--new_sessionTeams = freeswitch.Session(legTeams, session)
	api:executeString("uuid_bridge " .. uuid .. " " .. uuidTeams)
	legInterna:hangup("CANCEL")
end
if dispoInterna == "ANSWER" then
	--freeswitch.bridge(legA, legInterna)
	--new_sessionInterna = freeswitch.Session(legInterna, session)
	api:executeString("uuid_bridge " .. uuid .. " " .. uuidInterna)
	legTeams:hangup("CANCEL")
end
--atendimento = "None"

--while(atendimento == "None") do
--	dispoTeams = legTeams:getVariable("endpoint_disposition")


--end--]]
