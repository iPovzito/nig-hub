
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()


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


local RageTab = Window:CreateTab("RAGE", 4483362458)
local MiscTab = Window:CreateTab("MISC", 4483362458)


local function LoadModule(tab, url)
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success and module and typeof(module.Init) == "function" then
        module.Init(tab)
        print("[✅ KleizerHub] Módulo cargado:", module.Name)
    else
        warn("[❌ Error al cargar módulo]:", url)
    end
end


LoadModule(RageTab, "https://raw.githubusercontent.com/iPovzito/nig-hub/refs/heads/main/bhop.lua")  -- BunnyHop



Rayfield:Notify({
    Title = "Nigg Hub",
    Content = "Modules loaded successfully!",
    Duration = 5,
})
