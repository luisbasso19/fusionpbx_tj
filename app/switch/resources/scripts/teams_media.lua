api = freeswitch.API()
uuid = argv[1]


freeswitch.consoleLog("notice", "uuid de chamada para a midia TEAMS .: " .. uuid .. "\n")
--api:executeString("uuid_pre_answer " .. uuid)
--session:execute("wait_for_answer")
session:execute("info")
--session:preAnswer()
--teste="true"
--while (teste == "true") do
--	if (session:answered() == true) then
--		freeswitch.consoleLog("notice", "chamada atendida para a midia TEAMS .: \n")
		--api:executestring("uuid_early_ok " .. uuid) 
--		api:executestring("uuid_media " .. uuid) 
--		teste="false"
--		break
		
--	end
		
--end

