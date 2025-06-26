print("[TEST] Basic print works")

-- test math
assert(math.abs(-1.2) == 1.2, "[FAIL] math.abs")
assert(math.floor(3.6) == 3, "[FAIL] math.floor")

-- test string
assert(string.upper("hello") == "HELLO", "[FAIL] string.upper")
assert(string.find("pixu", "xu"), "[FAIL] string.find")

-- test table
local t = {a = 1, b = 2}
t.c = 3
assert(t.a + t.b + t.c == 6, "[FAIL] table basic")
for k, v in pairs(t) do print("table:", k, v) end

-- test ipairs
for i, v in ipairs({"a", "b", "c"}) do
  print("ipair", i, v)
end

-- test function / closure
local function make_counter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end
local counter = make_counter()
assert(counter() == 1 and counter() == 2, "[FAIL] closure")

-- test metatable
local m = {}
setmetatable(m, {
  __index = function(_, k) return "hi:" .. k end
})
assert(m.abc == "hi:abc", "[FAIL] metatable")

-- test pcall
local ok, err = pcall(function() error("oops") end)
assert(ok == false and string.find(err, "oops"), "[FAIL] pcall did not catch error")

-- test sandboxed globals
local blocked = {"os", "io", "debug", "coroutine", "require", "loadfile", "dofile", "load", "load_file", "collectgarbage"}
for _, name in ipairs(blocked) do
  if _G[name] ~= nil then
    print("[FAIL] dangerous global not removed: " .. name)
  else
    print("[OK] global blocked:", name)
  end
end

print("[PASS] All checks passed")