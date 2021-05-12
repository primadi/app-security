local exports = {}
local string = require('utils.string')
local data = require('utils.data')

local function fnGetData(d)
    return {
        appid = d[1],
        name = d[2],
        appdescr = d[3],
        isactive = d[4]
    }
end

-- for insert, replace
local function fnSetData(d)
    return {
        d['appid'], 
        d['name'], 
        d['appdescr'], 
        d['isactive']
    }
end

-- for insert, replace
local function fnGetDefaultValue()
    return {
        appdescr = '',
        isactive = true
    }
end

-- for insert, replace
local function fnValidateParam(d)
    if d['name'] == '' then
        return {
            errcode = 11,
            errdescr = 'name is empty'
        }
    end
    return nil
end

-- for insert, replace
local function fnGetParamKey(param)
    return {
        appid = param['appid'],
    }
end

-- for replace
local function fnOverwriteParam(param, req)
    param['appid'] = req:stash('appid')
end

-- for get, delete
local function fnGetArrayKey(req)
    return { req:stash('appid') }
end


exports.insert = function(req)
    local params = req:post_param()
    data.setDefaultValues(params, fnGetDefaultValue())

    local vp = fnValidateParam(params)
    if vp ~= nil then
        return req:render(data.renderError(vp.errcode, vp.errdescr))
    end

    local status, err = pcall(function() 
        box.space.APP:insert(fnSetData(params))    
    end)

    if status then
        return req:render(data.renderResult(fnGetParamKey(params)))
    end

    local errcode
    local errdescr = tostring(err)

    if string.startswith(errdescr, 'Duplicate key')  then
        errcode = 1
        errdescr = 'Duplicate AppId'
    else
        errcode = 2
        errdescr = errdescr
    end

    return req:render(data.renderError(errcode, errdescr))
end

exports.getlist = function (req)
    local result = box.space.APP:select()
    return req:render(data.renderArrayData(result, fnGetData))
end

exports.get = function (req)
    local result = box.space.APP:select(fnGetArrayKey(req))
    return req:render(data.renderSingleData(result, fnGetData))
end

exports.replace = function(req)
    local params = req:post_param()
    data.setDefaultValues(params, fnGetDefaultValue())

    local vp = fnValidateParam(params)
    if vp ~= nil then
        return req:render(data.renderError(vp.errcode, vp.errdescr))
    end

    fnOverwriteParam(params, req)

    local status, err = pcall(function() 
        box.space.APP:replace(fnSetData(params))    
    end)

    if status then
        return req:render(data.renderResult(fnGetParamKey(params)))
    end

    local errcode
    local errdescr = tostring(err)

    if string.startswith(errdescr, 'Duplicate key')  then
        errcode = 1
        errdescr = 'Duplicate AppId'
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
        result = box.space.APP:delete(key)    
    end)

    if status then
        local description
        if result ~= nil then
            description = 'found'
        else
            description = 'not found'
        end

        return req:render(data.renderResult({
            appid = key[1]
        }, description))
    end

    return req:render(data.renderError(2, tostring(err)))
end

return exports