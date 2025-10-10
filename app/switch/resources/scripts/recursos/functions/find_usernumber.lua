local usernumber = {}
function usernumber.find_usernumber(associated_uuid)
	local Database = require "resources.functions.database"
        local json = require "resources.functions.lunajson"  -- só se quiser logar params
        local dbh = Database.new('system')  -- DB do FusionPBX (Postgres na maioria)
        local rows = {}
        local sql = [[
		        SELECT
                		ve.extension,
		                ve.extension_uuid,
                		vd.domain_name
		        FROM v_extensions ve
		        JOIN v_domains vd ON ve.domain_uuid = vd.domain_uuid
		        WHERE ve.extension_uuid = :extension_uuid
        	]]
	local params = { extension_uuid = associated_uuid }
	dbh:query(sql, params, function(row)
		extension_associated = row.extension
	        domain_associated = row.domain_name
	end)
	dbh:release()
	local data_returned = {
		extension_associated = extension_associated,
		domain_associated = domain_associated
	}
	return data_returned
end
return usernumber
