// =========================================================== //

public void CreateNatives()
{
	CreateNative("GlobalAPI_GetAPIKey", Native_GetAPIKey);
	CreateNative("GlobalAPI_GetAuthStatus", Native_GetAuthStatus);

	CreateNative("GlobalAPI_GetBans", Native_GetBans);
	CreateNative("GlobalAPI_CreateBan", Native_CreateBan);
	CreateNative("GlobalAPI_GetJumpstats", Native_GetJumpstats);
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
	
	StringMap hData = new StringMap();

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.SetValue("callback", hFwd);

	hData.SetValue("data", data);
	
	return GetAuthStatus(hData);
}

// =========================================================== //

/*
	native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] banTypes = "",
									char[] banTypesList = "", char[] isExpired = "", char[] ipAddress = "",
									int steamId64 = -1, char[] steamId = "",char[] notesContain = "",
									char[] statsContain = "", int serverId = -1, char[] createdSince = "",
									char[] updatedSince = "", int offset = -1, int limit = -1);
*/
public int Native_GetBans(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	char banTypes[MAX_QUERYPARAM_LENGTH];
	GetNativeString(3, banTypes, sizeof(banTypes));
	
	char banTypesList[MAX_QUERYPARAM_LENGTH];
	GetNativeString(4, banTypesList, sizeof(banTypesList));
	
	char isExpired[MAX_QUERYPARAM_LENGTH];
	GetNativeString(5, isExpired, sizeof(isExpired));
	
	char ipAddress[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, ipAddress, sizeof(ipAddress));
	
	char steamId64[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(7), steamId64, sizeof(steamId64));
	
	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(8, steamId, sizeof(steamId));
	
	char notesContain[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, notesContain, sizeof(notesContain));
	
	char statsContain[MAX_QUERYPARAM_LENGTH];
	GetNativeString(10, statsContain, sizeof(statsContain));
	
	char serverId[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(11), serverId, sizeof(serverId));
	
	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(12, createdSince, sizeof(createdSince));
	
	char updatedSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(13, updatedSince, sizeof(updatedSince));
	
	char offset[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(14), offset, sizeof(offset));
	
	char limit[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(15), limit, sizeof(limit));
	
	StringMap hData = new StringMap();
	hData.SetString("ban_types", banTypes);
	hData.SetString("ban_types_list", banTypesList);
	hData.SetString("is_expired", isExpired);
	hData.SetString("ip", ipAddress);
	hData.SetString("steamid64", steamId64);
	hData.SetString("steam_id", steamId);
	hData.SetString("notes_contains", notesContain);
	hData.SetString("stats_contains", statsContain);
	hData.SetString("server_id", serverId);
	hData.SetString("created_since", createdSince);
	hData.SetString("updated_since", updatedSince);
	hData.SetString("offset", offset);
	hData.SetString("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.SetValue("callback", hFwd);

	hData.SetValue("data", data);
	
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
	
	StringMap hData = new StringMap();
	hData.SetString("steam_id", steamId);
	hData.SetString("ban_type", banType);
	hData.SetString("notes", notes);
	hData.SetString("stats", stats);
	hData.SetString("ip", ip);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.SetValue("callback", hFwd);

	hData.SetValue("data", data);
	
	return CreateBan(hData);
}

// =========================================================== //

/*
native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = -1,
									int serverId = -1, int steamId64 = -1, char[] steamId = "", char[] jumpType = "",
									char[] steamId64List = "", char[] jumpTypeList = "", float greaterThanDistance = -1.0,
									float lessThanDistance = -1.0, char[] isMsl = "", char[] isCrouchBind = "", char[] isForwardBind = "",
									char[] isCrouchBoost = "", int updatedById = -1, char[] createdSince = "", char[] updatedSince = "", 
									int offset = -1, int limit = -1);
*/
public int Native_GetJumpstats(Handle plugin, int numParams)
{
	Function callback = GetNativeCell(1);
	any data = GetNativeCell(2);
	
	char id[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(3), id, sizeof(id));
	
	char serverId[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(4), serverId, sizeof(serverId));
	
	char steamId64[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(5), steamId64, sizeof(steamId64));
	
	char steamId[MAX_QUERYPARAM_LENGTH];
	GetNativeString(6, steamId, sizeof(steamId));
	
	char jumpType[MAX_QUERYPARAM_LENGTH];
	GetNativeString(7, jumpType, sizeof(jumpType));
	
	// TODO FIXME: 64 is certainly not enough 
	char steamId64List[MAX_QUERYPARAM_LENGTH];
	GetNativeString(8, steamId64List, sizeof(steamId64List));
	
	char jumpTypeList[MAX_QUERYPARAM_LENGTH];
	GetNativeString(9, jumpTypeList, sizeof(jumpTypeList));
	
	char greaterThanDistance[MAX_QUERYPARAM_LENGTH];
	FloatToString(GetNativeCell(10), greaterThanDistance, sizeof(greaterThanDistance));
	
	char lowerThanDistance[MAX_QUERYPARAM_LENGTH];
	FloatToString(GetNativeCell(11), lowerThanDistance, sizeof(lowerThanDistance));
	
	char isMsl[MAX_QUERYPARAM_LENGTH];
	GetNativeString(12, isMsl, sizeof(isMsl));

	char isCrouchBind[MAX_QUERYPARAM_LENGTH];
	GetNativeString(13, isCrouchBind, sizeof(isCrouchBind));
	
	char isForwardBind[MAX_QUERYPARAM_LENGTH];
	GetNativeString(14, isForwardBind, sizeof(isForwardBind));
	
	char isCrouchBoost[MAX_QUERYPARAM_LENGTH];
	GetNativeString(15, isCrouchBoost, sizeof(isCrouchBoost));
	
	char updatedById[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(16), updatedById, sizeof(updatedById));
	
	char createdSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(17, createdSince, sizeof(createdSince));
	
	char updatedSince[MAX_QUERYPARAM_LENGTH];
	GetNativeString(18, updatedSince, sizeof(updatedSince));
	
	char offset[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(19), offset, sizeof(offset));
	
	char limit[MAX_QUERYPARAM_LENGTH];
	IntToString(GetNativeCell(20), limit, sizeof(limit));
	
	StringMap hData = new StringMap();
	hData.SetString("id", id);
	hData.SetString("server_id", serverId);
	hData.SetString("steamid64", steamId64);
	hData.SetString("steam_id", steamId);
	hData.SetString("jumptype", jumpType);
	hData.SetString("steamid64_list", steamId64List);
	hData.SetString("jumptype_list", jumpTypeList);
	hData.SetString("greater_than_distance", greaterThanDistance);
	hData.SetString("lower_than_distance", lowerThanDistance);
	hData.SetString("is_msl", isMsl);
	hData.SetString("is_crouch_bind", isCrouchBind);
	hData.SetString("is_forward_bind", isForwardBind);
	hData.SetString("is_crouch_boost", isCrouchBoost);
	hData.SetString("updated_by_id", updatedById);
	hData.SetString("created_since", createdSince);
	hData.SetString("updated_since", updatedSince);
	hData.SetString("offset", offset);
	hData.SetString("limit", limit);

	Handle hFwd = CreateForwardHandle(callback, data);
	AddToForwardEx(hFwd, plugin, callback);
	hData.SetValue("callback", hFwd);

	hData.SetValue("data", data);
	
	return GetJumpstats(hData);
}

// =========================================================== //