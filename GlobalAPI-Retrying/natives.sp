public void CreateNatives()
{
	CreateNative("GlobalAPI_Retrying_LoadModule", Native_LoadModule);
	CreateNative("GlobalAPI_Retrying_UnloadModule", Native_UnloadModule);
	CreateNative("GlobalAPI_Retrying_GetModulesCount", Native_GetModulesCount);
}

// =========================================================== //

public int Native_LoadModule(Handle plugin, int numParams)
{
	return LoadModule(plugin);
}

public int Native_UnloadModule(Handle plugin, int numParams)
{
	return UnloadModule(plugin);
}

public int Native_GetModulesCount(Handle plugin, int numParams)
{
	return gL_moduleList.Length;
}

// =========================================================== //