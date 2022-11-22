-- Custom typeof
local typeof = function(a)
	local meta = getmetatable(a);
	if type(meta) ~= "table" or meta.__type == nil then return typeof(a); end
	if type(meta.__type) ~= 'function' then return meta.__type; end
	return meta.__type(a);
end
