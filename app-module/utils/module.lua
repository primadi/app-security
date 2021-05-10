local exports = {}

exports.load = function(modulename) 
    local moduleid = package.loaded[modulename]
    if moduleid ~= nil then
        package.loaded[modulename] = nil
    end
    
    return require(modulename)
end

return exports