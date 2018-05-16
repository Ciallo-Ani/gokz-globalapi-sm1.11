// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Common_Helper_included_
#endinput
#endif
#define _GlobalAPI_Common_Helper_included_

// =========================================================== //

#include <GlobalAPI/params>

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
					PrintToServer("[String] %s => \"%s\"", key, value);
				}
				case Type_Float:
				{
					float floatValue = this.GetFloat(key);
					PrintToServer("[Float] %s => %f", key, floatValue);
				}
				case Type_Int:
				{
					int intValue = this.GetInt(key);
					PrintToServer("[Integer] %s => %d", key, intValue);
				}
				case Type_Bool:
				{
					bool boolValue = this.GetBool(key);
					PrintToServer("[Boolean] %s => %s", key, boolValue ? "true" : "false");
				}
				case Type_Null:
				{
					PrintToServer("[Default] %s", key);
				}
			}
		}
		delete keys;
	}
}

// =========================================================== //