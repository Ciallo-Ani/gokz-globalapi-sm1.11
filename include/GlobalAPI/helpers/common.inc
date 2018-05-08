// =========================================================== //

#include <json>

// =========================================================== //

methodmap APICommonHelper < StringMap
{
	public APICommonHelper(StringMap hData)
	{
		return view_as<APICommonHelper>(hData);
	}
	
	public void GetUrl(char[] buffer, int maxlength)
	{
		this.GetString("url", buffer, maxlength);
	}
	
	property int statusCode
	{
		public get() { int value; return this.GetValue("status", value); }
	}
	
	public void DumpProperties()
	{
		StringMapSnapshot keys = this.Snapshot();

		char key[128];
		char value[1024];
		int valueInt;

		for (int i; i < keys.Length; i++)
		{
			keys.GetKey(i, key, sizeof(key));

			if (this.GetValue(key, valueInt))
			{
				IntToString(valueInt, value, sizeof(value));
			}

			else
			{
				this.GetString(key, value, sizeof(value));
			}
		
			PrintToServer("Key: %s -> %s", key, value);
		}
		delete keys;
	}
}

// =========================================================== //