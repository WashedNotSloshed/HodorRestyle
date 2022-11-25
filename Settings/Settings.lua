local LAM = LibAddonMenu2
local HR = HodorRestyle
local LH = LibHyper

local function updateFont()
    local container = HodorRestyleContainer:GetNamedChild('container')
    local damageLabel = container:GetNamedChild('damageLabel')
    damageLabel:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    for i=1, 12 do
        local damage = container:GetNamedChild('damage' .. i)
        local label = container:GetNamedChild('label' .. i)
        damage:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
        label:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    end
end

local function updateBar()
    local container = HodorRestyleContainer:GetNamedChild('container')
    for i=1, 12 do
        local background = container:GetNamedChild('background' .. i)
        local bar = container:GetNamedChild('bar' .. i)
        background:SetCenterTexture(HR.savedVariables.backgroundBarTexture)
        bar:SetTexture(HR.savedVariables.barTexture)
    end
end

function HodorRestyle.InitializeSettings()
    local panelData = {
        type = "panel",
        name = "HodorRestyle",
        displayName = "HodorRestyle",
        author = "Hyperioxes",
        version = "0.1",
        registerForRefresh = true,
        registerForDefaults = false,
    }

    LAM:RegisterAddonPanel("HodorRestyleSettings", panelData)

    local optionsTable = {}

    table.insert(optionsTable, {
        type = "header",
        name = "Position",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "button",
        name = "Unlock UI",
        func = function()
            HodorRestyleContainer:SetMovable(HodorRestyleContainer:IsHidden())
            HodorRestyleContainer:SetHidden(not HodorRestyleContainer:IsHidden())
        end,
        width = "half",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Anchor to:",
        choices = LH.getTableKeys(LH.anchors),
        choicesValues = LH.getTableValues(LH.anchors),
        getFunc = function() return HR.savedVariables.anchor end,
        setFunc = function(var) HR.savedVariables.anchor = var
            HR.savedVariables.xPosition = 0
            HR.savedVariables.yPosition = 0
            HodorRestyleContainer:ClearAnchors()
            HodorRestyleContainer:SetAnchor(HR.savedVariables.anchor, GuiRoot, HR.savedVariables.anchor, HR.savedVariables.xPosition, HR.savedVariables.yPosition)
        end,
        width = "half",
    })

    table.insert(optionsTable, {
        type = "header",
        name = "Font",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Style:",
        choices = LH.getTableKeys(LH.fonts),
        choicesValues = LH.getTableValues(LH.fonts),
        getFunc = function() return HR.savedVariables.fontStyle end,
        setFunc = function(var) HR.savedVariables.fontStyle = var
            updateFont()
        end,
    })
    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Weight:",
        choices = LH.fontWeights,
        getFunc = function() return HR.savedVariables.fontWeight end,
        setFunc = function(var) HR.savedVariables.fontWeight = var
            updateFont()
        end,
    })
    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Size:",
        choices = LH.fontSizes,
        getFunc = function() return HR.savedVariables.fontSize end,
        setFunc = function(var) HR.savedVariables.fontSize = var
            updateFont()
        end,
    })

    table.insert(optionsTable, {
        type = "header",
        name = "Bar",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Bar Texture:",
        choices = LH.getTableKeys(LH.barTextures),
        choicesValues = LH.getTableValues(LH.barTextures),
        getFunc = function() return HR.savedVariables.barTexture end,
        setFunc = function(var) HR.savedVariables.barTexture = var
            updateBar()
        end,
    })
	
    LAM:RegisterOptionControls("HodorRestyleSettings", optionsTable)

end