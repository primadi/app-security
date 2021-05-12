local module = require('utils.module')

box.cfg{
   -- log = '/var/log/tarantool/data.log'
}

module.load('ddlv1')
module.load('main')
