local rs = game:GetService("ReplicatedStorage")
local sss = game:GetService("ServerScriptService")
local updateuievent = rs.Events.UpdateInventoryUI
local dropevent = rs.Events.DropEvent
local ItemFolder = rs.ItemModels
local dataservice = require(sss.Services.DataService)
local constants = require(rs.Utils.Constants)

local InventoryService = {}

--[[
	The inventory service manages the player's inventory data.
	It handles adding, removing and stacking items.
]]

-- Updates the inventory ui when needed
local function UpdateInventoryUI(player: Player)
	local Data = dataservice.GetData(player)
	if not Data then
		return
	end

	local inventory = Data.inventory

	updateuievent:FireClient(player, inventory)
end

-- This function gets called only by the item service, so the client cannot store non-existing items
function InventoryService.Store(item: constants.Item, player: Player)
	local Data = dataservice.GetData(player)
	if not Data then
		return
	end

	local inventory = Data.inventory

	if inventory[item.name] then
		inventory[item.name].amount += item.amount
		print(inventory)
	else
		inventory[item.name] = {
			name = item.name,
			description = item.description,
			rarity = item.rarity,
			amount = item.amount,
		}
	end
	print(inventory)
	UpdateInventoryUI(player)
	item.model:Destroy()
end

-- on drop button pressed, drop the selected item
dropevent.OnServerEvent:Connect(function(player, itemname)
	local Data = dataservice.GetData(player)
	if not Data then
		return
	end

	local inventory = Data.inventory

	-- Check if the item that is being requested to drop is actually in the player's inventory
	if not inventory[itemname] then
		print("The item does not exist in the player's inventory")
		return
	end

	local rootpart = player.Character:WaitForChild("HumanoidRootPart")

	-- get the spawnpos , wich is 5 studs in front of the rootpart
	local item = inventory[itemname]
	local SpawnPos = rootpart.Position + rootpart.CFrame.LookVector * 5

	local amount = item.amount

	--if there are more than 2 items just change the amount, and if there is only one item then delete it
	if amount > 1 then
		item.amount -= 1
	else
		inventory[itemname] = nil
	end

	UpdateInventoryUI(player)

	-- drop the item infront of the player
	for _, v in ItemFolder:GetChildren() do
		if v.Name == itemname then
			local Item = v:Clone()
			Item.Parent = workspace.DroppedItems
			local Cframe = CFrame.new(SpawnPos)
			Item:PivotTo(Cframe)
		end
	end
end)

return InventoryService
