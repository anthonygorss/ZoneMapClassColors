local BLIP_TEX_COORDS = {
 ["WARRIOR"]={0,0.125,0,0.25}, ["PALADIN"]={0.125,0.25,0,0.25},
 ["HUNTER"]={0.25,0.375,0,0.25}, ["ROGUE"]={0.375,0.5,0,0.25},
 ["PRIEST"]={0.5,0.625,0,0.25}, ["DEATHKNIGHT"]={0.625,0.75,0,0.25},
 ["SHAMAN"]={0.75,0.875,0,0.25}, ["MAGE"]={0.875,1,0,0.25},
 ["WARLOCK"]={0,0.125,0.25,0.5}, ["DRUID"]={0.25,0.375,0.25,0.5},
 ["MONK"]={0.125,0.25,0.25,0.5}, ["DEMONHUNTER"]={0.375,0.5,0.25,0.5}
}

local frame = CreateFrame("Frame",nil,BattlefieldMinimap)
local frequency = 0.5 -- how often to update blips (while in group when map shown)
local timer = frequency
frame:Hide()
frame:SetScript("OnUpdate",function(self,elapsed)
 timer = timer + elapsed
 if timer > frequency then
 timer = 0
 local groupSize = GetNumGroupMembers()
 local groupUnit = IsInRaid() and "Raid" or "Party"
 if groupSize>0 then
 for i=1,groupSize do
 local blip = _G["BattlefieldMinimap"..groupUnit..i]
 if blip and blip.unit and blip:IsVisible() then
 local _,class = UnitClass(blip.unit)
if BLIP_TEX_COORDS[class] then
 local combat = UnitAffectingCombat(blip.unit) and 0.5 or 0
 local left,right,top,bottom = unpack(BLIP_TEX_COORDS[class])
 blip.icon:SetTexture("Interface\\Minimap\\PartyRaidBlips")
 blip.icon:SetTexCoord(left,right,top+combat,bottom+combat)
end
 end
 end
 end
 end
end)

frame:SetScript("OnEvent",function(self,event)
 timer = frequency
 self:SetShown(IsInGroup())
end)
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
