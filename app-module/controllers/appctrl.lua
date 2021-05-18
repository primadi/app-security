local data = require 'utils.data'
local entity = require 'utils.entity'

local exports = {}

exports.app = entity.new {
    spacename = 'APP',
    fieldNames = { 'appid', 'name', 'description', 'isactive' },
    -- listMaxCount = 1,
    -- listSql = 'SELECT appid, name FROM app WHERE appid>?',
    numPrimaryKey = 1,
    defaultValue = {
        description = '',
        isactive = true
    },
    validateEntity = function (p)
        if p['name'] == '' then
            return {
                errcode = 11,
                description = 'name is empty'
            }
        end
        return nil
    end
}

exports.appsetting = entity.new {
    spacename = 'APPSETTING',
    fieldNames = { 'appid', 'settingid', 'value', 'description'},
    numPrimaryKey = 2,
    defaultValue = {
        value = '',
        description = ''
    },
    validateEntity = function (p)
        if data.isKeyExists('APP', p['appid']) == false then
            return {
                errcode = 11,
                description = 'App Id ' .. p['appid'] .. ' not found'
            }
        end
        return nil
    end
}

exports.appmodule = entity.new {
    spacename = 'APPMODULE',
    fieldNames = { 'appid', 'moduleid', 'modulename', 'moduleurl',
        'description', 'isactive', 'moduleorder' },
    numPrimaryKey = 2,
    defaultValue = {
        description = '',
        isactive = true,
        moduleorder = 0
    },
    validateEntity = function (p)
        if data.isKeyExists('APP', p['appid']) == false then
            return {
                errcode = 11,
                description = 'App Id ' .. p['appid'] .. ' not found'
            }
        end
        return nil
    end
}

exports.appmodulevar = entity.new {
    spacename = 'APPMODULEVAR',
    fieldNames = { 'appid', 'moduleid', 'varname', 'defaultvalue',
        'vartype', 'description' },
    numPrimaryKey = 3,
    defaultValue = {
        description = '',
        vartype = 0
    },
    validateEntity = function (p)
        if data.isKeyExists('APPMODULE', { p['appid'], p['moduleid'] }) == false then
            return {
                errcode = 11,
                description = 'Module Id ' .. p['appid'] .. '.' .. p['moduleid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.approle = entity.new {
    spacename = 'APPROLE',
    fieldNames = { 'appid', 'roleid', 'rolename', 'description' },
    numPrimaryKey = 2,
    defaultValue = {
        description = ''
    },
    validateEntity = function (p)
        if data.isKeyExists('APP', p['appid']) == false then
            return {
                errcode = 11,
                description = 'App Id ' .. p['appid'] .. ' not found'
            }
        end
        return nil
    end
}

exports.approlemodule = entity.new {
    spacename = 'APPROLEMODULE',
    fieldNames = { 'appid', 'roleid', 'moduleid' },
    numPrimaryKey = 3,
    defaultValue = {},
    validateEntity = function (p)
        if data.isKeyExists('APPROLE', { p['appid'], p['roleid'] }) == false then
            return {
                errcode = 11,
                description = 'Role Id ' .. p['appid'] .. '.' .. p['roleid'] .. ' not found'
            }
        end
        if data.isKeyExists('APPMODULE', { p['appid'], p['moduleid'] }) == false then
            return {
                errcode = 12,
                description = 'Module Id ' .. p['appid'] .. '.' .. p['moduleid'] .. ' not found'
            }
        end        
        return nil
    end
}

exports.approlemodulevar = entity.new {
    spacename = 'APPROLEMODULEVAR',
    fieldNames = { 'appid', 'roleid', 'moduleid', 'varname', 'varvalue' },
    numPrimaryKey = 4,
    defaultValue = {},
    validateEntity = function (p)
        if data.isKeyExists('APPROLEMODULE', { p['appid'], p['roleid'], p['moduleid'] }) == false then
            return {
                errcode = 11,
                description = 'RoleModule Id ' .. p['appid'] .. '.' .. p['roleid'] .. 
                    '.' .. p['moduleid'] .. ' not found'
            }
        end
        return nil
    end
}

return exports