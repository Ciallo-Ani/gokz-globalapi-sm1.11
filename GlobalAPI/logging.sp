// =========================================================== //

public bool Logging_LoadModule(Handle plugin)
{
	if (g_loggingModules.FindValue(plugin) == -1)
	{
		g_loggingModules.Push(plugin);
		return true;
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-Logging] Module is already loaded");
		return false;
	}
}

public bool Logging_UnloadModule(Handle plugin)
{
	int moduleIndex = g_loggingModules.FindValue(plugin);
	
	if (moduleIndex != -1)
	{
		g_loggingModules.Erase(moduleIndex);
		return true;
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-Logging] Module is not loaded!");
		return false;
	}
}

public int Logging_GetModuleCount()
{
	return g_loggingModules.Length;
}

public ArrayList Logging_GetModuleList()
{
	return g_loggingModules.Clone();
}

public Action Logging_DumpModules(int client, int args)
{
	bool usingLogging = g_loggingModules.Length >= 1;
	PrintToServer("[GlobalAPI-Logging] Currently GlobalAPI does %s use Logging!", usingLogging ? "" : "not");
	
	if (usingLogging)
	{
		PrintToServer("[GlobalAPI-Logging] Current Logging modules used:");
		for (int i; i < g_loggingModules.Length; i++)
		{
			Handle module = g_loggingModules.Get(i);
			
			char pluginName[PLATFORM_MAX_PATH];
			GetPluginFilename(module, pluginName, sizeof(pluginName));
			
			PrintToServer("[%d] -- %s", i, pluginName);
			delete module;
		}
	}
}

// =========================================================== //