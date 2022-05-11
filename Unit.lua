AddonName, DragtheronUF = ...

DragtheronUF.Unit = {};

DragtheronUF.SpellRelevance = {
  [139068] = false;
  [132144] = false;
  [335148] = false;
  [308434] = false;
}

function DragtheronUF.Unit:Create(name, parent, unit, options)
  local frame = CreateFrame("Button", name, parent, 'SecureUnitButtonTemplate');

  if options == nil then
    options = {};
  end

  local frameName = frame:GetName();

  frame:SetSize(200, 36);
  frame:SetPoint("CENTER");
  frame:EnableMouse(true);
  frame:SetAttribute('unit', unit);
	frame:SetAttribute("*type1", "target")
	frame:SetAttribute("*type2", "togglemenu")
	frame:SetAttribute("type2", "togglemenu")
  frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  SecureUnitButton_OnLoad(frame, unit);
  RegisterUnitWatch(frame);

  frame.unit = unit;

  frame.HealthBar = DragtheronUF.Bars:Create("$parentHealthBar", frame, 30);

  frame.HealthBar.HealIncoming = CreateFrame("Frame", "$parentHealIncoming", frame);
  frame.HealthBar.HealIncoming:SetSize(0, frame.HealthBar:GetHeight());
  frame.HealthBar.HealIncoming:SetPoint("TOPLEFT", frame.HealthBar, "TOPLEFT", 0, 0);
  frame.HealthBar.HealIncoming.texture = frame.HealthBar.HealIncoming:CreateTexture(nil, 'BACKGROUND', nil, -4);
  frame.HealthBar.HealIncoming.texture:SetAllPoints();
  frame.HealthBar.HealIncoming.texture:SetColorTexture(0, 1, 0);

  frame.HealthBar.HealthText = CreateFrame('Frame', '$parentHealthText', frame.HealthBar);
  frame.HealthBar.HealthText:SetAllPoints();
  frame.HealthBar.HealthText:SetPoint('TOPLEFT', 6, 0);
  frame.HealthBar.HealthText:SetPoint('BOTTOMLEFT', 0, 2);
  frame.HealthBar.HealthText:Hide();
  frame.HealthBar.HealthText.text = frame.HealthBar.HealthText:CreateFontString('$parentHealth', 'OVERLAY', 'GameFontNormalMed2Outline');
  frame.HealthBar.HealthText.text:SetAllPoints();
  frame.HealthBar.HealthText.text:SetJustifyH('LEFT');
  frame.HealthBar.HealthText.text:SetJustifyV('BOTTOM');

  frame.HealthBar.Absorb = CreateFrame("Frame", "$parentAbsorb", frame);
  frame.HealthBar.Absorb:SetSize(0, 30);
  frame.HealthBar.Absorb:SetPoint("TOPLEFT", frame.HealthBar, "TOPLEFT", 0, 0);
  frame.HealthBar.Absorb.texture = frame.HealthBar.Absorb:CreateTexture(nil, 'BACKGROUND', nil, -1);
  frame.HealthBar.Absorb.texture:SetAllPoints();
  frame.HealthBar.Absorb.texture:SetColorTexture(0.6392156862745098, 0.207843137254902, 0.9333333333333333);

  frame.RoleIndicator = CreateFrame("Frame", "$parentRoleIndicator", frame);
  frame.RoleIndicator:SetSize(10, 10);
  frame.RoleIndicator:SetPoint("BOTTOMLEFT", frame.HealthBar, 'BOTTOMLEFT', -8, 0);
  frame.RoleIndicator.texture = frame.RoleIndicator:CreateTexture(nil, 'BACKGROUND', nil, 0);
  frame.RoleIndicator.texture:SetAllPoints();

  frame.ThreatIndicator = CreateFrame("Frame", "$parentThreatIndicator", frame);
  frame.ThreatIndicator.threatSituation = 0;
  frame.ThreatIndicator:SetSize(10, 10);
  frame.ThreatIndicator:SetPoint("TOPRIGHT", frame.HealthBar, 'TOPRIGHT', 8, 0);
  frame.ThreatIndicator.texture = frame.ThreatIndicator:CreateTexture(nil, 'BACKGROUND', nil, 0);
  frame.ThreatIndicator.texture:SetAllPoints();

  frame.CastBar = CreateFrame('Frame', '$parentCast', frame);
  frame.CastBar:SetSize(0, frame.HealthBar:GetHeight() * 0.5);
  frame.CastBar:SetPoint('TOPLEFT', frame.HealthBar, 'TOPLEFT', 0, 0);
  frame.CastBar:SetPoint('BOTTOMRIGHT', frame.HealthBar, 'BOTTOMRIGHT', 0, frame.HealthBar:GetHeight() * 0.5);
  frame.CastBar.texture = frame.CastBar:CreateTexture(nil, 'BACKGROUND', nil, 1);
  frame.CastBar.texture:SetAllPoints();
  frame.CastBar.texture:SetColorTexture(1, 1, 0);
  frame.CastBar:Hide();

  frame.UnitName = CreateFrame("Frame", "$parentUnitName", frame);
  frame.UnitName:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, 0);
  frame.UnitName.text = frame.UnitName:CreateFontString("$parentName", "OVERLAY", "GameFontNormalMed2Outline");
  frame.UnitName.text:SetText("Test");
  frame.UnitName.text:SetAllPoints();
  frame.UnitName.text:SetJustifyH("LEFT");
  frame.UnitName.text:SetJustifyV("TOP");
  frame.UnitName.text:SetTextColor(1, 1, 1);
  frame.UnitName:SetSize(frame:GetWidth() - 4, frame.UnitName.text:GetStringHeight());

  frame.Mana = DragtheronUF.Bars:Create("$parentMana", frame, 6);
  frame.Mana:SetColors(DragtheronUF.Colors.Power.Default);
  frame.Mana:SetPoint("TOPLEFT", frame.HealthBar, "BOTTOMLEFT", 0, 0);
  frame.Mana.PowerText = CreateFrame('Frame', '$parentHealthText', frame.Mana);
  frame.Mana.PowerText:SetAllPoints();
  frame.Mana.PowerText:SetPoint('TOPLEFT', 6, 0);
  frame.Mana.PowerText:SetPoint('BOTTOMLEFT', 0, 2);
  frame.Mana.PowerText:Hide();
  frame.Mana.PowerText.text = frame.Mana.PowerText:CreateFontString('$parentPowerText', 'OVERLAY', 'GameFontNormalMed2Outline');
  frame.Mana.PowerText.text:SetAllPoints();
  frame.Mana.PowerText.text:SetJustifyH('LEFT');
  frame.Mana.PowerText.text:SetJustifyV('BOTTOM');

  frame.Auras = CreateFrame("Frame", "$parentAuras", frame);
  frame.Auras:SetAllPoints();
  frame.Auras.AuraFrames = {};
  for i = 1, 5 do
    frame.Auras.AuraFrames[i] = CreateFrame('Frame', '$parentAuraFrame' .. i, frame.Auras);
    local auraFrame = frame.Auras.AuraFrames[i];
    auraFrame:SetSize(16, 16);
    if i == 1 then
      auraFrame:SetPoint("BOTTOMRIGHT", frame.Auras, "BOTTOMRIGHT", -2, 2);
    else
      auraFrame:SetPoint("BOTTOMRIGHT", frame.Auras.AuraFrames[i - 1], "BOTTOMLEFT", -1, 0);
    end
    auraFrame.icon = frame.Auras.AuraFrames[i]:CreateTexture(nil, 'BACKGROUND', nil, 0);
    auraFrame.icon:SetAllPoints();
    auraFrame.icon:SetColorTexture(1, 0, 0);
    auraFrame.Counter = CreateFrame('Frame', '$parentCount', auraFrame);
    auraFrame.Counter:SetAllPoints();
    auraFrame.Counter.text = auraFrame.Counter:CreateFontString('$parentText', 'OVERLAY', 'GameFontHighlightOutline');
    auraFrame.Counter.text:SetAllPoints();
    auraFrame.Counter:SetPoint('BOTTOMRIGHT', 0, 0);
    auraFrame.Counter.text:SetJustifyH("CENTER");
    auraFrame.Counter.text:SetJustifyV("CENTER");
    auraFrame.Counter.text:SetTextColor(1, 1, 1);

    function auraFrame:Update()
      self.icon:SetTexture(self:GetAttribute('icon'));
      local count = self:GetAttribute('count');
      if count > 0 then
        self.Counter.text:SetText(self:GetAttribute('count'));
        self.Counter:Show();
      else
        self.Counter:Hide();
      end
    end

    if options.showHealthText then
      frame.HealthBar.HealthText:Show();
    end
  end

  function frame.HealthBar:UpdateColors()
    local color, barAtlas;
    if self.relative > 0.67 then
      barAtlas = 'ui-frame-bar-fill-green';
      color = DragtheronUF.Colors.Health.Good;
    elseif self.relative > 0.33 then
      barAtlas = 'ui-frame-bar-fill-yellow';
      color = DragtheronUF.Colors.Health.Medium;
    elseif self.relative > 0.0 then
      barAtlas = 'ui-frame-bar-fill-red';
      color = DragtheronUF.Colors.Health.Bad;
    else
      color = DragtheronUF.Colors.Health.Dead;
      barAtlas = 'ui-frame-bar-fill-white';
    end
    --self.bar:SetAtlas(barAtlas, true);

    self:SetColors(color);
  end

  function frame.HealthBar:Update()
    local barWidth = self:GetWidth() * self.relative;
    if self.relative > 0.0 then
      self.bar:SetPoint("RIGHT", self, "LEFT", barWidth, 0);
    else
      self.bar:SetPoint("RIGHT", self, "RIGHT", 0, 0);
    end
    
    if self.healIncomingRelative ~= nil and self.healIncomingRelative > 0 and self.healIncomingRelative < 1 then  
      self.HealIncoming:SetWidth(self:GetWidth() * self.healIncomingRelative);
      self.HealIncoming:Show();
    else
      self.HealIncoming:Hide();
    end

    if self.healAbsorbRelative ~= nil and self.healAbsorbRelative > 0 then  
      self.Absorb:SetWidth(self:GetWidth() * min(1, self.healAbsorbRelative));
      self.Absorb:Show();
    else
      self.Absorb:Hide();
    end

    self:UpdateColors();
    self.HealthText.text:SetFormattedText('%.1f%%', self.relative * 100);
  end

  function frame.Mana:Update()
    local barWidth = self:GetWidth() * self.relative;
    self.bar:SetPoint("RIGHT", self, "LEFT", barWidth, 0);
    self.PowerText.text:SetFormattedText('%i%%', self.relative * 100);
  end

  function frame.ThreatIndicator:Update()
    if self.threatSituation == 0 then
      color = DragtheronUF.Colors.Threat.Good;
    elseif self.threatSituation == 1 then
      color = DragtheronUF.Colors.Threat.Medium;
    elseif self.threatSituation == 2 then
      color = DragtheronUF.Colors.Threat.Medium;
    elseif self.threatSituation == 3 then
      color = DragtheronUF.Colors.Threat.Bad;
    else
      color = DragtheronUF.Colors.Threat.None;
    end
    self.texture:SetColorTexture(color[1], color[2], color[3]);
  end

  frame.HealthBar:Update();

  function frame.HealthBar.OnAnimationUpdate(value)
    frame.HealthBar.deltaBar:SetWidth(value);
  end
  
  function frame.HealthBar.OnAnimationComplete()
    frame.HealthBar.deltaBar:Hide()
  end

  function frame.Mana.OnAnimationUpdate(value)
    frame.Mana.deltaBar:SetWidth(value);
  end
  
  function frame.Mana.OnAnimationComplete()
    frame.Mana.deltaBar:Hide()
  end
  
  function frame.HealthBar:StartAnimation()
    local barWidthOld = self:GetWidth() * self.previousRelative;
    local barWidthNew = self:GetWidth() * self.relative;
    local barWidth = abs(barWidthNew - barWidthOld);
    self.deltaBar:Show();
    self.deltaBar:ClearAllPoints();
    self.deltaBar:SetSize(barWidth, self.bar:GetHeight());

    if self.previousRelative > self.relative then
      self.deltaBar:SetPoint("TOPLEFT", self, "TOPLEFT", barWidthNew, 0);
      self.deltaBar:SetColorTexture(1, 0, 0);
    else
      self.deltaBar:SetPoint("TOPRIGHT", self, "TOPLEFT", barWidthNew, 0);
      self.deltaBar:SetColorTexture(1, 1, 1);
    end

    DragtheronUF.AnimationLoop:SetCurrentValue(frameName .. "HealthBar-Delta", barWidth);
    DragtheronUF.AnimationLoop:Play(frameName .. "HealthBar-Delta", 0);
  end

  function frame.Mana:StartAnimation()
    local barWidthOld = self:GetWidth() * self.previousRelative;
    local barWidthNew = self:GetWidth() * self.relative;
    local barWidth = abs(barWidthNew - barWidthOld);
    self.deltaBar:Show()
    self.deltaBar:ClearAllPoints();
    self.deltaBar:SetSize(barWidth, self.bar:GetHeight());

    if self.previousRelative > self.relative then
      self.deltaBar:SetPoint("TOPLEFT", self, "TOPLEFT", barWidthNew, 0);
      self.deltaBar:SetColorTexture(1, 0, 0);
    else
      self.deltaBar:SetPoint("TOPRIGHT", self, "TOPLEFT", barWidthNew, 0);
      self.deltaBar:SetColorTexture(1, 1, 1);
    end

    DragtheronUF.AnimationLoop:SetCurrentValue(frameName .. "Power-Delta", barWidth);
    DragtheronUF.AnimationLoop:Play(frameName .. "Power-Delta", 0);
  end
  
  function frame.HealthBar:OnEvent(event)
    self:FullUpdate();
  end

  function frame.ThreatIndicator:OnEvent(event)
    if not UnitExists(unit) then
      self.threatSituation = 0;
      return
    end
    if UnitIsEnemy(unit, 'player') then
      self.threatSituation = UnitThreatSituation('player', unit);
    else
      self.threatSituation = UnitThreatSituation(unit);
    end
    self:Update();
  end

  function frame.CastBar:OnEvent(event)
    if event == 'UNIT_SPELLCAST_START' then
      local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(unit)
      local startTime = startTimeMS / 1000;
      local endTime = endTimeMS / 1000;
      self.startTime = startTime;
      self.endTime = endTime;
      self.notInterruptible = notInterruptible;
      self.duration = GetTime() - startTime;
    end
  end

  function frame.Auras:FullUpdate()

    local function isIrrelevantSpell(spellId)
      return DragtheronUF.SpellRelevance[spellId] == false;
    end

    local function fillAura(name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod)
      if frame.Auras.auraCount <= 4 then
        frame.Auras.auraCount = frame.Auras.auraCount + 1;
        frame.Auras.AuraFrames[frame.Auras.auraCount]:SetAttribute('icon', icon);
        frame.Auras.AuraFrames[frame.Auras.auraCount]:SetAttribute('count', count);
        frame.Auras.AuraFrames[frame.Auras.auraCount]:Update();
        frame.Auras.AuraFrames[frame.Auras.auraCount]:Show();
      end
    end

    local function fillAuraIfCastByPlayer(name, icon, count, debuffType, duration, expirationTime, source, isStealable,
      nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod)
      if frame.Auras.auraCount <= 4 and source == 'player' and not isIrrelevantSpell(spellId) then
        frame.Auras.auraCount = frame.Auras.auraCount + 1;
        frame.Auras.AuraFrames[frame.Auras.auraCount]:SetAttribute('icon', icon);
        frame.Auras.AuraFrames[frame.Auras.auraCount]:SetAttribute('count', count);
        frame.Auras.AuraFrames[frame.Auras.auraCount]:Update();
        frame.Auras.AuraFrames[frame.Auras.auraCount]:Show();
      end
    end

    self.auraCount = 0
    for key, auraFrame in pairs(self.AuraFrames) do
      auraFrame:Hide()
    end
    if UnitIsEnemy(unit, 'player') then
      AuraUtil.ForEachAura(unit, 'HELPFUL', 999, fillAura);
    else
      AuraUtil.ForEachAura(unit, 'HELPFUL', 999, fillAuraIfCastByPlayer);
      AuraUtil.ForEachAura(unit, 'HARMFUL', 999, fillAura);
    end
  end

  function frame.HealthBar:FullUpdate()
    local relative;

    if UnitExists(unit) then
      local unitHealPrediction = UnitGetIncomingHeals(unit) or 0;
      local unitHealth = UnitHealth(unit);
      local unitHealthMax = UnitHealthMax(unit);
      self.healIncomingRelative = (unitHealPrediction + unitHealth) / unitHealthMax;
      self.healAbsorbRelative = UnitGetTotalHealAbsorbs(unit) / unitHealthMax;
      self:Update();
      relative = unitHealth / unitHealthMax;
    else
      relative = 0;
    end

    self.previousRelative = self.relative;
    self.relative = relative;

    if self.previousRelative ~= self.relative then
      self:Update();
      self:StartAnimation();
    end
  end

  function frame.Auras:OnEvent(event, ...)
    if event == 'UNIT_AURA' then
      local unitTarget, isFullUpdate, updatedAuras = ...;
      if unitTarget == unit and not AuraUtil.ShouldSkipAuraUpdate(isFullUpdate, updatedAuras, function() return true end) then
        self:FullUpdate();
      end
    elseif event == 'PLAYER_ENTERING_WORLD' then
      self:FullUpdate();
    end
  end

  function frame.Mana:OnEvent()
    self:FullUpdate();
  end

  function frame.Mana:FullUpdate()
    local powerR, powerG, powerB, powerColor;
    if UnitExists(unit) then
      local unitPower = UnitPower(unit);
      local unitPowerMax = UnitPowerMax(unit);
      relative = unitPower / unitPowerMax;
      _, powerType, powerR, powerG, powerB = UnitPowerType(unit);
      if powerR ~= nil then
        powerColor = { powerR, powerG, powerB };
        self:SetColors(powerColor);
      else
        powerColor = PowerBarColor[powerType];
        self:SetColors({ powerColor.r, powerColor.g, powerColor.b });
      end
    else
      relative = 0;
    end

    self.previousRelative = self.relative;
    self.relative = relative;

    if self.previousRelative ~= self.relative then
      self:Update();
      self:StartAnimation();
    end
  end

  function frame:UpdateUnit()
    local unitExists = UnitExists(self.unit);
    if unitExists then
      local unitClass, unitClassFilename = UnitClass(self.unit);
      
      local unitGroupRole = UnitGroupRolesAssigned(self.unit);

      if unitGroupRole == 'NONE' and self.unit == 'player' then
        local unitSpecIndex = GetSpecialization();
        unitGroupRole = GetSpecializationRole(unitSpecIndex);
      end
      
      local roleColor;

      if unitGroupRole == 'TANK' then
        roleColor = DragtheronUF.Colors.Role.Tank;
      elseif unitGroupRole == 'HEALER' then
        roleColor = DragtheronUF.Colors.Role.Healer;
      elseif unitGroupRole == 'DAMAGE' or unitGroupRole == 'DAMAGER' then
        roleColor = DragtheronUF.Colors.Role.Damage;
      end

      if roleColor ~= nil then
        self.RoleIndicator.texture:SetColorTexture(roleColor[1], roleColor[2], roleColor[3]);
        self.RoleIndicator:Show();
      else
        self.RoleIndicator:Hide();
      end

      local unitName = UnitName(self.unit);
      self.UnitName.text:SetText(unitName);
      local unitNameColor;
      if UnitIsPlayer(self.unit) then
        local classColorR ,classColorG, classColorB = GetClassColor(unitClassFilename);
        unitNameColor = {
          classColorR,
          classColorG,
          classColorB,
        };
      else
        self.reaction = UnitReaction(unit, 'player');
        if self.reaction > 4 then
          unitNameColor = DragtheronUF.Colors.Reaction.Friendly;
        elseif self.reaction == 4 then
          unitNameColor = DragtheronUF.Colors.Reaction.Neutral;
        else
          unitNameColor = DragtheronUF.Colors.Reaction.Hostile;
        end
        unitNameColor = { 1, 1, 1 };
      end

      self.Auras:FullUpdate();
      self.UnitName.text:SetTextColor(unitNameColor[1], unitNameColor[2], unitNameColor[3]);
      self.HealthBar:FullUpdate();
      self.Mana:FullUpdate();
    end
  end
  
  frame.HealthBar:RegisterEvent("PLAYER_ENTERING_WORLD");
  frame.HealthBar:RegisterEvent("UNIT_HEALTH");
  frame.HealthBar:RegisterEvent("UNIT_MAXHEALTH");
  frame.HealthBar:RegisterEvent("UNIT_HEAL_PREDICTION");
  frame.HealthBar:SetScript("OnEvent", frame.HealthBar.OnEvent);

  frame.ThreatIndicator:RegisterEvent('PLAYER_REGEN_ENABLED');
  frame.ThreatIndicator:RegisterEvent('PLAYER_REGEN_DISABLED');
  frame.ThreatIndicator:RegisterEvent('PLAYER_TARGET_CHANGED');
  frame.ThreatIndicator:RegisterEvent("UNIT_THREAT_LIST_UPDATE");
  frame.ThreatIndicator:SetScript("OnEvent", frame.ThreatIndicator.OnEvent);

  frame.Auras:RegisterEvent("PLAYER_ENTERING_WORLD");
  frame.Auras:RegisterEvent('UNIT_AURA');
  frame.Auras:SetScript('OnEvent', frame.Auras.OnEvent);

  frame.Mana:RegisterEvent("PLAYER_ENTERING_WORLD");
  frame.Mana:RegisterEvent("UNIT_POWER_UPDATE");
  frame.Mana:SetScript("OnEvent", frame.Mana.OnEvent);

  frame.CastBar:RegisterEvent('UNIT_SPELLCAST_START');
  frame.CastBar:RegisterEvent('UNIT_SPELLCAST_STOP');
  --frame.CastBar:SetScript('OnEvent', frame.CastBar.OnEvent);

  frame:SetScript('OnShow', frame.UpdateUnit);

  DragtheronUF.AnimationLoop:Create(frameName .. "HealthBar-Delta", {
    duration = 0.5;
    OnUpdate = frame.HealthBar.OnAnimationUpdate;
    OnComplete = frame.HealthBar.OnAnimationComplete;
    preserveValue = true;
  });

  DragtheronUF.AnimationLoop:Create(frameName .. "Power-Delta", {
    duration = 0.5;
    OnUpdate = frame.Mana.OnAnimationUpdate;
    OnComplete = frame.Mana.OnAnimationComplete;
    preserveValue = true;
  });


  return frame;
end
