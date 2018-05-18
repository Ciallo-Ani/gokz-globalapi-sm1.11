// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Maps_Helper_included_
#endinput
#endif
#define _GlobalAPI_Maps_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIMaps < JSON_Object
{
	public APIMaps(JSON_Object hMaps)
	{
		return view_as<APIMaps>(hMaps);
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