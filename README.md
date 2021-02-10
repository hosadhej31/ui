# ui
ui's for my hub/scripts or a place to store my ui libs ive created.

# Luminosity
Alot of people like this lib and i like it too

## Docs
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
