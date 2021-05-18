local data = require 'utils.data'
local entity = require 'utils.entity'

local exports = {}

exports.client = entity.new {
    spacename = 'CLIENT',
    fieldNames = { 'clientid', 'name', 'contactperson', 'email', 'phonenumber', 'description', 'isactive' },
    numPrimaryKey = 1,
    defaultValue = {
        name = '',
        contactperson = '',
        email = '',
        phonenumber = '',
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

exports.clientapp = entity.new {
    spacename = 'CLIENTAPP',
    fieldNames = { 'clientid', 'appid', 'isactive', 'expireddate' },
    numPrimaryKey = 2,
    defaultValue = {
        isactive = true
    },
    validateEntity = function (p)
        if data.isKeyExists('CLIENT', p['clientid']) == false then
            return {
                errcode = 11,
                description = 'Client Id ' .. p['clientid'] .. ' not found'
            }
        end

        if data.isKeyExists('APP', p['appid']) == false then
            return {
                errcode = 12,
                description = 'App Id ' .. p['appid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.clientapprole = entity.new {
    spacename = 'CLIENTAPPROLE',
    fieldNames = { 'clientid', 'appid', 'roleid' },
    numPrimaryKey = 3,
    defaultValue = {},
    validateEntity = function (p)
        if data.isKeyExists('CLIENTAPP', { p['clientid'], p['appid'] }) == false then
            return {
                errcode = 11,
                description = 'App Id ' .. p['clientid'] .. '.' .. p['appid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.clientapprolemodule = entity.new {
    spacename = 'CLIENTAPPROLEMODULE',
    fieldNames = { 'clientid', 'appid', 'roleid', 'moduleid' },
    numPrimaryKey = 4,
    defaultValue = { },
    validateEntity = function (p)
        if data.isKeyExists('CLIENTAPPROLE', { p['clientid'], p['appid'], p['roleid'] }) == false then
            return {
                errcode = 11,
                description = 'Role Id ' .. p['clientid'] .. '.' .. 
                    p['appid'] .. '.' .. p['roleid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.clientapprolemodulevar = entity.new {
    spacename = 'CLIENTAPPROLEMODULEVAR',
    fieldNames = { 'clientid', 'appid', 'roleid', 'moduleid', 'varname', 'varvalue' },
    numPrimaryKey = 5,
    defaultValue = { },
    validateEntity = function (p)
        if data.isKeyExists('CLIENTAPPROLEMODULE', { p['clientid'], p['appid'], 
            p['roleid'], p['moduleid'] }) == false then
            return {
                errcode = 11,
                description = 'Role Id ' .. p['clientid'] .. '.' .. 
                    p['appid'] .. '.' .. p['roleid'] .. '.' .. p['moduleid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.clientappsetting = entity.new {
    spacename = 'CLIENTAPPSETTING',
    fieldNames = { 'clientid', 'appid', 'settingid', 'value' },
    numPrimaryKey = 3,
    defaultValue = { },
    validateEntity = function (p)
        if data.isKeyExists('CLIENTAPP', { p['clientid'], p['appid'] }) == false then
            return {
                errcode = 11,
                description = 'App Id ' .. p['clientid'] .. '.' .. p['appid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.clientbranch = entity.new {
    spacename = 'CLIENTBRANCH',
    fieldNames = { 'clientid', 'branchid', 'branchname', 'address', 'phonenumber', 'isactive' },
    numPrimaryKey = 2,
    defaultValue = {
        branchname = '',
        address = '',
        phonenumber = '',
        isactive = true
    },
    validateEntity = function (p)
        if data.isKeyExists('CLIENT', p['clientid']) == false then
            return {
                errcode = 11,
                description = 'Client Id ' .. p['clientid'] .. ' not found'
            }
        end

        return nil
    end
}

exports.clientappuser = entity.new {
    spacename = 'CLIENTAPPUSER',
    fieldNames = { 'clientid', 'appid', 'username', 'password', 'isactive', 'email', 'phonenumber' },
    numPrimaryKey = 3,
    defaultValue = {
        isactive = true,
        email = '',
        phonenumber = ''
    },
    validateEntity = function (p)
        if data.isKeyExists('CLIENTAPP', {p['clientid'], p['appid']}) == false then
            return {
                errcode = 11,
                description = 'App Id ' .. p['clientid'] .. '.' .. p['appid'] ' not found'
            }
        end

        -- TODO: password requirement validation

        return nil
    end
}

exports.clientappuserrolebranch = entity.new {
    spacename = 'CLIENTAPPUSERROLEBRANCH',
    fieldNames = { 'clientid', 'appid', 'username',  'roleid', 'branchid' },
    numPrimaryKey = 5,
    defaultValue = {},
    validateEntity = function (p)
        if data.isKeyExists('CLIENTAPPUSER', { p['clientid'], p['appid'], p['username'] }) == false then
            return {
                errcode = 11,
                description = 'User Name ' .. p['appid'] .. '.' 
                    .. p['username'] .. ' not found'
            }
        end

        if data.isKeyExists('CLIENTBRANCH', { p['clientid'], p['branchid'] }) == false then
            return {
                errcode = 12,
                description = 'Branch Id ' .. p['branchid'] .. ' not found'
            }
        end

        if data.isKeyExists('CLIENTAPPROLE', { p['clientid'], p['appid'], p['roleid'] }) == false then
            return {
                errcode = 13,
                description = 'Role Id ' .. p['appid'] .. '.' .. p['roleid'] .. ' not found'
            }
        end

        return nil
    end
}

return exports