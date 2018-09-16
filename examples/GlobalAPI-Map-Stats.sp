// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI-stocks>
#include <GlobalAPI/responses>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo = 
{
    name = "GlobalAPI-Map-Stats",
    author = "Sikari",
    description = "",
    version = "1.0.0",
    url = ""
};

// ======================= MAIN CODE ========================= //

public void OnPluginStart()
{
	RegConsoleCmd("sm_globalapi_mapstats", Command_GetStatsForMap);
}

public Action Command_GetStatsForMap(int client, int args)
{
	char temp[12];
	char mapName[128];
	GetCmdArg(1, mapName, sizeof(mapName));

	GetCmdArg(2, temp, sizeof(temp));
	int stage = StringToInt(temp);
	
	GetCmdArg(3, temp, sizeof(temp));
	int topNum = StringToInt(temp);

	if (topNum < 1) topNum = 1;
	if (topNum > 100) topNum = 100;
	
	// Mode
	GetCmdArg(4, temp, sizeof(temp));
	
	if (!StrEqual(temp, "kz_timer", false) || StrEqual(temp, "kz_simple", false) || StrEqual(temp, "kz_vanilla"))
	{
		if (StrEqual(temp, "kztimer", false))
		{
			temp = "kz_timer";
		}
		else if (StrEqual(temp, "vanilla", false))
		{
			temp = "kz_vanilla";
		}
		else if (StrEqual(temp, "simplekz", false))
		{
			temp = "kz_simple";
		}
		else
		{
			temp = "kz_timer";
		}
	}
	
	int userid = client > 0 ? GetClientUserId(client) : 0;
	
	// Combined
	GlobalAPI_GetRecordsTop(OnRecordsGet,
							.data = userid,
							.stage = stage,
							.tickRate = 128,
							.modes = temp,
							.mapName = mapName,
							.limit = topNum);
	
	// TP
	GlobalAPI_GetRecordsTop(OnRecordsGet,
							.data = userid,
							.hasTeleports = true,
							.stage = stage,
							.tickRate = 128,
							.modes = temp,
							.mapName = mapName,
							.limit = topNum);
	
	// Pro
	GlobalAPI_GetRecordsTop(OnRecordsGet, 
							.data = userid,
							.hasTeleports = false,
							.stage = stage,
							.tickRate = 128,
							.modes = temp,
							.mapName = mapName,
							.limit = topNum);
}

public void OnRecordsGet(JSON_Object hResponse, GlobalAPIRequestData hData, int userid)
{
	if (hData.failure == false)
	{
		if (hResponse != null)
		{
			APIIterable iterable = new APIIterable(hResponse);

			if (iterable != null)
			{
				FormatRecords(userid, iterable, hData);
				delete iterable;
			}
		}
	}
	else
	{
		LogMessage("Failure during HTTP Request!");
	}
	
	GlobalAPI_DebugMessage("<Get Records Top> executed in %d ms - status: %d", hData.responseTime, hData.status);
}

static void FormatRecords(int userid, APIIterable records, GlobalAPIRequestData hData)
{
	float bestTime = 0.0;
	float worstTime = 0.0;
	float totalTime = 0.0;
	int totalRecords = records.Count;
	
	for (int i = 0; i < totalRecords; i++)
	{
		APIRecord record = new APIRecord(records.GetById(i));
		
		if (i == 0)
		{
			bestTime = record.time;
		}
		else if (i == totalRecords -1)
		{
			worstTime = record.time;
		}

		totalTime += record.time;
		delete record;
	}

	int limit = hData.GetInt("limit");
	int stage = hData.GetInt("stage");
	int client = GetClientOfUserId(userid);

	char mapName[128];
	hData.GetString("map_name", mapName, sizeof(mapName));

	char mode[12];
	hData.GetString("modes_list_string", mode, sizeof(mode));

	char timeType[12];
	timeType = hData.GetKeyHidden("has_teleports") ? "Combined" : hData.GetBool("has_teleports") ? "TP" : "PRO";

	PrintToConsole(client, "[%s %s] Stats for Top %d - %s (Stage %d):", mode, timeType, limit, mapName, stage);
	PrintToConsole(client, "#1 time: %s", FormatRecordTime(bestTime));
	PrintToConsole(client, "#%d time: %s", limit, FormatRecordTime(worstTime));
	PrintToConsole(client, "Avg time: %s", FormatRecordTime((totalTime / totalRecords)));
}