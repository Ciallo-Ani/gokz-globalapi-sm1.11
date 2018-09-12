// =========================================================== //

char moduleTypes[][] =
{
	"Stats",
	"Logging",
	"Retrying"
};

// ======================= NATIVES =========================== //

bool LoadModule(Handle plugin, ModuleType type, int limit = -1)
{
	ArrayList modules = GetModuleHandle(type);
	
	// Guard for module limit
	if (limit > 0 && modules.Length >= limit)
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-%s] Maximum module limit reached! (Limit %d)", moduleTypes[type], limit);
		return false;
	}

	if (modules.FindValue(plugin) == -1)
	{
		modules.Push(plugin);
		return true;
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-%s] Module is already loaded", moduleTypes[type]);
		return false;
	}
}

bool UnloadModule(Handle plugin, ModuleType type)
{
	ArrayList modules = GetModuleHandle(type);
	int moduleIndex = modules.FindValue(plugin);
	
	if (moduleIndex != -1)
	{
		modules.Erase(moduleIndex);
		return true;
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-%s] Module is not loaded!", moduleTypes[type]);
		return false;
	}
}

int GetModuleCount(ModuleType type)
{
	ArrayList modules = GetModuleHandle(type);
	return modules.Length;
}

ArrayList GetModuleList(ModuleType type)
{
	ArrayList modules = GetModuleHandle(type);
	return modules.Clone();
}

void PrintModulesToConsole(int client, ModuleType type)
{
	ArrayList modules = GetModuleHandle(type);
	
	if (modules.Length <= 0)
	{
		PrintToConsole(client, "-- %s Module: \t None", moduleTypes[type]);
		return;
	}

	for (int i = 0; i < modules.Length; i++)
	{
		Handle module = modules.Get(i);

		char pluginName[GlobalAPI_Max_PluginName_Length];
		strcopy(pluginName, sizeof(pluginName), GetPluginDisplayName(module));

		PrintToConsole(client, "-- %s Module: \t %s", moduleTypes[type], pluginName);
		delete module;
	}
}

// =========================================================== //

static ArrayList GetModuleHandle(ModuleType type)
{
	switch (type)
	{
		case ModuleType_Stats: return g_statsModules;
		case ModuleType_Logging: return g_loggingModules;
		case ModuleType_Retrying: return g_retryingModules;
	}

	return null;
}

// =========================================================== //