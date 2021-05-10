local exports = {}
local string = require('string')

exports.startswith = function (str, find)
    return string.sub(str, 1, string.len(find)) == find
end

return exports