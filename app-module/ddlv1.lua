box.once("ddlv1", function () 
    box.execute([[
        CREATE TABLE app(
            appid STRING PRIMARY KEY,
            name STRING,
            appdescr STRING,
            isactive BOOLEAN
        )
    ]])

    box.execute([[
        CREATE TABLE appmodule(
            appid STRING PRIMARY KEY,
            moduleid STRING PRIMARY KEY,
            modulename STRING,
            moduleurl STRING,
            moduledescr STRING,
            isactive BOOLEAN,
            moduleorder UNSIGNED
        )
    ]])

    box.execute([[
        CREATE UNIQUE INDEX idx_appmodule_modulename ON appmodule(modulename)
    ]])

    box.execute([[
        CREATE INDEX idx_appmodule_moduleurl ON appmodule(moduleurl)
    ]])

    box.execute([[
        CREATE TABLE appmodulevar {
            appid STRING PRIMARY KEY,
            moduleid STRING PRIMARY KEY,
            varname STRING PRIMARY KEY,
            defaultvalue STRING,
            vartype UNSIGNED,   -- 0: string, 1: number, 2: date
            vardescr STRING
        }
    ]])

    box.execute([[
        CREATE TABLE approle {
            appid STRING PRIMARY KEY,
            roleid STRING PRIMARY KEY,
            rolename STRING,
            description STRING
        }
    ]])

    box.execute([[
        CREATE TABLE approlemodule {
            appid STRING PRIMARY KEY,
            roleid STRING PRIMARY KEY,
            moduleid STRING PRIMARY KEY,
        }
    ]])

    box.execute([[
        CREATE TABLE approlemodulevar {
            appid STRING PRIMARY KEY,
            roleid STRING PRIMARY KEY,
            moduleid STRING PRIMARY KEY,
            varname STRING PRIMARY KEY,
            varvalue STRING,
        }
    ]])

    box.execute([[
        CREATE TABLE client {
            id STRING PRIMARY KEY,
            name STRING,
            email STRING,
            phonenumber STRING
        }
    ]])

    box.execute([[
        CREATE TABLE clientapp {
            clientid STRING PRIMARY KEY,
            appid STRING PRIMARY KEY,
            isactive BOOLEAN,
            expireddate UNSIGNED,
            isactive BOOLEAN
        }
    ]])
    
    -- box.schema.space.create('app')
    -- box.space.app:format({
    --     { name = 'appid', type = 'string' },
    --     { name = 'name', type = 'string'},
    --     { name = 'isactive', type = 'boolean'}
    -- })
    -- box.space.app:create_index('app_pk', {
    --     parts = {'appid'}
    -- })

    -- box.schema.space.create('appmodule')
    -- box.space.appmodule:format({
    --     { name = 'appid', type = 'string' },
    --     { name = 'moduleid', type = 'string'},
    --     { name = 'modulename', type = 'string'},
    --     { name = 'moduleurl', type = 'string'},
    --     { name = 'isactive', type = 'boolean'},
    --     { name = 'order', type = 'unsigned'}
    -- })
    -- box.space.appmodule:create_index('appmodule_pk', {
    --     parts = {{'appid'}, {'moduleid'}}
    -- })

    -- box.schema.space.create('client')
    -- box.space.client:format({
    --     { name = 'clientid', type = 'string' },
    --     { name = 'clientname', type = 'string'},
    --     { name = 'isactive', type = 'boolean'}
    -- })
    -- box.space.client:create_index('client_pk', {
    --     parts = {'clientid'}
    -- })
end)