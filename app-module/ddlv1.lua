box.once("ddlv1", function () 
    local log = require('log')
    log.info('DDLV1 Created')

    box.execute([[
        CREATE TABLE app(
            appid STRING,
            name STRING,
            description STRING,
            isactive BOOLEAN,
            PRIMARY KEY(appid)
        )        
    ]])

    box.execute([[
        CREATE TABLE appsetting(
            appid STRING,
            settingid STRING,
            value STRING,
            description STRING,
            PRIMARY KEY(appid, settingid)
        )
    ]])

    box.execute([[
        CREATE TABLE appmodule(
            appid STRING,
            moduleid STRING,
            modulename STRING,
            moduleurl STRING,
            description STRING,
            isactive BOOLEAN,
            moduleorder UNSIGNED,
            PRIMARY KEY(appid, moduleid)
        )
    ]])

    box.execute([[
        CREATE UNIQUE INDEX idx_appmodule_modulename ON appmodule(modulename)
    ]])

    box.execute([[
        CREATE INDEX idx_appmodule_moduleurl ON appmodule(moduleurl)
    ]])

    -- appmodulevar -> 0: string, 1: number, 2: date
    box.execute([[
        CREATE TABLE appmodulevar(
            appid STRING,
            moduleid STRING,
            varname STRING,
            defaultvalue STRING,
            vartype UNSIGNED,
            description STRING,
            PRIMARY KEY(appid, moduleid, varname)
        )
    ]])

   box.execute([[
        CREATE TABLE approle(
            appid STRING,
            roleid STRING,
            rolename STRING,
            description STRING,
            PRIMARY KEY(appid, roleid)
        )
    ]])

    box.execute([[
        CREATE TABLE approlemodule(
            appid STRING,
            roleid STRING,
            moduleid STRING,
            PRIMARY KEY(appid, roleid, moduleid)
        )
    ]])

    box.execute([[
        CREATE TABLE approlemodulevar(
            appid STRING,
            roleid STRING,
            moduleid STRING,
            varname STRING,
            varvalue STRING,
            PRIMARY KEY(appid, roleid, moduleid, varname)
        )
    ]])

    box.execute([[
        CREATE TABLE client(
            clientid STRING,
            name STRING,
            contactperson STRING,
            email STRING,
            phonenumber STRING,
            description STRING,
            isactive BOOLEAN,
            PRIMARY KEY(clientid)
        )
    ]])

    box.execute([[
        CREATE TABLE clientapp(
            clientid STRING,
            appid STRING,
            isactive BOOLEAN,
            expireddate UNSIGNED,
            PRIMARY KEY(clientid, appid)
        )
    ]])

    box.execute([[
        CREATE TABLE clientapprole(
            clientid STRING,
            appid STRING,
            roleid STRING,
            PRIMARY KEY(clientid, appid, roleid)
        )
    ]])

    box.execute([[
        CREATE TABLE clientapprolemodule(
            clientid STRING,
            appid STRING,
            roleid STRING,
            moduleid STRING,
            PRIMARY KEY(clientid, appid, roleid, moduleid)
        )
    ]])

    box.execute([[
        CREATE TABLE clientapprolemodulevar(
            clientid STRING,
            appid STRING,
            roleid STRING,
            moduleid STRING,
            varname STRING,
            varvalue STRING,
            PRIMARY KEY(clientid, appid, roleid, moduleid, varname)
        )
    ]])

    box.execute([[
        CREATE TABLE clientappsetting(
            clientid STRING,
            appid STRING,
            settingid STRING,
            value STRING,
            PRIMARY KEY(clientid, appid, settingid)
        )
    ]])

    box.execute([[
        CREATE TABLE clientbranch(
            clientid STRING,
            branchid STRING,
            branchname STRING,
            address STRING,
            phonenumber STRING,
            isactive BOOLEAN,
            PRIMARY KEY(clientid, branchid)
        )
    ]])

    box.execute([[
        CREATE TABLE clientappuser(
            clientid STRING,
            appid STRING,
            username STRING,
            password STRING,
            isactive BOOLEAN,
            email STRING,
            phonenumber STRING,
            PRIMARY KEY(clientid, username)
        )
    ]])

    box.execute([[
        CREATE TABLE clientappuserrolebranch(
            clientid STRING,
            appid STRING,
            username STRING,
            roleid STRING,
            branchid STRING,
            PRIMARY KEY(clientid, appid, username, roleid, branchid)
        )
    ]])

    box.execute([[
        CREATE TABLE session(
            sessionid STRING,
            clientid STRING,
            username STRING,
            appid STRING
            roleid STRING,
            branchid STRING,
            PRIMARY KEY(sessionid)
        )
    ]])

    box.execute([[
        CREATE INDEX idx_session_username ON session(username)
    ]])
end)