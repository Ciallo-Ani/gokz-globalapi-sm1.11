// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI/helpers>

// ====================== FORMATTING ========================= //

#pragma newdecls required

// ====================== PLUGIN INFO ======================== //

// This plugin builds a keyvalues file with Global KZ maps and their tiers for MCE to use
// Requires a custom MCE (https://github.com/MitchDizzle/sourcemod-mapchooser-extended/tree/map-names)
// Generated file can be found under ./csgo/addons/sourcemod/mce_kz_tierlist.txt

public Plugin myinfo = 
{
    name = "GlobalAPI-MCE-TieredMaps",
    author = "Sikari",
    description = "Builds a KeyValues file with tiered Global KZ Maps for MCE",
    version = "1.0.0",
    url = ""
};

// ====================== VARIABLES ========================== //

ArrayList g_arrayList = null;

// ======================= MAIN CODE ========================= //

public void GlobalAPI_OnInitialized()
{
	g_arrayList = new ArrayList();
	
	GlobalAPI_GetMaps(OnMaps, .isValidated = true);
}

public void OnMaps(JSON_Object hResponse, GlobalAPIRequestData hData)
{
	if (hData.failure == false)
	{
		APIIterable iterable = new APIIterable(hResponse);
		
		if (iterable != null)
		{
			for (int i; i < iterable.Length; i++)
			{
				APIMap map = new APIMap(iterable.GetById(i));
				
				char mapName[PLATFORM_MAX_PATH];
				map.GetName(mapName, sizeof(mapName));
				
				int mapTier = map.difficulty;
				
				StringMap mapPack = new StringMap();
				mapPack.SetString("mapName", mapName);
				mapPack.SetValue("mapTier", mapTier);
				
				g_arrayList.Push(mapPack);
			}
			BuildTheThingie();
		}
	}
}

public void BuildTheThingie()
{
	KeyValues maps = new KeyValues("Map Names");
	
	for (int i; i < g_arrayList.Length; i++)
	{
		StringMap mapPack = g_arrayList.Get(i);
		
		char mapName[PLATFORM_MAX_PATH];
		mapPack.GetString("mapName", mapName, sizeof(mapName));
		
		int mapTier = -1;
		mapPack.GetValue("mapTier", mapTier);
		
		char displayName[PLATFORM_MAX_PATH + 1];
		Format(displayName, sizeof(displayName), "%s T%d", mapName, mapTier);
		
		maps.SetSectionName(mapName);
		maps.SetString(mapName, displayName);
		
		delete mapPack;
	}
	
	maps.SetSectionName("Map Names");
	
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "mce_kz_tierlist.txt");
	
	maps.ExportToFile(path);
}