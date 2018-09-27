// ================== DOUBLE INCLUDE ========================= //

#if defined _GlobalAPI_Function_Helpers_included_
#endinput
#endif
#define _GlobalAPI_Function_Helpers_included_

// =========================================================== //

#include <GlobalAPI>

// =========================================================== //

/**
 * Creates a directory if it does not exist
 *
 * @param dir					Directory to be created
 * @return						Whether the directory exists
 */
stock bool CreateDirectoryIfNotExist(char[] dir)
{
	if (!DirExists(dir))
	{
		return CreateDirectory(dir, 666);
	}
	
	return DirExists(dir);
}

/**
 * Gets plugin's display name from its handle
 *
 * @param plugin				Plugin handle to retrieve name from
 * @return						String representation of the plugin name
 */
stock char GetPluginDisplayName(Handle plugin)
{
	char pluginName[GlobalAPI_Max_PluginName_Length] = "Unknown";
	GetPluginInfo(plugin, PlInfo_Name, pluginName, sizeof(pluginName));
	
	return pluginName;
}

/**
 * Gets current map's "display name"
 *
 * @param buffer				Buffer to store the result in
 * @param maxlength				Max length of the buffer
 * @noreturn
 */
stock void GetMapDisplay(char[] buffer, int maxlength)
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));
	GetMapDisplayName(map, map, sizeof(map));
	
	FormatEx(buffer, maxlength, map);
}

/**
 * Gets current map's full (game dir) path
 *
 * @param buffer				Buffer to store result in
 * @param maxlength				Max length of the buffer
 * @noreturn
 */
stock void GetMapFullPath(char[] buffer, int maxlength)
{
	char mapPath[PLATFORM_MAX_PATH];
	GetCurrentMap(mapPath, sizeof(mapPath));
	
	Format(buffer, maxlength, "maps/%s.bsp", mapPath);
}

/**
 * Formats date from a ISO8601 datetime string
 *
 * @param datetime				Datetime string to parse from
 * @param useSlashes			Whether to use slashes instead of "-" in dates
 * @return						String representation of the date
 */
stock char FormatISO8601Date(char[] datetime, bool useSlashes = true)
{
	char date[2][30];
	ExplodeString(datetime, "T", date, sizeof(date), sizeof(date[]));
	
	if (useSlashes)
		ReplaceString(date[0], sizeof(date[]), "-", "/");
	
	return date[0];
}

/**
 * Formats a time float to a human readable format
 *
 * @param time					Time as a float
 * @return						Human readable string representation of the time
 */
stock char FormatRecordTime(float time, bool leadingZeroes = false)
{
	char formattedTime[12];
	int roundedTime = RoundFloat(time * 100);
	
	int milliseconds = roundedTime % 100;
	roundedTime = (roundedTime - milliseconds) / 100;
	int seconds = roundedTime % 60;
	roundedTime = (roundedTime - seconds) / 60;
	int minutes = roundedTime % 60;
	roundedTime = (roundedTime - minutes) / 60;
	int hours = roundedTime;
	
	if (hours == 0)
	{
		if (!leadingZeroes)
		{
			FormatEx(formattedTime, sizeof(formattedTime), "%02d:%02d.%02d", minutes, seconds, milliseconds);
		}
		else
		{
			FormatEx(formattedTime, sizeof(formattedTime), "00:%02d:%02d.%02d", minutes, seconds, milliseconds);
		}
	}
	else
	{
		FormatEx(formattedTime, sizeof(formattedTime), "%d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds);
	}

	return formattedTime;
}

// =========================================================== //

