// =========================================================== //

public void CreateNatives()
{
	// Plugin
	CreateNative("GlobalAPI_GetAPIKey", Native_GetAPIKey);
	CreateNative("GlobalAPI_GetStaging", Native_GetStaging);

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

	// Modes
	CreateNative("GlobalAPI_GetModes", Native_GetModes);
	CreateNative("GlobalAPI_GetModeById", Native_GetModeById);
	CreateNative("GlobalAPI_GetModeByName", Native_GetModeByName);

	// Players
	CreateNative("GlobalAPI_GetPlayers", Native_GetPlayers);
	CreateNative("GlobalAPI_GetPlayerBySteamId", Native_GetPlayerBySteamId);
	CreateNative("GlobalAPI_GetPlayerBySteamIdAndIp", Native_GetPlayerBySteamIdAndIp);

	// Records
	CreateNative("GlobalAPI_GetRecords", Native_GetRecords);
	CreateNative("GlobalAPI_CreateRecord", Native_CreateRecord);
	CreateNative("GlobalAPI_GetRecordPlaceById", Native_GetRecordPlaceById);
	CreateNative("GlobalAPI_GetRecordsTop", Native_GetRecordsTop);
	CreateNative("GlobalAPI_GetRecordsTopRecent", Native_GetRecordsTopRecent);

	// Servers
	CreateNative("GlobalAPI_GetServers", Native_GetServers);
	CreateNative("GlobalAPI_GetServerById", Native_GetServerById);
	CreateNative("GlobalAPI_GetServersByName", Native_GetServersByName);
}

// =========================================================== //

/*
	native void GlobalAPI_GetAPIKey(char[] buffer, int maxlength);
*/
public int Native_GetAPIKey(Handle plugin, int numParams)
{	
	int maxlength = GetNativeCell(2);
	SetNativeString(1, gC_apiKey, maxlength);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetStaging();
*/
public int Native_GetStaging(Handle plugin, int numParams)
{
	return gB_Staging;
}

// =========================================================== //

/*
	native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public int Native_GetAuthStatus(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;
	hData.keyRequired = true;
	
	char requestUrl[MAX_QUERYURL_LENGTH];
	FormatEx(requestUrl, sizeof(requestUrl), "%s/auth/status", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] banTypes = DEFAULT_STRING,
									char[] banTypesList = DEFAULT_STRING, bool isExpired = DEFAULT_BOOL, char[] ipAddress = DEFAULT_STRING,
									int steamId64 = DEFAULT_INT, char[] steamId = DEFAULT_STRING, char[] notesContain = DEFAULT_STRING,
									char[] statsContain = DEFAULT_STRING, int serverId = DEFAULT_INT, char[] createdSince = DEFAULT_STRING,
									char[] updatedSince = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetBans(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	char banTypes[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, banTypes, sizeof(banTypes));
	
	char banTypesList[MAX_QUERYPARAM_LENGTH];
	GetNativeString(4, banTypesList, sizeof(banTypesList));

	bool isExpired = GetNativeCell(5);
	
	char ipAddress[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, ipAddress, sizeof(ipAddress));

	int steamId64 = GetNativeCell(7);
	
	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(8, steamId, sizeof(steamId));
	
	char notesContain[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, notesContain, sizeof(notesContain));
	
	char statsContain[MAX_QUERYPARAM_LENGTH];
	GetNativeString(10, statsContain, sizeof(statsContain));
	
	int serverId = GetNativeCell(11);
	
	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(12, createdSince, sizeof(createdSince));
	
	char updatedSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(13, updatedSince, sizeof(updatedSince));
	
	int offset = GetNativeCell(14);
	int limit = GetNativeCell(15);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("ban_types", banTypes);
	hData.AddString("ban_types_list", banTypesList);
	hData.AddBool("is_expired", isExpired);
	hData.AddString("ip", ipAddress);
	hData.AddNum("steamid64", steamId64);
	hData.AddString("steam_id", steamId);
	hData.AddString("notes_contains", notesContain);
	hData.AddString("stats_contains", statsContain);
	hData.AddNum("server_id", serverId);
	hData.AddString("created_since", createdSince);
	hData.AddString("updated_since", updatedSince);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	FormatEx(requestUrl, sizeof(requestUrl), "%s/bans", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/* 
	native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
										char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip);
*/
public int Native_CreateBan(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));
	
	char banType[MAX_QUERYPARAM_LENGTH];
	GetNativeString(4, banType, sizeof(banType));
	
	char stats[MAX_QUERYPARAM_LENGTH * 8];
	GetNativeString(5, stats, sizeof(stats));
	
	char notes[MAX_QUERYPARAM_LENGTH * 16];
	GetNativeString(6, notes, sizeof(notes));
	
	char ip[MAX_QUERYPARAM_LENGTH];
	GetNativeString(7, ip, sizeof(ip));
	
	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("steam_id", steamId);
	hData.AddString("ban_type", banType);
	hData.AddString("stats", stats);
	hData.AddString("notes", notes);
	hData.AddString("ip", ip);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;
	hData.keyRequired = true;
	hData.bodyLength = 1856;

	char requestUrl[MAX_QUERYURL_LENGTH];
	FormatEx(requestUrl, sizeof(requestUrl), "%s/bans", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPPost(hData);
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
										int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetJumpstats(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	int id = GetNativeCell(3);
	int serverId = GetNativeCell(4);
	int steamId64 = GetNativeCell(5);
	
	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, steamId, sizeof(steamId));
	
	char jumpType[MAX_QUERYPARAM_LENGTH];
	GetNativeString(7, jumpType, sizeof(jumpType));
	
	// TODO FIXME: 64 is certainly not enough 
	char steamId64List[MAX_QUERYPARAM_LENGTH];
	GetNativeString(8, steamId64List, sizeof(steamId64List));
	
	char jumpTypeList[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, jumpTypeList, sizeof(jumpTypeList));

	float greaterThanDistance = GetNativeCell(10);
	float lowerThanDistance = GetNativeCell(11);

	bool isMsl = GetNativeCell(12);
	bool isCrouchBind = GetNativeCell(13);
	bool isForwardBind = GetNativeCell(14);
	bool isCrouchBoost = GetNativeCell(15);
	
	int updatedById = GetNativeCell(16);
	
	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(17, createdSince, sizeof(createdSince));
	
	char updatedSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(18, updatedSince, sizeof(updatedSince));
	
	int offset = GetNativeCell(19);
	int limit = GetNativeCell(20);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddNum("id", id);
	hData.AddNum("server_id", serverId);
	hData.AddNum("steamid64", steamId64);
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

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	FormatEx(requestUrl, sizeof(requestUrl), "%s/jumpstats", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_CreateJumpstat(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId,
											int jumpType, float distance, char[] jumpJsonInfo, int tickRate, int mslCount,
											bool isCrouchBind, bool isForwardBind, bool isCrouchBoost, int strafeCount);
*/
public int Native_CreateJumpstat(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	int jumpType = GetNativeCell(4);
	float distance = GetNativeCell(5);

	char jumpJsonInfo[MAX_QUERYPARAM_LENGTH * 1250];
	GetNativeString(6, jumpJsonInfo, sizeof(jumpJsonInfo));

	int tickRate = GetNativeCell(7);
	int mslCount = GetNativeCell(8);
	bool isCrouchBind = GetNativeCell(9);
	bool isForwardBind = GetNativeCell(10);
	bool isCrouchBoost = GetNativeCell(11);
	int strafeCount = GetNativeCell(12);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
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

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;
	hData.keyRequired = true;
	hData.bodyLength = 100352;

	char requestUrl[MAX_QUERYURL_LENGTH];
	FormatEx(requestUrl, sizeof(requestUrl), "%s/jumpstats", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPPost(hData);
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
											int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetJumpstatTop(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char jumpType[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, jumpType, sizeof(jumpType));

	int id = GetNativeCell(4);
	int serverId = GetNativeCell(5);
	int steamId64 = GetNativeCell(6);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(7, steamId, sizeof(steamId));

	char steamId64List[MAX_QUERYPARAM_LENGTH];
	GetNativeString(8, steamId64List, sizeof(steamId64List));

	char jumpTypeList[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, jumpTypeList, sizeof(jumpTypeList));

	float greaterThanDistance = GetNativeCell(10);
	float lessThanDistance = GetNativeCell(11);
	bool isMsl = GetNativeCell(12);
	bool isCrouchBind = GetNativeCell(13);
	bool isForwardBind = GetNativeCell(14);
	bool isCrouchBoost = GetNativeCell(15);
	int updatedById = GetNativeCell(16);

	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(17, createdSince, sizeof(createdSince));

	char updatedSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(18, updatedSince, sizeof(updatedSince));

	int offset = GetNativeCell(19);
	int limit = GetNativeCell(20);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddNum("id", id);
	hData.AddNum("server_id", serverId);
	hData.AddNum("steamid64", steamId64);
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

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/jumpstats/%s/top", gC_baseUrl, jumpType);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetJumpstatTop30(OnAPICallFinished callback = INVALID_HANDLE, any data = INVALID_HANDLE, char[] jumpType);
*/
public int Native_GetJumpstatTop30(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char jumpType[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, jumpType, sizeof(jumpType));

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/jumpstats/%s/top30", gC_baseUrl, jumpType);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetMaps(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] name = DEFAULT_STRING,
									int largerThanFilesize = DEFAULT_INT, int smallerThanFilesize = DEFAULT_INT, bool isValidated = DEFAULT_BOOL,
									int difficulty = DEFAULT_INT, char[] createdSince = DEFAULT_STRING, char[] updatedSince = DEFAULT_STRING,
									int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetMaps(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char name[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, name, sizeof(name));

	int largerThanFilesize = GetNativeCell(4);
	int smallerThanFilesize = GetNativeCell(5);
	bool isValidated = GetNativeCell(6);
	int difficulty = GetNativeCell(7);

	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(8, createdSince, sizeof(createdSince));

	char updatedSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, updatedSince, sizeof(updatedSince));

	int offset = GetNativeCell(10);
	int limit = GetNativeCell(11);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("name", name);
	hData.AddNum("larger_than_filesize", largerThanFilesize);
	hData.AddNum("smaller_than_filesize", smallerThanFilesize);
	hData.AddBool("is_validated", isValidated);
	hData.AddNum("difficulty", difficulty);
	hData.AddString("created_since", createdSince);
	hData.AddString("updated_since", updatedSince);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/maps", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetModes(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public int Native_GetModes(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/modes", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetModeById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);
*/
public int Native_GetModeById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/modes/id/%d", gC_baseUrl, id);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetModeByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] name);
*/
public int Native_GetModeByName(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char name[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, name, sizeof(name));

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/modes/name/%s", gC_baseUrl, name);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING,
										bool isBanned = DEFAULT_BOOL, int totalRecords = DEFAULT_INT,
										char[] ip = DEFAULT_STRING, char[] steamId64List = DEFAULT_STRING);
*/
public int Native_GetPlayers(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	bool isBanned = GetNativeCell(4);
	int totalRecords = GetNativeCell(5);

	char ip[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, ip, sizeof(ip));

	// TODO FIXME: 64 is certainly not enough
	char steamId64List[MAX_QUERYPARAM_LENGTH];
	GetNativeString(7, steamId64List, sizeof(steamId64List));

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("steam_id", steamId);
	hData.AddBool("is_banned", isBanned);
	hData.AddNum("total_records", totalRecords);
	hData.AddString("ip", ip);
	hData.AddString("steamid64_list", steamId64List);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/players", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayerBySteamId(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING);
*/
public int Native_GetPlayerBySteamId(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/players/steamid/%s", gC_baseUrl, steamId);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetPlayerBySteamIdAndIp(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId, char[] ip);
*/
public int Native_GetPlayerBySteamIdAndIp(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	char ip[MAX_QUERYPARAM_LENGTH];
	GetNativeString(4, ip, sizeof(ip));

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;
	hData.keyRequired = true;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/players/steamid/%s/ip/%s", gC_baseUrl, steamId, ip);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecords(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] mapName = DEFAULT_STRING,
										char[] modes = DEFAULT_STRING, int tickRate = DEFAULT_INT, char[] steamId = DEFAULT_STRING,
										int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetRecords(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char mapName[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, mapName, sizeof(mapName));

	char modes[MAX_QUERYPARAM_LENGTH];
	GetNativeString(4, modes, sizeof(modes));

	int tickRate = GetNativeCell(5);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, steamId, sizeof(steamId));

	int offset = GetNativeCell(7);
	int limit = GetNativeCell(8);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("map_name", mapName);
	hData.AddString("modes", modes);
	hData.AddNum("tick_rate", tickRate);
	hData.AddString("steam_id", steamId);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_CreateRecord(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId, int mapId,
										char[] mode, int stage, int tickRate, int teleports, float time);
*/
public int Native_CreateRecord(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	int mapId = GetNativeCell(4);

	char mode[MAX_QUERYPARAM_LENGTH];
	GetNativeString(5, mode, sizeof(mode));

	int stage = GetNativeCell(6);
	int tickRate = GetNativeCell(7);
	int teleports = GetNativeCell(8);
	float time = GetNativeCell(9);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("steam_id", steamId);
	hData.AddNum("map_id", mapId);
	hData.AddString("mode", mode);
	hData.AddNum("stage", stage);
	hData.AddNum("tickrate", tickRate);
	hData.AddNum("teleports", teleports);
	hData.AddFloat("time", time);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;
	hData.keyRequired = true;
	hData.bodyLength = 1024;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPPost(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordPlaceById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);
*/
public int Native_GetRecordPlaceById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records/place/%d", gC_baseUrl, id);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordsTop(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
											char[] steamId = DEFAULT_STRING, int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT,
											char[] mapName = DEFAULT_STRING, int tickRate = DEFAULT_INT, int stage = DEFAULT_INT,
											char[] modes = DEFAULT_STRING, bool hasTeleports = DEFAULT_BOOL, char[] playerName = DEFAULT_STRING,
											int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetRecordsTop(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	int steamId64 = GetNativeCell(4);
	int mapId = GetNativeCell(5);

	char mapName[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, mapName, sizeof(mapName));

	int tickRate = GetNativeCell(7);
	int stage = GetNativeCell(8);

	char modes[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, modes, sizeof(modes));

	bool hasTeleports = GetNativeCell(10);

	char playerName[MAX_QUERYPARAM_LENGTH];
	GetNativeString(11, playerName, sizeof(playerName));

	int offset = GetNativeCell(12);
	int limit = GetNativeCell(13);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("steam_id", steamId);
	hData.AddNum("steamid64", steamId64);
	hData.AddNum("map_id", mapId);
	hData.AddString("map_name", mapName);
	hData.AddNum("tickrate", tickRate);
	hData.AddNum("stage", stage);
	hData.AddString("modes_list_string", modes);
	hData.AddBool("has_teleports", hasTeleports);
	hData.AddString("player_name", playerName);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records/top", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetRecordsTopRecent(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] steamId = DEFAULT_STRING,
												int steamId64 = DEFAULT_INT, int mapId = DEFAULT_INT, char[] mapName = DEFAULT_STRING,
												int tickRate = DEFAULT_INT, int stage = DEFAULT_INT, char[] modes = DEFAULT_STRING,
												int placeTopAtLeast = DEFAULT_INT, int placeTopOverallAtLeast = DEFAULT_INT,
												bool hasTeleports = DEFAULT_BOOL, char[] createdSince = DEFAULT_STRING,
												char[] playerName = DEFAULT_STRING, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetRecordsTopRecent(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, steamId, sizeof(steamId));

	int steamId64 = GetNativeCell(4);
	int mapId = GetNativeCell(5);

	char mapName[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, mapName, sizeof(mapName));

	int tickRate = GetNativeCell(7);
	int stage = GetNativeCell(8);

	char modes[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, modes, sizeof(modes));

	int placeTopAtLeast = GetNativeCell(10);
	int placeTopOverallAtLeast = GetNativeCell(11);
	bool hasTeleports = GetNativeCell(12);

	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(13, createdSince, sizeof(createdSince));

	char playerName[MAX_QUERYPARAM_LENGTH];
	GetNativeString(14, playerName, sizeof(playerName));

	int offset = GetNativeCell(15);
	int limit = GetNativeCell(16);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddString("steam_id", steamId);
	hData.AddNum("steamid64", steamId64);
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

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/records/top/recent", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetServers(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
										int id = DEFAULT_INT, int port = DEFAULT_INT, char[] ip = DEFAULT_STRING,
										char[] name = DEFAULT_STRING, int ownerSteamId64 = DEFAULT_INT,
										int approvalStatus = DEFAULT_INT, int offset = DEFAULT_INT, int limit = DEFAULT_INT);
*/
public int Native_GetServers(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	int id = GetNativeCell(3);
	int port = GetNativeCell(4);

	char ip[MAX_QUERYPARAM_LENGTH];
	GetNativeString(5, ip, sizeof(ip));

	char name[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, name, sizeof(name));

	int ownerSteamId64 = GetNativeCell(7);
	int approvalStatus = GetNativeCell(8);
	int offset = GetNativeCell(9);
	int limit = GetNativeCell(10);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();
	hData.AddNum("id", id);
	hData.AddNum("port", port);
	hData.AddString("ip", ip);
	hData.AddString("name", name);
	hData.AddNum("owner_steamid64", ownerSteamId64);
	hData.AddNum("approval_status", approvalStatus);
	hData.AddNum("offset", offset);
	hData.AddNum("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/servers", gC_baseUrl);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetServerById(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id);
*/
public int Native_GetServerById(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	int id = GetNativeCell(3);

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/servers/%d", gC_baseUrl, id);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetServersByName(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] serverName);
*/
public int Native_GetServersByName(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);

	char serverName[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, serverName, sizeof(serverName));

	GlobalAPIRequestData hData = new GlobalAPIRequestData();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.data = data;
	hData.callback = hFwd;

	char requestUrl[MAX_QUERYURL_LENGTH];
	Format(requestUrl, sizeof(requestUrl), "%s/servers/name/%s", gC_baseUrl, serverName);
	hData.AddUrl(requestUrl);

	return HTTPGet(hData);
}

// =========================================================== //