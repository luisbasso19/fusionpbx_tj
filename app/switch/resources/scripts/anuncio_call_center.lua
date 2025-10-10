--- Scriptname: anuncio.lua
--- Este script fornece anuncio de posição na fila
--
--

api = freeswitch.API()
caller_uuid = argv[1]
queue_name = argv[2]
--dominio = "fs-cwb.tjpr.jus.br"
dominio = api:executeString("uuid_getvar "..caller_uuid.." domain_name")
--tempo = 20000 
tempo = argv[3]
if caller_uuid == nil or queue_name == nil then
	return
end
pasta = "/dados/recordings/"
if dominio ~= nil then
	caminho = pasta .. dominio .. "/"
	posicao = caminho.."posicao.wav"
end

sessaoValida = api:executeString("uuid_exists "..caller_uuid);

if sessaoValida == "true" then
	while (sessaoValida == "true") do
		freeswitch.msleep(tempo);
		--if (session:ready() == true) then
		--	freeswitch.consoleLog("notice", "DEBUG - anuncio_call_center.lua verificando session ready " .. "\n")
		--end
		chamadas = api:executeString("callcenter_config queue list members " .. queue_name);
		pos = 1;
		exists = false;
		for call in chamadas:gmatch("[^\r\n]+") do
			if (string.find(call, "Trying") ~= nil or string.find(call, "Waiting") ~= nil) then
				if string.find(call, caller_uuid, 1, true) ~= nil then
					exists = true
					api:executeString("uuid_broadcast " .. caller_uuid .. " ".. posicao .. " aleg")
					api:executeString("uuid_broadcast " .. caller_uuid .. " " .. caminho .. pos .. ".wav aleg")
				end
				pos = pos + 1
			elseif (string.find(call, "Answered") ~= nil) then
				exists = false;
			end		
		end
		if (exists == true) then
			sessaoValida = api:executeString("uuid_exists "..caller_uuid);
		else
			sessaoValida = "false"
		end
	end
end

--freeswitch.consoleLog("notice", "DEBUG - anuncio_call_center.lua apos sair do loop uuid " .. caller_uuid .. "\n")
