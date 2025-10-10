--[[
--	MODULO USADO PARA DEFINIR O NUMERO COMPLETO DE UMA RAMAL BASEADO EM NUMEROS,
--	BASEADO NO NUMERO DE DESTINO E CONTEXTO EM QUE A CHAMADA ESTA TRAFEGANDO. 
--	SAO FEITAS AS DEFINICOES DO NUMERO COMPLETO COM O DDD-PREFIXO-MCDU.
--	OCORREM OUTRAS DEFINICOES IMPORTANTES PARA O ENCAMINHAMENTO DE CHAMADAS ENTRE OS DOMINIOS.
--]]

local userdata = {}

function userdata.set_userdata(user_context,extension_number)
	 if user_context == "fs-cwb.tjpr.jus.br" then
                codigo_area_ramal_origem = "41";
		codigo_voip_ramal_origem = "1100";
                conurbada = true;
                if string.find(extension_number, "^63[0-9][0-9]") then
                        ramal_saida = '413250' .. extension_number;
                elseif string.find(extension_number, "^65[0-9][0-9]") then
                        ramal_saida = '413250' .. extension_number;
                elseif string.find(extension_number, "^67[0-9][0-9]") then
                        ramal_saida = '413250' .. extension_number;
                elseif string.find(extension_number, "^50[5-9][0-9]") then
                        ramal_saida = '413250' .. extension_number;
                elseif string.find(extension_number, "^[2-4][0-9][0-9][0-9]") then
                        ramal_saida = '413200' .. extension_number;
                elseif string.find(extension_number, "^[7-8][0-9][0-9][0-9]") then
                        ramal_saida = '413210' .. extension_number;
                elseif string.find(extension_number, "^5[7-9][0-9][0-9]") then
                        ramal_saida = '413228' .. extension_number;
                elseif string.find(extension_number, "^9[5-8][0-9][0-9]") then
                        ramal_saida = '413221' .. extension_number;
                elseif string.find(extension_number, "^9[1-4][0-9][0-9]") then
                        ramal_saida = '413309' .. extension_number;
                elseif string.find(extension_number, "^53[0-9][0-9]") then
                        ramal_saida = '413312' .. extension_number;
                elseif string.find(extension_number, "^6[0-2][0-9][0-9]") then
                        ramal_saida = '413312' .. extension_number;
                elseif string.find(extension_number, "^69[0-9][0-9]") then
                        ramal_saida = '413312' .. extension_number;
                elseif string.find(extension_number, "^1[7-8][0-9][0-9]") then
                        ramal_saida = '413250' .. extension_number;
                end
        elseif user_context == "fs-int.tjpr.jus.br" then
		codigo_voip_ramal_origem = "1101";
                conurbada = true;
                if string.find(extension_number, "^5[0-3][0-9][0-9]") then
                        codigo_area_ramal_origem = "45";
                        ramal_saida = '453392' .. extension_number;
                elseif string.find(extension_number, "^8[0-3][0-9][0-9]") then
                        codigo_area_ramal_origem = "45";
                        ramal_saida = '453308' .. extension_number;
                elseif string.find(extension_number, "^7[4-7][0-9][0-9]") then
                        codigo_area_ramal_origem = "42";
                        ramal_saida = '423308' .. extension_number;
                elseif string.find(extension_number, "^3[2-7][0-9][0-9]") then
                        codigo_area_ramal_origem = "43";
                        ramal_saida = '433572' .. extension_number;
                elseif string.find(extension_number, "^2[3-7][0-9][0-9]") then
                        codigo_area_ramal_origem = "44";
                        ramal_saida = '443472' .. extension_number;
                elseif string.find(extension_number, "^1[6-9][0-9][0-9]") then
                        codigo_area_ramal_origem = "42";
                        ramal_saida = '423309' .. extension_number;
                end
        elseif user_context == "fs-lcr41.tjpr.jus.br" then
                conurbada = true;
                perfil_pesquisa = "curitiba_area_conurbada"
                codigo_area_ramal_origem = "41";
                codigo_voip_ramal_origem = "1051";
		ramal_saida = '413263' .. extension_number;
        elseif user_context == "fs-lcr42.tjpr.jus.br" then
                conurbada = true;
                perfil_pesquisa = "pgo_area_conurbada"
                codigo_area_ramal_origem = "42";
                codigo_voip_ramal_origem = "1052";
                ramal_saida = '423309' .. extension_number;
        elseif user_context == "fs-lcr43.tjpr.jus.br" then
                conurbada = true;
                perfil_pesquisa = "londrina_area_conurbada"
                codigo_area_ramal_origem = "43";
                codigo_voip_ramal_origem = "1053";
		ramal_saida = '433572' .. extension_number;
        elseif user_context == "fs-lcr44.tjpr.jus.br" then
		conurbada = true;
                perfil_pesquisa = "maringa_area_conurbada"
                codigo_area_ramal_origem = "44";
                codigo_voip_ramal_origem = "1054";
                ramal_saida = '443259' .. extension_number;
        elseif user_context == "fs-lcr45.tjpr.jus.br" then
		conurbada = true;
                perfil_pesquisa = "cascavel_area_conurbada"
                codigo_area_ramal_origem = "45";
                codigo_voip_ramal_origem = "1055";
                ramal_saida = '453327' .. extension_number;
        elseif user_context == "fs-lcr46.tjpr.jus.br" then
		conurbada = true;
                perfil_pesquisa = "francisco_beltrao_area_conurbada"
                codigo_area_ramal_origem = "46";
                codigo_voip_ramal_origem = "1056";
                ramal_saida = '463905' .. extension_number;
        end
	local data_returned = {
		ramal_saida = ramal_saida,
		codigo_area_ramal_origem = codigo_area_ramal_origem,
		codigo_voip_ramal_origem = codigo_voip_ramal_origem,
		perfil_pesquisa = tostring(perfil_pesquisa),
		conurbada = conurbada
	}
	return data_returned
end
return userdata
