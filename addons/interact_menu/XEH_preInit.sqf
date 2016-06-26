#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(ActNamespace) = [] call CBA_fnc_createNamespace;
GVAR(ActSelfNamespace) = [] call CBA_fnc_createNamespace;

// Event handlers for all interact menu controls
DFUNC(handleMouseMovement) = {
    if (GVAR(cursorKeepCentered)) then {
        GVAR(cursorPos) = GVAR(cursorPos) vectorAdd [_this select 1, _this select 2, 0] vectorDiff [0.5, 0.5, 0];
        setMousePosition [0.5, 0.5];
    } else {
        GVAR(cursorPos) = [_this select 1, _this select 2, 0];
    };
};
DFUNC(handleMouseButtonDown) = {
    if (GVAR(useDetachedCursorMenu)) then {
        if (GVAR(dettachedMenuBasePath) isEqualTo [] && GVAR(actionSelected)) then {
            GVAR(dettachedMenuBasePath) = +GVAR(lastPath); [(GVAR(lastPath) select 0 select 1), (GVAR(lastPath) select 0 select 0), []];
            GVAR(cursorPos) = [0.5, 0.5, 0];
            setMousePosition [0.50, 0.5];
            GVAR(menuDepthPath) = +GVAR(lastPath);
            GVAR(expanded) = true;
            GVAR(expandedTime) = diag_tickTime-1000;
            GVAR(startHoverTime) = -1000;
        } else {
            // Only terminate the menu if an action with an statement was clicked
            if (GVAR(actionSelected)) then {
                private _actionData = GVAR(selectedAction) select 0;
                player globalChat str (_actionData select 3);
                if !(_actionData select 3 isEqualTo {}) then {
                    if !(GVAR(actionOnKeyRelease)) then {
                        [GVAR(openedMenuType),true] call FUNC(keyUp);
                    };
                };
            };
        };
    } else {
        if !(GVAR(actionOnKeyRelease)) then {
            [GVAR(openedMenuType),true] call FUNC(keyUp);
        };
    };
};
GVAR(useDetachedCursorMenu) = false;
GVAR(dettachedMenuBasePath) = [];

GVAR(keyDown) = false;
GVAR(keyDownSelfAction) = false;
GVAR(keyDownTime) = 0;
GVAR(openedMenuType) = -1;

GVAR(lastTime) = diag_tickTime;
GVAR(rotationAngle) = 0;

GVAR(selectedAction) = [[],[]];
GVAR(actionSelected) = false;
GVAR(selectedTarget) = objNull;

GVAR(menuDepthPath) = [];
GVAR(lastPos) = [0,0,0];

GVAR(currentOptions) = [];

GVAR(lastPath) = [];

GVAR(expanded) = false;

GVAR(startHoverTime) = diag_tickTime;
GVAR(expandedTime) = diag_tickTime;

// reset on mission load
addMissionEventHandler ["Loaded", {
    GVAR(startHoverTime) = 0;
    GVAR(expandedTime) = 0;
}];

GVAR(iconCtrls) = [];
GVAR(iconCount) = 0;

GVAR(collectedActionPoints) = [];
GVAR(foundActions) = [];
GVAR(lastTimeSearchedActions) = -1000;

// Init zeus menu
[] call FUNC(compileMenuZeus);

ADDON = true;
