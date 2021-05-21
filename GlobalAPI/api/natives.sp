void CreateNatives()
{
	// Plugin
	CreateNative("GlobalAPI_IsInit", Native_IsInit);
	CreateNative("GlobalAPI_GetAPIKey", Native_GetAPIKey);
	CreateNative("GlobalAPI_HasAPIKey", Native_HasAPIKey);
	CreateNative("GlobalAPI_IsStaging", Native_IsStaging);
	CreateNative("GlobalAPI_IsDebugging", Native_IsDebugging);
	CreateNative("GlobalAPI_SendRequest", Native_SendRequest);
	CreateNative("GlobalAPI_DebugMessage", Native_DebugMessage);

	// Auth
	CreateNative("GlobalAPI_GetAuthStatus", Native_GetAuthStatus);

	// Bans
	CreateNative("GlobalAPI_GetBans", Native_GetBans);
	CreateNative("GlobalAPI_CreateBan", Native_CreateBan);

	// Jumpstats
	CreateNative("GlobalAPI_GetJumpstats", Native_GetJumpstats);
	CreateNative("GlobalAPI_CreateJumpstat", Native_CreateJumpstat);
	CreateNative("GlobalAPI_GetJumpstatTop", Native_GetJumpstatTop);
	CreateNative("GlobalAPI_GetJumpstatTop30", Native_GetJumpstatTop30);

	// Maps
	CreateNative("GlobalAPI_GetMaps", Native_GetMaps);
	CreateNative("GlobalAPI_GetMapById", Native_GetMapById);
	CreateNative("GlobalAPI_GetMapByName", Native_GetMapByName);

	// Modes
	CreateNative("GlobalAPI_GetModes", Native_GetModes);
	CreateNative("GlobalAPI_GetModeById", Native_GetModeById);
	CreateNative("GlobalAPI_GetModeByName", Native_GetModeByName);

	// Players
	CreateNative("GlobalAPI_GetPlayers", Native_GetPlayers);
	CreateNative("GlobalAPI_GetPlayerBySteamId", Native_GetPlayerBySteamId);
	CreateNative("GlobalAPI_GetPlayerBySteamIdAndIp", Native_GetPlayerBySteamIdAndIp);

	// Records
	CreateNative("GlobalAPI_CreateRecord", Native_CreateRecord);
	CreateNative("GlobalAPI_GetRecordPlaceById", Native_GetRecordPlaceById);
	CreateNative("GlobalAPI_GetRecordsTop", Native_GetRecordsTop);
	CreateNative("GlobalAPI_GetRecordsTopRecent", Native_GetRecordsTopRecent);
	CreateNative("GlobalAPI_GetRecordsTopWorldRecords", Native_GetRecordsTopWorldRecords);

	// Servers
	CreateNative("GlobalAPI_GetServers", Native_GetServers);
	CreateNative("GlobalAPI_GetServerById", Native_GetServerById);
	CreateNative("GlobalAPI_GetServersByName", Native_GetServersByName);
	
	// Ranks
	CreateNative("GlobalAPI_GetPlayerRanks", Native_GetPlayerRanks);
	
	// Record Filters
	CreateNative("GlobalAPI_GetRecordFilters", Native_GetRecordFilters);
	CreateNative("GlobalAPI_GetRecordFilterDistributions", Native_GetRecordFilterDistributions);

	// Replays
	CreateNative("GlobalAPI_GetReplayList", Native_GetReplayList);
	CreateNative("GlobalAPI_GetReplayByRecordId", Native_GetReplayByRecordId);
	CreateNative("GlobalAPI_GetReplayByReplayId", Native_GetReplayByReplayId);
	CreateNative("GlobalAPI_CreateReplayForRecordId", Native_CreateReplayForRecordId);
}

// =========================================================== //

/*
	native bool GlobalAPI_IsInit();
*/
public int Native_IsInit(Handle plugin, int numParams)
{
	return gB_IsInit;
}

// =========================================================== //

/*
	native void GlobalAPI_GetAPIKey(char[] buffer, int maxlength)
*/
public int Native_GetAPIKey(Handle plugin, int numParams)
{
	int maxlength = GetNativeCell(2);
	SetNativeString(1, gC_apiKey, maxlength);
}

// =========================================================== //

/*
	native bool GlobalAPI_HasAPIKey()
*/
public int Native_HasAPIKey(Handle plugin, int numParams)
{
	return gB_usingAPIKey;
}

// =========================================================== //

/*
	native bool GlobalAPI_IsStaging()
*/
public int Native_IsStaging(Handle plugin, int numParams)
{
	return gCV_Staging.BoolValue;
}

// =========================================================== //

/*
	native bool GlobalAPI_IsDebugging()
*/
public int Native_IsDebugging(Handle plugin, int numParams)
{
	return gCV_Debug.BoolValue;
}

// =========================================================== //

/*
	native bool GlobalAPI_SendRequest(GlobalAPIRequestData hData)
*/
public int Native_SendRequest(Handle plugin, int numParams)
{
	GlobalAPIRequestData hData = GetNativeCell(1);

	switch (hData.RequestType)
	{
		case GlobalAPIRequestType_GET: return HTTPGet(hData);
		case GlobalAPIRequestType_POST: return HTTPPost(hData);
	}

	return false;
}

// =========================================================== //

/*
	native bool GlobalAPI_DebugMessage(const char[] message, any ...)
*/
public int Native_DebugMessage(Handle plugin, int numParams)
{
	if (!gCV_Debug.BoolValue)
	{
		return false;
	}

	char message[512];
	FormatNativeString(0, 1, 2, sizeof(message), _, message);

	LogMessage("%s", message);
	return true;
}

// =========================================================== //

/*
	native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
#define GlobalAPI_GetAuthStatus_Endpoint "auth/status"
public int Native_GetAuthStatus(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.KeyRequired = true;
	hData.RequestType = GlobalAPIRequestType_GET;
	
	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetAuthStatus_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] banTypes = DEFAULT_STRING,
									char[] banTypesList = DEFAULT_STRING, bool isExpired = DEFAULT_BOOL, char[] ipAddress = DEFAULT_STRING,
									int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING, char[] notesContain = DEFAULT_STRING,
									char[] statsContain = DEFAULT_STRING, int serverId = DEFAULT_INT, char[] createdSince = DEFAULT_STRING,
									char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetBans_Endpoint "bans"
public int Native_GetBans(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	char banTypes[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, banTypes, sizeof(banTypes));
	
	char banTypesList[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(4, banTypesList, sizeof(banTypesList));

	bool isExpired = GetNativeCell(5);
	
	char ipAddress[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, ipAddress, sizeof(ipAddress));

	char steamId64[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(7, steamId64, sizeof(steamId64));
	
	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(8, steamId, sizeof(steamId));
	
	char notesContain[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(9, notesContain, sizeof(notesContain));
	
	char statsContain[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(10, statsContain, sizeof(statsContain));
	
	int serverId = GetNativeCell(11);
	
	char createdSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(12, createdSince, sizeof(createdSince));
	
	char updatedSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(13, updatedSince, sizeof(updatedSince));
	
	int offset = GetNativeCell(14);
	int limit = GetNativeCell(15);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("ban_types", banTypes);
	hData.AddString("ban_types_list", banTypesList);
	hData.AddBool("is_expired", isExpired);
	hData.AddString("ip", ipAddress);
	hData.AddString("steamid64", steamId64);
	hData.AddString("steam_id", steamId);
	hData.AddString("notes_contains", notesContain);
	hData.AddString("stats_contains", statsContain);
	hData.AddNum("server_id", serverId);
	hData.AddString("created_since", createdSince);
	hData.AddString("updated_since", updatedSince);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetBans_Endpoint);
	
	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/* 
	native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
										char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip)
*/
#define GlobalAPI_CreateBan_Endpoint "bans"
public int Native_CreateBan(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));
	
	char banType[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(4, banType, sizeof(banType));
	
	char stats[GlobalAPI_Max_QueryParam_Length * 8];
	GetNativeString(5, stats, sizeof(stats));
	
	char notes[GlobalAPI_Max_QueryParam_Length * 16];
	GetNativeString(6, notes, sizeof(notes));
	
	char ip[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(7, ip, sizeof(ip));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("steam_id", steamId);
	hData.AddString("ban_type", banType);
	hData.AddString("stats", stats);
	hData.AddString("notes", notes);
	hData.AddString("ip", ip);

	hData.BodyLength = 2048;
	hData.KeyRequired = true;
	hData.RequestType = GlobalAPIRequestType_POST;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_CreateBan_Endpoint);
	
	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = DEFAULT_INT,
										int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING,
										char[] jumpType = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING, 
										char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
										float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL,
										bool isCrouchBind = DEFAULT_BOOL, bool isForwardBind = DEFAULT_BOOL,
										bool isCrouchBoost = DEFAULT_BOOL, int updatedById = DEFAULT_INT,
										char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
										int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetJumpstats_Endpoint "jumpstats"
public int Native_GetJumpstats(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	int id = GetNativeCell(3);
	int serverId = GetNativeCell(4);

	char steamId64[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(5, steamId64, sizeof(steamId64));
	
	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, steamId, sizeof(steamId));
	
	char jumpType[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(7, jumpType, sizeof(jumpType));
	
	// TODO FIXME: 64 is certainly not enough 
	char steamId64List[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(8, steamId64List, sizeof(steamId64List));
	
	char jumpTypeList[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(9, jumpTypeList, sizeof(jumpTypeList));

	float greaterThanDistance = GetNativeCell(10);
	float lowerThanDistance = GetNativeCell(11);

	bool isMsl = GetNativeCell(12);
	bool isCrouchBind = GetNativeCell(13);
	bool isForwardBind = GetNativeCell(14);
	bool isCrouchBoost = GetNativeCell(15);
	
	int updatedById = GetNativeCell(16);
	
	char createdSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(17, createdSince, sizeof(createdSince));
	
	char updatedSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(18, updatedSince, sizeof(updatedSince));
	
	int offset = GetNativeCell(19);
	int limit = GetNativeCell(20);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddNum("id", id);
	hData.AddNum("server_id", serverId);
	hData.AddString("steamid64", steamId64);
	hData.AddString("steam_id", steamId);
	hData.AddString("jumptype", jumpType);
	hData.AddString("steamid64_list", steamId64List);
	hData.AddString("jumptype_list", jumpTypeList);
	hData.AddFloat("greater_than_distance", greaterThanDistance);
	hData.AddFloat("lower_than_distance", lowerThanDistance);
	hData.AddBool("is_msl", isMsl);
	hData.AddBool("is_crouch_bind", isCrouchBind);
	hData.AddBool("is_forward_bind", isForwardBind);
	hData.AddBool("is_crouch_boost", isCrouchBoost);
	hData.AddNum("updated_by_id", updatedById);
	hData.AddString("created_since", createdSince);
	hData.AddString("updated_since", updatedSince);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetJumpstats_Endpoint);
	
	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId,
											int jumpType, float distance, char[] jumpJsonInfo, int tickRate, int mslCount,
											bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount)
*/
#define GlobalAPI_CreateJumpstat_Endpoint "jumpstats"
public int Native_CreateJumpstat(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	int jumpType = GetNativeCell(4);
	float distance = GetNativeCell(5);

	char jumpJsonInfo[GlobalAPI_Max_QueryParam_Length * 1250];
	GetNativeString(6, jumpJsonInfo, sizeof(jumpJsonInfo));

	int tickRate = GetNativeCell(7);
	int mslCount = GetNativeCell(8);
	bool isCrouchBind = GetNativeCell(9);
	bool isForwardBind = GetNativeCell(10);
	bool isCrouchBoost = GetNativeCell(11);
	int strafeCount = GetNativeCell(12);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("steam_id", steamId);
	hData.AddNum("jump_type", jumpType);
	hData.AddFloat("distance", distance);
	hData.AddString("json_jump_info", jumpJsonInfo);
	hData.AddNum("tickrate", tickRate);
	hData.AddNum("msl_count", mslCount);
	hData.AddBool("is_crouch_bind", isCrouchBind);
	hData.AddBool("is_forward_bind", isForwardBind);
	hData.AddBool("is_crouch_boost", isCrouchBoost);
	hData.AddNum("strafe_count", strafeCount);

	hData.BodyLength = 100352;
	hData.KeyRequired = true;
	hData.RequestType = GlobalAPIRequestType_POST;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_CreateJumpstat_Endpoint);
	
	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetJumpstatTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] jumpType,
											int id = DEFAULT_INT, int serverId = DEFAULT_INT, int steamId64 = DEFAULT_INT,
											char[] steamId = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING,
											char[] jumpTypeList = DEFAULT_STRING, float greaterThanDistance = DEFAULT_FLOAT,
											float lessThanDistance = DEFAULT_FLOAT, bool isMsl = DEFAULT_BOOL,
											bool isCrouchBind = DEFAULT_BOOL, bool isForwardBind = DEFAULT_BOOL,
											bool isCrouchBoost = DEFAULT_BOOL, int updatedById = DEFAULT_INT,
											char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
											int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetJumpstatTop_Endpoint "jumpstats/{jump_type}/top"
public int Native_GetJumpstatTop(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char jumpType[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, jumpType, sizeof(jumpType));

	int id = GetNativeCell(4);
	int serverId = GetNativeCell(5);

	char steamId64[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, steamId64, sizeof(steamId64));

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(7, steamId, sizeof(steamId));

	char steamId64List[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(8, steamId64List, sizeof(steamId64List));

	char jumpTypeList[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(9, jumpTypeList, sizeof(jumpTypeList));

	float greaterThanDistance = GetNativeCell(10);
	float lessThanDistance = GetNativeCell(11);
	bool isMsl = GetNativeCell(12);
	bool isCrouchBind = GetNativeCell(13);
	bool isForwardBind = GetNativeCell(14);
	bool isCrouchBoost = GetNativeCell(15);
	int updatedById = GetNativeCell(16);

	char createdSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(17, createdSince, sizeof(createdSince));

	char updatedSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(18, updatedSince, sizeof(updatedSince));

	int offset = GetNativeCell(19);
	int limit = GetNativeCell(20);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddNum("id", id);
	hData.AddNum("server_id", serverId);
	hData.AddString("steamid64", steamId64);
	hData.AddString("steam_id", steamId);
	hData.AddString("steamid64_list", steamId64List);
	hData.AddString("jumptype_list", jumpTypeList);
	hData.AddFloat("greater_than_distance", greaterThanDistance);
	hData.AddFloat("less_than_distance", lessThanDistance);
	hData.AddBool("is_msl", isMsl);
	hData.AddBool("is_crouch_bind", isCrouchBind);
	hData.AddBool("is_forward_bind", isForwardBind);
	hData.AddBool("is_crouch_boost", isCrouchBoost);
	hData.AddNum("updated_by_id", updatedById);
	hData.AddString("created_since", createdSince);
	hData.AddString("updated_since", updatedSince);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetJumpstatTop_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "jump_type", jumpType);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetJumpstatTop30(OnAPICallFinished callback = INVALID_HANDLE, any data = INVALID_HANDLE, char[] jumpType)
*/
#define GlobalAPI_GetJumpstatTop30_Endpoint "jumpstats/{jump_type}/top30"
public int Native_GetJumpstatTop30(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char jumpType[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, jumpType, sizeof(jumpType));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetJumpstatTop30_Endpoint);
	hData.AddEndpoint(requestUrl);

	FormatPathParam(requestUrl, sizeof(requestUrl), "jump_type", jumpType);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetMaps(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] name = DEFAULT_STRING,
									int largerThanFilesize = DEFAULT_INT, int smallerThanFilesize = DEFAULT_INT, bool isValidated = DEFAULT_BOOL,
									int difficulty = DEFAULT_INT, char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetMaps_Endpoint "maps"
public int Native_GetMaps(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char name[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, name, sizeof(name));

	int largerThanFilesize = GetNativeCell(4);
	int smallerThanFilesize = GetNativeCell(5);
	bool isValidated = GetNativeCell(6);
	int difficulty = GetNativeCell(7);

	char createdSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(8, createdSince, sizeof(createdSince));

	char updatedSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(9, updatedSince, sizeof(updatedSince));

	int offset = GetNativeCell(10);
	int limit = GetNativeCell(11);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("name", name);
	hData.AddNum("larger_than_filesize", largerThanFilesize);
	hData.AddNum("smaller_than_filesize", smallerThanFilesize);
	hData.AddBool("is_validated", isValidated);
	hData.AddNum("difficulty", difficulty);
	hData.AddString("created_since", createdSince);
	hData.AddString("updated_since", updatedSince);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetMaps_Endpoint);
	
	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetMapById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id)
*/
#define GlobalAPI_GetMapById_Endpoint "maps/{id}"
public int Native_GetMapById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetMapById_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "id", .intValue = id);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetMapByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, const char[] name)
*/
#define GlobalAPI_GetMapByName_Endpoint "maps/name/{map_name}"
public int Native_GetMapByName(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char name[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, name, sizeof(name));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetMapByName_Endpoint);
	hData.AddEndpoint(requestUrl);

	FormatPathParam(requestUrl, sizeof(requestUrl), "map_name", name);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetModes(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE)
*/
#define GlobalAPI_GetModes_Endpoint "modes"
public int Native_GetModes(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetModes_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetModeById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id)
*/
#define GlobalAPI_GetModeById_Endpoint "modes/id/{id}"
public int Native_GetModeById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetModeById_Endpoint);
	hData.AddEndpoint(requestUrl);

	FormatPathParam(requestUrl, sizeof(requestUrl), "id", .intValue = id);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetModeByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] name)
*/
#define GlobalAPI_GetModeByName_Endpoint "modes/name/{mode_name}"
public int Native_GetModeByName(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char name[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, name, sizeof(name));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetModeByName_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "mode_name", name);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING,
										bool isBanned = DEFAULT_BOOL, int totalRecords = DEFAULT_INT,
										char[] ip = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING)
*/
#define GlobalAPI_GetPlayers_Endpoint "players"
public int Native_GetPlayers(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	bool isBanned = GetNativeCell(4);
	int totalRecords = GetNativeCell(5);

	char ip[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, ip, sizeof(ip));

	// TODO FIXME: 64 is certainly not enough
	char steamId64List[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(7, steamId64List, sizeof(steamId64List));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("steam_id", steamId);
	hData.AddBool("is_banned", isBanned);
	hData.AddNum("total_records", totalRecords);
	hData.AddString("ip", ip);
	hData.AddString("steamid64_list", steamId64List);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetPlayers_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayerBySteamId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING)
*/
#define GlobalAPI_GetPlayerBySteamId_Endpoint "players/steamid/{steamid}"
public int Native_GetPlayerBySteamId(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetPlayerBySteamId_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "steamid", steamId);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayerBySteamIdAndIp(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId, char[] ip)
*/
#define GlobalAPI_GetPlayerBySteamIdAndIp_Endpoint "players/steamid/{steamid}/ip/{ip}"
public int Native_GetPlayerBySteamIdAndIp(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	char ip[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(4, ip, sizeof(ip));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.KeyRequired = true;
	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetPlayerBySteamIdAndIp_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "steamid", steamId);
	FormatPathParam(requestUrl, sizeof(requestUrl), "ip", ip);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_CreateRecord(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId, int mapId,
										char[] mode, int stage, int tickRate, int teleports, float time)
*/
#define GlobalAPI_CreateRecord_Endpoint "records"
public int Native_CreateRecord(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	int mapId = GetNativeCell(4);

	char mode[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(5, mode, sizeof(mode));

	int stage = GetNativeCell(6);
	int tickRate = GetNativeCell(7);
	int teleports = GetNativeCell(8);
	float time = GetNativeCell(9);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("steam_id", steamId);
	hData.AddNum("map_id", mapId);
	hData.AddString("mode", mode);
	hData.AddNum("stage", stage);
	hData.AddNum("tickrate", tickRate);
	hData.AddNum("teleports", teleports);
	hData.AddFloat("time", time);

	hData.BodyLength = 1024;
	hData.KeyRequired = true;
	hData.RequestType = GlobalAPIRequestType_POST;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_CreateRecord_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordPlaceById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id)
*/
#define GlobalAPI_GetRecordPlaceById_Endpoint "records/place/{id}"
public int Native_GetRecordPlaceById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetRecordPlaceById_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "id", .intValue = id);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordsTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
											char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT,
											char[] mapName = DEFAULT_STRING, int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
											char[] modes = DEFAULT_STRING, bool hasTeleports = DEFAULT_BOOL, char[] playerName = DEFAULT_STRING,
											int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetRecordsTop_Endpoint "records/top"
public int Native_GetRecordsTop(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	char steamId64[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(4, steamId64, sizeof(steamId64));

	int mapId = GetNativeCell(5);

	char mapName[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, mapName, sizeof(mapName));

	int tickRate = GetNativeCell(7);
	int stage = GetNativeCell(8);

	char modes[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(9, modes, sizeof(modes));

	bool hasTeleports = GetNativeCell(10);

	char playerName[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(11, playerName, sizeof(playerName));

	int offset = GetNativeCell(12);
	int limit = GetNativeCell(13);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("steam_id", steamId);
	hData.AddString("steamid64", steamId64);
	hData.AddNum("map_id", mapId);
	hData.AddString("map_name", mapName);
	hData.AddNum("tickrate", tickRate);
	hData.AddNum("stage", stage);
	hData.AddString("modes_list_string", modes);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddString("player_name", playerName);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetRecordsTop_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordsTopRecent(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING,
												int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT, char[] mapName = DEFAULT_STRING,
												int tickRate = DEFAULT_INT, int stage = DEFAULT_INT, char[] modes = DEFAULT_STRING,
												int placeTopAtLeast = DEFAULT_INT, int placeTopOverallAtLeast = DEFAULT_INT,
												bool hasTeleports = DEFAULT_BOOL, char[] createdSince = DEFAULT_STRING,
												char[] playerName = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetRecordsTopRecent_Endpoint "records/top/recent"
public int Native_GetRecordsTopRecent(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, steamId, sizeof(steamId));

	char steamId64[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(4, steamId64, sizeof(steamId64));

	int mapId = GetNativeCell(5);

	char mapName[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, mapName, sizeof(mapName));

	int tickRate = GetNativeCell(7);
	int stage = GetNativeCell(8);

	char modes[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(9, modes, sizeof(modes));

	int placeTopAtLeast = GetNativeCell(10);
	int placeTopOverallAtLeast = GetNativeCell(11);
	bool hasTeleports = GetNativeCell(12);

	char createdSince[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(13, createdSince, sizeof(createdSince));

	char playerName[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(14, playerName, sizeof(playerName));

	int offset = GetNativeCell(15);
	int limit = GetNativeCell(16);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddString("steam_id", steamId);
	hData.AddString("steamid64", steamId64);
	hData.AddNum("map_id", mapId);
	hData.AddString("map_name", mapName);
	hData.AddNum("tickrate", tickRate);
	hData.AddNum("stage", stage);
	hData.AddString("modes_list_string", modes);
	hData.AddNum("place_top_at_least", placeTopAtLeast);
	hData.AddNum("place_top_overall_at_least", placeTopOverallAtLeast);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddString("created_since", createdSince);
	hData.AddString("player_name", playerName);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetRecordsTopRecent_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordsTopWorldRecords(OnAPICallFinished callback = INVALID_FUNCTION, any data = DEFAULT_DATA,
													int[] ids = DEFAULT_INT, int idsLength = DEFAULT_INT,
													int[] mapIds = DEFAULT_INT, int mapIdsLength = DEFAULT_INT,
													int[] stages = DEFAULT_INT, int stagesLength = DEFAULT_INT,
													int[] modeIds = DEFAULT_INT, int modeIdsLength = DEFAULT_INT,
													int[] tickRates = DEFAULT_INT, int tickRatesLength = DEFAULT_INT,
													bool hasTeleports = DEFAULT_BOOL, char[] mapTag = DEFAULT_STRING,
													int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
#define GlobalAPI_GetRecordsTopWorldRecords_Endpoint "records/top/world_records"
public int Native_GetRecordsTopWorldRecords(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	int ids[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(3, ids, sizeof(ids));
	int idsLength = GetNativeCell(4);
	
	int mapIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(5, mapIds, sizeof(mapIds));
	int mapIdsLength = GetNativeCell(6);
	
	int stages[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(7, stages, sizeof(stages));
	int stagesLength = GetNativeCell(8);
	
	int modeIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(9, modeIds, sizeof(modeIds));
	int modeIdsLength = GetNativeCell(10);
	
	int tickRates[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(11, tickRates, sizeof(tickRates));
	int tickRatesLength = GetNativeCell(12);
	
	bool hasTeleports = GetNativeCell(13);
	
	char mapTag[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(14, mapTag, sizeof(mapTag));
	
	int offset = GetNativeCell(15);
	int limit = GetNativeCell(16);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddIntArray("ids", ids, idsLength);
	hData.AddIntArray("map_ids", mapIds, mapIdsLength);
	hData.AddIntArray("stages", stages, stagesLength);
	hData.AddIntArray("mode_ids", modeIds, modeIdsLength);
	hData.AddIntArray("tickrates", tickRates, tickRatesLength);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddString("mapTag", mapTag);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetRecordsTopWorldRecords_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetServers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
										int id = DEFAULT_INT, int port = DEFAULT_INT, char[] ip = DEFAULT_STRING,
										char[] name = DEFAULT_STRING, int ownerSteamId64 = DEFAULT_INT,
										int approvalStatus = DEFAULT_INT, int offset = DEFAULT_INT, int limit = DEFAULT_INT)
*/
#define GlobalAPI_GetServers_Endpoint "servers"
public int Native_GetServers(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	int id = GetNativeCell(3);
	int port = GetNativeCell(4);

	char ip[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(5, ip, sizeof(ip));

	char name[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(6, name, sizeof(name));

	char ownerSteamId64[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(7, ownerSteamId64, sizeof(ownerSteamId64));

	int approvalStatus = GetNativeCell(8);
	int offset = GetNativeCell(9);
	int limit = GetNativeCell(10);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddNum("id", id);
	hData.AddNum("port", port);
	hData.AddString("ip", ip);
	hData.AddString("name", name);
	hData.AddString("owner_steamid64", ownerSteamId64);
	hData.AddNum("approval_status", approvalStatus);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetServers_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetServerById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id)
*/
#define GlobalAPI_GetServerById_Endpoint "servers/{id}"
public int Native_GetServerById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetServerById_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "id", .intValue = id);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetServersByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] serverName)
*/
#define GlobalAPI_GetServersByName_Endpoint "servers/name/{server_name}"
public int Native_GetServersByName(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char serverName[GlobalAPI_Max_QueryParam_Length];
	GetNativeString(3, serverName, sizeof(serverName));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetServersByName_Endpoint);
	hData.AddEndpoint(requestUrl);
	
	FormatPathParam(requestUrl, sizeof(requestUrl), "server_name", serverName);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayerRanks(OnAPICallFinished callback = INVALID_FUNCTION, any data = DEFAULT_DATA,
										int pointsGreaterThan = DEFAULT_INT, float averageGreaterThan = DEFAULT_FLOAT,
										float ratingGreaterThan = DEFAULT_FLOAT, int finishesGreaterThan = DEFAULT_INT,
										int[] steamId64s = DEFAULT_INT, int steamId64sLength = DEFAULT_INT, 
										int[] recordFilterIds = DEFAULT_INT, int recordFilterIdsLength = DEFAULT_INT,
										int[] mapIds = DEFAULT_INT, int mapIdsLength = DEFAULT_INT,
										int[] stages = DEFAULT_INT, int stagesLength = DEFAULT_INT,
										int[] modeIds = DEFAULT_INT, int modeIdsLength = DEFAULT_INT,
										int[] tickRates = DEFAULT_INT, int tickRatesLength = DEFAULT_INT,
										bool hasTeleports = DEFAULT_BOOL, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
#define GlobalAPI_GetPlayerRanks_Endpoint "player_ranks"
public int Native_GetPlayerRanks(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	int pointsGreaterThan = GetNativeCell(3);
	float averageGreaterThan = GetNativeCell(4);
	float ratingGreaterThan = GetNativeCell(5);
	int finishesGreaterThan = GetNativeCell(6);

	char steamId64List[GlobalAPI_Max_QueryParam_Length * GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeString(7, steamId64List, sizeof(steamId64List));

	int recordFilterIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(8, recordFilterIds, sizeof(recordFilterIds));
	int recordFilterIdsLength = GetNativeCell(9);

	int mapIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(10, mapIds, sizeof(mapIds));
	int mapIdsLength = GetNativeCell(11);

	int stages[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(12, stages, sizeof(stages));
	int stagesLength = GetNativeCell(13);

	int modeIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(14, modeIds, sizeof(modeIds));
	int modeIdsLength = GetNativeCell(15);

	int tickRates[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(16, tickRates, sizeof(tickRates));
	int tickRatesLength = GetNativeCell(17);
	
	bool hasTeleports = GetNativeCell(18);
	int offset = GetNativeCell(19);
	int limit = GetNativeCell(20);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddNum("points_greater_than", pointsGreaterThan);
	hData.AddFloat("average_greater_than", averageGreaterThan);
	hData.AddFloat("rating_greater_than", ratingGreaterThan);
	hData.AddNum("finishes_greater_than", finishesGreaterThan);
	hData.AddIntArray("record_filter_ids", recordFilterIds, recordFilterIdsLength);
	hData.AddIntArray("map_ids", mapIds, mapIdsLength);
	hData.AddIntArray("stages", stages, stagesLength);
	hData.AddIntArray("mode_ids", modeIds, modeIdsLength);
	hData.AddIntArray("tickrates", tickRates, tickRatesLength);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	// Add comma-separated steamid64s
	char steamId64s[GlobalAPI_Max_QueryParam_Array_Length][GlobalAPI_Max_QueryParam_Length];
	int count = ExplodeString(steamId64List, ",", steamId64s, sizeof(steamId64s), sizeof(steamId64s[]));

	hData.AddStringArray("steamid64s", steamId64s, count);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetPlayerRanks_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

#define GlobalAPI_GetRecordFilters_Endpoint "record_filters"
public int Native_GetRecordFilters(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	int ids[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(3, ids, sizeof(ids));
	int idsLength = GetNativeCell(4);
	
	int mapIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(5, mapIds, sizeof(mapIds));
	int mapIdsLength = GetNativeCell(6);
	
	int stages[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(7, stages, sizeof(stages));
	int stagesLength = GetNativeCell(8);
	
	int modeIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(9, modeIds, sizeof(modeIds));
	int modeIdsLength = GetNativeCell(10);
	
	int tickRates[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(11, tickRates, sizeof(tickRates));
	int tickRatesLength = GetNativeCell(12);
	
	bool hasTeleports = GetNativeCell(13);
	bool isOverall = GetNativeCell(14);

	int offset = GetNativeCell(15);
	int limit = GetNativeCell(16);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddIntArray("ids", ids, idsLength);
	hData.AddIntArray("map_ids", mapIds, mapIdsLength);
	hData.AddIntArray("stages", stages, stagesLength);
	hData.AddIntArray("mode_ids", modeIds, modeIdsLength);
	hData.AddIntArray("tickrates", tickRates, tickRatesLength);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddBool("is_overall", isOverall);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetRecordFilters_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

#define GlobalAPI_GetRecordFilterDistributions_Endpoint "record_filters/distributions"
public int Native_GetRecordFilterDistributions(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	int ids[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(3, ids, sizeof(ids));
	int idsLength = GetNativeCell(4);
	
	int mapIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(5, mapIds, sizeof(mapIds));
	int mapIdsLength = GetNativeCell(6);
	
	int stages[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(7, stages, sizeof(stages));
	int stagesLength = GetNativeCell(8);
	
	int modeIds[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(9, modeIds, sizeof(modeIds));
	int modeIdsLength = GetNativeCell(10);
	
	int tickRates[GlobalAPI_Max_QueryParam_Array_Length];
	GetNativeArray(11, tickRates, sizeof(tickRates));
	int tickRatesLength = GetNativeCell(12);
	
	bool hasTeleports = GetNativeCell(13);
	bool isOverall = GetNativeCell(14);

	int offset = GetNativeCell(15);
	int limit = GetNativeCell(16);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddIntArray("ids", ids, idsLength);
	hData.AddIntArray("map_ids", mapIds, mapIdsLength);
	hData.AddIntArray("stages", stages, stagesLength);
	hData.AddIntArray("mode_ids", modeIds, modeIdsLength);
	hData.AddIntArray("tickrates", tickRates, tickRatesLength);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddBool("is_overall", isOverall);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetRecordFilterDistributions_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetReplayList(OnAPICallFinished callback = INVALID_FUNCTION, any data = DEFAULT_DATA,
										int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
#define GlobalAPI_GetReplayList_Endpoint "records/replay/list"
public int Native_GetReplayList(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int offset = GetNativeCell(3);
	int limit = GetNativeCell(4);
	
	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	hData.RequestType = GlobalAPIRequestType_GET;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetReplayList_Endpoint);

	hData.AddEndpoint(requestUrl);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetReplayByRecordId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int recordId);
*/
#define GlobalAPI_GetReplayByRecordId_Endpoint "records/{record_id}/replay"
public int Native_GetReplayByRecordId(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int recordId = GetNativeCell(3);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;
	hData.AcceptType = GlobalAPIRequestAcceptType_OctetStream;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetReplayByRecordId_Endpoint);
	hData.AddEndpoint(requestUrl);

	FormatPathParam(requestUrl, sizeof(requestUrl), "record_id", .intValue = recordId);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetReplayByReplayId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int replayId);
*/
#define GlobalAPI_GetReplayByReplayId_Endpoint "records/replay/{replay_id}"
public int Native_GetReplayByReplayId(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int replayId = GetNativeCell(3);

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);

	hData.RequestType = GlobalAPIRequestType_GET;
	hData.AcceptType = GlobalAPIRequestAcceptType_OctetStream;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_GetReplayByReplayId_Endpoint);
	hData.AddEndpoint(requestUrl);

	FormatPathParam(requestUrl, sizeof(requestUrl), "replay_id", .intValue = replayId);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_CreateReplayForRecordId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
													int recordId, char[] replayData, int maxlength);
*/
#define GlobalAPI_CreateReplayForRecordId_Endpoint "records/{record_id}/replay"
public int Native_CreateReplayForRecordId(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int recordId = GetNativeCell(3);

	char replayPath[PLATFORM_MAX_PATH];
	GetNativeString(4, replayPath, sizeof(replayPath));

	GlobalAPIRequestData hData = CreateRequestData(plugin, callback, data);
	hData.AddBodyFile(replayPath);

	hData.KeyRequired = true;
	hData.BodyLength = FileSize(replayPath);
	hData.RequestType = GlobalAPIRequestType_POST;
	hData.ContentType = GlobalAPIRequestContentType_OctetStream;

	char requestUrl[GlobalAPI_Max_QueryUrl_Length];
	FormatRequestUrl(requestUrl, sizeof(requestUrl), GlobalAPI_CreateReplayForRecordId_Endpoint);
	hData.AddEndpoint(requestUrl);

	FormatPathParam(requestUrl, sizeof(requestUrl), "record_id", .intValue = recordId);
	hData.AddUrl(requestUrl);

	return GlobalAPI_SendRequest(hData);
}
