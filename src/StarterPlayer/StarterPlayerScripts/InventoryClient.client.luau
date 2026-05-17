local rs = game:GetService("ReplicatedStorage")
local Players = game.Players
local Runservice = game.RunService
local collectionservice = game:GetService("CollectionService")
local UpdateUiEvent = rs.Events.UpdateInventoryUI
local DropEvent = rs.Events.DropEvent
local playergui = Players.LocalPlayer.PlayerGui

local UI = playergui:WaitForChild("InventoryUI")
local Main = playergui:WaitForChild("InventoryUI").Main
local Modelfolder = rs.ItemModels
local Connections = {}

local scrollingframe = Main.ScrollingFrame
local ItemInfo = UI.Main.ItemInfo
local Description = ItemInfo.DescriptionFrame.DescriptionText
local SelectedItemName = ItemInfo.ItemName.TextLabel
local DropButton = ItemInfo.DropButton

local RotationSpeed = math.rad(1)
local IsRotating = true
local RotationToggleButton = scrollingframe.Parent.RotationToggleButton

local SelectedItem = nil

local UiStrokes = {
	common = Color3.new(0, 0, 0),
	uncommon = Color3.new(0.427451, 1, 0.25098),
	rare = Color3.new(0.247059, 0.192157, 1),
	epic = Color3.new(0.65098, 0.164706, 1),
	legendary = Color3.new(1, 1, 0)
}

local camerapos = Vector3.new(0, 1.5, 4.25)
local cameraorientation = Vector3.new(-15, 0, 0)
local modelpos = Vector3.new(0, 0, 0)

local RotateTag = "Rotate"

local function updateui(inventory)
	print("function called")
	-- clear scrolling frame
	for _, slot in scrollingframe:GetChildren() do
		if slot:IsA("ViewportFrame") then
			slot:Destroy()
		end
	end
	
	for _, conn in Connections do
		conn:Disconnect()
	end
	
	table.clear(Connections)
	
	-- build scrolling frame

	for _, item in inventory do
		local Slot = rs.Templates.ItemSlotTemplate:Clone()
		Slot.Parent = scrollingframe
		
		local Model = Modelfolder[item.name]:Clone()
		Model.Parent = Slot
		Model.PrimaryPart.Orientation = Vector3.new(0,0,0)
		Model:PivotTo(CFrame.new(modelpos))

		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new(camerapos, Model.PrimaryPart.Position)
		camera.Parent = Slot

		Slot.CurrentCamera = camera

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Color = UiStrokes[item.rarity]
		UIStroke.Thickness = 1.5
		UIStroke.Parent = Slot
		
		local Amount = Slot.Amount
		Amount.Text = item.amount
		
		if not collectionservice:HasTag(Model, RotateTag) then
			collectionservice:AddTag(Model, "Rotate")
		end
		
		local conn
		conn = Runservice.Heartbeat:Connect(function()
			if not Model.PrimaryPart then
				conn:Disconnect()
				return
			end
			if IsRotating then
				Model.PrimaryPart.CFrame = Model.PrimaryPart.CFrame * CFrame.Angles(0,RotationSpeed,0)
			else
				return
			end
		end)
		table.insert(Connections, conn)
		
		local SelectButton = Slot.SelectButton
		
		SelectButton.MouseButton1Up:Connect(function()
			SelectedItem = item
			SelectedItemName.Text = SelectedItem.name or ""
			Description.Text = item.description or ""
			print(SelectedItem)
		end)
	end
end

-- outside updateui, connects once
DropButton.MouseButton1Up:Connect(function()
	if not SelectedItem then return end
	DropEvent:FireServer(SelectedItem.name)
end)

RotationToggleButton.MouseButton1Up:Connect(function()
	if not IsRotating then
		IsRotating = true
		RotationToggleButton.Text = "Item rotation: on"
	else
		IsRotating = false
		RotationToggleButton.Text = "Item rotation: off"
	end
end)

UpdateUiEvent.OnClientEvent:Connect(updateui)
