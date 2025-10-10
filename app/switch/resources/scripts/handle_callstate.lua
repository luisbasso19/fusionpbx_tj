api = freeswitch.API()

campon = event:getHeader("variable_campon");
uuid = event:getHeader("Unique-ID");
endpoint_disposition = event:getHeader("variable_endpoint_disposition")
answer_state = event:getHeader("Answer-State");

--if campon == "true" then
---USADO APENAS PARA DEBUG
freeswitch.consoleLog("notice", "---------------------------------------------------------------------------------------- " .. "\n")
freeswitch.consoleLog("notice", "O valor da variavel campon no call_state.: " .. tostring(campon) .. "\n");
freeswitch.consoleLog("notice", "O valor da variavel uuid no call_state.: " .. tostring(uuid) .. "\n");
freeswitch.consoleLog("notice", "O valor da variavel endpoint_disposition no call_state.: " .. tostring(endpoint_disposition) .. "\n");
freeswitch.consoleLog("notice", "O valor da variavel answer_state no call_state.: " .. tostring(answer_state) .. "\n");
freeswitch.consoleLog("notice", "---------------------------------------------------------------------------------------- " .. "\n")

