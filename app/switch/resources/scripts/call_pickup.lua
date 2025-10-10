-- teste de replicacao 19052022
--dbh = freeswitch.Dbh("odbc://fusionpbx");
--
--
local Database = require "resources.functions.database"

--local dsn = session:getVariable("dsn");

local dbh = freeswitch.Dbh(database["system"]);

api = freeswitch.API()

local function seleciona_grupo_ramal()
	local sql = 'SELECT extension,domain_uuid,call_group FROM v_extensions WHERE domain_uuid = \'';
	local sql = sql .. domain_uuid .. '\'';
	local sql = sql .. ' AND ' .. 'extension = \'';
	local sql = sql .. caller_id_number .. '\';';

	dbh:query(sql,function(row)
		call_group = string.gsub(row.call_group, "%s+", "");
	end)
	if call_group ~= nil then
		return call_group
	else
		return nil
	end

end


	
if (session:ready() ) then
	session:answer();
	domain_uuid = session:getVariable("domain_uuid");
	context = session:getVariable("context");
        caller_id_number = session:getVariable("caller_id_number");

	if (caller_id_number ~= nil) then
		grupo =	seleciona_grupo_ramal()
	end
	if (grupo ~= nil) then
		session:consoleLog("info", grupo .. " grupo dos ramais");
		local dsn = session:getVariable("dsn");
		local fsData = freeswitch.Dbh(dsn);
		--local fsData = freeswitch.Dbh(database["switch"]);
		local sql = 'SELECT extension,domain_uuid,call_group FROM v_extensions WHERE domain_uuid = \'';
		local sql = sql .. domain_uuid .. '\' AND call_group = \'' ..  grupo .. '\';';
		--cham = 'SELECT dest, callstate, context, call_uuid FROM detailed_calls WHERE call_uuid NOTNULL AND callstate = \'RINGING\' AND ';
		cham = 'SELECT dest, callstate, context, call_uuid FROM detailed_calls WHERE call_uuid NOTNULL AND callstate = \'RINGING\' AND context = \'' .. context .. '\' AND ';
		lst = '(';
		dbh:query(sql, function(row)
			lst = lst .. 'dest = \'';
			lst = lst .. row.extension .. '\'';
			lst = lst .. ' OR ';
		end)
		dbh:release();
		local teste_cpr = string.len(lst);
                --session:consoleLog("info", "DEBUG - comprimento " .. teste_cpr .. "\n");
		if (teste_cpr == 1) then
			--teste = "(" .. lst;
			--lst = "(" .. lst;
			--local teste_cpr = string.len(lst);
			--session:consoleLog("info", "DEBUG - " .. lst .. "\n");
			--session:consoleLog("info", "DEBUG - comprimento " .. teste_cpr .. "\n");
		else
			--session:consoleLog("info", "DEBUG - LST DIFERENTE DE 1 \n");
		--end
			local cpr1 = string.len(lst);
			lst = string.sub(lst,0,(cpr1-4));
			lst = lst .. ') ORDER BY "created_epoch" DESC LIMIT 1;'
			cham = cham .. lst
			--session:consoleLog("info", "DEBUG - " .. cham .. " consulta banco");
			fsData:query(cham,function(row)
				dest = row.dest;
				callstate = row.callstate;
				call_uuid = row.call_uuid;
			end)
	
			if (call_uuid ~= nil) then
				---TJPR UPDATE CORRECAO CHAMADA PRESA
				consulta_uuid = "SELECT uuid,call_uuid,created,dest,cid_num, context FROM channels where call_uuid = \'" ..  call_uuid .."\';"
				fsData:query(consulta_uuid, function(row)
					created = row.created;
					context_bd = row.context;
				end)
				if created ~= nil then
					session:consoleLog("info", "DEBUG - uuid criado.: " .. created .. " - " .. consulta_uuid .. "\n");
				else
					session:consoleLog("info", "DEBUG - uuid criado.: " .. consulta_uuid .."\n");
				end
				--[[if dest ~= nil then
	                                session:consoleLog("info", "DEBUG - uuid a dest.: " .. dest .. "\n");
				end
				if callstate ~= nil then
					session:consoleLog("info", "DEBUG - uuid a callstate.: " .. callstate .. "\n");
				end]]--
				uuidExists = api:executeString("uuid_exists " .. call_uuid);
				if uuidExists ~= nil then
					session:consoleLog("info", "DEBUG - uuid a existe.: " .. uuidExists .. "\n");
				end
				--chamadaInterceptada = '-bleg ' .. call_uuid;
				--session:execute("intercept", chamadaInterceptada);
				session:execute("intercept", call_uuid);
			else
				session:hangup();
		end
			fsData:release();
		end
	else
		session:hangup();
	end
end

session:consoleLog("info", "DEBUG - uuid a ultima instrucao \n");
session:destroy()

