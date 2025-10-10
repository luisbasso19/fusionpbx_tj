

--include config.lua
        require "resources.functions.config";

--add the function
        require "resources.functions.explode";
        require "resources.functions.trim";
        require "resources.functions.channel_utils";



--Get intercept logger
        local log = require "resources.functions.log".intercept

	local dsf = session:getVariable("dsf");

	local outbound_number = session:getVariable("outbound_caller_id_number");
	extension_uuid = session:getVariable("extension_uuid");
        if extension_uuid ~= nil then
                fsData = freeswitch.Dbh(dsf);
                consultaUUID = "SELECT extension_uuid, extension FROM v_extensions where extension_uuid = '" .. extension_uuid .."';";
                fsData:query(consultaUUID,function(row)
                        outbound_number = row.extension
                end);
                fsData:release()
	else
		outbound_number = session:getVariable("sip_to_user");
		if outbound_number == nil then
			outbound_number = session:getVariable("caller_id_number");
		end
        end




--	outbound_number = session:getVariable("outbound_caller_id_number");
	if outbound_number ~= nil then
		cpr_outbound = string.len(outbound_number);
	else
		--outbound_number = session:getVariable("sip_from_user");
		outbound_number = session:getVariable("sip_to_user");
                if outbound_number ~= nil then
                        cpr_outbound = string.len(outbound_number);
                end
	end
	if cpr_outbound ~= nil then
		if cpr_outbound > 4 then
			local ctr = cpr_outbound - 3;
			outbound_number = string.sub(outbound_number,ctr,cpr_outbound);
		end
	end

	--freeswitch.consoleLog("info", outbound_number .. " ramal analise");
	if string.find(outbound_number, "^5[0-3][0-9][0-9]") then
		cod_dest = 66009;
		ramal_saida = '453392' .. outbound_number;
		--ramal_saida = outbound_number;
		session:setVariable("outbound_caller_id_number", ramal_saida);
		session:setVariable("effective_caller_id_number", ramal_saida);
	elseif string.find(outbound_number, "^8[0-3][0-9][0-9]") then
		cod_dest = 66010;
		ramal_saida = '453308' .. outbound_number;
		session:setVariable("outbound_caller_id_number", ramal_saida);
		session:setVariable("effective_caller_id_number", ramal_saida);
	elseif string.find(outbound_number, "^7[4-7][0-9][0-9]") then
		cod_dest = 66011;
		ramal_saida = '423308' .. outbound_number;
		session:setVariable("outbound_caller_id_number", ramal_saida);
	elseif string.find(outbound_number, "^3[2-7][0-9][0-9]") then
		cod_dest = 66012;
		ramal_saida = '433572' .. outbound_number;
		session:setVariable("outbound_caller_id_number", ramal_saida);
	elseif string.find(outbound_number, "^2[3-7][0-9][0-9]") then
		cod_dest = 66013;
		ramal_saida = '443472' .. outbound_number;
		session:setVariable("outbound_caller_id_number", ramal_saida);
	elseif string.find(outbound_number, "^1[6-9][0-9][0-9]") then
		cod_dest = 66014;
		ramal_saida = '423309' .. outbound_number;
		session:setVariable("outbound_caller_id_number", ramal_saida);
	end


	if cod_dest == nil then
		session:setVariable("codigo_destino", "");
	else
		--session:setVariable("outbound_caller_id_number", ramal_saida);
		session:setVariable("codigo_destino", cod_dest);
	end

