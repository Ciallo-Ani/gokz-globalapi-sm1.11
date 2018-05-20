// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Modes_Helper_included_
#endinput
#endif
#define _GlobalAPI_Modes_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIModes < JSON_Object
{
	public APIModes(JSON_Object hModes)
	{
		return view_as<APIModes>(hModes);
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