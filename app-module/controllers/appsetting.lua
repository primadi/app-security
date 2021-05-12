local exports = {}
local string = require('utils.string')
local data = require('utils.data')

local function fnGetData(d)
    return {
        appid = d[1],
        settingid = d[2],
        value = d[3],
        settingdescr = d[4]
    }
end

-- for insert, replace
local function fnSetData(d)
    return {
        d['appid'],
        d['settingid'], 
        d['value'], 
        d['settingdescr']
    }
end

-- for insert, replace
local function fnGetDefaultValue()
    return {
        value = '',
        settingdescr = ''
    }
end

-- for insert, replace
local function fnValidateParam(d)
    -- search appid
    if data.isKeyExists('APP', d['appid']) == false then
        return {
            errcode = 11,
            errdescr = 'App Id ' .. d['appid'] .. ' not found'
        }
    end
    return nil
end

-- for insert, replace
local function fnGetParamKey(param)
    return {
        appid = param['appid'],
        settingid = param['settingid']
    }
end

-- for replace
local function fnOverwriteParam(param, req)
    param['appid'] = req:stash('appid')
    param['settingid'] = req:stash('settingid')
end

-- for get, delete
local function fnGetArrayKey(req)
    return { req:stash('appid'), req:stash('settingid') }
end

exports.insert = function(req)
    local params = req:post_param()
    params['appid'] = req:stash('appid')

    data.setDefaultValues(params, fnGetDefaultValue())

    local vp = fnValidateParam(params)
    if vp ~= nil then
        return req:render(data.renderError(vp.errcode, vp.errdescr))
    end

    local status, err = pcall(function() 
        box.space.APPSETTING:insert(fnSetData(params))    
    end)

    if status then
        return req:render(data.renderResult(fnGetParamKey(params)))
    end

    local errcode
    local errdescr = tostring(err)

    if string.startswith(errdescr, 'Duplicate key')  then
        errcode = 1
        errdescr = 'Duplicate SettingId'
    else
        errcode = 2
        errdescr = errdescr
    end

    return req:render(data.renderError(errcode, errdescr))
end

exports.getlist = function (req)
    local result = box.space.APPSETTING:select(req:stash('appid'))
    return req:render(data.renderArrayData(result, fnGetData))
end

exports.get = function (req)
    local result = box.space.APPSETTING:select(fnGetArrayKey(req))
    return req:render(data.renderSingleData(result, fnGetData))
end

exports.replace = function(req)
    local params = req:post_param()
    fnOverwriteParam(params, req)

    data.setDefaultValues(params, fnGetDefaultValue())

    local vp = fnValidateParam(params)
    if vp ~= nil then
        return req:render(data.renderError(vp.errcode, vp.errdescr))
    end
    
    local status, err = pcall(function() 
        box.space.APPSETTING:replace(fnSetData(params))    
    end)

    if status then
        return req:render(data.renderResult(fnGetParamKey(params)))
    end

    local errcode
    local errdescr = tostring(err)

    if string.startswith(errdescr, 'Duplicate key')  then
        errcode = 1
        errdescr = 'Duplicate SettingId'
    else
        errcode = 2
        errdescr = errdescr
    end

    return req:render(data.renderError(errcode, errdescr))
end

exports.delete = function(req)
    local key = fnGetArrayKey(req)
    local result
    local status, err = pcall(function() 
        result = box.space.APPSETTING:delete(key)    
    end)

    if status then
        local description
        if result ~= nil then
            description = 'found'
        else
            description = 'not found'
        end

        return req:render(data.renderResult({
            appid = key[1],
            settingid = key[2]
        }, description))
    end

    return req:render(data.renderError(2, tostring(err)))
end

return exports