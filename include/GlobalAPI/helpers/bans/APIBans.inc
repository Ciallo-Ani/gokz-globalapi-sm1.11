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