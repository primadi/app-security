local client = require 'utils.httpclient'

client.tesinit 'localhost:8080/'

-- sebelum tes, jalankan:
-- box.space.APP:truncate()

print('Test AppModuleVar')

client.test('Create app module Var 1 for km001/T001', 'POST', 'app/km001/module/T001/var', 
{   varname 	 = "var1",
    defaultvalue = "defVar1"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.varname == 'var1'
end)

client.test('Create app module Var 2 for km001/T001', 'POST', 'app/km001/module/T001/var', 
{   varname 	 = "var2",
    defaultvalue = "defVar2"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.varname == 'var2'
end)

client.test('Create app module Var 3 for km001/T001', 'POST', 'app/km001/module/T001/var', 
{   varname 	 = "var3",
    defaultvalue = "defVar3"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.varname == 'var3'
end)

client.test('Get km001 T001 var2', 'GET', 'app/km001/module/T001/var/var2', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.varname == 'var2'
end)

client.test('Update km001 T001 var3', 'PUT', 'app/km001/module/T001/var/var3', {
    defaultvalue = 'xxxx',
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.varname == 'var3'
end)

client.test('Get km001 T001 var3', 'GET', 'app/km001/module/T001/var/var3', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.defaultvalue == 'xxxx'
end)

client.test('Create kx001 T001 var1 Error', 'POST', 'app/kx001/module/T001/var', {
    varname 	 = "var3",
    defaultvalue = "defVar3"
}, function (res)
    return res.bodytable.errcode == 11
end)

client.test('Delete km001 T001 var3', 'DELETE', 'app/km001/module/T001/var/var3')

client.test('Get List km001 T001', 'GET', 'app/km001/module/T001/var', nil, function (res)
    return res.bodytable.count == 2
end, true)

client.testsummary()