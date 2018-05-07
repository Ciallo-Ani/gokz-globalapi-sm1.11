// =========================================================== //

methodmap APIBans < Handle
{
	public APIBans(Handle hBans)
	{
		return view_as<APIBans>(hBans);
	}
	
	property int Count
	{
		public get() { return json_array_size(this); }
	}
	
	public Handle GetById(int index)
	{
		return json_array_get(this, index);
	}
}

// =========================================================== //