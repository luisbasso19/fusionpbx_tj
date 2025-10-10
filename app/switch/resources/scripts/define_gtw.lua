
local Database = require "resources.functions.database"

local dsn = session:getVariable("dsn");

local fsData = freeswitch.Dbh(dsn);

local inbound_number = session:getVariable("destination_number");

local model_pabx = session:getVariable("sip_user_agent");

local domain_name = session:getVariable("domain_name");

--if model_pabx ~= nil then
--	if string.match(model_pabx, "NEC") then
--		outbound_number = session:getVariable("sip_from_user_stripped");
--		if string.match(outbound_number, "%a") then
--			freeswitch.consoleLog("info", outbound_number .. " e texto \n");
--			sql_ecf = "SELECT * FROM tronco_nec WHERE nome_destino = '";
--			sql_ecf = sql_ecf .. outbound_number;
--			sql_ecf = sql_ecf .. "';";

--			freeswitch.consoleLog("info", sql_ecf .. " pesquisa \n");

--			fsData:query(sql_ecf,function(row)
--				piloto = string.gsub(row.piloto, "%s+", "");

--				freeswitch.consoleLog("info", piloto .. " numero \n");
--			end)
--			if piloto ~= nil then
--				outbound_number = piloto;
--				session:setVariable("caller_id_number", piloto);
--			end
--		end
--	end
--end

if inbound_number == nil then
	freeswitch.consoleLog("info", "NUMERO RECEBIDO E INVALIDO");
else

	cod_origem = string.sub(inbound_number,0,4);
	sql = "SELECT * FROM define_gateway WHERE origem_chamada = '";
	sql = sql .. cod_origem;
	sql = sql .. "';";
end

--freeswitch.consoleLog("info",sql  ..  " valore pesquisa");

fsData:query(sql,function(row)
	codigo_gateway = string.gsub(row.codigo_gateway, "%s+", "");
	area_conurbada = string.gsub(row.conurbada, "%s+", "");
	codigo_area = string.gsub(row.codigo_area, "%s+", "");
end)

fsData:release();

if codigo_gateway == nil then
	session:hangup("USER_BUSY");
else
	session:setVariable("codigo_gateway", codigo_gateway);
	session:setVariable("area_conurbada", area_conurbada);
	session:setVariable("codigo_area", codigo_area);
	freeswitch.consoleLog("info",codigo_gateway .. " - " .. area_conurbada ..  " valores do gateway");
end

