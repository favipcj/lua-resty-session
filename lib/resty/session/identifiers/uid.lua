local tonumber = tonumber
local random   = require "resty.random".bytes
local var      = ngx.var

local defaults = {
    length = 6,
    header_name = var.session_header_uid
}

return function(session)
    -- local config = session or defaults
    -- local length = tonumber(config.length, 10) or defaults.length
    local length = defaults.length
    -- local uid = ngx.req.get_headers()[defaults.header_name] or ''
    local uid = ''
    if session.data and session.data.user then
        uid = session.data.user.email
    end
    local pad = random(length, true) or random(length)
    ngx.log(ngx.STDERR, "header_name: " .. defaults.header_name .. " uid: " .. uid .. " pad: " .. pad)
    ngx.log(ngx.STDERR, "session info: ")
    if session.data.user then
        for k,v in pairs(session.data.user) do
            if type(v) == "string" then
                ngx.log(ngx.STDERR, 'key: ' .. k .. ' value: ' .. v)
            else
                ngx.log(ngx.STDERR, 'key: ' .. k)
            end
        end
    end
    -- for k, v in pairs(session.data) do
    --    ngx.log(ngx.STDERR, 'session data: ' .. k)
    --    ngx.log(ngx.STDERR, 'value type: ' .. type(v))
    --    if type(v) == "string" then
    --        ngx.log(ngx.STDERR, 'session data value: ' .. v)
    --    end
    --end

    -- return uid if avalible with padding
    return (uid .. pad)
end
