local function handle_event(event)
    local event_type = event:getHeader("Event-Subclass")
    local from_user = event:getHeader("from-user")
    local to_user = event:getHeader("to-user")
    local call_direction = event:getHeader("Call-Direction")
    local call_state = event:getHeader("Answer-State")

    -- Lógica para determinar o estado do BLF
    local blf_state = "idle" -- Estado padrão

    if call_state == "early" then
        blf_state = "ringing"
    elseif call_state == "confirmed" then
        blf_state = "active"
    end

    freeswitch.consoleLog("notice", "DEBUG - funcao handle_event\n")
    -- Envia o evento BLF para o telefone
    local event = freeswitch.Event("CUSTOM", "sofia::presence")
    event:addHeader("proto", "sip")
    event:addHeader("from", from_user) -- Ou o usuário que você quer monitorar
    event:addHeader("to", to_user) -- Ou o usuário que está monitorando
    event:addHeader("event_type", "presence")
    event:addHeader("alt_event_type", "dialog")
    event:addHeader("Presence-Call-Direction", call_direction)
    event:addHeader("answer-state", call_state)
    event:addHeader("Presence-Status", blf_state)
    event:fire()
end

local function init()
    freeswitch.consoleLog("notice", "DEBUG  handle - Script BLF carregado\n")
--    con = freeswitch.EventConsumer();
    --con:bind("CHANNEL_ANSWER", function(self, event)
--	handle_event(event)
--  end)
    --con:bind("CHANNEL_HANGUP")
    --con:bind("CHANNEL_CREATE")
    --freeswitch.EventConsumer("CHANNEL_HANGUP", handle_event)
    --freeswitch.EventConsumer("CHANNEL_CREATE", handle_event)
end

freeswitch.consoleLog("notice", "DEBUG  handle - Script BLF carregado\n")

--service:bind("PRESENCE_PROBE", function(self, name, event)
--        local proto = event:getHeader('proto')
--        local handler = proto and protocols[proto]
--        if not handler then return end
--        return handler(event)
--end)




init()

