
local capture_function = {}
local api = freeswitch.API()

function capture_function.unregister(uuid)
	if not uuid then return end
	--if not capture_tag then
	--	capture_tag = false
	--end
	local mapping = api:execute("memcache", "get capture:map:"..uuid)
	mapping = (mapping or ""):match("^%s*(.-)%s*$")
	if mapping == "" then return end
	local tag, id = mapping:match("^([^|]+)|(%d+)%s*$")
	if tag and id then
		--freeswitch.consoleLog("notice", "Function unregister.: capture_tag "..tostring(capture_tag) .. " -- " .. tostring(tag) .."\n")
		api:execute("memcache", "delete capture:"..tag..":item:"..id)	
		--if capture_tag == false then
		--	api:execute("memcache", "increment capture:"..tag..":head 1")
		--end
	end
	api:execute("memcache", "delete capture:map:"..uuid)
	api:execute("memcache", "delete capture:seen:"..uuid)
end

function capture_function.register(tag,uuid)
--	freeswitch.consoleLog("notice", "Function register.:"..tostring(tag) .. "--" .. tostring(uuid) .."\n");
	
	local head_output = api:execute("memcache", "get capture:"..tag..":head")
	if string.find(head_output,"-ERR NOT FOUND") then
		api:execute("memcache", "add capture:"..tag..":head 0 3600")
	end
	local tail_output = api:execute("memcache", "get capture:"..tag..":tail")
	if string.find(tail_output,"-ERR NOT FOUND") then
		api:execute("memcache", "add capture:"..tag..":tail 0 3600")
	end
	local existed = api:execute("memcache", "add capture:seen:"..uuid.." 1 3600")
	if string.find(existed,"+OK") then
		local tail = api:execute("memcache", "increment capture:"..tag..":tail 1")
		local id = tonumber(tail) or 0
		api:execute("memcache", "set capture:"..tag..":item:"..id.." "..uuid.." 3600")
		api:execute("memcache", "set capture:map:"..uuid.." "..tag.."|"..id.." 3600")
	end

end



function capture_function.captura(tag)

	local head_output = api:execute("memcache", "get capture:"..tag..":head")
	if string.find(head_output,"-ERR NOT FOUND") then
		api:execute("memcache", "add capture:"..tag..":head 0 3600")
	end
	local tail_output = api:execute("memcache", "get capture:"..tag..":tail")
        if string.find(tail_output,"-ERR NOT FOUND") then
                api:execute("memcache", "add capture:"..tag..":tail 1 3600")
        end
	::uuid_error::
	head = tonumber(api:execute("memcache", "increment capture:"..tag..":head 1")) or 0
	local key = ("capture:%s:item:%d"):format(tag, head)
	local uuid = api:execute("memcache", "get "..key)
	if string.find(uuid, "-ERR NOT FOUND") then
		tail = tonumber(api:execute("memcache", "get capture:"..tag..":tail")) or 0
		if head < tail then
			goto uuid_error
		end
		if head > tail then
			api:execute("memcache", "set capture:"..tag..":head 0")
			goto uuid_error
		end
		if head == tail then
			--if session:ready() then
				--session:streamFile("tone_stream://%(200,0,500);%(200,2000,350,440)")
				--session:hangup("SERVICE_UNAVAILABLE")
			--end
			return
		end
	end
	capture_function.unregister(uuid)
	local campon = api:execute("uuid_getvar", uuid.." campon")
	if campon == 'true' then
		local uuid_intercept = session:getVariable("call_uuid")
		--api:execute("uuid_break", uuid.." all")
		--api:execute("uuid_setvar", uuid.." campon_timeout=1")
		--session:setVariable("intercept_unbridged_only","true")
		--local cmd_intercept = "-bleg " .. uuid
		--session:consoleLog("info", "campon intercept.: " .. tostring(cmd_intercept) .. "\n")
		--session:execute("intercept", cmd_intercept)
		session:consoleLog("info", "campon intercept campon.: " .. tostring(campon) .. "\n")
		session:consoleLog("info", "campon intercept uuid.: " .. tostring(uuid_intercept) .. "\n")
		--session:answer()
		--api:execute("uuid_park", uuid)
	
		local stop = "9" 
		api:execute("uuid_send_dtmf", uuid .. " " .. stop)
		freeswitch.msleep(80)

		--session:execute("sleep", "80")
		session:execute("intercept", uuid)
		--api:execute("uuid_bridge", uuid_intercept .." " uuid)
	--end
	else
		session:execute("intercept", uuid)
	end
end



return capture_function
