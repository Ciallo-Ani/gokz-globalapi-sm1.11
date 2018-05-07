// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_included_
#endinput
#endif
#define _GlobalAPI_included_

// ======================= DEFINITIONS ======================= //

#define GlobalAPI_Version "v1.0"
#define GlobalAPI_Staging_Version "v1.0"
#define GlobalAPI_BaseUrl "https://kztimerglobal.com/api/" ... GlobalAPI_Version
#define GlobalAPI_Staging_BaseUrl "https://staging.kztimerglobal.com/api/" ... GlobalAPI_Staging_Version

#define GlobalAPI_Plugin_Version "2.0.0"
#define GlobalAPI_Plugin_Desc "Plugin helper for GlobalAPI " ... GlobalAPI_Version
#define GlobalAPI_Plugin_Url "https://bitbucket.org/kztimerglobalteam/GlobalAPI-SMPlugin"

// ======================= ENUMS ============================= //

//...

// ======================= TYPEDEFS ========================== //

typeset OnAPICallFinished
{
	function void(bool bFailure, Handle hJson);
	function void(bool bFailure, Handle hJson, any data);
}

// ======================= FORWARDS ========================== //

forward void GlobalAPI_OnInitialized();

// ======================= NATIVES =========================== //

native void GlobalAPI_GetAPIKey(char[] buffer, int maxlength);

native bool GlobalAPI_GetAuthStatus(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE);


native bool GlobalAPI_GetBans(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, char[] banTypes = "",
								char[] banTypesList = "", char[] isExpired = "", char[] ipAddress = "",
								int steamId64 = -1, char[] steamId = "",char[] notesContain = "",
								char[] statsContain = "", int serverId = -1, char[] createdSince = "",
								char[] updatedSince = "", int offset = -1, int limit = -1);
								
native bool GlobalAPI_CreateBan(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE,
								char[] steamId, char[] banType, char[] stats, char[] notes, char[] ip);

native bool GlobalAPI_GetJumpstats(OnAPICallFinished callback = INVALID_FUNCTION, any data = INVALID_HANDLE, int id = -1,
									int serverId = -1, int steamId64 = -1, char[] steamId = "", char[] jumpType = "",
									char[] steamId64List = "", char[] jumpTypeList = "", float greaterThanDistance = -1.0,
									float lessThanDistance = -1.0, char[] isMsl = "", char[] isCrouchBind = "", char[] isForwardBind = "",
									char[] isCrouchBoost = "", int updatedById = -1, char[] createdSince = "", char[] updatedSince = "", 
									int offset = -1, int limit = -1);

// ======================= PLUGIN INFO ======================= //

public SharedPlugin __pl_GlobalAPI =
{
	name = "GlobalAPI",
	file = "GlobalAPI.smx",
	#if defined REQUIRE_PLUGIN
	required = 1,
	#else
	required = 0,
	#endif
};

// =========================================================== //

#if !defined REQUIRE_PLUGIN
public void __pl_GlobalAPI_SetNTVOptional()
{
	MarkNativeAsOptional("GlobalAPI_GetAPIKey");
	MarkNativeAsOptional("GlobalAPI_GetAuthStatus");
	
	MarkNativeAsOptional("GlobalAPI_GetBans");
	MarkNativeAsOptional("GlobalAPI_CreateBan");
	MarkNativeAsOptional("GlobalAPI_GetJumpstats");
}
#endif

// =========================================================== //