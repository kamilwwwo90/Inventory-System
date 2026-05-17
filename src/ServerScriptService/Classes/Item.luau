local Item = {}
Item.__index = Item

function Item.New(Name: string, Description: string, Rarity: string, Amount: number, Model: Model)
	local self = setmetatable({}, Item)

	self.name = Name
	self.description = Description
	self.rarity = Rarity
	self.amount = Amount
	self.model = Model

	return self
end

return Item
