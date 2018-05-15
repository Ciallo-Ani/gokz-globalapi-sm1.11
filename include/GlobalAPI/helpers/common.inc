// =========================================================== //

#include <json>

// =========================================================== //

methodmap APICommonHelper < GlobalAPIRequestParams
{
	public APICommonHelper(GlobalAPIRequestParams params)
	{
		return view_as<APICommonHelper>(params);
	}

	public void DumpProperties()
	{
		int maxlength;
		StringMapSnapshot keys = this.Snapshot();

		char value[80000];

		for (int i; i < keys.Length; i++)
		{
			maxlength = keys.KeyBufferSize(i);
			char[] key = new char[maxlength];

			keys.GetKey(i, key, maxlength);

			switch (this.GetKeyType(key))
			{
				case Type_String:
				{
					this.GetString(key, value, sizeof(value));
					PrintToServer("%s -> \"%s\"", key, value);
				}
				case Type_Float:
				{
					float floatValue = this.GetFloat(key);
					PrintToServer("%s -> %f", key, floatValue);
				}
				case Type_Int:
				{
					int intValue = this.GetInt(key);
					PrintToServer("%s -> %d", key, intValue);
				}
				case Type_Bool:
				{
					bool boolValue = this.GetBool(key);
					PrintToServer("%s -> %s", key, boolValue ? "true" : "false");
				}
			}
		}
		delete keys;
	}
}

// =========================================================== //