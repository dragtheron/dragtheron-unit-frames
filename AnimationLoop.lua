AddonName, DragtheronUF = ...

DragtheronUF.AnimationLoop = CreateFrame("Frame", UIParent, nil);
DragtheronUF.AnimationLoop.animations = {};

function DragtheronUF.AnimationLoop:Tick(elapsed)
  for animationName, animation in pairs(self.animations) do
    if animation.active and not animation.complete then
      if animation.complete then
        if animation.elapsed >= animation.delayStart + animation.duration + animation.delayComplete then
          if animation.OnComplete ~= nil then
            animation.OnComplete();
          end
          animation.active = false;
        end
      else
        if animation.elapsed == 0 then
          animation.elapsed = 0.01;
        else
          animation.elapsed = animation.elapsed + elapsed;
        end
        if animation.elapsed >= animation.delayStart then
          if animation.elapsed < animation.delayStart + animation.duration then
            animation.currentValue = animation.startValue + ((animation.elapsed - animation.delayStart) / animation.duration) * animation.delta;
            if animation.OnUpdate ~= nil then
              animation.OnUpdate(animation.currentValue);
            end
          else
            if not animation.preserveValue then
              animation.currentValue = animation.startValue;
            else
              animation.currentValue = animation.targetValue;
            end
            if animation.OnUpdate ~= nil then
              animation.OnUpdate(animation.targetValue);
            end
          end
        end
        if animation.elapsed >= animation.delayStart + animation.duration + animation.delayComplete then
          if animation.OnComplete ~= nil then
            animation.OnComplete();
          end
          animation.complete = true;
          return;
        end
      end
    end
  end
end

function DragtheronUF.AnimationLoop:Play(name, targetValue)
  local animation = self.animations[name];
  if animation.currentValue == nil then
    animation.currentValue = 0.0
  end
  animation.startValue = animation.currentValue;
  if targetValue ~= nil then
    animation.targetValue = targetValue;
  end
  animation.delta = animation.targetValue - animation.startValue;
  if animation.resetOnPlay or animation.complete then
    animation.elapsed =0;
  end
  animation.active = true;
  animation.complete = false;
end

function DragtheronUF.AnimationLoop:Create(name, options)
  if options.startValue == nil then
    options.startValue = 0.0
  end
  if options.targetValue == nil then
    options.targetValue = 0.0
  end
  if options.delayComplete == nil then
    options.delayComplete = 0.0
  end
  if options.delayStart == nil then
    options.delayStart = 0.0
  end
  if options.resetOnPlay == nil then
    options.resetOnPlay = true
  end
  local config = {
    active = false,
    complete = true,
    elapsed = 0,
    startValue = options.startValue,
    currentValue = options.startValue,
    targetValue = options.targetValue,
    delayStart = options.delayStart,
    delayComplete = options.delayComplete,
    delta = options.targetValue - options.startValue,
    duration = options.duration,
    OnUpdate = options.OnUpdate,
    OnComplete = options.OnComplete,
    resetOnPlay = options.resetOnPlay,
    preserveValue = options.preserveValue
  };
  if self.animations[name] == nil then
    self.animations[name] = config;
  else
    error("Animation Override Not Allowed");
  end
end

function DragtheronUF.AnimationLoop:SetCurrentValue(name, value)
  self.animations[name].currentValue = value;
  if self.animations[name].OnUpdate then
    self.animations[name].OnUpdate(value);
  end
end
