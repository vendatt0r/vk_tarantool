box.cfg{
    listen = 3301
}

if not box.space.kv then
    box.schema.space.create("kv")
    box.space.kv:format({
        {name = "key", type = "string"},
        {name = "value", type = "string"}
    })
    box.space.kv:create_index("primary", {parts = {"key"}})
end
