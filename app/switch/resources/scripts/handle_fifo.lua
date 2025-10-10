--include config.lua
        require "resources.functions.config"

--include funcoes de texto
        require "recursos.functions.texto"


api = freeswitch.API()

local transfer_destination = event:getHeader("variable_transfer_destination")
local transfer_to = event:getHeader("variable_transfer_to")
local transfer_fallback = event:getHeader("variable_transfer_fallback_extension")
--local endpoint_disposition = event:getHeader("variable_endpoint_disposition")
local uniqueId = event:getHeader("Unique-ID")
local FIFO_Action = event:getHeader("FIFO-Action")
local fifo_serviced_uuid = event:getHeader("variable_fifo_serviced_uuid")
local caller_id_number = event:getHeader("variable_caller_id_number")
local fifoMember = event:getHeader("Caller-Caller-ID-Number")
local result = event:getHeader("result")
local originate_string = event:getHeader("originate_string")
local cause = event:getHeader("cause")
local FIFOobuuid = event:getHeader("FIFO-Outbound-UUID-List")
local uuidOrigem = event:getHeader("caller-uuid")
local status = event:getHeader("variable_fifo_status")
local FIFO_Type = event:getHeader("FIFO-Type")
local FIFO_name = event:getHeader("FIFO-Name")
local fifoVarName = event:getHeader("variable_fifo_name")
local origCallerId = event:getHeader("Caller-Orig-Caller-ID-Number")
local transferFallback = event:getHeader("variable_transfer_fallback_extension")
--local transferDestination = event:getHeader("variable_transfer_destination")
local fifoBridgedUUID = event:getHeader("variable_call_uuid")
local outboundstrategy = event:getHeader("outbound-strategy")

local arquivo = io.open("/var/log/freeswitch/filas_eventos.txt", "a");
local arquivo_dump = io.open("/var/log/freeswitch/filas_dump.txt", "a");

--arquivo.write(params:serialize())

if FIFO_name ~= nil then
	if FIFO_name == 'DSC-TESTE-MEDICO@@fs-cwb.tjpr.jus.br' then --or FIFO_name == 'manual_calls' then
		freeswitch.consoleLog("info", "EVENTO_ ..:  " .. FIFO_name .. "\n");
		--freeswitch.consoleLog("info", "EVENTO FALLBACK.: " .. transfer_fallback .. "\n");
		if FIFO_Action ~= nil then
			freeswitch.consoleLog("info", "EVENTO_ FIFO-Action.: " .. FIFO_Action .. "\n");
			if FIFO_Action == 'channel-consumer-start' then
				if originate_string ~= nil then
					freeswitch.consoleLog("info", "EVENTO .: " .. originate_string .. "\n");
				end
			elseif FIFO_Action == 'post-dial' then
				 dump = api.executeString("uuid_dump " .. uniqueId)
                                        if dump ~= nil then
                                                arquivo_dump:write(dump)
                                        end
				if originate_string ~= nil then
                                        freeswitch.consoleLog("info", "EVENTO_ post-dial .: " .. originate_string .. "\n");
                                end
			elseif FIFO_Action == 'pre-dial' then
				freeswitch.consoleLog("info", "EVENTO_ uniqueid: " .. uniqueId .. "\n");
				dump = api.executeString("uuid_dump " .. uniqueId)
				if dump ~= nil then
					freeswitch.consoleLog("info", "EVENTO_ dump: " .. dump .. "\n");
				--	arquivo_dump:write(dump)
				end
				if originate_string ~= nil then
					freeswitch.consoleLog("info", "EVENTO_ pre_dial .: " .. originate_string .. "\n");
                                end
			elseif FIFO_Action == 'channel-consumer-stop' then
				endpoint_disposition = event:getHeader("variable_endpoint_disposition")
				transferDestination = event:getHeader("variable_transfer_destination")
			end
			elseif FIFO_Action == 'push' then
				freeswitch.consoleLog("info", "EVENTO_ push: " .. FIFO_Action .. "\n");
				if outboundstrategy ~= nil then
					freeswitch.consoleLog("info", "EVENTO_ OUTBOUND " .. outboundstrategy .. "\n")
				end
		end
		if originate_string ~= nil then
			freeswitch.consoleLog("info", "EVENTO originate.: " .. originate_string .. "\n");
		end
		if outboundstrategy ~= nil then
			freeswitch.consoleLog("info", "EVENTO_ FIFO_Action: " .. FIFO_Action .. "\n");
        	        freeswitch.consoleLog("info", "EVENTO_ OUTBOUND " .. outboundstrategy .. "\n")
                end
	end
end

if FIFO_Action ~= nil then
	if FIFO_Action == 'bridge-caller-start' then
		if (status == 'TALKING') then
			recordings_dir = api:executeString("uuid_getvar ".. fifo_serviced_uuid.. " recordings_dir")
			domain_name = api:executeString("uuid_getvar ".. fifo_serviced_uuid.. " domain_name")
			--recordings_dir = api:executeString("uuid_getvar ".. fifoBridgedUUID .. " recordings_dir")
			--domain_name = api:executeString("uuid_getvar "..  fifoBridgedUUID.. " domain_name")
			record_path = recordings_dir .. "/" .. domain_name .. "/archive/" .. os.date('%Y') .. "/" .. os.date('%b') .. "/" .. os.date('%d')
			record_name = fifo_serviced_uuid 
			api:executeString("uuid_setvar ".. fifo_serviced_uuid .." record_path " .. record_path)
			--api:executeString("uuid_setvar ".. fifo_serviced_uuid .." record_name " .. record_name)
			api:executeString("uuid_record " .. fifo_serviced_uuid .. " start " ..  record_path .. "/" .. record_name .. ".wav")
		end
	elseif FIFO_Action == 'bridge-caller-stop' then
		api:executeString("uuid_record " .. fifo_serviced_uuid .. " stop")
	--elseif FIFO_Action == 'post-dial' then
	--	freeswitch.consoleLog("info", "EVENTO #######################################################################\n");
	--	freeswitch.consoleLog("info", "EVENTO post-dial\n");

	--	freeswitch.consoleLog("info", "EVENTO #######################################################################\n");
	elseif FIFO_Action == 'bridge-consumer-start' then
		--freeswitch.consoleLog("info", "EVENTO #######################################################################\n");
		if (status == 'TALKING') then
			recordings_dir = api:executeString("uuid_getvar ".. fifoBridgedUUID .. " recordings_dir")
			domain_name = api:executeString("uuid_getvar ".. fifoBridgedUUID .. " domain_name")
			record_path = recordings_dir .. "/" .. domain_name .. "/archive/" .. os.date('%Y') .. "/" .. os.date('%b') .. "/" .. os.date('%d')
			record_name = fifoBridgedUUID
			--sessaoValida = api:executeString("uuid_exists ".. fifoBridgedUUID)
			--freeswitch.consoleLog("info", "EVENTO record dir.: " .. recordings_dir .."\n");
			--freeswitch.consoleLog("info", "EVENTO domain .: " .. domain_name .."\n");
			--freeswitch.consoleLog("info", "EVENTO record path .: " .. record_path .."\n");
			--freeswitch.consoleLog("info", "EVENTO record name .: " .. record_name .."\n");
			--freeswitch.consoleLog("info", "EVENTO uuid existe .: " ..  sessaoValida.."\n");

			--api:executeString("uuid_setvar " .. fifoBridgedUUID .." record_path " .. record_path)
	                --api:executeString("uuid_setvar " .. fifoBridgedUUID .." record_name " .. record_name)
                	--api:executeString("uuid_record " .. fifoBridgedUUID .. " start " ..  record_path .. "/" .. record_name .. ".wav")
		end
	elseif FIFO_Action == 'pre-dial' then
		if originate_string ~= nil then
			if fifo_name ~= nil then
                	 	freeswitch.consoleLog("info", "EVENTO nome fila  .: " .. fifo_name .. "\n")
		 	end
			if outboundstrategy ~= nil then
				freeswitch.consoleLog("info", "EVENTO outbound-strategy .: " .. outboundstrategy .. "\n")
			end
			freeswitch.consoleLog("info", "EVENTO  string chamada.: " .. originate_string .. "\n");
                end

	end

end

