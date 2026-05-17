local Itemservice = require(game.ServerScriptService.Services.ItemService)
local Inventoryservice = require(game.ServerScriptService.Services.InventoryService)
local DataService = require(game.ServerScriptService.Services.DataService)

for _, spawner in workspace.Spawners:GetChildren() do
	spawner.ProximityPrompt.Triggered:Connect(function()
		if spawner.Name == "WoodSpawner" then
			Itemservice.AddItem("wood", Vector3.new(0, 10, 0))
		elseif spawner.Name == "RockSpawner" then
			Itemservice.AddItem("rock", Vector3.new(0, 10, 0))
		elseif spawner.Name == "IronSpawner" then
			Itemservice.AddItem("iron", Vector3.new(0, 10, 0))
		elseif spawner.Name == "GoldSpawner" then
			Itemservice.AddItem("gold", Vector3.new(0, 10, 0))
		elseif spawner.Name == "DiamondSpawner" then
			Itemservice.AddItem("diamond", Vector3.new(0, 10, 0))
		end
	end)
end
