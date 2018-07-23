// =========================================================== //

public bool LoadModule(Handle plugin)
{
	int index = gL_moduleList.FindValue(plugin);
	
	if (index != -1)
	{
		char pluginName[PLATFORM_MAX_PATH];
		GetPluginFilename(plugin, pluginName, sizeof(pluginName));
		
		PrintToServer("[GlobalAPI-Retrying] %s already loaded!", pluginName);
		return false;
	}
	else if (gL_moduleList.Length > 1)
	{
		SetFailState("[GlobalAPI-Retrying] More than 1 module loaded!");
		return false;
	}
	else
	{
		gL_moduleList.Push(plugin);

		char pluginName[PLATFORM_MAX_PATH];
		GetPluginFilename(plugin, pluginName, sizeof(pluginName));
		
		PrintToServer("[GlobalAPI-Retrying] Loaded %s as a module!", pluginName);
		
		return true;
	}
}

public bool UnloadModule(Handle plugin)
{
	int index = gL_moduleList.FindValue(plugin);
	
	if (index != -1)
	{
		gL_moduleList.Erase(index);
		
		char pluginName[PLATFORM_MAX_PATH];
		GetPluginFilename(plugin, pluginName, sizeof(pluginName));
		
		PrintToServer("[GlobalAPI-Retrying] %s unloaded!", pluginName);
		
		if (GlobalAPI_Retrying_GetModulesCount() == 0)
		{
			SetFailState("[GlobalAPI-Retrying] One retrying module is required!");
		}
		
		return true;
	}
	else if (gL_moduleList.Length < 1)
	{
		PrintToServer("[GlobalAPI-Retrying] No plugins to unload!");
		return false;
	}
	else
	{
		char pluginName[PLATFORM_MAX_PATH];
		GetPluginFilename(plugin, pluginName, sizeof(pluginName));
		
		PrintToServer("[GlobalAPI-Retrying] %s is not loaded! Cannot unload.", pluginName);
		return false;
	}
}

public Action DumpModules(int client, int args)
{
	for (int i; i < gL_moduleList.Length; i++)
	{
		Handle plugin = gL_moduleList.Get(i);
		
		char pluginName[PLATFORM_MAX_PATH];
		GetPluginFilename(plugin, pluginName, sizeof(pluginName));
		
		PrintToServer("[%d] => %s", i, pluginName);
		delete plugin;
	}
}

// =========================================================== //