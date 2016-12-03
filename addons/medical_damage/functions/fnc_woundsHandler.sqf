/*
 * Author: Glowbal, commy2
 * Handling of the open wounds & injuries upon the handleDamage eventhandler.
 *
 * Arguments:
 * 0: Unit That Was Hit <OBJECT>
 * 1: Name Of Body Part <STRING>
 * 2: Amount Of Damage <NUMBER>
 * 3: Shooter or source of the damage <OBJECT>
 * 4: Type of the damage done <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit", "_bodyPart", "_damage", "_typeOfProjectile", "_typeOfDamage"];
TRACE_5("start",_unit,_bodyPart,_damage,_typeOfProjectile,_typeOfDamage);

if (_typeOfDamage isEqualTo "") then {
    _typeOfDamage = "unknown";
};

// Administration for open wounds and ids
private _openWounds = _unit getVariable [QEGVAR(medical,openWounds), []];
private _woundID = _unit getVariable [QEGVAR(medical,lastUniqueWoundID), 1];

private _extensionOutput = "ace_medical" callExtension format ["HandleDamageWounds,%1,%2,%3,%4", _bodyPart, _damage, _typeOfDamage, _woundID];
TRACE_1("",_extensionOutput);

// these are default values and modified by _extensionOutput
private _painToAdd = 0;
private _woundsCreated = [];

call compile _extensionOutput;

{
    _x params ["", "_woundClassIDToAdd", "_bodyPartNToAdd", "", "_bleeding"];
    
    // How much bleeding do we have?
    private _bloodiness = random (_damage ^ 2);
    _bloodiness = (0.1 * _damage) + (0.9 * _damage) * (1 - (0.995 ^ _bloodiness));
    
    _x set [4, _bleeding * _bloodiness];
    
    // How much pain do we have?
    private _painfullness = random (_damage ^ 2);
    _painfullness = (0.1 * _damage) + (0.9 * _damage) * (1 - (0.995 ^ _painfullness));
    
    private _pain = ((GVAR(woundsData) select _woundClassIDToAdd) select 3) * _painfullness;
    _x pushBack _pain;
    _painToAdd = _painToAdd + _pain;
    
    _x pushBack _damage;
    
    systemChat format["%1, damage: %2, peneration: %3, bleeding: %4, pain: %5", _bodyPart, _damage, _damage > PENETRATION_THRESHOLD, _x select 4, _x select 5];
    
    if (_bodyPartNToAdd == 0 && {_damage > 1}) then {
        [QEGVAR(medical,InjuryFatal), _unit] call CBA_fnc_localEvent;
    };
    
    private _causeLimping = (GVAR(woundsData) select _woundClassIDToAdd) select 7;
    if (_causeLimping == 1 && {_damage > 0.3} && {_bodyPartNToAdd > 3}) then {
        [_unit, true] call EFUNC(medical_engine,setLimping);
    };
    
    // @todo merge into existing wounds in an intelligent manner
    _openWounds pushBack _x;
} forEach _woundsCreated;

_unit setVariable [QEGVAR(medical,openWounds), _openWounds, true];

[_unit, _bodyPart] call EFUNC(medical_engine,updateBodyPartVisuals);

// Only update if new wounds have been created
if (count _woundsCreated > 0) then {
    _unit setVariable [QEGVAR(medical,lastUniqueWoundID), _woundID, true];
};

[_unit, _painToAdd] call EFUNC(medical,addPain);
[_unit, "hit", PAIN_TO_SCREAM(_painToAdd)] call EFUNC(medical_engine,playInjuredSound);

TRACE_5("exit",_unit, _painToAdd, _unit getVariable QEGVAR(medical,pain), _unit getVariable QEGVAR(medical,openWounds),_woundsCreated);
