-- main.lua - Kleizer Hub Loader (Rayfield)
-- =========================================================

-- 🧠 Cargar Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- 🔹 Crear ventana principal
local Window = Rayfield:CreateWindow({
    Name = "Kleizer Hub",
    LoadingTitle = "Loading Kleizer Hub...",
    LoadingSubtitle = "by Klever",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KleizerHub",
        FileName = "settings"
    },
})

-- =========================================================
-- 🧩 CREAR TABS
-- =========================================================
local RageTab = Window:CreateTab("RAGE", 4483362458)
local MiscTab = Window:CreateTab("MISC", 4483362458)
local MovementTab = Window:CreateTab("MOVEMENT", 4483362458)

-- =========================================================
-- 🔧 FUNCIÓN PARA CARGAR MÓDULOS
-- =========================================================
local function LoadModule(tab, url)
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success and module and typeof(module.Init) == "function" then
        local ok, err = pcall(function()
            module.Init(tab)
        end)

        if ok then
            print("[✅ KleizerHub] Módulo cargado:", module.Name or "Desconocido")
        else
            warn("[⚠️ Error ejecutando Init en módulo]:", err)
        end
    else
        warn("[❌ Error al cargar módulo]:", url)
    end
end

-- =========================================================
-- 🚀 CARGAR MÓDULOS
-- =========================================================
-- 🐇 BunnyHop (Movimiento)
LoadModule(MovementTab, "https://pastefy.app/ycJps6vj/raw")

-- 🔫 Aquí puedes agregar más módulos fácilmente:
-- LoadModule(RageTab, "https://tuscripts.com/rage/aimbot.lua")
-- LoadModule(MiscTab, "https://tuscripts.com/misc/fly.lua")

-- =========================================================
-- 🔔 NOTIFICACIÓN FINAL
-- =========================================================
Rayfield:Notify({
    Title = "Kleizer Hub",
    Content = "Modules loaded successfully!",
    Duration = 5,
})
