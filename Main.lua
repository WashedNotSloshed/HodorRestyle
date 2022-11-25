function OnAddOnLoaded(_, addonName)
    if addonName ~= HodorRestyle.name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(HodorRestyle.name, EVENT_ADD_ON_LOADED)

    --initialize saved variables
    HodorRestyle.savedVariables = ZO_SavedVars:NewAccountWide("HodorRestyleSV", 1, nil, HodorRestyle.defaultSavedVariables)

    HodorRestyle.InitializeUI()

    --initialize settings
    HodorRestyle.InitializeSettings()

    HodorRestyle.hookUpdateDamage()
    HodorReflexes_Share_Damage:SetAlpha(0) --hide original hodorReflexes
end

EVENT_MANAGER:RegisterForEvent(HodorRestyle.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

