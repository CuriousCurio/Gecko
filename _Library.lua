-- Carries containers full of attributes for each property
local function StripLibraryTag(suffixes:{}, i) -- Strips a library tag at the end of a string index
	for tag:'' in next,suffixes do -- Removing profix
		local len = #tag;
		if (i:sub(-len) == tag) then return i:sub(0,-len-1); end -- Checking if the profix ending was equal to the stored profix ending in 'library_profix'
	end
	return i;
end
local function ToNumerical(table:{}) -- Shifts all indicies to values, using numerical indicies as orginization
	local temp, ni = {},1;
	for i,v in next,table do
		temp[ni],ni = i,ni+1;
	end
	for i,v in ipairs(temp) do
		table[v] = nil;
		table[i] = v;
	end
	return table;
end

local __public:{} = {
	Iterate = function(self) -- Iterates through all library items
		return next,self['...'];
	end,
	Insert = function(self, library) -- Inserts all library items into this library
		for att:'',att_tb:{} in library:Iterate() do
			local this_att_tb:{} = self[att];
			if (this_att_tb == nil) then continue; end
			for i,v in next,att_tb do
				this_att_tb[i] = v;
			end
		end
	end,
	Push = function(self, i:'', __:{}) -- Searches and inserts all attributes of a property name
		for att:'',att_tb:{} in self:Iterate() do
			if (__[att] == nil) then
				__[att] = att_tb[i];
			end
		end
	end,
	AutoSort = function(self, tb) -- Uses the sorting iterator to automatically sort
		for i,__ in self:Sort(tb) do
			for att:'',v in next,__ do
				self[att][i] = v;
			end
		end
	end,
	SortProperties = function(self, sorted:{}, table) -- Finds all property indicies in the table given
		 -- Getting properties thrown in the root table --
		for i,v:any in next,table do
			if (type(i) ~= 'string') then error(string.format("For class initialization, string indicies are only allowed, there is currently a %s", typeof(i))); end
			if (self['...'][i] ~= nil) then continue; end -- if library container

			sorted[StripLibraryTag(self['...'], i)] = true;
		end

		-- Getting properties in catigorized tables --
		for att:'' in next,self do
			local tb:{} = table[att];
			if (tb) then
				for i in next,tb do
					sorted[i] = true;
				end
			end
		end
		return sorted;
	end,
	Sort = function(self, tb) -- Returns a sorting iterator to use for sorting attributes into tables
		local properties, ni = ToNumerical(self:SortProperties({}, tb)), 1;
		local __:{} = {}; -- attributes for each property found in 'tb' and this library


		return function()
			table.clear(__);
			local i:'';
			i, ni = properties[ni], ni+1;
			if (i == nil) then return; end

			-- PropertyName__abc   (Getting property settings with prosets)
			for att:'' in self:Iterate() do
				local suffix:'' = att == '__' and '' or att; -- don't use '__' suffix for '__' container
				__[att] = tb[i..suffix]; -- if found with suffix of attribute
			end

			local __attributes:{} = tb[i..'__']; -- Property setting table, any item that looks like 'Name__ = {}' will be considered
			if (__attributes) then -- PropertyName__[{}]    (Setting a properties' library table)
				for att:'' in self:Iterate() do
					if (__[att] == nil and __attributes[att] ~= nil) then
						__[att] = __attributes[att];
					end
				end
			end

			-- __abc[{}] <- PropertyName    (Getting properties in catigorized tables)
			for att:'' in self:Iterate() do
				if (__[att] == nil and tb[att] ~= nil) then
					__[att] = tb[att][i];
				end
			end

			return i,__;
		end
	end
};

local Library:{new:(any)} = {
	__metatable = {__type = '_Library'},
	__index = function(self, i)
		local v = __public[i]; -- if in storage device
		if (v ~= nil) then return v; end
		return self['...'][i];
	end,
	__newindex = function(self, i, v)
		for i,__ in self:Sort({[i] = v}) do
			for att:'',v in next,__ do
				self['...'][att][i] = v;
			end
		end
	end,
	__add = function(a, b) -- Inserts a librarie's contents into this one

	end
}
Library.new = function(table:{__newindex:{}})
	local self = setmetatable({['...'] = table or {}}, Library);
	return self;
end
return Library;
