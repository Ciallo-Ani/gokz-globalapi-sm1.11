// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Players_Helper_included_
#endinput
#endif
#define _GlobalAPI_Players_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIPlayers < JSON_Object
{
	public APIPlayers(JSON_Object hPlayers)
	{
		return view_as<APIPlayers>(hPlayers);
	}
	
	property int Count
	{
		public get() { return this.Length; }
	}
	
	public JSON_Object GetById(int index)
	{
		return this.GetObjectIndexed(index);
	}
}

// =========================================================== //