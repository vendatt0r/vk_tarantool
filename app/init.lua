box.cfg{
    listen = 3301,
    wal_dir = "/app/tarantool_wal",
    memtx_dir = "/app/tarantool_memtx",
    vinyl_dir = "/app/tarantool_vinyl"
}

local kv = box.schema.space.create("kv", {if_not_exists = true})

kv:format({
    {name = "key", type = "string"},
    {name = "value", type = "string"}
})

kv:create_index("primary", {parts = {"key"}, if_not_exists = true})

box.schema.user.grant('guest', 'read,write,execute', 'universe', {if_not_exists = true})
