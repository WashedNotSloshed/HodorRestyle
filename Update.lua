local HRF = HodorReflexes
local LH = LibHyper

local function newUpdateDamage()

    local container = HodorRestyleContainer:GetNamedChild('container')
    local timer = container:GetNamedChild('timer')

    local maxDps = 0
    local filteredTable = {}
    for i=1, 12 do
        local groupMemberName = GetUnitDisplayName('group' .. i)
        local groupMemberData = HRF.modules.share.playersData[groupMemberName]
        if groupMemberData and groupMemberData.dps > 0 then
            groupMemberData.groupMemberName = groupMemberName
            groupMemberData.groupMemberNumber = i
            table.insert(filteredTable, groupMemberData)

            if maxDps < groupMemberData.dmg/10 then
                maxDps = groupMemberData.dmg/10
            end

        end
    end

    table.sort(filteredTable, function(x,y) return (x and x.dmg>y.dmg) end)

    local t = HRF.combat.GetCombatTime()
    timer:SetText(t > 0 and string.format('%d:%04.1f|u0:2::|u', t / 60, t % 60) or '')

    for i=1, 12 do
        local backgroundOutline = container:GetNamedChild('backgroundOutline' .. i)
        local background = container:GetNamedChild('background' .. i)
        local iconBackground = container:GetNamedChild('iconBackground' .. i)
        local icon = container:GetNamedChild('icon' .. i)
        local bar = container:GetNamedChild('bar' .. i)
        local damage = container:GetNamedChild('damage' .. i)
        local label = container:GetNamedChild('label' .. i)

        if filteredTable[i] and filteredTable[i].groupMemberName then

            local dmgType = filteredTable[i].dmgType
            local dps = filteredTable[i].dps
            local dmg = filteredTable[i].dmg
            local groupMemberName = filteredTable[i].groupMemberName
            local groupMemberNumber = filteredTable[i].groupMemberNumber

            if HRF.users[groupMemberName] and HRF.users[groupMemberName][2] then
                label:SetText(i .. '. ' .. HRF.users[groupMemberName][2])
            else
                label:SetText(i .. '. ' .. groupMemberName:sub(2)) --FIXME remove the @
            end

            if HRF.users[groupMemberName] and HRF.users[groupMemberName][3] then
                icon:SetTexture(HRF.users[groupMemberName][3])
            else
                icon:SetTexture('/esoui/art/icons/class/gamepad/gp_class_' .. GetUnitClass('group' .. groupMemberNumber) .. '.dds')
            end

            if dmgType == 1 then -- total damage
                damage:SetText(dmg/100 .. 'M || ' .. dps .. 'K')
            else -- boss fight
                damage:SetText(dmg/10 .. 'k (' .. dps .. 'K)')
            end

            bar:SetDimensions(284 * (dmg/10)/maxDps, 32)
            bar:SetTextureCoords(0,dps/maxDps,0,1)
            bar:SetColor(unpack(LH.classColors[GetUnitClassId('group' .. groupMemberNumber)]))

            backgroundOutline:SetHidden(false)
            background:SetHidden(false)
            iconBackground:SetHidden(false)
            icon:SetHidden(false)
            bar:SetHidden(false)
            label:SetHidden(false)
            damage:SetHidden(false)
        else
            backgroundOutline:SetHidden(true)
            background:SetHidden(true)
            iconBackground:SetHidden(true)
            icon:SetHidden(true)
            bar:SetHidden(true)
            label:SetHidden(true)
            damage:SetHidden(true)
        end
    end
end

function HodorRestyle.hookUpdateDamage()
    local oldUpdateDamage = HRF.modules.share.UpdateDamage
    HRF.modules.share.UpdateDamage = function()
        oldUpdateDamage()
        newUpdateDamage()
    end
end