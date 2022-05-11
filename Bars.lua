AddonName, DragtheronUF = ...

DragtheronUF.Bars = {};


local function createBorder(frame)
  local function createBorderElement(frame)
    local element = frame:CreateTexture(nil, "BACKGROUND", nil, -3);
    return element;
  end

  local borderBottom = createBorderElement(frame);
  borderBottom:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -2, 0);
  borderBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2);

  local borderLeft = createBorderElement(frame);
  borderLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2);
  borderLeft:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, -2);

  local borderRight = createBorderElement(frame);
  borderRight:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, 2);
  borderRight:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2);

  local borderTop = createBorderElement(frame);
  borderTop:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2);
  borderTop:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 2, 0);
  
  frame.border = {
    ["bottom"] = borderBottom;
    ["left"] = borderLeft;
    ["right"] = borderRight;
    ["top"] = borderTop;
  }
end

function DragtheronUF.Bars:Create(name, parent, height)
  local frame = CreateFrame("Frame", name, parent);

  frame.relative = 0;
  frame.previousRelative = 0;
  frame:SetSize(parent:GetWidth(), height);
  frame:SetPoint("TOPLEFT", 0, 0);

  createBorder(frame);

  frame.bar = frame:CreateTexture(nil, "BACKGROUND", nil, -2);
  --frame.bar:SetAtlas('ui-frame-bar-fill-white');
  frame.bar:SetAllPoints();

  frame.deltaBar = frame:CreateTexture(nil, "BACKGROUND", nil, -1);
  frame.deltaBar:SetPoint("TOPLEFT", frame.bar, "TOPRIGHT");
  frame.deltaBar:SetPoint("BOTTOMRIGHT", frame.bar, "BOTTOMRIGHT");
  frame.deltaBar:SetColorTexture(1, 1, 1);

  frame.background = frame:CreateTexture(nil, "BACKGROUND", nil, -4);
  frame.background:SetAllPoints();
  frame.background:SetColorTexture(0, 0, 0, 0.5);

  function frame:SetColors(color)
    self.bar:SetColorTexture(color[1], color[2], color[3]);
    self.border.top:SetColorTexture(color[1], color[2], color[3]);
    self.border.bottom:SetColorTexture(color[1], color[2], color[3]);
    self.border.left:SetColorTexture(color[1], color[2], color[3]);
    self.border.right:SetColorTexture(color[1], color[2], color[3]);
  end

  return frame;
end

function DragtheronUF.Bars:SetColors(color)
  self.bar:SetColorTexture(color[1], color[2], color[3]);
  self.border.top:SetColorTexture(color[1], color[2], color[3]);
  self.border.bottom:SetColorTexture(color[1], color[2], color[3]);
  self.border.left:SetColorTexture(color[1], color[2], color[3]);
  self.border.right:SetColorTexture(color[1], color[2], color[3]);
end
