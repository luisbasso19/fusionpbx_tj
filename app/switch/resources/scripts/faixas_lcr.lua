local Database = require "resources.functions.database"

local dsn = session:getVariable("dsn");

local fsData = freeswitch.Dbh(dsn);

local inbound_number = session:getVariable("numero_recebido");

if inbound_number == nil then
	inbound_number = session:getVariable("numero_entrada");
end

local domain_name = session:getVariable("domain_name");

if inbound_number == nil then
	freeswitch.consoleLog("info", "NUMERO RECEBIDO E INVALIDO");
else
	ramal = string.sub(inbound_number,7,11);
	sql = "SELECT * FROM faixas_lcr WHERE faixa @> '";
	sql = sql .. inbound_number;
	sql = sql .. "' AND domain_name = '";
	sql = sql .. domain_name;
	sql = sql .. "';";
end
if sql == nil then
	freeswitch.consoleLog("notice", "SEM PESQUISA");
	session:execute("respond", "404");
else
	fsData:query(sql,function(row)
		codigo_destino = row.codigo_destino;
	end)
end

fsData:release();

if codigo_destino == nil then
	freeswitch.consoleLog("info", "NUMERO INTERNO");
	--session:execute("respond", "404");
else
	local numero_discado = codigo_destino .. ramal;
	freeswitch.consoleLog("info", numero_discado .. " Numero para acesso a outro central");
	session:transfer(numero_discado, "XML", "ligacoes_saintes");
end
