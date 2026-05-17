local sss = game:GetService("ServerScriptService")
local rs = game:GetService("ReplicatedStorage")
local collectionservice = game:GetService("CollectionService")
local Inventoryservice = require(sss.Services.InventoryService)
local Item = require(sss.Classes:WaitForChild("Item"))
local DroppedItems = workspace.DroppedItems
local ItemFolder = rs.ItemModels
local Constants = require(rs.Utils.Constants)

local tag = "item"

local ItemService = {}

--[[
	ItemService's goal is to check for items getting added to the dropped items folder, and give the "item" tag to all dropped items. 
	Every time an item time is asigned, createitem function gets called. 
	CreateItem function makes a new item class, and sets up a listener for proximity prompts. 
	If triggered the inventory service stores the item in the player's inventory.
--]]

local function CreateItem(object: Model)
	local ProximityPromt = object:FindFirstChild("ProximityPrompt", true)
	local name = object.Name
	local description = Constants.Items[name].Description
	local rarity = object:GetAttribute("rarity")
	local item = Item.New(object.Name, description, rarity, 1, object)
	ProximityPromt.Triggered:Connect(function(player)
		Inventoryservice.Store(item, player)
	end)
end

local function Tag(Object: Instance)
	if collectionservice:HasTag(Object, tag) then
		return
	end

	collectionservice:AddTag(Object, tag)
end

-- function used to spawn items
function ItemService.AddItem(Name: string, Position: Vector3)
	for _, v in ItemFolder:GetChildren() do
		if v.Name == Name then
			local item = v:Clone()
			item.Parent = workspace.DroppedItems
			local Cframe = CFrame.new(Position)
			item:PivotTo(Cframe)
		end
	end
end

-- check for items getting added to the dropped items folder, and tag them with the "item" tag
DroppedItems.ChildAdded:Connect(function()
	for _, item in DroppedItems:GetChildren() do
		Tag(item)
	end
end)

collectionservice:GetInstanceAddedSignal(tag):Connect(CreateItem)

return ItemService
