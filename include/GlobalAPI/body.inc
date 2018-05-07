// =========================================================== //

//...

// =========================================================== //

methodmap GlobalAPIRequestBody < Handle
{
	public GlobalAPIRequestBody()
	{
		return view_as<GlobalAPIRequestBody>(json_object());
	}
	
	public void AddString(char[] key, char[] value)
	{
		json_object_set_new(this, key, json_string(value));
	}
	
	public void AddNum(char[] key, int value)
	{
		json_object_set_new(this, key, json_integer(value));
	}
	
	public void AddFloat(char[] key, float value)
	{
		json_object_set_new(this, key, json_real(value));
	}
	
	public void AddAll(StringMap hData)
	{
		StringMapSnapshot keys = hData.Snapshot();
		
		char key[MAX_QUERYPARAM_LENGTH];
		char value[MAX_QUERYPARAM_LENGTH * 16];
		
		for (int i; i < keys.Length; i++)
		{
			keys.GetKey(i, key, sizeof(key));
			
			if (!StrEqual(key, "callback") && !StrEqual(key, "data") && !StrEqual(key, "url"))
			{
				hData.GetString(key, value, sizeof(value));
				this.AddString(key, value);
			}
		}
		keys.Close();
	}
	
	public Handle ToJSONHandle()
	{
		return this;
	}
}

// =========================================================== //