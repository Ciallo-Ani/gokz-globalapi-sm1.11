// =========================================================== //

public void CreateCommands()
{
	// Normal cmds
	RegConsoleCmd("sm_globalapi_logging_modules", Command_Logging_Modules);

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

			char pluginName[PLATFORM_MAX_PATH];
			strcopy(pluginName, sizeof(pluginName), GetPluginDisplayName(module));

			PrintToServer(" -- %s", pluginName);
			delete module;
		}
	}
}

// =========================================================== //
