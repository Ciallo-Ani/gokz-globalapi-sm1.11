// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_RequestData_included_
#endinput
#endif
#define _GlobalAPI_RequestData_included_

// =========================================================== //

#include <json>

// =========================================================== //

methodmap GlobalAPIRequestData < JSON_Object
{
	public GlobalAPIRequestData()
	{
		return view_as<GlobalAPIRequestData>(new JSON_Object());
	}

	public void SetDefault(char[] key)
	{
		this.SetHandle(key);
		this.SetKeyHidden(key, true);
	}

	public void AddUrl(char[] url)
	{
		this.SetString("url", url);
		this.SetKeyHidden("url", true);
	}

	public void AddFailure(bool failure)
	{
		this.SetBool("failure", failure);
		this.SetKeyHidden("failure", true);
	}

	public void AddData(any data)
	{
		this.SetInt("data", data);
		this.SetKeyHidden("data", true);
	}

	public void AddCallback(Handle hFwd)
	{
		this.SetHandle("callback", hFwd);
		this.SetKeyHidden("callback", true);
		this.SetKeyType("callback", Type_Int);
	}

	public void AddNum(char[] key, int value)
	{
		if (value == -1)
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetInt(key, value);
		}
	}

	public void AddFloat(char[] key, float value)
	{
		if (value == -1.000000)
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetFloat(key, value);
		}
	}

	public void AddString(char[] key, char[] value)
	{
		if (StrEqual(value, ""))
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetString(key, value);
		}
	}

	public void AddBool(char[] key, bool value)
	{
		if (value != true && value != false)
		{
			this.SetDefault(key);
		}
		else
		{
			this.SetBool(key, value);
		}
	}

	public void ToString(char[] queryString, int maxlength)
	{
		StringMapSnapshot paramsMap = this.Snapshot();

		char key[64]; // MAX_QUERYPARAM_LENGTH
		char value[1024]; // MAX_QUERYPARAM_LENGTH * 16

		int paramCount = 0;

		for (int i = 0; i < paramsMap.Length; i++)
		{
			paramsMap.GetKey(i, key, sizeof(key));

			if (!this.GetKeyHidden(key) && !json_is_meta_key(key))
			{
				switch(this.GetKeyType(key))
				{
					case Type_String:
					{
						this.GetString(key, value, sizeof(value));
					}
					case Type_Float:
					{
						float temp = this.GetFloat(key);
						FloatToString(temp, value, sizeof(value));
					}
					case Type_Int:
					{
						int temp = this.GetInt(key);
						IntToString(temp, value, sizeof(value));
					}
					case Type_Bool:
					{
						bool temp = this.GetBool(key);
						BoolToString(temp, value, sizeof(value));
					}
				}
				AppendToQueryString(paramCount, queryString, maxlength, key, value);
				paramCount++;
			}
		}
		delete paramsMap;
	}
}

// ======================== HELPERS ========================== //

stock void BoolToString(bool value, char[] buffer, int maxlength)
{
	FormatEx(buffer, maxlength, "%s", value ? "true" : "false");
}

stock void AppendToQueryString(int index, char[] buffer, int maxlength, char[] key, char[] value)
{
	if (index == 0)
	{
		Format(buffer, maxlength, "?%s=%s", key, value);
	}
	else
	{
		Format(buffer, maxlength, "%s&%s=%s", buffer, key, value);
	}
}

// =========================================================== //