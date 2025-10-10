

--include config.lua
        require "resources.functions.config";

--add the function
        require "resources.functions.explode";
        require "resources.functions.trim";
        require "resources.functions.channel_utils";
	--ocal Database = require "resources.functions.database"
	
	--dbh = Database.new('switch')


--Get intercept logger
        local log = require "resources.functions.log".intercept

	local dsf = session:getVariable("dsf");



	local outbound_number = session:getVariable("outbound_caller_id_number");
	extension_uuid = session:getVariable("extension_uuid");
	user_context = session:getVariable("user_context");
	user_context = string.gsub(user_context, " ", "")
	if extension_uuid ~= nil then
		fsData = freeswitch.Dbh(dsf);
		consultaUUID = "SELECT extension_uuid, extension FROM v_extensions where extension_uuid = '" .. extension_uuid .."';";
		fsData:query(consultaUUID,function(row)
			outbound_number = row.extension
		end);
		fsData:release()

	else
		outbound_number = session:getVariable("sip_to_user");
		--freeswitch.consoleLog("notice", "extension uuid vazio \n")
		if outbound_number == nil then
			outbound_number = session:getVariable("caller_id_number");
		end
	--	session:execute("info")
	end
	if outbound_number ~= nil then
		cpr_outbound = string.len(outbound_number);
		--freeswitch.consoleLog("notice", "DEBUG extension outbound " .. outbound_number .. " \n")
	else
	--	outbound_number = session:getVariable("sip_from_user");
		outbound_number = session:getVariable("sip_to_user");

		if outbound_number ~= nil then
			--freeswitch.consoleLog("notice", "extension outbound " .. outbound_number .. " \n")
			cpr_outbound = string.len(outbound_number);
		end
	end
	if cpr_outbound ~= nil then
		if cpr_outbound > 4 then
			local ctr = cpr_outbound - 3;
			outbound_number = string.sub(outbound_number,ctr,cpr_outbound);
		end
	end

	if user_context == "fs-cwb.tjpr.jus.br" then	
		if string.find(outbound_number, "^63[0-9][0-9]") then
			--cod_dest = 66001;
			ramal_saida = '413250' .. outbound_number;
			session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^65[0-9][0-9]") then
			--cod_dest = 66001;
			ramal_saida = '413250' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^67[0-9][0-9]") then
			--cod_dest = 66001;
			ramal_saida = '413250' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^50[5-9][0-9]") then
        	        --cod_dest = 66001;
                	ramal_saida = '413250' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^[2-4][0-9][0-9][0-9]") then
			--cod_dest = 66002;
			ramal_saida = '413200' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^[7-8][0-9][0-9][0-9]") then
			--cod_dest = 66003;
			ramal_saida = '413210' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^5[7-9][0-9][0-9]") then
			--cod_dest = 66004;
			ramal_saida = '413228' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^9[5-8][0-9][0-9]") then
			--cod_dest = 66005;
			ramal_saida = '413221' .. outbound_number;
                	session:setVariable("outbound_caller_id_number", ramal_saida)
		elseif string.find(outbound_number, "^9[1-4][0-9][0-9]") then
			--cod_dest = 66006;
			ramal_saida = '413309' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^53[0-9][0-9]") then
			--cod_dest = 66007;
			ramal_saida = '413312' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^6[0-2][0-9][0-9]") then
			--cod_dest = 66007;
			ramal_saida = '413312' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^69[0-9][0-9]") then
			--cod_dest = 66007;
			ramal_saida = '413312' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
		elseif string.find(outbound_number, "^1[7-8][0-9][0-9]") then
			--cod_dest = 66008;
			ramal_saida = '413250' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
		--elseif string.find(outbound_number, "^50[5-9][0-9]") then
			--cod_dest = 66001;
		end
	elseif user_context == "fs-int.tjpr.jus.br" then
		if string.find(outbound_number, "^5[0-3][0-9][0-9]") then
                	--cod_dest = 66009;
	                ramal_saida = '453392' .. outbound_number;
        	        --ramal_saida = outbound_number;
                	session:setVariable("outbound_caller_id_number", ramal_saida);
	                --session:setVariable("effective_caller_id_number", ramal_saida);
        	elseif string.find(outbound_number, "^8[0-3][0-9][0-9]") then
        	        --cod_dest = 66010;
                	ramal_saida = '453308' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
        	        --session:setVariable("effective_caller_id_number", ramal_saida);
	        elseif string.find(outbound_number, "^7[4-7][0-9][0-9]") then
        	        --cod_dest = 66011;
                	ramal_saida = '423308' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
        	elseif string.find(outbound_number, "^3[2-7][0-9][0-9]") then
                	--cod_dest = 66012;
	                ramal_saida = '433572' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
	        elseif string.find(outbound_number, "^2[3-7][0-9][0-9]") then
        	        --cod_dest = 66013;
                	ramal_saida = '443472' .. outbound_number;
	                session:setVariable("outbound_caller_id_number", ramal_saida);
        	elseif string.find(outbound_number, "^1[6-9][0-9][0-9]") then
                	--cod_dest = 66014;
	                ramal_saida = '423309' .. outbound_number;
        	        session:setVariable("outbound_caller_id_number", ramal_saida);
	        end
	elseif user_context == "fs-lcr41.tjpr.jus.br" then
		session:setVariable("outbound_prefix", "413263");
	end 
	--[[
	if cod_dest == nil then
		session:setVariable("codigo_destino", "");
	else
		session:setVariable("codigo_destino", cod_dest);
	end
	]]--
