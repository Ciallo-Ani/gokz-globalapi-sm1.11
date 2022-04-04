// ====================== DEFINITIONS ======================== //

#define DATA_PATH "data/GlobalAPI-Retrying"
#define DATA_FILE "retrying_{timestamp}_{gametick}.dat"

#define MAGIC_BYTES 0x676c6f62616c617069
#define FORMAT_VERSION 2

// =========================================================== //

#include <GlobalAPI>
#include <GlobalAPI/stocks>

// ====================== FORMATTING ========================= //

#pragma dynamic 131072
#pragma newdecls required

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo =
{
    name = "GlobalAPI-Retrying-Binary",
    author = "The KZ Global Team",
    description = "Retrying for GlobalAPI in binary format",
    version = GlobalAPI_Plugin_Version,
    url = GlobalAPI_Plugin_Url
};

// =========================================================== //

public void OnPluginStart()
{
    char rootDirPath[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, rootDirPath, sizeof(rootDirPath), "%s", DATA_PATH);

    if (!TryCreateDirectory(rootDirPath))
    {
        SetFailState("Failed to create directory %s", rootDirPath);
    }

    char filesDirPath[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, filesDirPath, sizeof(filesDirPath), "%s/files", DATA_PATH);

    if (!TryCreateDirectory(filesDirPath))
    {
        SetFailState("Failed to create directory %s", filesDirPath);
    }

    CreateTimer(30.0, CheckForRequests, _, TIMER_REPEAT);
}

// ======================= MAIN CODE ========================= //

public void GlobalAPI_OnRequestFailed(Handle request, GlobalAPIRequestData hData)
{
    if (hData.RequestType == GlobalAPIRequestType_POST)
    {
        SaveRequestAsBinary(hData);
    }
}

public void SaveRequestAsBinary(GlobalAPIRequestData hData)
{
    char szTimestamp[32];
    IntToString(GetTime(), szTimestamp, sizeof(szTimestamp));

    char szGameTime[32];
    FloatToString(GetEngineTime(), szGameTime, sizeof(szGameTime));

    char dataFile[PLATFORM_MAX_PATH] = DATA_FILE;
    ReplaceString(dataFile, sizeof(dataFile), "{gametick}", szGameTime);
    ReplaceString(dataFile, sizeof(dataFile), "{timestamp}", szTimestamp);

    char path[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, path, sizeof(path), "%s/%s", DATA_PATH, dataFile);

    File binaryFile = OpenFile(path, "a+");
    if (binaryFile == null)
    {
        LogError("Could not open or create binary file %s", path);
        return;
    }

    char bodyFilePath[PLATFORM_MAX_PATH];

    // Assume binary files have been set as files
    if (hData.ContentType == GlobalAPIRequestContentType_OctetStream)
    {
        char srcFilePath[PLATFORM_MAX_PATH];
        hData.GetBodyFile(srcFilePath, sizeof(srcFilePath));

        BuildPath(Path_SM, bodyFilePath, sizeof(bodyFilePath), "%s/files/%s", DATA_PATH, dataFile);

        File srcFile = OpenFile(srcFilePath, "rb");
        File destFile = OpenFile(bodyFilePath, "wb");

        if (srcFile == null || destFile == null)
        {
            delete srcFile;
            delete destFile;
            delete binaryFile;
            return;
        }

        int buffer[4096];

        while (!srcFile.EndOfFile())
        {
            int readCount = srcFile.Read(buffer, sizeof(buffer), 1);
            destFile.Write(buffer, readCount, 1);
        }

        delete srcFile;
        delete destFile;
    }

    char url[GlobalAPI_Max_BaseUrl_Length];
    hData.GetString("url", url, sizeof(url));

    char params[8192];
    hData.Encode(params, sizeof(params));

    binaryFile.WriteInt32(MAGIC_BYTES);
    binaryFile.WriteInt8(FORMAT_VERSION);
    binaryFile.WriteInt16(strlen(url));
    binaryFile.WriteString(url, false);
    binaryFile.WriteInt32(strlen(params));
    binaryFile.WriteString(params, false);
    binaryFile.WriteInt8(hData.KeyRequired);
    binaryFile.WriteInt8(hData.RequestType);
    binaryFile.WriteInt32(hData.BodyLength);
    binaryFile.WriteInt32(StringToInt(szTimestamp));
    binaryFile.WriteInt16(strlen(bodyFilePath));
    binaryFile.WriteString(bodyFilePath, false);

    delete binaryFile;
}

public Action CheckForRequests(Handle timer)
{
    char path[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, path, sizeof(path), DATA_PATH);

    DirectoryListing dataFiles = OpenDirectory(path);
    if (dataFiles == null)
    {
        LogError("Could not open directory %s", path);
        return;
    }

    char dataFile[PLATFORM_MAX_PATH];
    FileType fileType = FileType_Unknown;

    bool gotFile = false;

    while (dataFiles.GetNext(dataFile, sizeof(dataFile), fileType))
    {
        if (fileType == FileType_File)
        {
            Format(dataFile, sizeof(dataFile), "%s/%s", path, dataFile);
            gotFile = true;
            break;
        }
    }

    delete dataFiles;

    if (!gotFile)
    {
        return;
    }

    GlobalAPIRequestData requestData = Deserialize(dataFile);
    if (requestData == null)
    {
        return;
    }

    DeleteFile(dataFile);
    GlobalAPI_SendRequest(requestData);

    // Delete body file if it exists after sending the request
    char bodyFilePath[PLATFORM_MAX_PATH];
    requestData.GetBodyFile(bodyFilePath, sizeof(bodyFilePath));

    if (bodyFilePath[0] != '\0' && FileExists(bodyFilePath))
    {
        DeleteFile(bodyFilePath);
    }
}

public GlobalAPIRequestData Deserialize(char filePath[PLATFORM_MAX_PATH])
{
    File file = OpenFile(filePath, "r");
    if (file == null)
    {
        LogError("Could not open binary file %s", filePath);
        return null;
    }

    int magicBytes;
    file.ReadInt32(magicBytes);

    if (magicBytes != MAGIC_BYTES)
    {
        // Not a retrying file?
        return null;
    }

    int formatVersion;
    file.ReadInt8(formatVersion);

    if (formatVersion != FORMAT_VERSION)
    {
        // Unsupported format version
        return null;
    }

    GlobalAPIRequestData hData = new GlobalAPIRequestData(GetMyHandle());

    int length;

    file.ReadInt16(length);
    char[] url = new char[length + 1];
    file.ReadString(url, length, length);
    url[length] = '\0';

    file.ReadInt32(length);
    char[] params = new char[length + 1];
    file.ReadString(params, length, length);
    params[length] = '\0';

    bool keyRequired;
    file.ReadInt8(keyRequired);

    int requestType;
    file.ReadInt8(requestType);

    int bodyLength;
    file.ReadInt32(bodyLength);

    int timestamp;
    file.ReadInt32(timestamp);

    file.ReadInt16(length);
    char[] bodyFilePath = new char[length + 1];
    file.ReadString(bodyFilePath, length, length);
    bodyFilePath[length] = '\0';

    hData.AddUrl(url);
    hData.Merge(json_decode(params));

    JSON_Object hParams = json_decode(params);
    hData.Merge(hParams);

    // These are set to null until
    // We have a reliable way of retrieving
    // The handles from the original plugin
    hData.Data = INVALID_HANDLE;
    hData.Callback = INVALID_HANDLE;

    hData.IsRetried = true;
    hData.BodyLength = bodyLength;
    hData.KeyRequired = keyRequired;
    hData.RequestType = requestType;

    if (strlen(bodyFilePath) > 0)
    {
        hData.AddBodyFile(bodyFilePath);
    }

    json_cleanup_and_delete(hParams);

    delete file;
    return hData;
}
