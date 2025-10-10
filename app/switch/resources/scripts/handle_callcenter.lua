api = freeswitch.API()


cc_action = event:getHeader("CC-Action")
member_uuid = event:getHeader("CC-Member-UUID")
member_session_uuid = event:getHeader("CC-Member-Session-UUID")
variable_last_app = event:getHeader("variable_last_app")
if cc_action ~= nil then
	--freeswitch.consoleLog("notice", "DEBUG - acao efetuada " .. cc_action .. "\n")
	if cc_action == 'bridge-agent-fail' then
		freeswitch.consoleLog("notice", "DEBUG - acao efetuada " .. cc_action .. "\n")
		freeswitch.consoleLog("notice", "DEBUG - uuid " .. member_uuid .. "\n")
		freeswitch.consoleLog("notice", "DEBUG - session uuid " .. member_session_uuid .. "\n")
	elseif cc_action == 'bridge-agent-start' then
		freeswitch.consoleLog("notice", "DEBUG - acao efetuada " .. cc_action .. "\n")
                freeswitch.consoleLog("notice", "DEBUG - uuid " .. member_uuid .. "\n")
		freeswitch.consoleLog("notice", "DEBUG - session uuid " .. member_session_uuid .. "\n")
	elseif cc_action == 'bridge-agent-end' then
		CC_Queue = event:getHeader("CC-Queue")
		freeswitch.consoleLog("notice", "DEBUG - acao efetuada " .. cc_action .. "\n")
                freeswitch.consoleLog("notice", "DEBUG - uuid " .. member_uuid .. "\n")
                freeswitch.consoleLog("notice", "DEBUG - session uuid " .. member_session_uuid .. "\n")
		if CC_Queue ~= nil then
			freeswitch.consoleLog("notive", "DEBUG - nome da file " .. CC_Queue .. "\n")
		end
	end
else
	freeswitch.consoleLog("notice", "DEBUG - acao vazio " .. "\n")
end
