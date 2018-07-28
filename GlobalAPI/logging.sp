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

// =========================================================== //