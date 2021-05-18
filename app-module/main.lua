local server = require('http.server').new(nil, 8080)

server:route({path = '/ping', method = 'GET'}, function(req)
    return req:render {
        json = {
            status = 'ok'
        }
    }
end)

local appctrl = require('controllers.appctrl')
server:route({path = '/app', method = 'POST'}, appctrl.app.insert)
server:route({path = '/app', method = 'GET'}, appctrl.app.getlist)
server:route({path = '/app/:appid', method = 'GET'}, appctrl.app.get)
server:route({path = '/app/:appid', method = 'PUT'}, appctrl.app.replace)
server:route({path = '/app/:appid', method = 'DELETE'}, appctrl.app.delete)

server:route({path = '/app/:appid/setting', method = 'POST'}, appctrl.appsetting.insert)
server:route({path = '/app/:appid/setting', method = 'GET'}, appctrl.appsetting.getlist)
server:route({path = '/app/:appid/setting/:settingid', method = 'GET'}, appctrl.appsetting.get)
server:route({path = '/app/:appid/setting/:settingid', method = 'PUT'}, appctrl.appsetting.replace)
server:route({path = '/app/:appid/setting/:settingid', method = 'DELETE'}, appctrl.appsetting.delete)

server:route({path = '/app/:appid/module', method = 'POST'}, appctrl.appmodule.insert)
server:route({path = '/app/:appid/module', method = 'GET'}, appctrl.appmodule.getlist)
server:route({path = '/app/:appid/module/:moduleid', method = 'GET'}, appctrl.appmodule.get)
server:route({path = '/app/:appid/module/:moduleid', method = 'PUT'}, appctrl.appmodule.replace)
server:route({path = '/app/:appid/module/:moduleid', method = 'DELETE'}, appctrl.appmodule.delete)

server:route({path = '/app/:appid/module/:moduleid/var', method = 'POST'}, appctrl.appmodulevar.insert)
server:route({path = '/app/:appid/module/:moduleid/var', method = 'GET'}, appctrl.appmodulevar.getlist)
server:route({path = '/app/:appid/module/:moduleid/var/:varname', method = 'GET'}, appctrl.appmodulevar.get)
server:route({path = '/app/:appid/module/:moduleid/var/:varname', method = 'PUT'}, appctrl.appmodulevar.replace)
server:route({path = '/app/:appid/module/:moduleid/var/:varname', method = 'DELETE'}, appctrl.appmodulevar.delete)

server:route({path = '/app/:appid/role', method = 'POST'}, appctrl.approle.insert)
server:route({path = '/app/:appid/role', method = 'GET'}, appctrl.approle.getlist)
server:route({path = '/app/:appid/role/:roleid', method = 'GET'}, appctrl.approle.get)
server:route({path = '/app/:appid/role/:roleid', method = 'PUT'}, appctrl.approle.replace)
server:route({path = '/app/:appid/role/:roleid', method = 'DELETE'}, appctrl.approle.delete)
server:route({path = '/app/:appid/role/:roleid/copyto', method = 'POST'}, appctrl.approle.copyto)

server:route({path = '/app/:appid/role/:roleid/module', method = 'POST'}, appctrl.approlemodule.insert)
server:route({path = '/app/:appid/role/:roleid/module', method = 'GET'}, appctrl.approlemodule.getlist)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid', method = 'GET'}, appctrl.approlemodule.get)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid', method = 'PUT'}, appctrl.approlemodule.replace)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid', method = 'DELETE'}, appctrl.approlemodule.delete)

server:route({path = '/app/:appid/role/:roleid/module/:moduleid/var', method = 'POST'}, appctrl.approlemodulevar.insert)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid/var', method = 'GET'}, appctrl.approlemodulevar.getlist)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid/var/:varname', method = 'GET'}, appctrl.approlemodulevar.get)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid/var/:varname', method = 'PUT'}, appctrl.approlemodulevar.replace)
server:route({path = '/app/:appid/role/:roleid/module/:moduleid/var/:varname', method = 'DELETE'}, appctrl.approlemodulevar.delete)

local clientctrl = require('controllers.clientctrl')
server:route({path = '/client', method = 'POST'}, clientctrl.client.insert)
server:route({path = '/client', method = 'GET'}, clientctrl.client.getlist)
server:route({path = '/client/:clientid', method = 'GET'}, clientctrl.client.get)
server:route({path = '/client/:clientid', method = 'PUT'}, clientctrl.client.replace)
server:route({path = '/client/:clientid', method = 'DELETE'}, clientctrl.client.delete)

server:route({path = '/client/:clientid/app', method = 'POST'}, clientctrl.clientapp.insert)
server:route({path = '/client/:clientid/app', method = 'GET'}, clientctrl.clientapp.getlist)
server:route({path = '/client/:clientid/app/:appid', method = 'GET'}, clientctrl.clientapp.get)
server:route({path = '/client/:clientid/app/:appid', method = 'PUT'}, clientctrl.clientapp.replace)
server:route({path = '/client/:clientid/app/:appid', method = 'DELETE'}, clientctrl.clientapp.delete)

server:route({path = '/client/:clientid/app/:appid/role', method = 'POST'}, clientctrl.clientapprole.insert)
server:route({path = '/client/:clientid/app/:appid/role', method = 'GET'}, clientctrl.clientapprole.getlist)
server:route({path = '/client/:clientid/app/:appid/role/:roleid', method = 'GET'}, clientctrl.clientapprole.get)
server:route({path = '/client/:clientid/app/:appid/role/:roleid', method = 'PUT'}, clientctrl.clientapprole.replace)
server:route({path = '/client/:clientid/app/:appid/role/:roleid', method = 'DELETE'}, clientctrl.clientapprole.delete)
server:route({path = '/client/:clientid/app/:appid/copyrole', method = 'POST'}, clientctrl.clientapprole.copyrole)

server:route({path = '/client/:clientid/app/:appid/role/:roleid/module', method = 'POST'}, 
    clientctrl.clientapprolemodule.insert)
server:route({path = '/client/:clientid/app/:appid/role/:roleid/module', method = 'GET'}, 
    clientctrl.clientapprolemodule.getlist)
server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid', method = 'GET'}, 
    clientctrl.clientapprolemodule.get)
server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid', method = 'PUT'}, 
    clientctrl.clientapprolemodule.replace)
server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid', method = 'DELETE'}, 
    clientctrl.clientapprolemodule.delete)

server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid/var', method = 'POST'}, 
    clientctrl.clientapprolemodulevar.insert)
server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid/var', method = 'GET'}, 
    clientctrl.clientapprolemodulevar.getlist)
server:route({path = '/client/:clientid/app/:appid/role/:roleid/module/:moduleid/var/:varid', method = 'GET'}, 
    clientctrl.clientapprolemodulevar.get)

server:route({path = '/client/:clientid/app/:appid/setting', method = 'GET'}, 
    clientctrl.clientappsetting.getlist)
server:route({path = '/client/:clientid/app/:appid/setting/:settingid', method = 'GET'}, 
    clientctrl.clientappsetting.get)
server:route({path = '/client/:clientid/app/:appid/setting/:settingid', method = 'PUT'}, 
    clientctrl.clientappsetting.replace)

server:route({path = '/client/:clientid/branch', method = 'POST'}, clientctrl.clientbranch.insert)
server:route({path = '/client/:clientid/branch', method = 'GET'}, clientctrl.clientbranch.getlist)
server:route({path = '/client/:clientid/branch/:branchid', method = 'GET'}, clientctrl.clientbranch.get)
server:route({path = '/client/:clientid/branch/:branchid', method = 'PUT'}, clientctrl.clientbranch.replace)
server:route({path = '/client/:clientid/branch/:branchid', method = 'DELETE'}, clientctrl.clientbranch.delete)

server:route({path = '/client/:clientid/user', method = 'POST'}, clientctrl.clientappuser.insert)
server:route({path = '/client/:clientid/user', method = 'GET'}, clientctrl.clientappuser.getlist)
server:route({path = '/client/:clientid/app/:app/user/:userid', method = 'GET'}, clientctrl.clientappuser.get)
server:route({path = '/client/:clientid/app/:app/user/:userid', method = 'PUT'}, clientctrl.clientappuser.replace)
server:route({path = '/client/:clientid/app/:app/user/:userid', method = 'DELETE'}, clientctrl.clientappuser.delete)
server:route({path = '/client/:clientid/app/:app/user/:userid/resetlogin', method = 'POST'}, clientctrl.clientappuser.resetlogin)
server:route({path = '/client/:clientid/app/:app/user/:userid/resetpassword', method = 'POST'}, clientctrl.clientappuser.resetpassword)

server:route({path = '/client/:clientid/app/:app/user/:userid/rolebranch', method = 'POST'}, 
    clientctrl.clientappuserrolebranch.insert)
server:route({path = '/client/:clientid/app/:app/user/:userid/rolebranch', method = 'GET'}, 
    clientctrl.clientappuserrolebranch.getlist)
server:route({path = '/client/:clientid/app/:app/user/:userid/rolebranch/:roleid/:branchid', method = 'GET'}, 
    clientctrl.clientappuserrolebranch.get)
server:route({path = '/client/:clientid/app/:app/user/:userid/rolebranch/:roleid/:branchid', method = 'PUT'}, 
    clientctrl.clientappuserrolebranch.replace)
server:route({path = '/client/:clientid/app/:app/user/:userid/rolebranch/:roleid/:branchid', method = 'DELETE'}, 
    clientctrl.clientappuserrolebranch.delete)

local sessionctrl = require('controllers.sessionctrl')
server:route({path = '/session/login', method = 'POST'}, sessionctrl.session.login)
server:route({path = '/session/:sessionid/info', method = 'GET'}, sessionctrl.session.getinfo)
server:route({path = '/session/:sessionid/logout', method = 'POST'}, sessionctrl.session.logout)
server:route({path = '/session/:sessionid/changepassword', method = 'POST'}, sessionctrl.session.changepassword)
server:route({path = '/session/:sessionid/changerole', method = 'POST'}, sessionctrl.session.changerole)
server:route({path = '/session/:sessionid/module', method = 'GET'}, sessionctrl.session.getlistmodule)
server:route({path = '/session/:sessionid/module/:moduleid/var', method = 'GET'}, sessionctrl.session.getlistvar)
server:route({path = '/session/:sessionid/module/:moduleid/var/:varid', method = 'GET'}, sessionctrl.session.getvar)

server:start()