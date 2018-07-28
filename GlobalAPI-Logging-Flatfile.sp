// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-Stocks>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_Core = false;

// Paths
char gC_sourceModPath[PLATFORM_MAX_PATH];
char gC_HTTPLog_Directory[PLATFORM_MAX_PATH] = "logs/GlobalAPI";
char gC_HTTPFailed_LogFile[PLATFORM_MAX_PATH] = "failed-log.txt";
char gC_HTTPStarted_LogFile[PLATFORM_MAX_PATH] = "start-log.txt";
char gC_HTTPFinished_LogFile[PLATFORM_MAX_PATH] = "finished-log.txt";

// Phrases
char gC_HTTPMethodPhrases[][] = { "GET", "POST" };

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Logging-Flatfile",
	author = "Sikari",
	description = "Flatfile logging for GlobalAPI",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// ======================= MAIN CODE ========================= //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Logging-Flatfile");
}

public void OnPluginStart()
{
	BuildPath(Path_SM, gC_sourceModPath, sizeof(gC_sourceModPath), "");

	Format(gC_HTTPLog_Directory, sizeof(gC_HTTPLog_Directory), "%s%s", gC_sourceModPath, gC_HTTPLog_Directory);
	CreateDirectoryIfNotExist(gC_HTTPLog_Directory);
	
	Format(gC_HTTPFailed_LogFile, sizeof(gC_HTTPFailed_LogFile), "%s/%s", gC_HTTPLog_Directory, gC_HTTPFailed_LogFile);
	Format(gC_HTTPStarted_LogFile, sizeof(gC_HTTPStarted_LogFile), "%s/%s", gC_HTTPLog_Directory, gC_HTTPStarted_LogFile);
	Format(gC_HTTPFinished_LogFile, sizeof(gC_HTTPFinished_LogFile), "%s/%s", gC_HTTPLog_Directory, gC_HTTPFinished_LogFile);
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("GlobalAPI"))
	{
		gB_Core = true;
		GlobalAPI_Logging_LoadModule();
	}
}

public void OnPluginEnd()
{
	if (gB_Core)
	{
		GlobalAPI_Logging_UnloadModule();
	}
}

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "GlobalAPI"))
	{
		gB_Core = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "GlobalAPI"))
	{
		gB_Core = false;
	}
}

// =========================================================== //

public void GlobalAPI_Logging_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	char params[GlobalAPI_Max_QueryParams_Length] = "-";
	hData.ToString(params, sizeof(params));

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char pluginName[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));

	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);

	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPFailed_LogFile, "a+");

	hLogFile.WriteLine("%s (%s) API call failed!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => Status: %d", logTag, hData.status);
	hLogFile.WriteLine("%s    => URL: %s", logTag, url);
	hLogFile.WriteLine("%s     => Params: %s", logTag, params);
	hLogFile.Close();
}

// =========================================================== //

public void GlobalAPI_Logging_OnRequestStarted(Handle request, GlobalAPIRequestData hData)
{
	char params[GlobalAPI_Max_QueryParams_Length] = "-";
	hData.ToString(params, sizeof(params));

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char pluginName[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));

	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);

	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPStarted_LogFile, "a+");

	hLogFile.WriteLine("%s (%s) API call started!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => URL: %s", logTag, url);
	hLogFile.WriteLine("%s    => Params: %s", logTag, params);
	hLogFile.Close();
}

// =========================================================== //

public void GlobalAPI_Logging_OnRequestFinished(Handle request, GlobalAPIRequestData hData)
{
	char params[GlobalAPI_Max_QueryParams_Length] = "-";
	hData.ToString(params, sizeof(params));

	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char pluginName[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", pluginName, sizeof(pluginName));

	char method[5];
	FormatEx(method, sizeof(method), gC_HTTPMethodPhrases[hData.requestType]);

	char logTag[128];
	FormatTime(logTag, sizeof(logTag), "[GlobalAPI-Logging] %m/%d/%Y - %H:%M:%S");

	File hLogFile = OpenFile(gC_HTTPFinished_LogFile, "a+");

	hLogFile.WriteLine("%s (%s) API call finished!", logTag, pluginName);
	hLogFile.WriteLine("%s  => Method: %s", logTag, method);
	hLogFile.WriteLine("%s   => Status: %d", logTag, hData.status);
	hLogFile.WriteLine("%s    => Failure: %s", logTag, hData.failure ? "YES" : "NO");
	hLogFile.WriteLine("%s     => URL: %s", logTag, url);
	hLogFile.WriteLine("%s      => Params: %s", logTag, params);
	hLogFile.Close();
}

// =========================================================== //