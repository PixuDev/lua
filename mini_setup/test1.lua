print("[ATTACK] Begin sandbox breakout test")

-- 2. 尝试用 load 构造访问
local ok2, getg = pcall(function()
  return load("return _G", "exploit", "t", {})()
end)
if ok2 then
  print("[FAIL] load() is available, _G escaped:", getg)
end

-- 3. 利用已存在的 load 函数
local ok3, gotload = pcall(function()
  return load("return load", "lol", "t", {})()
end)
if ok3 then
  print("[FAIL] Nested load() succeeded")
end

-- 4. 构造闭包外层变量访问
local dangerous
local fn = function()
  return function()
    return dangerous
  end
end
local attack = fn()
local res = attack()
if res ~= nil then
  print("[WARN] Closure leak detected!")
end

-- 5. metatable __index 漏洞探测
local mt = {}
setmetatable(mt, {
  __index = function(_, k)
    print("[INFO] __index called for", k)
    return os and os[k]
  end
})
local test = mt["execute"]
if test then
  print("[FAIL] Metatable allowed os access")
end

-- 6. 如果允许 rawget(_G, 'os') 则直接失控
if rawget and pcall(function()
  local rawg = rawget(_G or {}, "os")
  if rawg then
    print("[FAIL] rawget global access leak!")
  end
end) then end

print("[PASS] Breakout attempts completed")