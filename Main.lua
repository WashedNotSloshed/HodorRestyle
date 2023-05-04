local HR = HodorRestyle

function OnAddOnLoaded(_, addonName)
    if addonName ~= HR.name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(HR.name, EVENT_ADD_ON_LOADED)

    --initialize saved variables
    HR.savedVariables = ZO_SavedVars:NewAccountWide("HodorRestyleSV", 1, nil, HR.defaultSavedVariables)

    HR.InitializeUI()

    --initialize settings
    HR.InitializeSettings()

    HR.hookUpdateDamage()
    HodorReflexes_Share_Damage:SetAlpha(0) --hide original hodorReflexes

    HR.registerChangingVisibilityOnCombatChange()
end

EVENT_MANAGER:RegisterForEvent(HR.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

