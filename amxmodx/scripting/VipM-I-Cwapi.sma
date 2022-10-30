#include <amxmodx>
#include <json>
#include <VipModular>
#include <cwapi>

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM-I] CWAPI";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "https://github.com/ArKaNeMaN/VipM-I-Cwapi";
public stock const PluginDescription[] = "[VipModular][Item] Custom Weapons API.";

new const TYPE_NAME[] = "Cwapi";

public VipM_IC_OnInitTypes() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);

    VipM_IC_RegisterType(TYPE_NAME);
    VipM_IC_RegisterTypeEvent(TYPE_NAME, ItemType_OnRead, "@OnItemRead");
    VipM_IC_RegisterTypeEvent(TYPE_NAME, ItemType_OnGive, "@OnItemGive");
}

@OnItemRead(const JSON:jItem, const Trie:tParams) {
    if (!TrieKeyExists(tParams, "Name")) {
        VipM_Json_LogForFile(jItem, "WARNING", "Weapon name not found.");
        return VIPM_STOP;
    }

    TrieSetCell(tParams, "GiveType", _:Json_Object_GetGiveType(jItem, "GiveType"));

    return VIPM_CONTINUE;
}

@OnItemGive(const UserId, const Trie:tParams) {
    static Name[32];
    VipM_Params_GetStr(tParams, "Name", Name, charsmax(Name));
    if (CWAPI_GetWeaponId(Name) < 0) {
        log_amx("[WARNING] Weapon `%s` not found.", Name);
        return VIPM_STOP;
    }
    
    new ItemId = CWAPI_GiveWeapon(UserId, Name, CWAPI_GiveType:VipM_Params_GetInt(tParams, "GiveType", _:CWAPI_GT_SMART));
    if (ItemId < 0) {
        return VIPM_STOP;
    }

    return VIPM_CONTINUE;
}

CWAPI_GiveType:Json_Object_GetGiveType(const JSON:Obj, const Key[], const bool:DotNot = false) {
    new Str[32];
    json_object_get_string(Obj, Key, Str, charsmax(Str), DotNot);
    return StrToGiveType(Str);
}

CWAPI_GiveType:StrToGiveType(const Str[]) {
    if (equali(Str, "Smart") || equali(Str, "CWAPI_GT_SMART")) {
        return CWAPI_GT_SMART;
    } else if (equali(Str, "Append") || equali(Str, "Add") || equali(Str, "CWAPI_GT_APPEND") || equali(Str, "GT_APPEND")) {
        return CWAPI_GT_APPEND;
    } else if (equali(Str, "Replace") || equali(Str, "CWAPI_GT_REPLACE") || equali(Str, "GT_REPLACE")) {
        return CWAPI_GT_REPLACE;
    } else if(equali(Str, "Drop") || equali(Str, "CWAPI_GT_DROP") || equali(Str, "GT_DROP_AND_REPLACE")) {
        return CWAPI_GT_DROP;
    } else {
        return CWAPI_GT_SMART;
    }
}
