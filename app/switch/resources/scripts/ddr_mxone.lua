
local lcr_auto_route = argv[1];
if lcr_auto_route == nil then
	session:consoleLog("info", "Número não pertence ao TJPR");
else
	session:consoleLog("info",lcr_auto_route .. " Número recebido");
	local comprimento = string.len(lcr_auto_route);
	local inicio = comprimento - 7;
	local resultante = string.sub(lcr_auto_route,inicio);
	session:consoleLog("info",resultante .. " Número resultate");
	session:setVariable("call_direction", "local");
	session:transfer(resultante, "XML", "ligacoes_saintes");
end



