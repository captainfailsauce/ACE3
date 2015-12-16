/*
 * Author: Grey
 * Loads Magazine into static weapon
 *
 * Arguments:
 * 0: static <OBJECT>
 * 1: unit <OBJECT>
 * 2: magazineClassOptional <OPTIONAL><STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_target,_player,'16aa_static_magazine_l16_illum'] call lsr_staticweapons_loadMagazine
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_unit","_static",["_magazineClassOptional","",[""]]];
private ["_weapon","_currentMagazine","_count","_magazines","_magazineDetails","_listOfMagNames",
    "_magazineClass","_magazineClassDetails","_parsed","_roundsLeft","_configMortar"];

//Get weapon & magazine information of static weapon
_weapon = (_static weaponsTurret [0]) select 0;
_currentMagazine = (magazinesAllTurrets _static) select 1;
_currentMagazineClass = _currentMagazine select 0;
_count = _currentMagazine select 2;

//Check all of the players magazines to see if they are compatible with the static weapon. First magazine that is compatible is chosen
_magazines = magazines _unit;
_magazineDetails = magazinesDetail _unit;
_listOfMagNames = getArray(configFile >> "cfgWeapons" >> _weapon >> "magazines");
_magazineClass = "";
_magazineClassDetails = "";
_parsed  ="";
_roundsLeft = 0;
{
    if (_x in _listOfMagNames) exitWith {
        _magazineClass = _magazines select _forEachIndex;
        _magazineClassDetails = _magazineDetails select _forEachIndex;
    };
} forEach _magazines;
//If the static weapon already has an empty magazine then remove it
if (_count == 0) then {
    [QGVAR(removeMagazine), [_static, _currentMagazineClass]] call EFUNC(common,globalEvent);
};
//Find out the ammo count of the compatible magazine found
if (_magazineClassDetails != "") then{
    _parsed = _magazineClassDetails splitString "([]/: )";
    _parsed params ["_type", "", "", "_roundsLeftText", "_maxRoundsText"];
    _roundsLeft = parseNumber _roundsLeftText;
    _roundsMax = parseNumber _maxRoundsText;
    _magType = _type;
};

//_configMortar = getNumber (configFile >> "CfgMagazines" >> _magazineClass >> QGVAR(isMortarRound));
//If function has been called with an optional classname hten add that magazine to the static weapon. Otherwise add the compatible magazine
if(_magazineClassOptional !="") then{
        _unit removeMagazine _magazineClassOptional;
        [QGVAR(addMagazine), [_static, _magazineClassOptional]] call EFUNC(common,globalEvent);
    }else{
        _unit removeMagazine _magazineClass;
        [QGVAR(addMagazine), [_static, _magazineClass]] call EFUNC(common,globalEvent);
        [QGVAR(setAmmo), _static, [_static, _magazineClass,_roundsLeft]] call EFUNC(common,targetEvent);
    };
