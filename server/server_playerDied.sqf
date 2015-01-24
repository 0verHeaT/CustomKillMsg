private ["_characterID","_minutes","_newObject","_playerID","_infected","_victim","_victimName","_killer","_killerName","_weapon","_distance","_message","_loc_message","_key","_death_record","_pic","_kill_txt"];
//[unit, weapon, muzzle, mode, ammo, magazine, projectile]
_characterID = 	_this select 0;
_minutes =		_this select 1;
_newObject = 	_this select 2;
_playerID = 	_this select 3;
_infected =		_this select 4;
if (((count _this) >= 6) && {(typeName (_this select 5)) == "STRING"} && {(_this select 5) != ""}) then {
	_victimName =	_this select 5;
} else {
	_victimName =  if (alive _newObject) then {name _newObject;} else {"";};
};
_victim = _newObject;
_newObject setVariable ["bodyName", _victimName, true];

_killer = _victim getVariable["AttackedBy", "nil"];
_killerName = _victim getVariable["AttackedByName", "nil"];

if ((typeName _killer) != "STRING") then {
	_weapon = _victim getVariable["AttackedByWeapon", "nil"];
	_distance = _victim getVariable["AttackedFromDistance", "nil"];
	_pic = _victim getVariable["AttackedByWeaponImg", "nil"];
	if ((owner _victim) == (owner _killer)) then {
		_loc_message = format["PLAYERSUICIDE: %1 killed himself", _victimName];
		_message = format ["%1 killed himself",_victimName];
	} else {
		_loc_message = format["PLAYERKILL: %1 was killed by %2 with weapon %3 from %4m", _victimName, _killerName, _weapon, _distance];
		_message = format ["%1 was killed by %2 with weapon %3 from %4m", _victimName, _killerName, _weapon, _distance];
	
		if ((gettext (configFile >> 'cfgWeapons' >> (currentWeapon _killer) >> 'displayName')) != "Throw") then {
			if (_pic != "nil") then {
				_kill_txt = format ["<t align='left' size='0.9'>%1 </t>",_killerName];
				_kill_txt = _kill_txt + format ["<img size='1.0' align='left' image='%1'/>",_pic];
				_kill_txt = _kill_txt + format ["<t align='left' size='0.9'> %1 </t>",_victimName];
				_kill_txt = _kill_txt + format ["<t align='left' size='0.9'>[%1m]</t>",(ceil _distance)];
				
				customkillMessage = [_kill_txt];
				publicVariable "customkillMessage";
			};
		};
	};

	diag_log _loc_message;
	
	if(DZE_DeathMsgGlobal) then {
		[nil, nil, rspawn, [_killer, _message], { (_this select 0) globalChat (_this select 1) }] call RE;
	};
	/* needs customRemoteMessage
	if(DZE_DeathMsgGlobal) then {
		customRemoteMessage = ['globalChat', _message, _killer];
		publicVariable "customRemoteMessage";
	};
	*/
	if(DZE_DeathMsgSide) then {
		[nil, nil, rspawn, [_killer, _message], { (_this select 0) sideChat (_this select 1) }] call RE;
	};
	if(DZE_DeathMsgTitleText) then {
		[nil,nil,"per",rTITLETEXT,_message,"PLAIN DOWN"] call RE;
	};
	
	//Use my killboard in order to work correctly
	_death_record = [
		_victimName,
		_killerName,
		_weapon,
		_pic,
		_distance,
		ServerCurrentTime
	];
	PlayerDeaths set [count PlayerDeaths,_death_record];
	PV_DeathBoard = PlayerDeaths;
	publicVariable "PV_DeathBoard";
	
	_victim setVariable["AttackedBy","nil", true];
	_victim setVariable["AttackedByName","nil", true];
	_victim setVariable["AttackedByWeapon","nil", true];
	_victim setVariable["AttackedFromDistance","nil", true];
	_victim setVariable["AttackedByWeaponImg","nil", true];
};

_newObject setVariable["processedDeath",diag_tickTime];

if (typeName _minutes == "STRING") then {
	_minutes = parseNumber _minutes;
};

diag_log ("PLAYERDEATH: Player Died " + _playerID);

if (_characterID != "0") then {
	_key = format["CHILD:202:%1:%2:%3:",_characterID,_minutes,_infected];
	#ifdef DZE_SERVER_DEBUG_HIVE
	diag_log ("HIVE: WRITE: "+ str(_key));
	#endif
	_key call server_hiveWrite;
} else {
	deleteVehicle _newObject;
};
