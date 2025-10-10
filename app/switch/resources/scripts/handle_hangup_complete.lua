


api = freeswitch.API()
capture_function = require("capture.capture_function")


campon = event:getHeader("variable_campon");
uuid = event:getHeader("variable_uuid");
endpoint_disposition = event:getHeader("variable_endpoint_disposition")
originate_disposition = event:getHeader("variable_originate_disposition")

--if campon == "true" then
        ---USADO APENAS PARA DEBUG
freeswitch.consoleLog("notice", "---------------------------------------------------------------------------------------- " .. "\n")
freeswitch.consoleLog("notice", "O valor em hangup complete campon no hangup_complete..: "..tostring(uuid) .." ".. tostring(campon) .. "\n");
freeswitch.consoleLog("notice", "O valor em hangup complete uuid no hangup_complete..: " ..tostring(uuid) .. "\n");
freeswitch.consoleLog("notice", "O valor da variavel endpoint_disposition no hangup_complete.: "..tostring(uuid).." " ..tostring(endpoint_disposition) .."\n");
freeswitch.consoleLog("notice", "O valor da variavel originate_disposition no hangup_complete.: "..tostring(uuid) .. " " .. tostring(originate_disposition) .. "\n");
freeswitch.consoleLog("notice", "---------------------------------------------------------------------------------------- " .. "\n")
---
if uuid ~= nil then
      	capture_function.unregister(uuid)
end      


--end

