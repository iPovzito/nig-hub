-- modules/bunnyhop.lua - Kleizer Hub (Rayfield v2.0)
-- =====================================================

-- 🧠 Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 🔹 Datos del módulo
local Module = {
    Name = "Bunny Hop",
    Version = "2.0",
    Author = "Klever"
}

-- 🔹 Variables globales
_G.BunnyHopEnabled = _G.BunnyHopEnabled or false
_G.BunnyHopSpeed   = _G.BunnyHopSpeed   or 30
_G.BunnyHopHoldKey = _G.BunnyHopHoldKey or Enum.KeyCode.Space

-- 🔹 Variables internas
local BunnyHopConnection
local IsKeyHeld = false

-- =====================================================
-- ⚙️ FUNCIONES PRINCIPALES
-- =====================================================
local function StartBunnyHop()
    if BunnyHopConnection then
        BunnyHopConnection:Disconnect()
        BunnyHopConnection = nil
    end
    BunnyHopConnection = RunService.Heartbeat:Connect(function()
        if not _G.BunnyHopEnabled then return end
        if not IsKeyHeld then return end

        local Character = LocalPlayer.Character
        if not Character then return end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HRP      = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not HRP then return end

        if Humanoid:GetState() == Enum.HumanoidStateType.Running then
            Humanoid.Jump = true
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                HRP.Velocity = Vector3.new(
                    moveDir.X * _G.BunnyHopSpeed,
                    HRP.Velocity.Y,
                    moveDir.Z * _G.BunnyHopSpeed
                )
            end
        end
    end)
end

local function StopBunnyHop()
    if BunnyHopConnection then
        BunnyHopConnection:Disconnect()
        BunnyHopConnection = nil
    end
end

-- =====================================================
-- 🎮 ENTRADAS DE TECLAS
-- =====================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == _G.BunnyHopHoldKey then
        IsKeyHeld = true
        if _G.BunnyHopEnabled then
            StartBunnyHop()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == _G.BunnyHopHoldKey then
        IsKeyHeld = false
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        StopBunnyHop()
    end
end)

-- =====================================================
-- 🧩 INTERFAZ DEL MÓDULO (Rayfield)
-- =====================================================
function Module.Init(tab)
    local Section = tab:CreateSection("Bunny Hop Settings")

    Section:CreateToggle({
        Name = "Enable BunnyHop",
        CurrentValue = _G.BunnyHopEnabled,
        Flag = "BunnyHopToggle",
        Callback = function(state)
            _G.BunnyHopEnabled = state
            if state then
                StartBunnyHop()
            else
                StopBunnyHop()
            end
        end
    })

    Section:CreateKeybind({
        Name           = "Hold Key",
        CurrentKeybind = _G.BunnyHopHoldKey,
        HoldToInteract = true,
        Flag           = "BunnyHopHoldKey",
        Callback       = function(key)
            _G.BunnyHopHoldKey = key
        end
    })

    Section:CreateSlider({
        Name         = "Speed",
        Range        = {10, 100},
        Increment    = 1,
        Suffix       = " u/s",
        CurrentValue = _G.BunnyHopSpeed,
        Flag         = "BunnyHopSpeed",
        Callback     = function(value)
            _G.BunnyHopSpeed = value
        end
    })
end

function Module.Unload()
    StopBunnyHop()
end

return Module
