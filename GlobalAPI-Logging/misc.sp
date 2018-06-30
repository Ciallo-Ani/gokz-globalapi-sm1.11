// =========================================================== //

public void BuildSMPath()
{
	BuildPath(Path_SM, gC_sourceModPath, sizeof(gC_sourceModPath), "");
}

// =========================================================== //

public void BuildLogPaths()
{
	Format(gC_HTTPFailed_LogFile, sizeof(gC_HTTPFailed_LogFile), "%s%s", gC_sourceModPath, HTTPFailed_LogFile);
	Format(gC_HTTPStarted_LogFile, sizeof(gC_HTTPStarted_LogFile), "%s%s", gC_sourceModPath, HTTPStarted_LogFile);
	Format(gC_HTTPFinished_LogFile, sizeof(gC_HTTPFinished_LogFile), "%s%s", gC_sourceModPath, HTTPFinished_LogFile);
}

// =========================================================== //

public void BuildAndCreateLogDirectory()
{
	char logPath[PLATFORM_MAX_PATH];
	Format(logPath, sizeof(logPath), "%s%s", gC_sourceModPath, HTTPLogs_Folder);

	if (!DirExists(logPath)) CreateDirectory(logPath, 666);
}

// =========================================================== //