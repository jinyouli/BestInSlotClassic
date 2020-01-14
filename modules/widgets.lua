-- Helpers function to create widgets.
local backdrop = {
    bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
    tile = true, tileSize = 16, edgeSize = 16, 
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
};
    
function IsSelfOrChild(self, focus)
    -- This function helps validate that the focus is within the local hierarchy.
    return focus and (self == focus or IsSelfOrChild(self, focus:GetParent()));
end
    
function StopMovingOrSizing(self)
    if self.isMoving then
        self:StopMovingOrSizing();
        self.isMoving = false;
    end
end

function StartMovingOrSizing(self, fromChild)
    if not self:IsMovable() and not self:IsResizable() then
        return
    end
    if self.isMoving then
        StopMovingOrSizing(self);
    else
        self.isMoving = true;
        if not self:IsMovable() or ((select(2, GetCursorPosition()) / self:GetEffectiveScale()) < math.max(self:GetTop() - 40, self:GetBottom() + 10)) then
            self:StartSizing();
        else
            self:StartMoving();
        end
    end
end
    
local function HideParent(self)
    self:GetParent():Hide();
end
    
function CreateWindow(name, height, width)
    local window = CreateFrame("FRAME", "BISManager", UIParent);        
    window:EnableMouse(true);
    window:SetMovable(true);
    window:SetResizable(true);
    window:SetPoint("CENTER");
	window:SetMinResize(32, 32);
	window:SetSize(height, width);
    window:SetUserPlaced(true);
    window:SetBackdrop(backdrop);
    window:SetBackdropBorderColor(1, 1, 1, 1);
    window:SetBackdropColor(0, 0, 0, 1);
    window:SetClampedToScreen(true);
	window:SetToplevel(true);        
	window:SetScript("OnMouseDown", StartMovingOrSizing);
	window:SetScript("OnMouseUp", StopMovingOrSizing);
	window:SetScript("OnHide", StopMovingOrSizing);

    -- The Close Button. It's assigned as a local variable so you can change how it behaves.
    window.CloseButton = CreateFrame("Button", nil, window, "UIPanelCloseButton");
    window.CloseButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", 4, 3);
    window.CloseButton:SetScript("OnClick", HideParent);

    return window;
end

function CreateCheckBox(name, label, parent, x, y, tooltip, callback)
    local checkbox = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate");
    checkbox.tooltip = tooltip;
    checkbox:SetPoint("TOPLEFT", x, y);
    _G[name.."Text"]:SetText(label);
    checkbox:SetScript("OnClick", callback);

    return checkbox;
end

function CreateSlider(name, label, parent, min, max, x, y, callback)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate");
    slider:SetPoint("TOPLEFT", x, y);
    slider:SetMinMaxValues(min, max);
    slider:SetWidth(200);
    slider:SetValueStep(1);
    slider:SetStepsPerPage(1);
    slider:SetWidth(200);
    slider:SetObeyStepOnDrag(true);    
    slider:SetScript("OnValueChanged", callback);
    _G[name.."Text"]:SetText(label);
    _G[name.."Low"]:SetText(min);
    _G[name.."High"]:SetText(max);

    return slider;
end

local races = { "Human", "Gnome", "Dwarf", "Night Elf", "Orc", "Undead", "Tauren", "Troll" };
local class = { "Warrior", "Shaman", "Druid", "Hunter", "Mage", "Warlock", "Priest", "Rogue", "Paladin" };
local specs = { "Todo" };
local phases = { "Phase 1", "Phase 2 - Preraid", "Phase 2", "Phase 3 - Preraid", "Phase 3", "Phase 4", "Phase 5", "Phase 6" };

function Initialize_RacesDropDown(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo();

    for idx, value in ipairs(races) do
        info.text, info.checked = value, false;
        UIDropDownMenu_AddButton(info);
    end
end

function Initialize_ClassDropDown(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo();

    for idx, value in ipairs(class) do
        info.text, info.checked = value, false;
        UIDropDownMenu_AddButton(info);
    end
end

function Initialize_SpecsDropDown(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo();

    for idx, value in ipairs(specs) do
        info.text, info.checked = value, false;
        UIDropDownMenu_AddButton(info);
    end
end

function Initialize_PhaseDropDown(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo();

    for idx, value in ipairs(phases) do
        info.text, info.checked = value, false;
        UIDropDownMenu_AddButton(info);
    end
end

local dropdownInitializer = {
    ["races"] = Initialize_RacesDropDown,
    ["class"] = Initialize_ClassDropDown,
    ["specs"] = Initialize_SpecsDropDown,
    ["phases"] = Initialize_PhaseDropDown,
}

local dropdownText = {
    ["races"] = "Select your race",
    ["class"] = "Select your class",
    ["specs"] = "Select your spec",
    ["phases"] = "Select your phase",
}

function CreateDropDownList(name, label, parent, width, x, y, items, callback)
    local dropdown = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");    
    dropdown:SetPoint("TOPLEFT", x, y);
    UIDropDownMenu_SetWidth(dropdown, width);
    UIDropDownMenu_SetText(dropdown, dropdownText[items]);
    UIDropDownMenu_Initialize(dropdown, dropdownInitializer[items]);

    return dropdown;
end
