-- fixes from Other sources, thanks goes to all autors ^_^

/* Quest/Barrens Horde - Counterattack! */
SET @Counterattack = 4021;

-- Vars
SET @Gossip = 23615;
-- NPCs
SET @Deathgate = 3389; -- Regthar Deathgate (quest giver)
SET @Kromzar = 9456; -- Warlord Krom'zar (abilities: 11976 Strike)
SET @Stormseer = 9523; -- Kolkar Stormseer (abilities: 9532 Lighting Bolt; 6535 Lightning Cloud)
SET @Invader = 9524; -- Kolkar Invader (abilities: 8014 Tetatuns, 11976 Strike, 6268 Rushing Charge)
SET @Thrower = 9458; -- Horde Axe Thrower
SET @Defender = 9457; -- Horde Defender (abilities: 10277 Throw)
-- Spells
SET @CreateBanner = 13965; -- Create Krom'zar's Banner

DELETE FROM `gossip_menu` WHERE `entry` IN (@Gossip,@Gossip+1);
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(@Gossip+0,2533),
(@Gossip+1,2534);

DELETE FROM `gossip_menu_option` WHERE `menu_id`=@Gossip AND `id`=0;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`action_script_id`,`box_coded`,`box_money`,`box_text`) VALUES
(@Gossip,0,0, 'Where is Warlord Krom''zar?',1,1,@Gossip+1,0,0,0,0,NULL);

DELETE FROM `creature_text` WHERE `entry` IN (@Deathgate,@Invader,@Thrower,@Kromzar);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@Deathgate,0,0,'Beware, $N! Look to the west!',0,0,100,1,0,0,'Regthar Deathgate: quest start'),
(@Deathgate,1,0,'A defender has fallen!',0,0,100,1,0,0,'Regthar Deathgate: Horde Defender death'),
(@Invader,0,0,'Kolkar Invader charges!',2,0,100,0,0,0,'Kolkar Invader: aggro'),
(@Thrower,0,0,'Defend the bunkers!',0,0,100,0,0,0,'Kolkar Axe Thrower'),
(@Thrower,0,1,'Our foes will fail!',0,0,100,0,0,0,'Kolkar Axe Thrower'),
(@Thrower,0,2,'For the Horde',0,0,100,0,0,0,'Kolkar Axe Thrower'),
(@Kromzar,0,0,'The Kolkar are the strongest!',1,0,100,0,0,0,'Warlord Krom''zar: spawn');

UPDATE `creature_template` SET `AIName`='SmartAI', `MovementType`=1 WHERE `entry` IN (@Kromzar,@Invader,@Stormseer,@Thrower,@Defender);
UPDATE `creature_template` SET `AIName`='SmartAI', `gossip_menu_id`=@Gossip WHERE `entry`=@Deathgate;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=@Gossip;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`Comment`) VALUES
(15,@Gossip,0,0,9,@Counterattack,0,0,0, 'Regthar Deathgate: Counterattack!: gossip: has quest'),
(15,@Gossip,0,0,26,11227,0,0,0, 'Regthar Deathgate: Counterattack!: gossip: does not have item Piece Banner');

DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Kromzar AND `source_type`=0);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Deathgate AND `source_type`=0);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Invader AND `source_type`=0);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Stormseer AND `source_type`=0);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Thrower AND `source_type`=0);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Deathgate*100 AND `source_type`=9);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@Defender AND `source_type`=0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Kromzar,0,0,0,0,0,100,0,0,1000,4000,6000,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,'Warlord Krom''Zar: In combat cast Strike every 4 to 6 seconds'),
(@Kromzar,0,1,0,6,0,100,1,0,1000,5000,8000,11,@CreateBanner,2,0,0,0,0,0,0,0,0,0,0,0,0,'Warlord Krom''Zar: On death cast Create Krom''zar''s Banner'),
(@Kromzar,0,4,0,11,0,100,0,0,0,0,0,89,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Krom''Zar: On spawn set random movement'),
(@Kromzar,0,5,0,11,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Krom''Zar: On spawn say text 0'),
(@Invader,0,0,0,4,0,100,0,0,0,0,0,11,6268,0,0,0,0,0,2,0,0,0,0,0,0,0,'Kolkar Invader: On aggro cast Rushing Charge'),
(@Invader,0,1,0,4,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Kolkar Invader: On aggro say text 0'),
(@Invader,0,2,0,0,0,100,0,0,1000,4000,6000,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,'Kolkar Invader: In combat cast Strike every 4 to 6 seconds'),
(@Invader,0,3,0,0,0,100,0,1000,2000,20000,20000,11,8014,0,0,0,0,0,2,0,0,0,0,0,0,0,'Kolkar Invader: In combat cast Tetanus every 20 seconds'),
(@Invader,0,4,0,11,0,100,0,0,0,0,0,89,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Kolkar Invader: On spawn set random movement'),
(@Stormseer,0,0,0,11,0,100,0,0,0,0,0,58,1,9532,3500,6000,30,15,1,0,0,0,0,0,0,0,'Kolkar Stormseer: On respawn install AI template caster for Lighting Bolt'),
(@Stormseer,0,1,0,0,0,100,0,3000,4000,10000,10000,11,6535,1,0,0,0,0,2,0,0,0,0,0,0,0,'Kolkar Stormseer: In combat cast Lightning Cloud every 10 seconds'),
(@Stormseer,0,2,0,11,0,100,0,0,0,0,0,89,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Kolkar Stormseer: On spawn set random movement'),
(@Thrower,0,0,0,11,0,100,0,0,0,0,0,58,2,10277,35,0,0,0,1,0,0,0,0,0,0,0,'Horde Axe Thrower: On respawn install AI template turret for Throw'),
(@Thrower,0,1,0,6,0,100,0,0,0,0,0,12,@Thrower,1,450000,0,0,0,8,0,0,0,-293.212,-1912.51,91.6673,1.42794,'Horde Axe Thrower: On death summon Horde Axe Thrower'),
(@Thrower,0,2,0,11,0,100,0,0,0,0,0,89,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Horde Axe Thower: On spawn set random movement'),
(@Thrower,0,3,0,60,0,100,0,20000,25000,30000,40000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Horde Axe Thower: Say text 0 every 30 to 40 seconds'),
(@Defender,0,0,0,6,0,100,0,0,0,0,0,1,1,0,0,0,0,0,9,@Deathgate,0,300,0,0,0,0,'Horde Axe Thrower: On death Regthar Deathgate say text 1'),
(@Defender,0,1,0,6,0,100,0,0,0,0,0,12,@Defender,1,450000,0,0,0,8,0,0,0,-280.703,-1908.01,91.6668,1.77351,'Horde Defender: On death summon Horde Defender'),
(@Defender,0,2,0,11,0,100,0,0,0,0,0,89,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Horde Defender: On spawn set random movement'),
(@Deathgate,0,0,0,11,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Regthar Deathgate: On respawn set phase 1 (p0)'),
(@Deathgate,0,1,0,19,1,100,0,@Counterattack,0,0,0,1,0,0,0,0,0,0,18,15,0,0,0,0,0,0,'Regthar Deathgate: On quest accept say text 0 (p1)'),
(@Deathgate,0,2,0,19,1,100,0,@Counterattack,0,0,0,22,2,0,0,0,0,0,0,0,0,0,0,0,0,0,'Regthar Deathgate: On quest accept set event phase 2 (p1)'),
(@Deathgate,0,3,0,19,2,100,0,@Counterattack,0,0,0,80,@Deathgate*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Regthar Deathgate: On quest accept call main script (p2)'),
(@Deathgate,0,4,0,62,1,100,0,@Gossip,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Regthar Deathgate: On gossip select say text 0 (p1)'),
(@Deathgate,0,5,0,62,4,100,0,@Gossip,0,0,0,80,@Deathgate*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Regthar Deathgate: On gossip select call main script (p4)'),
(@Deathgate*100,9,0,0,0,0,100,0,0,0,0,0,12,@Defender,1,450000,0,0,0,8,0,0,0,-280.703,-1908.01,91.6668,1.77351,'Counterattack!: Summon Horde Axe Thrower 1'),
(@Deathgate*100,9,1,0,0,0,100,0,0,0,0,0,12,@Defender,1,450000,0,0,0,8,0,0,0,-286.384,-1910.99,91.6668,1.59444,'Counterattack!: Summon Horde Defender 2'),
(@Deathgate*100,9,2,0,0,0,100,0,0,0,0,0,12,@Defender,1,450000,0,0,0,8,0,0,0,-297.373,-1917.11,91.6746,1.81435,'Counterattack!: Summon Horde Defender 3'),
(@Deathgate*100,9,3,0,0,0,100,0,0,0,0,0,12,@Thrower,1,450000,0,0,0,8,0,0,0,-293.212,-1912.51,91.6673,1.42794,'Counterattack!: Summon Horde Axe Thrower 1'),
(@Deathgate*100,9,4,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-280.037,-1888.35,92.2549,2.28087,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,5,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-292.107,-1899.54,91.667,4.78158,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,6,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-305.57,-1869.88,92.7754,2.45131,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,7,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-289.972,-1882.76,92.5714,3.43148,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,8,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-277.454,-1873.39,92.7773,4.75724,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,9,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-271.581,-1847.51,93.4329,4.39124,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,10,0,0,0,100,0,0,0,0,0,12,@Invader,1,450000,0,0,0,8,0,0,0,-269.982,-1828.6,92.4754,4.68655,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,11,0,0,0,100,0,0,0,0,0,12,@Stormseer,1,450000,0,0,0,8,0,0,0,-279.267,-1827.92,92.3128,1.35332,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,12,0,0,0,100,0,0,0,0,0,12,@Stormseer,1,450000,0,0,0,8,0,0,0,-297.42,-1847.41,93.2295,5.80967,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,13,0,0,0,100,0,0,0,0,0,12,@Stormseer,1,450000,0,0,0,8,0,0,0,-310.607,-1831.89,95.9363,0.371571,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,14,0,0,0,100,0,0,0,0,0,12,@Stormseer,1,450000,0,0,0,8,0,0,0,-329.177,-1842.43,95.3891,0.516085,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,15,0,0,0,100,0,0,0,0,0,12,@Stormseer,1,450000,0,0,0,8,0,0,0,-324.448,-1860.63,94.3221,4.97793,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,16,0,0,0,100,0,20000,30000,0,0,12,@Invader,1,250000,0,0,0,8,0,0,0,-290.588,-1858,92.5026,4.14698,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,17,0,0,0,100,0,20000,30000,0,0,12,@Stormseer,1,250000,0,0,0,8,0,0,0,-286.103,-1846.18,92.544,6.11047,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,18,0,0,0,100,0,20000,30000,0,0,12,@Invader,1,250000,0,0,0,8,0,0,0,-304.978,-1844.7,94.4432,1.61721,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,19,0,0,0,100,0,20000,30000,0,0,12,@Stormseer,1,250000,0,0,0,8,0,0,0,-308.105,-1859.08,93.8039,2.80709,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,20,0,0,0,100,0,20000,30000,0,0,12,@Invader,1,250000,0,0,0,8,0,0,0,-297.089,-1867.68,92.5601,2.21804,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,21,0,0,0,100,0,20000,30000,0,0,12,@Stormseer,1,250000,0,0,0,8,0,0,0,-286.988,-1876.47,92.7447,1.39494,'Counterattack!: Summon Kolkar Stormseer'),
(@Deathgate*100,9,22,0,0,0,100,0,20000,30000,0,0,12,@Invader,1,250000,0,0,0,8,0,0,0,-291.86,-1893.04,92.0213,1.96121,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,23,0,0,0,100,0,20000,30000,0,0,12,@Invader,1,250000,0,0,0,8,0,0,0,-298.297,-1846.85,93.3672,4.97792,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,24,0,0,0,100,0,0,0,0,0,12,@Invader,1,250000,0,0,0,8,0,0,0,-294.942,-1845.88,93.0999,4.86797,'Counterattack!: Summon Kolkar Invader'),
(@Deathgate*100,9,25,0,0,0,100,0,0,0,0,0,12,@Kromzar,1,250000,0,0,0,8,0,0,0,-296.718,-1846.38,93.2334,5.02897,'Counterattack!: Summon Warlord Kromzar'),
(@Deathgate*100,9,26,0,0,0,100,0,20000,20000,0,0,22,4,1,450000,0,0,0,1,0,0,0,0,0,0,0,'Regthar Deathgate: set phase 4'), -- if player does not finish this quest this time s/he can come back later'
(@Deathgate*100,9,27,0,0,0,100,0,2*3600*1000,2*3600*1000,0,0,22,1,1,450000,0,0,0,1,0,0,0,0,0,0,0,'Regthar Deathgate: set phase 1'), -- after 2 hours reset everything (event start on quest accept)'
(@Deathgate,0,7,0,20,10,100,0,@Counterattack,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Regthar Deathgate: On quest reward set phase 1');

DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (@Deathgate,@Kromzar,@Stormseer,@Invader,@Thrower,@Defender ); -- 16 EAI scripts

-- SAI for Gor'drek
-- This will remove 2 waypoint scripts that were spamming errors
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=21117;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=21117;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (2111700,2111701);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI
(21117,0,0,0,23,0,100,0,12550,0,2000,2000,11,12550,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Add Lightning Shield Aura'),
(21117,0,1,0,11,0,100,0,0,0,0,0,53,0,21117,1,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Start WP movement'),
(21117,0,2,0,40,0,100,0,2,21117,0,0,80,2111700,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Load script at WP 2'),
(21117,0,3,0,40,0,100,0,4,21117,0,0,80,2111701,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Load script at WP 4'),
-- Script 1
(2111700,9,0,0,0,0,100,0,0,0,0,0,54,128000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Pause at WP 2'),
(2111700,9,1,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.654867, 'Gor''drek - Turn to 5.654867'),
(2111700,9,2,0,0,0,100,0,2000,2000,0,0,11,28892,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Cast 42837'),
(2111700,9,3,0,0,0,100,0,120000,120000,0,0,92,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Stop Casting 42837'),
-- Script 2
(2111701,9,0,0,0,0,100,0,0,0,0,0,54,128000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Pause at WP 2'),
(2111701,9,1,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,4.677482, 'Gor''drek - Turn to 4.677482'),
(2111701,9,2,0,0,0,100,0,2000,2000,0,0,11,28892,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Cast 42837'),
(2111701,9,3,0,0,0,100,0,120000,120000,0,0,92,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gor''drek - Stop Casting 42837');
-- Update position and remove path for Gor'drek
UPDATE `creature` SET `position_x`=2313.006,`position_y`=6004.879,`position_z`=142.8264,`orientation`=4.677482,`MovementType`=0 WHERE `guid`=74168;
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid`=74168;
DELETE FROM `waypoint_data` WHERE `id`=741680;
DELETE FROM `waypoint_scripts` WHERE `id` IN (224,225);
-- Remove EAI
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=21117;
-- Proper waypoints for Gor'drek from sniff
DELETE FROM `waypoints` WHERE `entry`=21117;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(21117,1,2319.757,6007.015,142.7014,'Gor''drek WP 1'),
(21117,2,2325.909,6010.899,142.5764,'Gor''drek WP 2'),
(21117,3,2319.757,6007.015,142.7014,'Gor''drek WP 3'),
(21117,4,2313.006,6004.879,142.8264,'Gor''drek WP 4');

-- c27842 Fenrick Barlowe
-- issue: missing text & wp path
-- source: * screenshots & video from offy account (as of 7feb2011)
-- ================================
SET @ENTRY := 27842;
SET @SCRIPT1 := 2784201;
SET @SCRIPT2 := 2784202;
-- ================================
-- take random movement off of npc (smartAI will control pathing)
UPDATE `creature` SET `spawndist`=0, `MovementType`=0 WHERE `guid`=114186;
-- * create text into the DB
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES 
(@ENTRY,0,0, 'Bat gizzards again for the gnomes tonight...',0,0,100,1,0,0, 'Fenrick Barlowe text'),
(@ENTRY,0,1, 'What do they expect, making the bats come in at that angle? Broken necks and gamey bat stew, that''s what they get.',0,0,100,1,0,0, 'Fenrick Barlowe text'),
(@ENTRY,0,2, '''We like trees, Fenrick. They provide cover.'' They won''t let me chop them down, either.',0,0,100,1,0,0, 'Fenrick Barlowe text'),
(@ENTRY,0,3, 'I wonder how many reinforcements need to suffer injury before they allows us to chop down these idiotic trees. They''re costing us a fortune in bats. Maybe I''ll rig a harness or two...',0,0,100,1,0,0, 'Fenrick Barlowe text');
-- create path
-- point 8 reposition to face bat, do text - kneel for 10 seconds
-- point 5 do text - kneel for 10 seconds
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,3246.2,-642.609,165.239, 'Fenrick Barlowe path'),
(@ENTRY,2,3240.42,-645.154,165.399, 'Fenrick Barlowe path'),
(@ENTRY,3,3245.75,-664.935,166.789, 'Fenrick Barlowe path'),
(@ENTRY,4,3250.1,-663.819,166.789, 'Fenrick Barlowe path'),
(@ENTRY,5,3254.69,-661.435,167.188, 'Fenrick Barlowe path - kneel here - do text'),
(@ENTRY,6,3252.36,-659.146,167.118, 'Fenrick Barlowe path'),
(@ENTRY,7,3252.63,-648.746,165.904, 'Fenrick Barlowe path'),
(@ENTRY,8,3249.21,-647.163,165.7, 'Fenrick Barlowe path - kneel here - do text');
-- set SAI to npc
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
-- create scripts for random text, emotes, and pathing
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@SCRIPT1,@SCRIPT2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
-- AI
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'on spawn start path'),
(@ENTRY,0,1,0,40,0,100,0,5,@ENTRY,0,0,80,@SCRIPT1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'at wp 5 run script1'),
(@ENTRY,0,2,0,40,0,100,0,8,@ENTRY,0,0,80,@SCRIPT2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'at wp 8 run script2'),
-- script 1
(@SCRIPT1,9,0,0,0,0,100,0,0,0,0,0,54,13000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'pause pathing'),
(@SCRIPT1,9,1,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'say random text'),
(@SCRIPT1,9,2,0,0,0,100,0,0,0,0,0,90,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1=8 kneel'),
(@SCRIPT1,9,3,0,0,0,100,0,11000,11000,0,0,91,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1=0 stand up'),
-- script 2
(@SCRIPT2,9,0,0,0,0,100,0,0,0,0,0,54,14000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'pause pathing'),
(@SCRIPT2,9,1,0,40,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'say random text'),
(@SCRIPT2,9,2,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,10,108509,27787,0,0,0,0,0, 'face bat'),
(@SCRIPT2,9,3,0,0,0,100,0,1000,1000,0,0,90,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1=8 kneel'),
(@SCRIPT2,9,4,0,0,0,100,0,11000,11000,0,0,91,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1=0 stand up');
-- need the following fix also
-- c27787 Venomspite Riding Bat
-- offy screenshots show them as being dead (this coincides to the text that Fenrick Barlowe does)
UPDATE `creature` SET `unit_flags`=`unit_flags`|570688256,`dynamicflags`=`dynamicflags`|32 WHERE `guid` IN (108508,108509);
DELETE FROM `creature_addon` WHERE `guid` IN (108508,108509);
INSERT INTO `creature_addon` (`guid`,`bytes2`,`auras`) VALUES
(108508,1, '29266 0 29266 1'),(108509,1, '29266 0 29266 1');

-- Quest 11314 "The Fallen Sisters"
-- Chill Nymph SAI (in progress)
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=23678;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (23678,2367800);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23678,0,0,0,2,0,100,1,0,30,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Do text emote on health 30%'),
(23678,0,1,0,0,0,75,0,2000,3000,2000,2000,11,9739,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Wrath on victim'),
(23678,0,2,3,8,0,100,0,43340,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'On Spell hit 43340 face player'),
(23678,0,3,4,61,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'stop combat movement'),
(23678,0,4,5,61,0,100,0,0,0,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'evade'),
(23678,0,5,6,61,0,100,0,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,'set faction 35'),
(23678,0,6,7,61,0,100,0,0,0,0,0,33,24117,0,0,0,0,0,7,0,0,0,0,0,0,0,'quest credit'),
(23678,0,7,0,61,0,100,0,0,0,0,0,80,2367800,0,0,0,0,0,1,0,0,0,0,0,0,0,'load script'),
(23678,0,8,0,40,0,100,0,1,23678,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On reach waypoint 1 despawn'),
(2367800,9,0,0,0,0,100,0,2000,2000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Say text 1'),
(2367800,9,1,0,0,0,100,0,1000,1000,0,0,53,1,23678,0,0,0,0,1,0,0,0,0,0,0,0, 'start waypoint movement');
-- NPC talk text insert
DELETE FROM `creature_text` WHERE `entry`=23678;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(23678,0,0, 'Chill Nymph appears weak!',2,0,100,0,0,0, 'Chill Nymph'),
(23678,1,0, 'I knew Lurielle would send help! Thank you friend, and give Lurielle my thanks as well!',0,7,100,1,0,0, 'Chill Nymph'),
(23678,1,1, 'Where am I? What happened to me? You... you freed me?',0,7,100,1,0,0, 'Chill Nymph'),
(23678,1,2, 'Thank you. I thought I would die without seeing my sisters again!',0,7,100,1,0,0, 'Chill Nymph');
-- Chill Nymph Path
DELETE FROM `waypoints` WHERE `entry`=23678;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(23678,1,2063,-4666,217,'Chill Nymph point 1');
-- Add condition for Item 33606 "Lurielle''s Pendant" to only target Chill Nymph 23678
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceEntry`=33606;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,0,33606,0,24,1,23678,0,63,'','Item 33606 Lurielle''s Pendant targets Chill Nymph 23678');

-- Speech by Marrod Silvertongue, Fort Wildervar (Tested working)
SET @ENTRY := 24534;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,30000,50000,360000,360000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Load script every 6 min ooc'),
(@ENTRY*100,9,0,0,0,0,100,0,8000,8000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,2,0,0,0,100,0,8000,8000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 1'),
(@ENTRY*100,9,3,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,4,0,0,0,100,0,8000,8000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 2'),
(@ENTRY*100,9,5,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,6,0,0,0,100,0,8000,8000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 3'),
(@ENTRY*100,9,7,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,8,0,0,0,100,0,8000,8000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 4'),
(@ENTRY*100,9,9,0,0,0,100,0,2000,2000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,10,0,0,0,100,0,8000,8000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 5'),
(@ENTRY*100,9,11,0,0,0,100,0,2000,2000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,12,0,0,0,100,0,8000,8000,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 6'),
(@ENTRY*100,9,13,0,0,0,100,0,2000,2000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,14,0,0,0,100,0,3000,3000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry` IN (24534);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(24534,0,0, 'Welcome to Fort Wildervar, brave homesteaders! There''s a whole continent out there just waiting to be claimed!',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,1,0, 'True, Northrend is a hard land, but our people are strong, hardy, and equal to the task!',0,7,100,0,0,0, 'Marrod Silvertongue'),
(24534,2,0, 'We will win this land with the sword, and break it with the plow! You are the men and women who will be remembered for taming the wild continent!',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,3,0, 'But, you will not be alone out there. My men and I have prepared pack mules carrying the supplies you''ll need most.',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,4,0, 'Axes, picks, seed, nails, food, blankets, water... it''s all there, waiting for you. I think you''ll find my prices quite reasonable, too.',0,7,100,25,0,0, 'Marrod Silvertongue'),
(24534,5,0, 'There are more than enough to go around. Should you need other goods, don''t hesitate to ask!',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,6,0, 'Now, my loyal custo... err, friends, go forth and conquer this land for our people!',0,7,100,274,0,0, 'Marrod Silvertongue');

-- Gossip update Ghostlands
UPDATE `creature_template` SET `gossip_menu_id`=7242, `npcflag`=`npcflag`|1 WHERE `entry`=16204; -- Magister Idonis
UPDATE `creature_template` SET `gossip_menu_id`=7397, `npcflag`=`npcflag`|1 WHERE `entry`=16239; -- Magister Kaendris
UPDATE `creature_template` SET `gossip_menu_id`=7194, `npcflag`=`npcflag`|1 WHERE `entry`=16291; -- Magister Quallestis
UPDATE `creature_template` SET `gossip_menu_id`=7190, `npcflag`=`npcflag`|1 WHERE `entry`=16240; -- Arcanist Janeda
UPDATE `creature_template` SET `gossip_menu_id`=7187 WHERE `entry`=16198; -- Apothecary Renzithen
DELETE FROM `gossip_menu` WHERE `entry`=7242 AND `text_id`=8548;
DELETE FROM `gossip_menu` WHERE `entry`=7397 AND `text_id`=8860;
DELETE FROM `gossip_menu` WHERE `entry`=7194 AND `text_id`=8474;
DELETE FROM `gossip_menu` WHERE `entry`=7190 AND `text_id`=8470;
DELETE FROM `gossip_menu` WHERE `entry`=7187 AND `text_id`=8464;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7242,8548),(7397,8860),(7194,8474),(7190,8470),(7187,8464);
-- Gossip menu option
DELETE FROM `gossip_menu_option` WHERE `menu_id`=7187;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`action_script_id`,`box_coded`,`box_money`,`box_text`) VALUES
(7187,0,0,'I seek a sample of your restorative draught, apothecary.',1,1,0,0,0,0,0,'');
-- Gossip menu option condition
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=7187;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,7187,0,0,9,9164,0,0,0,'','Show gossip option 0 if player has quest 9164');
-- Smart AI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=16198;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16198;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16198,0,0,1,62,0,100,0,7187,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip option select close gossip'),
(16198,0,1,0,61,0,100,0,0,0,0,0,11,28149,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Cast Create Restorative Draught on player ');

-- Apothecary Enith Fixup for quest 9164 "Captives at Deatholme"
-- add gossip_id to npc and fix stand state
UPDATE `creature_template` SET `gossip_menu_id`=7182,`unit_flags`=33024 WHERE `entry`=16208;
DELETE FROM `creature_template_addon` WHERE `entry`=16208;
INSERT INTO `creature_template_addon` (`entry`,`bytes1`) VALUES (16208,7);
-- add gossip menu items
DELETE FROM `gossip_menu` WHERE `entry` IN (7182,7179);
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7182,8459),
(7179,8460);
-- add gossip menu options
DELETE FROM `gossip_menu_option` WHERE `menu_id` IN (7182,7179);
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`action_script_id`,`box_coded`,`box_money`,`box_text`) VALUES
(7182,0,0,'<Administer the restorative draught.>',1,1,7179,0,0,0,0,''),
(7179,0,0,'A bit ungrateful, aren''t we? The way out is clear, flee quickly!',1,1,0,0,0,0,0,'');
-- add condition for gossip option
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=7182;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,7182,0,0,2,22628,1,0,0,'','Show gossip option 0 if player has Renzithen''s Restorative Draught');
-- Apothecary Enith SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=16208;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (16208,1620800);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16208,0,0,0,62,0,100,0,7179,0,0,0,80,1620800,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
(16208,0,1,0,40,0,100,0,5,16208,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On reach waypoint 5 despawn'),
(1620800,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip flag'),
(1620800,9,1,0,0,0,100,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1 stand'),
(1620800,9,2,0,0,0,100,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'turn to envoker'),
(1620800,9,3,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(1620800,9,4,0,0,0,100,0,2000,2000,0,0,33,16208,0,0,0,0,0,7,0,0,0,0,0,0,0, 'give quest credit'),
(1620800,9,5,0,0,0,100,0,1000,1000,0,0,53,1,16208,0,0,0,0,1,0,0,0,0,0,0,0, 'start waypoint movement');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry`=16208;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(16208,0,0, 'Thanks, I should''ve never left Silverpine Forest.',0,0,100,6,0,0, 'Apothecary Enith');
-- Apothecary Enith Path
DELETE FROM `waypoints` WHERE `entry`=16208;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(16208,1,6647.83,-6344.92,9.13345,'Apothecary Enith point 1'),
(16208,2,6657.92,-6345.96,15.3468,'Apothecary Enith point 2'),
(16208,3,6661.58,-6342.65,15.4309,'Apothecary Enith point 3'),
(16208,4,6662.35,-6334.64,20.8803,'Apothecary Enith point 4'),
(16208,5,6662.63,-6331.85,20.8924,'Apothecary Enith point 5');

-- Ranger Vedoran <Farstriders> Fixup for quest 9164 "Captives at Deatholme"
-- add gossip_id to npc and fix stand state
UPDATE `creature_template` SET `gossip_menu_id`=7177 WHERE `entry`=16209;
-- add gossip menu items
DELETE FROM `gossip_menu` WHERE `entry` IN (7177,7176);
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7177,8457),
(7176,8456);
-- add gossip menu options
DELETE FROM `gossip_menu_option` WHERE `menu_id` IN (7177,7176);
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`action_script_id`,`box_coded`,`box_money`,`box_text`) VALUES
(7177,0,0,'<Administer the restorative draught.>',1,1,7176,0,0,0,0,''),
(7176,0,0,'You''re free to go now. The way out is safe.',1,1,0,0,0,0,0,'');
-- add condition for gossip option
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=7177;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,7177,0,0,2,22628,1,0,0,'','Show gossip option 0 if player has Renzithen''s Restorative Draught');
-- Ranger Vedoran SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=16209;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (16209,1620900);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16209,0,0,0,62,0,100,0,7176,0,0,0,80,1620900,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
(16209,0,1,0,40,0,100,0,7,16209,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On reach waypoint 7 despawn'),
(1620900,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip flag'),
(1620900,9,1,0,0,0,100,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1 stand'),
(1620900,9,2,0,0,0,100,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'turn to envoker'),
(1620900,9,3,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(1620900,9,4,0,0,0,100,0,2000,2000,0,0,33,16209,0,0,0,0,0,7,0,0,0,0,0,0,0, 'give quest credit'),
(1620900,9,5,0,0,0,100,0,1000,1000,0,0,53,1,16209,0,0,0,0,1,0,0,0,0,0,0,0, 'start waypoint movement');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry`=16209;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(16209,0,0, 'You have my thanks!',0,0,100,0,0,0, 'Ranger Vedoran');
-- Ranger Vedoran Path
DELETE FROM `waypoints` WHERE `entry`=16209;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(16209,1,6290.21,-6366.1,78.0195,'Ranger Vedoran point 1'),
(16209,2,6301.65,-6364.06,78.0238,'Ranger Vedoran point 2'),
(16209,3,6305.82,-6360.2,78.0782,'Ranger Vedoran point 3'),
(16209,4,6310.5,-6356.76,80.6154,'Ranger Vedoran point 4'),
(16209,5,6314.06,-6360.67,82.6096,'Ranger Vedoran point 5'),
(16209,6,6317.35,-6365.34,82.7124,'Ranger Vedoran point 6'),
(16209,7,6326.85,-6366.82,82.7090,'Ranger Vedoran point 7');

-- Apprentice Varnis Fixup for quest 9164 "Captives at Deatholme"
-- add gossip_id to npc and fix stand state
UPDATE `creature_template` SET `gossip_menu_id`=7185 WHERE `entry`=16206;
-- add gossip menu items
DELETE FROM `gossip_menu` WHERE `entry` IN (7185,7186);
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7185,8461),
(7186,8463);
-- add gossip menu options
DELETE FROM `gossip_menu_option` WHERE `menu_id` IN (7185,7186);
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`action_script_id`,`box_coded`,`box_money`,`box_text`) VALUES
(7185,0,0,'<Administer the restorative draught.>',1,1,7186,0,0,0,0,''),
(7186,0,0,'You''re free to go now. The way out is safe.',1,1,0,0,0,0,0,'');
-- add condition for gossip option
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=7185;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,7185,0,0,2,22628,1,0,0,'','Show gossip option 0 if player has Renzithen''s Restorative Draught');
-- Apprentice Varnis SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=16206;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (16206,1620600);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16206,0,0,0,62,0,100,0,7186,0,0,0,80,1620600,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
(16206,0,1,0,40,0,100,0,7,16206,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On reach waypoint 7 despawn'),
(1620600,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip flag'),
(1620600,9,1,0,0,0,100,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set bytes1 stand'),
(1620600,9,2,0,0,0,100,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'turn to envoker'),
(1620600,9,3,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(1620600,9,4,0,0,0,100,0,2000,2000,0,0,33,16206,0,0,0,0,0,7,0,0,0,0,0,0,0, 'give quest credit'),
(1620600,9,5,0,0,0,100,0,1000,1000,0,0,53,1,16206,0,0,0,0,1,0,0,0,0,0,0,0, 'start waypoint movement');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry`=16206;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(16206,0,0, 'Thank you. I thought I was going to die.',0,0,100,0,0,0, 'Apprentice Varnis');
-- Apprentice Varnis Path
DELETE FROM `waypoints` WHERE `entry`=16206;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(16206,1,6436.87,-6633.02,107.432,'Apprentice Varnis point 1'),
(16206,2,6435.63,-6620.86,107.436,'Apprentice Varnis point 2'),
(16206,3,6429.88,-6618.29,108.128,'Apprentice Varnis point 3'),
(16206,4,6426.7,-6614.82,110.159,'Apprentice Varnis point 4'),
(16206,5,6428.75,-6611.21,111.905,'Apprentice Varnis point 5'),
(16206,6,6432.83,-6606.89,112.126,'Apprentice Varnis point 6'),
(16206,7,6431.51,-6597.97,112.113,'Apprentice Varnis point 7');

-- Add aura to Zul'Drak Gateway Trigger if aura not present
SET @ENTRY := 28181;
SET @SPELL := 50795;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,23,0,100,0,@SPELL,0,2000,2000,11,@SPELL,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zul''Drak Gateway Trigger - Aura Zul''Drak Gateway not present - Add Aura Zul''Drak Gateway');

-- Conversation between Highlord Tirion Fordring & The Ebon Watcher
-- SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30377;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (30377,3037700);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30377,0,0,0,1,0,100,0,30000,60000,240000,240000,80,3037700,0,0,0,0,0,0,0,0,0,0,0,0,0,'Load script every 4 min ooc'),
(3037700,9,0,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 0'),
(3037700,9,1,0,0,0,100,0,6000,6000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 0'),
(3037700,9,2,0,0,0,100,0,12000,12000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 1'),
(3037700,9,3,0,0,0,100,0,12000,12000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 2'),
(3037700,9,4,0,0,0,100,0,5000,5000,0,0,1,1,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 1'),
(3037700,9,5,0,0,0,100,0,6000,6000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 3'),
(3037700,9,6,0,0,0,100,0,9000,9000,0,0,1,2,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 2'),
(3037700,9,7,0,0,0,100,0,9000,9000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 4'),
(3037700,9,8,0,0,0,100,0,3000,3000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 5'),
(3037700,9,9,0,0,0,100,0,9000,9000,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 6'),
(3037700,9,10,0,0,0,100,0,7000,7000,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 7'),
(3037700,9,11,0,0,0,100,0,11000,11000,0,0,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 8'),
(3037700,9,12,0,0,0,100,0,12000,12000,0,0,1,3,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 3'),
(3037700,9,13,0,0,0,100,0,13000,13000,0,0,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 9');
-- TEXT
DELETE FROM `creature_text` WHERE `entry` IN (28179,30377);
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(28179,0,0,'The Lich King reacted swiftly to the breach. Faster than I anticipated.',0,0,100,1,0,0,'Highlord Tirion Fordring'),
(28179,1,0,'What would you have me do, Darion?',0,0,100,6,0,0,'Highlord Tirion Fordring'),
(28179,2,0,'Choose your words wisely, death knight. You stand amidst the company of the devoted.',0,0,100,1,0,0,'Highlord Tirion Fordring'),
(28179,3,0,'We will do this with honor, Darion. We will not sink to the levels of the Scourge to be victorious. To do so would make us no better than the monster that we fight to destroy!',0,0,100,1,0,0,'Highlord Tirion Fordring'),
(30377,0,0,'You are dealing with a being that holds within it the consciousness of the most cunning, intelligent, and ruthless individuals to ever live.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,1,0,'The Lich King is unlike any foe that you have ever faced, Highlord. Though you bested him upon the holy ground of Light\'s Hope Chapel, you tread now upon his domain.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,2,0,'You cannot win. Not like this...',0,0,100,274,0,0,'The Ebon Watcher'),
(30377,3,0,'Nothing. There is nothing that you can do while the Light binds you. It controls you wholly, shackling you to the ground with its virtues.',0,0,100,274,0,0,'The Ebon Watcher'),
(30377,4,0,'%s shakes his head.','2',0,100,0,0,0,'The Ebon Watcher'),
(30377,5,0,'Look upon the field, Highlord. The Lich King has halted your advance completely and won the upper hand!',0,0,100,25,0,0,'The Ebon Watcher'),
(30377,6,0,'The breach you created was sealed with Nerubian webbing almost as quickly as it was opened.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,7,0,'Your soldiers are being used as living shields to stave off artillery fire in the Valley of Echoes, allowing the forces of the Lich King to assault your base without impediment.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,8,0,'The Lich King knows your boundaries, Highlord. He knows that you will not fire on your own men. Do you not understand? He has no boundaries. No rules to abide.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,9,0,'Then you have lost, Highlord.',0,0,100,1,0,0,'The Ebon Watcher');

-- Legion Fel Cannon SAI
SET @ENTRY := 21233;
SET @SPELL1 := 36238; -- Fel Cannon Blast
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,1000,1000,1000,1000,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Legion Fel Cannon - OOC - Prevent Combat Movement'),
(@ENTRY,0,1,0,0,0,100,0,0,1000,2500,2500,11,@SPELL1,1,0,0,0,0,2,0,0,0,0,0,0,0,'Legion Fel Cannon - Combat - Cast Fel Cannon Blast');

-- QUEST 9663 "The Kessel Run"
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (17116,17240,17440);
UPDATE `creature_template` SET `gossip_menu_id`=7983 WHERE `entry`=17440;
-- Smart AI
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (17116,17240,17440);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17116,0,0,0,64,0,100,0,0,0,0,0,33,17116,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663'),
(17240,0,0,0,64,0,100,0,0,0,0,0,33,17240,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663'),
(17440,0,0,0,64,0,100,0,0,0,0,0,33,17440,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663');
-- Add Gossip menu items
DELETE FROM `gossip_menu` WHERE `entry`=7399 AND `text_id`=9038;
DELETE FROM `gossip_menu` WHERE `entry`=7983 AND `text_id`=8994;
DELETE FROM `gossip_menu` WHERE `entry`=7983 AND `text_id`=9039;
DELETE FROM `gossip_menu` WHERE `entry`=7370 AND `text_id`=9040;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7399,9038),(7983,8994),(7983,9039),(7370,9040);
-- Gossip conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup` IN (7399,7983,7370);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,7399,9038,0,9,9663,0,0,0,'','Show gossip text 9038 if player has quest 9663'),
(14,7983,9039,0,9,9663,0,0,0,'','Show gossip text 9039 if player has quest 9663'),
(14,7370,9040,0,9,9663,0,0,0,'','Show gossip text 9040 if player has quest 9663');

-- Fel Cannon MKI SAI
SET @ENTRY := 22461;
SET @SPELL1 := 36238; -- Fel Cannon Blast
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,1000,1000,1000,1000,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Fel Cannon MKI - OOC - Prevent Combat Movement'),
(@ENTRY,0,1,0,0,0,100,0,0,1000,2500,2500,11,@SPELL1,1,0,0,0,0,2,0,0,0,0,0,0,0,'Fel Cannon MKI - Combat - Cast Fel Cannon Blast');

-- Quest: A Mammoth Undertaking (12607)
UPDATE `creature_template` SET `VehicleId`=206, `AIName`='SmartAI',`spell1`=51660  WHERE `entry`=28379; -- vehicle id is from sniffs
DELETE FROM `smart_scripts` WHERE `entryorguid`=28379 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(28379,0,0,0,31,0,100,0,51660,0,0,0,41,0,0,0,0,0,0,22,0,0,0,0,0,0,0, 'Shattertusk Mammoth - On Spell Hit - Despawn');

DELETE FROM `npc_spellclick_spells` where `npc_entry`=28379;
INSERT INTO `npc_spellclick_spells`(`npc_entry`,`spell_id`,`quest_start`,`quest_start_active`,`quest_end`,`cast_flags`,`aura_required`,`aura_forbidden`,`user_type`) values 
(28379,51658,12607,1,12607,0,0,0,0);

-- High Priest Andorath SAI
SET @ENTRY   := 25392;
SET @CHANNEL := 45491; -- Necrotic Purple Beam
SET @TARGET  := 25534; -- En'kilah Blood Globe
UPDATE `creature_template` SET `speed_run`=1,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,2000,6000,32000,32000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Andorath - OOC - Run Script every 32 sec'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,11,@CHANNEL,0,0,0,0,0,11,@TARGET,20,0,0,0,0,0, 'High Priest Andorath - script - Channel spell'),
(@ENTRY*100,9,1,0,0,0,100,0,23000,23000,0,0,92,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Andorath - script - Stop Channeling');

-- Quest 10895 "Zeth'Gor Must Burn!" (Alliance)
-- Remove flame spawns from db
DELETE FROM `gameobject` WHERE `guid` IN (32141,32142,32143,24683,24684,24685,24686);
-- Remove Honor Hold Gryphon Brigadier, Foothill spawns from db
DELETE FROM `creature` WHERE `guid` IN (78738,78739,78740,78741);
-- Zeth'Gor Quest Credit Marker, They Must Burn & Remove Honor Hold Gryphon Brigadier have wrong inhabit type, fix flags
UPDATE `creature_template` SET `InhabitType`=4 WHERE `entry` IN (21173,21170,22404,22405,22406);
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|2048 WHERE `entry` IN (21170,22404,22405,22406);

-- Add missing Zeth'Gor Quest Credit Marker, They Must Burn
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES 
(78738,21173,530,1,1,0,0,-1162.911377,2248.195313,152.24733,4.815845,120,0,0,1,0,0,0);

-- Add missing Go
DELETE FROM `gameobject_template` WHERE `entry`=183929;
INSERT INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`castBarCaption`,`unk1`,`faction`,`flags`,`size`,`data0`,`data1`,`data2`,`data3`,`data4`,`data5`,`data6`,`data7`,`data8`,`data9`,`data10`,`data11`,`data12`,`data13`,`data14`,`data15`,`data16`,`data17`,`data18`,`data19`,`data20`,`data21`,`data22`,`data23`,`ScriptName`,`WDBVerified`) VALUES 
(183929,6,0, '', '', '',35,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, '',1);

-- SAI add animation to GameObject Smoke Beacon
SET @ENTRY := 184661;
UPDATE `gameobject_template` SET `AIName`= 'SmartGameObjectAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=1 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,1,0,0,1,0,100,0,0,0,1000,1000,93,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'GameObject Smoke Beacon - On Spawn - Do Custom Animation');

-- Add spell conditions for 36325
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=36325;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,0,36325,0,18,1,21182,0,0,'','Spell 36325 target creature 21182'),
(13,0,36325,0,18,1,22401,0,0,'','Spell 36325 target creature 22401'),
(13,0,36325,0,18,1,22402,0,0,'','Spell 36325 target creature 22402'),
(13,0,36325,0,18,1,22403,0,0,'','Spell 36325 target creature 22403');

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower South
SET @ENTRY := 21182;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,1,0,0,0,0,10,78738,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower South from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-1156.975,2109.627,83.51005,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 1'),
(@ENTRY,2,-1152.303,2112.098,90.67654,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 2'),
(@ENTRY,3,-1150.817,2103.74,89.81573,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 3'),
(@ENTRY,4,-1153.965,2107.031,97.06559,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 4'),
(@ENTRY,5,-1156.105,2107.421,93.06557,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 5'),
(@ENTRY,6,-1152.167,2107.406,83.17665,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 6'),
(@ENTRY,7,-1150.145,2102.392,75.23684,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 7'),
(@ENTRY,8,-1158.784,2102.993,76.98234,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 8'),
(@ENTRY,9,-1158.344,2112.019,79.20454,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 9'),
(@ENTRY,10,-1148.166,2113.343,77.0103,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 10'),
(@ENTRY,11,-1148.897,2102.624,69.67694,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 11'),
(@ENTRY,12,-1157.054,2104.975,82.9548,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 12');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-1157.054,`position_y`=2104.975,`position_z`=82.9548,`orientation`=1.186824 WHERE `guid`=74299;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower North
SET @ENTRY := 22401;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,2,0,0,0,0,10,74239,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower North from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-821.9919,2034.883,55.01843,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 1'),
(@ENTRY,2,-820.9771,2027.591,63.68367,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 2'),
(@ENTRY,3,-825.2185,2034.113,65.86314,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 3'),
(@ENTRY,4,-816.8493,2028.659,49.75199,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 4'),
(@ENTRY,5,-825.249,2026.351,46.58422,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 5');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-825.249,`position_y`=2026.351,`position_z`=46.58422,`orientation`=1.186824 WHERE `guid`=78735;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Forge
SET @ENTRY := 22402;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,3,0,0,0,0,10,74239,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Forge from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-897.1001,1917.556,93.73737,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 1'),
(@ENTRY,2,-903.386,1919.14,76.0997,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 2'),
(@ENTRY,3,-898.1819,1920.161,82.67819,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 3'),
(@ENTRY,4,-901.2836,1920.168,92.57269,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 4'),
(@ENTRY,5,-894.9478,1924.78,75.48938,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 5'),
(@ENTRY,6,-894.4704,1919.866,93.71019,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 6');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-894.4704,`position_y`=1919.866,`position_z`=93.71019,`orientation`=1.186824 WHERE `guid`=78736;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Foothill
SET @ENTRY := 22403;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`flags_extra`=`flags_extra`|128,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,4,0,0,0,0,10,74239,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Foothill from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-978.3713,1883.556,104.3167,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 1'),
(@ENTRY,2,-974.3038,1878.926,109.6782,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 2'),
(@ENTRY,3,-974.1463,1874.819,121.9402,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 3'),
(@ENTRY,4,-982.4401,1875.441,100.4122,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 4'),
(@ENTRY,5,-975.1263,1882.178,118.0354,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 5'),
(@ENTRY,6,-979.3693,1876.667,121.5866,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 6');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-979.3693,`position_y`=1876.667,`position_z`=121.5866,`orientation`=1.186824 WHERE `guid`=78737;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn
SET @ENTRY  := 21173; -- Zeth'Gor Quest Credit Marker, They Must Burn
SET @ENTRY1 := 21170; -- Honor Hold Gryphon Brigadier, South
SET @ENTRY2 := 22404; -- Honor Hold Gryphon Brigadier, North
SET @ENTRY3 := 22405; -- Honor Hold Gryphon Brigadier, Forge
SET @ENTRY4 := 22406; -- Honor Hold Gryphon Brigadier, Foothills
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100, (@ENTRY*100)+1, (@ENTRY*100)+2, (@ENTRY*100)+3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI
(@ENTRY,0,0,0,38,0,100,0,0,1,0,0,80,(@ENTRY*100)+0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On dataset - load script'),
(@ENTRY,0,1,0,38,0,100,0,0,2,0,0,80,(@ENTRY*100)+1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On dataset - load script'),
(@ENTRY,0,2,0,38,0,100,0,0,3,0,0,80,(@ENTRY*100)+2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On dataset - load script'),
(@ENTRY,0,3,0,38,0,100,0,0,4,0,0,80,(@ENTRY*100)+3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On dataset - load script'),
-- Script 0
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Reset data 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,1000,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,3,0,0,0,100,0,0,0,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,5,0,0,0,100,0,0,0,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,7,0,0,0,100,0,0,0,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,8,0,0,0,100,0,3000,3000,0,0,45,0,4,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
-- Script 1
((@ENTRY*100)+1,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Reset data 0'),
((@ENTRY*100)+1,9,1,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,3,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,5,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,7,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,8,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
-- Script 2
((@ENTRY*100)+2,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Reset data 0'),
((@ENTRY*100)+2,9,1,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,3,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,5,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,7,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,8,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
-- Script 3
((@ENTRY*100)+3,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Reset data 0'),
((@ENTRY*100)+3,9,1,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,3,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,5,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,7,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,8,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill');

-- SAI for Honor Hold Gryphon Brigadier, South
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY1;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY1,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY1,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY1*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY1*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY1*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,4,0,38,0,100,0,0,4,0,0,53,1,(@ENTRY1*100)+3,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,5,0,40,0,100,0,10,@ENTRY1*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY1,0,6,0,40,0,100,0,10,(@ENTRY1*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY1,0,7,0,40,0,100,0,11,(@ENTRY1*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY1,0,8,0,40,0,100,0,11,(@ENTRY1*100)+3,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- SAI for Honor Hold Gryphon Brigadier, North
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY2;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY2,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY2,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY2*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY2*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY2*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,4,0,38,0,100,0,0,4,0,0,53,1,(@ENTRY2*100)+3,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,5,0,40,0,100,0,12,@ENTRY2*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY2,0,6,0,40,0,100,0,11,(@ENTRY2*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY2,0,7,0,40,0,100,0,12,(@ENTRY2*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY2,0,8,0,40,0,100,0,12,(@ENTRY2*100)+3,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- SAI for Honor Hold Gryphon Brigadier, Forge
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY3;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY3;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY3,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY3,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY3*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY3*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY3*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,4,0,38,0,100,0,0,4,0,0,53,1,(@ENTRY3*100)+3,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,5,0,40,0,100,0,13,@ENTRY3*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY3,0,6,0,40,0,100,0,13,(@ENTRY3*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY3,0,7,0,40,0,100,0,12,(@ENTRY3*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY3,0,8,0,40,0,100,0,14,(@ENTRY3*100)+3,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- SAI for Honor Hold Gryphon Brigadier, Foothill
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY4;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY4;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY4,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY4,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY4*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY4,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY4*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY4,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY4*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY4,0,4,0,40,0,100,0,15,@ENTRY4*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY4,0,5,0,40,0,100,0,15,(@ENTRY4*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY4,0,6,0,40,0,100,0,15,(@ENTRY4*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- Honor Hold Gryphon Brigadier, South Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY1*100, (@ENTRY1*100)+1, (@ENTRY1*100)+2, (@ENTRY1*100)+3);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, South Path 1
(@ENTRY1*100,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 1 WP 1'),
(@ENTRY1*100,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 1 WP 2'),
(@ENTRY1*100,3,-1162.907,2207.568,140.9076,'Honor Hold Gryphon Brigadier, South Path 1 WP 3'),
(@ENTRY1*100,4,-1165.149,2160.382,126.1298,'Honor Hold Gryphon Brigadier, South Path 1 WP 4'),
(@ENTRY1*100,5,-1171.198,2119.914,110.0741,'Honor Hold Gryphon Brigadier, South Path 1 WP 5'),
(@ENTRY1*100,6,-1152.598,2108.961,101.9074,'Honor Hold Gryphon Brigadier, South Path 1 WP 6'),
(@ENTRY1*100,7,-1126.18,2129.599,118.6573,'Honor Hold Gryphon Brigadier, South Path 1 WP 7'),
(@ENTRY1*100,8,-1113.314,2146.836,135.1296,'Honor Hold Gryphon Brigadier, South Path 1 WP 8'),
(@ENTRY1*100,9,-1105.45,2173.646,171.0185,'Honor Hold Gryphon Brigadier, South Path 1 WP 9'),
(@ENTRY1*100,10,-1107.9,2202.193,195.935,'Honor Hold Gryphon Brigadier, South Path 1 WP 10'),
-- Honor Hold Gryphon Brigadier, South Path 2
((@ENTRY1*100)+1,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 2 WP 1'),
((@ENTRY1*100)+1,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 2 WP 2'),
((@ENTRY1*100)+1,3,-1182.963,2208.794,125.3797,'Honor Hold Gryphon Brigadier, South Path 2 WP 3'),
((@ENTRY1*100)+1,4,-1182.292,2161.906,114.2409,'Honor Hold Gryphon Brigadier, South Path 2 WP 4'),
((@ENTRY1*100)+1,5,-1175.9,2113.828,105.1853,'Honor Hold Gryphon Brigadier, South Path 2 WP 5'),
((@ENTRY1*100)+1,6,-1152.598,2108.961,104.5463,'Honor Hold Gryphon Brigadier, South Path 2 WP 6'),
((@ENTRY1*100)+1,7,-1126.18,2129.599,117.0184,'Honor Hold Gryphon Brigadier, South Path 2 WP 7'),
((@ENTRY1*100)+1,8,-1097.298,2159.928,136.074,'Honor Hold Gryphon Brigadier, South Path 2 WP 8'),
((@ENTRY1*100)+1,9,-1084.76,2185.17,157.8796,'Honor Hold Gryphon Brigadier, South Path 2 WP 9'),
((@ENTRY1*100)+1,10,-1074.359,2208.386,178.1295,'Honor Hold Gryphon Brigadier, South Path 2 WP 10'),
-- Honor Hold Gryphon Brigadier, South Path 3
((@ENTRY1*100)+2,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 3 WP 1'),
((@ENTRY1*100)+2,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 3 WP 2'),
((@ENTRY1*100)+2,3,-1150.548,2194.858,120.9303,'Honor Hold Gryphon Brigadier, South Path 3 WP 3'),
((@ENTRY1*100)+2,4,-1151.814,2161.048,110.9858,'Honor Hold Gryphon Brigadier, South Path 3 WP 4'),
((@ENTRY1*100)+2,5,-1152.937,2131.728,105.9581,'Honor Hold Gryphon Brigadier, South Path 3 WP 5'),
((@ENTRY1*100)+2,6,-1151.148,2107.598,99.458,'Honor Hold Gryphon Brigadier, South Path 3 WP 6'),
((@ENTRY1*100)+2,7,-1165.406,2089.037,115.6802,'Honor Hold Gryphon Brigadier, South Path 3 WP 7'),
((@ENTRY1*100)+2,8,-1174.068,2083.782,125.0691,'Honor Hold Gryphon Brigadier, South Path 3 WP 8'),
((@ENTRY1*100)+2,9,-1205.327,2083.083,164.097,'Honor Hold Gryphon Brigadier, South Path 3 WP 9'),
((@ENTRY1*100)+2,10,-1232.793,2084.872,183.4025,'Honor Hold Gryphon Brigadier, South Path 3 WP 10'),
((@ENTRY1*100)+2,11,-1264.571,2093.127,197.5136,'Honor Hold Gryphon Brigadier, South Path 3 WP 11'),
-- Honor Hold Gryphon Brigadier, South Path 4
((@ENTRY1*100)+3,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 4 WP 1'),
((@ENTRY1*100)+3,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 4 WP 2'),
((@ENTRY1*100)+3,3,-1152.79,2211.288,120.9303,'Honor Hold Gryphon Brigadier, South Path 4 WP 3'),
((@ENTRY1*100)+3,4,-1146.584,2178.448,110.9858,'Honor Hold Gryphon Brigadier, South Path 4 WP 4'),
((@ENTRY1*100)+3,5,-1155.939,2146.783,105.9581,'Honor Hold Gryphon Brigadier, South Path 4 WP 5'),
((@ENTRY1*100)+3,6,-1151.148,2107.598,99.68026,'Honor Hold Gryphon Brigadier, South Path 4 WP 6'),
((@ENTRY1*100)+3,7,-1142.785,2094.159,103.5414,'Honor Hold Gryphon Brigadier, South Path 4 WP 7'),
((@ENTRY1*100)+3,8,-1136.896,2085.377,109.1246,'Honor Hold Gryphon Brigadier, South Path 4 WP 8'),
((@ENTRY1*100)+3,9,-1119.036,2071.976,118.8748,'Honor Hold Gryphon Brigadier, South Path 4 WP 9'),
((@ENTRY1*100)+3,10,-1103.594,2050.397,128.2081,'Honor Hold Gryphon Brigadier, South Path 4 WP 10'),
((@ENTRY1*100)+3,11,-1080.568,2022.377,137.5138,'Honor Hold Gryphon Brigadier, South Path 4 WP 11');

-- Honor Hold Gryphon Brigadier, North Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY2*100, (@ENTRY2*100)+1, (@ENTRY2*100)+2, (@ENTRY2*100)+3);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, North Path 1
(@ENTRY2*100,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,4,-774.873,1952.79,99.47905,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,5,-786.8572,1972.59,99.47905,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,6,-799.9429,2000.454,78.95126,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,7,-806.1043,2017.675,73.36794,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,8,-819.2725,2032.523,73.17354,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,9,-831.7571,2046.865,80.61793,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,10,-844.0977,2058.49,83.64579,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,11,-859.0389,2080.072,95.78463,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,12,-883.3383,2095.611,107.5624,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
-- Honor Hold Gryphon Brigadier, North Path 2
((@ENTRY2*100)+1,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,5,-792.3573,1953.981,99.47905,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,6,-812.7388,1993.078,78.95126,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,7,-823.2512,2008.549,73.36794,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,8,-823.4645,2030.833,73.17354,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,9,-812.5039,2051.152,80.61793,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,10,-775.5078,2066.004,83.64579,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,11,-728.4387,2072.975,87.72904,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
-- Honor Hold Gryphon Brigadier, North Path 3
((@ENTRY2*100)+2,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,5,-798.551,1950.061,99.47905,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,6,-822.979,1966.302,78.95126,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,7,-829.1212,1999.823,73.36794,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,8,-823.4645,2030.833,73.17354,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,9,-822.0243,2049.509,80.61793,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,10,-838.6264,2088.113,83.64579,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,11,-857.7249,2123.352,87.72904,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,12,-856.7349,2157.759,99.95123,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
-- Honor Hold Gryphon Brigadier, North Path 4
((@ENTRY2*100)+3,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,5,-792.3573,1953.981,99.47905,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,6,-812.7388,1993.078,78.95126,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,7,-823.2512,2008.549,73.36794,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,8,-823.4645,2030.833,73.17354,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,9,-812.5039,2051.152,80.61793,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,10,-838.6264,2088.113,83.64579,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,11,-857.7249,2123.352,87.72904,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,12,-891.1043,2149.23,87.72904,'Honor Hold Gryphon Brigadier, North Path 4 WP');

-- Honor Hold Gryphon Brigadier, Forge Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY3*100, (@ENTRY3*100)+1, (@ENTRY3*100)+2, (@ENTRY3*100)+3);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, Forge Path 1
(@ENTRY3*100,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,4,-779.0291,1934.054,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,5,-805.9227,1932.241,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,6,-837.3495,1926.666,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,7,-862.7343,1923.357,97.618,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,8,-897.9168,1921.757,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,9,-914.8586,1930.438,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,10,-932.5103,1940.806,109.0624,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,11,-945.1282,1950.602,122.7846,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,12,-966.2561,1954.868,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,13,-993.241,1956.073,157.4512,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
-- Honor Hold Gryphon Brigadier, Forge Path 2
((@ENTRY3*100)+1,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,4,-780.6625,1927.177,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,5,-811.2864,1921.429,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,6,-834.9781,1920.712,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,7,-866.0516,1916.696,97.618,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,8,-895.7596,1922.273,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,9,-923.1928,1916.771,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,10,-948.4045,1901.38,98.9791,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,11,-966.732,1893.369,110.0068,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,12,-989.9695,1893.078,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,13,-1025.913,1875.034,164.979,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
-- Honor Hold Gryphon Brigadier, Forge Path 3
((@ENTRY3*100)+2,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,5,-799.0213,1938.265,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,6,-821.9453,1929.91,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,7,-847.0975,1925.127,97.618,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,8,-884.1627,1919.391,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,9,-910.0975,1918.052,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,10,-931.7395,1901.312,98.9791,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,11,-938.8629,1883.565,110.0068,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,12,-948.2704,1857.24,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
-- Honor Hold Gryphon Brigadier, Forge Path 4
((@ENTRY3*100)+3,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,5,-799.0213,1938.265,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,6,-821.9453,1929.91,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,7,-847.0975,1925.127,97.618,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,8,-884.1627,1919.391,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,9,-898.5378,1920.82,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,10,-909.0667,1943.895,98.9791,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,11,-882.7237,1983.156,110.0068,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,12,-857.6995,1997.67,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,13,-834.7382,1999.236,151.1734,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,14,-797.808,1990.238,154.7012,'Honor Hold Gryphon Brigadier, Forge Path 4 WP');

-- Honor Hold Gryphon Brigadier, Foothill Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY4*100, (@ENTRY4*100)+1, (@ENTRY4*100)+2);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, Foothill Path 1
(@ENTRY4*100,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 1'),
(@ENTRY4*100,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 2'),
(@ENTRY4*100,3,-750.1168,1929.094,115.7846,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 3'),
(@ENTRY4*100,4,-780.6038,1912.869,111.4513,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 4'),
(@ENTRY4*100,5,-812.3557,1903.761,119.8957,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 5'),
(@ENTRY4*100,6,-844.3373,1894.094,121.1179,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 6'),
(@ENTRY4*100,7,-875.8698,1888.307,134.0069,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 7'),
(@ENTRY4*100,8,-908.7481,1889.962,139.368,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 8'),
(@ENTRY4*100,9,-936.4296,1891.453,135.5625,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 9'),
(@ENTRY4*100,10,-956.9449,1888.206,129.8402,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 10'),
(@ENTRY4*100,11,-976.4232,1879.735,128.3126,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 11'),
(@ENTRY4*100,12,-999.7429,1861.678,156.9511,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 12'),
(@ENTRY4*100,13,-1019.369,1838.22,181.4233,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 13'),
(@ENTRY4*100,14,-1015.93,1818.592,198.4232,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 14'),
(@ENTRY4*100,15,-1003.392,1791.963,211.84,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 15'),
-- Honor Hold Gryphon Brigadier, Foothill Path 2
((@ENTRY4*100)+1,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 1'),
((@ENTRY4*100)+1,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 2'),
((@ENTRY4*100)+1,3,-750.1168,1929.094,115.7846,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 3'),
((@ENTRY4*100)+1,4,-780.6038,1912.869,111.4513,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 4'),
((@ENTRY4*100)+1,5,-812.3557,1903.761,119.8957,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 5'),
((@ENTRY4*100)+1,6,-844.3373,1894.094,121.1179,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 6'),
((@ENTRY4*100)+1,7,-875.8698,1888.307,134.0069,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 7'),
((@ENTRY4*100)+1,8,-905.6191,1885.849,139.368,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 8'),
((@ENTRY4*100)+1,9,-933.7491,1881.107,135.5625,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 9'),
((@ENTRY4*100)+1,10,-957.0587,1876.275,129.8402,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 10'),
((@ENTRY4*100)+1,11,-976.4232,1879.735,128.3126,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 11'),
((@ENTRY4*100)+1,12,-1001.597,1896.851,136.0901,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 12'),
((@ENTRY4*100)+1,13,-1026.942,1912.217,153.8956,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 13'),
((@ENTRY4*100)+1,14,-1046.058,1925.075,168.2844,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 14'),
((@ENTRY4*100)+1,15,-1065.902,1940.892,183.0622,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 15'),
-- Honor Hold Gryphon Brigadier, Foothill Path 3
((@ENTRY4*100)+2,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 1'),
((@ENTRY4*100)+2,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 2'),
((@ENTRY4*100)+2,3,-750.1168,1929.094,115.7846,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 3'),
((@ENTRY4*100)+2,4,-780.6038,1912.869,111.4513,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 4'),
((@ENTRY4*100)+2,5,-812.3557,1903.761,119.8957,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 5'),
((@ENTRY4*100)+2,6,-852.6487,1887.492,134.7291,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 6'),
((@ENTRY4*100)+2,7,-885.8631,1878.916,144.8403,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 7'),
((@ENTRY4*100)+2,8,-910.2131,1876.215,149.118,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 8'),
((@ENTRY4*100)+2,9,-933.7659,1874.894,145.9792,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 9'),
((@ENTRY4*100)+2,10,-957.0587,1876.275,129.8402,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 10'),
((@ENTRY4*100)+2,11,-976.4232,1879.735,128.3126,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 11'),
((@ENTRY4*100)+2,12,-1003.331,1901.21,136.0901,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 12'),
((@ENTRY4*100)+2,13,-1019.146,1920.588,153.8956,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 13'),
((@ENTRY4*100)+2,14,-1035.73,1937.606,168.2844,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 14'),
((@ENTRY4*100)+2,15,-1055.794,1959.019,183.0622,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 15');

-- Fizzcrank Recon Pilot SAI
SET @ENTRY  := 25841;
SET @GOSSIP := 21248;
SET @SCRIPT := 212481;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,46362,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On gossip option select - close gossip'),
(@ENTRY,0,2,0,11,0,100,0,0,0,0,0,81,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On spawn - set gossip flag'),
(@ENTRY,0,3,4,8,0,100,0,46362,0,0,0,11,46362,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On spellhit - cast spell on envoker'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On spellhit - set phase 1'),
(@ENTRY,0,5,0,1,1,100,0,3000,3000,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - OOC - wait 3 sec despawn (Phase 1)');
-- Cleanup EAI
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@ENTRY;
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP AND `id`=0;
DELETE FROM `gossip_scripts` WHERE `id`=@SCRIPT;

-- Pathing for Chief Engineer Galpen Rolltie SAI
SET @ENTRY := 26600;
-- Remove old waypoint data and scripts
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4136.725,`position_y`=5316.553,`position_z`=28.726,`orientation`=0.3286853 WHERE `guid`=117890;
-- SAI for Chief Engineer Galpen Rolltie
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1,@ENTRY*100+2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,16000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 1 - STATE_WORK_MINING'),
(@ENTRY,0,3,4,40,0,100,0,7,@ENTRY,0,0,54,9000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 7 - pause path'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 7 - STATE_WORK_MINING'),
(@ENTRY,0,5,6,40,0,100,0,15,@ENTRY,0,0,54,14000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 15 - pause path'),
(@ENTRY,0,6,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 15 - STATE_WORK_MINING');
-- Waypoints for Chief Engineer Galpen Rolltie from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4138.141,5318.302,28.81850, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,2,4140.475,5319.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,3,4141.725,5323.979,29.04604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,4,4139.975,5327.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,5,4136.975,5328.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,6,4134.975,5327.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,7,4135.308,5325.655,28.77358, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,8,4135.063,5327.819,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,9,4140.063,5327.819,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,10,4143.313,5325.319,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,11,4141.313,5317.819,29.77233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,12,4137.063,5314.819,29.02233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,13,4132.313,5316.569,29.02233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,14,4130.313,5319.819,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,15,4131.816,5320.484,28.77108, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,16,4130.521,5321.019,29.24854, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,17,4131.021,5317.769,29.24854, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,18,4133.771,5315.769,28.99854, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,19,4136.725,5316.553,28.72600, 'Chief Engineer Galpen Rolltie');

-- Pathing for Willis Wobblewheel SAI
SET @ENTRY := 26599;
-- Remove old waypoint data and scripts
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4135.779,`position_y`=5282.234,`position_z`=25.11416,`orientation`=1.19467 WHERE `guid`=117866;
-- SAI for Willis Wobblewheel
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,17000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 1 - STATE_WORK_MINING'),
(@ENTRY,0,3,4,40,0,100,0,3,@ENTRY,0,0,54,16000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 3 - pause path'),
(@ENTRY,0,4,5,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.288348, 'Willis Wobblewheel - Reach wp 3 - turn to'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 1 - STATE_USESTANDING');
-- Waypoints for Willis Wobblewheel from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4137.04,5285.097,25.23916, 'Willis Wobblewheel'),
(@ENTRY,2,4135.779,5282.234,25.11416, 'Willis Wobblewheel'),
(@ENTRY,3,4135.004,5281.168,25.11416, 'Willis Wobblewheel'),
(@ENTRY,4,4135.779,5282.234,25.11416, 'Willis Wobblewheel');

-- Pathing for Fizzcrank Watcher Rupert Keeneye SAI
SET @ENTRY := 26634;
-- Remove old waypoint data and scripts
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4183.354,`position_y`=5318.837,`position_z`=58.1593 WHERE `guid`=97336;
-- SAI for Fizzcrank Watcher Rupert Keeneye
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Watcher Rupert Keeneye - On spawn - Start WP movement'),
(@ENTRY,0,1,0,40,0,100,0,2,@ENTRY,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Watcher Rupert Keeneye - Reach wp 2 - pause path'),
(@ENTRY,0,2,3,40,0,100,0,6,@ENTRY,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Watcher Rupert Keeneye - Reach wp 6 - pause path'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0.8901179, 'Fizzcrank Watcher Rupert Keeneye - Reach wp 6 - turn to');
-- Waypoints for Fizzcrank Watcher Rupert Keeneye from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4186.929,5321.105,58.13441, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,2,4185.132,5318.713,58.1639, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,3,4186.515,5316.936,58.15049, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,4,4186.929,5321.105,58.13441, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,5,4191.268,5319.607,58.12418, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,6,4189.929,5324.715,58.08976, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,7,4184.381,5325.549,58.05596, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,8,4183.354,5318.837,58.1593, 'Fizzcrank Watcher Rupert Keeneye');
-- Fizzcrank Watcher Rupert Keeneye dupe spawn
DELETE FROM `creature` WHERE `guid`=97346;
DELETE FROM `creature_addon` WHERE `guid`=97346;

-- Pathing for Fizzcrank Engineering Crew SAI
SET @ENTRY := 26645;
SET @PATH  := @ENTRY*100;
SET @PATH2 := @ENTRY*100+1;
-- Remove old waypoint data and scripts
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4153.918,`position_y`=5347.379,`position_z`=29.03030 WHERE `guid`=98042;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4145.670,`position_y`=5329.370,`position_z`=28.68240 WHERE `guid`=98043;
-- SAI for Fizzcrank Engineering Crew
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-98042,-98043);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-98042,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH,1,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - On spawn - Start WP movement'),
(-98042,0,1,2,40,0,100,0,1,@PATH,0,0,54,16000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 1 - pause path'),
(-98042,0,2,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 1 - STATE_USESTANDING'),
(-98042,0,3,4,40,0,100,0,6,@PATH,0,0,54,19000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 6 - pause path'),
(-98042,0,4,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 6 - STATE_USESTANDING'),
(-98042,0,5,6,40,0,100,0,10,@PATH,0,0,54,16000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 10 - pause path'),
(-98042,0,6,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 10 - STATE_USESTANDING'),
(-98042,0,7,8,40,0,100,0,14,@PATH,0,0,54,24000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 14 - pause path'),
(-98042,0,8,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 14 - STATE_USESTANDING'),
(-98043,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH2,1,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - On spawn - Start WP movement'),
(-98043,0,1,2,40,0,100,0,5,@PATH2,0,0,54,20000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 5 - pause path'),
(-98043,0,2,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 5 - STATE_USESTANDING'),
(-98043,0,3,4,40,0,100,0,10,@PATH2,0,0,54,23000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 10 - pause path'),
(-98043,0,4,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 10 - STATE_WORK_MINING'),
(-98043,0,5,6,40,0,100,0,18,@PATH2,0,0,54,25000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 18 - pause path'),
(-98043,0,6,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 18 - STATE_WORK_MINING'),
(-98043,0,7,8,40,0,100,0,24,@PATH2,0,0,54,25000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 24 - pause path'),
(-98043,0,8,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 24 - STATE_USESTANDING');
-- Waypoints for Fizzcrank Engineering Crew from sniff
DELETE FROM `waypoints` WHERE `entry` IN (@PATH,@PATH2);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@PATH,1,4153.728,5344.668,29.34072, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,2,4152.786,5345.597,29.62969, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,3,4157.786,5346.597,29.62969, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,4,4160.786,5343.097,30.37969, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,5,4158.286,5341.347,29.62969, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,6,4156.344,5341.525,29.41866, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,7,4158.535,5340.623,29.56693, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,8,4159.285,5338.123,29.06693, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,9,4157.035,5336.123,29.06693, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,10,4152.727,5336.721,28.71519, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,11,4152.224,5335.373,29.05804, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,12,4150.224,5335.873,29.05804, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,13,4148.974,5337.873,29.30804, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,14,4149.720,5343.525,28.90088, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,15,4148.819,5340.952,29.46559, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,16,4149.319,5336.702,29.21559, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,17,4154.319,5334.202,29.21559, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,18,4158.569,5336.702,28.96559, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,19,4160.819,5343.202,30.21559, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,20,4158.069,5347.202,29.71559, 'Fizzcrank Engineering Crew wp 1'),
(@PATH,21,4153.918,5347.379,29.03030, 'Fizzcrank Engineering Crew wp 1'),
(@PATH2,1,4147.00,5327.734,29.32715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,2,4149.25,5326.734,29.07715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,3,4151.50,5329.484,29.32715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,4,4150.25,5330.734,29.32715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,5,4148.829,5329.599,28.9719, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,6,4150.054,5331.477,29.32324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,7,4152.054,5333.477,29.07324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,8,4150.804,5335.727,29.07324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,9,4147.554,5336.477,29.07324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,10,4143.779,5335.355,28.67457, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,11,4146.732,5336.823,29.20758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,12,4150.982,5335.573,29.20758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,13,4153.232,5331.323,28.95758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,14,4150.482,5326.823,28.70758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,15,4144.732,5324.573,29.45758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,16,4141.482,5326.823,29.20758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,17,4139.686,5329.791,28.74058, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,18,4141.878,5331.735,28.69350, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,19,4141.274,5330.552,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,20,4141.774,5328.302,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,21,4142.774,5326.052,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,22,4145.524,5326.052,29.43795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,23,4146.774,5328.052,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,24,4145.670,5329.370,28.68240, 'Fizzcrank Engineering Crew wp 2');
-- Fizzcrank Engineering Crew dupe spawn
DELETE FROM `creature` WHERE `guid`=98029;
DELETE FROM `creature_addon` WHERE `guid`=98029;

-- Pathing for Fizzcrank bomber Entry: 25765
SET @NPC := 111360;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=4235.847,`position_y`=5353.55,`position_z`=81.03476 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`bytes2`,`mount`,`auras`) VALUES (@NPC,@PATH,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,4222.374,5370.328,72.03476,0,1,0,100,0),
(@PATH,2,4193.999,5364.787,66.81252,0,1,0,100,0),
(@PATH,3,4161.166,5319.937,66.81252,0,1,0,100,0),
(@PATH,4,4149.038,5289.545,66.81252,0,1,0,100,0),
(@PATH,5,4158.851,5255.303,66.81252,0,1,0,100,0),
(@PATH,6,4193.628,5230.504,79.17356,0,1,0,100,0),
(@PATH,7,4259.787,5211.473,79.20131,0,1,0,100,0),
(@PATH,8,4293.693,5221.593,80.20133,0,1,0,100,0),
(@PATH,9,4296.654,5282.716,82.20137,0,1,0,100,0),
(@PATH,10,4261.68,5314.814,89.8682,0,1,0,100,0),
(@PATH,11,4224.254,5366.333,98.86811,0,1,0,100,0),
(@PATH,12,4174.309,5345.78,98.86811,0,1,0,100,0),
(@PATH,13,4150.472,5287.501,98.86811,0,1,0,100,0),
(@PATH,14,4188.47,5251.628,102.757,0,1,0,100,0),
(@PATH,15,4241.055,5236.796,102.757,0,1,0,100,0),
(@PATH,16,4280.259,5260.132,105.6182,0,1,0,100,0),
(@PATH,17,4271.736,5301.975,105.6182,0,1,0,100,0),
(@PATH,18,4235.847,5353.55,81.03476,0,1,0,100,0);
-- Fizzcrank bomber dupe spawn
DELETE FROM `creature` WHERE `guid` IN (111361,111426);
DELETE FROM `creature_addon` WHERE `guid` IN (111361,111426);

-- Rig Hauler AC-9 SAI
SET @ENTRY := 25766;
UPDATE `creature` SET `position_x`=4170.335,`position_y`=5359.113,`position_z`=30.06447,`orientation`=2.740167 WHERE `guid`=111472;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,5000,10000,210000,210000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - OOC 3.5 min - start script 1'),
(@ENTRY,0,1,0,40,0,100,0,1,@ENTRY,0,0,45,0,1,0,0,0,0,11,25765,20,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 1 - dataset 0 1 nearest Fizzcrank Bomber'),
(@ENTRY,0,2,3,40,0,100,0,5,@ENTRY,0,0,54,5000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 5 - pause wp'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,92,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 5 - INTERRUPT_SPELL'),
(@ENTRY,0,4,0,40,0,100,0,6,@ENTRY,0,0,45,0,1,0,0,0,0,10,106069,15214,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 6 - dataset 0 1 Invisable Stalker'),
(@ENTRY,0,5,0,40,0,100,0,25,@ENTRY,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,2.740167, 'Rig Hauler AC-9 - Reach wp 25 - turn to'),
-- Script
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,12,25765,3,360000,0,0,0,8,0,0,0,4165.76,5354.39,30.1116,2.35619, 'Rig Hauler AC-9 - script - summon 25765'),
(@ENTRY*100,9,1,0,0,0,100,0,6000,6000,0,0,11,45967,0,0,0,0,0,11,25765,10,0,0,0,0,0, 'Rig Hauler AC-9 - script - cast 45967'),
(@ENTRY*100,9,2,0,0,0,100,0,3000,3000,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - script - Start WP movement');
-- Waypoints for Rig Hauler AC-9 from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4149.316,5357.732,29.11953, 'Rig Hauler AC-9'),
(@ENTRY,2,4136.816,5345.482,29.11953, 'Rig Hauler AC-9'),
(@ENTRY,3,4125.566,5333.982,29.11953, 'Rig Hauler AC-9'),
(@ENTRY,4,4115.297,5323.852,28.67458, 'Rig Hauler AC-9'),
(@ENTRY,5,4108.158,5316.849,28.75930, 'Rig Hauler AC-9'),
(@ENTRY,6,4111.660,5313.279,28.75930, 'Rig Hauler AC-9'),
(@ENTRY,7,4112.747,5314.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,8,4116.997,5314.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,9,4118.997,5316.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,10,4125.247,5323.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,11,4127.247,5325.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,12,4129.497,5326.696,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,13,4131.497,5328.446,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,14,4133.497,5328.446,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,15,4134.747,5329.446,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,16,4135.747,5333.696,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,17,4141.997,5337.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,18,4143.997,5341.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,19,4145.997,5344.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,20,4147.247,5346.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,21,4150.247,5348.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,22,4152.247,5350.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,23,4162.747,5356.196,29.66189, 'Rig Hauler AC-9'),
(@ENTRY,24,4166.997,5358.696,30.41189, 'Rig Hauler AC-9'),
(@ENTRY,25,4170.335,5359.113,30.06447, 'Rig Hauler AC-9');
-- Rig Hauler AC-9 dupe spawn
DELETE FROM `creature` WHERE `guid`=111501;
DELETE FROM `creature_addon` WHERE `guid`=111501;

-- Fizzcrank Bomber SAI
SET @ENTRY := 25765;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - on dataset 0 1 - dataset 0 0'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - on dataset 0 1 - Start WP movement'),
(@ENTRY,0,2,3,40,0,100,0,22,@ENTRY,0,0,54,45000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 22 - pause wp'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 22 - Set Speed run'),
(@ENTRY,0,4,5,40,0,100,0,74,@ENTRY,0,0,11,47460,3,0,0,0,0,11,26817,5,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 74 - cast 47460 on Fizzcrank fighter'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 74 - despawn');
-- Waypoints for Fizzcrank Bomber from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4164.758,5354.723,30.19215, 'Fizzcrank Bomber wp 1'),
(@ENTRY,2,4162.034,5355.368,30.09748, 'Fizzcrank Bomber wp 1'),
(@ENTRY,3,4159.190,5355.827,30.01153, 'Fizzcrank Bomber wp 1'),
(@ENTRY,4,4156.273,5356.132,29.94405, 'Fizzcrank Bomber wp 1'),
(@ENTRY,5,4154.659,5355.736,29.91132, 'Fizzcrank Bomber wp 1'),
(@ENTRY,6,4152.153,5354.786,29.86976, 'Fizzcrank Bomber wp 1'),
(@ENTRY,7,4149.633,5353.545,29.83581, 'Fizzcrank Bomber wp 1'),
(@ENTRY,8,4147.138,5352.081,29.80874, 'Fizzcrank Bomber wp 1'),
(@ENTRY,9,4144.689,5350.449,29.78749, 'Fizzcrank Bomber wp 1'),
(@ENTRY,10,4142.290,5348.694,29.77098, 'Fizzcrank Bomber wp 1'),
(@ENTRY,11,4139.963,5346.840,29.76581, 'Fizzcrank Bomber wp 1'),
(@ENTRY,12,4137.673,5344.909,29.76182, 'Fizzcrank Bomber wp 1'),
(@ENTRY,13,4135.418,5342.924,29.75874, 'Fizzcrank Bomber wp 1'),
(@ENTRY,14,4133.194,5340.901,29.75638, 'Fizzcrank Bomber wp 1'),
(@ENTRY,15,4130.993,5338.848,29.75706, 'Fizzcrank Bomber wp 1'),
(@ENTRY,16,4128.794,5336.785,29.75758, 'Fizzcrank Bomber wp 1'),
(@ENTRY,17,4126.612,5334.716,29.75798, 'Fizzcrank Bomber wp 1'),
(@ENTRY,18,4124.430,5332.629,29.75829, 'Fizzcrank Bomber wp 1'),
(@ENTRY,19,4121.542,5329.849,29.75858, 'Fizzcrank Bomber wp 1'),
(@ENTRY,20,4118.184,5326.597,29.75881, 'Fizzcrank Bomber wp 1'),
(@ENTRY,21,4116.024,5324.498,29.75892, 'Fizzcrank Bomber wp 1'),
(@ENTRY,22,4113.869,5322.398,29.75901, 'Fizzcrank Bomber wp 1'),
(@ENTRY,23,4090.109,5298.56,29.70082, 'Fizzcrank Bomber wp 1'),
(@ENTRY,24,4079.459,5287.617,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,25,4066.779,5274.603,31.53571, 'Fizzcrank Bomber wp 1'),
(@ENTRY,26,4041.215,5249.248,31.45236, 'Fizzcrank Bomber wp 1'),
(@ENTRY,27,4020.432,5218.824,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,28,4002.392,5190.421,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,29,4000.105,5146.331,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,30,3993.002,5119.754,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,31,3976.405,5093.208,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,32,3983.637,5055.651,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,33,3990.106,5011.049,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,34,3992.433,4984.051,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,35,3988.744,4946.948,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,36,3975.796,4912.274,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,37,3958.111,4895.366,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,38,3928.622,4858.76,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,39,3921.781,4825.03,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,40,3935.435,4790.436,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,41,3966.323,4756.983,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,42,3987.75,4763.042,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,43,4025.366,4755.083,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,44,4050.189,4787.045,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,45,4082.41,4825.174,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,46,4084.739,4845.887,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,47,4082.781,4879.066,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,48,4075.255,4897.705,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,49,4063.763,4936.532,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,50,4066.78,4968.409,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,51,4082.993,4997.696,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,52,4110.507,5030.572,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,53,4141.148,5060.043,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,54,4164.455,5087.176,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,55,4189.664,5124.69,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,56,4214.33,5154.247,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,57,4237.962,5194.166,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,58,4228.307,5238.578,42.11903, 'Fizzcrank Bomber wp 1'),
(@ENTRY,59,4200.375,5271.218,46.75792, 'Fizzcrank Bomber wp 1'),
(@ENTRY,60,4211.719,5318.444,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,61,4229.69,5356.218,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,62,4229.779,5396.165,53.08044, 'Fizzcrank Bomber wp 1'),
(@ENTRY,63,4231.299,5419.959,53.71933, 'Fizzcrank Bomber wp 1'),
(@ENTRY,64,4228.378,5466.135,57.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,65,4249.183,5490.759,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,66,4282.767,5500.858,48.85822, 'Fizzcrank Bomber wp 1'),
(@ENTRY,67,4300.521,5486.341,48.386, 'Fizzcrank Bomber wp 1'),
(@ENTRY,68,4291.369,5470.349,48.91378, 'Fizzcrank Bomber wp 1'),
(@ENTRY,69,4277.046,5454.25,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,70,4253.641,5434.851,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,71,4227.768,5423.928,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,72,4204.012,5411.217,37.52486, 'Fizzcrank Bomber wp 1'),
(@ENTRY,73,4194.847,5402.538,32.41374, 'Fizzcrank Bomber wp 1'),
(@ENTRY,74,4178.285,5386.063,30.94151, 'Fizzcrank Bomber wp 1');
-- Remove Fizzcrank Bomber spawn
DELETE FROM `creature` WHERE `guid`=111452;
DELETE FROM `creature_addon` WHERE `guid`=111452;

-- Invisable Stalker SAI
SET @ENTRY := 15214;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=-106069;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-106069,0,0,1,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisable Stalker - on dataset 0 1 - dataset 0 0'),
(-106069,0,1,0,61,0,100,0,0,0,0,0,11,47453,3,0,0,0,0,11,25766,200,0,0,0,0,0, 'Invisable Stalker - on dataset 0 1 - Cast 47453 on Rig Hauler AC-9');

-- Fizzcrank Fighter SAI
SET @ENTRY := 26817;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Fighter - on spawn - start wp'),
(@ENTRY,0,1,0,1,0,100,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Fighter - on spawn - say text 0'),
(@ENTRY,0,2,0,40,0,100,0,15,@ENTRY,0,0,11,43671,3,0,0,0,0,11,25765,20,0,0,0,0,0, 'Fizzcrank Fighter - Reach wp 15 - cast 43671 on Fizzcrank Bomber');
-- NPC talk text for Fizzcrank Fighter
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'I''ll blast those gnomish wannabes back to the scrap heap!',0,7,100,0,0,0, 'Fizzcrank Fighter'),
(@ENTRY,0,1, 'You''re sending me back there?!',0,7,100,0,0,0, 'Fizzcrank Fighter');
-- Waypoints for Fizzcrank Fighter from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4176.501,5280.566,27.17445, 'Fizzcrank Fighter'),
(@ENTRY,2,4167.001,5282.066,27.17445, 'Fizzcrank Fighter'),
(@ENTRY,3,4164.751,5282.566,26.92445, 'Fizzcrank Fighter'),
(@ENTRY,4,4162.655,5282.681,26.48916, 'Fizzcrank Fighter'),
(@ENTRY,5,4158.462,5280.628,26.26419, 'Fizzcrank Fighter'),
(@ENTRY,6,4155.712,5279.378,25.76419, 'Fizzcrank Fighter'),
(@ENTRY,7,4154.958,5278.939,24.86416, 'Fizzcrank Fighter'),
(@ENTRY,8,4147.710,5281.817,24.86416, 'Fizzcrank Fighter'),
(@ENTRY,9,4144.757,5295.502,25.61416, 'Fizzcrank Fighter'),
(@ENTRY,10,4142.652,5300.067,26.94346, 'Fizzcrank Fighter'),
(@ENTRY,11,4137.876,5308.749,27.94350, 'Fizzcrank Fighter'),
(@ENTRY,12,4135.610,5310.586,28.93834, 'Fizzcrank Fighter'),
(@ENTRY,13,4131.433,5312.564,28.75930, 'Fizzcrank Fighter'),
(@ENTRY,14,4123.820,5317.622,28.75930, 'Fizzcrank Fighter'),
(@ENTRY,15,4115.430,5321.649,28.75930, 'Fizzcrank Fighter');
-- Remove Fizzcrank Fighter spawns
DELETE FROM `creature` WHERE `guid` IN (114142,114143,114165);
DELETE FROM `creature_addon` WHERE `guid` IN (114142,114143,114165);

-- Pathing for Crafty Wobblesprocket SAI
SET @ENTRY := 25477;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4172.788,`position_y`=5254.925,`position_z`=26.12851 WHERE `guid`=108021;
-- SAI for Crafty Wobblesprocket
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,45000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 1 - STATE_USESTANDING'),
(@ENTRY,0,3,4,40,0,100,0,6,@ENTRY,0,0,54,35000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 6 - pause path'),
(@ENTRY,0,4,5,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0.4712389, 'Crafty Wobblesprocket - Reach wp 6 - turn to'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 6 - STATE_WORK_MINING');
-- Waypoints for Crafty Wobblesprocket from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4179.099,5251.51,26.37851, 'Crafty Wobblesprocket'),
(@ENTRY,2,4177.94,5250.202,26.87851, 'Crafty Wobblesprocket'),
(@ENTRY,3,4181.048,5243.429,24.87851, 'Crafty Wobblesprocket'),
(@ENTRY,4,4182.067,5222.448,25.00868, 'Crafty Wobblesprocket'),
(@ENTRY,5,4193.037,5217.233,25.13368, 'Crafty Wobblesprocket'),
(@ENTRY,6,4193.037,5217.233,25.13368, 'Crafty Wobblesprocket'),
(@ENTRY,7,4190.718,5217.938,25.25868, 'Crafty Wobblesprocket'),
(@ENTRY,8,4176.049,5229.444,24.50868, 'Crafty Wobblesprocket'),
(@ENTRY,9,4166.732,5248.798,24.75351, 'Crafty Wobblesprocket'),
(@ENTRY,10,4172.788,5254.925,26.12851, 'Crafty Wobblesprocket');
-- Remove Crafty Wobblesprocket dupe spawn
DELETE FROM `creature` WHERE `guid`=108025;
DELETE FROM `creature_addon` WHERE `guid`=108025;
-- Fix addon for Crafty Wobblesprocket
DELETE FROM `creature_addon` WHERE `guid`=108021;
DELETE FROM `creature_template_addon` WHERE `entry`=25477;
INSERT INTO `creature_template_addon` (`entry`,`bytes2`) VALUES (25477,257);

-- SAI for ELM General Purpose Bunny
SET @ENTRY := 23837;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-98575,-98576);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-98575,0,0,0,1,0,100,0,10000,20000,90000,105000,11,45931,3,0,0,0,0,10,98576,23837,0,0,0,0,0, 'ELM General Purpose Bunny - OOC timed - cast 45931 on target'),
(-98576,0,0,0,8,0,100,0,45931,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'ELM General Purpose Bunny - On spellhit - run script'),
(@ENTRY*100,9,0,0,0,0,100,0,4000,4000,0,0,12,25783,3,60000,0,0,0,8,0,0,0,4181.491,5258.655,27.19127,3.857178, 'ELM General Purpose Bunny - script - summon 25783'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,1000,0,0,5,5,0,0,0,0,0,11,25747,10,0,0,0,0,0, 'ELM General Purpose Bunny - script - send emote to 25747'),
(@ENTRY*100,9,2,0,0,0,100,0,4000,4000,0,0,45,0,1,0,0,0,0,11,25783,10,0,0,0,0,0, 'ELM General Purpose Bunny - script - set data 0 1 on 25783');

-- SAI for Fizzcrank Airstrip Survivor
SET @ENTRY := 25783;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,0,0,0,0,11,34427,3,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on spawn - cast 34427 on self'),
(@ENTRY,0,1,0,1,0,100,1,1000,1000,1000,1000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on spawn - say text 0'),
(@ENTRY,0,2,3,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on dataset 0 1 - dataset 0 0'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on dataset 0 1 - Start WP movement'),
(@ENTRY,0,4,0,40,0,100,0,6,@ENTRY,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - Reach wp 6 - despawn');
-- Waypoints for Fizzcrank Airstrip Survivor from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4168.529,5251.933,24.87851, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,2,4156.656,5256.007,24.62325, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,3,4151.527,5268.997,25.36416, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,4,4159.549,5281.078,26.23916, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,5,4173.898,5280.844,26.69306, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,6,4179.473,5282.701,26.69306, 'Fizzcrank Airstrip Survivor');
-- Remove Fizzcrank Airstrip Survivor spawn
DELETE FROM `creature` WHERE `guid` IN (88109);
DELETE FROM `creature_addon` WHERE `guid` IN (88109);
-- NPC talk text for Fizzcrank Survivor
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'I''m flesh and blood again. That''s all that matters!',0,7,100,5,0,0, 'Fizzcrank Survivor');

-- Fizzcrank Fullthrottle SAI
SET @ENTRY  := 25590;
SET @GOSSIP := 9182;
UPDATE `creature_template` SET `AIName`= '0' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;

-- Dread Captain DeMeza SAI
SET @ENTRY := 28048;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,9647,0,0,0,11,50517,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Dread Captain DeMeza - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Dread Captain DeMeza - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=9647 AND `id`=0;
DELETE FROM `gossip_scripts` WHERE `id`=9647;

-- Drakuru SAI
SET @ENTRY := 26423;
SET @GOSSIP := 21249;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,33,27921,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Drakuru - On gossip option select - killcredit'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Drakuru - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP AND `id`=0;
DELETE FROM `gossip_scripts` WHERE `id`=@GOSSIP;

-- Steel Gate Chief Archaeologist SAI
SET @ENTRY  := 24399;
SET @GOSSIP := 8953;
SET @SCRIPT := 895300;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,43533,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP AND `id`=0;
DELETE FROM `gossip_scripts` WHERE `id`=@SCRIPT;

-- Glodrak Huntsniper SAI
SET @ENTRY  := 24657;
SET @GOSSIP := 10603;
SET @SCRIPT := 1060400;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,66592,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Glodrak Huntsniper - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Glodrak Huntsniper - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP AND `id`=0;
DELETE FROM `gossip_scripts` WHERE `id`=@SCRIPT;
-- Goldark Snipehunter SAI
SET @ENTRY  := 23486;
SET @GOSSIP := 10604;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,66592,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Goldark Snipehunter - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Goldark Snipehunter - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP AND `id`=0;

-- Pol Amberstill & Driz Tumblequick SAI
SET @ENTRY   := 24468;
SET @ENTRY1  := 24510;
SET @GOSSIP  := 8958;
SET @GOSSIP1 := 8960;
SET @SCRIPT  := 895800;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (@ENTRY,@ENTRY1);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@ENTRY,@ENTRY1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- Pol Amberstill
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,6,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - close gossip'),
(@ENTRY,0,2,3,62,0,100,0,@GOSSIP1,0,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - cast spell'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - close gossip'),
-- Driz Tumblequick
(@ENTRY1,0,0,1,62,0,100,0,@GOSSIP,6,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - cast spell'),
(@ENTRY1,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - close gossip'),
(@ENTRY1,0,2,3,62,0,100,0,@GOSSIP1,0,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - cast spell'),
(@ENTRY1,0,3,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - close gossip');
-- Ckeanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP AND `id`=6;
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP1 AND `id`=0;
DELETE FROM `gossip_scripts` WHERE `id`=@SCRIPT;

-- Keeper Remulos SAI
SET @ENTRY  := 11832;
SET @GOSSIP := 10215;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,57413,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Keeper Remulos - On gossip option select - cast spell'),
(@ENTRY,0,1,2,62,0,100,0,@GOSSIP,1,0,0,11,57670,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Keeper Remulos - On gossip option select - cast spell'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Keeper Remulos - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id` IN (1021500,1021501);

-- Jean Pierre Poulain SAI
SET @ENTRY  := 34244;
SET @GOSSIP := 10478;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,64795,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Jean Pierre Poulain - On gossip option select - cast spell');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id` IN (1047800);

-- Thargold Ironwing SAI
SET @ENTRY  := 29154;
SET @GOSSIP := 9776;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,53335,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Thargold Ironwing - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Thargold Ironwing - On gossip option select - close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id` IN (977600);

-- SAI for Gavin Gnarltree
SET @ENTRY := 225;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=-10617.34,`position_y`=-1153.902,`position_z`=27.11271 WHERE `guid`=4086;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,6000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,5,25,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 1 - ONESHOT_POINT'),
(@ENTRY,0,3,0,40,0,100,0,6,@ENTRY,0,0,54,50000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 6 - pause path'),
(@ENTRY,0,4,5,40,0,100,0,10,@ENTRY,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 10 - pause path'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 10 - STATE_WORK_MINING'),
(@ENTRY,0,6,0,56,0,100,0,10,@ENTRY,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - waypoint 10 resumed - STATE_NONE');
-- Waypoints for Gavin Gnarltree from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-10616.74,-1150.729,28.03606, 'Gavin Gnarltree'),
(@ENTRY,2,-10609.4,-1154.94,28.2175, 'Gavin Gnarltree'),
(@ENTRY,3,-10605.3,-1157.31,30.007, 'Gavin Gnarltree'),
(@ENTRY,4,-10600.3,-1159.58,30.0602, 'Gavin Gnarltree'),
(@ENTRY,5,-10596.1,-1156.43,30.0602, 'Gavin Gnarltree'),
(@ENTRY,6,-10596.89,-1154.147,30.05965, 'Gavin Gnarltree'),
(@ENTRY,7,-10601.7,-1159.03,30.0602, 'Gavin Gnarltree'),
(@ENTRY,8,-10606,-1156.86,29.9963, 'Gavin Gnarltree'),
(@ENTRY,9,-10609.6,-1155.18,28.2269, 'Gavin Gnarltree'),
(@ENTRY,10,-10617.34,-1153.902,27.11271, 'Gavin Gnarltree');

-- SAI for Joseph Wilson
SET @ENTRY := 33589;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=8489.46,`position_y`=964.667,`position_z`=547.293 WHERE `guid`=75904;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - On spawn - Start WP movement'),
(@ENTRY,0,1,0,40,0,100,0,1,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - Reach wp 1 - run script'),
(@ENTRY,0,2,3,40,0,100,0,4,@ENTRY,0,0,54,60000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - Reach wp 4 - pause path'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.193953, 'Joseph Wilson - Reach wp 4 - turn to'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,54,22000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - Script - pause path'),
(@ENTRY*100,9,1,0,0,0,100,0,500,500,0,0,66,0,0,0,0,0,0,19,33479,0,0,0,0,0,0, 'Joseph Wilson - Script - turn to'),
(@ENTRY*100,9,2,0,0,0,100,0,500,500,0,0,11,61493,0,0,0,0,0,19,33479,0,0,0,0,0,0, 'Joseph Wilson - Script - cast'),
(@ENTRY*100,9,3,0,0,0,100,0,10000,10000,0,0,66,0,0,0,0,0,0,19,33460,0,0,0,0,0,0, 'Joseph Wilson - Script - turn to'),
(@ENTRY*100,9,4,0,0,0,100,0,500,500,0,0,11,61493,0,0,0,0,0,19,33460,0,0,0,0,0,0, 'Joseph Wilson - Script - cast');
-- Waypoints for Joseph Wilson from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,8492.984,961.6198,547.2927, 'Joseph Wilson'),
(@ENTRY,2,8489.46,964.667,547.293, 'Joseph Wilson'),
(@ENTRY,3,8489.138,966.7257,547.2927, 'Joseph Wilson'),
(@ENTRY,4,8489.907,967.6441,547.2939, 'Joseph Wilson'),
(@ENTRY,5,8489.138,966.7257,547.2927, 'Joseph Wilson'),
(@ENTRY,6,8489.46,964.667,547.293, 'Joseph Wilson');

-- SAI for Thomas Partridge
SET @ENTRY := 33854;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=8480.21,`position_y`=937.883,`position_z`=547.293 WHERE `guid`=76735;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,60000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.01942, 'Thomas Partridge - Reach wp 1 - turn to'),
(@ENTRY,0,3,0,40,0,100,0,5,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 5 - run script'),
(@ENTRY,0,4,0,40,0,100,0,9,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 9 - run script'),
(@ENTRY,0,5,0,40,0,100,0,13,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 13 - run script'),
(@ENTRY,0,6,0,40,0,100,0,16,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 16 - run script'),
(@ENTRY,0,7,0,40,0,100,0,20,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 20 - run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,54,8000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Script - pause path'),
(@ENTRY*100,9,1,0,0,0,100,0,500,500,0,0,5,273,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Script - emote');
-- Waypoints for Thomas Partridge from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,8481.685,959.4879,547.2927, 'Thomas Partridge'),
(@ENTRY,2,8482.575,952.007,547.2927, 'Thomas Partridge'),
(@ENTRY,3,8479.16,931.178,547.294, 'Thomas Partridge'),
(@ENTRY,4,8480.29,928.951,547.293, 'Thomas Partridge'),
(@ENTRY,5,8481.386,929.6846,547.2927, 'Thomas Partridge'),
(@ENTRY,6,8479.16,931.178,547.294, 'Thomas Partridge'),
(@ENTRY,7,8479.08,935.109,547.293, 'Thomas Partridge'),
(@ENTRY,8,8482.33,937.765,547.294, 'Thomas Partridge'),
(@ENTRY,9,8487.458,937.033,547.2927, 'Thomas Partridge'),
(@ENTRY,10,8482.33,937.765,547.294, 'Thomas Partridge'),
(@ENTRY,11,8479.16,931.178,547.294, 'Thomas Partridge'),
(@ENTRY,12,8479.21,919.35,547.294, 'Thomas Partridge'),
(@ENTRY,13,8483.181,917.6667,547.2927, 'Thomas Partridge'),
(@ENTRY,14,8480.25,917.926,547.293, 'Thomas Partridge'),
(@ENTRY,15,8480.31,909.402,547.293, 'Thomas Partridge'),
(@ENTRY,16,8484.031,903.8014,547.2927, 'Thomas Partridge'),
(@ENTRY,17,8479.39,909.922,547.293, 'Thomas Partridge'),
(@ENTRY,18,8479.08,935.109,547.293, 'Thomas Partridge'),
(@ENTRY,19,8483.99,937.559,547.293, 'Thomas Partridge'),
(@ENTRY,20,8486.654,940.0261,547.2929, 'Thomas Partridge'),
(@ENTRY,21,8483.99,937.559,547.293, 'Thomas Partridge'),
(@ENTRY,22,8480.21,937.883,547.293, 'Thomas Partridge');


-- SAI for Brammold Deepmine
SET @ENTRY := 32509;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=5771.88,`position_y`=632.803,`position_z`=661.075 WHERE `guid`=120355;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Brammold Deepmine - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,2,@ENTRY,0,0,54,480000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Brammold Deepmine - Reach wp 2 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,2.321288, 'Brammold Deepmine - Reach wp 2 - turm to'),
(@ENTRY,0,3,4,40,0,100,0,8,@ENTRY,0,0,54,480000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Brammold Deepmine - Reach wp 8 - pause path'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,1.692969, 'Brammold Deepmine - Reach wp 8 - turn to');
-- Waypoints for Brammold Deepmine from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,5769.026,629.7931,661.0721, 'Brammold Deepmine'),
(@ENTRY,2,5770.056,625.5038,661.0721, 'Brammold Deepmine'),
(@ENTRY,3,5769.026,629.7931,661.0721, 'Brammold Deepmine'),
(@ENTRY,4,5771.88,632.803,661.075, 'Brammold Deepmine'),
(@ENTRY,5,5773.25,637.491,661.151, 'Brammold Deepmine'),
(@ENTRY,6,5759.77,648.809,650.12, 'Brammold Deepmine'),
(@ENTRY,7,5757,647.883,650.141, 'Brammold Deepmine'),
(@ENTRY,8,5753.792,635.2266,650.1417, 'Brammold Deepmine'),
(@ENTRY,9,5757,647.883,650.141, 'Brammold Deepmine'),
(@ENTRY,10,5759.77,648.809,650.12, 'Brammold Deepmine'),
(@ENTRY,11,5773.25,637.491,661.151, 'Brammold Deepmine'),
(@ENTRY,12,5771.88,632.803,661.075, 'Brammold Deepmine');


-- SAI for Emi
SET @ENTRY := 32668;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=5805.625,`position_y`=692.3191,`position_z`=647.0484 WHERE `guid`=110543;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Emi - On spawn - Start WP movement'),
(@ENTRY,0,1,0,40,0,100,0,1,@ENTRY,0,0,54,18000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Emi - Reach wp 1 - pause path'),
(@ENTRY,0,2,3,40,0,100,0,2,@ENTRY,0,0,54,25000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Emi - Reach wp 2 - pause path'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.316126, 'Emi - Reach wp 2 - turm to');
-- Waypoints for Emi from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,5809.61,694.5121,647.0484, 'Emi'),
(@ENTRY,2,5805.625,692.3191,647.0484, 'Emi');
-- 0xF130007F9C00292F .go 5809.61 694.5121 647.0484

-- SAI for Colin
SET @ENTRY := 32669;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=5807.146,`position_y`=683.3826,`position_z`=647.0484 WHERE `guid`=110586;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Colin - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,4000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Colin - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.427974, 'Colin - Reach wp 1 - turm to'),
(@ENTRY,0,3,4,40,0,100,0,2,@ENTRY,0,0,54,28000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Colin - Reach wp 2 - pause path'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0.2094395, 'Colin - Reach wp 2 - turm to'),
(@ENTRY,0,5,6,40,0,100,0,3,@ENTRY,0,0,54,23000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Colin - Reach wp 3 - pause path'),
(@ENTRY,0,6,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.804818, 'Colin - Reach wp 3 - turm to');
-- Waypoints for Colin from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,5815.523,681.2226,647.0484, 'Colin'),
(@ENTRY,2,5818.646,688.2175,647.0484, 'Colin'),
(@ENTRY,3,5807.146,683.3826,647.0484, 'Colin');
-- 0xF130007F9D00293F .go 5815.523 681.2226 647.0484

-- Stabled Argent Hippogryph SAI
SET @ENTRY  := 35117;
SET @GOSSIP := 10616;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,66777,2,0,0,0,0,7,0,0,0,0,0,0,0, 'Stabled Argent Hippogryph - On gossip option select - Cast Mount Up on player');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=1061600;

-- Zidormi SAI
SET @ENTRY  := 31848;
SET @GOSSIP := 10131;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,85,46343,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zidormi - On gossip option select - Player Cast Teleport to Caverns of Time on self');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=@GOSSIP;

-- Arch Druid Lilliandra SAI
SET @ENTRY  := 30630;
SET @GOSSIP := 9991;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,85,57536,0,0,0,0,0,19,30630,0,0,0,0,0,0, 'Arch Druid Lilliandra - On gossip option select - Player Cast Forcecast Portal: Moonglade on Arch Druid Lilliandra');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=999200;

-- Librarian Tiare SAI
SET @ENTRY  := 30051;
SET @GOSSIP := 9626;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,50135,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Librarian Tiare - On gossip option select - Cast Teleport - Coldarra, Transitus Shield to Amber Ledge on player');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=962600;

-- Surristrasz SAI
SET @ENTRY  := 24795;
SET @GOSSIP := 9472;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Surristrasz - On gossip option select - Close gossip'),
(@ENTRY,0,1,0,61,0,100,0,@GOSSIP,0,0,0,85,46064,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Surristrasz - On gossip option select - Player Cast Amber Ledge to Coldarra on self');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=947200; @GOSSIP := 9472;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Surristrasz - On gossip option select - Close gossip'),
(@ENTRY,0,1,0,61,0,100,0,@GOSSIP,0,0,0,85,46064,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Surristrasz - On gossip option select - Player Cast Amber Ledge to Coldarra on self');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=947200; @ENTRY  := 24795;
SET @GOSSIP := 9472;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Surristrasz - On gossip option select - Close gossip'),
(@ENTRY,0,1,0,61,0,100,0,@GOSSIP,0,0,0,85,46064,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Surristrasz - On gossip option select - Player Cast Amber Ledge to Coldarra on self');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=947200;

-- Librarian Tiare SAI
SET @ENTRY  := 30051;
SET @GOSSIP := 9626;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,50135,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Librarian Tiare - On gossip option select - Cast Teleport - Coldarra, Transitus Shield to Amber Ledge on player');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=962600;

-- Jero'me SAI
SET @ENTRY  := 19882;
SET @GOSSIP := 8060;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,1,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Jero''me - On gossip option select - Close gossip');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=806000;

-- Greer Orehammer SAI
SET @ENTRY  := 23859;
SET @GOSSIP := 9546;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,4,0,100,0,0,0,0,0,80,2385900,0,2,0,0,0,1,0,0,0,0,0,0,0, 'Greer Orehammer - On aggro - Run Script'),
(@ENTRY,0,1,2,62,0,100,0,@GOSSIP,1,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Greer Orehammer - On gossip option select - Close gossip'),
(@ENTRY,0,2,3,61,0,100,0,0,0,0,0,56,33634,10,0,0,0,0,7,0,0,0,0,0,0,0, 'Greer Orehammer - On gossip option select - give player 10 Orehammer''s Precision Bombs'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,52,745,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Greer Orehammer - On gossip option select - Plague This Taxi Start');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=954601;

-- Darrok SAI
SET @ENTRY  := 27425;
SET @GOSSIP := 21250;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Darrok - On gossip option select - Close gossip'),
(@ENTRY,0,1,2,61,0,100,0,0,0,0,0,85,48960,3,0,0,0,0,1,0,0,0,0,0,0,0, 'Darrok - On gossip option select - Cast Horde Log Ride 01 Begin on player'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,85,48961,3,0,0,0,0,1,0,0,0,0,0,0,0, 'Darrok - On gossip option select - Cast Log Ride Horde 00 on player');
-- Cleanup gossip
UPDATE `gossip_menu_option` SET `action_script_id`=0 WHERE `menu_id`=@GOSSIP;
DELETE FROM `gossip_scripts` WHERE `id`=2125100;

-- SAI for Fhyron Shadesong
SET @ENTRY := 33788;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=8570.943,`position_y`=1008.467,`position_z`=548.2927 WHERE `guid`=85201;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - On spawn - Start WP movement'),
(@ENTRY,0,1,0,40,0,100,0,8,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 8 - run script'),
(@ENTRY,0,2,0,40,0,100,0,10,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 10 - run script'),
(@ENTRY,0,3,0,40,0,100,0,12,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 12 - run script'),
(@ENTRY,0,4,0,40,0,100,0,14,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 14 - run script'),
(@ENTRY,0,5,0,40,0,100,0,15,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 15 - run script'),
(@ENTRY,0,6,0,40,0,100,0,17,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 17 - run script'),
(@ENTRY,0,7,0,40,0,100,0,18,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 18 - run script'),
(@ENTRY,0,8,0,40,0,100,0,20,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 20 - run script'),
(@ENTRY,0,9,0,40,0,100,0,21,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 21 - run script'),
(@ENTRY,0,10,0,40,0,100,0,26,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 26 - run script'),
(@ENTRY,0,11,0,40,0,100,0,28,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 28 - run script'),
(@ENTRY,0,12,0,40,0,100,0,31,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 31 - run script'),
(@ENTRY,0,13,0,40,0,100,0,33,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 33 - run script'),
(@ENTRY,0,14,0,40,0,100,0,38,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 38 - run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,54,8000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Script - Pause path'),
(@ENTRY*100,9,1,0,0,0,100,0,100,100,0,0,66,0,0,0,0,0,0,19,33787,0,0,0,0,0,0, 'Fhyron Shadesong - Script - turn to Tournament Druid Spell Target'),
(@ENTRY*100,9,2,0,0,0,100,0,100,100,0,0,11,63678,0,0,0,0,0,19,33787,0,0,0,0,0,0, 'Fhyron Shadesong - Script - Cast Earthliving Visual on Tournament Druid Spell Target'),
(@ENTRY*100,9,3,0,0,0,50,0,4000,4000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Script - say text 0');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry`=@ENTRY; 
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'Help shield us from these cutting winds, little sapling.',0,7,100,2,0,0, 'Fhyron Shadesong'),
(@ENTRY,0,1, 'There you are',0,7,100,273,0,0, 'Fhyron Shadesong'),
(@ENTRY,0,2, 'Grow, little one.',0,7,100,273,0,0, 'Fhyron Shadesong');
-- Waypoints for Fhyron Shadesong from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,8567.44,973.9194,547.9177, 'Fhyron Shadesong'),
(@ENTRY,2,8568.162,947.0933,547.8038, 'Fhyron Shadesong'),
(@ENTRY,3,8566.031,913.37,548.2927, 'Fhyron Shadesong'),
(@ENTRY,4,8564.706,894.527,547.6705, 'Fhyron Shadesong'),
(@ENTRY,5,8567.681,876.0731,547.5937, 'Fhyron Shadesong'),
(@ENTRY,6,8578.911,863.8034,548.4218, 'Fhyron Shadesong'),
(@ENTRY,7,8590.869,849.7815,547.6718, 'Fhyron Shadesong'),
(@ENTRY,8,8603.909,853.178,548.1281, 'Fhyron Shadesong'),
(@ENTRY,9,8599.38,855.512,547.715, 'Fhyron Shadesong'),
(@ENTRY,10,8591.701,868.5342,549.3784, 'Fhyron Shadesong'),
(@ENTRY,11,8586.77,871.798,547.876, 'Fhyron Shadesong'),
(@ENTRY,12,8586.149,883.8123,549.2509, 'Fhyron Shadesong'),
(@ENTRY,13,8583.74,886.251,548.96, 'Fhyron Shadesong'),
(@ENTRY,14,8582.075,903.0688,550.0374, 'Fhyron Shadesong'),
(@ENTRY,15,8585.078,918.2136,548.6675, 'Fhyron Shadesong'),
(@ENTRY,16,8581.65,944.137,547.897, 'Fhyron Shadesong'),
(@ENTRY,17,8582.839,948.3386,547.6221, 'Fhyron Shadesong'),
(@ENTRY,18,8565.45,986.6495,549.3403, 'Fhyron Shadesong'),
(@ENTRY,19,8570.5,989.399,547.629, 'Fhyron Shadesong'),
(@ENTRY,20,8576.626,1006.561,549.2132, 'Fhyron Shadesong'),
(@ENTRY,21,8586.87,1008.438,548.1278, 'Fhyron Shadesong'),
(@ENTRY,22,8590.46,1005.12,547.563, 'Fhyron Shadesong'),
(@ENTRY,23,8599.41,1007.08,547.419, 'Fhyron Shadesong'),
(@ENTRY,24,8602.17,1013.39,548.185, 'Fhyron Shadesong'),
(@ENTRY,25,8604.88,1030.23,556.734, 'Fhyron Shadesong'),
(@ENTRY,26,8612.658,1035.293,558.3499, 'Fhyron Shadesong'),
(@ENTRY,27,8611.47,1039.23,558.735, 'Fhyron Shadesong'),
(@ENTRY,28,8613.692,1042.313,558.3265, 'Fhyron Shadesong'),
(@ENTRY,29,8603.88,1044.65,558.38, 'Fhyron Shadesong'),
(@ENTRY,30,8598.02,1072.57,557.923, 'Fhyron Shadesong'),
(@ENTRY,31,8602.397,1081.373,558.2934, 'Fhyron Shadesong'),
(@ENTRY,32,8597.45,1089.27,557.317, 'Fhyron Shadesong'),
(@ENTRY,33,8600.864,1092.901,557.4839, 'Fhyron Shadesong'),
(@ENTRY,34,8593.38,1084.72,556.817, 'Fhyron Shadesong'),
(@ENTRY,35,8578.9,1068.6,557.38, 'Fhyron Shadesong'),
(@ENTRY,36,8563.31,1065.51,554.057, 'Fhyron Shadesong'),
(@ENTRY,37,8549.85,1061.87,550.61, 'Fhyron Shadesong'),
(@ENTRY,38,8547.754,1051.273,550.2899, 'Fhyron Shadesong'),
(@ENTRY,39,8544.317,1042.702,549.2928, 'Fhyron Shadesong'),
(@ENTRY,40,8557.891,1029.923,548.1677, 'Fhyron Shadesong'),
(@ENTRY,41,8566.168,1017.246,548.1677, 'Fhyron Shadesong'),
(@ENTRY,42,8570.943,1008.467,548.2927, 'Fhyron Shadesong');
-- Change InhabitType for 33787 "Tournament Druid Spell Target"
UPDATE `creature_template` SET `InhabitType`=1 WHERE `entry`=33787;

-- Quest: Bring 'Em Back Alive (11690)
UPDATE `creature_template` SET `AIName`='SmartAI',`spell1`=45877  WHERE `entry`=25596;
DELETE FROM `smart_scripts` WHERE `entryorguid`=25596 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(25596,0,0,0,27,0,100,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Infected Kodo Beast - On passager boarded - Remove death state'),
(25596,0,1,0,31,0,100,0,45877,0,0,0,41,0,0,0,0,0,0,22,0,0,0,0,0,0,0, 'Infected Kodo Beast - On Spell Hit - Despawn'),
(25596,0,2,0,0,0,100,0,3500,4500,15600,17800,11,45876,0,0,0,0,0,2,1,0,0,0,0,0,0, 'Infected Kodo Beast - Cast Stampede');

DELETE FROM `npc_spellclick_spells` where `npc_entry`=25596;
INSERT INTO `npc_spellclick_spells`(`npc_entry`,`spell_id`,`quest_start`,`quest_start_active`,`quest_end`,`cast_flags`,`aura_required`,`aura_forbidden`,`user_type`) values 
(25596,45875,11690,1,11690,0,0,0,0);

-- Ol' Sooty - SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=1225;
DELETE FROM `smart_scripts` WHERE `id`=0 AND `entryorguid`=1225;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1225,0,0,0,11,0,100,0,0,0,0,0,53,0,1225,1,0,0,0,1,0,0,0,0,0,0,0,'Ol'' Sooty - On spawn - Load waypoints');
-- Ol' Sooty - Waypoints
DELETE FROM `waypoints` WHERE `entry`=1225;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES 
(1225,1,-5716.181152,-3110.810791,316.686523,'Ol'' Sooty'),
(1225,2,-5716.187012,-3093.080078,325.600677,'Ol'' Sooty'),
(1225,3,-5712.214355,-3090.297607,327.738647,'Ol'' Sooty'),
(1225,4,-5705.484375,-3092.523438,329.362366,'Ol'' Sooty'),
(1225,5,-5681.826660,-3110.568848,338.121887,'Ol'' Sooty'),
(1225,6,-5659.498535,-3122.215576,344.336151,'Ol'' Sooty'),
(1225,7,-5639.585938,-3124.536133,348.404938,'Ol'' Sooty'),
(1225,8,-5618.112793,-3110.905762,360.618225,'Ol'' Sooty'),
(1225,9,-5621.486816,-3096.315918,368.247772,'Ol'' Sooty'),
(1225,10,-5632.212891,-3078.608398,374.990936,'Ol'' Sooty'),
(1225,11,-5629.793457,-3056.124023,384.465576,'Ol'' Sooty'),
(1225,12,-5642.278809,-3036.872314,385.471649,'Ol'' Sooty'),
(1225,13,-5609.369141,-3006.883301,386.288177,'Ol'' Sooty'),
(1225,14,-5643.634277,-3036.388672,385.531891,'Ol'' Sooty'),
(1225,15,-5630.174805,-3057.015869,384.385712,'Ol'' Sooty'),
(1225,16,-5629.840332,-3065.496338,381.129578,'Ol'' Sooty'),
(1225,17,-5634.866211,-3078.448975,374.489044,'Ol'' Sooty'),
(1225,18,-5620.416504,-3101.081543,364.819855,'Ol'' Sooty'),
(1225,19,-5624.629395,-3117.040527,354.493805,'Ol'' Sooty'),
(1225,20,-5644.949707,-3125.081787,347.271362,'Ol'' Sooty'),
(1225,21,-5660.741699,-3121.580566,343.975922,'Ol'' Sooty'),
(1225,22,-5676.210938,-3111.586914,340.021484,'Ol'' Sooty'),
(1225,23,-5691.895508,-3102.994385,333.646698,'Ol'' Sooty'),
(1225,24,-5711.662109,-3088.433594,328.761566,'Ol'' Sooty'),
(1225,25,-5717.663574,-3099.033691,321.686920,'Ol'' Sooty'),
(1225,26,-5705.214844,-3132.324219,315.837585,'Ol'' Sooty'),
(1225,27,-5679.014160,-3185.046875,319.508057,'Ol'' Sooty');

-- SAI for Thoralius the Wise
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23975;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23975;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (2397500,2397501,2397502,2397503);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI Section
(23975,0,0,1,1,0,100,0,60000,120000,300000,300000,91,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - every 5 min Stand'),
(23975,0,1,0,61,0,100,0,0,0,0,0,53,0,23975,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Start WP'),
(23975,0,2,0,40,0,100,0,2,23975,0,0,80,2397500,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Load script 1 at WP 2'),
(23975,0,3,0,40,0,100,0,4,23975,0,0,80,2397501,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Load script 2 at WP 4'),
(23975,0,4,0,40,0,100,0,7,23975,0,0,80,2397502,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Load script 3 at WP 7'),
(23975,0,5,0,40,0,100,0,8,23975,0,0,80,2397503,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Load script 4 at WP 8'),
-- Script 1
(2397500,9,0,0,0,0,100,0,0,0,0,0,54,4000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Pause at WP 2'),
(2397500,9,1,0,0,0,100,0,0,0,0,0,11,42837,3,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Cast 42837'),
(2397500,9,2,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,19,24046,0,0,0,0,0,0, 'Thoralius the Wise - Turn to face spirit Totem (Fire)'),
(2397500,9,3,0,0,0,100,0,500,500,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - say text 0'),
-- Script 2
(2397501,9,0,0,0,0,100,0,0,0,0,0,54,4000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Pause at WP 4'),
(2397501,9,1,0,0,0,100,0,0,0,0,0,11,42838,3,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Cast 42838'),
(2397501,9,2,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,19,24045,0,0,0,0,0,0, 'Thoralius the Wise - Turn to face spirit Totem (Water)'),
(2397501,9,3,0,0,0,100,0,500,500,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Say text 1'),
-- Script 3
(2397502,9,0,0,0,0,100,0,0,0,0,0,54,53000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Pause at WP 7'),
(2397502,9,1,0,0,0,100,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Do text 2'),
(2397502,9,2,0,0,0,100,0,1000,1000,0,0,17,64,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - do emote state STATE_STUN'),
(2397502,9,3,0,0,0,100,0,45000,45000,0,0,17,26,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - do emote state STATE_STAND'),
(2397502,9,4,0,0,0,100,0,2000,2000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Do text 3'),
-- Script 4
(2397503,9,0,0,0,0,100,0,8,23975,0,0,55,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Stop at WP 8'),
(2397503,9,1,0,0,0,100,0,500,500,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - Reset heading at WP 8'),
(2397503,9,2,0,0,0,100,0,500,500,0,0,90,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thoralius the Wise - sit at WP 8');

-- NPC talk text insert
DELETE FROM `creature_text` WHERE `entry`=23975;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(23975,0,0, 'Fire grant me vision...',0,7,100,20,0,0, 'Thoralius the Wise'),
(23975,1,0, 'Water grant me serenity...',0,7,100,20,0,0, 'Thoralius the Wise'),
(23975,2,0, '%s inhales the wispy smoke tendrils emanating from the burner.',2,7,100,0,0,0, 'Thoralius the Wise'),
(23975,3,0, 'Thank you, spirits.',0,7,100,2,0,0, 'Thoralius the Wise');

-- Waypoints for Thoralius the Wise from sniff
DELETE FROM `waypoints` WHERE `entry`=23975;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(23975,1,637.177,-5011.109,4.653919,'Thoralius the Wise WP 1'),
(23975,2,634.8372,-5010.296,4.528919,'Thoralius the Wise WP 2'),
(23975,3,637.9232,-5015.031,4.528919,'Thoralius the Wise WP 3'),
(23975,4,636.0419,-5016.675,4.153919,'Thoralius the Wise WP 4'),
(23975,5,638.2552,-5013.186,4.653919,'Thoralius the Wise WP 5'),
(23975,6,637.7585,-5013.268,4.653919,'Thoralius the Wise WP 6'),
(23975,7,636.8245,-5013.386,4.528919,'Thoralius the Wise WP 7'),
(23975,8,638.2552,-5013.186,4.653919,'Thoralius the Wise WP 8');

-- Add spell target positions
DELETE FROM `spell_target_position` WHERE `id` IN (42837,42838);
INSERT INTO `spell_target_position` (`id`,`target_map`,`target_position_x`,`target_position_y`,`target_position_z`,`target_orientation`) VALUES
(42837,571,634.094,-5010.67,4.419494,2.807002),
(42838,571,635.081,-5016.87,4.138474,3.859472);

-- Valiance Keep Footman SAI (tested) 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=25253;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-111383,-111377,-111378,-111382,-111379,-111380);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-111383,0,0,0,1,0,100,0,1000,2000,4000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 4-5 sec'),
(-111377,0,0,0,1,0,100,0,3000,4000,4000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 4-5 sec'),
(-111378,0,0,0,1,0,100,0,8000,8000,16000,16000,10,4,5,21,0,0,0,1,0,0,0,0,0,0,0,'Random cheer emote every 16 sec'),
(-111382,0,0,0,1,0,100,0,16000,16000,16000,16000,10,4,5,21,0,0,0,1,0,0,0,0,0,0,0,'Random cheer emote every 16 sec'),
(-111379,0,0,0,1,0,100,0,2000,2000,5000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 5 sec'),
(-111379,0,1,0,1,0,100,0,4000,4000,7000,7000,5,36,0,0,0,0,0,10,111376,25253,0,0,0,0,0,'Attack emote dueler 2 sec later sec'),
(-111380,0,0,0,1,0,100,0,5000,5000,5000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 5 sec'),
(-111380,0,1,0,1,0,100,0,7000,7000,7000,7000,5,36,0,0,0,0,0,10,111381,25253,0,0,0,0,0,'Attack emote dueler 2 sec later sec');

-- Azure Front Channel Stalker SAI (tested working)
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=31400;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-203457,-111746,-111726,-111742);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-203457,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,111746,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned'),
(-111746,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,111726,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned'),
(-111726,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,111742,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned'),
(-111742,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,203520,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned');

-- Surge Needle Sorcerer SAI
SET @ELMGUID := 113473;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26257;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (26257,-109558,-109559,-109560,-109561,-109563,-109564,-109565,-109569,-109570,-109571,-109572,-109578);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26257,0,2,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109558,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109558,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109559,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109559,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109560,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109560,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109561,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109561,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109563,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109563,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109564,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109564,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109565,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109565,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109569,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109569,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109570,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109570,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109571,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109571,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109572,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109572,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim'),
(-109578,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Surge Needle Sorcerer - On reset - Cast Surge Needle Beam'),
(-109578,0,1,0,0,0,100,0,3000,4000,3000,5000,11,51797,0,0,0,0,0,2,0,0,0,0,0,0,0,'Surge Needle Sorcerer - Combat - Cast Arcane Blast on victim');

-- Goramosh SAI
SET @ELMGUID := 113473;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26349;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (26349);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26349,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Goramosh - On reset - Cast Surge Needle Beam'),
(26349,0,1,0,2,0,100,1,0,50,0,0,11,20828,0,0,0,0,0,2,0,0,0,0,0,0,0,'Goramosh - Health level - Cast Cone of Cold on victim at 50%'),
(26349,0,2,0,0,0,100,0,3500,3500,3500,3500,11,9672,0,0,0,0,0,2,0,0,0,0,0,0,0,'Goramosh - Combat - Cast Frost Bolt on victim');

-- Arcanimus SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26370;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (26370);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26370,0,0,0,1,0,100,1,2000,2000,2000,2000,45,0,1,0,0,0,0,10,113473,26298,0,0,0,0,0, 'Arcanimus - On reset - Set data 0 = 1 on bunny'),
(26370,0,1,0,1,0,100,1,0,0,0,0,11,46934,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - On reset - Aura Arcane Force Shield (Blue x2)'),
(26370,0,2,3,4,0,100,0,0,0,0,0,28,46934,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Remove Cosmetic - Arcane Force Shield (Blue x2) Aura on aggro'),
(26370,0,3,0,61,0,100,0,0,0,0,0,28,46906,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Remove Cosmetic - Surge Needle Beam on aggro'),
(26370,0,4,0,2,0,100,1,71,80,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Health level - Cast Arcane Explosion on self at 80%'),
(26370,0,5,0,2,0,100,1,41,60,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Health level - Cast Arcane Explosion on self at 60%'),
(26370,0,6,0,2,0,100,1,21,40,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Health level - Cast Arcane Explosion on self at 40%'),
(26370,0,7,0,2,0,100,1,1,20,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Health level - Cast Arcane Explosion on self at 20%');

-- ELM General Purpose Bunny (scale x0.01) Large SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26298;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-113473);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-113473,0,0,0,11,0,100,0,0,0,0,0,11,32566,2,0,0,0,0,1,0,0,0,0,0,0,0,'ELM General Purpose Bunny - On spawn - Aura Purple Banish State'),
(-113473,0,1,2,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'ELM General Purpose Bunny - On Data set - Reset data 0 = 0'),
(-113473,0,2,0,61,0,100,0,0,0,0,0,11,46906,2,0,0,0,0,10,96298,26370,0,0,0,0,0, 'ELM General Purpose Bunny - On Data set - Cast Surge Needle Beam on Arcanimus');

-- Pathing for Thulrin SAI
-- Remove old waypoint data and scripts
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=2352.691,`position_y`=5268.956,`position_z`=7.668962 WHERE `guid`=110115;
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid`=110115;
DELETE FROM `waypoint_data` WHERE `id`=1101150;
DELETE FROM waypoint_scripts WHERE `id` BETWEEN 1117 AND 1119;
-- SAI for Thulrin
UPDATE `creature_template` SET `AIName`='SmartAI',`equipment_id`=0 WHERE `entry`=25239;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=25239;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (2523900,2523901);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI
(25239,0,0,0,11,0,100,0,0,0,0,0,53,0,25239,1,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Start WP movement'),
(25239,0,1,0,40,0,100,0,4,25239,0,0,80,2523900,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Load script 1 at WP 4'),
(25239,0,2,0,40,0,100,0,9,25239,0,0,80,2523901,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Load script 2 at WP 9'),
-- Script 1
(2523900,9,0,0,0,0,100,0,0,0,0,0,54,1500,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Pause at WP 4'),
(2523900,9,1,0,0,0,100,0,0,0,0,0,5,16,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Emote ONESHOT_KNEEL'),
(2523900,9,2,0,0,0,100,0,1000,1000,0,0,71,344,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Equip sword'),
-- Script 2
(2523901,9,0,0,0,0,100,0,0,0,0,0,54,51000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Pause at WP 9'),
(2523901,9,1,0,0,0,100,0,500,500,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,2.984513, 'Thulrin - Turn to pos'),
(2523901,9,2,0,0,0,100,0,1000,1000,0,0,17,133,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Emote STATE_USESTANDING_NOSHEATHE'),
(2523901,9,3,0,0,0,100,0,48000,48000,0,0,71,10000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Equip nothing'),
(2523901,9,4,0,0,0,100,0,0,0,0,0,17,26,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thulrin - Emote STATE_STAND');
-- Waypoints for Thulrin from sniff
DELETE FROM `waypoints` WHERE `entry`=25239;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(25239,1,2347.805,5265.343,7.630844, 'Thulrin WP 1'),
(25239,2,2344.542,5267.178,7.668962, 'Thulrin WP 2'),
(25239,3,2340.221,5270.315,7.668962, 'Thulrin WP 3'),
(25239,4,2336.553,5273.868,7.793962, 'Thulrin WP 4'),
(25239,5,2339.075,5271.176,7.668962, 'Thulrin WP 5'),
(25239,6,2346.919,5265.093,7.630844, 'Thulrin WP 6'),
(25239,7,2351.8,5266.425,7.630844, 'Thulrin WP 7'),
(25239,8,2352.691,5268.956,7.668962, 'Thulrin WP 8'),
(25239,9,2352.691,5268.956,7.668962, 'Thulrin WP 9');

-- Frozen Earth SAI
SET @ENTRY   := 28411; -- NPC entry
SET @TARGET  := 23837; -- ELM General Porpose Bunny
SET @SPELL1  := 54532; -- Ice Spike
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@ENTRY,-119784,-119944,-119945,-119947,-119949,-119951,-119968,-119991);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119784,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119784,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119944,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119944,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119945,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119945,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119947,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119947,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119949,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119949,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119951,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119951,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119968,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119968,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim'),
(-119991,0,0,0,1,0,100,0,1000,4000,4000,7000,11,51590,2,0,0,0,0,11,@TARGET,120,0,0,0,0,0,'Frozen Earth - OOC - Cast Toss Ice Boulder'),
(-119991,0,1,0,0,0,100,0,1000,4000,10000,17000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Frozen Earth - Combat - Cast Ice Spike on victim');
-- Fix Spell condition for Spell 51590 to only target ELM General Porpose Bunny
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=51590;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,0,51590,0,18,1,23837,0,0,'','Spell 51590 targets only ELM General Porpose Bunny');

-- Scourge Deathspeaker SAI 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=27615;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=27615;
DELETE FROM `smart_scripts` WHERE `entryorguid`=27615;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27615,0,0,1,1,0,100,1,1000,1000,1000,1000,11,49119,2,0,0,0,0,10,101497,27452,0,0,0,0,0,'Scourge Deathspeaker - Spawn & reset - channel Fire Beam'),
(27615,0,1,0,61,0,100,1,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - Spawn & reset - Prevent Combat Movement'),
(27615,0,2,3,4,0,100,1,0,0,0,0,11,52282,2,0,0,0,0,2,0,0,0,0,0,0,0,'Scourge Deathspeaker - On aggro - Cast Fireball'),
(27615,0,3,0,61,0,100,1,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - On aggro - Set phase 1'),
(27615,0,4,0,9,1,100,0,3000,3000,3400,4800,11,52282,1,0,0,0,0,2,0,0,0,0,0,0,0,'Scourge Deathspeaker - in combat - Cast Fireball (phase 1)'),
(27615,0,5,0,9,1,100,0,35,80,1000,1000,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 35 Yards - Start Combat Movement (phase 1)'),
(27615,0,6,0,9,1,100,0,5,15,1000,1000,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15 Yards - Prevent Combat Movement (phase 1)'),
(27615,0,7,0,9,1,100,0,0,5,1000,1000,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - Below 5 Yards - Start Combat Movement (phase 1)'),
(27615,0,8,0,3,1,100,1,0,7,0,0,22,2,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - Mana at 7% - Set Phase 2 (phase 1)'),
(27615,0,9,0,0,2,100,1,0,0,0,0,21,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - In combat - Allow Combat Movement (phase 2)'),
(27615,0,10,0,3,2,100,1,15,100,100,100,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - Mana above 15% - Set Phase 1 (phase 2)'),
(27615,0,11,0,2,0,100,1,0,30,120000,130000,11,52281,0,0,0,0,0,2,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Cast Flame of the Seer'),
(27615,0,12,0,2,0,100,1,0,15,0,0,22,3,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Set Phase 3'),
(27615,0,13,0,2,4,100,1,0,15,0,0,21,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Allow Combat Movement (phase 3)'),
(27615,0,14,15,2,4,100,1,0,15,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Flee (phase 3)'),
(27615,0,15,0,61,4,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Scourge Deathspeaker - At 15% HP - Say text0 (Phase 3)');

-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry` IN (27615);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(27615,0,0, '%s attempts to run away in fear!',2,0,100,0,0,0, 'Scourge Deathspeaker');

-- SET InhabitType for Invisible Stalker Grizzly Hills
UPDATE `creature_template` SET `InhabitType`=7 WHERE `entry`=27452;

-- Add missing Invisible Stalker (Floating)
SET @GUID := 85175; -- 2 Required
DELETE FROM `creature` WHERE `guid` BETWEEN @GUID AND @GUID+1; 
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES
(@GUID,23033,571,1,1,0,0,3799.331,3428.748,92.80447,3.804818,120,0,0,1,0,0,0),
(@GUID+1,23033,571,1,1,0,0,3789.681,3434.306,92.37619,4.764749,120,0,0,1,0,0,0);
-- High Priest Talet-Kha Fixup
SET @ENTRY  := 26073; -- NPC entry
SET @SPELL1 := 45492; -- Shadow Nova
SET @SPELL2 := 11640; -- Renew         cast once below 45%
SET @SPELL3 := 15587; -- Mind Blast    cast below 45% after renew 
UPDATE `creature` SET `modelid`=0,`spawndist`=0,`MovementType`=0 WHERE `id`=@ENTRY;
DELETE FROM `creature_addon` WHERE `guid`=85240;
DELETE FROM `creature_template_addon` WHERE `entry`=26073;
INSERT INTO `creature_template_addon` (`entry`,`bytes1`,`bytes2`) VALUES (26073,1,1);
-- SAI for High Priest Talet-Kha
UPDATE `creature_template` SET `speed_run`=1,`faction_H`=21,`InhabitType`=7,`AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - On spawn - Set React State civilian'),
(@ENTRY,0,1,2,1,0,100,1,1000,1000,1000,1000,70,0,0,0,0,0,0,10,85098,25422,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Respawn Mystical Webbing'),
(@ENTRY,0,2,3,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,10,85098,25422,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Set data Mystical Webbing'),
(@ENTRY,0,3,4,61,0,100,0,0,0,0,0,70,0,0,0,0,0,0,10,85118,25422,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Respawn Mystical Webbing'),
(@ENTRY,0,4,5,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,10,85118,25422,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Set data Mystical Webbing'),
(@ENTRY,0,5,6,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,10,85175,23033,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Set data Invisible Stalker'),
(@ENTRY,0,6,0,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,10,85176,23033,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Set data Invisible Stalker'),
(@ENTRY,0,7,0,1,0,100,0,3000,3000,3000,3000,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Set phase 1'),
(@ENTRY,0,8,0,23,1,100,1,45497,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - On Aura missing - Run Script (Phase 1)'),
(@ENTRY,0,9,10,2,1,100,0,0,45,0,0,11,11640,1,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - Health 45% - Cast Renew on self'),
(@ENTRY,0,10,0,61,1,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - OOC - Set phase 2'),
(@ENTRY,0,11,0,0,2,100,0,1500,1500,1500,1500,11,15587,0,0,0,0,0,2,0,0,0,0,0,0,0, 'High Priest Talet-Kha - Combat - Cast Mind Blast on victim (Phase 2)'),
(@ENTRY*100,9,0,0,0,0,100,0,3000,3000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - script - Text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,500,500,0,0,69,0,0,0,0,0,0,1,0,0,0,3788.444,3418.249,85.05618,0, 'High Priest Talet-Kha - script - Move to'),
(@ENTRY*100,9,2,0,0,0,100,0,500,500,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,1.1672, 'High Priest Talet-Kha - script - turn to'),
(@ENTRY*100,9,3,0,0,0,100,0,1500,1500,0,0,91,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - script - Bytes1 set to 0'),
(@ENTRY*100,9,4,0,0,0,100,0,100,100,0,0,19,33555200,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - script - Remove unitflags'),
(@ENTRY*100,9,5,0,0,0,100,0,100,100,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - script - Set React State Hostile'),
(@ENTRY*100,9,6,0,0,0,100,0,100,100,0,0,11,@SPELL1,1,0,0,0,0,1,0,0,0,0,0,0,0, 'High Priest Talet-Kha - script - Aura self');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry` IN (26073);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(26073,0,0, 'Who disturbs my meditation?!',1,7,100,15,0,0, 'High Priest Talet-Kha');
-- SAI for Mystical Webbing
SET @ENTRY := 25422; -- NPC entry
SET @CHANNEL := 45497; -- Web Beam
SET @TARGET  := 26073; -- High Priest Talet-Kha
UPDATE `creature_template` SET `faction_H`=21,`AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-85098,-85118);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-85098,0,0,0,11,0,100,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Mystical Webbing - On spawn - Set React State civilian'),
(-85098,0,1,0,1,0,100,1,1000,1000,1000,1000,11,@CHANNEL,2,0,0,0,0,11,@TARGET,40,0,0,0,0,0, 'Mystical Webbing - On spawn & reset - Web Beam'),
(-85098,0,2,0,6,0,100,1,0,0,0,0,45,0,2,0,0,0,0,10,85176,23033,0,0,0,0,0, 'Mystical Webbing - On death - set data 0 2 Invisible Stalker'),
(-85098,0,3,4,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 1 - set data 0 0'),
(-85098,0,4,0,61,0,100,0,0,0,0,0,70,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 1 - reset AI'),
(-85118,0,0,0,11,0,100,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Mystical Webbing - On spawn - Set React State civilian'),
(-85118,0,1,0,1,0,100,1,1000,1000,1000,1000,11,@CHANNEL,2,0,0,0,0,11,@TARGET,40,0,0,0,0,0, 'Mystical Webbing - On spawn & reset - Web Beam'),
(-85118,0,2,0,6,0,100,1,0,0,0,0,45,0,2,0,0,0,0,10,85175,23033,0,0,0,0,0, 'Mystical Webbing - On death - set data 0 2 Invisible Stalker'),
(-85118,0,3,4,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 1 - set data 0 0'),
(-85118,0,4,0,61,0,100,0,0,0,0,0,70,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 1 - reset AI');
-- SAI for Invisible Stalker (Floating)
SET @ENTRY := 23033; -- NPC entry
SET @CHANNEL := 45497; -- Web Beam
SET @TARGET  := 26073; -- High Priest Talet-Kha
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-85175,-85176);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- Invisible Stalker (Floating)
(-85175,0,0,0,38,0,100,0,0,1,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 1 - Set Phase 1'),
(-85175,0,1,0,38,0,100,0,0,2,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 2 - Set Phase 2'),
(-85175,0,2,3,1,1,100,0,0,0,0,0,11,@CHANNEL,2,0,0,0,0,11,@TARGET,40,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Cast Web Beam on target (Phase 1)'),
(-85175,0,3,4,61,1,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Set data 0 0 (Phase 1)'),
(-85175,0,4,0,61,1,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Set Phase 0 (Phase 1)'),
(-85175,0,5,6,1,2,100,0,0,0,0,0,92,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Stop casting (Phase 2)'),
(-85175,0,6,0,61,2,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Set Phase 0 (Phase 2)'),
-- Invisible Stalker (Floating)
(-85176,0,0,0,38,0,100,0,0,1,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 1 - Set Phase 1'),
(-85176,0,1,0,38,0,100,0,0,2,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - On dataset 0 2 - Set Phase 2'),
(-85176,0,2,3,1,1,100,0,0,0,0,0,11,@CHANNEL,2,0,0,0,0,11,@TARGET,40,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Cast Web Beam on target (Phase 1)'),
(-85176,0,3,4,61,1,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Set data 0 0 (Phase 1)'),
(-85176,0,4,0,61,1,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Set Phase 0 (Phase 1)'),
(-85176,0,5,6,1,2,100,0,0,0,0,0,92,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Stop casting (Phase 2)'),
(-85176,0,6,0,61,2,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisible Stalker (Floating) - OOC - Set Phase 0 (Phase 2)');

-- Pathing for Stormfleet Deckhand SAI
SET @ENTRY := 25234;
SET @PATH1 := @ENTRY*100;
SET @PATH2 := @ENTRY*100+1;
SET @PATH3 := @ENTRY*100+2;
SET @PATH4 := @ENTRY*100+3;
-- Remove old waypoint data and scripts
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=2265.704,`position_y`=5314.686,`position_z`=22.43809 WHERE `guid`=109653;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=2253.791,`position_y`=5252.389,`position_z`=35.69936 WHERE `guid`=109654;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=2220.033,`position_y`=5292.010,`position_z`=10.70095 WHERE `guid`=109652;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=2233.497,`position_y`=5291.667,`position_z`=11.21773 WHERE `guid`=109655;
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid` IN (109653,109654,109652,109655);
DELETE FROM `waypoint_data` WHERE `id` IN (1096530,1096540,1096520,1096550);
DELETE FROM `waypoint_scripts` WHERE `id` IN (1057,1058,1059,1060,1061,1130,1131,1132,1133);
-- SAI for Stormfleet Deckhand
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-109653,-109654,-109652,-109655);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1,@ENTRY*100+2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-109653,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH1,1,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - On spawn - Start WP movement'),
(-109653,0,1,2,40,0,100,0,4,@PATH1,0,0,54,10000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 4 - pause wp'),
(-109653,0,2,0,61,0,100,0,0,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 4 - run script'),
(-109653,0,3,4,40,0,100,0,8,@PATH1,0,0,54,21000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 8 - pause wp'),
(-109653,0,4,5,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.794493, 'Stormfleet Deckhand - Reach wp 8 - turn to'),
(-109653,0,5,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 8 - run script'),
(-109654,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH2,1,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - On spawn - Start WP movement'),
(-109654,0,1,2,40,0,100,0,6,@PATH2,0,0,54,10000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 6 - pause wp'),
(-109654,0,2,0,61,0,100,0,0,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 6 - run script'),
(-109654,0,3,4,40,0,100,0,13,@PATH2,0,0,54,21000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 13 - pause wp'),
(-109654,0,4,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 13 - run script'),
(-109652,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH3,1,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - On spawn - Start WP movement'),
(-109652,0,1,2,40,0,100,0,17,@PATH3,0,0,54,10000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 17 - pause wp'),
(-109652,0,2,0,61,0,100,0,0,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 17 - run script'),
(-109652,0,3,4,40,0,100,0,9,@PATH3,0,0,54,21000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 9 - pause wp'),
(-109652,0,4,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 9 - run script'),
(-109655,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH4,1,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - On spawn - Start WP movement'),
(-109655,0,1,2,40,0,100,0,3,@PATH4,0,0,54,11000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 3 - pause wp'),
(-109655,0,2,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 3 - run script'),
(-109655,0,3,4,40,0,100,0,13,@PATH4,0,0,54,11000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 13 - pause wp'),
(-109655,0,4,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 13 - run script'),
(-109655,0,5,6,40,0,100,0,16,@PATH4,0,0,54,11000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 16 - pause wp'),
(-109655,0,6,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 16 - run script'),
(-109655,0,7,8,40,0,100,0,25,@PATH4,0,0,54,11000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 25 - pause wp'),
(-109655,0,8,9,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.969026, 'Stormfleet Deckhand - Reach wp 25 - turn to'),
(-109655,0,9,0,61,0,100,0,0,0,0,0,80,@ENTRY*100+2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - Reach wp 25 - run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,90,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - set bytes1'),
(@ENTRY*100,9,1,0,0,0,100,0,10000,10000,0,0,91,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - remove bytes1'),
(@ENTRY*100+1,9,0,0,0,0,100,0,3000,3000,0,0,5,22,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - emote'),
(@ENTRY*100+1,9,1,0,0,0,100,0,6000,6000,0,0,5,70,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - emote'),
(@ENTRY*100+1,9,2,0,0,0,100,0,6000,6000,0,0,5,22,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - emote'),
(@ENTRY*100+2,9,0,0,0,0,100,0,1000,1000,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - set state STATE_USESTANDING'),
(@ENTRY*100+2,9,1,0,0,0,100,0,8000,8000,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - set state NONE'),
(@ENTRY*100+2,9,2,0,0,0,100,0,0,0,0,0,90,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - set bytes1'),
(@ENTRY*100+2,9,3,0,0,0,100,0,2000,2000,0,0,91,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stormfleet Deckhand - script - remove bytes1');
-- Waypoints for Stormfleet Deckhand from sniff
DELETE FROM `waypoints` WHERE `entry` IN (@PATH1,@PATH2,@PATH3,@PATH4);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@PATH1,1,2261.388,5305.248,21.68184, 'Stormfleet Deckhand'),
(@PATH1,2,2259.963,5295.583,20.08975, 'Stormfleet Deckhand'),
(@PATH1,3,2260.002,5286.996,15.49093, 'Stormfleet Deckhand'),
(@PATH1,4,2257.711,5281.927,12.09341, 'Stormfleet Deckhand'),
(@PATH1,5,2261.763,5286.725,15.76729, 'Stormfleet Deckhand'),
(@PATH1,6,2260.902,5294.649,19.95268, 'Stormfleet Deckhand'),
(@PATH1,7,2263.460,5304.816,21.72922, 'Stormfleet Deckhand'),
(@PATH1,8,2265.704,5314.686,22.43809, 'Stormfleet Deckhand'),
(@PATH2,1,2248.875,5255.391,36.45885, 'Stormfleet Deckhand'),
(@PATH2,2,2246.625,5256.641,37.20885, 'Stormfleet Deckhand'),
(@PATH2,3,2244.625,5258.641,36.45885, 'Stormfleet Deckhand'),
(@PATH2,4,2241.625,5258.391,37.20885, 'Stormfleet Deckhand'),
(@PATH2,5,2238.625,5259.391,36.45885, 'Stormfleet Deckhand'),
(@PATH2,6,2232.960,5260.392,35.71835, 'Stormfleet Deckhand'),
(@PATH2,7,2235.375,5260.141,36.20885, 'Stormfleet Deckhand'),
(@PATH2,8,2239.375,5259.141,36.45885, 'Stormfleet Deckhand'),
(@PATH2,9,2241.625,5258.641,37.20885, 'Stormfleet Deckhand'),
(@PATH2,10,2244.625,5258.641,36.45885, 'Stormfleet Deckhand'),
(@PATH2,11,2247.125,5256.391,37.20885, 'Stormfleet Deckhand'),
(@PATH2,12,2249.125,5255.391,36.45885, 'Stormfleet Deckhand'),
(@PATH2,13,2253.791,5252.389,35.69936, 'Stormfleet Deckhand'),
(@PATH3,1,2212.298,5281.927,10.82595, 'Stormfleet Deckhand'),
(@PATH3,2,2211.701,5275.361,10.82595, 'Stormfleet Deckhand'),
(@PATH3,3,2224.383,5268.124,7.166187, 'Stormfleet Deckhand'),
(@PATH3,4,2235.353,5264.704,8.606246, 'Stormfleet Deckhand'),
(@PATH3,5,2244.243,5262.414,11.81635, 'Stormfleet Deckhand'),
(@PATH3,6,2248.373,5259.464,11.78494, 'Stormfleet Deckhand'),
(@PATH3,7,2247.781,5252.418,11.96684, 'Stormfleet Deckhand'),
(@PATH3,8,2246.383,5249.14,15.53435, 'Stormfleet Deckhand'),
(@PATH3,9,2243.871,5243.415,21.4974, 'Stormfleet Deckhand'),
(@PATH3,10,2245.975,5248.252,16.51618, 'Stormfleet Deckhand'),
(@PATH3,11,2248.437,5255.79,11.86939, 'Stormfleet Deckhand'),
(@PATH3,12,2248.403,5261.318,11.747, 'Stormfleet Deckhand'),
(@PATH3,13,2228.012,5267.475,7.16457, 'Stormfleet Deckhand'),
(@PATH3,14,2215.574,5274.178,11.13563, 'Stormfleet Deckhand'),
(@PATH3,15,2213.556,5283.097,10.82595, 'Stormfleet Deckhand'),
(@PATH3,16,2218.244,5291.424,10.70095, 'Stormfleet Deckhand'),
(@PATH3,17,2224.214,5293.65,10.82595, 'Stormfleet Deckhand'),
(@PATH3,18,2220.033,5292.01,10.70095, 'Stormfleet Deckhand'),
(@PATH4,1,2232.031,5289.312,11.11433, 'Stormfleet Deckhand'),
(@PATH4,2,2229.514,5285.923,11.22073, 'Stormfleet Deckhand'),
(@PATH4,3,2231.239,5285.13,11.22661, 'Stormfleet Deckhand'),
(@PATH4,4,2229.854,5285.705,11.22414, 'Stormfleet Deckhand'),
(@PATH4,5,2228.48,5291.178,11.13671, 'Stormfleet Deckhand'),
(@PATH4,6,2226.165,5291.41,10.95095, 'Stormfleet Deckhand'),
(@PATH4,7,2223.731,5291.465,10.82595, 'Stormfleet Deckhand'),
(@PATH4,8,2218.564,5293.642,10.70095, 'Stormfleet Deckhand'),
(@PATH4,9,2213.531,5285.789,10.70095, 'Stormfleet Deckhand'),
(@PATH4,10,2208.855,5275.448,10.82595, 'Stormfleet Deckhand'),
(@PATH4,11,2206.379,5260.244,10.58918, 'Stormfleet Deckhand'),
(@PATH4,12,2211.11,5256.537,10.71418, 'Stormfleet Deckhand'),
(@PATH4,13,2219.187,5252.958,11.33607, 'Stormfleet Deckhand'),
(@PATH4,14,2216.945,5251.284,11.26102, 'Stormfleet Deckhand'),
(@PATH4,15,2215.487,5248.678,11.44615, 'Stormfleet Deckhand'),
(@PATH4,16,2217.447,5248.063,11.4383, 'Stormfleet Deckhand'),
(@PATH4,17,2213.407,5251.713,10.96418, 'Stormfleet Deckhand'),
(@PATH4,18,2207.356,5257.069,10.71418, 'Stormfleet Deckhand'),
(@PATH4,19,2205.434,5262.277,10.58918, 'Stormfleet Deckhand'),
(@PATH4,20,2208.177,5274.885,10.82595, 'Stormfleet Deckhand'),
(@PATH4,21,2214.61,5286.973,10.82595, 'Stormfleet Deckhand'),
(@PATH4,22,2219.416,5292.909,10.70095, 'Stormfleet Deckhand'),
(@PATH4,23,2224.719,5291.44,10.82595, 'Stormfleet Deckhand'),
(@PATH4,24,2228.346,5291.136,10.95095, 'Stormfleet Deckhand'),
(@PATH4,25,2233.497,5291.667,11.21773, 'Stormfleet Deckhand');

SET @ENTRY := 29129;
SET @AURA := 17327;
SET @SPELL1 := 37361;
SET @SPELL2 := 24050;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=0 AND `creature_id`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,23,0,100,0,@AURA,0,2000,2000,11,@AURA,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Lost Drakkari Spirit - Aura Spirit Particles not present - Add Aura Spirit Particles'),
(@ENTRY,0,1,2,4,0,100,1,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Lost Drakkari Spirit - On Aggro - Prevent Combat Movement'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lost Drakkari Spirit - On Aggro - Set Phase 1'),
(@ENTRY,0,3,0,0,1,100,0,0,0,1000,1000,11,@SPELL1,1,0,0,0,0,2,0,0,0,0,0,0,0,'Lost Drakkari Spirit - Combat - Cast Arcane Bolt (Phase 1)'),
(@ENTRY,0,4,5,3,1,100,0,0,15,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lost Drakkari Spirit - Mana at 15% - Allow combat movement (Phase 1)'),
(@ENTRY,0,5,0,3,1,100,0,0,15,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lost Drakkari Spirit - Mana at 15% - Set phase 2 (Phase 1)'),
(@ENTRY,0,6,0,9,1,100,0,35,80,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lost Drakkari Spirit - At 35 yards - Allow combat movement (Phase 1)'),
(@ENTRY,0,7,0,9,1,100,0,0,15,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lost Drakkari Spirit - Below 15 yards - Prevent combat movement (Phase 1)'),
(@ENTRY,0,8,0,3,2,100,0,30,100,100,100,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lost Drakkari Spirit - Mana above 30% - Set phase 1 (Phase 2)'),
(@ENTRY,0,9,0,0,0,100,0,10000,16000,15000,18000,11,@SPELL2,1,0,0,0,0,2,0,0,0,0,0,0,0,'Lost Drakkari Spirit - Combat - Cast Spirit Burst');


-- Skybreaker Sorcerer channel Below Zero
SET @ENTRY := 37116;
SET @SPELL := 69705;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,1000,1000,1000,1000,11,@SPELL,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Skybreaker Sorcerer - On spawn & reset - Channel Spell <Below Zero>');

-- Kor'kron Battle-Mage channel Below Zero
SET @ENTRY := 37117;
SET @SPELL := 69705;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,1000,1000,1000,1000,11,@SPELL,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Kor''kron Battle-Mage - On spawn & reset - Channel Spell <Below Zero>');

-- Add spell conditions for 69705
SET @SPELL := 69705;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=@SPELL;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,0,@SPELL,0,18,1,36838,0,0,'','Gunship Battle - Spell 69705 (Below Zero) target creature 36838'),
(13,0,@SPELL,0,18,1,36839,0,0,'','Gunship Battle - Spell 69705 (Below Zero) target creature 36839');

  DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (30845, 34300);
 INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) 
 VALUES
 (30845,0,0,0,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
 (30845,0,1,0,4,1,100,1,0,0,0,0,11,48195,0,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Emerald Lasher Emerge on Aggro'),
 (30845,0,2,0,4,1,100,1,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Remove Ground Emote on Aggro'),
 (30845,0,3,0,0,1,100,0,4000,7000,9000,13000,11,51901,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Dream Lash'),
 (30845,0,4,0,7,1,100,1,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Set Phase 2 on Evade'),
 (30845,0,5,0,7,2,100,1,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Remove Ground Emote on Evade'),
 (30845,0,6,0,21,2,100,1,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Set Ground Emote on Reached Home'),
 (34300,0,0,0,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
 (34300,0,1,0,4,1,100,1,0,0,0,0,11,48195,0,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Emerald Lasher Emerge on Aggro'),
 (34300,0,2,0,4,1,100,1,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Remove Ground Emote on Aggro'),
 (34300,0,3,0,0,1,100,0,4000,7000,9000,13000,11,51901,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Dream Lash'),
 (34300,0,4,0,7,1,100,1,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Set Phase 2 on Evade'),
 (34300,0,5,0,7,2,100,1,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Remove Ground Emote on Evade'),
 (34300,0,6,0,21,2,100,1,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Set Ground Emote on Reached Home');
 
 UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (17116,17240,17440);
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (17116,17240,17440);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17116,0,0,0,64,0,100,0,0,0,0,0,33,17116,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663'),
(17240,0,0,0,64,0,100,0,0,0,0,0,33,17240,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663'),
(17440,0,0,0,64,0,100,0,0,0,0,0,33,17440,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=27990;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (27990,2799000,2799001);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27990,0,0,0,62,0,100,0,10199,0,0,0,80,2799001,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
(27990,0,1,0,62,0,100,0,10199,1,0,0,80,2799000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
-- horde quest script
(2799000,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip & Questgiver flags'),
(2799000,9,1,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn of Gossip & Questgiver flags for Alexstrasza'),
(2799000,9,2,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(2799000,9,3,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 1'),
(2799000,9,4,0,0,0,100,0,0,0,0,0,45,0,1,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos start path'),
(2799000,9,5,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 2'),
(2799000,9,6,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 3'),
(2799000,9,7,0,0,0,100,0,4000,4000,0,0,1,0,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 0'),
(2799000,9,8,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 1'),
(2799000,9,9,0,0,0,100,0,4000,4000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 4'),
(2799000,9,10,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 2'),
(2799000,9,11,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza'),
(2799000,9,12,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Alexstrasza Say text 0'),
(2799000,9,13,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 3'),
(2799000,9,14,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos resume path'),
(2799000,9,15,0,0,0,100,0,0,0,0,0,45,0,2,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza back'),
(2799000,9,16,0,0,0,100,0,1000,1000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 5'),
(2799000,9,17,0,0,0,100,0,4000,4000,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 6'),
(2799000,9,18,0,0,0,100,0,4000,4000,0,0,33,36715,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Give quest credit'),
(2799000,9,19,0,0,0,100,0,4000,4000,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn on Gossip & Questgiver flags'),
(2799000,9,20,0,0,0,100,0,0,0,0,0,81,3,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn on Gossip & Questgiver flags for Alexstrasza'),
-- alliance quest script
(2799001,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip & Questgiver flags'),
(2799001,9,1,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn of Gossip & Questgiver flags for Alexstrasza'),
(2799001,9,2,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(2799001,9,3,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 1'),
(2799001,9,4,0,0,0,100,0,0,0,0,0,45,0,1,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos start path'),
(2799001,9,5,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 2'),
(2799001,9,6,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 3'),
(2799001,9,7,0,0,0,100,0,4000,4000,0,0,1,0,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 0'),
(2799001,9,8,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 1'),
(2799001,9,9,0,0,0,100,0,4000,4000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 4'),
(2799001,9,10,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 2'),
(2799001,9,11,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza'),
(2799001,9,12,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Alexstrasza Say text 0'),
(2799001,9,13,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 3'),
(2799001,9,14,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos resume path'),
(2799001,9,15,0,0,0,100,0,0,0,0,0,45,0,2,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza back'),
(2799001,9,16,0,0,0,100,0,1000,1000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 5'),
(2799001,9,17,0,0,0,100,0,4000,4000,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 7'),
(2799001,9,18,0,0,0,100,0,4000,4000,0,0,33,36715,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Give quest credit'),
(2799001,9,19,0,0,0,100,0,4000,4000,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn on Gossip & Questgiver flags'),
(2799001,9,20,0,0,0,100,0,0,0,0,0,81,3,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn on Gossip & Questgiver flags for Alexstrasza');
DELETE FROM `creature_text` WHERE `entry` IN (26917,27990,38017);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(26917,0,0,'Mortal champions have long used these weapons to combat evil. I see no reason to keep the swords from them in this battle.',0,0,100,1,0,0,'Alexstrasza the Life-Binder'),
(27990,0,0,'You''re too late, $n. Another visitor from Dalaran came asking after information about the same prismatic dragon blades.',0,0,100,1,0,0,'Krasus'),
(27990,1,0,'From your description, I''m certain the book I loaned our visitor could allow you to easily identify the weapon.',0,0,100,25,0,0,'Krasus'),
(27990,2,0,'I''m afraid you''ll have to ask the -- Well, perhaps Kalecgos can help.',0,0,100,1,0,0,'Krasus'),
(27990,3,0,'$n may have found the remains of a prismatic blade, Kalecgos. Will you offer your help to our visitor?',0,0,100,1,0,0,'Krasus'),
(27990,4,0,'You believe our allies will not be able to control the power of the swords?',0,0,100,1,0,0,'Krasus'),
(27990,5,0,'As will we all.',0,0,100,25,0,0,'Krasus'),
(27990,6,0,'Please, mortal, speak with Arcanist Tybalin in Dalaran. He may be able to negotiate with the Sunreavers for access to the book.',0,0,100,1,0,0,'Krasus'),
(27990,7,0,'Please, mortal, seek out Magister Hathorel in Dalaran. He might be able to negotiate with the Silver Covenant for access to the book.',0,0,100,1,0,0,'Krasus'),
(38017,0,0,'Are you certain you should be helping these mortals in their quest for the sword?',0,0,100,1,0,0,'Kalecgos'),
(38017,1,0,'These blades, Krasus... They were made long ago, when things were... different.',0,0,100,1,0,0,'Kalecgos'),
(38017,2,0,'Our enemies once turned our strongest weapon against us. What makes you think the prismatic blades will be any different?',0,0,100,1,0,0,'Kalecgos'),
(38017,3,0,'As you wish, my queen. I will not stand in their way, but I will keep a close watch.',0,0,100,16,0,0,'Kalecgos');
-- waypoints for Kalecgos
DELETE FROM `waypoints` WHERE `entry`=38017;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(38017,1,3541.156,276.041,342.721,'talk point'),
(38017,2,3545.989,287.278,342.721,'home point');
-- SAI for Kalecgos
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=38017;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=38017;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (3801700,3801701);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(38017,0,0,1,38,0,100,0,0,1,0,0,80,3801700,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On dataset 0 1 run script'),
(38017,0,1,1,38,0,100,0,0,2,0,0,80,3801701,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On dataset 0 2 run script'),
(38017,0,2,3,40,0,100,0,1,38017,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Pause at wp 1'),
(38017,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,9,27990,0,15,0,0,0,0, 'turn to Krasus'),
(38017,0,4,5,40,0,100,0,2,38017,0,0,55,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stop at wp 2'),
(38017,0,5,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'turn to pos'),
(3801700,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'dataset 0 0'),
(3801700,9,1,0,0,0,100,0,0,0,0,0,53,0,38017,0,0,0,0,1,0,0,0,0,0,0,0, 'wp start'),
(3801701,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'dataset 0 0'),
(3801701,9,1,0,0,0,100,0,0,0,0,0,65,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'wp resume');
-- SAI for Alexstrasza
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26917;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26917;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26917,0,0,1,38,0,100,0,0,1,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,1.6049, 'On dataset 0 1 turn'),
(26917,0,1,1,38,0,100,0,0,2,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On dataset 0 2 turn');
-- Conversation between Sabetta Ward & Gavin Ward, Fort Wildervar "Sabetta Ward Envoker"
SET @ENTRY := 24532;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,10000,30000,150000,150000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Load script every 2.5 min ooc'),
(@ENTRY*100,9,0,0,0,0,100,0,5000,5000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Sabetta Ward Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,5000,5000,0,0,1,0,0,0,0,0,0,9,24531,0,10,0,0,0,0,'Gavin Ward Say text 0'),
(@ENTRY*100,9,2,0,0,0,100,0,5000,5000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Sabetta Ward Say text 1'),
(@ENTRY*100,9,3,0,0,0,100,0,5000,5000,0,0,1,1,0,0,0,0,0,9,24531,0,10,0,0,0,0,'Gavin Ward Say text 1'),
(@ENTRY*100,9,4,0,0,0,100,0,5000,5000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Sabetta Ward Say text 2'),
(@ENTRY*100,9,5,0,0,0,100,0,5000,5000,0,0,1,2,0,0,0,0,0,9,24531,0,10,0,0,0,0,'Gavin Ward Say text 2');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry` IN (24531,24532);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(24532,0,0, 'And I don''t want our land to have any of those horrible wolves, or giants, or ugly rams!',0,7,100,1,0,0, 'Sabetta Ward'),
(24531,0,0, 'Yes, darling. You realize you''ll be eating dire ram mutton for dinner until the crops are planted...',0,7,100,1,0,0, 'Gavin Ward'),
(24532,1,0, 'I''d sooner butcher that mule of yours! Why did you bring that beast in here, anyway?',0,7,100,5,0,0, 'Sabetta Ward'),
(24531,1,0, 'I''d rather listen to his braying than yours, dear.',0,7,100,0,0,0, 'Gavin Ward'),
(24532,2,0, 'Remember, honey, we need to get a plot of land with a nice hot spring.',0,7,100,1,0,0, 'Sabetta Ward'),
(24531,2,0, 'Of course, darling.',0,7,100,1,0,0, 'Gavin Ward');

-- Conversation between Brune Grayblade & Eldrim Mounder <Blacksmith>, Fort Wildervar "Brune Grayblade Envoker"
SET @ENTRY := 24528;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,30000,60000,150000,150000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Load script every 2.5 min ooc'),
(@ENTRY*100,9,0,0,0,0,100,0,5000,5000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Brune Grayblade Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,5000,5000,0,0,1,0,0,0,0,0,0,9,24052,0,10,0,0,0,0,'Eldrim Mounder Say text 0'),
(@ENTRY*100,9,2,0,0,0,100,0,5000,5000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Brune Grayblade Say text 1'),
(@ENTRY*100,9,3,0,0,0,100,0,5000,5000,0,0,1,1,0,0,0,0,0,9,24052,0,10,0,0,0,0,'Eldrim Mounder Say text 1'),
(@ENTRY*100,9,4,0,0,0,100,0,5000,5000,0,0,1,2,0,0,0,0,0,9,24052,0,10,0,0,0,0,'Eldrim Mounder Say text 2'),
(@ENTRY*100,9,5,0,0,0,100,0,5000,5000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Brune Grayblade Say text 2');
-- NPC talk text insert from sniff "5 sec between text 2 min between restart"
DELETE FROM `creature_text` WHERE `entry` IN (24528,24052);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(24528,0,0, 'How much''ll it cost me to get my mules shod?',0,7,100,6,0,0, 'Brune Grayblade'),
(24052,0,0, 'We don''t shoe no mules here. ''Sides, it''s strictly expedition business right now.',0,7,100,1,0,0, 'Eldrim Mounder'),
(24528,1,0, 'You don''t understand! If I''m not ready to go soon, all the good homesteading land will be taken!',0,7,100,1,0,0, 'Brune Grayblade'),
(24052,1,0, 'Not my problem! If yer so antsy to get yerself a house built, do it ''ere in the fort and quit yer whinin''!',0,7,100,274,0,0, 'Eldrim Mounder'),
(24052,2,0, 'Now, if you''d be so kind as to get your ass away from my forge...',0,7,100,25,0,0, 'Eldrim Mounder'),
(24528,2,0, 'That, sir, is a mule!',0,7,100,25,0,0, 'Brune Grayblade');
-- Creature Template Addon info
DELETE FROM `creature_template_addon` WHERE `entry` IN (24528,24052);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(24528,0,0,256,0, ''),
(24052,0,0,257,0, '');
DELETE FROM `creature_text` WHERE `entry`=27656;
INSERT INTO `creature_text` (entry,groupid,id,text,type,comment) VALUES
(27656,0,0,'You brash interlopers are out of your element! I will ground you!',1,'Boss Eregos - Aggro'),
(27656,1,0,'Such insolence... such arrogance... must be PUNISHED!',1,'Boss Eregos - Enrage'),
(27656,2,0,'Savor this small victory, foolish little creatures. You and your dragon allies have won this battle. But we will win... the Nexus War.',1,'Boss Eregos - Death');
SET @ENTRY := 23859;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,4,0,100,0,0,0,0,0,80,@ENTRY*100,0,2,0,0,0,1,0,0,0,0,0,0,0, 'Greer Orehammer - Script on Aggro'),
(@ENTRY,0,1,0,62,0,100,0,9546,1,0,0,52,745,0,0,0,0,0,0,0,0,0,0,0,0,0, 'Plague This Taxi Start'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,0,0,0,0,12,9526,4,30000,0,0,0,7,0,0,0,0,0,0,0,'Summon Enraged Gryphon'),
(@ENTRY*100,9,2,0,0,0,100,0,0,0,0,0,12,9526,4,30000,0,0,0,7,0,0,0,0,0,0,0,'Summon Enraged Gryphon');
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES 
(@ENTRY,0,0,'Guards!',0,0,100,0,0,0,'Greer Orehammer');
DELETE FROM `creature_text` WHERE `entry`=27447;
INSERT INTO `creature_text` (entry,groupid,id,TEXT,TYPE,LANGUAGE,sound) VALUES 
(27447,0,0,'There will be no mercy!',1,0,13649),
(27447,1,1,'Blast them! Destroy them!',1,0,13650),
(27447,2,2,'%s calls an Azure Ring Captain!',3,0,0),
(27447,3,3,'They are... too strong! Underestimated their... fortitude.',1,0,13655);
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30273;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30273;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30273,0,0,0,6,0,100,0,0,0,0,0,85,56515,0x02,0,0,0,0,7,0,0,0,0,0,0,0, 'Cast Summon Freed Crusader on Death'),
(30273,0,1,0,6,0,100,0,0,0,0,0,33,30274,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Cast Summon Freed Crusader Quest Credit');
UPDATE `creature_template` SET `AIName`= 'SmartAI', `minlevel`=1, `maxlevel`=1 WHERE `entry`=30268;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30268;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30268,0,0,0,6,0,100,0,0,0,0,0,12,30204,1,30000,0,0,0,1,0,0,0,0,0,0,0, 'Summon Forgotten Depths Ambusher');
-- Freeed Crusader
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30274;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30274;
DELETE FROM `smart_scripts` WHERE `entryorguid`=3027400;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30274,0,0,0,54,0,100,0,0,0,0,0,80,3027400,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader Start Script on Spawn'),
(3027400,9,0,0,0,0,100,0,0,0,0,0,11,58054,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Freed Crusader Blessing of Kings'),
(3027400,9,1,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader Speach'),
(3027400,9,2,0,0,0,100,0,0,0,0,0,11,58053,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Freed Crusader Holy Light'),
(3027400,9,3,0,0,0,100,0,4000,4000,0,0,53,1,30274,0,13008,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader paths to Argeant Vanguard'),
(3027400,9,4,0,0,0,100,0,0,0,0,0,41,4000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader Despawn');
-- create path point location to send Freed Crusaders to
DELETE FROM `waypoints` WHERE `entry`=30274;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES 
(30274,1,6296.25,92.9397,390.701, 'send Freed Crusader here');
DELETE FROM `creature_text` WHERE `entry`=30274;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(30274,0,0, 'Thank you and farewell, friend. I must return to the Argent Vanguard.',0,0,100,0,0,0, 'Freed Crusader Speach');
-- Forgotten Depths Ambusher
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30204;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30204;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30204,0,0,0,54,0,100,0,0,0,0,0,11,56418,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Forgotten Depths Ambusher - Emerge From Snow');
-- Cult Plaguebringer <Cult of the Damned> SAI (tested) 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=24957;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=24957;
DELETE FROM `smart_scripts` WHERE `entryorguid`=24957;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(24957,0,0,0,1,0,100,0,1000,900000,500000,700000,11,45850,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Ghoul Summons OOC'),
(24957,0,2,0,0,0,30,0,1100,6300,8800,13800,11,50356,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Inject Plague on victim');
-- Cultist Necrolyte SAI (tested) 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=25651;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (25651);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(25651,0,0,0,11,0,100,0,0,0,0,0,11,45104,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Shadow Channelling on self when spawned'),
(25651,0,1,0,21,0,100,0,0,0,0,0,11,45104,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Shadow Channelling on self when reach home home'),
(25651,0,2,0,0,0,30,0,1000,2000,6000,8000,11,18266,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Curse of Agony on victim'),
(25651,0,3,0,0,0,70,0,3000,4000,3000,4000,11,9613,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Shadow Bolt on victim');
-- Azure Front Channel Stalker SAI (tested working)
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=31400;
REPLACE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-112478,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,111746,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned'),
(-112479,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,111726,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned'),
(-112480,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,111742,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned'),
(-112482,0,0,0,1,0,100,1,1000,1000,1000,1000,11,59044,2,0,0,0,0,10,203520,31400,0,0,0,0,0,'Cast Cosmetic - Crystalsong Tree Beam when spawned');
-- Wildhammer Scout SAI (tested)
-- Removes waypoint script error spamming at Wildhammer Stronghold
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=19384;
REPLACE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-74030,0,0,0,1,0,100,0,1000,2000,3000,6000,11,33808,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Shoot Gun every 3-6 sec'),
(-74031,0,0,0,1,0,100,0,1000,2000,3000,6000,11,33808,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Shoot Gun every 3-6 sec'),
(-74037,0,0,0,1,0,100,0,3000,5000,3000,5000,11,33805,2,0,0,0,0,9,19388,0,25,0,0,0,0,'Cast Throw Hammer every 3-5 sec'),
(-74038,0,0,0,1,0,100,0,3000,5000,3000,5000,11,33806,2,0,0,0,0,9,19388,0,25,0,0,0,0,'Cast Throw Hammer every 3-5 sec'),
(-74055,0,0,0,1,0,100,0,1000,2000,3000,6000,11,33808,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Shoot Gun every 3-6 sec'),
(-74091,0,0,0,1,0,100,0,1000,2000,3000,6000,11,33808,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Shoot Gun every 3-6 sec');
-- Speech by Marrod Silvertongue, Fort Wildervar (Tested working)
SET @ENTRY := 24534;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,30000,50000,360000,360000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Load script every 6 min ooc'),
(@ENTRY*100,9,0,0,0,0,100,0,8000,8000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,2,0,0,0,100,0,8000,8000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 1'),
(@ENTRY*100,9,3,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,4,0,0,0,100,0,8000,8000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 2'),
(@ENTRY*100,9,5,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,6,0,0,0,100,0,8000,8000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 3'),
(@ENTRY*100,9,7,0,0,0,100,0,2000,2000,0,0,5,21,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,8,0,0,0,100,0,8000,8000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 4'),
(@ENTRY*100,9,9,0,0,0,100,0,2000,2000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,10,0,0,0,100,0,8000,8000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 5'),
(@ENTRY*100,9,11,0,0,0,100,0,2000,2000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,12,0,0,0,100,0,8000,8000,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,'Marrod Silvertongue Say text 6'),
(@ENTRY*100,9,13,0,0,0,100,0,2000,2000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote'),
(@ENTRY*100,9,14,0,0,0,100,0,3000,3000,0,0,5,4,0,0,0,0,0,9,24535,0,20,0,0,0,0,'Northrend Homesteader emote');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry` IN (24534);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(24534,0,0, 'Welcome to Fort Wildervar, brave homesteaders! There''s a whole continent out there just waiting to be claimed!',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,1,0, 'True, Northrend is a hard land, but our people are strong, hardy, and equal to the task!',0,7,100,0,0,0, 'Marrod Silvertongue'),
(24534,2,0, 'We will win this land with the sword, and break it with the plow! You are the men and women who will be remembered for taming the wild continent!',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,3,0, 'But, you will not be alone out there. My men and I have prepared pack mules carrying the supplies you''ll need most.',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,4,0, 'Axes, picks, seed, nails, food, blankets, water... it''s all there, waiting for you. I think you''ll find my prices quite reasonable, too.',0,7,100,25,0,0, 'Marrod Silvertongue'),
(24534,5,0, 'There are more than enough to go around. Should you need other goods, don''t hesitate to ask!',0,7,100,1,0,0, 'Marrod Silvertongue'),
(24534,6,0, 'Now, my loyal custo... err, friends, go forth and conquer this land for our people!',0,7,100,274,0,0, 'Marrod Silvertongue');
DELETE FROM `achievement_criteria_data` WHERE `criteria_id`=12846 AND `type` in (16,18);
DELETE FROM `achievement_criteria_data` WHERE `criteria_id`=12859 AND `type` in (5,15,18);
INSERT INTO `achievement_criteria_data`(`criteria_id`,`type`,`value1`,`value2`,`ScriptName`) VALUES 
(12846,16,335,0, ''),
(12859,5,26682,0, ''),
(12859,15,3,0, '');
DELETE FROM `creature_text` WHERE `entry` IN (38490,38494);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(38490,0,0, '$n is infected with the Death Plague!',3,0,100,25,0,0, 'Rotting Frost Giant - Death Plague'),
(38494,0,0, '$n is infected with the Death Plague!',3,0,100,25,0,0, 'Rotting Frost Giant - Death Plague');
DELETE FROM `creature_text` WHERE `entry` IN (38472,38485);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(38472,0,0, 'Die, intruders! None shall interfere with the Cult''s plans!',1,0,0,0,0,0, 'Darnavan - SAY_DARNAVAN_AGGRO'),
(38472,1,0, 'Wh- where am I...? What a nightmare I have had... But this is no time to reflect, I have much information to report!',0,0,0,0,0,0, 'Darnavan - SAY_DARNAVAN_RESCUED'),
(38485,0,0, 'Die, intruders! None shall interfere with the Cult''s plans!',1,0,0,0,0,0, 'Darnavan - SAY_DARNAVAN_AGGRO'),
(38485,1,0, 'Wh- where am I...? What a nightmare I have had... But this is no time to reflect, I have much information to report!',0,0,0,0,0,0, 'Darnavan - SAY_DARNAVAN_RESCUED');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=27006;
DELETE FROM `smart_scripts` WHERE `entryorguid`=27006;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=27006; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27006,0,0,0,0,0,100,0,5000,11000,16000,25000,11,52080,1,0,0,0,0,2,0,0,0,0,0,0,0,'Bonesunder - Cast Bonecrack');
-- Goramosh SAI
SET @ELMGUID := 113473;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26349;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (26349);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26349,0,0,0,1,0,100,1,1000,1000,1000,1000,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Cast Surge Needle Beam when spawned'),
(26349,0,1,0,21,0,100,0,0,0,0,0,11,46906,2,0,0,0,0,10,@ELMGUID,26298,0,0,0,0,0,'Cast Surge Needle Beam when reach home'),
(26349,0,2,0,2,0,100,1,0,50,0,0,11,20828,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Cone of Cold on victim at 50% health'),
(26349,0,3,0,0,0,100,0,3500,3500,3500,3500,11,9672,0,0,0,0,0,2,0,0,0,0,0,0,0,'Cast Frost Bolt on victim');
-- Arcanimus SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26370;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (26370);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26370,0,0,0,1,0,100,1,2000,2000,2000,2000,45,0,1,0,0,0,0,10,113473,26298,0,0,0,0,0, 'Set data 0 = 1 on bunny 2 sec after reset'),
(26370,0,1,0,1,0,100,1,0,0,0,0,11,46934,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Add Cosmetic - Arcane Force Shield (Blue x2) Aura on spawn & reset'),
(26370,0,2,3,4,0,100,0,0,0,0,0,28,46934,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Remove Cosmetic - Arcane Force Shield (Blue x2) Aura on aggro'),
(26370,0,3,0,61,0,100,0,0,0,0,0,28,46906,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - Remove Cosmetic - Surge Needle Beam on aggro'),
(26370,0,4,0,2,0,100,1,71,80,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - at 80% health cast Arcane Explosion on self'),
(26370,0,5,0,2,0,100,1,41,60,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - at 60% health cast Arcane Explosion on self'),
(26370,0,6,0,2,0,100,1,21,40,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - at 40% health cast Arcane Explosion on self'),
(26370,0,7,0,2,0,100,1,1,20,0,0,11,51820,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Arcanimus - at 20% health cast Arcane Explosion on self');
-- ELM General Purpose Bunny (scale x0.01) Large SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26298;
REPLACE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-104147,0,0,0,11,0,100,0,0,0,0,0,11,32566,2,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Purple Banish State aura on self when spawned'),
(-104147,0,1,2,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'reset data 0 = 0'),
(-104147,0,2,0,61,0,100,0,0,0,0,0,11,46906,2,0,0,0,0,10,96298,26370,0,0,0,0,0, 'cast Surge Needle Beam on Arcanimus');
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|128 WHERE `entry`=38752;
UPDATE `creature_template` SET `AIName`='NullAI' WHERE `entry` IN(33742,33809,33942);
UPDATE `creature_template` SET `speed_run`=5.5/7, `modelid1`=1126, `modelid2`=11686, `flags_extra`= `flags_extra`|128 WHERE `entry` IN(33632,33802);


UPDATE `creature_template` SET `AIName`='SmartAI',`InhabitType`=4 WHERE `entry`=31689;
DELETE FROM `creature_template_addon` WHERE `entry`=31689;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (31689,0,33554432,1,0, '59562 0');
DELETE FROM `smart_scripts` WHERE `entryorguid`=31689 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)VALUES
(31689,0,0,0,22,0,100,0,78,5000,5000,0,5,66,0,0,0,0,0,1,0,0,0,0,0,0,0,'Salute - Salute'),
(31689,0,1,0,22,0,100,0,21,5000,5000,0,5,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Cheer - Bow'),
(31689,0,2,0,22,0,100,0,101,5000,5000,0,5,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Wave - Wave'),
(31689,0,3,0,22,0,100,0,34,5000,5000,0,5,94,0,0,0,0,0,1,0,0,0,0,0,0,0,'Dance - Dance'),
(31689,0,4,0,22,0,100,0,328,5000,5000,0,5,11,0,0,0,0,0,1,0,0,0,0,0,0,0,'Flirt - Laugh'),
(31689,0,5,0,22,0,100,0,58,5000,5000,0,5,23,0,0,0,0,0,1,0,0,0,0,0,0,0,'Kiss - Flex'),
(31689,0,6,0,22,0,100,0,77,5000,5000,0,5,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rude - Rude');

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (15872,15873,15874,15879,15880,15882);
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (15872,15873,15874,15879,15880,15882);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (15872,15873,15874,15879,15880,15882);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(15879,0,0,0,1,0,100,1,0,0,0,0,33,15893,0,0,0,0,0,18,20,0,0,0,0,0,0, 'give credit'),
(15879,0,1,0,1,0,100,1,0,0,0,0,11,26344,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15880,0,0,0,1,0,100,1,0,0,0,0,33,15893,0,0,0,0,0,18,20,0,0,0,0,0,0, 'give credit'),
(15880,0,1,0,1,0,100,1,0,0,0,0,11,26345,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15882,0,0,0,1,0,100,1,0,0,0,0,33,15893,0,0,0,0,0,18,20,0,0,0,0,0,0, 'give credit'),
(15882,0,1,0,1,0,100,1,0,0,0,0,11,26347,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15872,0,0,0,1,0,100,1,0,0,0,0,33,15894,0,0,0,0,0,18,20,0,0,0,0,0,0, 'give credit'),
(15872,0,1,0,1,0,100,1,0,0,0,0,11,26344,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15873,0,0,0,1,0,100,1,0,0,0,0,33,15894,0,0,0,0,0,18,20,0,0,0,0,0,0, 'give credit'),
(15873,0,1,0,1,0,100,1,0,0,0,0,11,26347,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15874,0,0,0,1,0,100,1,0,0,0,0,33,15894,0,0,0,0,0,18,20,0,0,0,0,0,0, 'give credit'),
(15874,0,1,0,1,0,100,1,0,0,0,0,11,26345,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks');

UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry` IN (192708,192706,192871,192905,192710,192886,192869,192880,192713,192889,192890,192866,192891,192872,192881,192709,192883,192651,192711,192653,192887,192865,192874,192868,192867,192882,192707);
DELETE FROM `smart_scripts` WHERE `source_type`=1 AND `id`=0 AND `entryorguid` IN (192708,192706,192871,192905,192710,192886,192869,192880,192713,192889,192890,192866,192891,192872,192881,192709,192883,192651,192711,192653,192887,192865,192874,192868,192867,192882,192707);
INSERT INTO `smart_scripts`(`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(192708,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192706,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192871,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192905,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192710,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192886,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192869,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192880,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192713,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192889,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192890,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192866,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192891,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192872,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192881,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192709,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192883,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192651,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192711,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192653,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192887,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192865,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192874,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192868,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192867,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192882,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello'),
(192707,1,0,0,64,0,100,0,0,0,0,0,41,180000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dalaran Books: Despawn after 3 mins on gossip_hello');
SET @ENTRY := 23859;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,4,0,100,0,0,0,0,0,80,@ENTRY*100,0,2,0,0,0,1,0,0,0,0,0,0,0, 'Greer Orehammer - Script on Aggro'),
(@ENTRY,0,1,0,62,0,100,0,9546,1,0,0,52,745,0,0,0,0,0,0,0,0,0,0,0,0,0, 'Plague This Taxi Start'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,0,0,0,0,12,9526,4,30000,0,0,0,7,0,0,0,0,0,0,0,'Summon Enraged Gryphon'),
(@ENTRY*100,9,2,0,0,0,100,0,0,0,0,0,12,9526,4,30000,0,0,0,7,0,0,0,0,0,0,0,'Summon Enraged Gryphon');
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES 
(@ENTRY,0,0,'Guards!',0,0,100,0,0,0,'Greer Orehammer');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30273;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30273;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30273,0,0,0,6,0,100,0,0,0,0,0,85,56515,0x02,0,0,0,0,7,0,0,0,0,0,0,0, 'Cast Summon Freed Crusader on Death'),
(30273,0,1,0,6,0,100,0,0,0,0,0,33,30274,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Cast Summon Freed Crusader Quest Credit');
DELETE FROM `spell_scripts` WHERE `id`=56515;
INSERT INTO `spell_scripts` (`id`,`effIndex`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(56515,0,0,15,56516,2,0,0,0,0,0);
UPDATE `creature_template` SET `AIName`= 'SmartAI', `minlevel`=1, `maxlevel`=1 WHERE `entry`=30268;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30268;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30268,0,0,0,6,0,100,0,0,0,0,0,12,30204,1,30000,0,0,0,1,0,0,0,0,0,0,0, 'Summon Forgotten Depths Ambusher');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30274;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30274;
DELETE FROM `smart_scripts` WHERE `entryorguid`=3027400;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30274,0,0,0,54,0,100,0,0,0,0,0,80,3027400,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader Start Script on Spawn'),
(3027400,9,0,0,0,0,100,0,0,0,0,0,11,58054,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Freed Crusader Blessing of Kings'),
(3027400,9,1,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader Speach'),
(3027400,9,2,0,0,0,100,0,0,0,0,0,11,58053,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Freed Crusader Holy Light'),
(3027400,9,3,0,0,0,100,0,4000,4000,0,0,53,1,30274,0,13008,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader paths to Argeant Vanguard'),
(3027400,9,4,0,0,0,100,0,0,0,0,0,41,4000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Freed Crusader Despawn');
DELETE FROM `waypoints` WHERE `entry`=30274;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES 
(30274,1,6296.25,92.9397,390.701, 'send Freed Crusader here');
DELETE FROM `creature_text` WHERE `entry`=30274;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(30274,0,0, 'Thank you and farewell, friend. I must return to the Argent Vanguard.',0,0,100,0,0,0, 'Freed Crusader Speach');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30204;
DELETE FROM `smart_scripts` WHERE `entryorguid`=30204;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30204,0,0,0,54,0,100,0,0,0,0,0,11,56418,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Forgotten Depths Ambusher - Emerge From Snow');

SET @ENTRY := 36879;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,5000,5000,10000,10000,11,69581,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Pustulant Flesh on Random Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,5000,5000,10000,10000,11,70273,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Pustulant Flesh on Random Target (Heroic)'),
(@ENTRY,0,2,0,0,0,100,6,8000,8000,8000,8000,11,70274,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Toxic Waste on Random Target'),
(@ENTRY,0,3,0,2,0,100,6,15,15,0,0,11,69582,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast Blight Bomb self at 15pct Health');
SET @ENTRY := 37711;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,6,4000,6000,8000,12000,11,70393,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Devour Flesh on current Target');
SET @ENTRY := 37712;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,100,100,3000,3000,11,70386,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Shadow Bolt on current Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,100,100,3000,3000,11,70387,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Shadow Bolt on current Target (Heroic)');
SET @ENTRY := 37713;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,6,10000,10000,10000,10000,11,70392,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Black Brand on current Target'),
(@ENTRY,0,1,0,0,0,100,6,6000,6000,13000,13000,11,70391,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Curse of Agony on Random Target');
SET @ENTRY := 36840;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,7000,7000,8000,8000,11,69603,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Blight on Random Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,7000,7000,8000,8000,11,70285,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Blight on Random Target (Heroic)');
SET @ENTRY := 36896;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,1000,1000,5000,5000,11,69520,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Gargoyle Strike on current Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,1000,1000,5000,5000,11,70275,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Gargoyle Strike on current Target (Heroic)'),
(@ENTRY,0,2,0,2,0,100,6,10,10,0,0,11,69575,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast Stoneform self at 10pct Health');
SET @ENTRY := 37728;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,3000,3000,8000,8000,11,75330,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Shadow Bolt on current Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,3000,3000,8000,8000,11,75331,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Shadow Bolt on current Target (Heroic)');
SET @ENTRY := 36842;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,100,100,3000,3000,11,69573,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Frostbolt on current Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,100,100,3000,3000,11,70277,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Frostbolt on current Target (Heroic)'),
(@ENTRY,0,2,0,0,0,100,2,9000,9000,15000,15000,11,69574,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Freezing Circle on current Target (Non-Heroic)'),
(@ENTRY,0,3,0,0,0,100,4,9000,9000,15000,15000,11,70276,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Freezing Circle on current Target (Heroic)');
SET @ENTRY := 36788;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,100,100,3000,3000,11,69577,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Shadow Bolt on current Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,100,100,3000,3000,11,70270,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Shadow Bolt on current Target (Heroic)'),
(@ENTRY,0,2,0,0,0,100,2,9000,9000,24000,24000,11,69578,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Conversion Beam on Random Target (Non-Heroic)'),
(@ENTRY,0,3,0,0,0,100,4,9000,9000,24000,24000,11,70269,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Conversion Beam on Random Target (Heroic)');
SET @ENTRY := 36841;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,6,5000,5000,7000,8000,11,69579,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Arcing Slice to current Target'),
(@ENTRY,0,1,0,0,0,100,6,15000,15000,22000,22000,11,61044,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast Demoralizing Shout'),
(@ENTRY,0,2,0,0,0,100,6,22000,22000,25000,25000,11,69580,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast Shield Block');
SET @ENTRY := 38487;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,6,5000,5000,7000,8000,11,69579,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Arcing Slice to current Target'),
(@ENTRY,0,1,0,0,0,100,6,15000,15000,22000,22000,11,61044,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast Demoralizing Shout'),
(@ENTRY,0,2,0,0,0,100,6,22000,22000,25000,25000,11,69580,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast Shield Block');
SET @ENTRY := 31260;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,6,4000,4000,8000,8000,11,70292,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Glacial Strike on current Target'),
(@ENTRY,0,1,0,2,0,100,6,50,50,0,0,11,70291,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Frostblade on Random Target at 50pct Health');
SET @ENTRY := 37670;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,6,1000,1000,0,0,11,70306,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Cast Frostblade self');
SET @ENTRY := 36892;
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`="" WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,2,4000,4000,8000,8000,11,69528,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Empowered Shadow Bolt on Random Target (Non-Heroic)'),
(@ENTRY,0,1,0,0,0,100,4,4000,4000,8000,8000,11,70281,0,0,0,0,0,5,0,0,0,0,0,0,0, 'Cast Empowered Shadow Bolt on Random Target (Heroic)');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=25281;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (25281);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(25281,0,0,0,1,0,100,0,6000,6000,6000,6000,11,45425,2,0,0,0,0,10,103993,24921,0,0,0,0,0,'Fire at target every 6 sec');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=25282;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (25282);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(25282,0,0,0,1,0,100,0,6000,6000,6000,6000,11,42611,2,0,0,0,0,10,103994,24921,0,0,0,0,0,'Fire at target every 6 sec');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=28801;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-107662);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-107662,0,0,0,1,0,100,0,12000,18000,12000,18000,11,54423,2,0,0,0,0,10,117888,29416,0,0,0,0,0,'Fire at target every 12-18 sec');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=16896;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-58449);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-58449,0,0,0,1,0,100,0,6000,6000,6000,6000,11,29120,2,0,0,0,0,10,58457,16898,0,0,0,0,0,'Fire at target every 6 sec');
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-58450);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-58450,0,0,0,1,0,100,0,4000,4000,6000,6000,11,29120,2,0,0,0,0,10,58461,16899,0,0,0,0,0,'Fire at target every 6 sec');
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-58451);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-58451,0,0,0,1,0,100,0,2000,2000,6000,6000,11,29120,2,0,0,0,0,10,58455,16897,0,0,0,0,0,'Fire at target every 6 sec');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=30377;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (30377,3037700);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30377,0,0,0,1,0,100,0,30000,60000,240000,240000,80,3037700,0,0,0,0,0,0,0,0,0,0,0,0,0,'Load script every 4 min ooc'),
(3037700,9,0,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 0'),
(3037700,9,1,0,0,0,100,0,6000,6000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 0'),
(3037700,9,2,0,0,0,100,0,12000,12000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 1'),
(3037700,9,3,0,0,0,100,0,12000,12000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 2'),
(3037700,9,4,0,0,0,100,0,5000,5000,0,0,1,1,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 1'),
(3037700,9,5,0,0,0,100,0,6000,6000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 3'),
(3037700,9,6,0,0,0,100,0,9000,9000,0,0,1,2,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 2'),
(3037700,9,7,0,0,0,100,0,9000,9000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 4'),
(3037700,9,8,0,0,0,100,0,3000,3000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 5'),
(3037700,9,9,0,0,0,100,0,9000,9000,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 6'),
(3037700,9,10,0,0,0,100,0,7000,7000,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 7'),
(3037700,9,11,0,0,0,100,0,11000,11000,0,0,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 8'),
(3037700,9,12,0,0,0,100,0,12000,12000,0,0,1,3,0,0,0,0,0,9,28179,0,10,0,0,0,0,'Highlord Tirion Fordring Say text 3'),
(3037700,9,13,0,0,0,100,0,13000,13000,0,0,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'The Ebon Watcher Say text 9');
DELETE FROM `creature_text` WHERE `entry` IN (28179,30377);
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(28179,0,0,'The Lich King reacted swiftly to the breach. Faster than I anticipated.',0,0,100,1,0,0,'Highlord Tirion Fordring'),
(28179,1,0,'What would you have me do, Darion?',0,0,100,6,0,0,'Highlord Tirion Fordring'),
(28179,2,0,'Choose your words wisely, death knight. You stand amidst the company of the devoted.',0,0,100,1,0,0,'Highlord Tirion Fordring'),
(28179,3,0,'We will do this with honor, Darion. We will not sink to the levels of the Scourge to be victorious. To do so would make us no better than the monster that we fight to destroy!',0,0,100,1,0,0,'Highlord Tirion Fordring'),
(30377,0,0,'You are dealing with a being that holds within it the consciousness of the most cunning, intelligent, and ruthless individuals to ever live.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,1,0,'The Lich King is unlike any foe that you have ever faced, Highlord. Though you bested him upon the holy ground of Light\'s Hope Chapel, you tread now upon his domain.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,2,0,'You cannot win. Not like this...',0,0,100,274,0,0,'The Ebon Watcher'),
(30377,3,0,'Nothing. There is nothing that you can do while the Light binds you. It controls you wholly, shackling you to the ground with its virtues.',0,0,100,274,0,0,'The Ebon Watcher'),
(30377,4,0,'%s shakes his head.','2',0,100,0,0,0,'The Ebon Watcher'),
(30377,5,0,'Look upon the field, Highlord. The Lich King has halted your advance completely and won the upper hand!',0,0,100,25,0,0,'The Ebon Watcher'),
(30377,6,0,'The breach you created was sealed with Nerubian webbing almost as quickly as it was opened.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,7,0,'Your soldiers are being used as living shields to stave off artillery fire in the Valley of Echoes, allowing the forces of the Lich King to assault your base without impediment.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,8,0,'The Lich King knows your boundaries, Highlord. He knows that you will not fire on your own men. Do you not understand? He has no boundaries. No rules to abide.',0,0,100,1,0,0,'The Ebon Watcher'),
(30377,9,0,'Then you have lost, Highlord.',0,0,100,1,0,0,'The Ebon Watcher');
SET @Diver=31689; -- Gnome Diver
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@Diver; -- Gnome Diver
REPLACE INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(28951,0,0,257,0, '60913 0 61354 0'), -- Breanni
(@Diver,0,33554432,1,0, '59562 0'); -- Gnome Diver
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Diver AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)VALUES
(@Diver,0,0,0,22,0,100,0,78,5000,5000,0,5,66,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Salute - Salute'),
(@Diver,0,1,0,22,0,100,0,21,5000,5000,0,5,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Cheer - Bow'),
(@Diver,0,2,0,22,0,100,0,101,5000,5000,0,5,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Wave - Wave'),
(@Diver,0,3,0,22,0,100,0,34,5000,5000,0,5,94,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Dance - Dance'),
(@Diver,0,4,0,22,0,100,0,328,5000,5000,0,5,11,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Flirt - Laugh'),
(@Diver,0,5,0,22,0,100,0,58,5000,5000,0,5,23,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Kiss - Flex'),
(@Diver,0,6,0,22,0,100,0,77,5000,5000,0,5,14,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gnome Diver: Rude - Rude');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (15872,15873,15874,15879,15880,15882);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (15872,15873,15874,15879,15880,15882);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(15879,0,0,0,1,0,100,1,0,0,0,0,11,26344,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15880,0,0,0,1,0,100,1,0,0,0,0,11,26345,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15882,0,0,0,1,0,100,1,0,0,0,0,11,26347,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15872,0,0,0,1,0,100,1,0,0,0,0,11,26344,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15873,0,0,0,1,0,100,1,0,0,0,0,11,26347,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks'),
(15874,0,0,0,1,0,100,1,0,0,0,0,11,26345,2,0,0,0,0,1,0,0,0,0,0,0,0, 'cast fireworks');

SET @ENTRY := 24752; -- Rock Falcon SAI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,9007,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip option Close Gossip'), -- Player needs to cast this on self "not working"
(@ENTRY,0,1,0,61,0,100,0,100,100,100,100,86,44363,0,7,0,0,0,7,0,0,0,0,0,0,0,'Player selfcast spell');
SET @ENTRY := 33303; -- NPC entry
SET @ERROR1 := 1334; -- Error Message 1
SET @ERROR2 := 1335; -- Error Message 2
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,75,45776,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Apply aura on spawn'),
(@ENTRY,0,1,0,8,0,100,0,62767,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,28,45776,0,0,0,0,0,1,0,0,0,0,0,0,0,'Remove aura'),
(@ENTRY*100,9,1,0,0,0,100,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Face Player'),
(@ENTRY*100,9,2,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Say text 0'),
(@ENTRY*100,9,3,0,0,0,100,0,6000,6000,6000,6000,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Say text 1'),
(@ENTRY*100,9,4,0,0,0,100,0,5000,5000,5000,5000,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Reset Orientation'),
(@ENTRY*100,9,5,0,0,0,100,0,0,0,0,0,75,45776,0,0,0,0,0,1,0,0,0,0,0,0,0,'Replace Aura');
DELETE FROM `creature_text` WHERE `entry`=33303;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(33303,0,0, 'Thank you, mortal, for freeing me from this curse. I beg you, take this blade.',0,0,100,1,0,0, 'Maiden of Winter''s Breath Lake'),
(33303,1,0, 'It has brought me naught but ill. Mayhap you can find someone who will contain its power.',0,0,100,1,0,0, 'Maiden of Winter''s Breath Lake');


DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry`=62767;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceEntry`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`COMMENT`) VALUES
(17,62767,19,33303,0,0,@ERROR1, 'Break Curse of Ice Required Target Maiden of Winter''s Breath Lake'),
(17,62767,1,45776,0,1,@ERROR2, 'Break Curse of Ice Required Target Needs Aura Ice Block');
DELETE FROM `trinity_string` WHERE `entry` IN (@ERROR1,@ERROR2);
INSERT INTO `trinity_string` (`entry`,`content_default`) VALUES
(@ERROR1, 'Requires Maiden of Winter''s Breath Lake'),
(@ERROR2, 'You can''t use that right now');
SET @ENTRY := 30224;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
UPDATE `smart_scripts` SET `target_type`=1, `comment`=  'The Ebon Watcher: Load script every 4 min ooc' WHERE `entryorguid`=30377 AND `source_type` =0 AND `id`=0;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,30000,60000,150000,150000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Load script every 2.5 min ooc'),
(@ENTRY*100,9,0,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Lord Dalfors text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,6000,6000,0,0,1,0,0,0,0,0,0,9,30225,0,10,0,0,0,0,'Crusader Sunborn Say text 0'),
(@ENTRY*100,9,2,0,0,0,100,0,4000,4000,0,0,5,14,0,0,0,0,0,9,30225,0,10,0,0,0,0,'Crusader Sunborn emote');
DELETE FROM `creature_text` WHERE `entry` IN (30224,30225);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(30224,0,0, 'What''s on yer mind, lad?',0,0,100,6,0,0, 'Crusader Lord Dalfors'),
(30225,0,0, 'Eversong Woods, Dalfors. I''m thinking about how beautiful it was before Arthas cut a swathe of death through it...',0,0,100,1,0,0, 'Crusader Sunborn');
INSERT IGNORE INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES 
(19,0,8871,0,4,1519,0,0,0,0,'The Lunar Festival: Stormwind'),
(19,0,8872,0,4,1657,0,0,0,0,'The Lunar Festival: Darnassus'),
(19,0,8870,0,4,1537,0,0,0,0,'The Lunar Festival: Ironforge'),
(19,0,8873,0,4,1637,0,0,0,0,'The Lunar Festival: Orgrimmar'),
(19,0,8874,0,4,1497,0,0,0,0,'The Lunar Festival: Undercity'),
(19,0,8875,0,4,1638,0,0,0,0,'The Lunar Festival: Thunder Bluff');
SET @Goodman := 27234; -- Blacksmith Goodman
SET @Zierhut := 27235; -- Lead Cannoneer Zierhut (npc)
SET @Mercer := 27236; -- Stable Master Mercer (npc)
SET @Jordan := 27237; -- Commander Jordan (npc)
SET @Rod := 37438; -- Rod of Compulsion (item)
SET @Compelled := 48714; -- Compelled (spell)
SET @DeathJordan := 48724; -- The Denouncement: Commander Jordan On Death
SET @DeathZierhut := 48726; -- The Denouncement: Lead Cannoneer Zierhut On Death
SET @DeathGoodman := 48728; -- The Denouncement: Blacksmith Goodman On Death
SET @DeathMercer := 48730; -- The Denouncement: Stable Master Mercer On Death
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (@Goodman,@Zierhut,@Mercer,@Jordan);
DELETE FROM `spell_scripts` WHERE `id` IN (@DeathJordan,@DeathZierhut,@DeathGoodman,@DeathMercer);
INSERT INTO `spell_scripts`(`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(@DeathJordan,0,15,48723,1,0,0,0,0,0),  -- cast "The Denouncement: Commander Jordan Kill Credit" on player
(@DeathZierhut,0,15,48725,1,0,0,0,0,0), -- cast "The Denouncement: Lead Cannoneer Zierhut Kill Credit" on player
(@DeathGoodman,0,15,48727,1,0,0,0,0,0), -- cast "The Denouncement: Blacksmith Goodman Kill Credit" on player
(@DeathMercer,0,15,48729,1,0,0,0,0,0);  -- cast "The Denouncement: Stable Master Mercer Kill Credit" on player
DELETE FROM `creature_text` WHERE `entry` IN (@Goodman,@Zierhut,@Mercer,@Jordan);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@Goodman,0,0, 'You are being misled! The Onslaught is all lies! The Scourge and the Forsaken are not our enemies! Wake up!',1,0,100,5,0,0, 'Blacksmith Goodman'),
(@Jordan,0,0, 'High general Abbendis personally told me that it was a mistake to come north and that we''re doomed! I urge you all to lay down your weapons and leave before it''s too late!',1,0,100,5,0,0, 'Commander Jordan'),
(@Zierhut,0,0, 'Renounce the Scarlet Onslaught! Don''t listen to the lies of the high general and the grand admiral any longer!',1,0,100,5,0,0, 'Lead Cannoneer Zierhut'),
(@Mercer,0,0, 'Abbendis is nothing but a harlot and Grand Admiral Westwind is selling her cheap like he sold us out!',1,0,100,5,0,0, 'Stable Master Mercer');
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (@Goodman,@Zierhut,@Mercer,@Jordan);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@Goodman,0,0,0,8,0,100,0,@Compelled,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Goodman: On spellhit set phase 2'),
(@Goodman,0,1,0,6,2,100,0,0,0,0,0,85,@DeathGoodman,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Goodman: On death in phase 2 cast spell'),
(@Goodman,0,2,0,25,0,100,0,0,0,0,0,28,@Compelled,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Goodman: On reset remove Compelled aura'),
(@Goodman,0,3,0,25,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Goodman: On reset set phase 0'),
(@Goodman,0,4,0,6,2,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Goodman: On death in phase 2 yell'),
(@Mercer,0,0,0,8,0,100,0,@Compelled,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Mercer: On spellhit set phase 2'),
(@Mercer,0,1,0,6,2,100,0,0,0,0,0,85,@DeathMercer,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Mercer: On death in phase 2 cast spell'),
(@Mercer,0,2,0,25,0,100,0,0,0,0,0,28,@Compelled,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Mercer: On reset remove Compelled aura'),
(@Mercer,0,3,0,25,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Mercer: On reset set phase 0'),
(@Mercer,0,4,0,6,2,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Mercer: On death in phase 2 yell'),
(@Zierhut,0,0,0,8,0,100,0,@Compelled,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Goodman: On spellhit set phase 2'),
(@Zierhut,0,1,0,6,2,100,0,0,0,0,0,85,@DeathZierhut,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Zierhut: On death in phase 2 cast spell'),
(@Zierhut,0,2,0,25,0,100,0,0,0,0,0,28,@Compelled,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Zierhut: On reset remove Compelled aura'),
(@Zierhut,0,3,0,25,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Zierhut: On reset set phase 0'),
(@Zierhut,0,4,0,6,2,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Zierhut: On death in phase 2 yell'),
(@Jordan,0,0,0,8,0,100,0,@Compelled,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Jordan: On spellhit set phase 2'),
(@Jordan,0,1,0,6,2,100,0,0,0,0,0,85,@DeathJordan,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Jordan: On death in phase 2 cast spell'),
(@Jordan,0,2,0,25,0,100,0,0,0,0,0,28,@Compelled,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Jordan: On reset remove Compelled aura'),
(@Jordan,0,3,0,25,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Jordan: On reset set phase 0'),
(@Jordan,0,4,0,6,2,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Denouncement/Jordan: On death in phase 2 yell');
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=25253;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-111383,-111377,-111378,-111382,-111379,-111380);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-111383,0,0,0,1,0,100,0,1000,2000,4000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 4-5 sec'),
(-111377,0,0,0,1,0,100,0,3000,4000,4000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 4-5 sec'),
(-111378,0,0,0,1,0,100,0,8000,8000,16000,16000,10,4,5,21,0,0,0,1,0,0,0,0,0,0,0,'Random cheer emote every 16 sec'),
(-111382,0,0,0,1,0,100,0,16000,16000,16000,16000,10,4,5,21,0,0,0,1,0,0,0,0,0,0,0,'Random cheer emote every 16 sec'),
(-111379,0,0,0,1,0,100,0,2000,2000,5000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 5 sec'),
(-111379,0,1,0,1,0,100,0,4000,4000,7000,7000,5,36,0,0,0,0,0,10,111376,25253,0,0,0,0,0,'Attack emote dueler 2 sec later sec'),
(-111380,0,0,0,1,0,100,0,5000,5000,5000,5000,5,36,0,0,0,0,0,1,0,0,0,0,0,0,0,'Attack emote every 5 sec'),
(-111380,0,1,0,1,0,100,0,7000,7000,7000,7000,5,36,0,0,0,0,0,10,111381,25253,0,0,0,0,0,'Attack emote dueler 2 sec later sec');
INSERT IGNORE INTO `conditions`(`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`Comment`) VALUES
(13,0,@DeathJordan,0,18,1,@Jordan,0,0, 'The Denouncement: Jordan target'),
(13,0,@DeathZierhut,0,18,1,@Zierhut,0,0, 'The Denouncement: Zierhut target'),
(13,0,@DeathGoodman,0,18,1,0,0,0, 'The Denouncement: Goodman target'),
(13,0,@DeathMercer,0,18,1,@Mercer,0,0, 'The Denouncement: Mercer'),
(18,0,@Rod,0,24,1,@Goodman,0,0, 'The Denouncement: Rod - Goodman target'),
(18,0,@Rod,0,24,1,@Zierhut,0,0, 'The Denouncement: Rod - Zierhut target'),
(18,0,@Rod,0,24,1,@Mercer,0,0, 'The Denouncement: Rod - Mercer target'),
(18,0,@Rod,0,24,1,@Jordan,0,0, 'The Denouncement: Rod - Jordan target');
DELETE FROM `creature_text` WHERE `entry`=36853;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(36853,0,0, 'You are fools to have come to this place! The icy winds of Northrend will consume your souls!',1,0,0,0,0,17007, 'Sindragosa - SAY_AGGRO'),
(36853,1,0, 'Suffer, mortals, as your pathetic magic betrays you!',1,0,0,0,0,17014, 'Sindragosa - SAY_UNCHAINED_MAGIC'),
(36853,2,0, '%s prepares to unleash a wave of blistering cold!',3,0,0,0,0,0, 'Sindragosa - EMOTE_WARN_BLISTERING_COLD'),
(36853,3,0, 'Can you feel the cold hand of death upon your heart?',1,0,0,0,0,17013, 'Sindragosa - SAY_BLISTERING_COLD'),
(36853,4,0, 'Aaah! It burns! What sorcery is this?!',1,0,0,0,0,17015, 'Sindragosa - SAY_RESPITE_FOR_A_TORMENTED_SOUL'),
(36853,5,0, 'Your incursion ends here! None shall survive!',1,0,0,0,0,17012, 'Sindragosa - SAY_AIR_PHASE'),
(36853,6,0, 'Now feel my master''s limitless power and despair!',1,0,0,0,0,17016, 'Sindragosa - SAY_PHASE_2'),
(36853,7,0, '%s fires a frozen orb towards $N!',3,0,0,0,0,0, 'Sindragosa - EMOTE_WARN_FROZEN_ORB'),
(36853,8,0, 'Perish!',1,0,0,0,0,17008, 'Sindragosa - SAY_KILL 1'),
(36853,8,1, 'A flaw of mortality...',1,0,0,0,0,17009, 'Sindragosa - SAY_KILL 2'),
(36853,9,0, 'Enough! I tire of these games!',1,0,0,0,0,17011, 'Sindragosa - SAY_BERSERK'),
(36853,10,0, 'Free...at last...',1,0,0,0,0,17010, 'Sindragosa - SAY_DEATH');
SET @ENTRY:=20561;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'On spawn set phase 1'),
(@ENTRY,0,1,0,8,1,100,0,35372,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 'set phase 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,1000,0,0,33,20561,0,0,0,0,0,7,0,0,0,0,0,0,0,'give quest credit'),
(@ENTRY*100,9,2,0,0,0,100,0,1000,1000,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'despawn');
SET @ENTRY:=25321;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'On spawn set phase 1'),
(@ENTRY,0,1,0,8,1,100,0,45504,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 'set phase 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say Text 0 random'),
(@ENTRY*100,9,2,0,0,0,100,0,1000,1000,0,0,33,25321,0,0,0,0,0,7,0,0,0,0,0,0,0,'give quest credit'),
(@ENTRY*100,9,3,0,0,0,100,0,1000,1000,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'despawn');
DELETE FROM `creature_text` WHERE `entry`=25321;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES 
(25321,0,0, 'Thank you for freeing me! May the tides always favor you.',0,0,100,1,0,0, 'Kaskala Craftman'),
(25321,0,1, 'Do not allow Kaskala to forget what has happened here.',0,0,100,1,0,0, 'Kaskala Craftman');
SET @ENTRY:=25322;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0, 'On spawn set phase 1'),
(@ENTRY,0,1,0,8,1,100,0,45504,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 'set phase 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say Text 0 random'),
(@ENTRY*100,9,2,0,0,0,100,0,1000,1000,0,0,33,25322,0,0,0,0,0,7,0,0,0,0,0,0,0, 'give quest credit'),
(@ENTRY*100,9,3,0,0,0,100,0,1000,1000,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'despawn');
DELETE FROM `creature_text` WHERE `entry`=25322;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES 
(25322,0,0, 'May the ancestors always aid you, $n, as you have aided me.',0,0,100,1,0,0, 'Kaskala Shaman'),
(25322,0,1, 'Thank you, $n. May the winds and seas always deliver you safely.',0,0,100,1,0,0, 'Kaskala Shaman');

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=32739; -- Baroness Zildjia
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=32736; -- Scribe Whitman
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=32741; -- Conjurer Weinhaus
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=32734; -- Arcanist Ginsberg
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=32735; -- Alchemist Burroughs
-- Talk events for Baroness Zildjia, Scribe Whitman and Conjurer Weinhaus
DELETE FROM `creature_text` WHERE `entry` IN (32739,32736,32741) AND `groupid`=0;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(32739,0,0, 'The view up here is amazing!',0,0,0,5,0,0, 'Baroness Zildjia'), -- Baroness Zildjia
(32739,0,1, 'Too bad I left my light feathers at home... Slow Fall would work perfect here!',0,0,0,1,0,0, 'Baroness Zildjia'), -- Baroness Zildjia
(32736,0,0, 'The view up here is amazing!',0,0,0,5,0,0, 'Scribe Whitman'), -- Scribe Whitman
(32736,0,1, 'Too bad I left my light feathers at home... Slow Fall would work perfect here!',0,0,0,1,0,0, 'Scribe Whitman'), -- Scribe Whitman
(32741,0,0, 'The view up here is amazing!',0,0,0,5,0,0, 'Conjurer Weinhaus'), -- Conjurer Weinhaus
(32741,0,1, 'Too bad I left my light feathers at home... Slow Fall would work perfect here!',0,0,0,1,0,0, 'Conjurer Weinhaus'); -- Conjurer Weinhaus
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (32739,32736,32741,32734,32735) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(32739,0,0,0,1,0,100,0,0,0,420000,1000000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Baroness Zildjia: Say rand text every 7-14 minutes'), -- Baroness Zildjia
(32736,0,0,0,1,0,100,0,0,0,300000,840000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Scribe Whitman: Say rand text every 5-14 minutes'), -- Scribe Whitman
(32741,0,0,0,1,0,100,0,0,0,400000,520000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Conjurer Weinhaus: Say rand text every 5-7 minutes'), -- Conjurer Weinhaus
(32734,0,0,0,1,0,100,0,0,0,5000,30000,10,274,1,11,0,0,0,1,0,0,0,0,0,0,0, 'Arcanist Ginsberg: Random emote every 5-30 seconds'), -- Arcanist Ginsberg
(32735,0,0,0,1,0,100,0,0,0,5000,30000,10,274,1,11,0,0,0,1,0,0,0,0,0,0,0, 'Alchemist Burroughs: Random emote every 5-30 seconds'); -- Alchemist Burroughs
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (25664,25665,25666);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (25664,25665,25666);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(25664,0,0,0,8,0,100,0,45853,1,0,0,33,25664,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Mark Sinkhole Killcredit: South'),
(25665,0,0,0,8,0,100,0,45853,1,0,0,33,25665,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Mark Sinkhole Killcredit: NorthEast'),
(25666,0,0,0,8,0,100,0,45853,1,0,0,33,25666,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Mark Sinkhole Killcredit: NorthWest');

UPDATE `creature_template` SET `AIName`='AggressorAI' WHERE `entry`=27131;
DELETE FROM `conditions` WHERE `SourceEntry` =60089;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(17,0,60089,0,1,5487,0,0,0, '', 'Faerie Fire - Bear Form'),
(17,0,60089,1,1,9634,0,0,0, '', 'Faerie Fire - Dire Bear Form');
INSERT IGNORE INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,0,71322,0,18,1,38558,0,0, '', 'Blood-Queen Lana''thel - Annihilate Minchar');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (18714,18717,18716,18719,18715);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (18714,18717,18716,18719,18715);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18714,0,0,0,19,0,100,0,10041,0,0,0,11,48917,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Neftis - On Quest Accept - Cast spell 48917 on player'),
(18714,0,1,0,20,0,100,0,10041,0,0,0,28,32756,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Neftis - On Quest Reward - Remove spell 32756 on player'),
(18714,0,2,0,62,0,100,0,7772,0,0,0,11,48917,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Neftis - On Gossip option - Cast spell 48917 on player'),
(18715,0,0,0,19,0,100,0,10040,0,0,0,11,48917,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Private Weeks - On Quest Accept - Cast spell 48917 on player'),
(18715,0,1,0,20,0,100,0,10040,0,0,0,28,32756,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Private Weeks - On Quest Reward - Remove spell 32756 on player'),
(18715,0,2,0,62,0,100,0,21253,0,0,0,11,48917,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Private Week - On Gossip option - Cast spell 48917 on player'),
(18717,0,0,0,62,0,100,0,7757,0,0,0,11,47069,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Who Are They - Shadowy Laborer - On Gossip option - Cast spell 47069 on player'),
(18716,0,0,0,62,0,100,0,7759,0,0,0,11,47068,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Who Are They - Shadowy Initiate - On Gossip option - Cast spell 47068 on player'),
(18719,0,0,0,62,0,100,0,7760,0,0,0,11,47070,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Who Are They - Shadowy Advisor - On Gossip option - Cast spell 47070 on player');
DELETE FROM `creature_text` WHERE `entry` IN (37119,37181,37183);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(37119,0,0, 'This is our final stand. What happens here will echo through the ages. Regardless of outcome, they will know that we fought with honor. That we fought for the freedom and safety of our people!',1,0,0,22,0,16653, 'Highlord Tirion Fordring - SAY_TIRION_INTRO_1'),
(37119,1,0, 'Remember, heroes, fear is your greatest enemy in these befouled halls. Steel your heart and your soul will shine brighter than a thousand suns. The enemy will falter at the sight of you. They will fall as the light of righteousness envelops them!',1,0,0,22,0,16654, 'Highlord Tirion Fordring - SAY_TIRION_INTRO_2'),
(37119,2,0, 'Our march upon Icecrown Citadel begins now!',1,0,0,22,0,16655, 'Highlord Tirion Fordring - SAY_TIRION_INTRO_3'),
(37119,3,0, 'ARTHAS! I swore that I would see you dead and the Scourge dismantled! I''m going to finish what I started at Light''s Hope!',1,0,0,22,0,16656, 'Highlord Tirion Fordring - SAY_TIRION_INTRO_4'),
(37181,0,0, 'You now stand upon the hallowed ground of the Scourge. The Light won''t protect you here, paladin. Nothing will protect you...',1,0,0,0,0,17230, 'The Lich King - SAY_LK_INTRO_1'),
(37181,1,0, 'You could have been my greatest champion, Fordring: A force of darkness that would wash over this world and deliver it into a new age of strife.',1,0,0,0,0,17231, 'The Lich King - SAY_LK_INTRO_2'),
(37181,2,0, 'But that honor is no longer yours. Soon,I will have a new champion.',1,0,0,0,0,17232, 'The Lich King - SAY_LK_INTRO_3'),
(37181,3,0, 'The breaking of this one has been taxing. The atrocities I have committed upon his soul. He has resisted for so long, but he will bow down before his king soon.',1,0,0,0,0,17233, 'The Lich King - SAY_LK_INTRO_4'),
(37181,4,0, 'In the end, you will all serve me.',1,0,0,0,0,17234, 'The Lich King - SAY_LK_INTRO_5'),
(37183,0,0, 'NEVER! I... I will never... serve... you...',1,0,0,0,0,17078, 'Highlord Bolvar Fordragon - SAY_BOLVAR_INTRO_1');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=37011; -- The Damned
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-200966,-201066,37011);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(37011,0,0,0,6,0,100,1,0,0,0,0,11,70961,3,0,0,0,0,1,0,0,0,0,0,0,0, 'The Damned - Cast Shattered Bones on death'),
(37011,0,1,0,2,0,100,0,5,30,15000,20000,75,70960,0,0,0,0,0,1,0,0,0,0,0,0,0, 'The Damned - Cast Bone Flurry at 5-30%');
DELETE FROM `creature_text` WHERE `entry`=37187 AND `groupid` BETWEEN 15 AND 18;
DELETE FROM `creature_text` WHERE `entry`=37200 AND `groupid` BETWEEN 13 AND 15;
DELETE FROM `creature_text` WHERE `entry`=37119 AND `groupid` IN (4,5);
DELETE FROM `creature_text` WHERE `entry`=37181 AND `groupid`=2;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(37187,15,0, 'The paladin still lives? Is it possible, Highlord? Could he have survived?',0,0,0,6,0,17107, 'High Overlord Saurfang - SAY_SAURFANG_INTRO_1'),
(37187,16,0, 'Then we must save him! If we rescue Bolvar Fordragon, we may quell the unrest between the Alliance and the Horde.',0,0,0,5,0,17108, 'High Overlord Saurfang - SAY_SAURFANG_INTRO_2'),
(37187,17,0, 'Our mission is now clear: The Lich King will answer for his crimes and we will save Highlord Bolvar Fordragon!',0,0,0,15,0,17109, 'High Overlord Saurfang - SAY_SAURFANG_INTRO_3'),
(37187,18,0, 'Kor''kron, prepare Orgrim''s Hammer for its final voyage! Champions, our gunship will find a point to dock on the upper reaches of the citadel. Meet us there!',1,0,0,22,0,17110, 'High Overlord Saurfang - SAY_SAURFANG_INTRO_4'),
(37119,4,0, 'The power of the Light knows no bounds, Saurfang. His soul is under great strain, but he lives - for now.',0,0,0,1,0,16658, 'Highlord Tirion Fordring - SAY_TIRION_INTRO_5'),
(37181,2,0, 'But that honor is no longer yours. Soon, I will have a new champion.',1,0,0,0,0,17232, 'The Lich King - SAY_LK_INTRO_3'),
(37200,13,0, 'Could it be, Lord Fordring? If Bolvar lives, mayhap there is hope fer peace between the Alliance and the Horde. We must reach the top o'' this cursed place and free the paladin!',0,0,0,6,0,16980, 'Muradin Bronzebeard - SAY_SAURFANG_INTRO_2'),
(37200,14,0, 'Prepare the Skybreaker fer an aerial assault on the citadel!',1,0,0,5,0,16981, 'Muradin Bronzebeard - SAY_SAURFANG_INTRO_3'),
(37200,15,0, 'Heroes, ye must fight yer way to a clear extraction point within Icecrown. We''ll try an'' rendezvous on the ramparts!',1,0,0,22,0,16982, 'Muradin Bronzebeard - SAY_SAURFANG_INTRO_4'),
(37119,5,0, 'By the Light, it must be so!',0,0,0,5,0,16657, 'Highlord Tirion Fordring - SAY_TIRION_INTRO_A_5');
UPDATE `creature_template` SET `AIName`='SmartAI',`InhabitType`=7,`flags_extra`=`flags_extra`|128 WHERE `entry`=38557;
UPDATE `creature_template` SET `InhabitType`=7 WHERE `entry`=38558;
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-93946,0,0,0,25,0,100,0,0,0,0,0,11,72302,3,0,0,0,0,10,@GUID,0,0,0,0,0,0, 'Minchar Beam Stalker - Channel beam'),
(-93947,0,0,0,25,0,100,0,0,0,0,0,11,72301,3,0,0,0,0,10,@GUID,0,0,0,0,0,0, 'Minchar Beam Stalker - Channel beam'),
(-93948,0,0,0,25,0,100,0,0,0,0,0,11,72304,3,0,0,0,0,10,@GUID,0,0,0,0,0,0, 'Minchar Beam Stalker - Channel beam'),
(-93949,0,0,0,25,0,100,0,0,0,0,0,11,72303,3,0,0,0,0,10,@GUID,0,0,0,0,0,0, 'Minchar Beam Stalker - Channel beam');



-- SAI for Chief Engineer Galpen Rolltie
SET @ENTRY := 26600;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1,@ENTRY*100+2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,16000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 1 - STATE_WORK_MINING'),
(@ENTRY,0,3,4,40,0,100,0,7,@ENTRY,0,0,54,9000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 7 - pause path'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 7 - STATE_WORK_MINING'),
(@ENTRY,0,5,6,40,0,100,0,15,@ENTRY,0,0,54,14000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 15 - pause path'),
(@ENTRY,0,6,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Chief Engineer Galpen Rolltie - Reach wp 15 - STATE_WORK_MINING');
-- Waypoints for Chief Engineer Galpen Rolltie from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4138.141,5318.302,28.81850, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,2,4140.475,5319.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,3,4141.725,5323.979,29.04604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,4,4139.975,5327.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,5,4136.975,5328.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,6,4134.975,5327.229,29.29604, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,7,4135.308,5325.655,28.77358, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,8,4135.063,5327.819,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,9,4140.063,5327.819,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,10,4143.313,5325.319,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,11,4141.313,5317.819,29.77233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,12,4137.063,5314.819,29.02233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,13,4132.313,5316.569,29.02233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,14,4130.313,5319.819,29.27233, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,15,4131.816,5320.484,28.77108, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,16,4130.521,5321.019,29.24854, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,17,4131.021,5317.769,29.24854, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,18,4133.771,5315.769,28.99854, 'Chief Engineer Galpen Rolltie'),
(@ENTRY,19,4136.725,5316.553,28.72600, 'Chief Engineer Galpen Rolltie');


-- Pathing for Willis Wobblewheel SAI
SET @ENTRY := 26599;
-- SAI for Willis Wobblewheel
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,17000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 1 - STATE_WORK_MINING'),
(@ENTRY,0,3,4,40,0,100,0,3,@ENTRY,0,0,54,16000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 3 - pause path'),
(@ENTRY,0,4,5,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.288348, 'Willis Wobblewheel - Reach wp 3 - turn to'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Willis Wobblewheel - Reach wp 1 - STATE_USESTANDING');
-- Waypoints for Willis Wobblewheel from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4137.04,5285.097,25.23916, 'Willis Wobblewheel'),
(@ENTRY,2,4135.779,5282.234,25.11416, 'Willis Wobblewheel'),
(@ENTRY,3,4135.004,5281.168,25.11416, 'Willis Wobblewheel'),
(@ENTRY,4,4135.779,5282.234,25.11416, 'Willis Wobblewheel');

-- Pathing for Fizzcrank Watcher Rupert Keeneye SAI
SET @ENTRY := 26634;
-- SAI for Fizzcrank Watcher Rupert Keeneye
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Watcher Rupert Keeneye - On spawn - Start WP movement'),
(@ENTRY,0,1,0,40,0,100,0,2,@ENTRY,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Watcher Rupert Keeneye - Reach wp 2 - pause path'),
(@ENTRY,0,2,3,40,0,100,0,6,@ENTRY,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Watcher Rupert Keeneye - Reach wp 6 - pause path'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0.8901179, 'Fizzcrank Watcher Rupert Keeneye - Reach wp 6 - turn to');
-- Waypoints for Fizzcrank Watcher Rupert Keeneye from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4186.929,5321.105,58.13441, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,2,4185.132,5318.713,58.1639, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,3,4186.515,5316.936,58.15049, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,4,4186.929,5321.105,58.13441, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,5,4191.268,5319.607,58.12418, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,6,4189.929,5324.715,58.08976, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,7,4184.381,5325.549,58.05596, 'Fizzcrank Watcher Rupert Keeneye'),
(@ENTRY,8,4183.354,5318.837,58.1593, 'Fizzcrank Watcher Rupert Keeneye');

-- Pathing for Fizzcrank Engineering Crew SAI
SET @ENTRY := 26645;
SET @PATH2 := @ENTRY;
-- SAI for Fizzcrank Engineering Crew
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-117070,0,0,0,11,0,100,0,0,0,0,0,53,0,@PATH2,1,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - On spawn - Start WP movement'),
(-117070,0,1,2,40,0,100,0,5,@PATH2,0,0,54,20000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 5 - pause path'),
(-117070,0,2,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 5 - STATE_USESTANDING'),
(-117070,0,3,4,40,0,100,0,10,@PATH2,0,0,54,23000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 10 - pause path'),
(-117070,0,4,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 10 - STATE_WORK_MINING'),
(-117070,0,5,6,40,0,100,0,18,@PATH2,0,0,54,25000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 18 - pause path'),
(-117070,0,6,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 18 - STATE_WORK_MINING'),
(-117070,0,7,8,40,0,100,0,24,@PATH2,0,0,54,25000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 24 - pause path'),
(-117070,0,8,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Engineering Crew - Reach wp 24 - STATE_USESTANDING');
-- Waypoints for Fizzcrank Engineering Crew from sniff
DELETE FROM `waypoints` WHERE `entry` IN (@PATH,@PATH2);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@PATH2,1,4147.00,5327.734,29.32715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,2,4149.25,5326.734,29.07715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,3,4151.50,5329.484,29.32715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,4,4150.25,5330.734,29.32715, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,5,4148.829,5329.599,28.9719, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,6,4150.054,5331.477,29.32324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,7,4152.054,5333.477,29.07324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,8,4150.804,5335.727,29.07324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,9,4147.554,5336.477,29.07324, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,10,4143.779,5335.355,28.67457, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,11,4146.732,5336.823,29.20758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,12,4150.982,5335.573,29.20758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,13,4153.232,5331.323,28.95758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,14,4150.482,5326.823,28.70758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,15,4144.732,5324.573,29.45758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,16,4141.482,5326.823,29.20758, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,17,4139.686,5329.791,28.74058, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,18,4141.878,5331.735,28.69350, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,19,4141.274,5330.552,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,20,4141.774,5328.302,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,21,4142.774,5326.052,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,22,4145.524,5326.052,29.43795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,23,4146.774,5328.052,29.18795, 'Fizzcrank Engineering Crew wp 2'),
(@PATH2,24,4145.670,5329.370,28.68240, 'Fizzcrank Engineering Crew wp 2');

-- Pathing for Fizzcrank bomber Entry: 25765
SET @NPC := 95549;
SET @PATH := @NPC;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=4235.847,`position_y`=5353.55,`position_z`=81.03476 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`bytes2`,`mount`,`auras`) VALUES (@NPC,@PATH,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,4222.374,5370.328,72.03476,0,1,0,100,0),
(@PATH,2,4193.999,5364.787,66.81252,0,1,0,100,0),
(@PATH,3,4161.166,5319.937,66.81252,0,1,0,100,0),
(@PATH,4,4149.038,5289.545,66.81252,0,1,0,100,0),
(@PATH,5,4158.851,5255.303,66.81252,0,1,0,100,0),
(@PATH,6,4193.628,5230.504,79.17356,0,1,0,100,0),
(@PATH,7,4259.787,5211.473,79.20131,0,1,0,100,0),
(@PATH,8,4293.693,5221.593,80.20133,0,1,0,100,0),
(@PATH,9,4296.654,5282.716,82.20137,0,1,0,100,0),
(@PATH,10,4261.68,5314.814,89.8682,0,1,0,100,0),
(@PATH,11,4224.254,5366.333,98.86811,0,1,0,100,0),
(@PATH,12,4174.309,5345.78,98.86811,0,1,0,100,0),
(@PATH,13,4150.472,5287.501,98.86811,0,1,0,100,0),
(@PATH,14,4188.47,5251.628,102.757,0,1,0,100,0),
(@PATH,15,4241.055,5236.796,102.757,0,1,0,100,0),
(@PATH,16,4280.259,5260.132,105.6182,0,1,0,100,0),
(@PATH,17,4271.736,5301.975,105.6182,0,1,0,100,0),
(@PATH,18,4235.847,5353.55,81.03476,0,1,0,100,0);

-- Rig Hauler AC-9 SAI
SET @ENTRY := 25766;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,0,5000,10000,210000,210000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - OOC 3.5 min - start script 1'),
(@ENTRY,0,1,0,40,0,100,0,1,@ENTRY,0,0,45,0,1,0,0,0,0,11,25765,20,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 1 - dataset 0 1 nearest Fizzcrank Bomber'),
(@ENTRY,0,2,3,40,0,100,0,5,@ENTRY,0,0,54,5000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 5 - pause wp'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,92,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 5 - INTERRUPT_SPELL'),
(@ENTRY,0,4,0,40,0,100,0,6,@ENTRY,0,0,45,0,1,0,0,0,0,10,106069,15214,0,0,0,0,0, 'Rig Hauler AC-9 - Reach wp 6 - dataset 0 1 Invisable Stalker'),
(@ENTRY,0,5,0,40,0,100,0,25,@ENTRY,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,2.740167, 'Rig Hauler AC-9 - Reach wp 25 - turn to'),
-- Script
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,12,25765,3,360000,0,0,0,8,0,0,0,4165.76,5354.39,30.1116,2.35619, 'Rig Hauler AC-9 - script - summon 25765'),
(@ENTRY*100,9,1,0,0,0,100,0,6000,6000,0,0,11,45967,0,0,0,0,0,11,25765,10,0,0,0,0,0, 'Rig Hauler AC-9 - script - cast 45967'),
(@ENTRY*100,9,2,0,0,0,100,0,3000,3000,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Rig Hauler AC-9 - script - Start WP movement');
-- Waypoints for Rig Hauler AC-9 from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4149.316,5357.732,29.11953, 'Rig Hauler AC-9'),
(@ENTRY,2,4136.816,5345.482,29.11953, 'Rig Hauler AC-9'),
(@ENTRY,3,4125.566,5333.982,29.11953, 'Rig Hauler AC-9'),
(@ENTRY,4,4115.297,5323.852,28.67458, 'Rig Hauler AC-9'),
(@ENTRY,5,4108.158,5316.849,28.75930, 'Rig Hauler AC-9'),
(@ENTRY,6,4111.660,5313.279,28.75930, 'Rig Hauler AC-9'),
(@ENTRY,7,4112.747,5314.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,8,4116.997,5314.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,9,4118.997,5316.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,10,4125.247,5323.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,11,4127.247,5325.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,12,4129.497,5326.696,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,13,4131.497,5328.446,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,14,4133.497,5328.446,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,15,4134.747,5329.446,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,16,4135.747,5333.696,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,17,4141.997,5337.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,18,4143.997,5341.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,19,4145.997,5344.946,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,20,4147.247,5346.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,21,4150.247,5348.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,22,4152.247,5350.196,29.16189, 'Rig Hauler AC-9'),
(@ENTRY,23,4162.747,5356.196,29.66189, 'Rig Hauler AC-9'),
(@ENTRY,24,4166.997,5358.696,30.41189, 'Rig Hauler AC-9'),
(@ENTRY,25,4170.335,5359.113,30.06447, 'Rig Hauler AC-9');

-- Fizzcrank Bomber SAI
SET @ENTRY := 25765;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - on dataset 0 1 - dataset 0 0'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - on dataset 0 1 - Start WP movement'),
(@ENTRY,0,2,3,40,0,100,0,22,@ENTRY,0,0,54,45000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 22 - pause wp'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 22 - Set Speed run'),
(@ENTRY,0,4,5,40,0,100,0,74,@ENTRY,0,0,11,47460,3,0,0,0,0,11,26817,5,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 74 - cast 47460 on Fizzcrank fighter'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Bomber - Reach wp 74 - despawn');
-- Waypoints for Fizzcrank Bomber from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4164.758,5354.723,30.19215, 'Fizzcrank Bomber wp 1'),
(@ENTRY,2,4162.034,5355.368,30.09748, 'Fizzcrank Bomber wp 1'),
(@ENTRY,3,4159.190,5355.827,30.01153, 'Fizzcrank Bomber wp 1'),
(@ENTRY,4,4156.273,5356.132,29.94405, 'Fizzcrank Bomber wp 1'),
(@ENTRY,5,4154.659,5355.736,29.91132, 'Fizzcrank Bomber wp 1'),
(@ENTRY,6,4152.153,5354.786,29.86976, 'Fizzcrank Bomber wp 1'),
(@ENTRY,7,4149.633,5353.545,29.83581, 'Fizzcrank Bomber wp 1'),
(@ENTRY,8,4147.138,5352.081,29.80874, 'Fizzcrank Bomber wp 1'),
(@ENTRY,9,4144.689,5350.449,29.78749, 'Fizzcrank Bomber wp 1'),
(@ENTRY,10,4142.290,5348.694,29.77098, 'Fizzcrank Bomber wp 1'),
(@ENTRY,11,4139.963,5346.840,29.76581, 'Fizzcrank Bomber wp 1'),
(@ENTRY,12,4137.673,5344.909,29.76182, 'Fizzcrank Bomber wp 1'),
(@ENTRY,13,4135.418,5342.924,29.75874, 'Fizzcrank Bomber wp 1'),
(@ENTRY,14,4133.194,5340.901,29.75638, 'Fizzcrank Bomber wp 1'),
(@ENTRY,15,4130.993,5338.848,29.75706, 'Fizzcrank Bomber wp 1'),
(@ENTRY,16,4128.794,5336.785,29.75758, 'Fizzcrank Bomber wp 1'),
(@ENTRY,17,4126.612,5334.716,29.75798, 'Fizzcrank Bomber wp 1'),
(@ENTRY,18,4124.430,5332.629,29.75829, 'Fizzcrank Bomber wp 1'),
(@ENTRY,19,4121.542,5329.849,29.75858, 'Fizzcrank Bomber wp 1'),
(@ENTRY,20,4118.184,5326.597,29.75881, 'Fizzcrank Bomber wp 1'),
(@ENTRY,21,4116.024,5324.498,29.75892, 'Fizzcrank Bomber wp 1'),
(@ENTRY,22,4113.869,5322.398,29.75901, 'Fizzcrank Bomber wp 1'),
(@ENTRY,23,4090.109,5298.56,29.70082, 'Fizzcrank Bomber wp 1'),
(@ENTRY,24,4079.459,5287.617,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,25,4066.779,5274.603,31.53571, 'Fizzcrank Bomber wp 1'),
(@ENTRY,26,4041.215,5249.248,31.45236, 'Fizzcrank Bomber wp 1'),
(@ENTRY,27,4020.432,5218.824,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,28,4002.392,5190.421,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,29,4000.105,5146.331,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,30,3993.002,5119.754,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,31,3976.405,5093.208,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,32,3983.637,5055.651,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,33,3990.106,5011.049,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,34,3992.433,4984.051,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,35,3988.744,4946.948,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,36,3975.796,4912.274,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,37,3958.111,4895.366,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,38,3928.622,4858.76,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,39,3921.781,4825.03,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,40,3935.435,4790.436,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,41,3966.323,4756.983,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,42,3987.75,4763.042,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,43,4025.366,4755.083,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,44,4050.189,4787.045,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,45,4082.41,4825.174,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,46,4084.739,4845.887,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,47,4082.781,4879.066,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,48,4075.255,4897.705,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,49,4063.763,4936.532,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,50,4066.78,4968.409,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,51,4082.993,4997.696,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,52,4110.507,5030.572,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,53,4141.148,5060.043,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,54,4164.455,5087.176,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,55,4189.664,5124.69,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,56,4214.33,5154.247,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,57,4237.962,5194.166,29.8968, 'Fizzcrank Bomber wp 1'),
(@ENTRY,58,4228.307,5238.578,42.11903, 'Fizzcrank Bomber wp 1'),
(@ENTRY,59,4200.375,5271.218,46.75792, 'Fizzcrank Bomber wp 1'),
(@ENTRY,60,4211.719,5318.444,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,61,4229.69,5356.218,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,62,4229.779,5396.165,53.08044, 'Fizzcrank Bomber wp 1'),
(@ENTRY,63,4231.299,5419.959,53.71933, 'Fizzcrank Bomber wp 1'),
(@ENTRY,64,4228.378,5466.135,57.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,65,4249.183,5490.759,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,66,4282.767,5500.858,48.85822, 'Fizzcrank Bomber wp 1'),
(@ENTRY,67,4300.521,5486.341,48.386, 'Fizzcrank Bomber wp 1'),
(@ENTRY,68,4291.369,5470.349,48.91378, 'Fizzcrank Bomber wp 1'),
(@ENTRY,69,4277.046,5454.25,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,70,4253.641,5434.851,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,71,4227.768,5423.928,47.13599, 'Fizzcrank Bomber wp 1'),
(@ENTRY,72,4204.012,5411.217,37.52486, 'Fizzcrank Bomber wp 1'),
(@ENTRY,73,4194.847,5402.538,32.41374, 'Fizzcrank Bomber wp 1'),
(@ENTRY,74,4178.285,5386.063,30.94151, 'Fizzcrank Bomber wp 1');

-- Invisable Stalker SAI
SET @ENTRY := 15214;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` in (-112623,-112625);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-112623,0,0,1,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Invisable Stalker - on dataset 0 1 - dataset 0 0'),
(-112625,0,1,0,61,0,100,0,0,0,0,0,11,47453,3,0,0,0,0,11,25766,200,0,0,0,0,0, 'Invisable Stalker - on dataset 0 1 - Cast 47453 on Rig Hauler AC-9');

-- Fizzcrank Fighter SAI
SET @ENTRY := 26817;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Fighter - on spawn - start wp'),
(@ENTRY,0,1,0,1,0,100,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Fighter - on spawn - say text 0'),
(@ENTRY,0,2,0,40,0,100,0,15,@ENTRY,0,0,11,43671,3,0,0,0,0,11,25765,20,0,0,0,0,0, 'Fizzcrank Fighter - Reach wp 15 - cast 43671 on Fizzcrank Bomber');
-- NPC talk text for Fizzcrank Fighter
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'I''ll blast those gnomish wannabes back to the scrap heap!',0,7,100,0,0,0, 'Fizzcrank Fighter'),
(@ENTRY,0,1, 'You''re sending me back there?!',0,7,100,0,0,0, 'Fizzcrank Fighter');
-- Waypoints for Fizzcrank Fighter from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4176.501,5280.566,27.17445, 'Fizzcrank Fighter'),
(@ENTRY,2,4167.001,5282.066,27.17445, 'Fizzcrank Fighter'),
(@ENTRY,3,4164.751,5282.566,26.92445, 'Fizzcrank Fighter'),
(@ENTRY,4,4162.655,5282.681,26.48916, 'Fizzcrank Fighter'),
(@ENTRY,5,4158.462,5280.628,26.26419, 'Fizzcrank Fighter'),
(@ENTRY,6,4155.712,5279.378,25.76419, 'Fizzcrank Fighter'),
(@ENTRY,7,4154.958,5278.939,24.86416, 'Fizzcrank Fighter'),
(@ENTRY,8,4147.710,5281.817,24.86416, 'Fizzcrank Fighter'),
(@ENTRY,9,4144.757,5295.502,25.61416, 'Fizzcrank Fighter'),
(@ENTRY,10,4142.652,5300.067,26.94346, 'Fizzcrank Fighter'),
(@ENTRY,11,4137.876,5308.749,27.94350, 'Fizzcrank Fighter'),
(@ENTRY,12,4135.610,5310.586,28.93834, 'Fizzcrank Fighter'),
(@ENTRY,13,4131.433,5312.564,28.75930, 'Fizzcrank Fighter'),
(@ENTRY,14,4123.820,5317.622,28.75930, 'Fizzcrank Fighter'),
(@ENTRY,15,4115.430,5321.649,28.75930, 'Fizzcrank Fighter');

-- Pathing for Crafty Wobblesprocket SAI
SET @ENTRY := 25477;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=4172.788,`position_y`=5254.925,`position_z`=26.12851 WHERE `guid`=108021;
-- SAI for Crafty Wobblesprocket
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100,@ENTRY*100+1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - On spawn - Start WP movement'),
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,45000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,17,69,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 1 - STATE_USESTANDING'),
(@ENTRY,0,3,4,40,0,100,0,6,@ENTRY,0,0,54,35000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 6 - pause path'),
(@ENTRY,0,4,5,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0.4712389, 'Crafty Wobblesprocket - Reach wp 6 - turn to'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Crafty Wobblesprocket - Reach wp 6 - STATE_WORK_MINING');
-- Waypoints for Crafty Wobblesprocket from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4179.099,5251.51,26.37851, 'Crafty Wobblesprocket'),
(@ENTRY,2,4177.94,5250.202,26.87851, 'Crafty Wobblesprocket'),
(@ENTRY,3,4181.048,5243.429,24.87851, 'Crafty Wobblesprocket'),
(@ENTRY,4,4182.067,5222.448,25.00868, 'Crafty Wobblesprocket'),
(@ENTRY,5,4193.037,5217.233,25.13368, 'Crafty Wobblesprocket'),
(@ENTRY,6,4193.037,5217.233,25.13368, 'Crafty Wobblesprocket'),
(@ENTRY,7,4190.718,5217.938,25.25868, 'Crafty Wobblesprocket'),
(@ENTRY,8,4176.049,5229.444,24.50868, 'Crafty Wobblesprocket'),
(@ENTRY,9,4166.732,5248.798,24.75351, 'Crafty Wobblesprocket'),
(@ENTRY,10,4172.788,5254.925,26.12851, 'Crafty Wobblesprocket');


-- SAI for Fizzcrank Airstrip Survivor
SET @ENTRY := 25783;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,0,0,0,0,11,34427,3,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on spawn - cast 34427 on self'),
(@ENTRY,0,1,0,1,0,100,1,1000,1000,1000,1000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on spawn - say text 0'),
(@ENTRY,0,2,3,38,0,100,0,0,1,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on dataset 0 1 - dataset 0 0'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,53,0,@ENTRY,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - on dataset 0 1 - Start WP movement'),
(@ENTRY,0,4,0,40,0,100,0,6,@ENTRY,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Airstrip Survivor - Reach wp 6 - despawn');
-- Waypoints for Fizzcrank Airstrip Survivor from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4168.529,5251.933,24.87851, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,2,4156.656,5256.007,24.62325, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,3,4151.527,5268.997,25.36416, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,4,4159.549,5281.078,26.23916, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,5,4173.898,5280.844,26.69306, 'Fizzcrank Airstrip Survivor'),
(@ENTRY,6,4179.473,5282.701,26.69306, 'Fizzcrank Airstrip Survivor');
-- NPC talk text for Fizzcrank Survivor
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'I''m flesh and blood again. That''s all that matters!',0,7,100,5,0,0, 'Fizzcrank Survivor');


-- Jean Pierre Poulain SAI
SET @ENTRY  := 34244;
SET @GOSSIP := 10478;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,64795,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Jean Pierre Poulain - On gossip option select - cast spell');
-- Fizzcrank Fullthrottle SAI
SET @ENTRY  := 25590;
SET @GOSSIP := 9171;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,15,11708,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Fullthrottle - On gossip option select - quest complete'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Fullthrottle - On gossip option select - close gossip');
-- Keeper Remulos SAI
SET @ENTRY  := 11832;
SET @GOSSIP := 10215;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,@GOSSIP,0,0,0,11,57413,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Keeper Remulos - On gossip option select - cast spell'),
(@ENTRY,0,1,2,62,0,100,0,@GOSSIP,1,0,0,11,57670,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Keeper Remulos - On gossip option select - cast spell'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Keeper Remulos - On gossip option select - close gossip');
-- Fizzcrank Recon Pilot SAI
SET @ENTRY  := 25841;
SET @GOSSIP := 9190;
SET @SCRIPT := 50028;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,46362,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On gossip option select - close gossip'),
(@ENTRY,0,2,0,11,0,100,0,0,0,0,0,81,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On spawn - set gossip flag'),
(@ENTRY,0,3,4,8,0,100,0,46362,0,0,0,11,46362,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On spellhit - cast spell on envoker'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - On spellhit - set phase 1'),
(@ENTRY,0,5,0,1,1,100,0,3000,3000,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fizzcrank Recon Pilot - OOC - wait 3 sec despawn (Phase 1)');
-- Glodrak Huntsniper SAI
SET @ENTRY  := 24657;
SET @GOSSIP := 9016;
SET @SCRIPT := 10603;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,66592,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Glodrak Huntsniper - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Glodrak Huntsniper - On gossip option select - close gossip');
-- Goldark Snipehunter SAI
SET @ENTRY  := 23486;
SET @GOSSIP := 9006;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,66592,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Goldark Snipehunter - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Goldark Snipehunter - On gossip option select - close gossip');

-- Pol Amberstill & Driz Tumblequick SAI
SET @ENTRY   := 24468;
SET @ENTRY1  := 24510;
SET @GOSSIP  := 8958;
SET @GOSSIP1 := 8958;
SET @SCRIPT  := 8958;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (@ENTRY,@ENTRY1);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@ENTRY,@ENTRY1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- Pol Amberstill
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,6,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - close gossip'),
(@ENTRY,0,2,3,62,0,100,0,@GOSSIP1,0,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - cast spell'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Pol Amberstill - On gossip option select - close gossip'),
-- Driz Tumblequick
(@ENTRY1,0,0,1,62,0,100,0,@GOSSIP,6,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - cast spell'),
(@ENTRY1,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - close gossip'),
(@ENTRY1,0,2,3,62,0,100,0,@GOSSIP1,0,0,0,11,44262,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - cast spell'),
(@ENTRY1,0,3,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Driz Tumblequick - On gossip option select - close gossip');
-- Steel Gate Chief Archaeologist SAI
SET @ENTRY  := 24399;
SET @GOSSIP := 8954;
SET @SCRIPT := 24399;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,43533,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On gossip option select - close gossip');

-- Drakuru SAI
SET @ENTRY := 26423;
SET @GOSSIP := 9615;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,33,27921,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Drakuru - On gossip option select - killcredit'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Drakuru - On gossip option select - close gossip');

-- Dread Captain DeMeza SAI
SET @ENTRY := 28048;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,9647,0,0,0,11,50517,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Dread Captain DeMeza - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Dread Captain DeMeza - On gossip option select - close gossip');
-- Scourge Deathspeaker SAI 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=27615;
DELETE FROM `smart_scripts` WHERE `entryorguid`=27615;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27615,0,0,1,1,0,100,1,1000,1000,1000,1000,11,49119,2,0,0,0,0,10,101497,27452,0,0,0,0,0,'Scourge Deathspeaker - Spawn & reset - channel Fire Beam'),
(27615,0,1,0,61,0,100,1,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - Spawn & reset - Prevent Combat Movement'),
(27615,0,2,3,4,0,100,1,0,0,0,0,11,52282,2,0,0,0,0,2,0,0,0,0,0,0,0,'Scourge Deathspeaker - On aggro - Cast Fireball'),
(27615,0,3,0,61,0,100,1,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - On aggro - Set phase 1'),
(27615,0,4,0,9,1,100,0,3000,3000,3400,4800,11,52282,1,0,0,0,0,2,0,0,0,0,0,0,0,'Scourge Deathspeaker - in combat - Cast Fireball (phase 1)'),
(27615,0,5,0,9,1,100,0,35,80,1000,1000,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 35 Yards - Start Combat Movement (phase 1)'),
(27615,0,6,0,9,1,100,0,5,15,1000,1000,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15 Yards - Prevent Combat Movement (phase 1)'),
(27615,0,7,0,9,1,100,0,0,5,1000,1000,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scourge Deathspeaker - Below 5 Yards - Start Combat Movement (phase 1)'),
(27615,0,8,0,3,1,100,1,0,7,0,0,22,2,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - Mana at 7% - Set Phase 2 (phase 1)'),
(27615,0,9,0,0,2,100,1,0,0,0,0,21,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - In combat - Allow Combat Movement (phase 2)'),
(27615,0,10,0,3,2,100,1,15,100,100,100,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - Mana above 15% - Set Phase 1 (phase 2)'),
(27615,0,11,0,2,0,100,1,0,30,120000,130000,11,52281,0,0,0,0,0,2,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Cast Flame of the Seer'),
(27615,0,12,0,2,0,100,1,0,15,0,0,22,3,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Set Phase 3'),
(27615,0,13,0,2,4,100,1,0,15,0,0,21,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Allow Combat Movement (phase 3)'),
(27615,0,14,15,2,4,100,1,0,15,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Scourge Deathspeaker - At 15% HP - Flee (phase 3)'),
(27615,0,15,0,61,4,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Scourge Deathspeaker - At 15% HP - Say text0 (Phase 3)');

-- NPC talk text insert
DELETE FROM `creature_text` WHERE `entry` IN (27615);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(27615,0,0, '%s attempts to run away in fear!',2,0,100,0,0,0, 'Scourge Deathspeaker');

-- SET InhabitType for Invisible Stalker Grizzly Hills
UPDATE `creature_template` SET `InhabitType`=7 WHERE `entry`=27452;

-- SAI for Dark Conclave Ritualist
SET @ENTRY := 22138;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,1,0,100,1,1000,1000,1000,1000,11,38469,0,0,0,0,0,19,22139,0,0,0,0,0,0,'Dark Conclave Ritualist - OOC - Dark Conclave Ritualist Channel');


-- SAI add animation to GameObject Smoke Beacon
SET @ENTRY := 184661;
UPDATE `gameobject_template` SET `AIName`= 'SmartGameObjectAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=1 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,1,0,0,1,0,100,0,0,0,1000,1000,93,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'GameObject Smoke Beacon - On Spawn - Do Custom Animation');

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower South
SET @ENTRY := 21182;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,1,0,0,0,0,10,78738,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower South from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-1156.975,2109.627,83.51005,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 1'),
(@ENTRY,2,-1152.303,2112.098,90.67654,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 2'),
(@ENTRY,3,-1150.817,2103.74,89.81573,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 3'),
(@ENTRY,4,-1153.965,2107.031,97.06559,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 4'),
(@ENTRY,5,-1156.105,2107.421,93.06557,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 5'),
(@ENTRY,6,-1152.167,2107.406,83.17665,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 6'),
(@ENTRY,7,-1150.145,2102.392,75.23684,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 7'),
(@ENTRY,8,-1158.784,2102.993,76.98234,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 8'),
(@ENTRY,9,-1158.344,2112.019,79.20454,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 9'),
(@ENTRY,10,-1148.166,2113.343,77.0103,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 10'),
(@ENTRY,11,-1148.897,2102.624,69.67694,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 11'),
(@ENTRY,12,-1157.054,2104.975,82.9548,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South WP 12');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-1157.054,`position_y`=2104.975,`position_z`=82.9548,`orientation`=1.186824 WHERE `guid`=74299;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower North
SET @ENTRY := 22401;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,2,0,0,0,0,10,74239,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower North from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-821.9919,2034.883,55.01843,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 1'),
(@ENTRY,2,-820.9771,2027.591,63.68367,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 2'),
(@ENTRY,3,-825.2185,2034.113,65.86314,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 3'),
(@ENTRY,4,-816.8493,2028.659,49.75199,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 4'),
(@ENTRY,5,-825.249,2026.351,46.58422,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North WP 5');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-825.249,`position_y`=2026.351,`position_z`=46.58422,`orientation`=1.186824 WHERE `guid`=78735;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Forge
SET @ENTRY := 22402;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,3,0,0,0,0,10,74239,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Forge from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-897.1001,1917.556,93.73737,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 1'),
(@ENTRY,2,-903.386,1919.14,76.0997,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 2'),
(@ENTRY,3,-898.1819,1920.161,82.67819,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 3'),
(@ENTRY,4,-901.2836,1920.168,92.57269,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 4'),
(@ENTRY,5,-894.9478,1924.78,75.48938,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 5'),
(@ENTRY,6,-894.4704,1919.866,93.71019,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge WP 6');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-894.4704,`position_y`=1919.866,`position_z`=93.71019,`orientation`=1.186824 WHERE `guid`=78736;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Foothill
SET @ENTRY := 22403;
UPDATE `creature_template` SET `minlevel`=1,`maxlevel`=1,`flags_extra`=`flags_extra`&~2,`flags_extra`=`flags_extra`|128,`InhabitType`=4,`AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On Spawn - Start WP movement'),
(@ENTRY,0,1,2,8,0,100,0,36374,0,0,0,45,0,4,0,0,0,0,10,74239,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On spell hit - Call Griphonriders'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On spell hit - Spawn fire');

-- Waypoints for Zeth'Gor Quest Credit Marker, They Must Burn, Tower Foothill from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,-978.3713,1883.556,104.3167,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 1'),
(@ENTRY,2,-974.3038,1878.926,109.6782,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 2'),
(@ENTRY,3,-974.1463,1874.819,121.9402,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 3'),
(@ENTRY,4,-982.4401,1875.441,100.4122,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 4'),
(@ENTRY,5,-975.1263,1882.178,118.0354,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 5'),
(@ENTRY,6,-979.3693,1876.667,121.5866,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill WP 6');
-- Update Creature
UPDATE `creature` SET `curhealth`=1,`spawndist`=0,`MovementType`=0,`position_x`=-979.3693,`position_y`=1876.667,`position_z`=121.5866,`orientation`=1.186824 WHERE `guid`=78737;

-- SAI for Zeth'Gor Quest Credit Marker, They Must Burn
SET @ENTRY  := 21173; -- Zeth'Gor Quest Credit Marker, They Must Burn
SET @ENTRY1 := 21170; -- Honor Hold Gryphon Brigadier, South
SET @ENTRY2 := 22404; -- Honor Hold Gryphon Brigadier, North
SET @ENTRY3 := 22405; -- Honor Hold Gryphon Brigadier, Forge
SET @ENTRY4 := 22406; -- Honor Hold Gryphon Brigadier, Foothills
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100, (@ENTRY*100)+1, (@ENTRY*100)+2, (@ENTRY*100)+3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- AI
(@ENTRY,0,0,0,38,0,100,0,0,1,0,0,80,(@ENTRY*100)+0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On dataset - load script'),
(@ENTRY,0,1,0,38,0,100,0,0,2,0,0,80,(@ENTRY*100)+1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On dataset - load script'),
(@ENTRY,0,2,0,38,0,100,0,0,3,0,0,80,(@ENTRY*100)+2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On dataset - load script'),
(@ENTRY,0,3,0,38,0,100,0,0,4,0,0,80,(@ENTRY*100)+3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On dataset - load script'),
-- Script 0
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Reset data 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,1000,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,3,0,0,0,100,0,0,0,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,5,0,0,0,100,0,0,0,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,7,0,0,0,100,0,0,0,0,0,11,36302,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
(@ENTRY*100,9,8,0,0,0,100,0,3000,3000,0,0,45,0,4,0,0,0,0,19,@ENTRY1,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, South'),
-- Script 1
((@ENTRY*100)+1,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Reset data 0'),
((@ENTRY*100)+1,9,1,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,3,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,5,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,7,0,0,0,100,0,0,0,0,0,11,39106,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
((@ENTRY*100)+1,9,8,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY2,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, North'),
-- Script 2
((@ENTRY*100)+2,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Reset data 0'),
((@ENTRY*100)+2,9,1,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,3,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,5,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,7,0,0,0,100,0,0,0,0,0,11,39107,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
((@ENTRY*100)+2,9,8,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY3,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Forge'),
-- Script 3
((@ENTRY*100)+3,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Reset data 0'),
((@ENTRY*100)+3,9,1,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,2,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,3,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,4,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,5,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,6,0,0,0,100,0,3000,3000,0,0,45,0,3,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,7,0,0,0,100,0,0,0,0,0,11,39108,0,0,0,0,0,1,0,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill'),
((@ENTRY*100)+3,9,8,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,19,@ENTRY4,0,0,0,0,0,0, ' Summon Honor Hold Gryphon Brigadier, Foothill');

-- SAI for Honor Hold Gryphon Brigadier, South
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY1;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY1,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY1,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY1*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY1*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY1*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,4,0,38,0,100,0,0,4,0,0,53,1,(@ENTRY1*100)+3,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY1,0,5,0,40,0,100,0,10,@ENTRY1*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY1,0,6,0,40,0,100,0,10,(@ENTRY1*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY1,0,7,0,40,0,100,0,11,(@ENTRY1*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY1,0,8,0,40,0,100,0,11,(@ENTRY1*100)+3,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- SAI for Honor Hold Gryphon Brigadier, North
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY2;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY2,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY2,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY2*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY2*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY2*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,4,0,38,0,100,0,0,4,0,0,53,1,(@ENTRY2*100)+3,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY2,0,5,0,40,0,100,0,12,@ENTRY2*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY2,0,6,0,40,0,100,0,11,(@ENTRY2*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY2,0,7,0,40,0,100,0,12,(@ENTRY2*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY2,0,8,0,40,0,100,0,12,(@ENTRY2*100)+3,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- SAI for Honor Hold Gryphon Brigadier, Forge
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY3;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY3;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY3,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY3,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY3*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY3*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY3*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,4,0,38,0,100,0,0,4,0,0,53,1,(@ENTRY3*100)+3,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY3,0,5,0,40,0,100,0,13,@ENTRY3*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY3,0,6,0,40,0,100,0,13,(@ENTRY3*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY3,0,7,0,40,0,100,0,12,(@ENTRY3*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY3,0,8,0,40,0,100,0,14,(@ENTRY3*100)+3,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- SAI for Honor Hold Gryphon Brigadier, Foothill
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY4;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY4;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY4,0,0,0,11,0,100,0,0,0,0,0,11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spawn - Add aura'),
(@ENTRY4,0,1,0,38,0,100,0,0,1,0,0,53,1,@ENTRY4*100,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY4,0,2,0,38,0,100,0,0,2,0,0,53,1,(@ENTRY4*100)+1,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY4,0,3,0,38,0,100,0,0,3,0,0,53,1,(@ENTRY4*100)+2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On data set - Start WP movement'),
(@ENTRY4,0,4,0,40,0,100,0,15,@ENTRY4*100,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY4,0,5,0,40,0,100,0,15,(@ENTRY4*100)+1,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn'),
(@ENTRY4,0,6,0,40,0,100,0,15,(@ENTRY4*100)+2,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Reach WP - Despawn');

-- Honor Hold Gryphon Brigadier, South Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY1*100, (@ENTRY1*100)+1, (@ENTRY1*100)+2, (@ENTRY1*100)+3);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, South Path 1
(@ENTRY1*100,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 1 WP 1'),
(@ENTRY1*100,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 1 WP 2'),
(@ENTRY1*100,3,-1162.907,2207.568,140.9076,'Honor Hold Gryphon Brigadier, South Path 1 WP 3'),
(@ENTRY1*100,4,-1165.149,2160.382,126.1298,'Honor Hold Gryphon Brigadier, South Path 1 WP 4'),
(@ENTRY1*100,5,-1171.198,2119.914,110.0741,'Honor Hold Gryphon Brigadier, South Path 1 WP 5'),
(@ENTRY1*100,6,-1152.598,2108.961,101.9074,'Honor Hold Gryphon Brigadier, South Path 1 WP 6'),
(@ENTRY1*100,7,-1126.18,2129.599,118.6573,'Honor Hold Gryphon Brigadier, South Path 1 WP 7'),
(@ENTRY1*100,8,-1113.314,2146.836,135.1296,'Honor Hold Gryphon Brigadier, South Path 1 WP 8'),
(@ENTRY1*100,9,-1105.45,2173.646,171.0185,'Honor Hold Gryphon Brigadier, South Path 1 WP 9'),
(@ENTRY1*100,10,-1107.9,2202.193,195.935,'Honor Hold Gryphon Brigadier, South Path 1 WP 10'),
-- Honor Hold Gryphon Brigadier, South Path 2
((@ENTRY1*100)+1,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 2 WP 1'),
((@ENTRY1*100)+1,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 2 WP 2'),
((@ENTRY1*100)+1,3,-1182.963,2208.794,125.3797,'Honor Hold Gryphon Brigadier, South Path 2 WP 3'),
((@ENTRY1*100)+1,4,-1182.292,2161.906,114.2409,'Honor Hold Gryphon Brigadier, South Path 2 WP 4'),
((@ENTRY1*100)+1,5,-1175.9,2113.828,105.1853,'Honor Hold Gryphon Brigadier, South Path 2 WP 5'),
((@ENTRY1*100)+1,6,-1152.598,2108.961,104.5463,'Honor Hold Gryphon Brigadier, South Path 2 WP 6'),
((@ENTRY1*100)+1,7,-1126.18,2129.599,117.0184,'Honor Hold Gryphon Brigadier, South Path 2 WP 7'),
((@ENTRY1*100)+1,8,-1097.298,2159.928,136.074,'Honor Hold Gryphon Brigadier, South Path 2 WP 8'),
((@ENTRY1*100)+1,9,-1084.76,2185.17,157.8796,'Honor Hold Gryphon Brigadier, South Path 2 WP 9'),
((@ENTRY1*100)+1,10,-1074.359,2208.386,178.1295,'Honor Hold Gryphon Brigadier, South Path 2 WP 10'),
-- Honor Hold Gryphon Brigadier, South Path 3
((@ENTRY1*100)+2,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 3 WP 1'),
((@ENTRY1*100)+2,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 3 WP 2'),
((@ENTRY1*100)+2,3,-1150.548,2194.858,120.9303,'Honor Hold Gryphon Brigadier, South Path 3 WP 3'),
((@ENTRY1*100)+2,4,-1151.814,2161.048,110.9858,'Honor Hold Gryphon Brigadier, South Path 3 WP 4'),
((@ENTRY1*100)+2,5,-1152.937,2131.728,105.9581,'Honor Hold Gryphon Brigadier, South Path 3 WP 5'),
((@ENTRY1*100)+2,6,-1151.148,2107.598,99.458,'Honor Hold Gryphon Brigadier, South Path 3 WP 6'),
((@ENTRY1*100)+2,7,-1165.406,2089.037,115.6802,'Honor Hold Gryphon Brigadier, South Path 3 WP 7'),
((@ENTRY1*100)+2,8,-1174.068,2083.782,125.0691,'Honor Hold Gryphon Brigadier, South Path 3 WP 8'),
((@ENTRY1*100)+2,9,-1205.327,2083.083,164.097,'Honor Hold Gryphon Brigadier, South Path 3 WP 9'),
((@ENTRY1*100)+2,10,-1232.793,2084.872,183.4025,'Honor Hold Gryphon Brigadier, South Path 3 WP 10'),
((@ENTRY1*100)+2,11,-1264.571,2093.127,197.5136,'Honor Hold Gryphon Brigadier, South Path 3 WP 11'),
-- Honor Hold Gryphon Brigadier, South Path 4
((@ENTRY1*100)+3,1,-1166.146,2232.443,154.4811,'Honor Hold Gryphon Brigadier, South Path 4 WP 1'),
((@ENTRY1*100)+3,2,-1166.439,2233.399,154.4811,'Honor Hold Gryphon Brigadier, South Path 4 WP 2'),
((@ENTRY1*100)+3,3,-1152.79,2211.288,120.9303,'Honor Hold Gryphon Brigadier, South Path 4 WP 3'),
((@ENTRY1*100)+3,4,-1146.584,2178.448,110.9858,'Honor Hold Gryphon Brigadier, South Path 4 WP 4'),
((@ENTRY1*100)+3,5,-1155.939,2146.783,105.9581,'Honor Hold Gryphon Brigadier, South Path 4 WP 5'),
((@ENTRY1*100)+3,6,-1151.148,2107.598,99.68026,'Honor Hold Gryphon Brigadier, South Path 4 WP 6'),
((@ENTRY1*100)+3,7,-1142.785,2094.159,103.5414,'Honor Hold Gryphon Brigadier, South Path 4 WP 7'),
((@ENTRY1*100)+3,8,-1136.896,2085.377,109.1246,'Honor Hold Gryphon Brigadier, South Path 4 WP 8'),
((@ENTRY1*100)+3,9,-1119.036,2071.976,118.8748,'Honor Hold Gryphon Brigadier, South Path 4 WP 9'),
((@ENTRY1*100)+3,10,-1103.594,2050.397,128.2081,'Honor Hold Gryphon Brigadier, South Path 4 WP 10'),
((@ENTRY1*100)+3,11,-1080.568,2022.377,137.5138,'Honor Hold Gryphon Brigadier, South Path 4 WP 11');

-- Honor Hold Gryphon Brigadier, North Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY2*100, (@ENTRY2*100)+1, (@ENTRY2*100)+2, (@ENTRY2*100)+3);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, North Path 1
(@ENTRY2*100,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,4,-774.873,1952.79,99.47905,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,5,-786.8572,1972.59,99.47905,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,6,-799.9429,2000.454,78.95126,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,7,-806.1043,2017.675,73.36794,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,8,-819.2725,2032.523,73.17354,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,9,-831.7571,2046.865,80.61793,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,10,-844.0977,2058.49,83.64579,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,11,-859.0389,2080.072,95.78463,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
(@ENTRY2*100,12,-883.3383,2095.611,107.5624,'Honor Hold Gryphon Brigadier, North Path 1 WP'),
-- Honor Hold Gryphon Brigadier, North Path 2
((@ENTRY2*100)+1,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,5,-792.3573,1953.981,99.47905,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,6,-812.7388,1993.078,78.95126,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,7,-823.2512,2008.549,73.36794,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,8,-823.4645,2030.833,73.17354,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,9,-812.5039,2051.152,80.61793,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,10,-775.5078,2066.004,83.64579,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
((@ENTRY2*100)+1,11,-728.4387,2072.975,87.72904,'Honor Hold Gryphon Brigadier, North Path 2 WP'),
-- Honor Hold Gryphon Brigadier, North Path 3
((@ENTRY2*100)+2,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,5,-798.551,1950.061,99.47905,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,6,-822.979,1966.302,78.95126,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,7,-829.1212,1999.823,73.36794,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,8,-823.4645,2030.833,73.17354,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,9,-822.0243,2049.509,80.61793,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,10,-838.6264,2088.113,83.64579,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,11,-857.7249,2123.352,87.72904,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
((@ENTRY2*100)+2,12,-856.7349,2157.759,99.95123,'Honor Hold Gryphon Brigadier, North Path 3 WP'),
-- Honor Hold Gryphon Brigadier, North Path 4
((@ENTRY2*100)+3,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,5,-792.3573,1953.981,99.47905,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,6,-812.7388,1993.078,78.95126,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,7,-823.2512,2008.549,73.36794,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,8,-823.4645,2030.833,73.17354,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,9,-812.5039,2051.152,80.61793,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,10,-838.6264,2088.113,83.64579,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,11,-857.7249,2123.352,87.72904,'Honor Hold Gryphon Brigadier, North Path 4 WP'),
((@ENTRY2*100)+3,12,-891.1043,2149.23,87.72904,'Honor Hold Gryphon Brigadier, North Path 4 WP');

-- Honor Hold Gryphon Brigadier, Forge Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY3*100, (@ENTRY3*100)+1, (@ENTRY3*100)+2, (@ENTRY3*100)+3);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, Forge Path 1
(@ENTRY3*100,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,4,-779.0291,1934.054,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,5,-805.9227,1932.241,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,6,-837.3495,1926.666,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,7,-862.7343,1923.357,97.618,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,8,-897.9168,1921.757,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,9,-914.8586,1930.438,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,10,-932.5103,1940.806,109.0624,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,11,-945.1282,1950.602,122.7846,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,12,-966.2561,1954.868,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
(@ENTRY3*100,13,-993.241,1956.073,157.4512,'Honor Hold Gryphon Brigadier, Forge Path 1 WP'),
-- Honor Hold Gryphon Brigadier, Forge Path 2
((@ENTRY3*100)+1,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,4,-780.6625,1927.177,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,5,-811.2864,1921.429,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,6,-834.9781,1920.712,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,7,-866.0516,1916.696,97.618,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,8,-895.7596,1922.273,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,9,-923.1928,1916.771,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,10,-948.4045,1901.38,98.9791,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,11,-966.732,1893.369,110.0068,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,12,-989.9695,1893.078,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
((@ENTRY3*100)+1,13,-1025.913,1875.034,164.979,'Honor Hold Gryphon Brigadier, Forge Path 2 WP'),
-- Honor Hold Gryphon Brigadier, Forge Path 3
((@ENTRY3*100)+2,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,5,-799.0213,1938.265,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,6,-821.9453,1929.91,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,7,-847.0975,1925.127,97.618,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,8,-884.1627,1919.391,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,9,-910.0975,1918.052,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,10,-931.7395,1901.312,98.9791,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,11,-938.8629,1883.565,110.0068,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
((@ENTRY3*100)+2,12,-948.2704,1857.24,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 3 WP'),
-- Honor Hold Gryphon Brigadier, Forge Path 4
((@ENTRY3*100)+3,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,3,-750.1168,1929.094,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,4,-773.3017,1941.179,99.47905,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,5,-799.0213,1938.265,104.2291,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,6,-821.9453,1929.91,101.0902,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,7,-847.0975,1925.127,97.618,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,8,-884.1627,1919.391,99.59021,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,9,-898.5378,1920.82,97.67357,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,10,-909.0667,1943.895,98.9791,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,11,-882.7237,1983.156,110.0068,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,12,-857.6995,1997.67,135.8124,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,13,-834.7382,1999.236,151.1734,'Honor Hold Gryphon Brigadier, Forge Path 4 WP'),
((@ENTRY3*100)+3,14,-797.808,1990.238,154.7012,'Honor Hold Gryphon Brigadier, Forge Path 4 WP');

-- Honor Hold Gryphon Brigadier, Foothill Pathing
DELETE FROM `waypoints` WHERE `entry` IN (@ENTRY4*100, (@ENTRY4*100)+1, (@ENTRY4*100)+2);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
-- Honor Hold Gryphon Brigadier, Foothill Path 1
(@ENTRY4*100,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 1'),
(@ENTRY4*100,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 2'),
(@ENTRY4*100,3,-750.1168,1929.094,115.7846,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 3'),
(@ENTRY4*100,4,-780.6038,1912.869,111.4513,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 4'),
(@ENTRY4*100,5,-812.3557,1903.761,119.8957,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 5'),
(@ENTRY4*100,6,-844.3373,1894.094,121.1179,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 6'),
(@ENTRY4*100,7,-875.8698,1888.307,134.0069,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 7'),
(@ENTRY4*100,8,-908.7481,1889.962,139.368,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 8'),
(@ENTRY4*100,9,-936.4296,1891.453,135.5625,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 9'),
(@ENTRY4*100,10,-956.9449,1888.206,129.8402,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 10'),
(@ENTRY4*100,11,-976.4232,1879.735,128.3126,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 11'),
(@ENTRY4*100,12,-999.7429,1861.678,156.9511,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 12'),
(@ENTRY4*100,13,-1019.369,1838.22,181.4233,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 13'),
(@ENTRY4*100,14,-1015.93,1818.592,198.4232,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 14'),
(@ENTRY4*100,15,-1003.392,1791.963,211.84,'Honor Hold Gryphon Brigadier, Foothill Path 1 WP 15'),
-- Honor Hold Gryphon Brigadier, Foothill Path 2
((@ENTRY4*100)+1,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 1'),
((@ENTRY4*100)+1,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 2'),
((@ENTRY4*100)+1,3,-750.1168,1929.094,115.7846,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 3'),
((@ENTRY4*100)+1,4,-780.6038,1912.869,111.4513,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 4'),
((@ENTRY4*100)+1,5,-812.3557,1903.761,119.8957,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 5'),
((@ENTRY4*100)+1,6,-844.3373,1894.094,121.1179,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 6'),
((@ENTRY4*100)+1,7,-875.8698,1888.307,134.0069,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 7'),
((@ENTRY4*100)+1,8,-905.6191,1885.849,139.368,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 8'),
((@ENTRY4*100)+1,9,-933.7491,1881.107,135.5625,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 9'),
((@ENTRY4*100)+1,10,-957.0587,1876.275,129.8402,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 10'),
((@ENTRY4*100)+1,11,-976.4232,1879.735,128.3126,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 11'),
((@ENTRY4*100)+1,12,-1001.597,1896.851,136.0901,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 12'),
((@ENTRY4*100)+1,13,-1026.942,1912.217,153.8956,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 13'),
((@ENTRY4*100)+1,14,-1046.058,1925.075,168.2844,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 14'),
((@ENTRY4*100)+1,15,-1065.902,1940.892,183.0622,'Honor Hold Gryphon Brigadier, Foothill Path 2 WP 15'),
-- Honor Hold Gryphon Brigadier, Foothill Path 3
((@ENTRY4*100)+2,1,-739.3298,1922.589,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 1'),
((@ENTRY4*100)+2,2,-738.3353,1922.693,100.9578,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 2'),
((@ENTRY4*100)+2,3,-750.1168,1929.094,115.7846,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 3'),
((@ENTRY4*100)+2,4,-780.6038,1912.869,111.4513,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 4'),
((@ENTRY4*100)+2,5,-812.3557,1903.761,119.8957,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 5'),
((@ENTRY4*100)+2,6,-852.6487,1887.492,134.7291,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 6'),
((@ENTRY4*100)+2,7,-885.8631,1878.916,144.8403,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 7'),
((@ENTRY4*100)+2,8,-910.2131,1876.215,149.118,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 8'),
((@ENTRY4*100)+2,9,-933.7659,1874.894,145.9792,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 9'),
((@ENTRY4*100)+2,10,-957.0587,1876.275,129.8402,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 10'),
((@ENTRY4*100)+2,11,-976.4232,1879.735,128.3126,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 11'),
((@ENTRY4*100)+2,12,-1003.331,1901.21,136.0901,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 12'),
((@ENTRY4*100)+2,13,-1019.146,1920.588,153.8956,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 13'),
((@ENTRY4*100)+2,14,-1035.73,1937.606,168.2844,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 14'),
((@ENTRY4*100)+2,15,-1055.794,1959.019,183.0622,'Honor Hold Gryphon Brigadier, Foothill Path 3 WP 15');
-- Pathing for Ol' Sooty Entry: 1225
SET @NPC := 8392;
SET @PATH := @NPC;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=-5679.014160,`position_y`=-3185.046875,`position_z`=319.508057 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`bytes2`,`mount`,`auras`) VALUES (@NPC,@PATH,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,-5716.181152,-3110.810791,316.686523,0,0,0,100,0),
(@PATH,2,-5716.187012,-3093.080078,325.600677,0,0,0,100,0),
(@PATH,3,-5712.214355,-3090.297607,327.738647,0,0,0,100,0),
(@PATH,4,-5705.484375,-3092.523438,329.362366,0,0,0,100,0),
(@PATH,5,-5681.826660,-3110.568848,338.121887,0,0,0,100,0),
(@PATH,6,-5659.498535,-3122.215576,344.336151,0,0,0,100,0),
(@PATH,7,-5639.585938,-3124.536133,348.404938,0,0,0,100,0),
(@PATH,8,-5618.112793,-3110.905762,360.618225,0,0,0,100,0),
(@PATH,9,-5621.486816,-3096.315918,368.247772,0,0,0,100,0),
(@PATH,10,-5632.212891,-3078.608398,374.990936,0,0,0,100,0),
(@PATH,11,-5629.793457,-3056.124023,384.465576,0,0,0,100,0),
(@PATH,12,-5642.278809,-3036.872314,385.471649,0,0,0,100,0),
(@PATH,13,-5609.369141,-3006.883301,386.288177,0,0,0,100,0),
(@PATH,14,-5643.634277,-3036.388672,385.531891,0,0,0,100,0),
(@PATH,15,-5630.174805,-3057.015869,384.385712,0,0,0,100,0),
(@PATH,16,-5629.840332,-3065.496338,381.129578,0,0,0,100,0),
(@PATH,17,-5634.866211,-3078.448975,374.489044,0,0,0,100,0),
(@PATH,18,-5620.416504,-3101.081543,364.819855,0,0,0,100,0),
(@PATH,19,-5624.629395,-3117.040527,354.493805,0,0,0,100,0),
(@PATH,20,-5644.949707,-3125.081787,347.271362,0,0,0,100,0),
(@PATH,21,-5660.741699,-3121.580566,343.975922,0,0,0,100,0),
(@PATH,22,-5676.210938,-3111.586914,340.021484,0,0,0,100,0),
(@PATH,23,-5691.895508,-3102.994385,333.646698,0,0,0,100,0),
(@PATH,24,-5711.662109,-3088.433594,328.761566,0,0,0,100,0),
(@PATH,25,-5717.663574,-3099.033691,321.686920,0,0,0,100,0),
(@PATH,26,-5705.214844,-3132.324219,315.837585,0,0,0,100,0),
(@PATH,27,-5679.014160,-3185.046875,319.508057,0,0,0,100,0);
-- Thargold Ironwing SAI
SET @ENTRY  := 29154;
SET @GOSSIP := 9776;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,53335,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Thargold Ironwing - On gossip option select - cast spell'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Thargold Ironwing - On gossip option select - close gossip');
DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (10062,10063,10054,10055,10046,10047,10048,10049,10050,10051,10044,10045);
INSERT INTO `achievement_criteria_data` (`criteria_id`,`type`,`value1`,`value2`,`ScriptName`) VALUES
(10062,12,0,0, 'achievement_quick_shave'),
(10063,12,1,0, 'achievement_quick_shave'),
(10044,12,0,0, 'achievement_unbroken'),
(10045,12,1,0, 'achievement_unbroken'),
(10054,12,0,0, 'achievement_shutout'),
(10055,12,1,0, 'achievement_shutout'),
(10046,12,0,0, 'achievement_three_car_garage_chopper'),
(10047,12,0,0, 'achievement_three_car_garage_siege'),
(10048,12,0,0, 'achievement_three_car_garage_demolisher'),
(10049,12,1,0, 'achievement_three_car_garage_chopper'),
(10050,12,1,0, 'achievement_three_car_garage_siege'),
(10051,12,1,0, 'achievement_three_car_garage_demolisher'),
(10062,11,0,0, 'achievement_quick_shave'),
(10063,11,0,0, 'achievement_quick_shave'),
(10044,11,0,0, 'achievement_unbroken'),
(10045,11,0,0, 'achievement_unbroken'),
(10054,11,0,0, 'achievement_shutout'),
(10055,11,0,0, 'achievement_shutout'),
(10046,11,0,0, 'achievement_three_car_garage_chopper'),
(10047,11,0,0, 'achievement_three_car_garage_siege'),
(10048,11,0,0, 'achievement_three_car_garage_demolisher'),
(10049,11,0,0, 'achievement_three_car_garage_chopper'),
(10050,11,0,0, 'achievement_three_car_garage_siege'),
(10051,11,0,0, 'achievement_three_car_garage_demolisher');
DELETE FROM `creature_text` WHERE `entry` IN (32295,28859);
INSERT INTO `creature_text` (entry,groupid,id,text,type,language,sound,comment) VALUE
(28859,0,0,'My patience has reached its limit, I will be rid of you!',1,0,14517,'Malygos - Aggro (Phase 1)'),
(28859,1,0,'Your stupidity has finally caught up to you',1,0,14519,'Malygos - Killed Player (1) (Phase 1)'),
(28859,1,1,'More artifacts to confiscate...',1,0,14520,'Malygos - Killed Player (2) (Phase 1)'),
(28859,1,2,'<Laughs> How very... naive...',1,0,14521,'Malygos - Killed Player (3) (Phase 1)'),
(28859,2,0,'I had hoped to end your lives quickly, but you have proven more... resilient then I had anticipated. Nonetheless, your efforts are in vain, it is you reckless, careless mortals who are to blame for this war! I do what I must... And if it means your... extinction... THEN SO BE IT',1,0,14522,'Malygos - End Phase One'),
(28859,3,0,'Few have experienced the pain I will now inflict upon you!',1,0,14523,'Malygos - Aggro (Phase 2)'),
(28859,4,0,'I will teach you IGNORANT children just how little you know of magic...',1,0,14524,'Malygos - Anti-Magic Shell'),
(28859,5,0,'Watch helplessly as your hopes are swept away...',1,0,14525,'Malygos - Magic Blast'),
(28859,6,0,'Your energy will be put to good use!',1,0,14526,'Malygos - Killed Player 1 (Phase 2)'),
(28859,6,1,'I am the spell-weaver! My power is infinite!',1,0,14527,'Malygos - Killed Player 2 (Phase 2)'),
(28859,6,2,'Your spirit will linger here forever!',1,0,14528,'Malygos - Killed Player 3 (Phase 2)'),
(28859,7,0,'ENOUGH! If you intend to reclaim Azeroth''s magic, then you shall have it...',1,0,14529,'Malygos - End Phase 2'),
(28859,8,0,'Now your benefactors make their appearance... But they are too late. The powers contained here are sufficient to destroy the world ten times over! What do you think they will do to you?',1,0,14530,'Intro Phase 3'),
(28859,9,0,'SUBMIT!',1,0,14531,'Malygos - Aggro (Phase 3)'),
(28859,10,0,'The powers at work here exceed anything you could possibly imagine!',1,0,14532,'Malygos - Surge of Power'),
(28859,11,0,'I AM UNSTOPPABLE!',1,0,14533,'Malygos - Buffed by a spark'),
(28859,12,0,'Alexstrasza! Another of your brood falls!',1,0,14534,'Malygos - Killed Player 1 (Phase 3)'),
(28859,12,1,'Little more then gnats!',1,0,14535,'Malygos - Killed Player 2 (Phase 3)'),
(28859,12,2,'Your red allies will share your fate...',1,0,14536,'Malygos - Killed Player 3 (Phase 3)'),
(28859,13,0,'Still standing? Not for long...',1,0,14537,'Malygos - Spell Casting 1(Phase 3)'),
(28859,13,1,'Your cause is lost',1,0,14538,'Malygos - Spell Casting 2 (Phase 3)'),
(28859,13,2,'Your fragile mind will be shattered!',1,0,14539,'Malygos - Spell Casting 3 (Phase 3)'),
(28859,14,0,'Unthinkable! The mortals will destroy... everything... my sister... what have you...',1,0,0,'Malygos - Death'),
(32295,0,0,'I did what I had to, brother. You gave me no alternative.',1,0,0,'Alexstrasza - Yell One'),
(32295,1,0,'And so ends the Nexus War.',1,0,0,'Alexstrasza - Yell Two'),
(32295,2,0,'This resolution pains me deeply, but the destruction, the monumental loss of life had to end. Regardless of Malygos'' recent transgressions, I will mourn his loss. He was once a guardian, a protector. This day, one of the world''s mightiest has fallen.',1,0,0,'Alexstrasza - Yell Three'),
(32295,3,0,'The red dragonflight will take on the burden of mending the devastation wrought on Azeroth. Return home to your people and rest. Tomorrow will bring you new challenges, and you must be ready to face them. Life... goes on.',1,0,0,'Alexstrasza - Yell Four');



SET @CGuid = 208901; -- (Set by TDB team - creature.guid - need X)
SET @GGuid = 151829; -- (Set by TDB team - gameobject.guid - need X)
SET @EquiEntry = 2433; -- (Set by TDB team - creature_equip_template.entry - need X)
SET @Gossip = 21257; -- (Set by TDB team - gossip_menu.entry - need 1)
SET @Event = 61; -- (Set by TDB team - game_event.entry - need 1)
-- Creature enums
SET @N_Vanira = 40184; -- Vanira
SET @N_VaniraTotem = 40187; -- Vanira's Sentry Totem
SET @N_Frog = 40176; -- Sen'jin Frog
SET @N_AtunnedFrog = 40188; -- Atunned Frog
SET @N_Voljin = 40391; -- Vol'jin
SET @N_Uruzin = 40253; -- Champion Uru'zin
SET @N_VoljinBoss = 39654; -- Vol'jin (on the island, starts fight)
SET @N_BatHandler = 40204; -- Handler Marnlek
SET @N_Bat = 40222; -- Scout Bat
SET @N_SpyFrogCredit = 40218; -- Spy Frog Credit
SET @N_TigerCredit = 40301; -- Tiger Matriarch Credit
SET @N_TigerSpirit = 40305; -- Spirit of the Tiger
SET @N_Matriarch = 40312; -- Tiger Matriarch (casts 75163 (Vicious Bite), 61184 (Pounce), 75159 (Claw))
SET @N_Zentabra = 40329; -- Zen'tabra
SET @N_DWarrior = 40392; -- Darkspear Warrior
SET @N_DScout = 40416; -- Darkspear Scout
SET @N_Citizien1 = 40256; -- Troll Citizien (1)
SET @N_Citizien2 = 40257; -- Troll Citizien (2)
SET @N_Volunteer1 = 40260; -- Troll Volunteer
SET @N_Volunteer2 = 40264; -- Troll Volunteer
SET @N_RDancer = 40356; -- Ritual Dancer
SET @N_TDanceleader = 40361; -- Troll Dance Leader
SET @N_DancePart = 40363; -- Dance Participant
SET @N_RDrummer = 40373; -- Ritual Drummer
SET @N_Omen = 40387; -- Omen Event Credit
SET @N_DAncestor = 40388; -- Darkspear Ancestor
SET @N_Voice = 40374; -- Voice of the Spirits
SET @N_Doctor = 40352; -- Witch Doctor Hez'tok
-- Gameobject enums
SET @G_BatTotem = 202833; -- Sen'jin Bat Totem
SET @G_BatStraw = 202834; -- Sen'jin Bat Roost Straw
SET @G_BatFence = 202835; -- Sen'jin Bat Roost Fence
SET @G_BatPost = 202839; -- Sen'jin Bat Roost Fence Post
SET @G_RDrum = 202879; -- Ritual Drum
SET @G_RGong = 202880; -- Ritual Gong
SET @G_RBrazier = 202881; -- Ritual Brazier
SET @G_SRDrum = 202882; -- Small Ritual Drum
SET @G_SRDrum2 = 202883; -- Small Ritual Drum 2
SET @G_Banner = 202885; -- Sen'jin Banner
SET @G_Tent = 202886; -- Sen'jin Tent
SET @G_Table = 202888; -- Sen'jin Table
SET @G_Book1 = 202889; -- Troll Book 1
SET @G_Book2 = 202890; -- Troll Book 2
SET @G_CCrate = 202891; -- Closed Weapon Crate
SET @G_OCrate = 202892; -- Open Weapon Crate
SET @G_SPennant = 202893; -- Sen'jin Pennant
-- Quest enums
SET @Q_DaPerfectSpies = 25444; -- Da Perfect Spies
SET @Q_FrogsAway = 25446; -- Frogs Away!
SET @Q_LadyOfDaTigers = 25470; -- Lady Of Da Tigers
SET @Q_DanceOfDeSpirits = 25480; -- Dance Of De Spirits
SET @Q_TrollinForVolunteers = 25461; -- Trollin' For Volunteers
SET @Q_PreparinForBattle = 25495; -- Preparin For Battle
SET @Q_ZalazanesFall = 25445; -- Zalazane's Fall
-- Spell enums
SET @S_Pickup = 74904; -- Pickup Sen'jin Frog [player -> creature]
SET @S_Pickup2 = 74905; -- Pickup Sen'jin Frog [creature -> player]
SET @S_InvsAura = 75433; -- Spawn Invisibility Aura (QZS 2)
SET @S_FrogsAway = 74977; -- Frogs Away!
SET @S_SeeSenjinFrogInvs = 75434; -- See Sen'jin Frog Invis
SET @S_SeeSpyFrogInvs =74982; -- See Spy Frog Invisibility
SET @S_Taxi_Frog = 74978; -- Echo Isles: Unlearned Spy Frog Taxi
SET @S_Taxi_Troll = 75421; -- Echo Isles: Unlearned Troll Recruit Taxi
SET @S_Taxi_Battle = 75422; -- Echo Isles: Unlearned Troll Battle Taxi
SET @S_SpyFrogInvs = 74980; -- Spy Frog Invisibility
SET @S_SmokeFlare = 74971; -- Red Flare State
SET @S_VisualSpawn = 31517; -- Bind Visual Spawn In DND
SET @S_SpyFrogState = 74917; -- Spy Frog State
SET @S_RideVehicle = 46598; -- Ride Vehicle Hardcoded
SET @S_Tiger = 75147; -- Spirit of the Tiger
SET @S_ForceTiger = 75186; -- Force Cast Spirit of the Tiger
SET @S_NatVisual = 60957; -- Cosmetic Nature Cast
SET @S_TigerAura = 75165; -- Spirit of the Tiger Aura
SET @S_TigerSeeInvs = 75180; -- Detect QZS 3
SET @S_TigerGhost = 22650; -- Ghost Visual
SET @S_BossEmotePAura =75213; -- Boss Emote & No Summon Aura
SET @S_TigerCredit = 40301; -- OCW TOTE On Quest Check (what?)
SET @S_MatriarchShroud = 75179; -- Matriarch's Shroud
SET @S_TigerQuestCredit = 75197; -- Zen'tabra Credit
SET @S_MatriarchSummonF = 75188; -- Force Cast Summon Tiger Matriarch
SET @S_MatriarchSummon = 75187; -- Summon Tiger Matriarch
SET @S_ZentabraSummon = 75181; -- Summon Zen'tabra
SET @S_ZentabraController = 75212; -- Controller Summon Zen'tabra Trigger
SET @S_ZentrabaSmoke = 36747; -- Spawn Smoke (Druid)
SET @S_ZentrabaTransform = 74931; -- [DND] Tiger Transform
SET @S_VolunterSummon1 = 75088; -- Motivate
SET @S_VolunterSummon2 = 75086; -- Motivate
-- Item enums
SET @I_VoljinDrums = 54215; -- Voljin Drums Questitem
UPDATE `creature_template` SET `spell1`=75159,`spell2`=75160,`spell3`=75161,`faction_A`=35,`faction_H`=35,`exp`=2,`minlevel`=80,`maxlevel`=80,`baseattacktime`=2500,`unit_flags`=`unit_flags`|16777224,`unit_class`=4,`speed_walk`=2.8,`speed_run`=1.5714285714286,`vehicleid`=736,`attackpower`=1167 WHERE `entry`=@N_TigerSpirit; -- Spirit of the Tiger CHECKME: speed_run and speed_walk
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (@N_Frog,@N_TigerSpirit);
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`quest_start`,`quest_start_active`,`quest_end`,`cast_flags`,`aura_required`,`aura_forbidden`,`user_type`) VALUES
(@N_Frog,@S_Pickup,@Q_DaPerfectSpies,1,@Q_DaPerfectSpies,1,0,0,0),
(@N_Frog,@S_Pickup2,@Q_DaPerfectSpies,1,@Q_DaPerfectSpies,3,0,0,0),
(@N_TigerSpirit,@S_RideVehicle,0,0,0,1,0,0,0); -- Spirit of the Tiger - Ride Vehicle Hardcoded
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@N_Frog,@N_AtunnedFrog,@N_Vanira,@N_Zentabra,@N_DScout,@N_Citizien1,@N_Citizien2,@N_Doctor,@N_DancePart,@N_RDrummer) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@N_Vanira*100,@N_Zentabra*100,@N_DScout*100,@N_Doctor*100) AND `source_type`=9;
INSERT INTO `smart_scripts`(`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)VALUES
(@N_Frog,0,0,0,8,0,100,0,@S_Pickup,0,0,0,41,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Echo Isles: Senjin Frog - add aura'),
(@N_AtunnedFrog,0,0,0,54,0,100,0,0,0,0,0,33,@N_SpyFrogCredit,0,0,0,0,0,0,0,0,0,0,0,0,0, 'Echo Isles: Spy Frog Killcredit'), -- FIXME: should be replaced by proper flare targeting
(@N_AtunnedFrog,0,1,0,25,0,100,0,0,0,0,0,89,5,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Attuned Frog: On reset set random movement'),
(@N_Vanira,0,0,0,19,0,100,0,@Q_LadyOfDaTigers,0,0,0,80,@N_Vanira*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Echo Isles: On quest accept run script'),
(@N_Vanira*100,9,0,0,0,0,100,0,0,0,0,0,11,@S_ForceTiger,0,0,0,0,0,7,0,0,0,0,0,0,0,'Echo Isles: Cast Force Tiger on player'),
(@N_Vanira*100,9,1,0,0,0,100,0,0,0,0,0,11,@S_NatVisual,0,0,0,0,0,1,0,0,0,0,0,0,0,'Echo Isles: Cast Nature Visual on self'),
(@N_Vanira*100,9,2,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Echo Isles: Say Text 0'),
(@N_Vanira*100,9,3,0,0,0,100,0,500,500,0,0,86,75165,0,22,0,0,0,1,0,0,0,0,0,0,0,'Echo Isles: Force Tiger cast 75165 on self'),
(@N_Zentabra,0,0,0,25,0,100,0,0,0,0,0,80,@N_Zentabra*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Call actionlist on spawn'),
(@N_Zentabra*100,9,0,0,0,0,100,0,0,0,0,0,66,0,0,0,0,0,0,23,0,0,0,0,0,0,0, 'Set orientation to player'),
(@N_Zentabra*100,9,1,0,0,0,100,0,0,0,0,0,11,@S_ZentrabaSmoke,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast spawn smoke effect on self'),
(@N_Zentabra*100,9,2,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(@N_Zentabra*100,9,3,0,0,0,100,0,1500,1500,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 1'),
(@N_Zentabra*100,9,4,0,0,0,100,0,5500,5500,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 2'),
(@N_Zentabra*100,9,5,0,0,0,100,0,5500,5500,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 3'),
(@N_Zentabra*100,9,6,0,0,0,100,0,5500,5500,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 4'),
(@N_Zentabra*100,9,7,0,0,0,100,0,0,0,0,0,33,@N_TigerCredit,0,0,0,0,0,23,0,0,0,0,0,0,0, 'Award kill credit to player'),
(@N_Zentabra*100,9,8,0,0,0,100,0,5500,5500,0,0,11,@S_ZentrabaTransform,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cast tiger transform on self'),
(@N_Zentabra*100,9,9,0,0,0,100,0,100,100,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Set run on self'),
(@N_Zentabra*100,9,10,0,0,0,100,0,0,0,0,0,46,10,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Move self forward 10 yards'),
(@N_Zentabra*100,9,11,0,0,0,100,0,600,600,0,0,41,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Despawn self'),
(@N_DScout,0,0,0,25,0,100,0,0,0,0,0,53,1,@N_DScout,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Start waypath on spawn'),
(@N_DScout,0,1,0,40,0,100,0,1,@N_DScout,0,0,60,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Set fly = 0 on waypoint 1'),
(@N_DScout,0,2,0,40,0,100,0,1,@N_DScout,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Set run = 0 on waypoint 1'),
(@N_DScout,0,3,0,40,0,100,0,1,@N_DScout,0,0,43,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Unmount on waypoint 1'),
(@N_DScout,0,4,0,40,0,100,0,6,@N_DScout,0,0,54,15000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Pause waypoint on waypoint 6'),
(@N_DScout,0,5,0,40,0,100,0,6,@N_DScout,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0.820305, 'Darkspear Scout: Change orientation on waypoint 6'),
(@N_DScout,0,6,0,40,0,100,0,6,@N_DScout,0,0,80,@N_DScout*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Run script on waypoint 6'),
(@N_DScout,0,7,0,40,0,100,0,9,@N_DScout,0,0,41,500,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Despawn on waypoint 9'),
(@N_DScout*100,9,0,0,0,0,100,0,0,0,0,0,10,1,2,5,66,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Random emote 1,2,5,66'),
(@N_DScout*100,9,1,0,0,0,50,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Random text'),
(@N_DScout*100,9,2,0,0,0,50,0,1000,1000,0,0,1,0,0,0,0,0,0,9,@N_Voljin,0,15,0,0,0,0, 'Vol''Jin: Reply to Darkspear Scout'),
(@N_DScout*100,9,3,0,0,0,100,0,2000,2000,0,0,10,1,2,5,66,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Random emote 1,2,5,66'),
(@N_DScout*100,9,4,0,0,0,100,0,6000,6000,0,0,10,1,2,5,66,0,0,1,0,0,0,0,0,0,0, 'Darkspear Scout: Random emote 1,2,5,66'),
(@N_Citizien1,0,0,0,8,0,100,0,@S_VolunterSummon1,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Echo Isles: On spellhit - force despawn'),
(@N_Citizien2,0,0,0,8,0,100,0,@S_VolunterSummon2,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Echo Isles: On spellhit - force despawn'),
(@N_Doctor, 0,0,0,62,0,0,0,@Gossip+0,0,0,0,80,@N_Doctor*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - On gossip select start script'),
(@N_Doctor*100,9,0,0,0,0,100,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Remove gossip flag'),
(@N_Doctor*100,9,1,0,0,0,100,0,1500,1500,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 0'),
(@N_Doctor*100,9,2,0,0,0,100,0,1000,1000,0,0,12,@N_RDrummer,1,50000,0,0,0,8,0,0,0,-812.137,-4986.7,17.3759,5.89921, 'Witch Doctor Hez''tok - Summon Ritual Drummer (1)'),
(@N_Doctor*100,9,3,0,0,0,100,0,0,0,0,0,12,@N_RDrummer,1,50000,0,0,0,8,0,0,0,-798.187,-4985.52,17.7904,4.41568, 'Witch Doctor Hez''tok - Summon Ritual Drummer (2)'),
(@N_Doctor*100,9,4,0,0,0,100,0,0,0,0,0,12,@N_RDrummer,1,50000,0,0,0,8,0,0,0,-799.888,-4975.01,17.9325,0.942478, 'Witch Doctor Hez''tok - Summon Ritual Drummer (3)'),
(@N_Doctor*100,9,5,0,0,0,100,0,3500,3500,0,0,69,0,0,0,0,0,0,8,0,0,0,-806.2,-4989.5,17.5177,0, 'Witch Doctor Hez''tok - Move to pos'),
(@N_Doctor*100,9,6,0,0,0,100,0,6500,6500,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 1'),
(@N_Doctor*100,9,7,0,0,0,100,0,5500,5500,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 2'),
(@N_Doctor*100,9,8,0,0,0,100,0,3500,3500,0,0,5,25,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Do emote'),
(@N_Doctor*100,9,9,0,0,0,100,0,3500,3500,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 3'),
(@N_Doctor*100,9,10,0,0,0,100,0,2500,2500,0,0,5,6,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Do emote'),
(@N_Doctor*100,9,11,0,0,0,100,0,5000,5000,0,0,11,56745,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Drink Alcohol self'),
(@N_Doctor*100,9,12,0,0,0,100,0,600,600,0,0,11,29389,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Firebreathing self'),
(@N_Doctor*100,9,13,0,0,0,100,0,4000,4000,0,0,90,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Set bytes1 kneel state'),
(@N_Doctor*100,9,14,0,0,0,100,0,1000,1000,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-805.8477,-5003.044,20.18328,5.89921, 'Witch Doctor Hez''tok - Summon Dance Participant (1)'),
(@N_Doctor*100,9,15,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-801.0605,-4998.501,18.59358,4.41568, 'Witch Doctor Hez''tok - Summon Dance Participant (2)'),
(@N_Doctor*100,9,16,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-808.2397,-4985.208,19.54311,0.942478, 'Witch Doctor Hez''tok - Summon Dance Participant (3)'),
(@N_Doctor*100,9,17,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-799.2618,-4994.353,19.61933,5.89921, 'Witch Doctor Hez''tok - Summon Dance Participant (4)'),
(@N_Doctor*100,9,18,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-797.8184,-4986.597,21.60157,4.41568, 'Witch Doctor Hez''tok - Summon Dance Participant (5)'),
(@N_Doctor*100,9,19,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-805.1284,-4987.553,18.79003,0.942478, 'Witch Doctor Hez''tok - Summon Dance Participant (6)'),
(@N_Doctor*100,9,20,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-814.1109,-5001.676,19.44409,5.89921, 'Witch Doctor Hez''tok - Summon Dance Participant (7)'),
(@N_Doctor*100,9,21,0,0,0,100,0,0,0,0,0,12,@N_DancePart,1,40000,0,0,0,8,0,0,0,-795.7561,-4993.671,21.80729,5.89921, 'Witch Doctor Hez''tok - Summon Dance Participant (8)'),
(@N_Doctor*100,9,22,0,0,0,100,0,1000,1000,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-790.217041,-4999.733,17.171814,2.84488654, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (1)'),
(@N_Doctor*100,9,23,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-792.0052,-4994.14258,17.4839725,2.70526028, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (2)'),
(@N_Doctor*100,9,24,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-795.2049,-5003.078,17.716095,2.46091413, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (3)'),
(@N_Doctor*100,9,25,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-799.2274,-5005.68066,16.6322536,2.11184835, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (4)'),
(@N_Doctor*100,9,26,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-799.2557,-4990.76172,17.6279469,2.70527148, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (5)'),
(@N_Doctor*100,9,27,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-801.422058,-4998.04346,17.0008545,2.46088934, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (6)'),
(@N_Doctor*100,9,28,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-805.4358,-5002.88525,16.544487,1.727876, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (7)'),
(@N_Doctor*100,9,29,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-807.135,-4997.469,17.0008545,1.15000379, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (8)'),
(@N_Doctor*100,9,30,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-810.3698,-4993.825,17.1258545,0.808653831, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (9)'),
(@N_Doctor*100,9,31,0,0,0,100,0,0,0,0,0,12,@N_DAncestor,1,40000,0,0,0,8,0,0,0,-810.3889,-5004.778,16.12407,1.15191734, 'Witch Doctor Hez''tok - Summon Darkspear Ancestor (10)'),
(@N_Doctor*100,9,32,0,0,0,100,0,7000,7000,0,0,11,70663,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Shadow Nova self'),
(@N_Doctor*100,9,33,0,0,0,100,0,0,0,0,0,11,31309,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Spirit Particles self'),
(@N_Doctor*100,9,34,0,0,0,100,0,0,0,0,0,91,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Set bytes1 none'),
(@N_Doctor*100,9,35,0,0,0,100,0,100,100,0,0,3,@N_Voice,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Change entry to Voice of the Spirits'),
(@N_Doctor*100,9,36,0,0,0,100,0,100,100,0,0,3,0,31819,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Change model to Voice of the Spirits'),
(@N_Doctor*100,9,37,0,0,0,100,0,1000,1000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 4'),
(@N_Doctor*100,9,38,0,0,0,100,0,4000,4000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 5'),
(@N_Doctor*100,9,39,0,0,0,100,0,3000,3000,0,0,5,25,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Do emote'),
(@N_Doctor*100,9,40,0,0,0,100,0,3500,3500,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 6'),
(@N_Doctor*100,9,41,0,0,0,100,0,6000,6000,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 7'),
(@N_Doctor*100,9,42,0,0,0,100,0,4500,4500,0,0,5,274,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Do emote'),
(@N_Doctor*100,9,43,0,0,0,100,0,5000,5000,0,0,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 8'),
(@N_Doctor*100,9,44,0,0,0,100,0,4500,4500,0,0,5,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Do emote'),
(@N_Doctor*100,9,45,0,0,0,100,0,5500,5500,0,0,11,70663,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Shadow Nova self'),
(@N_Doctor*100,9,46,0,0,0,100,0,100,100,0,0,28,31309,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Remove aura Spirit Particles'),
(@N_Doctor*100,9,47,0,0,0,100,0,0,0,0,0,3,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Change entry and model to Witch Doctor Hez''tok'),
(@N_Doctor*100,9,48,0,0,0,100,0,4000,4000,0,0,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Say text 9'),
(@N_Doctor*100,9,49,0,0,0,100,0,2500,2500,0,0,5,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Do emote'),
(@N_Doctor*100,9,50,0,0,0,100,0,0,0,0,0,85,75319,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Omen Event Credit invoker'), -- working
-- (@N_Doctor*100,9,50,0,0,0,100,0,0,0,0,0,11,75319,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Cast Omen Event Credit self'), -- how it shold be but not working
(@N_Doctor*100,9,51,0,0,0,100,0,5000,5000,0,0,69,0,0,0,0,0,0,8,0,0,0,-805.0104,-4975.75,17.75085,0, 'Witch Doctor Hez''tok - Move to pos'),
(@N_Doctor*100,9,52,0,0,0,100,0,5000,5000,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,4.625123, 'Witch Doctor Hez''tok - Change orientation'),
(@N_Doctor*100,9,53,0,0,0,100,0,2000,2000,0,0,82,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Witch Doctor Hez''tok - Enable gossip flag'),
(@N_DancePart,0,0,0,25,0,100,0,0,0,0,0,89,10,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dance Participant - On reset set random movement'),
(@N_DancePart,0,1,0,25,0,100,0,0,0,0,0,3,0,22769,0,0,0,0,1,0,0,0,0,0,0,0, 'Dance Participant - On reset set model'),
(@N_RDrummer,0,0,0,1,0,100,0,0,0,1000,2000,5,38,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Ritual Drummer - Play emote attack 2h every 1 or 2 secs'),
(@N_RDrummer,0,1,0,1,0,100,0,0,0,5000,5000,11,75313,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Ritual Drummer - Cast Bang Ritual Gong every 5 seconds'),
(@N_RDrummer,0,2,0,1,0,100,1,4000,4000,0,0,4,7294,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Ritual Drummer - Play TrollDrumLoop after 4 seconds of spawn - not repeteable'),
(@N_RDrummer,0,3,0,1,0,100,0,0,0,30000,30000,4,7294,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Ritual Drummer - Play Drumms sound every 30 secs');

DELETE FROM `creature_text` WHERE `entry` IN (@N_Vanira,@N_Zentabra,@N_Volunteer1,@N_Volunteer2,@N_Matriarch,@N_TigerCredit,@N_Doctor,@N_DScout,@N_Voljin);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@N_Vanira,0,0, 'O spirit of de tigers, lend $N your power and help us find de answers we seek!',0,0,100,5,0,0, 'Vanira'),
(@N_Zentabra,0,0, 'Dat be enough for now!',0,0,100,25,0,0, 'Zen''tabra'),
(@N_Zentabra,1,0, 'Don''t be lookin'' so surprised. Your shaman friend has sharp eyes, or should I say, sharp frogs.',0,0,100,1,0,0, 'Zen''tabra'),
(@N_Zentabra,2,0, 'My kind, da druids, we been layin'' low for some time now. We been waitin'' to see when an'' if Vol''jin might return.',0,0,100,11,0,0, 'Zen''tabra'),
(@N_Zentabra,3,0, 'Now dat it looks like de Darkspear be returnin'' to these isles, maybe de time has come for us to reveal ourselves.',0,0,100,1,0,0, 'Zen''tabra'),
(@N_Zentabra,4,0, 'Go back to Vol''jin an'' tell him dis: Zen''tabra stands ready to help him in de coming battle.',0,0,100,1,0,0, 'Zen''tabra'),
(@N_Volunteer1,0,0, 'Sign me up!',0,0,100,66,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer1,0,1, 'Anythin'' for Vol''jin!',0,0,100,0,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer1,0,2, 'I''d be glad to help.',0,0,100,273,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer1,0,3, 'Just point me at de enemy!',0,0,100,66,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer2,0,0, 'Sign me up!',0,0,100,66,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer2,0,1, 'Anythin'' for Vol''jin!',0,0,100,0,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer2,0,2, 'I''d be glad to help.',0,0,100,273,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer2,0,3, 'Just point me at de enemy!',0,0,100,66,0,0, 'Troll Volunteer JustSpawned'),
(@N_Volunteer1,1,0, 'Reportin'' for duty.',0,0,100,66,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer1,1,1, 'Ready to take de fight to Zalazane.',0,0,100,1,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer1,1,2, 'Ready to fight beside Vol''jin!',0,0,100,66,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer1,1,3, 'New troll here!',0,0,100,0,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer1,1,4, 'When does de trainin'' start?',0,0,100,6,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer2,1,0, 'Reportin'' for duty.',0,0,100,66,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer2,1,1, 'Ready to take de fight to Zalazane.',0,0,100,1,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer2,1,2, 'Ready to fight beside Vol''jin!',0,0,100,66,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer2,1,3, 'New troll here!',0,0,100,0,0,0, 'Troll Volunteer Quest Turn in'),
(@N_Volunteer2,1,4, 'When does de trainin'' start?',0,0,100,6,0,0, 'Troll Volunteer Quest Turn in'),
(@N_TigerCredit,0,0, 'The tiger matriarch appears! Prove yourself in combat!',3,0,100,0,0,0, 'Tiger Matriarch Credit'),
(@N_Doctor,0,0, 'Darkspears, we consult de spirits! Drummers, take your places!' ,0,0,100,25,0,0, 'Witch Doctor Hez''tok' ),
(@N_Doctor,1,0, 'Spirits, we be gathered here to ask for your guidance.' ,0,0,100,5,0,0, 'Witch Doctor Hez''tok' ),
(@N_Doctor,2,0, 'Our leader, Vol''jin, son of Sen''jin, issued de call to all Darkspears: reclaim de Echo Isles for our tribe.' ,0,0,100,1,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,3,0, 'Spirits! I offer me own body to you! Speak through me! Is de time right for mighty Vol''jin''s undertaking?' ,0,0,100,5,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,4,0, 'De ancestors hear ya, witch doctor!' ,0,0,100,1,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,5,0, 'Know dat your plans please us, Darkspears. De son of Sen''jin walks de right path.' ,0,0,100,1,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,6,0, 'De task in front of ya will not be easy, but ya have our blessin''.' ,0,0,100,1,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,7,0, 'Ya gave up your home an'' ya gave up de loas of your ancestors when ya left de Echo Isles. Dey will not be pleased dat you been ignorin'' dem.' ,0,0,100,1,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,8,0, 'Ya must make amends wit'' Bwonsamdi, de guardian of de dead, if ya hope to defeat Zalazane. It be de only way. Tell de son of Sen''jin dese things.' ,0,0,100,1,0,0, 'Witch Doctor Hez''tok'),
(@N_Doctor,9,0, 'De spirits have blessed us wit'' an answer! De Echo Isles will be ours again!' ,0,0,100,5,0,0, 'Witch Doctor Hez''tok'),
(@N_DScout,0,0, 'He got a big army, an'' he be plannin'' somethin'' down dere.' ,0,0,100,1,0,0, 'Darkspear Scout'),
(@N_DScout,0,1, 'Zalazane got most of his hexes trolls hidden under de canopy on de big island.' ,0,0,100,1,0,0, 'Darkspear Scout'),
(@N_Voljin,0,0, 'Thank ya, scout. Keep up da patrols. But for now, a rest is in order. Dismissed.' ,0,0,100,1,0,0, 'Vol''jin');
DELETE FROM `waypoints` WHERE `entry`=@N_DScout;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@N_DScout,1,-838.1788,-4989.835,14.93872, ''),
(@N_DScout,2,-829.3889,-4999.125,15.50085, ''),
(@N_DScout,3,-808.0018,-5010.587,15.36734, ''),
(@N_DScout,4,-796.1736,-5009.604,16.01879, ''),
(@N_DScout,5,-782.4566,-5002.518,17.26879, ''),
(@N_DScout,6,-758.7136,-5001.088,19.65562, 'Run script'),
(@N_DScout,7,-763.0104,-4995.054,20.06314, ''),
(@N_DScout,8,-753.5364,-4974.764,21.81314, ''),
(@N_DScout,9,-742.8715,-4961.878,22.66427, 'Despawn');
DELETE FROM `achievement_reward` WHERE `entry` IN (4784,4785);
INSERT INTO `achievement_reward` (`entry`,`title_A`,`title_H`,`item`,`sender`,`subject`,`text`) VALUES
(4784,0,0,0,37942, 'Emblem Quartermasters in Dalaran''s Silver Enclave', 'Your achievements in Northrend have not gone unnoticed, friend.$B$BThe Emblems you have earned may be used to purchase equipment from the various Emblem Quartermasters in Dalaran.$B$BYou may find us there, in the Silver Enclave, where each variety of Emblem has its own quartermaster.$B$BWe look forward to your arrival!'),
(4785,0,0,0,37941, 'Emblem Quartermasters in Dalaran''s Sunreaver Sanctuary', 'Your achievements in Northrend have not gone unnoticed, friend.$B$BThe Emblems you have earned may be used to purchase equipment from the various Emblem Quartermasters in Dalaran.$B$BYou may find us there, in the Sunreaver Sanctuary, where each variety of Emblem has its own quartermaster.$B$BWe look forward to your arrival!');
SET @ENTRY := 32487;
SET @SPELL1 := 61080; -- Putrid Punt
SET @SPELL2 := 41534; -- War Stomp
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,0,0,100,0,7000,8000,8000,9000,11,@SPELL1,1,0,0,0,0,2,0,0,0,0,0,0,0,'Putridus the Ancient - Combat - Cast Putrid Punt'),
(@ENTRY,0,1,0,0,0,100,0,6000,7000,12000,12000,11,@SPELL2,1,0,0,0,0,2,0,0,0,0,0,0,0,'Putridus the Ancient - Combat - Cast War Stomp');



UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=25171; -- Invisible Stalker (Scale x0.5) (move to new file)
DELETE FROM `smart_scripts` WHERE `entryorguid`=25171 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(25171,0,0,0,1,0,100,1,500,500,0,0,11,63413,0,0,0,0,0,11,35469,10,0,0,0,0,0, 'Invisible Stalker (Scale x0.5) - OOC cast Rope Beam in Gormok the Impaler (not repeteable)'),
(25171,0,1,0,1,0,100,1,500,500,0,0,11,63413,0,0,0,0,0,11,35470,10,0,0,0,0,0, 'Invisible Stalker (Scale x0.5) - OOC cast Rope Beam in Icehowl (not repeteable)');
-- SAI for Gavin Gnarltree
SET @ENTRY := 225;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,6000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,5,25,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 1 - ONESHOT_POINT'),
(@ENTRY,0,3,0,40,0,100,0,6,@ENTRY,0,0,54,50000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 6 - pause path'),
(@ENTRY,0,4,5,40,0,100,0,10,@ENTRY,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 10 - pause path'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,17,233,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - Reach wp 10 - STATE_WORK_MINING'),
(@ENTRY,0,6,0,56,0,100,0,10,@ENTRY,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Gavin Gnarltree - waypoint 10 resumed - STATE_NONE');
-- SAI for Joseph Wilson
SET @ENTRY := 33589;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,1,0,40,0,100,0,1,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - Reach wp 1 - run script'),
(@ENTRY,0,2,3,40,0,100,0,4,@ENTRY,0,0,54,60000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - Reach wp 4 - pause path'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.193953, 'Joseph Wilson - Reach wp 4 - turn to'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,54,22000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Joseph Wilson - Script - pause path'),
(@ENTRY*100,9,1,0,0,0,100,0,500,500,0,0,66,0,0,0,0,0,0,19,33479,0,0,0,0,0,0, 'Joseph Wilson - Script - turn to'),
(@ENTRY*100,9,2,0,0,0,100,0,500,500,0,0,11,61493,0,0,0,0,0,19,33479,0,0,0,0,0,0, 'Joseph Wilson - Script - cast'),
(@ENTRY*100,9,3,0,0,0,100,0,10000,10000,0,0,66,0,0,0,0,0,0,19,33460,0,0,0,0,0,0, 'Joseph Wilson - Script - turn to'),
(@ENTRY*100,9,4,0,0,0,100,0,500,500,0,0,11,61493,0,0,0,0,0,19,33460,0,0,0,0,0,0, 'Joseph Wilson - Script - cast');
-- SAI for Thomas Partridge
SET @ENTRY := 33854;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,60000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.01942, 'Thomas Partridge - Reach wp 1 - turn to'),
(@ENTRY,0,3,0,40,0,100,0,5,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 5 - run script'),
(@ENTRY,0,4,0,40,0,100,0,9,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 9 - run script'),
(@ENTRY,0,5,0,40,0,100,0,13,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 13 - run script'),
(@ENTRY,0,6,0,40,0,100,0,16,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 16 - run script'),
(@ENTRY,0,7,0,40,0,100,0,20,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Reach wp 20 - run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,54,8000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Script - pause path'),
(@ENTRY*100,9,1,0,0,0,100,0,500,500,0,0,5,273,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Thomas Partridge - Script - emote');
-- SAI for Brammold Deepmine
SET @ENTRY := 32509;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,1,2,40,0,100,0,2,@ENTRY,0,0,54,480000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Brammold Deepmine - Reach wp 2 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,2.321288, 'Brammold Deepmine - Reach wp 2 - turm to'),
(@ENTRY,0,3,4,40,0,100,0,8,@ENTRY,0,0,54,480000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Brammold Deepmine - Reach wp 8 - pause path'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,1.692969, 'Brammold Deepmine - Reach wp 8 - turn to');
-- SAI for Emi
SET @ENTRY := 32668;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,1,0,40,0,100,0,1,@ENTRY,0,0,54,18000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Emi - Reach wp 1 - pause path'),
(@ENTRY,0,2,3,40,0,100,0,2,@ENTRY,0,0,54,25000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Emi - Reach wp 2 - pause path'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.316126, 'Emi - Reach wp 2 - turm to');
-- SAI for Colin
SET @ENTRY := 32669;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,1,2,40,0,100,0,1,@ENTRY,0,0,54,4000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Colin - Reach wp 1 - pause path'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,5.427974, 'Colin - Reach wp 1 - turm to'),
(@ENTRY,0,3,4,40,0,100,0,2,@ENTRY,0,0,54,28000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Colin - Reach wp 2 - pause path'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0.2094395, 'Colin - Reach wp 2 - turm to'),
(@ENTRY,0,5,6,40,0,100,0,3,@ENTRY,0,0,54,23000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Colin - Reach wp 3 - pause path'),
(@ENTRY,0,6,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,3.804818, 'Colin - Reach wp 3 - turm to');


-- SAI for Henze Faulk
SET @ENTRY := 6172;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
-- AI
(@ENTRY,0,0,1,11,0,100,0,0,0,0,0,11,29266,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - On spawn - add aura'),
(@ENTRY,0,1,2,61,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - Script - set npcflags'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - On spawn - set phase 1'),
(@ENTRY,0,3,0,8,1,100,0,8593,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - On spellhit - run script (phase 1)'),
-- Script
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - Script - set phase 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Henze Faulk - Script - turn to player'),
(@ENTRY*100,9,2,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Henze Faulk - Script - say text'),
(@ENTRY*100,9,3,0,0,0,100,0,1500,1500,0,0,81,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - Script - set npcflags'),
(@ENTRY*100,9,4,0,0,0,100,0,120000,120000,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Henze Faulk - Script - evade (reset script)');
-- NPC talk text insert
DELETE FROM `creature_text` WHERE `entry`=@ENTRY; 
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'Thank you, dear $C, you just saved my life.',0,7,100,1,0,0, 'Henze Faulk');
-- Scripting cleanup
UPDATE `creature_template` SET `ScriptName`= '',`RegenHealth`=0 WHERE `entry`=@ENTRY;
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=@ENTRY;

-- SAI for Narm Faulk
SET @ENTRY := 6177;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@ENTRY*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
-- AI
(@ENTRY,0,0,1,11,0,100,0,0,0,0,0,11,29266,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - On spawn - add aura'),
(@ENTRY,0,1,2,61,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - Script - set npcflags'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - On spawn - set phase 1'),
(@ENTRY,0,3,0,8,1,100,0,8593,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - On spellhit - run script (phase 1)'),
-- Script
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - Script - set phase 0'),
(@ENTRY*100,9,1,0,0,0,100,0,1000,1000,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Narm Faulk - Script - turn to player'),
(@ENTRY*100,9,2,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Narm Faulk - Script - say text'),
(@ENTRY*100,9,3,0,0,0,100,0,1500,1500,0,0,81,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - Script - set npcflags'),
(@ENTRY*100,9,4,0,0,0,100,0,120000,120000,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Narm Faulk - Script - evade (reset script)');
-- NPC talk text insert
DELETE FROM `creature_text` WHERE `entry`=@ENTRY; 
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'Thank you, dear $C, you just saved my life.',0,7,100,1,0,0, 'Narm Faulk');
-- Scripting cleanup
UPDATE `creature_template` SET `ScriptName`= '',`RegenHealth`=0 WHERE `entry`=@ENTRY;
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=@ENTRY;

-- SAI for Fhyron Shadesong
SET @ENTRY := 33788;
UPDATE `creature` SET `spawndist`=0,`MovementType`=0,`position_x`=8570.943,`position_y`=1008.467,`position_z`=548.2927 WHERE `guid`=127614;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,11,0,100,0,0,0,0,0,53,0,@ENTRY,1,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - On spawn - Start WP movement'),
(@ENTRY,0,1,0,40,0,100,0,8,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 8 - run script'),
(@ENTRY,0,2,0,40,0,100,0,10,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 10 - run script'),
(@ENTRY,0,3,0,40,0,100,0,12,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 12 - run script'),
(@ENTRY,0,4,0,40,0,100,0,14,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 14 - run script'),
(@ENTRY,0,5,0,40,0,100,0,15,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 15 - run script'),
(@ENTRY,0,6,0,40,0,100,0,17,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 17 - run script'),
(@ENTRY,0,7,0,40,0,100,0,18,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 18 - run script'),
(@ENTRY,0,8,0,40,0,100,0,20,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 20 - run script'),
(@ENTRY,0,9,0,40,0,100,0,21,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 21 - run script'),
(@ENTRY,0,10,0,40,0,100,0,26,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 26 - run script'),
(@ENTRY,0,11,0,40,0,100,0,28,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 28 - run script'),
(@ENTRY,0,12,0,40,0,100,0,31,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 31 - run script'),
(@ENTRY,0,13,0,40,0,100,0,33,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 33 - run script'),
(@ENTRY,0,14,0,40,0,100,0,38,@ENTRY,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Reach wp 38 - run script'),
(@ENTRY*100,9,0,0,0,0,100,0,0,0,0,0,54,8000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Script - Pause path'),
(@ENTRY*100,9,1,0,0,0,100,0,100,100,0,0,66,0,0,0,0,0,0,19,33787,0,0,0,0,0,0, 'Fhyron Shadesong - Script - turn to Tournament Druid Spell Target'),
(@ENTRY*100,9,2,0,0,0,100,0,100,100,0,0,11,63678,0,0,0,0,0,19,33787,0,0,0,0,0,0, 'Fhyron Shadesong - Script - Cast Earthliving Visual on Tournament Druid Spell Target'),
(@ENTRY*100,9,3,0,0,0,50,0,4000,4000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Fhyron Shadesong - Script - say text 0');
-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry`=@ENTRY; 
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'Help shield us from these cutting winds, little sapling.',0,7,100,2,0,0, 'Fhyron Shadesong'),
(@ENTRY,0,1, 'There you are',0,7,100,273,0,0, 'Fhyron Shadesong'),
(@ENTRY,0,2, 'Grow, little one.',0,7,100,273,0,0, 'Fhyron Shadesong');
-- Waypoints for Fhyron Shadesong from sniff
DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,8567.44,973.9194,547.9177, 'Fhyron Shadesong'),
(@ENTRY,2,8568.162,947.0933,547.8038, 'Fhyron Shadesong'),
(@ENTRY,3,8566.031,913.37,548.2927, 'Fhyron Shadesong'),
(@ENTRY,4,8564.706,894.527,547.6705, 'Fhyron Shadesong'),
(@ENTRY,5,8567.681,876.0731,547.5937, 'Fhyron Shadesong'),
(@ENTRY,6,8578.911,863.8034,548.4218, 'Fhyron Shadesong'),
(@ENTRY,7,8590.869,849.7815,547.6718, 'Fhyron Shadesong'),
(@ENTRY,8,8603.909,853.178,548.1281, 'Fhyron Shadesong'),
(@ENTRY,9,8599.38,855.512,547.715, 'Fhyron Shadesong'),
(@ENTRY,10,8591.701,868.5342,549.3784, 'Fhyron Shadesong'),
(@ENTRY,11,8586.77,871.798,547.876, 'Fhyron Shadesong'),
(@ENTRY,12,8586.149,883.8123,549.2509, 'Fhyron Shadesong'),
(@ENTRY,13,8583.74,886.251,548.96, 'Fhyron Shadesong'),
(@ENTRY,14,8582.075,903.0688,550.0374, 'Fhyron Shadesong'),
(@ENTRY,15,8585.078,918.2136,548.6675, 'Fhyron Shadesong'),
(@ENTRY,16,8581.65,944.137,547.897, 'Fhyron Shadesong'),
(@ENTRY,17,8582.839,948.3386,547.6221, 'Fhyron Shadesong'),
(@ENTRY,18,8565.45,986.6495,549.3403, 'Fhyron Shadesong'),
(@ENTRY,19,8570.5,989.399,547.629, 'Fhyron Shadesong'),
(@ENTRY,20,8576.626,1006.561,549.2132, 'Fhyron Shadesong'),
(@ENTRY,21,8586.87,1008.438,548.1278, 'Fhyron Shadesong'),
(@ENTRY,22,8590.46,1005.12,547.563, 'Fhyron Shadesong'),
(@ENTRY,23,8599.41,1007.08,547.419, 'Fhyron Shadesong'),
(@ENTRY,24,8602.17,1013.39,548.185, 'Fhyron Shadesong'),
(@ENTRY,25,8604.88,1030.23,556.734, 'Fhyron Shadesong'),
(@ENTRY,26,8612.658,1035.293,558.3499, 'Fhyron Shadesong'),
(@ENTRY,27,8611.47,1039.23,558.735, 'Fhyron Shadesong'),
(@ENTRY,28,8613.692,1042.313,558.3265, 'Fhyron Shadesong'),
(@ENTRY,29,8603.88,1044.65,558.38, 'Fhyron Shadesong'),
(@ENTRY,30,8598.02,1072.57,557.923, 'Fhyron Shadesong'),
(@ENTRY,31,8602.397,1081.373,558.2934, 'Fhyron Shadesong'),
(@ENTRY,32,8597.45,1089.27,557.317, 'Fhyron Shadesong'),
(@ENTRY,33,8600.864,1092.901,557.4839, 'Fhyron Shadesong'),
(@ENTRY,34,8593.38,1084.72,556.817, 'Fhyron Shadesong'),
(@ENTRY,35,8578.9,1068.6,557.38, 'Fhyron Shadesong'),
(@ENTRY,36,8563.31,1065.51,554.057, 'Fhyron Shadesong'),
(@ENTRY,37,8549.85,1061.87,550.61, 'Fhyron Shadesong'),
(@ENTRY,38,8547.754,1051.273,550.2899, 'Fhyron Shadesong'),
(@ENTRY,39,8544.317,1042.702,549.2928, 'Fhyron Shadesong'),
(@ENTRY,40,8557.891,1029.923,548.1677, 'Fhyron Shadesong'),
(@ENTRY,41,8566.168,1017.246,548.1677, 'Fhyron Shadesong'),
(@ENTRY,42,8570.943,1008.467,548.2927, 'Fhyron Shadesong');
-- Change InhabitType for 33787 "Tournament Druid Spell Target"
UPDATE `creature_template` SET `InhabitType`=1 WHERE `entry`=33787;

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (23801,24746,29594);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (23801,24746,29594);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23801,0,0,0,6,0,100,1,0,0,0,0,85,25281,2,0,0,0,0,7,0,0,0,0,0,0,0,'Turkey - Cast Marker on death'),
(24746,0,0,0,6,0,100,1,0,0,0,0,85,25281,2,0,0,0,0,7,0,0,0,0,0,0,0,'Fjord Turkey - Cast Marker on death'),
(29594,0,0,0,6,0,100,1,0,0,0,0,85,25281,2,0,0,0,0,7,0,0,0,0,0,0,0,'Angry Turkey - Cast Marker on death');

SET @ENTRY := 23861;
UPDATE `creature_template` SET `ScriptName`='',`AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,25,0,100,0,0,0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Restless Apparition - On spawn - Run script'),
(@ENTRY*100,9,0,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Restless Apparition - Script - Say text 0'),
(@ENTRY*100,9,1,0,0,0,100,0,8000,8000,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Restless Apparition - Script - Despawn');
DELETE FROM `creature_text` WHERE `entry`=@ENTRY; 
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0, 'The darkness... the corruption... they came too quickly for anyone to know...',0,0,15,25,0,0, 'Restless Apparition'),
(@ENTRY,0,1, 'It is too late for us, living one. Take yourself and your friend away from here before you both are... claimed...',0,0,15,25,0,0, 'Restless Apparition'),
(@ENTRY,0,2, 'Go away, whoever you are! Witch Hill is mine... mine!',0,0,15,25,0,0, 'Restless Apparition'),
(@ENTRY,0,3, 'The darkness will consume all... all the living...',0,0,15,25,0,0, 'Restless Apparition'),
(@ENTRY,0,4, 'The manor... someone else... will soon be consumed...',0,0,15,25,0,0, 'Restless Apparition'),
(@ENTRY,0,5, 'Why have you come here, outsider? You will only find pain! Our fate will be yours...',0,0,15,25,0,0, 'Restless Apparition'),
(@ENTRY,0,6, 'It was... terrible... the demon...',0,0,15,25,0,0, 'Restless Apparition');
-- Zeppelin Power Core
SET @ENTRY := 23832;
-- Remove aura hack
DELETE FROM `creature_template_addon` WHERE `entry`=@ENTRY;
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id`=@ENTRY);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@ENTRY,0,0,1,0, NULL); -- Zeppelin Power Core
-- Remove random movement
UPDATE `creature` SET `spawndist`=0,`MovementType`=0 WHERE `id`=@ENTRY;
-- SmartAI for Zeppelin Power Core
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@ENTRY*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY,0,0,0,1,0,100,0,1000,60000,90000,120000,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeppelin Power Core - OOC - Load script every 1.5-2 min'),
(@ENTRY*100,9,0,0,0,0,100,0,1000,1000,0,0,11,42491,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeppelin Power Core - Script - Cast Energized Periodic on self'),
(@ENTRY*100,9,1,0,0,0,100,0,60000,90000,0,0,28,42491,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Zeppelin Power Core - Script - After 1 - 1.5 min, remove Energized Periodic on self');
-- Add condition for Ooze Buster (item 33108, spell 42489)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceEntry`=33108;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,0,33108,0,24,1,4394,0,0, '', 'Item 33108 can target Bubbling Swamp Ooze'),
(18,0,33108,1,24,1,4393,0,0, '', 'Item 33108 can target Acidic Swamp Ooze');
UPDATE `creature_text` SET `type`=0 WHERE `type`=12 AND `entry`=23861;
DELETE FROM `creature_template_addon` WHERE `entry`=28221;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(28221,0,0,1,0, '11959');



 
 