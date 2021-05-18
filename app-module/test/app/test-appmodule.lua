local client = require 'utils.httpclient'

client.tesinit 'localhost:8080/'

-- sebelum tes, jalankan:
-- box.space.APP:truncate()

print('Test AppModule')

client.test('Create app module 1 for km001', 'POST', 'app/km001/module', 
{   moduleid 	= "T001",
    modulename  = "Tabungan/Tabungan Baru/Pembuatan",
    moduleurl   = "POST saving/newaccount",
    description = "Create New Saving Account"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.moduleid == 'T001'
end)

client.test('Create app module 2 for km001', 'POST', 'app/km001/module', 
{   moduleid 	= "T002",
    modulename  = "Tabungan/Tabungan Baru/Otorisasi",
    moduleurl   = "POST saving/newaccount/authorize",
    description = "Authorize New Saving Account"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.moduleid == 'T002'
end)

client.test('Create app module 3 for km001', 'POST', 'app/km001/module', 
{   moduleid 	= "T003",
    modulename  = "Tabungan/Pengaktifan Tabungan/Pembuatan",
    moduleurl   = "POST saving/account/activate",
    description = "Activate Saving Account"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.moduleid == 'T003'
end)

client.test('Get km001 T003', 'GET', 'app/km001/module/T003', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.moduleurl == 'POST saving/account/activate'
end)

client.test('Update km001 T003', 'PUT', 'app/km001/module/T003', {
    description= 'xxxx',
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.moduleid == 'T003'
end)

client.test('Get km001 T003', 'GET', 'app/km001/module/T003', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.description == 'xxxx'
end)

client.test('Create kx001 T003 Error', 'POST', 'app/kx001/module', {
    moduleid 	= "T003",
    modulename  = "Tabungan/Pengaktifan Tabungan/Pembuatan",
    moduleurl   = "POST saving/account/activate",
    description = "Activate Saving Account"
}, function (res)
    return res.bodytable.errcode == 11
end)

client.test('Delete km001 T003', 'DELETE', 'app/km001/module/T003')

client.test('Get List km001 module', 'GET', 'app/km001/module', nil, function (res)
    return res.bodytable.count == 2
end, true)

client.testsummary()