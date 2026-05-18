export type Item = {
	name: string,
	description: string,
	rarity : string,
	amount: number,
	model: Model
}

-- constatns table for the item refrences

local Constants = {
	-- Items
	["Items"] = {
		wood = {
			Name = "Wood",
			Description = "A common material sourced from trees."
		},
		rock = {
			Name = "Rock",
			Description = "A rough stone fragment found on the ground."
		},
		iron = {
			Name = "Iron",
			Description = "A sturdy metal ore mined from the earth."
		},
		gold = {
			Name = "Gold",
			Description = "A rare and valuable metal."
		},
		diamond = {
			Name = "Diamond",
			Description = "An exceptionally rare gemstone."
		},
	},
}

return Constants
