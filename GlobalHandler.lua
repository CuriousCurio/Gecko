local RunService = game:GetService('RunService');

local module = {};
function module:GetNative(settings, plugin)
	if (plugin and plugin:IsA('Plugin')) then return 'Plugin'; end
	if (settings and settings:IsA('GlobalSettings')) then return 'CommandBar'; end
	if (RunService:IsClient()) then return 'Client'; end
	return 'Server';
end;
function module:FilterSettings(settings) -- Checks for the settings global
	if (settings == nil) then return; end
	if (typeof(settings) ~= 'function') then return; end
	local obj:GlobalSettings = settings();
	if (typeof(obj) ~= 'Instance') then return; end
	if (obj:IsA('GlobalSettings') == false) then return; end
	return settings;
end
function module:FilterPlugin(plugin:nil|Plugin|Instance)
	if (plugin == nil) then return; end
	if (typeof(plugin) ~= 'Instance') then return; end
	if (not plugin:IsA('Plugin')) then return; end
	return plugin;
end
return module;
