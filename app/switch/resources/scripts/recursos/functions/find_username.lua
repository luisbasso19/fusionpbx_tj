local username = {}
function username.find_username(associated_uuid)
	local Database = require "resources.functions.database"
        local json = require "resources.functions.lunajson"  -- só se quiser logar params
        local dbh = Database.new('system')  -- DB do FusionPBX (Postgres na maioria)
        local rows = {}
        local sql = [[
        	SELECT
                        vs.extension_setting_type,
                	vs.extension_setting_name,
                        vs.extension_setting_value,
                        ve.extension,
                        vd.domain_name
		FROM v_extension_settings vs
                JOIN v_extensions ve ON vs.extension_uuid = ve.extension_uuid
                JOIN v_domains vd ON ve.domain_uuid = vd.domain_uuid
                WHERE extension_setting_value = :extension_uuid
                AND extension_setting_name = 'associated_uuid'
                ORDER BY ve.extension
		]]
	local params = { extension_uuid = associated_uuid }
	username_contact = {}
	dbh:query(sql, params, function(row)
		username_contact[#username_contact+1] = row.extension .. "@" .. row.domain_name
	end)
	dbh:release()
	return username_contact
end
return username
