// ====================== DEFINITIONS ======================== //

#define DATA_FILE "retrying{fileNumber}.dat"
#define DATA_PATH "data/GlobalAPI-Retrying"

// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-Retrying>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== VARIABLES ========================== //

int gI_retryRequests = 1;
bool gB_Retrying = false;

// ======================= INCLUDES ========================== //

// ...

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
	name = "GlobalAPI-Retrying-Binary",
	author = "Sikari",
	description = "",
	version = GlobalAPI_Plugin_Version,
	url = GlobalAPI_Plugin_Url
};

// =========================================================== //

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("GlobalAPI-Retrying-Binary");
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("GlobalAPI-Retrying"))
	{
		gB_Retrying = true;
		GlobalAPI_Retrying_LoadModule();
	}
}

public void OnPluginEnd()
{
	if (gB_Retrying)
	{
		GlobalAPI_Retrying_UnloadModule();
	}
}

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "GlobalAPI-Retrying"))
	{
		gB_Retrying = true;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "GlobalAPI-Retrying"))
	{
		gB_Retrying = false;
	}
}

// ======================= MAIN CODE ========================= //

public void GlobalAPI_Retrying_OnSaveRequest(GlobalAPIRequestData hData)
{
	char fileNumber[32];
	IntToString(gI_retryRequests, fileNumber, sizeof(fileNumber));

	char dataFile[PLATFORM_MAX_PATH] = DATA_FILE;
	ReplaceString(dataFile, sizeof(dataFile), "{fileNumber}", fileNumber);

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "%s/%s", DATA_PATH, dataFile);

	while (FileExists(path))
	{
		gI_retryRequests++;

		PrintToServer(path);
		IntToString(gI_retryRequests, fileNumber, sizeof(fileNumber));

		FormatEx(dataFile, sizeof(dataFile), path);
		ReplaceString(dataFile, sizeof(dataFile), "{fileNumber}", fileNumber);
		BuildPath(Path_SM, path, sizeof(path), "%s/%s", DATA_PATH, dataFile);
	}

	gI_retryRequests++;

	File binaryFile = OpenFile(path, "a+");

	if (binaryFile == null)
	{
		LogError("Could not open or create binary file for retrying... [%s]", path);
		return;
	}

	// Start preparing data
	char url[GlobalAPI_Max_BaseUrl_Length];
	hData.GetString("url", url, sizeof(url));

	char params[GlobalAPI_Max_QueryParams_Length];
	hData.ToString(params, sizeof(params));

	any data = hData.data;
	Handle callback = hData.callback;
	int timestamp = GetTime();

	binaryFile.WriteInt8(strlen(url));
	binaryFile.WriteString(url, false);
	binaryFile.WriteInt8(strlen(params));
	binaryFile.WriteString(params, false);
	binaryFile.WriteInt32(data);
	binaryFile.WriteInt32(view_as<int>(callback));
	binaryFile.WriteInt32(timestamp);

	PrintToServer("Writing %s %s %d %d %d", url, params, data, callback, timestamp);

	binaryFile.Close();
}

public void GlobalAPI_Retrying_OnCheckRequests()
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

	DirectoryListing dataFiles = OpenDirectory(path);

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
			LogError("Could not open binary file for retrying... [%s]", path);
			return;
		}

		int length;

		binaryFile.ReadInt8(length);
		char[] url = new char[length + 1];
		binaryFile.ReadString(url, length, length);
		url[length] = '\0';

		binaryFile.ReadInt8(length);
		char[] params = new char[length + 1];
		binaryFile.ReadString(params, length, length);
		params[length] = '\0';

		any data;
		binaryFile.ReadInt32(data);

		Handle callback;
		binaryFile.ReadInt32(view_as<int>(callback));

		int timestamp;
		binaryFile.ReadInt32(timestamp);
		binaryFile.Close();

		PrintToServer("Reading %s %s %d %d %d", url, params, data, callback, timestamp);

		DeleteFile(dataFile);
		gI_retryRequests--;
	}
}

// =========================================================== //