local client = require 'utils.httpclient'

client.tesinit 'localhost:8080/'

-- sebelum tes, jalankan:
-- box.space.APP:truncate()

print('Test AppRoleModule')

client.test('Create app role module 1 for km001/R001', 'POST', 'app/km001/role/R001/module', 
{   moduleid = "T001"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.moduleid == 'T001'
end)

client.test('Create app role module 1 for km001/R001 ERROR', 'POST', 'app/km001/role/R001/module', 
{   moduleid = "Module Error"
}, function (res)
    return res.bodytable.errcode == 12
end)

client.test('Create app role module 2 for km001/T001', 'POST', 'app/km001/role/T001/module', 
{   modulename 	 = "module2",
    defaultvalue = "defmodule2"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.modulename == 'module2'
end)

client.test('Create app role module 3 for km001/T001', 'POST', 'app/km001/role/T001/module', 
{   modulename 	 = "module3",
    defaultvalue = "defmodule3"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.modulename == 'module3'
end)

client.test('Get km001 T001 module2', 'GET', 'app/km001/role/T001/module/module2', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.modulename == 'module2'
end)

client.test('Update km001 T001 module3', 'PUT', 'app/km001/role/T001/module/module3', {
    defaultvalue = 'xxxx',
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.modulename == 'module3'
end)

client.test('Get km001 T001 module3', 'GET', 'app/km001/role/T001/module/module3', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.defaultvalue == 'xxxx'
end)

client.test('Create kx001 T001 module1 Error', 'POST', 'app/kx001/role/T001/module', {
    modulename 	 = "module3",
    defaultvalue = "defmodule3"
}, function (res)
    return res.bodytable.errcode == 11
end)

client.test('Delete km001 T001 module3', 'DELETE', 'app/km001/role/T001/module/module3')

client.test('Get List km001 T001', 'GET', 'app/km001/role/T001/module', nil, function (res)
    return res.bodytable.count == 2
end, true)

client.testsummary()