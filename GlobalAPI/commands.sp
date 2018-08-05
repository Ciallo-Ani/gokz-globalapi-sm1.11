// =========================================================== //

public void CreateCommands()
{
	// Normal cmds
	RegConsoleCmd("sm_globalapi_logging_modules", Command_Logging_Modules);
	RegConsoleCmd("sm_globalapi_retrying_modules", Command_Retrying_Modules);

	// Admin Cmds
	RegAdminCmd("sm_globalapi_reload_apikey", Command_ReloadAPIKey, ADMFLAG_ROOT, "Reloads the API Key");
}

// =========================================================== //

public Action Command_ReloadAPIKey(int client, int args)
{
	gB_usingAPIKey = ReadAPIKey();
	ReplyToCommand(client, "[GlobalAPI] API Key reloaded!");
}

// =========================================================== //

public Action Command_Logging_Modules(int client, int args)
{
	bool usingLogging = g_loggingModules.Length >= 1;

	if (!usingLogging)
	{
		PrintToServer("[GlobalAPI] Currently there are no logging modules in use!");
	}
	else
	{
		PrintToServer("[GlobalAPI-Logging] GlobalAPI has these logging modules loaded:");

		for (int i; i < g_loggingModules.Length; i++)
		{
			Handle module = g_loggingModules.Get(i);

			char pluginName[GlobalAPI_Max_PluginName_Length];
			strcopy(pluginName, sizeof(pluginName), GetPluginDisplayName(module));

			PrintToServer(" -- %s", pluginName);
			delete module;
		}
	}
}

// =========================================================== //

public Action Command_Retrying_Modules(int client, int args)
{
	bool usingRetrying = g_retryingModules.Length >= 1;

	if (!usingRetrying)
	{
		PrintToServer("[GlobalAPI] Currently there are no retrying modules in use!");
	}
	else
	{
		PrintToServer("[GlobalAPI-Retrying] GlobalAPI has these retrying modules loaded:");

		for (int i; i < g_retryingModules.Length; i++)
		{
			Handle module = g_retryingModules.Get(i);

			char pluginName[GlobalAPI_Max_PluginName_Length];
			strcopy(pluginName, sizeof(pluginName), GetPluginDisplayName(module));

			PrintToServer(" -- %s", pluginName);
			delete module;
		}
	}
}

// =========================================================== //
