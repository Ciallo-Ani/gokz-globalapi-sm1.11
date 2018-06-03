// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Server_Helper_included_
#endinput
#endif
#define _GlobalAPI_Server_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIServer < JSON_Object
{
	public APIServer(JSON_Object hServer)
	{
		return view_as<APIServer>(hServer);
	}
	
	property int port
	{
		public get() { return this.GetInt("port"); }
	}
	
	public void GetIPAddress(char[] buffer, int maxlength)
	{
		this.GetString("ip", buffer, maxlength);
	}
	
	public void GetName(char[] buffer, int maxlength)
	{
		this.GetString("name", buffer, maxlength);
	}
	
	property int ownerSteamId64
	{
		public get() { return this.GetInt("owner_steamid64"); }
	}
}

// =========================================================== //