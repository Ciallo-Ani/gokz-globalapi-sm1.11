// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Function_Helpers_included_
#endinput
#endif
#define _GlobalAPI_Function_Helpers_included_

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
	char pluginName[GlobalAPI_Max_PluginName_Length];
	GetPluginInfo(plugin, PlInfo_Name, pluginName, sizeof(pluginName));
	
	return pluginName;
}

// =========================================================== //