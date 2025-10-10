--- Scriptname: anuncio.lua
--- Este script fornece anuncio de posição na fila
--
--

api = freeswitch.API()
caller_uuid = argv[1]
--queue_name = argv[2]
--dominio = "fs-cwb.tjpr.jus.br"
dominio = api:executeString("uuid_getvar "..caller_uuid.." domain_name")
tempo = 1
pasta = "/dados/recordings/"

sessaoValida = api:executeString("uuid_exists "..caller_uuid)

while (sessaoValida == "true") do
	--freeswitch.consoleLog("info", "uuid:  "..caller_uuid.."\n");
	sessaoValida = api:executeString("uuid_exists "..caller_uuid)
	--freeswitch.consoleLog("info", "uuid existe:  "..sessaoValida.."\n")
	--estadoChamada = api:executeString("uuid_getvar "..caller_uuid.." fifo_status");
	freeswitch.msleep(30000)
	position = api:executeString("uuid_getvar "..caller_uuid.." fifo_position")
	--freeswitch.consoleLog("info", "Chamador esta na posição: "..position.." uuid:"..caller_uuid.."\n");
	estadoChamada = api:executeString("uuid_getvar "..caller_uuid.." fifo_status");
	if (estadoChamada == "WAITING") then
		if (string.sub(position,1,4) ~= "-ERR") then
			position = tonumber(position)
			if (position >= 1) then
				caminho = pasta .. dominio .. "/"
				posicao = caminho.."posicao.wav"
				--freeswitch.consoleLog("info", "audios estao: "..caminho.."\n");
				api:executeString("uuid_broadcast " .. caller_uuid .. " ".. posicao .. " aleg")
				api:executeString("uuid_broadcast " .. caller_uuid .. " " .. caminho .. position .. ".wav aleg")
			end
		end
	end
end
