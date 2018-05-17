// =========================================================== //

public void CreateNatives()
{
	CreateNative("GlobalAPI_GetAPIKey", Native_GetAPIKey);
	CreateNative("GlobalAPI_GetAuthStatus", Native_GetAuthStatus);

	CreateNative("GlobalAPI_GetBans", Native_GetBans);
	CreateNative("GlobalAPI_CreateBan", Native_CreateBan);
	CreateNative("GlobalAPI_GetJumpstats", Native_GetJumpstats);
	CreateNative("GlobalAPI_CreateJumpstat", Native_CreateJumpstat);
	CreateNative("GlobalAPI_GetJumpstatTop", Native_GetJumpstatTop);
	CreateNative("GlobalAPI_GetJumpstatTop30", Native_GetJumpstatTop30);
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
	native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);
*/
public int Native_GetAuthStatus(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.AddData(data);
	hData.AddCallback(hFwd);
	
	return GetAuthStatus(hData);
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

	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();
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
	hData.AddData(data);
	hData.AddCallback(hFwd);
	
	return GetBans(hData);
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
	
	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();
	hData.AddString("steam_id", steamId);
	hData.AddString("ban_type", banType);
	hData.AddString("stats", stats);
	hData.AddString("notes", notes);
	hData.AddString("ip", ip);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.AddData(data);
	hData.AddCallback(hFwd);
	
	return CreateBan(hData);
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

	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();
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
	hData.AddData(data);
	hData.AddCallback(hFwd);
	
	return GetJumpstats(hData);
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

	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();
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
	hData.AddData(data);
	hData.AddCallback(hFwd);

	return CreateJumpstat(hData);
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

	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();
	hData.AddString("jumpType", jumpType);
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
	hData.AddData(data);
	hData.AddCallback(hFwd);

	// This is a URL param so set it hidden
	hData.SetKeyHidden("jumpType", true);

	return GetJumpstatTop(hData);
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
	
	GlobalAPIRequestParams hData = new GlobalAPIRequestParams();
	hData.AddString("jumpType", jumpType);
	
	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.AddData(data);
	hData.AddCallback(hFwd);

	// This is a URL param so set it hidden
	hData.SetKeyHidden("jumpType", true);

	return GetJumpstatTop30(hData);
}

// =========================================================== //