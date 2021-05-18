local exports = {}

local function getDataFromObject(data, fnCreateData)
    if #data == 0 then
        return {}
    end
    local result = {}
    for i, v in ipairs(data) do
        result[i] = fnCreateData(v)
    end
    return result
end

local function getDataFromSql(d)
    if #d.rows == 0 then
        return {}
    end

    local result = {}
    for i, v in ipairs(d.rows) do
        local data = {}

        for j, md in ipairs(d.metadata) do
            data[md.name:lower()] = v[j] 
        end
        result[i] = data
    end
    return result
end

local function dataNotFound()
    return {
        json = {
            status = 'ok',
            description = 'not found',
            count = 0,
            result = {}
        }
    }
end

local function dataFound(data)
    return {
        json = {
            status = 'ok',
            description = 'found',
            count = #data,
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
    
    return dataFound(getDataFromObject(result, fnGetData))
end

exports.renderSqlData = function(result, listmaxcount)
    if result == nil or #result.rows == 0 then
        return {
            json = {
                status = 'ok',
                description = 'not found',
                count = 0,
                listmaxcount = listmaxcount,
                lastdata = '',
                result = {}
            }
        }
    end

    local data = getDataFromSql(result)

    return {
        json = {
            status = 'ok',
            description = 'found',
            count = #data,
            listmaxcount = listmaxcount,
            lastdata = 'lastdata',
            result = data
        }
    }
end


-- set defaultvalue of table if not exists
exports.setDefaultValues = function(data, defaultvalues)
    if defaultvalues == nil then
        return
    end
    
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