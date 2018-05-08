// =========================================================== //

//...

// =========================================================== //

methodmap GlobalAPIRequestBody < JSON_Object
{
	public GlobalAPIRequestBody()
	{
		return view_as<GlobalAPIRequestBody>(new JSON_Object());
	}
	
	public void AddAll(StringMap hData)
	{
		int maxlength;
		char value[1024];
		StringMapSnapshot keys = hData.Snapshot();
		
		for (int i; i < keys.Length; i++)
		{
			maxlength = keys.KeyBufferSize(i);
			char[] key = new char[maxlength];

			keys.GetKey(i, key, maxlength);

			if (!StrEqual(key, "callback") && !StrEqual(key, "data") && !StrEqual(key, "url"))
			{
				hData.GetString(key, value, sizeof(value));
				this.SetString(key, value);
			}
		}
		delete keys;
	}
}

// =========================================================== //