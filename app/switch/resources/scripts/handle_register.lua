--include config.lua
        require "resources.functions.config"

--include funcoes de texto
        require "recursos.functions.texto"

local Database    = require "resources.functions.database"

local user = event:getHeader("from-user") --
local domain = event:getHeader("domain_name") --
local useragent = event:getHeader("user-agent") --
local contact = "" --
local hora_local = event:getHeader("Event-Date-Local") --
local hora_gmt = event:getHeader("Event-Date-GMT") --
local network_ip = event:getHeader("network-ip") --
local auth_realm = event:getHeader("sip_auth_realm") --
local auth_user = event:getHeader("sip_auth_username") --
local reg_contact = event:getHeader("contact") --

--local dbh = freeswitch.Dbh(database["switch"])
--informações a serem adicionadas no log
--para controle de registros de aparelhos, serão gravadas as seguintes informacoes
--contact, ip de origem, horario, user name, dominio, e dominio de autenticacao

if hora_local == nil then hora_local = " " end
if hora_gmt == nil then hora_gmt = " " end
if network_ip == nil then network_ip = " " end
if auth_realm == nil then auth_realm = " " end
if auth_user == nil then auth_user = " " end
if reg_contact == nil then reg_contact = " " end


if user ~= nil and domain ~= nil then
        acesso = user .. "@" .. domain
elseif user ~= nil and domain == nil then
        freeswitch.consoleLog("notice", "Nome de dominio ausente" .. "\n")
        domain = " "
elseif user == nil and domain ~= nil then
        user = " "
        freeswitch.consoleLog("notice", "Nome de usuario ausente" .. "\n")
else
        freeswitch.consoleLog("notice", "Verificar dados recebidos" .. "\n")
end
if useragent ~= nil then
        if string.find(useragent, "^Linphone") then
                contact = reg_contact;
		local dbh = freeswitch.Dbh(database["switch"])
		local pn_prid = "";
		local pn_provider = "";
		local pn_param = "";
                if contact ~= nil then
                        contact_split = split(contact, ";")
                        for i,contact_info in pairs(contact_split) do
                                contact_temp = parse_contact(contact_info)
                                if (contact_temp) then
                                        if (contact_temp["pn-prid"]) then
						pn_prid = contact_temp["pn-prid"]
                                        elseif (contact_temp["pn-provider"]) then
						pn_provider = contact_temp["pn-provider"]
                                        elseif (contact_temp["pn-param"]) then
						pn_param = contact_temp["pn-param"]
                                        end
                                end
                        end
			query = string.format([[INSERT INTO registros ("hora_local", "hora_gmt", "usuario", domain, contact, networkIP, useragent, "pn_prid", "pn_provider", "pn_param") VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')]], hora_local, hora_gmt, user, domain, contact, network_ip, useragent, pn_prid, pn_provider, pn_param)
			dbh:query(query);
		end

        end
else
        useragent = " "
end
freeswitch.consoleLog("notice", "Registro.: " .. acesso .. " - " .. useragent .. " - " .. network_ip .. " - " .. auth_realm .. " - " .. auth_user .. "\n")

