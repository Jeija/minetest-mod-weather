function weather_mod.weather_cmd_set()
	local weather_cmd = weather.cmd
	weather.cmd = false
	return weather_cmd or false
end

minetest.register_privilege("weather", {
	description = "Change the weather",
	give_to_singleplayer = false
})

-- Set weather
minetest.register_chatcommand("setweather", {
	params = "<weather>",
	description = "Set weather to a registered type of downfall\
		show all types when no parameters are given", -- full description
	privs = {weather = true},
	func = function(name, param)
		local types = "none"
		local setparam = false
		if param == "none" then
			setparam = true
		else
			for i,_ in pairs(weather_mod.registered_downfalls) do
				if i == param then
					setparam = true
					break
				end
				types=types..", "..i
			end
		end
		if not setparam then
			minetest.chat_send_player(name, "available weather types: "..types)
		else
			if param == "none" then
				weather.cmd = false
			else
				weather.cmd = true
			end
			weather.type = param
			weather_mod.handle_lightning()
		end
	end
})

-- Set wind
minetest.register_chatcommand("setwind", {
	params = "<wind>",
	description = "Set windspeed to the given x,z direction", -- full description
	privs = {weather = true},
	func = function(name, param)
		if param==nil or param=="" then
			minetest.chat_send_player(name, "please provide two comma seperated numbers")
			return
		end
		local x,z = string.match(param, "^([%d.-]+)[, ] *([%d.-]+)$")
		x=tonumber(x)
		z=tonumber(z)
		if (not x) or (not z) then
			x, z = string.match(param, "^%( *([%d.-]+)[, ] *([%d.-]+) *%)$")
		end
		if x and z then
			weather.wind = vector.new(x,0,z)
		else
			minetest.chat_send_player(name, param.." are not two comma seperated numbers")
		end
	end
})
