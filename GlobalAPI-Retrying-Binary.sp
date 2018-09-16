// ====================== DEFINITIONS ======================== //

#define PLUGIN_NAME "GlobalAPI-Retrying-Binary"

#define DATA_PATH "data/GlobalAPI-Retrying"
#define DATA_FILE "retrying_{timestamp}_{gametick}.dat"

// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-stocks>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

bool gB_Core = false;

// ======================= INCLUDES ========================== //

// ...

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = PLUGIN_NAME,
	author = "Sikari",
	description = "",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
	// FIX: I think this is a horrible way of versioning
};

// =========================================================== //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary(PLUGIN_NAME);
}

public void OnPluginStart()
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

	if (!CreateDirectoryIfNotExist(path))
	{
		SetFailState("[%s] Failed to create directory [%s]", PLUGIN_NAME, path);
	}
	
	// This is not the final solution!!!!!
	CreateTimer(30.0, CheckForRequests, _, TIMER_REPEAT);
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("GlobalAPI"))
	{
		gB_Core = true;
		GlobalAPI_Retrying_LoadModule();
	}
}

public void OnPluginEnd()
{
	if (gB_Core)
	{
		GlobalAPI_Retrying_UnloadModule();
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

// ======================= MAIN CODE ========================= //

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
	if (hData.requestType == GlobalAPIRequestType_POST)
	{
		SaveRequestAsBinary(hData);
	}
}

public void SaveRequestAsBinary(GlobalAPIRequestData hData)
{
	char szTimestamp[32];
	IntToString(GetTime(), szTimestamp, sizeof(szTimestamp));
	
	char szGameTime[32];
	FloatToString(GetEngineTime(), szGameTime, sizeof(szGameTime));
	
	char dataFile[PLATFORM_MAX_PATH] = DATA_FILE;
	ReplaceString(dataFile, sizeof(dataFile), "{gametick}", szGameTime);
	ReplaceString(dataFile, sizeof(dataFile), "{timestamp}", szTimestamp);

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "%s/%s", DATA_PATH, dataFile);

	File binaryFile = OpenFile(path, "a+");

	if (binaryFile == null)
	{
		LogError("[%s] Could not open or create binary file [%s]", PLUGIN_NAME, path);
		return;
	}

	// Start preparing data
	int bodyLength = hData.bodyLength;
	
	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char plugin[GlobalAPI_Max_PluginName_Length];
	hData.GetString("pluginName", plugin, sizeof(plugin));

	char[] params = new char[bodyLength];
	hData.Encode(params, bodyLength);

	int requestType = hData.requestType;
	bool keyRequired = hData.keyRequired;

	binaryFile.WriteInt16(strlen(url));
	binaryFile.WriteString(url, false);
	binaryFile.WriteInt8(strlen(plugin));
	binaryFile.WriteString(plugin, false);
	binaryFile.WriteInt32(strlen(params));
	binaryFile.WriteString(params, false);
	binaryFile.WriteInt8(keyRequired);
	binaryFile.WriteInt8(requestType);
	binaryFile.WriteInt32(bodyLength);
	binaryFile.WriteInt32(StringToInt(szTimestamp));
	binaryFile.Close();
}

public Action CheckForRequests(Handle timer)
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

	DirectoryListing dataFiles = OpenDirectory(path);

	if (dataFiles == null)
	{
		LogError("[%s] Could not open directory [%s]", PLUGIN_NAME, path);
		delete dataFiles;
		return;
	}

	char dataFile[PLATFORM_MAX_PATH];
	while (dataFiles.GetNext(dataFile, sizeof(dataFile)))
	{
		if (!StrEqual(dataFile, ".") && !StrEqual(dataFile, ".."))
		{
			Format(dataFile, sizeof(dataFile), "%s/%s", path, dataFile);
			break;
		}
	}

	if (FileExists(dataFile))
	{
		File binaryFile = OpenFile(dataFile, "r");

		if (binaryFile == null)
		{
			LogError("[%s] Could not open binary file [%s]", PLUGIN_NAME, path);
			return;
		}

		int length;

		binaryFile.ReadInt16(length);
		char[] url = new char[length + 1];
		binaryFile.ReadString(url, length, length);
		url[length] = '\0';

		binaryFile.ReadInt8(length);
		char[] plugin = new char[length + 1];
		binaryFile.ReadString(plugin, length, length);
		plugin[length] = '\0';

		binaryFile.ReadInt32(length);
		char[] params = new char[length + 1];
		binaryFile.ReadString(params, length, length);
		params[length] = '\0';
		
		bool keyRequired;
		binaryFile.ReadInt8(keyRequired);
		
		int requestType;
		binaryFile.ReadInt8(requestType);
		
		int bodyLength;
		binaryFile.ReadInt32(bodyLength);

		int timestamp;
		binaryFile.ReadInt32(timestamp);
		binaryFile.Close();

		RetryRequest(url, plugin, params, keyRequired, requestType, bodyLength);
		DeleteFile(dataFile);
	}
	
	delete dataFiles;
}

public void RetryRequest(char[] url, char[] plugin, char[] params, bool keyRequired, int requestType, int bodyLength)
{
	// Pack everything into GlobalAPI plugin friendly format
	GlobalAPIRequestData hData = new GlobalAPIRequestData(plugin);

	hData.AddUrl(url);
	hData.Decode(params);

	// These are set to null until
	// We have a reliable way of retrieving
	// The handles from the original plugin
	hData.data = INVALID_HANDLE;
	hData.callback = INVALID_HANDLE;

	hData.isRetried = true;
	hData.bodyLength = bodyLength;
	hData.keyRequired = keyRequired;
	hData.requestType = requestType;

	GlobalAPI_SendRequest(hData);
}

// =========================================================== //