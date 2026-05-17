--// Services 

local Rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local ProfileStore = require(SSS.ServerPackages.ProfileStore)

--// Variables

local DefaultData = require(Rs.Data.DataTemplate)

local updateuievent = Rs.Events.UpdateInventoryUI

local Data_Store_Key = "PlayerData"

if RunService:IsStudio() then
	Data_Store_Key = "Test_PlayerDataV5"
end

local PlayerStore = ProfileStore.New(Data_Store_Key, DefaultData.PlayersData)

local Profiles: {[Player]: typeof(PlayerStore:StartSessionAsync())} = {}

local Shared = {}

local function Init(Player)
	local Profile = PlayerStore:StartSessionAsync(`{Player.UserId}`, {
		Cancel = function ()
			return Player.Parent ~= Players
		end,
	})

	if Profile ~= nil then
		Profile:AddUserId(Player.UserId)
		Profile:Reconcile()

		Profile.OnSessionEnd:Connect(function()
			Profiles[Player] = nil
			Player:Kick(`Session ended - Please rejoin`)
		end)

		if Player.Parent == Players then
			-- Load Profile
			Profiles[Player] = Profile
			Shared.LoadInventory(Player)
			print(`Profile loaded for {Player.DisplayName}`)
		else
			Profile:EndSession()
		end
	else
		Player:Kick(`Data Failed to load - PLease rejoin`)
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(Init, player)
end

function Shared.GetData(Player: Player): DefaultData.PlayerData?
	local profile = Profiles[Player]
	if not profile then return end

	return profile.Data
end

function Shared.LoadInventory(player)
	local Data = Profiles[player].Data
	if not Data then return end
	
	local inventory = Data.inventory
	
	updateuievent:FireClient(player, inventory)
end

Players.PlayerAdded:Connect(Init)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end)

return Shared
