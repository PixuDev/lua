print("[SANDBOX TEST] Begin sandbox breakout scan\n")

local function safeget(name)
  local ok, val = pcall(function() return _G and _G[name] end)
  return ok and val or nil
end

-- 1. 测试 _G 全局访问
local ok1, g = pcall(function() return _G end)
if ok1 and type(g) == "table" then
  print("[FAIL] _G is still accessible!")
else
  print("[OK] _G blocked")
end

-- 3. 测试 load() 注入
local ok3, v3 = pcall(function()
  return load("return 123")()
end)
if ok3 then
  print("[FAIL] load() is available!")
else
  print("[OK] load() blocked")
end

-- 4. 测试 debug 库访问
if safeget("debug") then
  print("[FAIL] debug library is exposed!")
else
  print("[OK] debug blocked")
end

-- 5. 测试 require()
if safeget("require") then
  print("[FAIL] require() is exposed!")
else
  print("[OK] require blocked")
end

-- 6. 测试 coroutine 库
if safeget("coroutine") then
  print("[FAIL] coroutine is exposed!")
else
  print("[OK] coroutine blocked")
end

-- 7. 测试 os/ io 库
if safeget("os") then
  print("[FAIL] os is exposed!")
else
  print("[OK] os blocked")
end
if safeget("io") then
  print("[FAIL] io is exposed!")
else
  print("[OK] io blocked")
end

-- 8. 测试 rawget + global 表
local ok8 = pcall(function()
  local val = rawget(_ENV or {}, "os")
  if val then
    error("rawget leak")
  end
end)
if ok8 then
  print("[OK] rawget sandboxed")
else
  print("[FAIL] rawget can leak os")
end

-- 9. 测试 metatable __index 泄露
local mt = {}
setmetatable(mt, {
  __index = function(_, k)
    print("[INFO] __index triggered:", k)
    return os and os[k]
  end
})
if mt["execute"] then
  print("[FAIL] metatable allowed os access")
else
  print("[OK] metatable access safe")
end

print("\n[SANDBOX TEST] Done")