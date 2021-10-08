-- ceat_ceat fake instance
-- please keep my credit! thank you!
local http = game:GetService("HttpService")
if _G.BaseInstance then return _G.BaseInstance end
loadstring(game:HttpGet("https://raw.githubusercontent.com/ceat-ceat/roblox-script-utils/main/fakebindable.lua"))()
local instancemaker,instances = {},{}
local instance = {
	__index = function(self,index)
		local inst = instances[self.badbaseinstanceidlol]
		local properties,functions,events = inst.Properties,inst.Functions,inst.Events
		return properties and properties[index] and properties[index].Value or events and events[index] or functions and functions[index]
	end,
	__newindex = function(self,index,value)
		local inst = instances[self.badbaseinstanceidlol]
		local properties = inst.Properties
		local property = properties[index]
		assert(property,string.format("'%s' is not a valid property of %s",index,properties.Name.Value))
		assert(not property.ReadOnly,"can't set value")
		local oldval = property.Value
		local newval do
			local valid,quotes = false,typeof(value) == "string" and "'" or ""
			if property.Filter then
				valid,newval = pcall(property.Filter,value)
			else
				valid,newval = true,value
			end
			assert(valid,string.format("%s%s%s is not a valid value for %s.%s",quotes,tostring(value),quotes,properties.Name.Value,index))
		end
		property.Value = newval
		if newval ~= oldval then
			inst.ChangedEvent:Fire(index,newval)
		end
	end,
	__metatable = function()
		return "The metatable is locked."
	end,
	__tostring = function(self)
		return instances[self.badbaseinstanceidlol].Properties.Name.Value
	end,
}

--[[
{
Properties = {
Name = {ReadOnly=false,Value="yes",Filter=function()  end},
}
}

]]

function namefilter(val)
	assert(typeof(val) == "string")
	return val
end

function instancemaker.new(classname: string,properties: table,events:table,functions: table)
	assert(typeof(classname) == "string","ClassName must be a string")
	assert(typeof(properties) == "table" or properties == nil,"Properties must be a table or nil")
	if properties ~= nil then
		properties.Name = {Value=classname,Filter=namefilter}
	end
	local id = http:GenerateGUID(false)
	local new = setmetatable({badbaseinstanceidlol=id},instance)
	local changedevent = _G.FakeBindable.new()
	events = typeof(events) == "table" and events or {}
	events.Changed = changedevent.Event
	instances[id] = {ChangedEvent=changedevent,Properties=properties,Events=events,Functions=functions}
	return new
end

_G.BaseInstance = instancemaker
return _G.BaseInstance
