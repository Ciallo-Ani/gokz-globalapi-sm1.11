// =========================================================== //

public bool Retrying_LoadModule(Handle plugin)
{
	if (g_retryingModules.FindValue(plugin) == -1)
	{
		if (g_retryingModules.Length < 1)
		{
			g_retryingModules.Push(plugin);
			return true;
		}
		else
		{
			ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-Retrying] More than 1 module loaded!");
			return false;
		}
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-Retrying] Module is already loaded");
		return false;
	}
}

public bool Retrying_UnloadModule(Handle plugin)
{
	int moduleIndex = g_retryingModules.FindValue(plugin);
	
	if (moduleIndex != -1)
	{
		g_retryingModules.Erase(moduleIndex);
		return true;
	}
	else
	{
		ThrowNativeError(SP_ERROR_NATIVE, "[GlobalAPI-Logging] Module is not loaded!");
		return false;
	}
}

public int Retrying_GetModuleCount()
{
	return g_retryingModules.Length;
}

public ArrayList Retrying_GetModuleList()
{
	return g_retryingModules.Clone();
}

// =========================================================== //