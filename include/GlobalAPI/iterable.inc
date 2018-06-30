// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Iterable_included_
#endinput
#endif
#define _GlobalAPI_Iterable_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap APIIterable < JSON_Object
{
	public APIIterable(JSON_Object hItems)
	{
		if (hItems.HasKey("result"))
		{
			return view_as<APIIterable>(hItems.GetObject("result"));
		}
		return view_as<APIIterable>(hItems);
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