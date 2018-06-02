// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Servers_Helper_included_
#endinput
#endif
#define _GlobalAPI_Servers_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIServers < JSON_Object
{
	public APIServers(JSON_Object hServers)
	{
		return view_as<APIServers>(hServers);
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