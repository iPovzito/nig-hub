-- 🧠 Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 🔹 Datos del módulo
local Module = {
    Name = "Bunny Hop",
    Version = "3.3",
    Author = "Klever"
}

-- 🔹 Variables globales
_G.BunnyHopEnabled = _G.BunnyHopEnabled or false
_G.BunnyHopSpeed   = _G.BunnyHopSpeed   or 50

-- 🔹 Variables internas
local BunnyHopConnection
local IsKeyHeld = false -- Estado de la tecla Espacio (única tecla permitida)

-- =====================================================
-- ⚙️ FUNCIONES PRINCIPALES
-- =====================================================

local function StartBunnyHop()
    if BunnyHopConnection then return end
    
    BunnyHopConnection = RunService.Heartbeat:Connect(function()
        -- 1. Verificar si el Toggle está activo y si la tecla Espacio está presionada
        if not _G.BunnyHopEnabled or not IsKeyHeld then 
            StopBunnyHop() 
            return 
        end
        
        local Character = LocalPlayer.Character
        if not Character then return end
        
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HRP      = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HRP then return end

        -- LÓGICA CLAVE: FORZAR SALTO SOLO EN EL SUELO
        if Humanoid.FloorMaterial ~= Enum.Material.Air then
            Humanoid.Jump = true
        end
        
        -- 2. APLICAR VELOCIDAD EN LA DIRECCIÓN DE MOVIMIENTO (W/A/S/D)
        local moveDir = Humanoid.MoveDirection
        
        if moveDir.Magnitude > 0 then
             -- Impulsa en la dirección exacta del input del usuario
             HRP.Velocity = Vector3.new(
                moveDir.X * _G.BunnyHopSpeed,
                HRP.Velocity.Y,
                moveDir.Z * _G.BunnyHopSpeed
            )
        else
            -- Si no hay input de movimiento (solo se presiona Espacio), salta en el lugar.
            -- Mantenemos la inercia actual del personaje con un arrastre suave.
            HRP.Velocity = Vector3.new(
                HRP.Velocity.X * 0.9, 
                HRP.Velocity.Y,
                HRP.Velocity.Z * 0.9
            )
        end
    end)
end

local function StopBunnyHop()
    if BunnyHopConnection then
        BunnyHopConnection:Disconnect()
        BunnyHopConnection = nil
    end
    -- Limpiar estado de salto
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Jump = false
        end
    end
end

-- =====================================================
-- 🎮 MANEJO DE ENTRADAS MANUAL: DEDICADO SOLO A LA TECLA ESPACIO
-- =====================================================

UserInputService.InputBegan:Connect(function(input, processed)
    -- Activa solo si se presiona Espacio
    if input.KeyCode == Enum.KeyCode.Space then
        IsKeyHeld = true
        if _G.BunnyHopEnabled then
            StartBunnyHop()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    -- Desactiva solo si se suelta Espacio
    if input.KeyCode == Enum.KeyCode.Space then
        IsKeyHeld = false
        StopBunnyHop()
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
    
    -- 1. TOGGLE
    tab:CreateToggle({
        Name = "🟢 Activar Bunny Hop",
        CurrentValue = _G.BunnyHopEnabled,
        Flag = "BunnyHopToggle",
        Callback = function(state)
            _G.BunnyHopEnabled = state
            if not state then
                StopBunnyHop()
            elseif IsKeyHeld then 
                StartBunnyHop()
            end
        end,
    })

    -- 2. SLIDER
    tab:CreateSlider({
        Name = "🔥 Velocidad del Bunny Hop",
        Range = {30, 500},
        Increment = 5,
        Suffix = " u/s",
        CurrentValue = _G.BunnyHopSpeed,
        Flag = "BunnyHopSpeed",
        Callback = function(value)
            _G.BunnyHopSpeed = value
        end
    })
    
    -- 3. TECLA FIJA (Etiqueta informativa)
    tab:CreateLabel("Tecla de Activación: [ESPACIO] (Fija)")

end

function Module.Unload()
    StopBunnyHop()
end

return Module
