local data = require 'utils.data'
local entity = require 'utils.entity'

local exports = {}

exports.session = entity.new({
    handlers = {
        login = function (req)
            local params = req:post_param()
            
        end,
        getinfo = function (req)
    
        end,
        logout = function (req)
    
        end,
        changerole = function (req)
    
        end,
        changepassword = function (req)
    
        end,
        getlistmodule = function (req)
    
        end,
        getlistvar = function (req)
    
        end,
        getvar = function (req)
    
        end
    }
})

return exports