local Data = {}

-- The default data template for profile store

Data.PlayersData = {
	inventory = {} 
}

export type PlayerData = typeof(Data.PlayersData)

return Data
