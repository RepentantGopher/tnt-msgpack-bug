#!/usr/bin/env tarantool

-- Enable strict mode to check undefined variables
require('strict').on()

local cfg = require('app.cfg')
local box = require('box')

box.cfg(cfg.cfg)

box.once('init', function()
    if not box.schema.user.exists(cfg.user) then
        box.schema.user.create(cfg.user)
        box.schema.user.passwd(cfg.user, cfg.password)
    end

    box.schema.user.grant(cfg.user, 'read,write,execute', 'universe')

    local clients = box.schema.space.create('clients', { if_not_exists = true })
    clients:format({
        { 'id', 'unsigned' },
        { 'name', 'string' },
        { 'created_at', 'unsigned' },
    })
    clients:create_index('id', { sequence = true, if_not_exists = true })
    clients:create_index('name', { parts = { 'name' }, type = 'HASH', if_not_exists = true, unique = true })
end)

function decode()
    local fio = require('fio')
    local errno = require('errno')
    local f = fio.open('binary', {'O_RDONLY'})
    if not f then
        error("Failed to open file: "..errno.strerror())
    end
    local data = f:read(4096)
    f:close()
    return require('msgpack').decode(data)
end

--rawset(_G, 'api', api)