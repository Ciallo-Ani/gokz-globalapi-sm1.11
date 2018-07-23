// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Retrying_included_
#endinput
#endif
#define _GlobalAPI_Retrying_included_

// ======================= NATIVES =========================== //

native bool GlobalAPI_Retrying_LoadModule();
native bool GlobalAPI_Retrying_UnloadModule();

native int GlobalAPI_Retrying_GetModulesCount();

// ======================= PLUGIN INFO ======================= //

public SharedPlugin __pl_GlobalAPI =
{
	name = "GlobalAPI-Retrying",
	file = "GlobalAPI-Retrying.smx",
	#if defined REQUIRE_PLUGIN
	required = 1,
	#else
	required = 0,
	#endif
};

// =========================================================== //

#if !defined REQUIRE_PLUGIN
public void __pl_GlobalAPI_Retrying_SetNTVOptional()
{
	MarkNativeAsOptional("GlobalAPI_Retrying_LoadModule");
	MarkNativeAsOptional("GlobalAPI_Retrying_UnloadModule");
	MarkNativeAsOptional("GlobalAPI_Retrying_GetModulesCount");
}
#endif

// =========================================================== //