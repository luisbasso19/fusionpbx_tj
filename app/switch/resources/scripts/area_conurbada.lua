
local lcr_auto_route = argv[1];
if (session:ready()) then
	if lcr_auto_route ~= nil then
		session:consoleLog("info", "DEBUG VALOR LCR_AUTO_ROUTE " .. lcr_auto_route);
	else
		session:consoleLog("info", "DEBUG - lcr_auto_route VAZIA");
	end
	if lcr_auto_route == nil then
		session:consoleLog("info", "Número não pertence à área conurbada");
		inbound_number = session:getVariable("num_discado");
		codigo_area = session:getVariable("codigo_chamada");
		portado = session:getVariable("portado");
		if codigo_area == nil then
			codigo_area = session:getVariable("codigo_area");
		end
		--codigo modificado para a portabilidade
		if portado ~= nil then
			session:consoleLog("info", "DEBUG - valor portado " .. portado);
		else
			 session:consoleLog("info", "DEBUG - portado VAZIA");
		end
		if portado == nil or portado == 'NO' then
			operadora = session:getVariable("operadora");
		else
			operadora = "43"
		end
		--fim do codigo modificado para a portabilidade
		gateway = session:getVariable("codigo_gateway"); --usado para integrar nec
		if inbound_number ~= nil then
			tamanho = string.len(inbound_number);
			comeco = tamanho - 7;
			numero = string.sub(inbound_number, comeco);
		else
			numero = "";
		end
		if gateway ~= nil then --usado para integrar nec
			resultado = gateway ..  "0"; --usado para integrar nec
			resultado = resultado .. operadora; --usado para integrar nec
			resultado = resultado .. codigo_area; --usado para integrar nec
			resultado = resultado .. numero; --usado para integrar nec
			session:consoleLog("info", resultado .. "Número discado"); --usado para integrar nec
			session:transfer(resultado, "XML", "ligacoes_saintes"); --usado para integrar nec
		else --usado para integrar nec	
			num_discado = "0" .. operadora .. codigo_area .. numero;
			session:consoleLog("info", num_discado .. " Número discado");
			session:setVariable("num_discado", num_discado);
		end --usado para integrar nec
	else
		local comprimento = string.len(lcr_auto_route);
		--local inicio = comprimento - 14; comentado 16-01-25
		local inicio = comprimento - 7;

		local resultante = string.sub(lcr_auto_route,inicio)
		session:consoleLog("info", lcr_auto_route);
		session:consoleLog("info", resultante .. " Número discado");
		--session:transfer(resultante, "XML", "ligacoes_saintes"); comentado 16-01-25
		session:setVariable("num_discado", resultante);
	end
end



