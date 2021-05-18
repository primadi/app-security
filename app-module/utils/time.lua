local ffi = require('ffi')

ffi.cdef[[
    typedef long time_t;
    typedef struct timeval {
    time_t tv_sec;
    time_t tv_usec;
} timeval;
    int gettimeofday(struct timeval *t, void *tzp);
]]

local timeval_buf = ffi.new("timeval")

return {
    now = function()
        ffi.C.gettimeofday(timeval_buf, nil)
        return tonumber(timeval_buf.tv_sec * 1000 + (timeval_buf.tv_usec / 1000))
    end
}