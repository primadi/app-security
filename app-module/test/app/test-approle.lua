local client = require 'utils.httpclient'

client.tesinit 'localhost:8080/'

-- sebelum tes, jalankan:
-- box.space.APP:truncate()

print('Test AppRole')

client.test('Create app role 1 for km001', 'POST', 'app/km001/role', 
{   roleid 	= "R001",
    rolename  = "Operator"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.roleid == 'R001'
end)

client.test('Create app role 2 for km001', 'POST', 'app/km001/role', 
{   roleid 	= "R002",
    rolename  = "Teller"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.roleid == 'R002'
end)

client.test('Create app role 3 for km001', 'POST', 'app/km001/role', 
{   roleid 	= "R003",
    rolename  = "Kepala Cabang"
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.roleid == 'R003'
end)

client.test('Get km001 R003', 'GET', 'app/km001/role/R003', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.rolename == 'Kepala Cabang'
end)

client.test('Update km001 R003', 'PUT', 'app/km001/role/R003', {
    description= 'xxxx',
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.roleid == 'R003'
end)

client.test('Get km001 R003', 'GET', 'app/km001/role/R003', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.description == 'xxxx'
end)

client.test('Create kx001 T003 Error', 'POST', 'app/kx001/role', {
    roleid 	= "R003",
    rolename  = "Error"
}, function (res)
    return res.bodytable.errcode == 11
end)

client.test('Delete km001 R003', 'DELETE', 'app/km001/role/R003')

client.test('Get List km001 role', 'GET', 'app/km001/role', nil, function (res)
    return res.bodytable.count == 2
end, true)

client.testsummary()