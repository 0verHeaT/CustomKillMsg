Custom Kill Messages
====================
Better kill messages with picture of the gun and the distance in the upper left corner.

Format: [killer] ['image'] [victim] ['distance'm] 

#### Install instructions

1. Copy and replace the server_playerDied.sqf and the fnc_plyrHit.sqf in 'day_server/compile'.
2. Copy the kill_msg.sqf to your mission.pbo in your mod folder.
3. In your init.sqf search for:
```
if (!isDedicated) then {
```
  below add:
```
execVM ""+YOURFOLDER+"\kill_msg.sqf";
```

## Killboard Fix

If you want the killboard in the trader city to work correctly you have to use my version.
Paste the file in your mission pbo and add this line to your custom compiles

```
call compile preprocessFileLineNumbers ""+YOURPATH+"\player_murderMenu.sqf";
```

Done.
