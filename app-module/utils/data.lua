local exports = {}

local function getQueryData(data, fnCreateData)
    if #data == 0 then
        return {}
    end
    local result = {}
    for i, v in ipairs(data) do
        result[i] = fnCreateData(v)
    end
    return result
end

local function dataNotFound()
    return {
        json = {
            status = 'ok',
            description = 'not found',
            result = {}
        }
    }
end

local function dataFound(data)
    return {
        json = {
            status = 'ok',
            description = 'found',
            result = data
        }
    }
end

exports.renderResult = function(result, description)
    return {
        json = {
            status = 'ok',
            description = description,
            result = result
        }
    }
end

exports.renderError = function(errcode, errdescr)
    return {
        json = {
            status = 'error',
            errcode = errcode,
            description = errdescr
        }
    }
end

exports.renderSingleData = function (result, fnGetData)
    if #result == 0 then
        return dataNotFound()
    end
    
    return dataFound(fnGetData(result[1]))
end

exports.renderArrayData = function(result, fnGetData)
    if #result == 0 then
        return dataNotFound()
    end
    
    return dataFound(getQueryData(result, fnGetData))
end

-- set defaultvalue of table if not exists
exports.setDefaultValues = function(data, defaultvalues)
    for k, v in pairs(defaultvalues) do
        if data[k] == nil then
            data[k] = v
        end
    end
end

-- check if key is exists on space or not
exports.isKeyExists = function (spacename, keys)
    return #box.space[spacename]:select(keys) == 1
end

return exports