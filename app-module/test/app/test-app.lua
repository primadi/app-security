local client = require 'utils.httpclient'

client.tesinit 'localhost:8080/'

-- sebelum tes, jalankan:
-- box.space.APP:truncate()

print('Test App')

client.test('Ping', 'GET', 'ping')

client.test('Create app km001', 'POST', 'app', {
    appid 		= "km001",
    name 		= "klinik-mobileapp",
    description = "Aplikasi Klinik - Mobile Version",
    isactive  	= true
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'km001'
end)

client.test('Create App kw001', 'POST', 'app', {
    appid 		= "kw001",
    name 		= "klinik-webapp",
    description = "Aplikasi Klinik - Web Version",
    isactive  	= true
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'kw001'
end)

client.test('Get kw001', 'GET', 'app/kw001', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'kw001'
end)

client.test('Update App kw001', 'PUT', 'app/kw001', {
    name 		= "klinik-webapp 2",
    description = "Aplikasi Klinik - Web Version",
    isactive  	= true
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'kw001'
end)

client.test('Get kw001', 'GET', 'app/kw001', nil, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.name == 'klinik-webapp 2'
end)

client.test('Create App kx001', 'POST', 'app', {
    appid 		= "kx001",
    name 		= "klinik-webapp x",
    description = "Aplikasi Klinik - Web Version",
    isactive  	= true
}, function (res)
    return res.bodytable.result ~= nil and res.bodytable.result.appid == 'kx001'
end)

client.test('Delete kx002', 'DELETE', 'app/kx001', nil, function (res)
    return res.bodytable.description == 'found'
end)

client.test('Get List App', 'GET', 'app', nil, function (res)
    return res.bodytable.count == 2
end, true)

client.testsummary()