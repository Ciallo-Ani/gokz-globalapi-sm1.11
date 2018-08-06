#include <GlobalAPI>
#include <GlobalAPI/Helpers/Common>

#pragma dynamic 50000000

public void GlobalAPI_OnInitialized()
{
    GlobalAPI_GetReplayByReplayId(OnReplay, _, 1);
    GlobalAPI_GetReplayByRecordId(OnReplay2, _, 791453);

    char path[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, path, sizeof(path), "data/gokz-replays/kz_natureblock_go/0_KZT_NRM_PRO.replay");

    File binaryFile = OpenFile(path, "rb");
    int maxlength = FileSize(path);

    int value;
    char[] replayData = new char[maxlength + 1];

    for (int i = 0; i < maxlength; i++)
    {
        if (binaryFile.ReadInt8(value))
        {
            replayData[i] = value;
        }
    }

    GlobalAPI_CreateReplayForRecordId(OnReplayCreated, _, 791453, replayData, maxlength);
}

public void OnReplay(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData)
{
    char replayPath[PLATFORM_MAX_PATH];
    hData.GetString("replayPath", replayPath, sizeof(replayPath));
    PrintToServer("Heres your path for the replay: %s", replayPath);
    PrintToServer("<GlobalAPI_GetReplayByReplayId> Status: %d", hData.status);
}

public void OnReplay2(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData)
{
    char replayPath[PLATFORM_MAX_PATH];
    hData.GetString("replayPath", replayPath, sizeof(replayPath));
    PrintToServer("Heres your path for the replay: %s", replayPath);
    PrintToServer("<GlobalAPI_GetReplayByRecordId> Status: %d", hData.status);
}

public void OnReplayCreated(bool bFailure, JSON_Object hResponse, GlobalAPIRequestData hData)
{
    PrintToServer("<GlobalAPI_CreateReplayForRecordId> Status: %d", hData.status);
}