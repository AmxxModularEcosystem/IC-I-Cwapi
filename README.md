# [VipM-I] Cwapi

Кастомное оружие из плагина [Custom Weapons API](https://github.com/AmxxModularEcosystem/CustomWeaponsAPI).

## Требования

- [VipModular](https://github.com/ArKaNeMaN/amxx-VipModular-pub) v5.0.0-b12 или новее
- [CustomWeaponsAPI](https://github.com/AmxxModularEcosystem/CustomWeaponsAPI) v1.0.0-b3 или новее
- [ParamsController](https://github.com/AmxxModularEcosystem/ParamsController) v1.0.0-b4 или новее

## Параметры

| Название      | Тип            | Обязательный? | Описание                                                                               |
| :------------ | :------------- | :------------ | :------------------------------------------------------------------------------------- |
| `Name`        | Строка         | Да            | Название оружия из CWAPI.                                                              |
| `GiveType`    | Строка         | Нет           | Тип выдачи оружия (см. [таблицу](#доступные-значения-givetype)). По умолчанию `Smart`. |
| `ForceActive` | `true`/`false` | Нет           | Выдавать ли оружие принудительно в руки. По умолчанию `false`                          |

### Доступные значения `GiveType`

| Значение  | Описание                                                                                  |
| :-------- | :---------------------------------------------------------------------------------------- |
| `Smart`   | Для ножей заменить, для гранат добавить, для остального выбросить текущее и выдать новое. |
| `Append`  | Добавить к текущему в соответствующем слоте.                                              |
| `Replace` | Заменить оружие из соответствующего слота на новое.                                       |
| `Drop`    | Выбросить текущее в соответствующем слоте и выдать новое.                                 |

## Пример

```jsonc
{
  "Type": "Cwapi",

  "Name": "Vip_Ak47",
  "GiveType": "Replace",
  "ForceActive": true
}
```
