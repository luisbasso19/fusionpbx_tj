--include config.lua
        require "resources.functions.config";

--add the function
        require "resources.functions.explode";
        require "resources.functions.trim";
        require "resources.functions.channel_utils";


        api = freeswitch.API()

        local dsn = session:getVariable("dsn");

        local dsf = session:getVariable("dsf");


        local extension_uuid = session:getVariable("extension_uuid");

        local outbound_number = session:getVariable("outbound_caller_id_number");
        local outbound_prefix = session:getVariable("outbound_prefix");
	outbound_caller_id_number = session:getVariable("outbound_caller_id_number");
	forward_all_enabled = session:getVariable("forward_all_enabled");
	domain_name = session:getVariable("domain_name");
	origination_caller_id_number = session:getVariable("origination_caller_id_number");

        toll_allow = session:getVariable("toll_allow");
        if toll_allow ~= nil then
                session:consoleLog("info", "DEBUG - valor de toll_allow.:" .. toll_allow);
        else
                toll_allow = ""
                session:consoleLog("info", "DEBUG - toll allow vazio");
                session:hangup("OUTGOING_CALL_BARRED");
                session:execute("respond", "403");
        end

	session:consoleLog("info", "DEBUG - valor de domain_name.:" .. tostring(domain_name));
	session:consoleLog("info", "DEBUG - valor de origination_caller_id_number.:" .. tostring(origination_caller_id_number));

        codigo_area_ramal_origem = ""; -- ARMAZENA CODIGO DE AREA DO RAMAL DE ORIGEM BASEADO NO CONTEXTO.
        codigo_area_numero_destino = session:getVariable("codigo_area_numero_destino"); -- ARMAZENA CODIGO DE AREA DO NUMERO DE DESTINO.
        numero_discado = argv[1]
	csp_fidelizacao = session:getVariable("operadora"); --VARIAVEL COM A OPERADORA DE CSP PARA FIDELIZACAO

        if outbound_prefix == nil then
                outbound_prefix = "";
        end

        user_context = session:getVariable("user_context");	

	if user_context == "fusionpbx.tjpr.jus.br" then
		sip_from_user = session:getVariable("sip_from_user")
		if sip_from_user ~= nil then
			associated_uuid = api:executeString("user_data " .. sip_from_user .. "@" .. user_context .. " var associated_uuid")
			if  associated_uuid ~= nil then
				extension_uuid = associated_uuid
			end
			session:consoleLog("info", "DEBUG - VALOR DE from_user .:" .. tostring(sip_from_user));
		end
	end


        if extension_uuid ~= nil then
		session:consoleLog("info", "DEBUG - VALOR DE extension_uuid .:" .. extension_uuid);
                fsData = freeswitch.Dbh(dsf);
                consultaUUID = "SELECT extension_uuid, extension, user_context FROM v_extensions where extension_uuid = '" .. extension_uuid .."';";
                fsData:query(consultaUUID,function(row)
                        outbound_number = row.extension
			--INCLUSAO 15-08-2025 CORRECAO FALHA DO SIGA-ME QUE VINHA SEM USER_CONTEXT
			if user_context == nil or user_context == "fusionpbx.tjpr.jus.br" then
				user_context = row.user_context
				session:consoleLog("info", "DEBUG - VALOR DE user context .:" .. tostring(user_context));
			end
			--
                end);
                fsData:release()
        end
	if user_context ~= nil then
                user_context = string.gsub(user_context, " ", "")
                session:consoleLog("info", "DEBUG - VALOR DE CONTEXTO .:" .. user_context);
        else
		if user_context == nil and domain_name == nil then
	                user_context = false
		elseif domain_name ~= nil then
			user_context = domain_name
		else
			user_context = false		
		end

                session:consoleLog("info", "DEBUG - VALOR DE CONTEXTO .:" .. user_context);
                sip_from_host = session:getVariable("sip_from_host");
                if sip_from_host == "mxone-cwb-lim01-prd.tjpr.net" then
			sip_from_user_stripped = session:getVariable("sip_from_user_stripped")
			if sip_from_user_stripped ~= nil then
				session:consoleLog("info", "DEBUG - VALOR DE sip_from_user_stripped.:" .. sip_from_user_stripped);
				outbound_number = string.sub(sip_from_user_stripped, -4)
				session:consoleLog("info", "DEBUG - VALOR DE outbound_number.:" .. outbound_number);
			else
				session:consoleLog("info", "DEBUG - VALOR DE sip_from_user_stripped .:");
			end
                        user_context = "fs-cwb.tjpr.jus.br"
                elseif user_context == false then
                        session:consoleLog("info", "DEBUG - VALOR DE sip_from_host vazio .:");
			session:hangup("OUTGOING_CALL_BARRED");
                        session:execute("respond", "403");
                end     
        end

	if outbound_number == nil and origination_caller_id_number ~= nil then
		outbound_number = origination_caller_id_number
	end



	 if user_context == "fs-cwb.tjpr.jus.br" then
                codigo_area_ramal_origem = "41";
                if string.find(outbound_number, "^63[0-9][0-9]") then
                        ramal_saida = '413250' .. outbound_number;
                elseif string.find(outbound_number, "^65[0-9][0-9]") then
                        ramal_saida = '413250' .. outbound_number;
                elseif string.find(outbound_number, "^67[0-9][0-9]") then
                        ramal_saida = '413250' .. outbound_number;
                elseif string.find(outbound_number, "^50[5-9][0-9]") then
                        ramal_saida = '413250' .. outbound_number;
                elseif string.find(outbound_number, "^[2-4][0-9][0-9][0-9]") then
                        ramal_saida = '413200' .. outbound_number;
                elseif string.find(outbound_number, "^[7-8][0-9][0-9][0-9]") then
                        ramal_saida = '413210' .. outbound_number;
                elseif string.find(outbound_number, "^5[7-9][0-9][0-9]") then
                        ramal_saida = '413228' .. outbound_number;
                elseif string.find(outbound_number, "^9[5-8][0-9][0-9]") then
                        ramal_saida = '413221' .. outbound_number;
                elseif string.find(outbound_number, "^9[1-4][0-9][0-9]") then
                        ramal_saida = '413309' .. outbound_number;
                elseif string.find(outbound_number, "^53[0-9][0-9]") then
                        ramal_saida = '413312' .. outbound_number;
                elseif string.find(outbound_number, "^6[0-2][0-9][0-9]") then
                        ramal_saida = '413312' .. outbound_number;
                elseif string.find(outbound_number, "^69[0-9][0-9]") then
                        ramal_saida = '413312' .. outbound_number;
                elseif string.find(outbound_number, "^1[7-8][0-9][0-9]") then
                        ramal_saida = '413250' .. outbound_number;
                end
        elseif user_context == "fs-int.tjpr.jus.br" then
                if string.find(outbound_number, "^5[0-3][0-9][0-9]") then
                        codigo_area_ramal_origem = "45";
                        ramal_saida = '453392' .. outbound_number;
                elseif string.find(outbound_number, "^8[0-3][0-9][0-9]") then
                        codigo_area_ramal_origem = "45";
                        ramal_saida = '453308' .. outbound_number;
                elseif string.find(outbound_number, "^7[4-7][0-9][0-9]") then
                        codigo_area_ramal_origem = "42";
                        ramal_saida = '423308' .. outbound_number;
                elseif string.find(outbound_number, "^3[2-7][0-9][0-9]") then
                        codigo_area_ramal_origem = "43";
                        ramal_saida = '433572' .. outbound_number;
                elseif string.find(outbound_number, "^2[3-7][0-9][0-9]") then
                        codigo_area_ramal_origem = "44";
                        ramal_saida = '443472' .. outbound_number;
                elseif string.find(outbound_number, "^1[6-9][0-9][0-9]") then
                        codigo_area_ramal_origem = "42";
                        ramal_saida = '423309' .. outbound_number;
                end
        elseif user_context == "fs-lcr41.tjpr.jus.br" then
                codigo_area_ramal_origem = "41";
                ramal_saida = '413263' .. outbound_number;
        elseif user_context == "fs-lcr42.tjpr.jus.br" then
                codigo_area_ramal_origem = "42";
                ramal_saida = '423309' .. outbound_number;
        elseif user_context == "fs-lcr43.tjpr.jus.br" then
                codigo_area_ramal_origem = "43";
                ramal_saida = '433572' .. outbound_number;
        elseif user_context == "fs-lcr44.tjpr.jus.br" then
                codigo_area_ramal_origem = "44";
                ramal_saida = '443259' .. outbound_number;
        elseif user_context == "fs-lcr45.tjpr.jus.br" then
                codigo_area_ramal_origem = "45";
                ramal_saida = '453327' .. outbound_number;
        elseif user_context == "fs-lcr46.tjpr.jus.br" then
                codigo_area_ramal_origem = "46";
                ramal_saida = '463905' .. outbound_number;
	else
		session:consoleLog("info", "DEBUG - CHAMADA ORIGINADA NO.:" .. tostring(user_context) .. "\n");

        end
	if ramal_saida ~= nil then
                session:setVariable("effective_caller_id_number", ramal_saida);
		session:setVariable("call_direction", "outbound");
	else
		if outbound_caller_id_number ~= nil then
			session:setVariable("effective_caller_id_number", outbound_caller_id_number);
			session:setVariable("effective_caller_id_name", outbound_caller_id_number);
			session:setVariable("call_direction", "outbound");
		end
        end

	if codigo_area_numero_destino == nil then
                codigo_area_numero_destino = codigo_area_ramal_origem;
        end
	if codigo_area_numero_destino == codigo_area_ramal_origem then
		session:consoleLog("info", "DEBUG - CHAMADA LOCAL");
	else
		session:consoleLog("info", "DEBUG - CHAMADA INTERURBANA");
	end

	if numero_discado ~= nil then
		if codigo_area_numero_destino == codigo_area_ramal_origem then
			if string.find(string.lower(toll_allow),string.lower("celular")) then
	                	numero_enviado_gateway = numero_discado
        	        else
                		session:consoleLog("info", "CHAMADA NÃO PERMITIDA \n");
	                	session:hangup("OUTGOING_CALL_BARRED");
	        	        session:execute("respond", "403");
        	        end	
		else
			 if string.find(string.lower(toll_allow),string.lower("celular")) then
	                         numero_enviado_gateway = "0" ..  csp_fidelizacao .. codigo_area_numero_destino .. numero_discado
                        	 session:consoleLog("info", "Número não pertence a area conurbada");
                         else
                	         session:consoleLog("info", "CHAMADA NÃO PERMITIDA \n");
        	                 session:hangup("OUTGOING_CALL_BARRED");
	                         session:execute("respond", "403");
                         end
		end
		if numero_enviado_gateway ~= nil then
                        session:setVariable("call_direction", "outbound");
	                session:consoleLog("info", "Número discado.: " .. numero_enviado_gateway);
        	        session:setVariable("numero_enviado_gateway", numero_enviado_gateway);
                end

	else
                session:consoleLog("notice", "verifique o envio do numero discado .: \n")
        end
