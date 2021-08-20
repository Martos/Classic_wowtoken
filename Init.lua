local frame, events = CreateFrame("Frame"), {};

C_WowTokenPublic.UpdateMarketPrice();
local PGGold = math.floor(math.abs((GetMoney() / 100 / 100)));
local tokenPrice = C_WowTokenPublic.GetCurrentMarketPrice();
if tokenPrice == nil then
    tokenPrice = 0;
else
    tokenPrice = tokenPrice / 100 / 100;
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("PLAYER_MONEY");
frame:RegisterEvent("PLAYER_TRADE_MONEY");

local statusbar = CreateFrame("StatusBar", nil, UIParent)
statusbar:SetMovable(true);
statusbar:EnableMouse(true);
statusbar:RegisterForDrag("LeftButton")
statusbar:SetScript("OnDragStart", statusbar.StartMoving)
statusbar:SetScript("OnDragStop", statusbar.StopMovingOrSizing)
statusbar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 2)
--statusbar:SetWidth(330)
--statusbar:SetHeight(20)
statusbar:SetHeight(10)
statusbar:SetWidth(800)
statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar:GetStatusBarTexture():SetHorizTile(false)
statusbar:GetStatusBarTexture():SetVertTile(false)
--statusbar:SetStatusBarColor(0.64, 0.19, 0.79)
statusbar:SetStatusBarColor(51/255, 153/255, 255/255)
statusbar:SetFrameStrata("MEDIUM")
statusbar:SetMinMaxValues(0, 100);
statusbar:SetValue(0);

local function progressBarUpdates()
    PGGold = math.floor(math.abs((GetMoney() / 100 / 100)));
    C_WowTokenPublic.UpdateMarketPrice();
    tokenPrice = C_WowTokenPublic.GetCurrentMarketPrice();
    if tokenPrice == nil then
        C_WowTokenPublic.UpdateMarketPrice();
    else
        tokenPrice = tokenPrice / 100 / 100;
    end

    statusbar:SetMinMaxValues(0, tokenPrice);
    statusbar:SetValue(PGGold);

    local percentage = math.floor(((PGGold * 100) / tokenPrice) * 10) / 10;
    if(percentage < 0) then percentage = 100; end

    --LocationText:SetText(percentage.." %")
end

local function eventHandler(self, event, ...)

    if event == "PLAYER_TRADE_MONEY" then
        progressBarUpdates()
    end
    if event == "PLAYER_MONEY" then
        progressBarUpdates()
    end
    if event == "PLAYER_ENTERING_WORLD" then
        progressBarUpdates()
    end

end

frame:SetScript("OnEvent", eventHandler);