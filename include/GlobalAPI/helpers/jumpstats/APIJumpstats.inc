// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Jumpstats_Helper_included_
#endinput
#endif
#define _GlobalAPI_Jumpstats_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIJumpstats < JSON_Object
{
	public APIJumpstats(JSON_Object hJumps)
	{
		return view_as<APIJumpstats>(hJumps);
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