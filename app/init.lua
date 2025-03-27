box.cfg{
    listen = 3301
}

box.once("init", function()
    local kv = box.schema.space.create("kv")
    kv:format({
        {name = "key", type = "string"},
        {name = "value", type = "string"}
    })
    kv:create_index("primary", {parts = {"key"}})
end)
