// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Bans_Helper_included_
#endinput
#endif
#define _GlobalAPI_Bans_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIBans < JSON_Object
{
	public APIBans(JSON_Object hBans)
	{
		return view_as<APIBans>(hBans);
	}
	
	property int Count
	{
		public get() { return this.Length; }
	}
	
	public Handle GetById(int index)
	{
		return this.GetObjectIndexed(index);
	}
}

// =========================================================== //