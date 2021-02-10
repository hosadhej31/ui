# ui
ui's for my hub/scripts or a place to store my ui libs ive created.

# Luminosity
Alot of people like this lib and i like it too

## Luminosity: Example
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/VoidMasterX/ui/main/luminosity.lua", true))()

local window = library:CreateWindow({
    Name = "SOLARWIND",
    Version = "9.4.2"
})

local tab = window:CreateTab("Tab1")

tab:CreateToggle("TOGGLE ME 1", function(state)
    print("state:",state)
end)
tab:CreateToggle("TOGGLE ME 2", function(state)
    print("state:",state)
end)

tab:CreateSeperator()

tab:CreateButton("CLICK ME 1", function()
    print("button:","pressed me")
end)
tab:CreateButton("CLICK ME 2", function()
    print("button:","pressed me")
end)

tab:CreateSeperator()

tab:CreateLabel("LABEL 1")
tab:CreateLabel("LABEL 2")

tab:CreateSeperator()

tab:CreateSlider("Slider 1", {
    Min = 0,
    Max = 25000
}, function(value)
    print("slided me:",value)
end)
tab:CreateSlider("Slider 2", {
    Min = 0,
    Max = 25000
}, function(value)
    print("slided me:",value)
end)

tab:CreateSeperator()
```

## Luminosity: Docs
```lua
Library:CreateWindow(<table> options [Name, Version])
  <table> Window:CreateTab(<string> name)
    <void> Tab:SelectTab()
    <table> Tab:CreateButton(<string> name, <void> callback)
      <void> GetText()
      <void> SetText(<string> text)
    <table> Tab:CreateLabel(<string> name)
      <void> GetText()
      <void> SetText(<string> text)
    <void> Tab:CreateSeperator()
    <table> Tab:CreateToggle(<string> name, <void> callback)
      <void> GetState()
      <void> SetState(<bool> state)
    <table> Tab:CreateSlider(<string> name, <table> options [Min, Max], <void> callback)
      <void> GetValue()
      <void> SetValue(<number> value)
```

## Luminosity: Updates
```
- V1.0:
[+] Released
```
