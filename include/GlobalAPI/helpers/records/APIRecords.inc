// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Records_Helper_included_
#endinput
#endif
#define _GlobalAPI_Records_Helper_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIRecords < JSON_Object
{
	public APIRecords(JSON_Object hRecords)
	{
		if (hRecords.HasKey("result"))
		{
			return view_as<APIRecords>(hRecords.GetObject("result"));
		}
		return view_as<APIRecords>(hRecords);
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