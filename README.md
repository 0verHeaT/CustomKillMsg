Custom kill messages
====================
Better kill messages with picture of the gun and the distance in the upper left corner.

Format: [killer] ['image'] [victim] ['distance'm] 

Install instructions
====================
1. Copy and replace the server_playerDied.sqf and the fnc_plyrHit.sqf in 'day_server/compile'.
2. Copy the kill_msg.sqf to your mission.pbo in your mod folder.
3. In your init.sqf search for:
```
if (!isDedicated) then {
```
  below add:
```
execVM "YOURFOLDER\kill_msg.sqf";
```

Done.

0verHeaT 
