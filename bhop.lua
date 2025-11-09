-- modules/bunnyhop.lua - Kleizer Hub (Rayfield)
-- =====================================================

-- 🧠 Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 🔹 Datos del módulo
local Module = {
    Name = "Bunny Hop",
    Version = "1.3",
    Author = "Klever"
}

-- 🔹 Variables internas
local BunnyHopConnection
local IsKeyHeld = false

_G.BunnyHopEnabled = _G.BunnyHopEnabled or false
_G.BunnyHopKey = _G.BunnyHopKey or Enum.KeyCode.Space
_G.BunnyHopSpeed = _G.BunnyHopSpeed or 30

-- =====================================================
-- ⚙️ FUNCIONES PRINCIPALES
-- =====================================================
local function StartBunnyHop()
    if BunnyHopConnection then
        BunnyHopConnection:Disconnect()
        BunnyHopConnection = nil
    end

    BunnyHopConnection = RunService.Heartbeat:Connect(function()
        if not _G.BunnyHopEnabled or not IsKeyHeld then return end

        local Character = LocalPlayer.Character
        if not Character then return end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local Root = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not Root then return end

        if Humanoid:GetState() == Enum.HumanoidStateType.Running then
            Humanoid.Jump = true
            local moveDirection = Humanoid.MoveDirection
            if moveDirection.Magnitude > 0 then
                Root.Velocity = Vector3.new(
                    moveDirection.X * _G.BunnyHopSpeed,
                    Root.Velocity.Y,
                    moveDirection.Z * _G.BunnyHopSpeed
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
    if input.KeyCode == _G.BunnyHopKey then
        IsKeyHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == _G.BunnyHopKey then
        IsKeyHeld = false
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        StopBunnyHop()
    end
end)

-- =====================================================
-- 🧩 INTERFAZ DEL MÓDULO
-- =====================================================
function Module.Init(tab)
    local Section = tab:CreateSection("Movement / Bunny Hop")

    tab:CreateToggle({
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

    tab:CreateKeybind({
        Name = "Hop Key",
        CurrentKeybind = _G.BunnyHopKey,
        HoldToInteract = true,
        Flag = "BunnyHopKey",
        Callback = function(Key)
            _G.BunnyHopKey = Key
        end
    })

    tab:CreateSlider({
        Name = "Speed",
        Range = {10, 50},
        Increment = 1,
        Suffix = " u/s",
        CurrentValue = _G.BunnyHopSpeed,
        Flag = "BunnyHopSpeed",
        Callback = function(value)
            _G.BunnyHopSpeed = value
        end
    })
end

function Module.Unload()
    StopBunnyHop()
end

return Module
