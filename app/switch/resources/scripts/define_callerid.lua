--include config.lua
        require "resources.functions.config";

--add the function
        require "resources.functions.explode";
        require "resources.functions.trim";
        require "resources.functions.channel_utils";



--Get intercept logger
        local log = require "resources.functions.log".intercept;

	local Database = require "resources.functions.database"

	local dsn = session:getVariable("dsn");
	local dsf = session:getVariable("dsf");
	--local dbh = Database.new('switch')

	local fsData = freeswitch.Dbh(dsn);
	
	local extension_uuid = session:getVariable("extension_uuid");

	local outbound_number = session:getVariable("outbound_caller_id_number");
	local outbound_prefix = session:getVariable("outbound_prefix");
	local model_pabx = session:getVariable("sip_user_agent");
	

	if outbound_prefix == nil then
		outbound_prefix = "";
	end
	if model_pabx ~= nil then
		if string.match(model_pabx, "NEC") then
			outbound_number = session:getVariable("sip_from_user_stripped");
			freeswitch.consoleLog("info", outbound_number .. " e texto  1 \n");
			if string.match(outbound_number, "%a") then
                        	freeswitch.consoleLog("info", outbound_number .. " e texto \n");
                        	sql_ecf = "SELECT * FROM tronco_nec WHERE nome_destino = '";
                        	sql_ecf = sql_ecf .. outbound_number;
                        	sql_ecf = sql_ecf .. "';";

                        	freeswitch.consoleLog("info", sql_ecf .. " pesquisa \n");

                        	fsData:query(sql_ecf,function(row)
                                	piloto = string.gsub(row.piloto, "%s+", "");
                                	freeswitch.consoleLog("info", piloto .. " numero \n");
                        	end);
                        	if piloto ~= nil then
                                	outbound_number = piloto;
                                	session:setVariable("caller_id_number", piloto);
                        	end
				fsData:release();
			end
		end
	end
	if extension_uuid ~= nil then
		idData = freeswitch.Dbh(dsf);
		consultaUUID = "SELECT extension_uuid, extension FROM v_extensions where extension_uuid = '" .. extension_uuid .."';";
                idData:query(consultaUUID,function(row)
                        outbound_number = row.extension
                end);
                idData:release()

		--freeswitch.consoleLog("notice", "extension_uuid de chamada para callerid o sigam-me/saida .: " .. extension_uuid .. "\n")
	end
	if outbound_number ~= nil then
		cpr_outbound = string.len(outbound_number);
	else
		outbound_number = session:getVariable("sip_from_user");
	end
	if cpr_outbound ~= nil then
		if cpr_outbound > 4 then
			local ctr = cpr_outbound - 3;
			outbound_number = string.sub(outbound_number,ctr,cpr_outbound);
		end
	end
	if outbound_prefix ~= nil  and outbound_number ~= nil then
		numero_normalizado = outbound_prefix .. outbound_number;
	end
	if numero_normalizado ~= nil then
		session:setVariable("effective_caller_id_name", numero_normalizado);
		session:setVariable("effective_caller_id_number", numero_normalizado);
		session:setVariable("caller_id_number", numero_normalizado);
		session:setVariable("caller_id_name", numero_normalizado);
	end
	
