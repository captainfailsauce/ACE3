/*
 * Author: Ruthberg
 * Handle incapacitation due to wounds
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * ReturnValue:
 * nothing
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _bodyDamage = 0;

{
    _x params ["", "", "_bodyPart", "", "", "", "_damage"];
    if (_bodyPart < 2 && {_damage > PENETRATION_THRESHOLD}) then {
        _bodyDamage = _bodyDamage + _damage;
    };
} forEach (_unit getVariable [QGVAR(openWounds), []]);

if (_bodyDamage > 3 * PENETRATION_THRESHOLD) then {
    [_unit, true] call FUNC(setUnconscious);
    //[QGVAR(CriticalVitals), _unit] call CBA_fnc_localEvent;
};
