local client = require('http.client').new()
local json = require 'json'

local exports = {}
local ctr = 1

local baseurl = 'localhost/'
local succesctr = 0
local failctr = 0

exports.tesinit = function (test_baseurl)
    if test_baseurl ~= nil then
        baseurl = test_baseurl
    end
    succesctr = 0
    failctr = 0
end

exports.request = function(method, url, body, options)
    local res
    if body ~= nil then
        body = json.encode(body)
    end

    if options == nil then
        options = {}
    end
    
    if options.headers == nil then
        options.headers = {}
    end
    options.headers['content-Type'] = 'application/json'

    local res = client:request(method, baseurl .. url, body, options)
    if res.body == nil then
        res.body = ''
        res.bodytable = {}
    else
        res.bodytable = json.decode(res.body)
    end
    return res
end

exports.test = function(name, method, url, body, fnValidate, showRespBody)
    local res = exports.request(method, url, body)
    if fnValidate == nil then
        fnValidate = function(_) return true end
    end
    
    if res.status == 200 and fnValidate(res) == true then
        print(ctr .. '. Test ' .. name .. ': PASSED')
        if showRespBody then
            print('--> Response Body: ' .. res.body)
        end
        succesctr = succesctr + 1
    else
        print(ctr .. '. Test ' .. name .. ': FAILED')
        print('--> Response Body: ' .. res.body)
        failctr = failctr + 1
    end
    ctr = ctr + 1
end

exports.testsummary = function ()
    print('\nTest PASSED : ' .. succesctr)
    print('Test FAILED : ' .. failctr .. '\n')
end

return exports