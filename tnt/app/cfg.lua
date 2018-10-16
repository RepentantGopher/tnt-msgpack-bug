-- Enable strict mode to check undefined variables
require('strict').on()

local os = require('os')

local module = {}

local function get_env_var(name, default)
    local variable = os.getenv(name)
    if not variable and not default then
        error('Env variable "' .. name .. '" is missing!')
    end
    return variable
end

-- Username to access binary port
module.user = get_env_var('TARANTOOL_USER')
-- Password
module.password = get_env_var('TARANTOOL_PASSWORD')

-- Configuration for box.cfg()
module.cfg = {
--    log_level=7,
    memtx_memory = tonumber(get_env_var('TARANTOOL_MEMTX_MEMMORY')),
    read_only = false,
    listen = get_env_var('TARANTOOL_LISTEN'),
    memtx_dir = get_env_var('TARANTOOL_MEMTX_DIR'),
    wal_dir = get_env_var('TARANTOOL_WAL_DIR'),
}

return module