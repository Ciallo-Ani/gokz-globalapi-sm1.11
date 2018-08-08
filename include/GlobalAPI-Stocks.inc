// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Function_Helpers_included_
#endinput
#endif
#define _GlobalAPI_Function_Helpers_included_

// =========================================================== //

#include <GlobalAPI>

// =========================================================== //

stock bool CreateDirectoryIfNotExist(char[] dir)
{
	if (!DirExists(dir))
	{
		return CreateDirectory(dir, 666);
	}
	
	return DirExists(dir);
}

stock char GetPluginDisplayName(Handle plugin)
{
	char pluginName[GlobalAPI_Max_PluginName_Length] = "Unknown";
	GetPluginInfo(plugin, PlInfo_Name, pluginName, sizeof(pluginName));
	
	return pluginName;
}

stock char GetMapDisplay(char[] buffer, int maxlength)
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));
	GetMapDisplayName(map, map, sizeof(map));
	
	FormatEx(buffer, maxlength, map);
}

stock char GetMapFullPath(char[] buffer, int maxlength)
{
	char mapPath[PLATFORM_MAX_PATH];
	GetCurrentMap(mapPath, sizeof(mapPath));
	
	PrintToServer(mapPath);
	
	Format(buffer, maxlength, "maps/%s.bsp", mapPath);
	PrintToServer(buffer);
}

stock char FormatISO8601Date(char[] datetime, bool useSlashes = true)
{
	char date[2][30];
	ExplodeString(datetime, "T", date, sizeof(date), sizeof(date[]));
	
	if (useSlashes)
		ReplaceString(date[0], sizeof(date[]), "-", "/");
	
	return date[0];
}

// =========================================================== //

