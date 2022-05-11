AddonName, DragtheronUF = ...

DragtheronUF.Frame = CreateFrame('Frame', 'DragtheronUF', UIParent);

local PlayerFrame = DragtheronUF.Unit:Create('DragtheronUF_Player', UIParent, 'player');
PlayerFrame:SetPoint('TOPRIGHT', UIParent, 'CENTER', -100, -300);
--PlayerFrame:SetAlpha(0.2);
PlayerFrame:UpdateUnit();

local TargetFrame = DragtheronUF.Unit:Create('DragtheronUF_Target', UIParent, 'target', {
  showHealthText = true;
});
TargetFrame:SetPoint('TOPLEFT', UIParent, 'CENTER', 100, -300);
TargetFrame.HealthBar:RegisterEvent('PLAYER_TARGET_CHANGED', TargetFrame.HealthBar.OnEvent);
--TargetFrame:SetAlpha(0.2);

local GroupFrame = CreateFrame('Frame', 'DragtheronUF_Group', UIParent);
GroupFrame.spacing = 10;
GroupFrame.Units = {};
GroupFrame:SetPoint('BOTTOMLEFT', PlayerFrame, 'TOPLEFT', 0, GroupFrame.spacing);
GroupFrame:SetSize(200, (30 + GroupFrame.spacing) * 4);
for i = 1, 4 do
  GroupFrame.Units[i] = DragtheronUF.Unit:Create('$parentUnit' .. i, GroupFrame, 'party' .. i);
  --GroupFrame.Units[i]:SetAlpha(UnitExists('party' .. i) and 1 or 0.2);
  if i == 1 then
    GroupFrame.Units[i]:SetPoint('BOTTOMLEFT', GroupFrame, 'BOTTOMLEFT', 0, 0);
  else
    GroupFrame.Units[i]:SetPoint('BOTTOMLEFT', GroupFrame.Units[i - 1], 'TOPLEFT', 0, GroupFrame.spacing);
  end
end

local RaidFrame = CreateFrame('Frame', 'DragtheronUF_Raid', UIParent);
RaidFrame.Units = {};
RaidFrame.spacing = 10;
RaidFrame.height = 26;
RaidFrame:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 100);
RaidFrame:SetSize(200, (RaidFrame.height + RaidFrame.spacing) * 40);
for i = 1, 40 do
  RaidFrame.Units[i] = DragtheronUF.Unit:Create('$parentUnit' .. i, RaidFrame, 'raid' .. i);
  --RaidFrame.Units[i]:SetAlpha(UnitExists('raid' .. i) and 1 or 0.2);
  RaidFrame.Units[i]:SetSize(200, RaidFrame.height);
  RaidFrame.Units[i].HealthBar:SetSize(200, RaidFrame.height - 6);
  RaidFrame.Units[i].HealthBar.HealIncoming:SetSize(200, RaidFrame.height - 6);
  RaidFrame.Units[i].HealthBar.Absorb:SetSize(200, RaidFrame.height - 6);
  if i == 1 then
    RaidFrame.Units[i]:SetPoint('BOTTOMLEFT', RaidFrame, 'BOTTOMLEFT', 0, 0);
  else
    if i % 20 == 1 then
      RaidFrame.Units[i]:SetPoint('BOTTOMLEFT', RaidFrame.Units[(i - 1) / 20], 'BOTTOMRIGHT', RaidFrame.spacing * 2, 0);
    else
      if i % 5 == 1 then
        RaidFrame.Units[i]:SetPoint('BOTTOMLEFT', RaidFrame.Units[i - 1], 'TOPLEFT', 0, RaidFrame.spacing * 2);
      else
        RaidFrame.Units[i]:SetPoint('BOTTOMLEFT', RaidFrame.Units[i - 1], 'TOPLEFT', 0, RaidFrame.spacing);
      end
    end
  end
end

local BossFrame = CreateFrame('Frame', 'DragtheronUF_Boss', UIParent);
BossFrame.spacing = 10;
BossFrame.Units = {};
BossFrame:SetPoint('BOTTOMLEFT', TargetFrame, 'TOPLEFT', 0, BossFrame.spacing);
BossFrame:SetSize(200, (30 + BossFrame.spacing) * 4);
for i = 1, 4 do
  BossFrame.Units[i] = DragtheronUF.Unit:Create('$parentUnit' .. i, BossFrame, 'boss' .. i, {
    showHealthText = true;
  });
  if i == 1 then
    BossFrame.Units[i]:SetPoint('BOTTOMLEFT', BossFrame, 'BOTTOMLEFT', 0, 0);
  else
    BossFrame.Units[i]:SetPoint('BOTTOMLEFT', BossFrame.Units[i - 1], 'TOPLEFT', 0, BossFrame.spacing);
  end
end

local function updateUnits(groupFrame)
  for key, player in pairs(groupFrame.Units) do
    if UnitExists(player.unit) then
      player:UpdateUnit()
    else
    end
  end
end

DragtheronUF.AnimationLoop:SetScript('OnUpdate', DragtheronUF.AnimationLoop.Tick);

local function updateGroupFrameVisibility() 
  RaidFrame:Hide();
  GroupFrame:Hide();
  _G['PlayerFrame']:Hide();
  _G['TargetFrame']:Hide();
  if UnitInRaid('player') then
    RaidFrame:Show();
  else
    GroupFrame:Show();
  end
end

function DragtheronUF.Frame:OnEvent(event)
  if event == 'PLAYER_REGEN_DISABLED' and not UnitExists('target') then
    --PlayerFrame:SetAlpha(1);
  elseif event == 'PLAYER_REGEN_ENABLED' then
    --PlayerFrame:SetAlpha(0.2);
    local threatColor = DragtheronUF.Colors.Health.Dead;
    PlayerFrame.ThreatIndicator.texture:SetColorTexture(threatColor[1], threatColor[2], threatColor[3]);
  elseif event == 'PLAYER_TARGET_CHANGED' then
    if UnitExists('target') then
      --PlayerFrame:SetAlpha(1);
      --TargetFrame:SetAlpha(1);
      TargetFrame:UpdateUnit();
    else
      --TargetFrame:SetAlpha(0.2);
    end
  elseif event == 'RAID_ROSTER_UPDATE' then
    updateUnits(RaidFrame);
  elseif event == 'GROUP_ROSTER_UPDATE' then
    updateUnits(GroupFrame);
    updateUnits(RaidFrame);
    updateGroupFrameVisibility();
  elseif event == 'PLAYER_ENTERING_WORLD' or event == 'UNIT_NAME_UPDATE' then
    PlayerFrame:UpdateUnit();
    updateUnits(GroupFrame);
    updateUnits(RaidFrame);
    updateUnits(BossFrame);
    updateGroupFrameVisibility();
  elseif event == 'PLAYER_SPECIALIZATION_CHANGED' then
    PlayerFrame:UpdateUnit();
  end
end

DragtheronUF.Frame:RegisterEvent('PLAYER_REGEN_ENABLED');
DragtheronUF.Frame:RegisterEvent('PLAYER_REGEN_DISABLED');
DragtheronUF.Frame:RegisterEvent('PLAYER_TARGET_CHANGED');
DragtheronUF.Frame:RegisterEvent('GROUP_ROSTER_UPDATE');
DragtheronUF.Frame:RegisterEvent('RAID_ROSTER_UPDATE');
DragtheronUF.Frame:RegisterEvent('PLAYER_ENTERING_WORLD');
DragtheronUF.Frame:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED');
DragtheronUF.Frame:RegisterEvent('UNIT_NAME_UPDATE');
DragtheronUF.Frame:SetScript('OnEvent', DragtheronUF.Frame.OnEvent);
