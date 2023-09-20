#include <amxmodx>
#include <json>
#include <VipModular>
#include <cwapi>

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM-I] CWAPI";
public stock const PluginVersion[] = "2.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "https://github.com/ArKaNeMaN/VipM-I-Cwapi";
public stock const PluginDescription[] = "[VipModular-Item] Custom Weapons API.";

new const TYPE_NAME[] = "Cwapi";

public VipM_IC_OnInitTypes() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);

    VipM_IC_RegisterType(TYPE_NAME);
    VipM_IC_RegisterTypeEvent(TYPE_NAME, ItemType_OnRead, "@OnItemRead");
    VipM_IC_RegisterTypeEvent(TYPE_NAME, ItemType_OnGive, "@OnItemGive");
}

@OnItemRead(const JSON:jItem, const Trie:tParams) {
    new sWeaponName[CWAPI_WEAPON_NAME_MAX_LEN];
    json_object_get_string(jItem, "Name", sWeaponName, charsmax(sWeaponName));

    new T_CustomWeapon:iWeapon = CWAPI_Weapons_Find(sWeaponName);
    if (iWeapon == Invalid_CustomWeapon) {
        log_amx("[WARNING] Custom weapon '%s' not found.", sWeaponName);
        return VIPM_STOP;
    }

    TrieSetCell(tParams, "WeaponId", iWeapon);
    TrieSetCell(tParams, "GiveType", Json_Object_GetGiveType(jItem, "GiveType"));

    return VIPM_CONTINUE;
}

@OnItemGive(const UserId, const Trie:tParams) {
    new ItemId = CWAPI_Weapons_Give(
        UserId,
        VipM_Params_GetCell(tParams, "WeaponId", CWAPI_GT_SMART),
        VipM_Params_GetCell(tParams, "GiveType", CWAPI_GT_SMART)
    );

    if (ItemId < 0) {
        return VIPM_STOP;
    }

    return VIPM_CONTINUE;
}

CWeapon_GiveType:Json_Object_GetGiveType(const JSON:jObj, const sKey[], const bool:bDotNot = false) {
    new sType[32];
    json_object_get_string(jObj, sKey, sType, charsmax(sType), bDotNot);
    return StrToGiveType(sType);
}

CWeapon_GiveType:StrToGiveType(const sType[]) {
    static Trie:tTypesMap = Invalid_Trie;
    if (tTypesMap == Invalid_Trie) {
        tTypesMap = TrieCreate();
        TrieSetCell(tTypesMap, "Smart", CWAPI_GT_SMART);
        TrieSetCell(tTypesMap, "CWAPI_GT_SMART", CWAPI_GT_SMART);

        TrieSetCell(tTypesMap, "Append", CWAPI_GT_APPEND);
        TrieSetCell(tTypesMap, "Add", CWAPI_GT_APPEND);
        TrieSetCell(tTypesMap, "CWAPI_GT_APPEND", CWAPI_GT_APPEND);
        TrieSetCell(tTypesMap, "GT_APPEND", CWAPI_GT_APPEND);

        TrieSetCell(tTypesMap, "Replace", CWAPI_GT_REPLACE);
        TrieSetCell(tTypesMap, "CWAPI_GT_REPLACE", CWAPI_GT_REPLACE);
        TrieSetCell(tTypesMap, "GT_REPLACE", CWAPI_GT_REPLACE);

        TrieSetCell(tTypesMap, "Drop", CWAPI_GT_DROP);
        TrieSetCell(tTypesMap, "CWAPI_GT_DROP", CWAPI_GT_DROP);
        TrieSetCell(tTypesMap, "GT_DROP_AND_REPLACE", CWAPI_GT_DROP);
    }

    new CWeapon_GiveType:iType = CWAPI_GT_SMART;
    TrieGetCell(tTypesMap, sType, iType);

    return iType;
}
