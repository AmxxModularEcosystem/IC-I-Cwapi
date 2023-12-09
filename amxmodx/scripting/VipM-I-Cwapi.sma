#include <amxmodx>
#include <json>
#include <VipModular>
#include <cwapi>
#include <ParamsController>

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM-I] CWAPI";
public stock const PluginVersion[] = "2.1.1";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "https://github.com/ArKaNeMaN/VipM-I-Cwapi";
public stock const PluginDescription[] = "[VipModular-Item] Custom Weapons API.";

new const TYPE_NAME[] = "Cwapi";

public VipM_IC_OnInitTypes() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);
    ParamsController_Init();

    VipM_IC_RegisterType(TYPE_NAME);
    VipM_IC_RegisterTypeEvent(TYPE_NAME, ItemType_OnRead, "@OnItemRead");
    VipM_IC_RegisterTypeEvent(TYPE_NAME, ItemType_OnGive, "@OnItemGive");
}

@OnItemRead(const JSON:jItem, Trie:tParams) {
    new sErrParamName[32], E_ParamsReadErrorType:iErrType = ParamsReadError_None;
    ParamsController_Param_ReadList(
        PrepareParams(), jItem, tParams,
        iErrType, sErrParamName, charsmax(sErrParamName)
    );

    if (iErrType != ParamsReadError_None) {
        VipM_Json_LogForFile(jItem, "WARNING", "Param '%s' is invalid or not specified.", sErrParamName);
        return VIPM_STOP;
    }

    return VIPM_CONTINUE;
}

@OnItemGive(const UserId, const Trie:tParams) {
    new ItemId = CWAPI_Weapons_Give(
        UserId,
        VipM_Params_GetCell(tParams, "Name"),
        VipM_Params_GetCell(tParams, "GiveType", CWAPI_GT_SMART)
    );

    if (ItemId < 0) {
        return VIPM_STOP;
    }

    return VIPM_CONTINUE;
}

Array:PrepareParams() {
    static Array:aParams = Invalid_Array;
    if (aParams != Invalid_Array) {
        return aParams;
    }

    aParams = ArrayCreate(1, 1);

    ArrayPushCell(aParams, ParamsController_Param_Construct("Name", CWAPI_WEAPON_PARAM_TYPE_NAME, true));
    ArrayPushCell(aParams, ParamsController_Param_Construct("GiveType", CWAPI_GIVE_TYPE_PARAM_TYPE_NAME, false));

    return aParams;
}
