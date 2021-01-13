local random   = require "resty.random".bytes

local defaults = {
    length = 10
}

return function(session)
    local length = defaults.length
    local uid = ''
    local pad = random(length, true) or random(length)
    if session.data and session.data.user then
        uid = session.data.user.email
        local id_encoded = session.encoder.encode(uid .. pad)
        ngx.log(
                ngx.WARN, "session id: " .. id_encoded .. " created for: " .. uid ..
                        " from session " .. session.encoder.encode(session.id)
        )
    else
        ngx.log(ngx.WARN, "anonymous session id: " .. session.encoder.encode(pad) .. " create for non authenticated user")
    end
    ngx.log(ngx.DEBUG, "uid: " .. uid .. " pad: " .. pad)

    -- return uid if avalible with padding
    return (uid .. pad)
end
