local HRF = HodorReflexes
local Icons = LibCustomIcons
local Names = LibCustomNames
local LH = LibHyper
local HR = HodorRestyle

local classRoleIcons = { --FIXME should move that somewhere else
    [0] = { --None 
        [0] = '/esoui/art/icons/class/class_dragonknight.dds', --None
        [1] = '/esoui/art/icons/ability_dragonknight_001_b.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_dragonknight_007_b.dds', --Tank
        [4] = '/esoui/art/icons/ability_dragonknight_002_b.dds', --Healer'
    },
    [1] = { --Dragonknight
        [0] = '/esoui/art/icons/class/class_dragonknight.dds', --None
        [1] = '/esoui/art/icons/ability_dragonknight_001_b.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_dragonknight_007_b.dds', --Tank
        [4] = '/esoui/art/icons/ability_dragonknight_002_b.dds', --Healer'
    },
    [2] = { --Sorcerer
        [0] = '/esoui/art/icons/class/gamepad/gp_class_sorcerer.dds', --None
        [1] = '/esoui/art/icons/ability_sorcerer_thunderstomp.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_sorcerer_unstable_clannfear.dds', --Tank
        [4] = '/esoui/art/icons/ability_sorcerer_storm_prey_summoned.dds', --Healer'
    },
    [3] = { --Nightblade
        [0] = '/esoui/art/icons/class/gamepad/gp_class_nightblade.dds', --None
        [1] = '/esoui/art/icons/ability_nightblade_007_a.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_nightblade_013_a.dds', --Tank
        [4] = '/esoui/art/icons/ability_nightblade_012_b.dds', --Healer'
    },
    [4] = { --Warden
        [0] = '/esoui/art/icons/class/gamepad/gp_class_warden.dds', --None
        [1] = '/esoui/art/icons/ability_warden_013_a.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_warden_002.dds', --Tank
        [4] = '/esoui/art/icons/ability_warden_008.dds', --Healer
    },
    [5] = { --Necromancer
        [0] = '/esoui/art/icons/class/gamepad/gp_class_necromancer.ddss', --None
        [1] = '/esoui/art/icons/ability_necromancer_001.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_necromancer_008_b.dds', --Tank
        [4] = '/esoui/art/icons/ability_necromancer_013.dds', --Healer'
    },
    [6] = { --Templar
        [0] = '/esoui/art/icons/class/gamepad/gp_class_templar.dds', --None
        [1] = '/esoui/art/icons/ability_templar_over_exposure.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_templar_radiant_ward.dds', --Tank
        [4] = '/esoui/art/icons/ability_templar_breath_of_life.dds', --Healer'
    },
    [117] = { --Arcanist
        [0] = '/esoui/art/icons/class/gamepad/gp_class_arcanist.dds', --None
        [1] = '/esoui/art/icons/ability_arcanist_006_b.dds', --Damage Dealer
        [2] = '/esoui/art/icons/ability_arcanist_008_b.dds', --Tank
        [4] = '/esoui/art/icons/ability_arcanist_013_b.dds', --Healer'
    }

}


local iconTypeFunctions = {
    ['hodor'] = function(groupMemberName, groupMemberNumber, icon, classId)
        if Icons.GetStatic(groupMemberName) ~= nil then
            icon:SetTexture(Icons.GetStatic(groupMemberName))
        else
            icon:SetTexture(classRoleIcons[classId][0])
        end
    end,
    ['class'] = function(_, groupMemberNumber, icon, classId)
        icon:SetTexture(classRoleIcons[classId][0])
    end,
    ['classRole'] = function(_, groupMemberNumber, icon, classId)
        icon:SetTexture(classRoleIcons[classId][0])
    end,
}

local textColorFunctions = {
    ['hodor'] = function(groupMemberName, label, i)
        local name = Names.Get(groupMemberName) or groupMemberName
        label:SetText(i .. '. ' ..name)
    end,
    ['white'] = function (groupMemberName, label, i)
        label:SetText(i .. '. ' .. groupMemberName) --FIXME remove the @
    end,
}

local function newUpdateDamage()

    local container = HodorRestyleContainer:GetNamedChild('container')
    local timer = container:GetNamedChild('timer')

    if IsUnitInCombat("player") or not HR.savedVariables.hideOutOfCombat then
        container:SetHidden(false)
    else
        container:SetHidden(true)
        return
    end

    local maxDps = 0
    local filteredTable = {}
    local groupMemberNumber = 1
    for name,data in pairs(HRF.modules.share.playersData) do
        local groupMemberName = name
        local groupMemberData = data

        if groupMemberData and groupMemberData.dps > 0 then
            groupMemberData.groupMemberName = groupMemberName
            groupMemberData.groupMemberNumber = groupMemberNumber

            table.insert(filteredTable, groupMemberData)

            if maxDps < groupMemberData.dmg/10 then
                maxDps = groupMemberData.dmg/10
            end

        end
        groupMemberNumber = groupMemberNumber + 1
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

            local classId = filteredTable[i].classId or 0
            if classId > 6 and classId ~= 117 then
                classId = 0
            end
            textColorFunctions[HR.savedVariables.textColor](groupMemberName, label, i)
            if classId ~= 0 then
                iconTypeFunctions[HR.savedVariables.iconType](groupMemberName, groupMemberNumber, icon, classId)
            end

            if dmgType == 1 then -- total damage
                damage:SetText(dmg/100 .. 'M || ' .. dps .. 'K')
            else -- boss fight
                damage:SetText(dmg/10 .. 'k (' .. dps .. 'K)')
            end

            bar:SetDimensions(HR.savedVariables.barWidth * (dmg/10)/maxDps, HR.savedVariables.barHeight)
            bar:SetTextureCoords(0,(dmg/10)/maxDps,0,1)

            bar:SetColor(unpack(LH.classColors[classId]))

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
