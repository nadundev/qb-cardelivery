local QBCore = exports['qb-core']:GetCoreObject()

-- Function to draw 3D text
function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)
    local scale = 200 / (GetGameplayCamFov() * distance)

    SetTextColourRed(255, 255, 255, 255)
    SetTextScale(0.0, 0.55 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

-- Function to create a PolyZone
function CreatePolyZone(coords, length, width, debugPoly)
    local polyZone = PolyZone:Create(coords, {
        debugPoly = debugPoly,
        length = length,
        width = width,
    })

    return polyZone
end
