local GUI = script.Parent

local boolean = false

game.UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.M then
		if boolean == false then
			GUI.Enabled = true
			boolean = true
		else
			GUI.Enabled = false
			boolean = false
		end
	end
end)