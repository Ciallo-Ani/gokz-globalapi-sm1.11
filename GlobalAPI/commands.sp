// =========================================================== //

static char validArgs[][] =
{
	"--show-modules",
	"--show-map-info"
};

// =========================================================== //

public void CreateCommands()
{
	RegConsoleCmd("sm_globalapi_info", Command_Info);

	RegAdminCmd("sm_globalapi_reload_apikey", Command_ReloadAPIKey, ADMFLAG_ROOT, "Reloads the API Key");
}

// =========================================================== //

public Action Command_Info(int client, int args)
{
	PrintInfoHeaderToConsole(client);

	for (int i = 1; i <= args; i++)
	{
		char argument[32];
		GetCmdArg(i, argument, sizeof(argument));

		// --show-modules
		if (StrEqual(argument, validArgs[0]))
		{
			PrintLoggingModulesToConsole(client);
			PrintRetryingModulesToConsole(client);
		}

		// --show-map-info
		else if (StrEqual(argument, validArgs[1]))
		{
			PrintMapInfoToConsole(client);
		}

		// All valid ones checked, has to be invalid
		else if (String_StartsWith(argument, "--"))
		{
			PrintToConsole(client, "Invalid command option \"%s\"", argument);
		}

		// Not even a command option?
		else
		{
			PrintToConsole(client, "Invalid argument! \"%s\"", argument);
		}
	}
}

// =========================================================== //

public Action Command_ReloadAPIKey(int client, int args)
{
	gB_usingAPIKey = ReadAPIKey();
	ReplyToCommand(client, "[GlobalAPI] API Key reloaded!");
}

// =========================================================== //