-- cpf.lua
-- Módulo para validação de CPF em Lua (retorna true/false)

local M = {}

local function only_digits(s)
  return (tostring(s or ""):gsub("%D", ""))
end

local function is_repeated_sequence(s)
  return s:match("^(%d)%1+$") ~= nil
end

--- Valida CPF (com ou sem pontuação).
-- @param cpf string|number
-- @return boolean
function M.valida(cpf)
  local s = only_digits(cpf)
  if #s ~= 11 then return false end
  if is_repeated_sequence(s) then return false end

  -- 1º dígito verificador
  local soma = 0
  for i = 1, 9 do
    soma = soma + tonumber(s:sub(i, i)) * (11 - i) -- pesos 10..2
  end
  local resto = (soma * 10) % 11
  if resto == 10 or resto == 11 then resto = 0 end
  if resto ~= tonumber(s:sub(10, 10)) then return false end

  -- 2º dígito verificador
  soma = 0
  for i = 1, 10 do
    soma = soma + tonumber(s:sub(i, i)) * (12 - i) -- pesos 11..2
  end
  resto = (soma * 10) % 11
  if resto == 10 or resto == 11 then resto = 0 end
  if resto ~= tonumber(s:sub(11, 11)) then return false end

  return true
end

return M

