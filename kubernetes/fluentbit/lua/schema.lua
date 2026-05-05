-- 1. Pure Lua JSON Serializer (No cjson required)
function to_json(val)
    local t = type(val)
    if t == "string" then
        -- Escape quotes, backslashes, and newlines so DuckDB can parse it later
        local escaped = string.gsub(val, "\\", "\\\\")
        escaped = string.gsub(escaped, '"', '\\"')
        escaped = string.gsub(escaped, "\n", "\\n")
        return '"' .. escaped .. '"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "table" then
        -- Detect if the table is an array or a key-value object
        if val[1] ~= nil then
            local res = {}
            for _, v in ipairs(val) do
                table.insert(res, to_json(v))
            end
            return "[" .. table.concat(res, ",") .. "]"
        else
            local res = {}
            for k, v in pairs(val) do
                -- Ignore complex Lua types like functions or threads
                if type(v) ~= "function" and type(v) ~= "userdata" then
                    table.insert(res, '"' .. tostring(k) .. '":' .. to_json(v))
                end
            end
            return "{" .. table.concat(res, ",") .. "}"
        end
    else
        return 'null'
    end
end

-- 2. The formatting logic
function format_for_parquet(tag, timestamp, record)
    local new_record = {}

    -- Pass the original log timestamp through the firewall
    new_record["time"] = record["time"] or "1970-01-01T00:00:00Z"

    -- Extract K8s metadata into rigid Parquet columns
    local k8s = record["kubernetes"] or {}
    new_record["namespace"] = k8s["namespace_name"] or "unknown"
    new_record["pod"]       = k8s["pod_name"] or "unknown"
    new_record["container"] = k8s["container_name"] or "unknown"
    new_record["node"]      = k8s["host"] or "unknown"

    -- The Catch-All: Use our custom pure Lua function to safely stringify the record
    new_record["raw_json"] = to_json(record)

    -- Keep the UUID
    new_record["log_id"] = record["log_id"] or "missing-id"

    return 1, timestamp, new_record
end
