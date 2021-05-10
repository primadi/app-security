local exports = {}
local string = require('utils.string')
local data = require('utils.data')

local function fnGetData(data)
    return {
        appid = data[1],
        name = data[2],
        appdescr = data[3],
        isactive = data[4]
    }
end

local function fnSetData(data)
    return {
        data['appid'], 
        data['name'], 
        data['appdescr'], 
        data['isactive']
    }
end

exports.insert = function(req)
    local params = req:post_param()
    data.setDefaultValues(params, { isactive = true })

    local status, err = pcall(function() 
        box.space.APP:insert(fnSetData(params))    
    end)

    if status then
        return req:render(data.renderResult({
            appid = params['appid']
        }))
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

exports.replace = function(req)
    local params = req:post_param()
    data.setDefaultValues(params, { isactive = true })

    if req:stash('appid') ~= params['appid'] then
        if params['appid'] == nil then
            return req:render(data.renderError(3, 'appid is required'))
        end
        return req:render(data.renderError(4, 'cannot change appid'))
    end
    local status, err = pcall(function() 
        box.space.APP:replace(fnSetData(params))    
    end)

    if status then
        return req:render(data.renderResult({
            appid = params['appid']
        }))
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

    return req:render(data.renderError(
        req.path, errcode, errdescr))
end

exports.delete = function(req)
    local appid = req:stash('appid')
    local result
    local status, err = pcall(function() 
        result = box.space.APP:delete {appid}    
    end)

    if status then
        local description
        if result ~= nil then
            description = 'found'
        else
            description = 'not found'
        end

        return req:render(data.renderResult({
            appid = appid
        }, description))
    end

    return req:render(data.renderError(2, tostring(err)))
end

exports.get = function (req)
    local result = box.space.APP:select(req:stash('appid'))
    return req:render(data.renderSingleData(result, fnGetData))
end

exports.getlist = function (req)
    local result = box.space.APP:select{}
    return req:render(data.renderArrayData(result, fnGetData))
end

return exports