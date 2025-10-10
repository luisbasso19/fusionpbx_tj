

api = freeswitch.API()

cpf_number = argv[1]



domain_name = session:getVariable("user_context");


session:consoleLog("info", "O cpf e.: " .. tostring(cpf_number) .. "\n")

local valida_cpf = require("recursos.functions.valida_cpf")


cpf = valida_cpf.valida(cpf_number)

--session:consoleLog("info", "O cpf e.: " .. tostring(cpf) .. "\n")

if cpf == true then
	--session:consoleLog("info", "O cpf e.: " .. tostring(cpf) .. "\n")
	session:execute("export", "call_direction=local")
	session:execute("export", "domain_name=fusionpbx.tjpr.jus.br")
	session:transfer(cpf_number, "XML", "fusionpbx.tjpr.jus.br")
end
