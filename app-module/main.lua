local server = require('http.server').new(nil, 8080)

server:route({path = '/ping', method = 'GET'}, function(req)
    return req:render {
        json = {
            status = 'ok'
        }
    }
end)

local app = require('controllers.app')
server:route({path = '/app', method = 'POST'}, app.insert)
server:route({path = '/app', method = 'GET'}, app.getlist)
server:route({path = '/app/:appid', method = 'GET'}, app.get)
server:route({path = '/app/:appid', method = 'PUT'}, app.replace)
server:route({path = '/app/:appid', method = 'DELETE'}, app.delete)

local appmodule = require('controllers.appmodule')
server:route({path = '/app/:appid/module', method = 'POST'}, appmodule.insert)
server:route({path = '/app/:appid/module', method = 'GET'}, appmodule.getlist)
server:route({path = '/app/:appid/module/:moduleid', method = 'GET'}, appmodule.get)
server:route({path = '/app/:appid/module/:moduleid', method = 'PUT'}, appmodule.replace)
server:route({path = '/app/:appid/module/:moduleid', method = 'DELETE'}, appmodule.delete)

-- local appmodulevar = require('controllers.appmodulevar')
-- server:route({path = '/app/:appid/module/:moduleid/var', method = 'POST'}, appmodulevar.insert)
-- server:route({path = '/app/:appid/module/:moduleid/var', method = 'GET'}, appmodulevar.getlist)
-- server:route({path = '/app/:appid/module/:moduleid/var/:varid', method = 'GET'}, appmodulevar.get)
-- server:route({path = '/app/:appid/module/:moduleid/var/:varid', method = 'PUT'}, appmodulevar.replace)
-- server:route({path = '/app/:appid/module/:moduleid/var/:varid', method = 'DELETE'}, appmodulevar.delete)

-- local client = require('controllers.client')
-- server:route({path = '/client', method = 'POST'}, client.insert)
-- server:route({path = '/client', method = 'GET'}, client.getlist)
-- server:route({path = '/client/:clientid', method = 'GET'}, client.get)
-- server:route({path = '/client/:clientid', method = 'PUT'}, client.replace)
-- server:route({path = '/client/:clientid', method = 'DELETE'}, client.delete)

-- local clientapp = require('controllers.clientapp')
-- server:route({path = '/client/:clientid/app', method = 'POST'}, clientapp.insert)
-- server:route({path = '/client/:clientid/app', method = 'GET'}, clientapp.getlist)
-- server:route({path = '/client/:clientid/app/:appid', method = 'GET'}, clientapp.get)
-- server:route({path = '/client/:clientid/app/:appid', method = 'PUT'}, clientapp.replace)
-- server:route({path = '/client/:clientid/app/:appid', method = 'DELETE'}, clientapp.delete)

-- local clientappsetting = require('controllers.clientappsetting')
-- server:route({path = '/client/:clientid/app/:appid/setting', method = 'GET'}, clientappsetting.getlist)
-- server:route({path = '/client/:clientid/app/:appid/setting/:settingid', method = 'GET'}, clientappsetting.get)
-- server:route({path = '/client/:clientid/app/:appid/setting/:settingid', method = 'PUT'}, clientappsetting.replace)

-- local clientapprole = require('controllers.clientapprole')
-- server:route({path = '/client/:clientid/app/:appid/role', method = 'POST'}, clientapprole.insert)
-- server:route({path = '/client/:clientid/app/:appid/role', method = 'GET'}, clientapprole.getlist)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid', method = 'GET'}, clientapprole.get)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid', method = 'PUT'}, clientapprole.replace)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid', method = 'DELETE'}, clientapprole.delete)
-- server:route({path = '/client/:clientid/app/:appid/copyrole', method = 'POST'}, clientapprole.copyrole)

-- local clientapprolemodule = require('controllers.clientapprolemodule')
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/module', method = 'POST'}, clientapprolemodule.insert)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/module', method = 'GET'}, clientapprolemodule.getlist)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/:roleid/module/:moduleid', method = 'GET'}, clientapprolemodule.get)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/:roleid/module/:moduleid', method = 'PUT'}, clientapprolemodule.replace)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/:roleid/module/:moduleid', method = 'DELETE'}, clientapprolemodule.delete)

-- local clientapprolemodulevar = require('controllers.clientapprolemodulevar')
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid/var', method = 'POST'}, clientapprolemodulevar.insert)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid/var', method = 'GET'}, clientapprolemodulevar.getlist)
-- server:route({path = '/client/:clientid/app/:appid/role/:roleid/:roleid/module/:moduleid/var/:varid', method = 'GET'}, clientapprolemodulevar.get)

-- local clientbranch = require('controllers.clientbranch')
-- server:route({path = '/client/:clientid/branch', method = 'POST'}, clientbranch.insert)
-- server:route({path = '/client/:clientid/branch', method = 'GET'}, clientbranch.getlist)
-- server:route({path = '/client/:clientid/branch/:branchid', method = 'GET'}, clientbranch.get)
-- server:route({path = '/client/:clientid/branch/:branchid', method = 'PUT'}, clientbranch.replace)
-- server:route({path = '/client/:clientid/branch/:branchid', method = 'DELETE'}, clientbranch.delete)

-- local clientuser = require('controllers.clientuser')
-- server:route({path = '/client/:clientid/user', method = 'POST'}, clientuser.insert)
-- server:route({path = '/client/:clientid/user', method = 'GET'}, clientuser.getlist)
-- server:route({path = '/client/:clientid/user/:userid', method = 'GET'}, clientuser.get)
-- server:route({path = '/client/:clientid/user/:userid', method = 'PUT'}, clientuser.replace)
-- server:route({path = '/client/:clientid/user/:userid', method = 'DELETE'}, clientuser.delete)
-- server:route({path = '/client/:clientid/user/:userid/resetlogin', method = 'POST'}, clientuser.resetlogin)
-- server:route({path = '/client/:clientid/user/:userid/resetpassword', method = 'POST'}, clientuser.resetpassword)

-- local clientuserapprolebranch = require('controllers.clientuserapprolebranch')
-- server:route({path = '/client/:clientid/user/:userid/approlebranch', method = 'POST'}, clientuserapprolebranch.insert)
-- server:route({path = '/client/:clientid/user/:userid/approlebranch', method = 'GET'}, clientuserapprolebranch.getlist)
-- server:route({path = '/client/:clientid/user/:userid/approlebranch/:approlebranchid', method = 'GET'}, clientuserapprolebranch.get)
-- server:route({path = '/client/:clientid/user/:userid/approlebranch/:approlebranchid', method = 'PUT'}, clientuserapprolebranch.replace)
-- server:route({path = '/client/:clientid/user/:userid/approlebranch/:approlebranchid', method = 'DELETE'}, clientuserapprolebranch.delete)

-- local session = require('controllers.session')
-- server:route({path = '/session/login', method = 'POST'}, session.login)
-- server:route({path = '/session/:sessionid/info', method = 'GET'}, session.getinfo)
-- server:route({path = '/session/:sessionid/logout', method = 'POST'}, session.logout)
-- server:route({path = '/session/:sessionid/changepassword', method = 'POST'}, session.changepassword)
-- server:route({path = '/session/:sessionid/module', method = 'GET'}, session.getlistmodule)
-- server:route({path = '/session/:sessionid/module/:moduleid/var', method = 'GET'}, session.getlistvar)
-- server:route({path = '/session/:sessionid/module/:moduleid/var/:varid', method = 'GET'}, session.getvar)

server:start()