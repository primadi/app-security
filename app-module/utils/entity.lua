local data = require 'utils.data'
local string = require 'utils.string'
-- local log = require 'log'
local exports = {}

local function fnGetData(cfg, d)
    local ret = {}
    for i, v in pairs(cfg.fieldNames) do
        ret[v] = d[i]
    end
    return ret
end

-- TODO : getlist from Sql
-- local function fnGetDataSql(d)
--     local ret = {}
--     for i, v in pairs(d.metadata) do
--         ret[v:lower()] = d[i]
--     end
--     return ret
-- end

local function fnSetData(cfg, d)
    local ret = {}
    for i, v in pairs(cfg.fieldNames) do
        ret[i] = d[v]
    end

    return ret
end

local function fnGetParamKey(cfg, d)
    local j = cfg.numPrimaryKey
    local ret = {}
    for i, v in pairs(cfg.fieldNames) do
        ret[v] = d[v]
        if i == j then
            return ret
        end
    end
    return ret
end

local function fnOverwriteParamList(cfg, d, req)
    local j = cfg.numPrimaryKey - 1 

    if j <= 0 then
        return
    end

    for i, v in pairs(cfg.fieldNames) do
        d[v] = req:stash(v)
        if i == j then
            return
        end
    end
end

local function fnOverwriteParamEntity(cfg, d, req)
    local j = cfg.numPrimaryKey

    for i, v in pairs(cfg.fieldNames) do
        d[v] = req:stash(v)
        if i == j then
            return
        end
    end
end

local function fnGetKeyEntity(cfg, req)
    local j = cfg.numPrimaryKey
    local ret = {}
    for i, v in pairs(cfg.fieldNames) do
        ret[i] = req:stash(v)
        if i == j then
            return ret
        end
    end
    return ret
end

local function fnGetKeyList(cfg, req)
    local j = cfg.numPrimaryKey - 1

    if j <= 0 then
        return {}
    end

    local ret = {}
    for i, v in pairs(cfg.fieldNames) do
        ret[i] = req:stash(v)
        if i == j then
            return ret
        end
    end
    return ret
end

function exports.new(cfg)
    local ctrl = {} 

    if cfg.spacename == nil then
        error('spacename not exists', 2)
    end
    
    if cfg.fieldNames == nil then
        error('fieldNames not exists', 2)
    end

    if cfg.numPrimaryKey == nil then
        error('NumPrimaryKey not exists', 2)
    end

    if cfg.insert ~= nil then
        ctrl.insert = cfg.insert
    else
        ctrl.insert = function(req)
            local params = req:post_param()
            fnOverwriteParamList(cfg, params, req)
            
            data.setDefaultValues(params, cfg.defaultValue)
            if cfg.validateEntity ~= nil then
                local res = cfg.validateEntity(params)
                if res ~= nil then
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end

            box.begin()

            if cfg.beforeInsert ~= nil then
                local res = cfg.beforeInsert(params)
                if res ~= nil then
                    box.rollback()
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end
        
            local status, err
            
            if cfg.doInsert == nil then
                status, err = pcall(function() 
                    box.space[cfg.spacename]:insert(fnSetData(cfg, params))    
                end)
            else
                status, err = pcall(function() 
                    cfg.doInsert(params)
                end)
            end

            if status then
                if cfg.afterInsert ~= nil then
                    local res = cfg.afterInsert(params)
                    if res ~= nil then
                        box.rollback()
                        return req:render(data.renderError(res.errcode, res.description))
                    end
                end

                box.commit()
                return req:render(data.renderResult(fnGetParamKey(cfg, params)))
            end
        
            box.rollback()

            local errcode
            local errdescr = tostring(err)
        
            if string.startswith(errdescr, 'Duplicate key') then
                errcode = 1
                errdescr = 'Duplicate Key'
            else
                errcode = 2
                errdescr = errdescr
            end
        
            return req:render(data.renderError(errcode, errdescr))
        end
    end

    if cfg.copyto ~= nil then
        ctrl.copyto = cfg.copyto
    else
        ctrl.copyto = function(req)
            local params = req:post_param()
                   
            local oldDbData = box.space[cfg.spacename]:select(fnGetKeyEntity(cfg, req))
            local rows = oldDbData.rows
            if #rows ~= 1 then
                return req:render(data.renderError(31, 'CopyTo Source Data not found'))
            end
            rows = rows[1]
            local newData = {}
            for i, v in ipairs(oldDbData.metadata) do
                local newName = 'new_' .. v
                if params[newName] ~= nil then
                    newData[v] = params[newName]
                else
                    newData[v] = rows[i]
                end
            end
            if cfg.validateEntity ~= nil then
                local res = cfg.validateEntity(newData)
                if res ~= nil then
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end

            box.begin()

            if cfg.beforeReplace ~= nil then
                local res = cfg.beforeCopyTp(newData)
                if res ~= nil then
                    box.rollback()
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end
        
            local status, err
            
            if cfg.doCopyTo == nil then
                status, err = pcall(function() 
                    box.space[cfg.spacename]:insert(fnSetData(cfg, newData))    
                end)
            else
                status, err = pcall(function() 
                    cfg.doCopyTo(newData)   
                end)
            end

            if status then
                if cfg.afterCopyTo ~= nil then
                    local res = cfg.afterCopyTo(newData)
                    if res ~= nil then
                        box.rollback()
                        return req:render(data.renderError(res.errcode, res.description))
                    end
                end

                box.commit()
                return req:render(data.renderResult(fnGetParamKey(cfg, newData)))
            end
        
            box.rollback()

            local errcode
            local errdescr = tostring(err)
        
            if string.startswith(errdescr, 'Duplicate key')  then
                errcode = 1
                errdescr = 'Duplicate Key'
            else
                errcode = 2
                errdescr = errdescr
            end
        
            return req:render(data.renderError(errcode, errdescr))
        end
    end

    if cfg.getlist ~= nil then
        ctrl.getlist = cfg.getlist
    else
        if cfg.listSql == nil then
            ctrl.getlist = function (req)
                local result = box.space[cfg.spacename]:select(fnGetKeyList(cfg, req))
                return req:render(data.renderArrayData(result, function(d) 
                    return fnGetData(cfg, d)
                end))
            end
        else
            local maxCount = cfg.listMaxCount
            if maxCount == nil then
                maxCount = 100
            end
            ctrl.getlist = function (req)
                local params = req:query_param()
                local firstdata = params.firstdata
                local lastdata = params.lastdata

                if firstdata == nil then firstdata = '' end
                if lastdata == nil then lastdata = '' end
                
                local movedir = params.movedir
                if movedir == nil then movedir = 0 end
                
                -- movedir : -2 movefirst -1 moveprev 0 refresh
                --            1 movenext   2 movelast
                local result = box.execute(cfg.listSql, { lastdata, maxCount })
                return req:render(data.renderSqlData(result, lastdata, maxCount))
            end
        end
    end

    if cfg.get ~= nil then
        ctrl.get = cfg.get
    else
        ctrl.get = function (req)
            local result = box.space[cfg.spacename]:select(fnGetKeyEntity(cfg, req))
            return req:render(data.renderSingleData(result, function(d) 
                return fnGetData(cfg, d)
            end))
        end 
    end

    if cfg.replace ~= nil then
        ctrl.replace = cfg.replace
    else
        ctrl.replace = function (req)
            local params = req:post_param()
            data.setDefaultValues(params, cfg.defaultValue)
        
            fnOverwriteParamEntity(cfg, params, req)

            if cfg.validateEntity ~= nil then
                local res = cfg.validateEntity(params)
                if res ~= nil then
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end

            box.begin()

            if cfg.beforeReplace ~= nil then
                local res = cfg.beforeReplace(params)
                if res ~= nil then
                    box.rollback()
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end
        
            local status, err
            
            if cfg.doReplace == nil then
                status, err = pcall(function() 
                    box.space[cfg.spacename]:replace(fnSetData(cfg, params))    
                end)
            else
                status, err = pcall(function() 
                    cfg.doReplace(params)   
                end)
            end

            if status then
                if cfg.afterReplace ~= nil then
                    local res = cfg.afterReplace(params)
                    if res ~= nil then
                        box.rollback()
                        return req:render(data.renderError(res.errcode, res.description))
                    end
                end

                box.commit()
                return req:render(data.renderResult(fnGetParamKey(cfg, params)))
            end
        
            box.rollback()

            local errcode
            local errdescr = tostring(err)
        
            if string.startswith(errdescr, 'Duplicate key')  then
                errcode = 1
                errdescr = 'Duplicate Key'
            else
                errcode = 2
                errdescr = errdescr
            end
        
            return req:render(data.renderError(errcode, errdescr))
        end
    end

    if cfg.delete ~= nil then
        ctrl.delete = cfg.delete
    else
        ctrl.delete = function(req)
            local key = fnGetKeyEntity(cfg, req)
            local result

            box.begin()

            if cfg.beforeDelete ~= nil then
                local res = cfg.beforeDelete(params)
                if res ~= nil then
                    box.rollback()
                    return req:render(data.renderError(res.errcode, res.description))
                end
            end

            local status, err
            
            if cfg.doDelete == nil then
                status, err = pcall(function() 
                    result = box.space[cfg.spacename]:delete(key)    
                end)
            else
                status, err = pcall(function() 
                    result = cfg.doDelete(key)    
                end)
            end
        
            if status then
                box.commit()

                local description
                if result ~= nil then
                    description = 'found'
                else
                    description = 'not found'
                end
        
                local params = {}
                fnOverwriteParamEntity(cfg, params, req)

                return req:render(data.renderResult(fnGetParamKey(cfg, params), description))
            end
        
            box.rollback()            
            return req:render(data.renderError(2, tostring(err)))
        end         
    end

    for k, v in pairs(cfg.handlers) do
        ctrl[k] = v
    end

    return ctrl
end

return exports