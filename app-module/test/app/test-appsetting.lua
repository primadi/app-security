local client = require 'utils.httpclient'

client.tesinit 'localhost:8080/'

-- sebelum tes, jalankan:
-- box.space.APP:truncate()

print('Test AppSetting')

client.test('Create app setting for km001', 'POST', 'app/km001/setting', {
    settingid 	= "pwd_mustcontainnumeric",
    value       = "false",
    description = "Password must contain numeric",
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.settingid == 'pwd_mustcontainnumeric'
end)

client.test('Create app setting for km001', 'POST', 'app/km001/setting', {
    settingid 	= "pwd_mustcontainalpha",
    value       = "false",
    description = "Password must contain Alphabet",
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'km001'
end)

client.test('Create app setting for km001', 'POST', 'app/km001/setting', {
    settingid 	= "pwd_mustcontainsymbol",
    value       = "false",
    description = "Password must contain Symbol",
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'km001'
end)


client.test('Get km001 pwd_mustcontainsymbol', 'GET', 'app/km001/setting/pwd_mustcontainsymbol', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.value == 'false'
end)

client.test('Update km001 pwd_mustcontainsymbol', 'PUT', 'app/km001/setting/pwd_mustcontainsymbol', {
    value = 'true',
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'km001'
end)

client.test('Get km001 password.MustContainSymbol', 'GET', 'app/km001/setting/pwd_mustcontainsymbol', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.value == 'true'
end)

client.test('Create kx001 pwd_mustcontainsymbol Error', 'POST', 'app/kx001/setting', {
    settingid 	= "pwd_mustcontainsymbol",
    value       = "false",
    description = "Password must contain Symbol",
}, function (res)
    return res.bodytable.errcode == 11
end)

client.test('Delete km001 password.MustContainSymbol', 'DELETE', 'app/km001/setting/pwd_mustcontainsymbol')

client.test('Get List km001 setting', 'GET', 'app/km001/setting', nil, function (res)
    return res.bodytable.count == 2
end, true)

client.testsummary()