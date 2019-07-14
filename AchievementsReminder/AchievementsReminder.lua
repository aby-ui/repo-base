achievereminderload=1
function out(text)
DEFAULT_CHAT_FRAME:AddMessage(text)
UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0, 1, 10) 
end

function icllonload()

iclllocaleuim()

if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="zhCN" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" or GetLocale()=="ptBR" then
iclllocaleui()
end


ralldatabase()

  achievementsreminderver=8.200


	if ralloptions==nil then ralloptions={1,1,0,0,0,0,1,0,0,0,0,0} end
	if rallbosstooltip==nil then rallbosstooltip=true end
	if rallbosschaton==nil then rallbosschaton=true end
	if ralloptionsmanual==nil then ralloptionsmanual={1,0,0,0,0,0} end
	if ralloptionsmanual3==nil then ralloptionsmanual3={1,0} end
	if ralloptionTrackCharAchieves==nil then ralloptionTrackCharAchieves=false end
	rallnomorereport={{},{},{0},{0}}
	ralltooltipready={{0},{0},{{0}}}
	rallcolonka=0
	ralldelaycheckzone2=GetTime()+10

	RaidAchievement_reminder:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	RaidAchievement_reminder:RegisterEvent("ADDON_LOADED")

	SLASH_ACHIEVEREMEASYACH1 = "/AchievementsReminder"
	SLASH_ACHIEVEREMEASYACH2 = "/achrem"
	SLASH_ACHIEVEREMEASYACH3 = "/ар"
	SLASH_ACHIEVEREMEASYACH4 = "/ачиврем"
	SLASH_ACHIEVEREMEASYACH5 = "/ачр"
	SLASH_ACHIEVEREMEASYACH6 = "/achr"
	if GetLocale()~="frFR" then
    SLASH_ACHIEVEREMEASYACH7 = "/ar"
  else
    SLASH_ACHIEVEREMEASYACH7 = "/arem"
	end
	SlashCmdList["ACHIEVEREMEASYACH"] = ACHIEVEREMEASYACH_Command

rabigmenuchatlisten={"raid", "raid_warning", "officer", "party", "guild", "say", "yell", "sebe"}
bigmenuchatlistea = {
areachatlist1,
areachatlist2,
areachatlist3,
areachatlist4,
areachatlist5,
areachatlist6,
areachatlist7,
areachatlist8,
}

end


function ACHIEVEREMEASYACH_Command(msg)

icll_buttonnew2()

end


function checkzoneIdA(_zoneList, _zoneId)

if (type(_zoneList) == "number") then
	if _zoneList==_zoneId then
		return true
	else
		return false
	end
else
	for iz=1,#_zoneList do
		if _zoneList[iz]==_zoneId then
			return true
		end
	end
end
return false

end


function icll_OnUpdate(icracurtime)


if ralldelaycheckzone2 and icracurtime>ralldelaycheckzone2 then
ralldelaycheckzone2=nil
ralldelaycheckzone=GetTime()+0.5 --ыытест не работал инфо после релога, так заработал
local a1, a2, a3, a4, a5 = GetInstanceInfo()
  if UnitInRaid("player") or a2=="pvp" or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or a3==2 or a3==23 or (a3==1 and a2=="scenario") then
  --SetMapToCurrentZone()
  end
  local _, instanceType, pppl, _, maxPlayers, dif = GetInstanceInfo()
if select(3,GetInstanceInfo())==17 then
--no LFR
elseif (a2=="pvp" and raenablebg==1) or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or select(3,GetInstanceInfo())==2 or (select(3,GetInstanceInfo())==1 and a2=="scenario") then
  local found=0
  local curZoneID=C_Map.GetBestMapForUnit("player")
  for kj=1,#ralllocations do
    if checkzoneIdA(ralllocations[kj],curZoneID) then
      found=found+1
      rallcolonka=kj
    end
  end
  if found>1 then
    rallcolonka=0
	local curZoneID=C_Map.GetBestMapForUnit("player")
    for bv=1,#ralllocations do
      if checkzoneIdA(ralllocations[bv],curZoneID) then
        if ralltip[bv]=="10" or ralltip[bv]=="25" then
          if tonumber(ralltip[bv])==a5 then
            rallcolonka=bv
          end
        else
            rallcolonka=bv
        end
      end
    end
  end
else
  rallcolonka=0
end

end

if ralldelaycheckzone and icracurtime>ralldelaycheckzone then
  ralldelaycheckzone=nil
  local vbil=0
  local a1, a2, a3, a4, a5 = GetInstanceInfo()
  if UnitInRaid("player") or (a2=="pvp" and raenablebg==1) or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or select(3,GetInstanceInfo())==2 or (select(3,GetInstanceInfo())==1 and a2=="scenario") then
  --SetMapToCurrentZone()
  end
  local _, instanceType, pppl, _, maxPlayers, dif = GetInstanceInfo()
if select(3,GetInstanceInfo())==17 then
--no LFR
elseif C_Map.GetBestMapForUnit("player") and C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")) and C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name and ralllocationnames and ralllocations then
local curZoneID=C_Map.GetBestMapForUnit("player")
  for i=1,#ralllocations do
    if checkzoneIdA(ralllocations[i],curZoneID) then
      ralllocationnames[i]=C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name
      if a2~="pvp" then
        vbil=1
      end
    end
  end
end


	if ralloptions[7]==1 and vbil==1 then
		RaidAchievement_reminder:RegisterEvent("PLAYER_TARGET_CHANGED")
	else
		RaidAchievement_reminder:UnregisterEvent("PLAYER_TARGET_CHANGED")
	end

	if rallbosstooltip and ralloptions[7]==1 and vbil==1 then
		RaidAchievement_reminder:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	else
		RaidAchievement_reminder:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end


local _, a2, a3, _, a5 = GetInstanceInfo()
local _, instanceType, pppl, _, maxPlayers, dif = GetInstanceInfo()
if select(3,GetInstanceInfo())==17 then
--no LFR
else
	if ralloptions[1]==1 then
		if #rallnomorereport[1]==0 then
			if (a2=="pvp" and raenablebg==1) or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or select(3,GetInstanceInfo())==2 or (select(3,GetInstanceInfo())==1 and a2=="scenario") then
				icllcheckachieves(1)
				local a1, a2, a3, a4, a5 = GetInstanceInfo()
        if a2~="pvp" then --для пвп постоянно показываем зону, для сценариев также!
          if select(3,GetInstanceInfo())~=1 and a2~=nil then
			local curZoneID=C_Map.GetBestMapForUnit("player")
            table.insert(rallnomorereport[1],curZoneID)
            table.insert(rallnomorereport[2],a5)
          end
				end
			end
		else
			local bil=0
			local curZoneID=C_Map.GetBestMapForUnit("player")
			for i=1,#rallnomorereport[1] do
				if rallnomorereport[1][i]==curZoneID then
					if a5==rallnomorereport[2][i] then
						bil=1
						icllcheckachieves()
					end
				end
			end
			if bil==0 then
				icllcheckachieves(1)
				if (a2=="pvp" and raenablebg==1) or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or select(3,GetInstanceInfo())==2 or (select(3,GetInstanceInfo())==1 and a2=="scenario") then
          local a1, a2, a3, a4, a5 = GetInstanceInfo()
          if a2~="pvp" then --для пвп постоянно показываем зону, для сценариев также!
            if select(3,GetInstanceInfo())~=1 and a2~=nil then
				local curZoneID=C_Map.GetBestMapForUnit("player")
              table.insert(rallnomorereport[1],curZoneID)
              table.insert(rallnomorereport[2],a5)
            end
					end
				else
					rallcolonka=0
				end
			end
		end


	else
		if psllinfframe then
			psllinfframe:Clear()
			psllinfframe:AddMessage(rallachiverepl6)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
				psllinfframe:SetHeight(40)
			end
		end
	rallcolonka=0
	end
end--lfr
end


end


function icllonevent(self,event,...)

local arg1, arg2, arg3,arg4,arg5,arg6 = ...



if event == "PLAYER_TARGET_CHANGED" then
rallbosscheck()
end

if event == "UPDATE_MOUSEOVER_UNIT" then
ralltooltipchangenow()
end


if event == "ZONE_CHANGED_NEW_AREA" then
ralldelaycheckzone=GetTime()+3
ralldelaycheckzone2=nil
end

if event == "ADDON_LOADED" then

	if arg1=="AchievementsReminder" then
	
	zzralistach=icralistach
zzralistach2=icralistach2
zzralistach3=icralistach3
zzralistach3_Button1=icralistach3_Button1
zzralistach3_Button2=icralistach3_Button2
zzralistach3_ButtonP=icralistach3_ButtonP
zzralistach3_ButtonN=icralistach3_ButtonN
	
	
	if ralllocationnamesdef then

if ralllocationnames==nil then
ralllocationnames={}
for i=1,#ralllocationnamesdef do
	table.insert(ralllocationnames,ralllocationnamesdef[i])
end
end


if ralllocationnames then
for i=1,#ralllocationnamesdef do
	if ralllocationnames[i]==nil then
		ralllocationnames[i]=ralllocationnamesdef[i]
	end
end
end

ralllocationnamesdef=nil
	end


	if ralloptions[7]==1 then
		RaidAchievement_reminder:RegisterEvent("PLAYER_TARGET_CHANGED")
	else
		RaidAchievement_reminder:UnregisterEvent("PLAYER_TARGET_CHANGED")
	end

	if rallbosstooltip and ralloptions[7]==1 then
		RaidAchievement_reminder:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	else
		RaidAchievement_reminder:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end


	--перенос тактик
ralltacticsdef=
{{ralldefaulttactic40,ralldefaulttactic41,ralldefaulttactic42,0,ralldefaulttactic43,ralldefaulttactic44,ralldefaulttactic45,ralldefaulttactic46,ralldefaulttactic94,format(ralldefaulttactic47,3),ralldefaulttactic48,ralldefaulttactic49,ralldefaulttactic50,0,0,0,0,0,0,0,0,0,0,0,0},--icc10
{ralldefaulttactic40,ralldefaulttactic41,ralldefaulttactic42,0,ralldefaulttactic43,ralldefaulttactic44,ralldefaulttactic45,ralldefaulttactic46,ralldefaulttactic94,format(ralldefaulttactic47,8),ralldefaulttactic48,ralldefaulttactic49,ralldefaulttactic50,0,0,0,0,0,0,0,0,0,0,0,0},--icc25
{format(ralldefaulttactic33,2),0,0,0,0,ralldefaulttactic34,0,0}, --toc10
{format(ralldefaulttactic33,4),0,0,0,ralldefaulttactic34,0,0}, --toc25
{ralldefaulttactic51,0,0,ralldefaulttactic52,ralldefaulttactic53,0,0,0,0,ralldefaulttactic54,ralldefaulttactic55,0,ralldefaulttactic56,ralldefaulttactic57,ralldefaulttactic58,ralldefaulttactic59,ralldefaulttactic60,0,0,0,0,0,0,0,ralldefaulttactic61,ralldefaulttactic62,ralldefaulttactic63,format(ralldefaulttactic64,rallachievekologarnhp1),0,0,ralldefaulttactic65,0,ralldefaulttactic66,ralldefaulttactic67,ralldefaulttactic68,ralldefaulttactic69,ralldefaulttactic70,ralldefaulttactic71,ralldefaulttactic72,ralldefaulttactic73,0,0,0,0,0,ralldefaulttactic74,0,0,0,ralldefaulttactic75,ralldefaulttactic76,0,0,0,ralldefaulttactic77,0,ralldefaulttactic78,ralldefaulttactic79,ralldefaulttactic80,0,0,0,0,0,0,0,ralldefaulttactic81,0},
{ralldefaulttactic51,0,0,ralldefaulttactic52,ralldefaulttactic53,0,0,0,0,ralldefaulttactic54,ralldefaulttactic55,0,ralldefaulttactic56,ralldefaulttactic57,ralldefaulttactic58,ralldefaulttactic59,ralldefaulttactic60,0,0,0,0,0,0,0,ralldefaulttactic61,ralldefaulttactic62,ralldefaulttactic63,format(ralldefaulttactic64,rallachievekologarnhp2),0,0,ralldefaulttactic65,0,ralldefaulttactic66,ralldefaulttactic67,ralldefaulttactic68,ralldefaulttactic69,ralldefaulttactic70,ralldefaulttactic71,ralldefaulttactic72,ralldefaulttactic73,0,0,0,0,0,ralldefaulttactic74,0,0,0,ralldefaulttactic75,ralldefaulttactic76,0,0,0,ralldefaulttactic77,0,ralldefaulttactic78,ralldefaulttactic79,ralldefaulttactic80,0,0,0,0,0,0,0,ralldefaulttactic81,0},
{0,ralldefaulttactic37,0,0,0,0,0,0,0,ralldefaulttactic38,0,0,0,0,ralldefaulttactic39,0,0,0},--naxx10
{0,ralldefaulttactic37,0,0,0,0,0,0,0,ralldefaulttactic38,0,0,0,0,ralldefaulttactic39,0,0,0},--naxx25
{ralldefaulttactic36,0,0,0},--malygos10
{ralldefaulttactic36,0,0,0},--malygos25
{0,ralldefaulttactic31,ralldefaulttactic32,0},--onyxia10
{0,ralldefaulttactic31,ralldefaulttactic32,0},--onyxia25
{0},--arka10
{0},--arka25
{ralldefaulttactic35,0,0,0,0,0},--sart10
{ralldefaulttactic35,0,0,0,0,0},--sart25
{0,0},--halion10
{0,0},--halion25
{ralldefaulttactic28,0,0,0},--ankahet
{0,ralldefaulttactic5.."\n"..ralldefaulttacticmain3,0,0},--azjol
{ralldefaulttactic1,ralldefaulttactic13,0},--strat
{ralldefaulttactic18,ralldefaulttactic19,ralldefaulttactic20.."\n"..ralldefaulttacticmain2},--colis5
{ralldefaulttactic3,ralldefaulttactic2,ralldefaulttactic4.."\n"..ralldefaulttacticmain1,0},--draktaron
{ralldefaulttactic6,ralldefaulttactic7,ralldefaulttactic8,ralldefaulttactic9,0},--gundrak
{0,0},--reflect
{ralldefaulttactic11.."\n"..ralldefaulttacticmain2,ralldefaulttactic12.."\n"..ralldefaulttacticmain3,0},--PitOfSaron
{ralldefaulttactic14,ralldefaulttactic15,0},--ForgeOfSouls
{0,ralldefaulttactic16,ralldefaulttactic17,0},--nexus
{0,0,0,0,0,0},--oculus
{0,ralldefaulttactic25,ralldefaulttactic26,0,ralldefaulttactic27},--VioletHold
{ralldefaulttactic29,ralldefaulttactic30,0,0},--HallsOfLighting
{0,0,ralldefaulttactic10.."\n"..ralldefaulttacticmain1,0},--HallsOfStone
{ralldefaulttactic21,0},--utgard5
{ralldefaulttactic22,0,ralldefaulttactic23,ralldefaulttactic24,0},--utgard5
{ralldefaulttactic84,ralldefaulttactic82,ralldefaulttactic83,0,0,0,0},--The Deadmines
{ralldefaulttactic85,ralldefaulttactic86,0,0},--Shadowfang Keep
{ralldefaulttactic87,ralldefaulttactic88,0},--Throne of the Tides
{0,ralldefaulttactic89,0,0,0},--Blackrock Caverns
{0,0},--The Stonecore
{ralldefaulttactic92,ralldefaulttactic90,0},--The Vortex Pinnacle
{ralldefaulttactic91,0,0},--Grim Batol
{0,0,0,0,0},--Halls of Origination
{0,ralldefaulttactic93,0,0},--Lost City of the Tol'vir
{0},--Baradin Hold
{0,0,0,0,0,0,0,0,0,0,0,0,0},--Blackwing Descent
{0,0,0,0,0,0,0,0,0,0,0},--The Bastion of Twilight
{0,0,0,0,0},--Throne of the Four Winds
}



--версия игры
ralltacticsverdef={{406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406},--icc10
{406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406},--icc25
{406,403,403,403,403,406,406,406}, --toc10
{406,403,403,403,406,406,406}, --toc25
{403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403},
{403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403},
{403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403},--naxx10
{403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403,403},--naxx25
{403,403,403,403},--malygos10
{403,403,403,403},--malygos25
{403,403,403,403},--onyxia10
{403,403,403,403},--onyxia25
{403},--arka10
{403},--arka25
{403,403,403,403,403,403},--sart10
{403,403,403,403,403,403},--sart25
{403,403},--halion10
{403,403},--halion25
{403,403,403,403},--ankahet
{403,403,403,403},--azjol
{403,403,403},--strat
{403,403,403},--colis5
{403,403,403,403},--draktaron
{403,403,403,403,403},--gundrak
{403,403},--reflect
{403,403,403},--PitOfSaron
{403,403,403},--ForgeOfSouls
{403,403,403,403},--nexus
{403,403,403,403,403,403},--oculus
{403,403,403,403,403},--VioletHold
{403,403,403,403},--HallsOfLighting
{403,403,403,403},--HallsOfStone
{403,403},--utgard5
{403,403,403,403,403},--utgard5
{405,406,405,405,405,405,405},--The Deadmines
{404,404,404,404},--Shadowfang Keep
{404,404,404},--Throne of the Tides
{404,404,404,404,404},--Blackrock Caverns
{404,404},--The Stonecore
{405,405,404},--The Vortex Pinnacle
{404,404,404},--Grim Batol
{404,404,404,404,404},--Halls of Origination
{404,405,404,404},--Lost City of the Tol'vir
{404},--Baradin Hold
{404,404,404,404,404,404,404,404,404,404,404,404,404},--Blackwing Descent
{404,404,404,404,404,404,404,404,404,404,404},--The Bastion of Twilight
{404,404,404,404,404},--Throne of the Four Winds
}

ralltacticsdifdef={{0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0},--icc10
{0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0},--icc25
{0,0,0,0,0,1,0,0}, --toc10
{0,0,0,0,1,0,0}, --toc25
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},--naxx10
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},--naxx25
{0,0,0,0},--malygos10
{0,0,0,0},--malygos25
{0,0,0,0},--onyxia10
{0,0,0,0},--onyxia25
{0},--arka10
{0},--arka25
{0,0,0,0,0,0},--sart10
{0,0,0,0,0,0},--sart25
{0,0},--halion10
{0,0},--halion25
{0,0,0,0},--ankahet
{0,0,0,0},--azjol
{1,0,0},--strat
{0,1,0},--colis5
{0,0,0,0},--draktaron
{0,0,1,0,0},--gundrak
{0,0},--reflect
{0,0,0},--PitOfSaron
{1,0,0},--ForgeOfSouls
{0,0,0,0},--nexus
{0,0,0,0,0,0},--oculus
{0,0,0,0,0},--VioletHold
{0,0,0,0},--HallsOfLighting
{0,0,1,0},--HallsOfStone
{0,0},--utgard5
{0,0,0,0,0},--utgard5
{0,0,1,0,0,0,0},--The Deadmines
{0,0,0,0},--Shadowfang Keep
{0,0,0},--Throne of the Tides
{0,0,0,0,0},--Blackrock Caverns
{0,0},--The Stonecore
{0,1,0},--The Vortex Pinnacle
{0,0,0},--Grim Batol
{0,0,0,0,0},--Halls of Origination
{0,1,0,0},--Lost City of the Tol'vir
{0},--Baradin Hold
{0,0,0,0,0,0,0,0,0,0,0,0,0},--Blackwing Descent
{0,0,0,0,0,0,0,0,0,0,0},--The Bastion of Twilight
{0,0,0,0,0},--Throne of the Four Winds
}

	if ralltactics==nil then ralltactics=ralltacticsdef end
	if ralltacticsver==nil then ralltacticsver=ralltacticsverdef end
	if ralltacticsdif==nil then ralltacticsdif=ralltacticsdifdef end

	for i=1,#rallachieve do
		if ralltactics[i]==nil then ralltactics[i]={} end
		if ralltacticsver[i]==nil then ralltacticsver[i]={} end
		if ralltacticsdif[i]==nil then ralltacticsdif[i]={} end
		for j=1,#rallachieve[i] do
			if ralltactics[i][j]==nil then
				if ralltacticsdef[i] and ralltacticsdef[i][j] then
					ralltactics[i][j]=ralltacticsdef[i][j]
				else
					ralltactics[i][j]=0
				end
			elseif ralltactics[i][j]==0 then
				if ralltacticsdef[i] and ralltacticsdef[i][j] then
					ralltactics[i][j]=ralltacticsdef[i][j]
				end
			end

			if ralltacticsdif[i][j]==nil then
				if ralltacticsdifdef[i] and ralltacticsdifdef[i][j] then
					ralltacticsdif[i][j]=ralltacticsdifdef[i][j]
				else
					ralltacticsdif[i][j]=0
				end
			elseif ralltacticsdif[i][j]==0 then
				if ralltacticsdifdef[i] and ralltacticsdifdef[i][j] then
					ralltacticsdif[i][j]=ralltacticsdifdef[i][j]
				end
			end

			if ralltacticsver[i][j]==nil then
				if ralltacticsverdef[i] and ralltacticsverdef[i][j] then
					ralltacticsver[i][j]=ralltacticsverdef[i][j]
				else
					ralltacticsver[i][j]=4.0
				end
			else
				if ralltacticsverdef[i] and ralltacticsverdef[i][j] then
					if ralltacticsverdef[i][j]>ralltacticsver[i][j] and ralltacticsdef[i][j]~=0 then
						ralltacticsver[i][j]=ralltacticsverdef[i][j]
						ralltactics[i][j]=ralltacticsdef[i][j]
					end
				end
			end

		end
	end

ralltacticsdifdef=nil
ralltacticsverdef=nil

	end
end




end --КОНЕЦ ОНЕВЕНТ



function icll_buttonnew2()
if IsAddOnLoaded("RaidAchievement") then
  PSFea_closeallpr()
  PSFeamain1:Show()
  PSFeamain2:Show()
else
  zzralistach:Hide()
  zzralistach2:Hide()
  zzralistach3:Hide()
  ARmain1:Show()
end


zzralistach:Show()
iclldrawtext()
icllcheckachieves()

end --конец бутон2

function PSFea_listachmanual()

if IsAddOnLoaded("RaidAchievement") then
  PSFea_closeallpr()
else
  zzralistach:Hide()
  zzralistach2:Hide()
  zzralistach3:Hide()
  ARmain1:Show()
end

zzralistach2:Show()
iclldrawtext2()

end --конец бутон3

function icll_button3()
if IsAddOnLoaded("RaidAchievement") then
  PSFea_closeallpr()

else
  zzralistach:Hide()
  zzralistach2:Hide()
  zzralistach3:Hide()
  ARmain1:Show()
end
zzralistach3:Show()

local aa2="TACTICS: This module is not updated since Cataclysm launched, not easy to maintain it."
if GetLocale() == "ruRU" then
aa2="ТАКТИКИ: Этот модуль не обновляется с выхода Катаклизма, занимает много времени на его поддержку."
end

out("|cff99ffffAchievementsReminder|r - "..aa2)


iclldrawtext3()

end

function icll_button33()
--если текущая зона инст - открывать тактики сразу


--local aa2="TACTICS: This module is not updated since Cataclysm lunched, not easy to maintain it."
--if GetLocale() == "ruRU" then
--aa2="ТАКТИКИ: Этот модуль не обновляется с выхода Катаклизма, занимает много времени на его поддержку."
--end


--out("|cff99ffffRaidAchievement|r - "..aa2)

local bil=0
--SetMapToCurrentZone()
local _, instanceType, pppl, _, maxPlayers, dif = GetInstanceInfo()
if select(3,GetInstanceInfo())==17 then
--no LFR
else
local curZoneID=C_Map.GetBestMapForUnit("player")
for i=1,#ralllocations do
	if checkzoneIdA(ralllocations[i],curZoneID) then
		local a1, a2, a3, a4, a5 = GetInstanceInfo()
		if a2=="pvp" or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or select(3,GetInstanceInfo())==2 or (select(3,GetInstanceInfo())==1 and a2=="scenario") then
			if ralltip[i]=="10" or ralltip[i]=="25" then
				if tonumber(ralltip[i])==a5 then
					bil=i
				end
			else
				bil=i
			end
		end
	end
end
end
if bil==0 then
PSFea_listachmanual()
else
rallonlycurrzone=bil
icll_button3()
end

end


function iclldrawtext()
if iclldrawtime1==nil then
iclldrawtime1=1

local t = zzralistach:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetText(ralltitle2)
t:SetJustifyH("LEFT")
t:SetJustifyV("TOP")
t:SetPoint("TOPLEFT",20,-15)
t:SetWidth(700)
t:SetHeight(155)

--отправить инфо
rapsebf1 = CreateFrame("EditBox", "rallpseb1", zzralistach,"InputBoxTemplate")
rapsebf1:SetAutoFocus(false)
rapsebf1:SetHeight(20)
rapsebf1:SetWidth(120)
rapsebf1:SetPoint("TOPLEFT", 617, -324)
rapsebf1:Show()
rapsebf1:SetScript("OnTextChanged", function(self) if string.len(rapsebf1:GetText())>0 then rallradiobtn1:SetChecked(true) rallradiobtn2:SetChecked(false) else rallradiobtn1:SetChecked(false) rallradiobtn2:SetChecked(true) end end )
rapsebf1:SetScript("OnEnterPressed", function(self) rapsebf1:ClearFocus() end )
rapsebf1:SetScript("OnEditFocusLost", function(self) if string.len(rapsebf1:GetText())==0 then rallradiobtn1:SetChecked(false) rallradiobtn2:SetChecked(true) end end)

openmenull()

rallradiobtn1 = CreateFrame("CheckButton", nil, zzralistach, "SendMailRadioButtonTemplate")
rallradiobtn1:SetWidth("20")
rallradiobtn1:SetHeight("20")
rallradiobtn1:SetPoint("TOPLEFT", 593, -325)
rallradiobtn1:SetScript("OnClick", function(self) if string.len(rapsebf1:GetText())>0 then rallradiobtn2:SetChecked(false) rallradiobtn1:SetChecked(true) else rallradiobtn1:SetChecked(true) rallradiobtn2:SetChecked(false) rapsebf1:SetFocus(true) end end )

rallradiobtn2 = CreateFrame("CheckButton", nil, zzralistach, "SendMailRadioButtonTemplate")
rallradiobtn2:SetWidth("20")
rallradiobtn2:SetHeight("20")
rallradiobtn2:SetPoint("TOPLEFT", 593, -355)
rallradiobtn2:SetScript("OnClick", function(self) rallradiobtn1:SetChecked(false) rallradiobtn2:SetChecked(true) rapsebf1:SetText("") rapsebf1:ClearFocus() end )

local t2 = zzralistach:CreateFontString()
t2:SetFont(GameFontNormal:GetFont(), 14)
t2:SetText(rallwhisper)
t2:SetJustifyH("LEFT")
t2:SetJustifyV("TOP")
t2:SetPoint("TOPLEFT",640,-308)
t2:SetWidth(100)
t2:SetHeight(25)


psllinfscroll = CreateFrame("ScrollFrame", "psllinfscroll", zzralistach, "UIPanelScrollFrameTemplate")
psllinfscroll:SetPoint("TOPLEFT", zzralistach, "TOPLEFT", 20, -310)
psllinfscroll:SetHeight(180)
psllinfscroll:SetWidth(550)


--скролл фрейм с ачивками
psllinfframe = CreateFrame("ScrollingMessageFrame", "psllinfframe", psllinfscroll)

psllinfframe:SetPoint("TOPRIGHT", psllinfscroll, "TOPRIGHT", 0, 0)
psllinfframe:SetPoint("TOPLEFT", psllinfscroll, "TOPLEFT", 0, 0)
psllinfframe:SetPoint("BOTTOMRIGHT", psllinfscroll, "BOTTOMRIGHT", 0, 0)
psllinfframe:SetPoint("BOTTOMLEFT", psllinfscroll, "BOTTOMLEFT", 0, 0)
psllinfframe:SetFont(GameFontNormal:GetFont(), 12) --ыытест как появится ТОП пролистывание, сменить размер на 12
psllinfframe:SetMaxLines(100)
psllinfframe:SetHyperlinksEnabled(true)
psllinfframe:SetScript("OnHyperlinkClick", function(self,link,text,button) SetItemRef(link,text,button) end)
psllinfframe:SetHeight(155)
psllinfframe:SetWidth(540)
psllinfframe:Show()
psllinfframe:SetFading(false)
psllinfframe:SetJustifyH("LEFT")
psllinfframe:SetJustifyV("TOP")
--psllinfframe:SetInsertMode("TOP") --ыытест to check after 4.0.1




psllinfscroll:SetScrollChild(psllinfframe)
psllinfscroll:Show()


--tooltip change
rallbosstooltipcb = CreateFrame("CheckButton", nil, zzralistach, "UICheckButtonTemplate")
rallbosstooltipcb:SetWidth("20")
rallbosstooltipcb:SetHeight("20")
rallbosstooltipcb:SetPoint("TOPLEFT", 42, -214)
rallbosstooltipcb:SetScript("OnClick", function(self) icllgalkatt(1) end )

rallbosstooltipcb2 = CreateFrame("CheckButton", nil, zzralistach, "UICheckButtonTemplate")
rallbosstooltipcb2:SetWidth("20")
rallbosstooltipcb2:SetHeight("20")
rallbosstooltipcb2:SetPoint("TOPLEFT", 20, -214)
rallbosstooltipcb2:SetScript("OnClick", function(self) icllgalkatt(2) end )

if rallbosstooltip then
rallbosstooltipcb:SetChecked(true)
else
rallbosstooltipcb:SetChecked(false)
end

if rallbosschaton then
rallbosstooltipcb2:SetChecked(true)
else
rallbosstooltipcb2:SetChecked(false)
end


rallbosstooltiptxt = zzralistach:CreateFontString()
rallbosstooltiptxt:SetFont(GameFontNormal:GetFont(), 12)
local ttyt=""
if rallbosschaton then
ttyt="|cff00ff00"..rallchatshowboss.."|r"
else
ttyt="|cffff0000"..rallchatshowboss.."|r"
end

if rallbosstooltip then
ttyt=ttyt.." / |cff00ff00"..ralltooltiptxt.."|r"
else
ttyt=ttyt.." / |cffff0000"..ralltooltiptxt.."|r"
end

rallbosstooltiptxt:SetText(ttyt)
rallbosstooltiptxt:SetJustifyH("LEFT")
rallbosstooltiptxt:SetPoint("TOPLEFT",64, -211)
rallbosstooltiptxt:SetHeight(23)



psllcheckbuttontable={}
psllcheckbuttontable2={}
local txttable={ralltxt1,ralltxt2,ralltxt3,ralltxt4,ralltxt5,ralltxt6,ralltxt7,ralltxt8,ralltxt9,ralltxt10,ralltxt11,ralltxt12}
local o=0
for i=1,12 do
if i==7 then
o=15
end
if i==8 then
o=30
end
if i==1 or i==7 then
local c = CreateFrame("CheckButton", nil, zzralistach, "OptionsCheckButtonTemplate")
c:SetWidth("20")
c:SetHeight("20")
c:SetPoint("TOPLEFT", 20, -79-i*15-o)
c:SetScript("OnClick", function(self) icllgalka(i) end )
table.insert(psllcheckbuttontable, c)
else
local c = CreateFrame("CheckButton", nil, zzralistach, "SendMailRadioButtonTemplate")
c:SetWidth("16")
c:SetHeight("16")
c:SetPoint("TOPLEFT", 22, -81-i*15-o)
c:SetScript("OnClick", function(self) icllgalkaradio(i) end )
table.insert(psllcheckbuttontable, c)
end

--txt
local t = zzralistach:CreateFontString()
if i==1 or i==7 then
t:SetFont(GameFontNormal:GetFont(), 13)
else
t:SetFont(GameFontNormal:GetFont(), 11)
end
t:SetText(txttable[i])
t:SetJustifyH("LEFT")
t:SetPoint("TOPLEFT",42, -77-i*15-o)
t:SetHeight(23)
table.insert(psllcheckbuttontable2, t)


end

--only char achieves
ralloptionTrackCharAchievesCB = CreateFrame("CheckButton", nil, zzralistach, "OptionsCheckButtonTemplate")
ralloptionTrackCharAchievesCB:SetWidth("20")
ralloptionTrackCharAchievesCB:SetHeight("20")
ralloptionTrackCharAchievesCB:SetPoint("TOPLEFT", 350, -229)
ralloptionTrackCharAchievesCB:SetScript("OnClick", function(self) if ralloptionTrackCharAchieves then ralloptionTrackCharAchieves=false icllcheckachieves() else ralloptionTrackCharAchieves=true icllcheckachieves() end end )
local t2 = zzralistach:CreateFontString()
t2:SetFont(GameFontNormal:GetFont(), 11)
t2:SetText("NEW! "..ralltextoptionCharAch)
t2:SetJustifyH("LEFT")
t2:SetPoint("TOPLEFT",372, -227)
t2:SetHeight(23)

icllsetgalki()

end
end


function iclldrawtext2()
if iclldrawtime2==nil then
iclldrawtime2=1

local t = zzralistach2:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetText(ralltitle3)
t:SetJustifyH("LEFT")
t:SetJustifyV("TOP")
t:SetPoint("TOPLEFT",20,-15)
t:SetWidth(700)
t:SetHeight(155)

--отправить инфо
rapsebf2 = CreateFrame("EditBox", "rallpseb2", zzralistach2,"InputBoxTemplate")
rapsebf2:SetAutoFocus(false)
rapsebf2:SetHeight(20)
rapsebf2:SetWidth(120)
rapsebf2:SetPoint("TOPLEFT", 617, -324)
rapsebf2:Show()
rapsebf2:SetScript("OnTextChanged", function(self) if string.len(rapsebf2:GetText())>0 then rallradiobtn11:SetChecked(true) rallradiobtn22:SetChecked(false) else rallradiobtn11:SetChecked(false) rallradiobtn22:SetChecked(true) end end )
rapsebf2:SetScript("OnEnterPressed", function(self) rapsebf2:ClearFocus() end )
rapsebf2:SetScript("OnEditFocusLost", function(self) if string.len(rapsebf2:GetText())==0 then rallradiobtn11:SetChecked(false) rallradiobtn22:SetChecked(true) end end)


rallradiobtn11 = CreateFrame("CheckButton", nil, zzralistach2, "SendMailRadioButtonTemplate")
rallradiobtn11:SetWidth("20")
rallradiobtn11:SetHeight("20")
rallradiobtn11:SetPoint("TOPLEFT", 593, -325)
rallradiobtn11:SetScript("OnClick", function(self) if string.len(rapsebf2:GetText())>0 then rallradiobtn22:SetChecked(false) rallradiobtn11:SetChecked(true) else rallradiobtn11:SetChecked(true) rallradiobtn22:SetChecked(false) rapsebf2:SetFocus(true) end end )

rallradiobtn22 = CreateFrame("CheckButton", nil, zzralistach2, "SendMailRadioButtonTemplate")
rallradiobtn22:SetWidth("20")
rallradiobtn22:SetHeight("20")
rallradiobtn22:SetPoint("TOPLEFT", 593, -355)
rallradiobtn22:SetScript("OnClick", function(self) rallradiobtn11:SetChecked(false) rallradiobtn22:SetChecked(true) rapsebf2:SetText("") rapsebf2:ClearFocus() end )

local ttm={{640,50,250,450},{-308,-200,-200,-200},{rallwhisper,rallmanualtxt1,rallmanualtxt2,rallmanualtxt3}}
for tter=1,4 do
local t2 = zzralistach2:CreateFontString()
t2:SetFont(GameFontNormal:GetFont(), 14)
t2:SetText(ttm[3][tter])
t2:SetJustifyH("LEFT")
t2:SetJustifyV("TOP")
t2:SetPoint("TOPLEFT",ttm[1][tter],ttm[2][tter])
t2:SetWidth(100)
t2:SetHeight(25)
end


psllinfscroll2 = CreateFrame("ScrollFrame", "psllinfscroll2", zzralistach2, "UIPanelScrollFrameTemplate")
psllinfscroll2:SetPoint("TOPLEFT", zzralistach2, "TOPLEFT", 20, -260)
psllinfscroll2:SetHeight(230)
psllinfscroll2:SetWidth(550)


--скролл фрейм с ачивками
psllinfframe2 = CreateFrame("ScrollingMessageFrame", "psllinfframe2", psllinfscroll2)

psllinfframe2:SetPoint("TOPRIGHT", psllinfscroll2, "TOPRIGHT", 0, 0)
psllinfframe2:SetPoint("TOPLEFT", psllinfscroll2, "TOPLEFT", 0, 0)
psllinfframe2:SetPoint("BOTTOMRIGHT", psllinfscroll2, "BOTTOMRIGHT", 0, 0)
psllinfframe2:SetPoint("BOTTOMLEFT", psllinfscroll2, "BOTTOMLEFT", 0, 0)
psllinfframe2:SetFont(GameFontNormal:GetFont(), 12) --ыытест как появится ТОП пролистывание, сменить размер на 12
psllinfframe2:SetMaxLines(100)
psllinfframe2:SetHyperlinksEnabled(true)
psllinfframe2:SetScript("OnHyperlinkClick", function(self,link,text,button) SetItemRef(link,text,button) end)
psllinfframe2:SetHeight(55)
psllinfframe2:SetWidth(540)
psllinfframe2:Show()
psllinfframe2:SetFading(false)
psllinfframe2:SetJustifyH("LEFT")
psllinfframe2:SetJustifyV("TOP")
--psllinfframe2:SetInsertMode("TOP") --ыытест to check after 4.0.1




psllinfscroll2:SetScrollChild(psllinfframe2)
psllinfscroll2:Show()



psllcheckbuttontablem1={}
--psllcheckbuttontablem2={}
local txttable={ralltxt2,ralltxt3,ralltxt4,ralltxt5,ralltxt6,ralltxt13}
for i=1,6 do
local c = CreateFrame("CheckButton", nil, zzralistach2, "SendMailRadioButtonTemplate")
c:SetWidth("16")
c:SetHeight("16")
c:SetPoint("TOPLEFT", 22, -81-i*15)
c:SetScript("OnClick", function(self) icllgalkaradiom2(i) end )
table.insert(psllcheckbuttontablem1, c)


--txt
local t = zzralistach2:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 11)
t:SetText(txttable[i])
t:SetJustifyH("LEFT")
t:SetPoint("TOPLEFT",42, -77-i*15)
t:SetHeight(23)



end

rallmanualch1=#rallexpansions
rallmanualch2=1
rallmanualch3=1

openmenull2()
openmenullch1()
openmenullch2()
openmenullch3()

icllsetgalkim2()

end
end
















function iclldrawtext3()
if iclldrawtime3==nil then
iclldrawtime3=1

local t = zzralistach3:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 12)
t:SetText(ralltitle33)
t:SetJustifyH("LEFT")
t:SetJustifyV("TOP")
t:SetPoint("TOPLEFT",20,-15)
t:SetWidth(700)
t:SetHeight(175)

--отправить инфо
rapsebf3 = CreateFrame("EditBox", "rallpsebf3", zzralistach3,"InputBoxTemplate")
rapsebf3:SetAutoFocus(false)
rapsebf3:SetHeight(20)
rapsebf3:SetWidth(120)
rapsebf3:SetPoint("TOPLEFT", 617, -324)
rapsebf3:Show()
rapsebf3:SetScript("OnTextChanged", function(self) if string.len(rapsebf3:GetText())>0 then rallradiobtn31:SetChecked(true) rallradiobtn32:SetChecked(false) else rallradiobtn31:SetChecked(false) rallradiobtn32:SetChecked(true) end end )
rapsebf3:SetScript("OnEnterPressed", function(self) rapsebf3:ClearFocus() end )
rapsebf3:SetScript("OnEditFocusLost", function(self) if string.len(rapsebf3:GetText())==0 then rallradiobtn31:SetChecked(false) rallradiobtn32:SetChecked(true) end end)


rallradiobtn31 = CreateFrame("CheckButton", nil, zzralistach3, "SendMailRadioButtonTemplate")
rallradiobtn31:SetWidth("20")
rallradiobtn31:SetHeight("20")
rallradiobtn31:SetPoint("TOPLEFT", 593, -325)
rallradiobtn31:SetScript("OnClick", function(self) if string.len(rapsebf3:GetText())>0 then rallradiobtn32:SetChecked(false) rallradiobtn31:SetChecked(true) else rallradiobtn31:SetChecked(true) rallradiobtn32:SetChecked(false) rapsebf3:SetFocus(true) end end )

rallradiobtn32 = CreateFrame("CheckButton", nil, zzralistach3, "SendMailRadioButtonTemplate")
rallradiobtn32:SetWidth("20")
rallradiobtn32:SetHeight("20")
rallradiobtn32:SetPoint("TOPLEFT", 593, -355)
rallradiobtn32:SetScript("OnClick", function(self) rallradiobtn31:SetChecked(false) rallradiobtn32:SetChecked(true) rapsebf3:SetText("") rapsebf3:ClearFocus() end )

local ttm={{640,450},{-308,-115},{rallwhisper,ralltactictext1}}
for tter=1,2 do
local t2 = zzralistach3:CreateFontString()
t2:SetFont(GameFontNormal:GetFont(), 14)
t2:SetText(ttm[3][tter])
t2:SetJustifyH("LEFT")
t2:SetJustifyV("TOP")
t2:SetPoint("TOPLEFT",ttm[1][tter],ttm[2][tter])
t2:SetWidth(300)
t2:SetHeight(25)
end

--вывод в едит бокс
rallinfscroll = CreateFrame("ScrollFrame", "rallinfscroll", zzralistach3, "UIPanelScrollFrameTemplate")
rallinfscroll:SetPoint("TOPLEFT", zzralistach3, "TOPLEFT", 20, -202)
rallinfscroll:SetHeight(285)
rallinfscroll:SetWidth(500)

rallinfframe = CreateFrame("EditBox", "rallinfframe", rallinfscroll)
rallinfframe:SetPoint("TOPRIGHT", rallinfscroll, "TOPRIGHT", 0, 0)
rallinfframe:SetPoint("TOPLEFT", rallinfscroll, "TOPLEFT", 0, 0)
rallinfframe:SetPoint("BOTTOMRIGHT", rallinfscroll, "BOTTOMRIGHT", 0, 0)
rallinfframe:SetPoint("BOTTOMLEFT", rallinfscroll, "BOTTOMLEFT", 0, 0)
rallinfframe:SetScript("onescapepressed", function(self) rallinfframe:ClearFocus() end)
rallinfframe:SetScript("OnEditFocusGained", function(self) if rallinfframe:GetText()==ralluilooktactic3 then rallinfframe:SetText("") end end)
rallinfframe:SetScript("OnEditFocusLost", function(self)
rallinfframe:SetFont(GameFontNormal:GetFont(), 12)


if zzralistach3_Button1:IsShown() then

if string.len(rallinfframe:GetText())<6 then
rallinfframe:SetText(ralluilooktactic3)
else
local length=string.len(rallinfframe:GetText())
local mtxt=rallinfframe:GetText()

if string.find(mtxt, "%\n") or string.find(mtxt, " ") then
while (string.find(mtxt, "%\n") or string.find(mtxt, " ")) do
	local first=0
	local first2=2
	if string.find(mtxt, "%\n") then
		first=string.find(mtxt, "%\n")
	end
	if first==0 or (string.find(mtxt, " ") and string.find(mtxt, " ")<first) then
		first=string.find(mtxt, " ")
		first2=1
	end
	mtxt=string.sub(mtxt,first+1)
	length=length-first2
end
end

if length<6 then
rallinfframe:SetText(ralluilooktactic3)
end
end

else
rallinfframe:SetText("")
end

end)





rallinfframe:SetFont(GameFontNormal:GetFont(), 12)
rallinfframe:SetMultiLine(true)
rallinfframe:SetAutoFocus(false)
rallinfframe:SetHeight(470)
rallinfframe:SetWidth(490)
rallinfframe:Show()

rallinfscroll:SetScrollChild(rallinfframe)
rallinfscroll:Show()


rallzoneandachname = CreateFrame("ScrollingMessageFrame", "psllinfframetac", zzralistach3)

rallzoneandachname:SetPoint("TOPLEFT",255,-144)
rallzoneandachname:SetFont(GameFontNormal:GetFont(), 12)
rallzoneandachname:SetMaxLines(1)
rallzoneandachname:SetHyperlinksEnabled(true)
rallzoneandachname:SetScript("OnHyperlinkClick", function(self,link,text,button) SetItemRef(link,text,button) end)
rallzoneandachname:SetHeight(35)
rallzoneandachname:SetWidth(460)
rallzoneandachname:Show()
rallzoneandachname:SetFading(false)
rallzoneandachname:SetJustifyH("LEFT")
rallzoneandachname:SetJustifyV("TOP")



psllcheckbuttontablem31={}
local txttable={ralltxt2,ralltxt3}
for i=1,2 do
local c = CreateFrame("CheckButton", nil, zzralistach3, "SendMailRadioButtonTemplate")
c:SetWidth("16")
c:SetHeight("16")
c:SetPoint("TOPLEFT", 22, -105-i*15)
c:SetScript("OnClick", function(self) icllgalkaradiom3(i) end )
table.insert(psllcheckbuttontablem31, c)


--txt
local t = zzralistach3:CreateFontString()
t:SetFont(GameFontNormal:GetFont(), 11)
t:SetText(txttable[i])
t:SetJustifyH("LEFT")
t:SetPoint("TOPLEFT",42, -101-i*15)
t:SetHeight(23)



end

--rallmanualch31=1
--rallmanualch32=1
--rallmanualch33=1
rallmanualch34=1

openmenull3()


icllsetgalkim3()

end

openmenullch34()
end



function icllsetgalki()
if ralloptions[2]+ralloptions[3]+ralloptions[4]+ralloptions[5]+ralloptions[6]~=1 then
ralloptions[2]=1
for i=3,6 do
ralloptions[i]=0
end
end
if ralloptions[8]+ralloptions[9]+ralloptions[10]+ralloptions[11]+ralloptions[12]~=1 then
ralloptions[8]=1
for i=9,12 do
ralloptions[i]=0
end
end
for i=1,12 do
	if ralloptions[i]==nil then ralloptions[i]=0 end
	if ralloptions[i]==1 then
		psllcheckbuttontable[i]:SetChecked(true)
	else
		psllcheckbuttontable[i]:SetChecked(false)
	end
	if i==1 then
		if ralloptions[i]==1 then
			psllcheckbuttontable2[i]:SetText("|cff00ff00"..ralltxton.."|r "..ralltxt1)
		else
			psllcheckbuttontable2[i]:SetText("|cffff0000"..ralltxtoff.."|r "..ralltxt1)
		end
	end
	if i==7 then
		if ralloptions[i]==1 then
			psllcheckbuttontable2[i]:SetText("|cff00ff00"..ralltxton.."|r "..ralltxt7)
		else
			psllcheckbuttontable2[i]:SetText("|cffff0000"..ralltxtoff.."|r "..ralltxt7)
		end
	end
end
if ralloptionTrackCharAchieves then
	ralloptionTrackCharAchievesCB:SetChecked(true)
else
	ralloptionTrackCharAchievesCB:SetChecked(false)
end
end

function icllsetgalkim2()
if ralloptionsmanual[1]+ralloptionsmanual[2]+ralloptionsmanual[3]+ralloptionsmanual[4]+ralloptionsmanual[5]+ralloptionsmanual[6]~=1 then
ralloptionsmanual[1]=1
for i=2,6 do
ralloptionsmanual[i]=0
end
end

for i=1,6 do
	if ralloptionsmanual[i]==nil then ralloptionsmanual[i]=0 end
	if ralloptionsmanual[i]==1 then
		psllcheckbuttontablem1[i]:SetChecked(true)
	else
		psllcheckbuttontablem1[i]:SetChecked(false)
	end
end
end

function icllsetgalkim3()

for i=1,2 do
	if ralloptionsmanual3[i]==nil then ralloptionsmanual3[i]=0 end
	if ralloptionsmanual3[i]==1 then
		psllcheckbuttontablem31[i]:SetChecked(true)
	else
		psllcheckbuttontablem31[i]:SetChecked(false)
	end
end
end

function icllgalka(i)
if ralloptions[i]==1 then ralloptions[i]=0 else ralloptions[i]=1 end
	if i==1 then
		if ralloptions[i]==1 then
			psllcheckbuttontable2[i]:SetText("|cff00ff00"..ralltxton.."|r "..ralltxt1)
		else
			psllcheckbuttontable2[i]:SetText("|cffff0000"..ralltxtoff.."|r "..ralltxt1)
		end
	icllcheckachieves()
	end
	if i==7 then
		if ralloptions[i]==1 then
			RaidAchievement_reminder:RegisterEvent("PLAYER_TARGET_CHANGED")
			if rallbosstooltip then
				RaidAchievement_reminder:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			end
			psllcheckbuttontable2[i]:SetText("|cff00ff00"..ralltxton.."|r "..ralltxt7)
		else
			psllcheckbuttontable2[i]:SetText("|cffff0000"..ralltxtoff.."|r "..ralltxt7)
			RaidAchievement_reminder:UnregisterEvent("PLAYER_TARGET_CHANGED")
			RaidAchievement_reminder:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end
	end
end

function icllgalkatt(i)
if i==1 then
if rallbosstooltip then
	rallbosstooltip=false
	RaidAchievement_reminder:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
else
	rallbosstooltip=true
	if ralloptions[7]==1 then
		RaidAchievement_reminder:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end
end

if i==2 then
if rallbosschaton then
	rallbosschaton=false
else
	rallbosschaton=true
end
end

local ttyt=""
if rallbosschaton then
ttyt="|cff00ff00"..rallchatshowboss.."|r"
else
ttyt="|cffff0000"..rallchatshowboss.."|r"
end

if rallbosstooltip then
ttyt=ttyt.." / |cff00ff00"..ralltooltiptxt.."|r"
else
ttyt=ttyt.." / |cffff0000"..ralltooltiptxt.."|r"
end
rallbosstooltiptxt:SetText(ttyt)
end


function icllgalkaradio(i)
if i>1 and i<7 then
for p=2,6 do
	if p==i then
		ralloptions[p]=1
	else
		ralloptions[p]=0
	end
end
icllcheckachieves()
end

if i>7 and i<13 then
for p=8,12 do
	if p==i then
		ralloptions[p]=1
	else
		ralloptions[p]=0
	end
end
table.wipe(rallnomorereport[3])
table.wipe(rallnomorereport[4])
rallnomorereport[3]={0}
rallnomorereport[4]={0}
table.wipe(ralltooltipready[1])
table.wipe(ralltooltipready[2])
table.wipe(ralltooltipready[3])
ralltooltipready={{0},{0},{{0}}}
rallbosscheck(1)
end

icllsetgalki()
end

function icllgalkaradiom2(i)
for p=1,6 do
	if p==i then
		ralloptionsmanual[p]=1
	else
		ralloptionsmanual[p]=0
	end
end

icllsetgalkim2()
icllcheckachievesm2()
end

function icllgalkaradiom3(i)
for p=1,2 do
	if p==i then
		ralloptionsmanual3[p]=1
	else
		ralloptionsmanual3[p]=0
	end
end

icllsetgalkim3()
openmenullch34()
end


function icllcheckachieves(reportself,channel,nickforwhisp)
if ralloptions[1]==1 then


local a1, a2, a3, a4, a5 = GetInstanceInfo()
--SetMapToCurrentZone()
if a2=="pvp" or a2=="raid" or a2=="scenario" or a3==14 or a3==15 or a3==16 or (a2=="party" and (a3==2 or a3==23)) or select(3,GetInstanceInfo())==2 or (select(3,GetInstanceInfo())==1 and a2=="scenario") then


--проверка по имени локации, если имя встречается дважды - проверяется цифра на сколько чел расчитано и с той колонкой работаем

local found=0
local _, instanceType, pppl, _, maxPlayers, dif = GetInstanceInfo()
if select(3,GetInstanceInfo())==17 then
--no LFR
else
local curZoneID=C_Map.GetBestMapForUnit("player")
for kj=1,#ralllocations do
	if checkzoneIdA(ralllocations[kj],curZoneID) then
		found=found+1
		rallcolonka=kj
	end
end
end--lfr


if found==0 then
	if psllinfframe then
		psllinfframe:Clear()
		psllinfframe:AddMessage(rallzonenotfound)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
				psllinfframe:SetHeight(40)
			end
	end
else
local curZoneID=C_Map.GetBestMapForUnit("player")
if found>1 then
	rallcolonka=0
	for bv=1,#ralllocations do
		if checkzoneIdA(ralllocations[bv],curZoneID) then
			if ralltip[bv]=="10" or ralltip[bv]=="25" then
			if tonumber(ralltip[bv])==a5 then
				rallcolonka=bv
			end
			else
					rallcolonka=bv
			end
		end
	end
end

if rallcolonka>0 then

--тут уже идут проверки на настройки и вывод инфо
local texttableout={}
local texttableout2={}
local reportqu=0

if ralloptions[2]==1 then
	for i=1,#rallachieve[rallcolonka] do
	if rallachieve[rallcolonka][i]>0 and GetAchievementLink(rallachieve[rallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
		if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[rallcolonka][i]==0 then
			if #texttableout==0 then
				local cur_zone=C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name
				if cur_zone==nil then
					cur_zone="Unknown zone"
				end
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl1.." '"..cur_zone.."':")
				table.insert(texttableout2,rallachiverepl1.." '"..cur_zone.."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[rallcolonka][i]))

			--критерия
			if GetAchievementNumCriteria(rallachieve[rallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

			reportqu=reportqu+1
			if rallmeta[rallcolonka][i]==1 and ralltip[rallcolonka]~=ramainbattleground then
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallglory..")|r"
			end
			if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnoaddontrack..")|r"
			end
			if rallboss[rallcolonka][i][1]==0 and ralltip[rallcolonka]~=ramainbattleground and rallcontent[rallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
			if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..ralltactictext3..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe then
	psllinfframe:Clear()
	psllinfframe:AddMessage(rallachiverepl2)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
	psllinfframe:SetHeight(40)
			end
end
end



elseif ralloptions[3]==1 then



	for i=1,#rallachieve[rallcolonka] do
	if GetAchievementLink(rallachieve[rallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])

		if rallfullver[rallcolonka][i]==0 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl4.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
				table.insert(texttableout2,rallachiverepl4.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[rallcolonka][i]))
			

			reportqu=reportqu+1
			if (completed and ralloptionTrackCharAchieves==false) or (completed and ralloptionTrackCharAchieves and wasEarnedByMe) then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel1..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallachdonel1..")|r"
			else
			
          --критерия
          if GetAchievementNumCriteria(rallachieve[rallcolonka][i])>1 then
          local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],1)
          local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],2)
          if b1 and b4 and b5 and c1==nil then
            texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
            texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
          end
          end

					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel2..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallachdonel2..")|r"
			end
			if rallmeta[rallcolonka][i]==1 and ralltip[rallcolonka]~=ramainbattleground then
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallglory..")|r"
			end
			if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnoaddontrack..")|r"
			end
			if rallboss[rallcolonka][i][1]==0 and ralltip[rallcolonka]~=ramainbattleground and rallcontent[rallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
			if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..ralltactictext3..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe then
	psllinfframe:Clear()
	psllinfframe:AddMessage(rallachiverepl5)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
	psllinfframe:SetHeight(40)
			end
end
end



elseif ralloptions[4]==1 then
	for i=1,#rallachieve[rallcolonka] do
	if GetAchievementLink(rallachieve[rallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
		if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[rallcolonka][i]==0 and rallmeta[rallcolonka][i]==1 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl8.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
				table.insert(texttableout2,rallachiverepl8.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[rallcolonka][i]))
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[rallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

			reportqu=reportqu+1
			if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnoaddontrack..")|r"
			end
			if rallboss[rallcolonka][i][1]==0 and ralltip[rallcolonka]~=ramainbattleground and rallcontent[rallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
			if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..ralltactictext3..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe then
	psllinfframe:Clear()
	psllinfframe:AddMessage(rallachiverepl9)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
	psllinfframe:SetHeight(40)
			end
end
end




elseif ralloptions[5]==1 then



	for i=1,#rallachieve[rallcolonka] do
	if GetAchievementLink(rallachieve[rallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
		if rallfullver[rallcolonka][i]==0 and rallmeta[rallcolonka][i]==1 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl10.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
				table.insert(texttableout2,rallachiverepl10.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[rallcolonka][i]))
			

			reportqu=reportqu+1
			if (completed and ralloptionTrackCharAchieves==false) or (completed and ralloptionTrackCharAchieves and wasEarnedByMe) then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel1..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallachdonel1..")|r"
			else
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[rallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel2..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallachdonel2..")|r"
			end

			if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnoaddontrack..")|r"
			end
			if rallboss[rallcolonka][i][1]==0 and ralltip[rallcolonka]~=ramainbattleground and rallcontent[rallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
			if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..ralltactictext3..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe then
	psllinfframe:Clear()
	psllinfframe:AddMessage(rallachiverepl11)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
	psllinfframe:SetHeight(40)
			end
end
end



elseif ralloptions[6]==1 then
	for i=1,#rallachieve[rallcolonka] do
	if GetAchievementLink(rallachieve[rallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
		if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl12.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
				table.insert(texttableout2,rallachiverepl12.." '"..C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name.."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[rallcolonka][i]))
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[rallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[rallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

			reportqu=reportqu+1
			if rallmeta[rallcolonka][i]==1 and ralltip[rallcolonka]~=ramainbattleground then
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallglory..")|r"
			end
			if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnoaddontrack..")|r"
			end
			if rallboss[rallcolonka][i][1]==0 and ralltip[rallcolonka]~=ramainbattleground and rallcontent[rallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
			if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..ralltactictext3..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe then
	psllinfframe:Clear()
	psllinfframe:AddMessage(rallachiverepl2)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
	psllinfframe:SetHeight(40)
			end
end
end






end





--вывод репорта
if #texttableout>0 then
if psllinfframe then
	psllinfframe:Clear()
	for i=1,#texttableout2 do
		psllinfframe:AddMessage(texttableout2[i])
	end
	if psllinfframe:GetHeight()>(#texttableout*12.4+10) and psllinfframe:GetHeight()<(#texttableout*12.4+30) then
	else
		psllinfframe:SetHeight(#texttableout*12.4+20) --ыытест
	end
end

--текст
if channel and channel~="sebe" then
rallreportinchat(texttableout,channel,nickforwhisp)
elseif reportself or channel=="sebe" then
	if (reportself and reportqu<12) or channel=="sebe" then
    for i=1,#texttableout do
      if i==1 then
        print("|cff99ffffAchievementsReminder|r - "..texttableout2[i])
      else
        print(texttableout2[i])
      end
    end
	else
		print("|cff99ffffAchievementsReminder|r - "..format(rallachiverepl7,reportqu))
	end
end








end


end

end


else
	if psllinfframe then
		psllinfframe:Clear()
		psllinfframe:AddMessage(rallachiverepl3)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
		psllinfframe:SetHeight(40)
			end
	end
end

else
	if psllinfframe then
		psllinfframe:Clear()
		psllinfframe:AddMessage(rallachiverepl6)
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
		psllinfframe:SetHeight(40)
			end
	end
rallcolonka=0
end
end


function rallreportinchat(texttableout,chat,whisp)

if chat and (chat=="party" or chat=="raid" or chat=="raid_warning") and (select(3,GetInstanceInfo())==17 or IsLFGModeActive(LE_LFG_CATEGORY_LFD)) then
chat="Instance_CHAT"
end

for i=1,#texttableout do
if string.len(texttableout[i])>1 then

if chat=="sebe" then
DEFAULT_CHAT_FRAME:AddMessage(texttableout[i])
elseif chat=="whisper" then

local bna=GetAutoCompletePresenceID(whisp)

if bna then
BNSendWhisper(bna, texttableout[i])
else
SendChatMessage(texttableout[i], "WHISPER", nil, whisp)
end


else
local bililine=0
for i,cc in ipairs(rabigmenuchatlisten) do 
if cc == chat then bililine=1
end end
if chat=="Instance_CHAT" then
bililine=1
end

	if bililine==1 then

		SendChatMessage(texttableout[i], chat)
	else


local nrchatmy=GetChannelName(chat)
		if nrchatmy==0 then
	JoinPermanentChannel(chat)
	ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chat)
	nrchatmy=GetChannelName(chat)
		end
if nrchatmy>0 then
SendChatMessage(texttableout[i], "CHANNEL",nil,nrchatmy)
end

	end
end


end
end
end


function openmenull()
if not DropDownMenureportll then
CreateFrame("Frame", "DropDownMenureportll", zzralistach, "UIDropDownMenuTemplate")
end
DropDownMenureportll:ClearAllPoints()
DropDownMenureportll:SetPoint("TOPLEFT", 595, -351)
DropDownMenureportll:Show()
local items = bigmenuchatlistea
local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenureportll, self:GetID())

arbigmenuchatea(self:GetID())
wherereportll=wherereporttempbigma
end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

if wherereportll==nil then wherereportll="raid" end

arbigmenuchatea2(wherereportll)

if bigma2num==0 then
bigma2num=1
wherereportll="raid"
end

UIDropDownMenu_Initialize(DropDownMenureportll, initialize)
UIDropDownMenu_SetWidth(DropDownMenureportll, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenureportll, 125)
UIDropDownMenu_SetSelectedID(DropDownMenureportll,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenureportll, "LEFT")
end

function openmenull2()
if not DropDownMenureportll2 then
CreateFrame("Frame", "DropDownMenureportll2", zzralistach2, "UIDropDownMenuTemplate")
end
DropDownMenureportll2:ClearAllPoints()
DropDownMenureportll2:SetPoint("TOPLEFT", 595, -351)
DropDownMenureportll2:Show()
local items = bigmenuchatlistea
local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenureportll2, self:GetID())

arbigmenuchatea(self:GetID())
wherereportll3=wherereporttempbigma
end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

if wherereportll3==nil then wherereportll3="raid" end

arbigmenuchatea2(wherereportll3)

if bigma2num==0 then
bigma2num=1
wherereportll3="raid"
end

UIDropDownMenu_Initialize(DropDownMenureportll2, initialize)
UIDropDownMenu_SetWidth(DropDownMenureportll2, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenureportll2, 125)
UIDropDownMenu_SetSelectedID(DropDownMenureportll2,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenureportll2, "LEFT")
end

function openmenull3()
if not DropDownMenureportll3 then
CreateFrame("Frame", "DropDownMenureportll3", zzralistach3, "UIDropDownMenuTemplate")
end
DropDownMenureportll3:ClearAllPoints()
DropDownMenureportll3:SetPoint("TOPLEFT", 595, -351)
DropDownMenureportll3:Show()
local items = bigmenuchatlistea
local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenureportll3, self:GetID())

arbigmenuchatea(self:GetID())
wherereportll33=wherereporttempbigma
end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

if wherereportll33==nil then wherereportll33="raid" end

arbigmenuchatea2(wherereportll33)

if bigma2num==0 then
bigma2num=1
wherereportll33="raid"
end

UIDropDownMenu_Initialize(DropDownMenureportll3, initialize)
UIDropDownMenu_SetWidth(DropDownMenureportll3, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenureportll3, 125)
UIDropDownMenu_SetSelectedID(DropDownMenureportll3,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenureportll3, "LEFT")
end

function rallwhispbutfun()
if string.len(rapsebf1:GetText())>0 then
icllcheckachieves(nil,"whisper",rapsebf1:GetText())
else
icllcheckachieves(nil,wherereportll)
end
end

function rallwhispbutfun2()
if string.len(rapsebf2:GetText())>0 then
icllcheckachievesm2("whisper",rapsebf2:GetText())
else
icllcheckachievesm2(wherereportll3)
end
end


function rallbosscheck(showme)
if rallcolonka>0 and ralloptions[7]==1 then
if UnitGUID("target") then
local guui=UnitGUID("target")
if guui then
local a1=3 --tonumber(string.sub(guui,5,5)) deleted guid changed in wow
if a1==3 or a1==5 then
local a2=arGetUnitID(guui)

local bil=0
for i=1,#rallboss[rallcolonka] do
	for j=1,#rallboss[rallcolonka][i] do
		if rallboss[rallcolonka][i][j]==a2 then
			bil=1
		end
	end
end
if bil==1 then
local _, _, _, _, ai5 = GetInstanceInfo()
for k=1,#rallnomorereport[3] do
	if rallnomorereport[3][k]==a2 and ai5==rallnomorereport[4][k] and showme==nil then
		bil=0
	end
end
if bil==1 then

local tocpvp={34461,34460,34465,34466,34467,34468,34469,34471,34472,34473,34463,34470,34474,34475}
if UnitFactionGroup("player")=="Alliance" then
tocpvp={34458,34451,34459,34448,34449,34445,34456,34447,34441,34454,34455,34444,34450,34453}
end

--ыытест босс двойной
local bossdabl={{37970,37972,37973},{34496,34497},{32857,32927,32867},{16064,16065,30549,16063},{15929,15930},{32915,32913,32914},{31125,33993,35013},tocpvp,{47296,47297},{33350,33432},{28684,28730,28729,28731},{42178,42166,42179,42180},{45992,45993},{43735,43686,43687,43688,43689},{45871,45870,45872},{52577,53087,52558}}

local fff=0

for g=1,#bossdabl do
	for t=1,#bossdabl[g] do
		if bossdabl[g][t]==a2 then
			fff=g
		end
	end
end

if fff>0 then
	for d=1,#bossdabl[fff] do
		table.insert(rallnomorereport[3],bossdabl[fff][d])
		table.insert(rallnomorereport[4],ai5)
	end
else
table.insert(rallnomorereport[3],a2)
table.insert(rallnomorereport[4],ai5)
end


rallreportbossachfound(a2,UnitName("target"),showme)
else
local vbil=0
for fd=1,#ralltooltipready[1] do
	if ralltooltipready[1][fd]==a2 then
		vbil=1
	end
end
if vbil==0 then
rallreportbossachfound(a2,UnitName("target"),showme,1)
end



end
end
end
end
end
end
end


function rallreportbossachfound(id,nick,showme,onlytooltip)

local texttableout={}
local achlist={}

if ralloptions[8]==1 then
	for i=1,#rallboss[rallcolonka] do
		for j=1,#rallboss[rallcolonka][i] do
			if rallboss[rallcolonka][i][j]==id then
				local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
				if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[rallcolonka][i]==0 then
					if #texttableout==0 then
						table.insert(texttableout,"|cff99ffffAchievementsReminder|r - "..rallachiverepl13.." '"..nick.."':")
					end
					table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
          if rallmeta[rallcolonka][i]==1 and ralltip[rallcolonka]~=ramainbattleground then
            texttableout[#texttableout]=texttableout[#texttableout].." |cff00ff00("..rallglory..")|r"
          end
					if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallnoaddontrack..")|r"
					end
					if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
						texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..ralltactictext3..")|r"
					end
					table.insert(achlist,rallachieve[rallcolonka][i])
				end
			end
		end
	end


elseif ralloptions[9]==1 then
	for i=1,#rallboss[rallcolonka] do
		for j=1,#rallboss[rallcolonka][i] do
			if rallboss[rallcolonka][i][j]==id then
				local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
				if rallfullver[rallcolonka][i]==0 then
					if #texttableout==0 then
						table.insert(texttableout,"|cff99ffffAchievementsReminder|r - "..rallachiverepl14.." '"..nick.."':")
					end
					table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
					if (completed and ralloptionTrackCharAchieves==false) or (completed and ralloptionTrackCharAchieves and wasEarnedByMe) then
							texttableout[#texttableout]=texttableout[#texttableout].." |cff00ff00("..rallachdonel1..")|r"
					else
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallachdonel2..")|r"
					end
          if rallmeta[rallcolonka][i]==1 and ralltip[rallcolonka]~=ramainbattleground then
            texttableout[#texttableout]=texttableout[#texttableout].." |cff00ff00("..rallglory..")|r"
          end
					if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallnoaddontrack..")|r"
					end
					if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
						texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..ralltactictext3..")|r"
					end
					table.insert(achlist,rallachieve[rallcolonka][i])
				end
			end
		end
	end

elseif ralloptions[10]==1 then
	for i=1,#rallboss[rallcolonka] do
		for j=1,#rallboss[rallcolonka][i] do
			if rallboss[rallcolonka][i][j]==id then
				local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
				if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[rallcolonka][i]==0 and rallmeta[rallcolonka][i]==1 then
					if #texttableout==0 then
						table.insert(texttableout,"|cff99ffffAchievementsReminder|r - "..rallachiverepl16.." '"..nick.."':")
					end
					table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
					if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallnoaddontrack..")|r"
					end
					if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
						texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..ralltactictext3..")|r"
					end
					table.insert(achlist,rallachieve[rallcolonka][i])
				end
			end
		end
	end


elseif ralloptions[11]==1 then
	for i=1,#rallboss[rallcolonka] do
		for j=1,#rallboss[rallcolonka][i] do
			if rallboss[rallcolonka][i][j]==id then
				local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
				if rallfullver[rallcolonka][i]==0 and rallmeta[rallcolonka][i]==1 then
					if #texttableout==0 then
						table.insert(texttableout,"|cff99ffffAchievementsReminder|r - "..rallachiverepl17.." '"..nick.."':")
					end
					table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
					if completed then
							texttableout[#texttableout]=texttableout[#texttableout].." |cff00ff00("..rallachdonel1..")|r"
					else
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallachdonel2..")|r"
					end
					if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallnoaddontrack..")|r"
					end
					if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
						texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..ralltactictext3..")|r"
					end
					table.insert(achlist,rallachieve[rallcolonka][i])
				end
			end
		end
	end

elseif ralloptions[12]==1 then
	for i=1,#rallboss[rallcolonka] do
		for j=1,#rallboss[rallcolonka][i] do
			if rallboss[rallcolonka][i][j]==id then
				local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[rallcolonka][i])
				if completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false) then
					if #texttableout==0 then
						table.insert(texttableout,"|cff99ffffAchievementsReminder|r - "..rallachiverepl18.." '"..nick.."':")
					end
					table.insert(texttableout,GetAchievementLink(rallachieve[rallcolonka][i]))
          if rallmeta[rallcolonka][i]==1 and ralltip[rallcolonka]~=ramainbattleground then
            texttableout[#texttableout]=texttableout[#texttableout].." |cff00ff00("..rallglory..")|r"
          end
					if ralltrack[rallcolonka][i]==0 and ralltip[rallcolonka]~=ramainbattleground then
							texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..rallnoaddontrack..")|r"
					end
					if ralltip[rallcolonka]~=ramainbattleground and ralltactics[rallcolonka][i]~=0 and ralltacticsdif[rallcolonka][i]==1 then
						texttableout[#texttableout]=texttableout[#texttableout].." |cffff0000("..ralltactictext3..")|r"
					end
					table.insert(achlist,rallachieve[rallcolonka][i])
				end
			end
		end
	end

end

--вывод
if onlytooltip==nil then
if #texttableout>0 then
	if rallbosschaton then
	for i=1,#texttableout do
		print(texttableout[i])
	end
	end
elseif showme and rallbosschaton then
print ("|cff99ffffAchievementsReminder|r - "..rallachiverepl15)
end
end

--сохранение ачивок
if #achlist>0 then

table.insert(ralltooltipready[1],id)
local _, _, _, _, ai5 = GetInstanceInfo()
table.insert(ralltooltipready[2],ai5)
table.insert(ralltooltipready[3],achlist)


if rallbosstooltip then
ralltooltipchangenow()
end
end


end









function icllcheckachievesm2(channel,nickforwhisp)

local locrallcolonka=0

local insid=0
for ty=1,#ralllocationnames do
	if ralllocationnames[ty]==ralltableofinstancebyname[rallmanualch3] then
		insid=ralllocations[ty]
	end
end



local found=0
for kj=1,#ralllocations do
	if checkzoneIdA(ralllocations[kj],insid) then
		found=found+1
		locrallcolonka=kj
	end
end
if found==0 then
	if psllinfframe then
		psllinfframe:Clear()
		psllinfframe:AddMessage("error")
			if psllinfframe:GetHeight()>39 and psllinfframe:GetHeight()<41 then
			else
		psllinfframe:SetHeight(40)
			end
	end
else

if found>1 then
	locrallcolonka=0
	for bv=1,#ralllocations do
		if checkzoneIdA(ralllocations[bv],insid) then
			if ralltip[bv]=="10" or ralltip[bv]=="25" then
			if ralltip[bv]==ralltableofinstancebyq[rallmanualch2] then
				locrallcolonka=bv
			end
			else
					locrallcolonka=bv
			end
		end
	end
end

if locrallcolonka>0 then

--тут уже идут проверки на настройки и вывод инфо
local texttableout={}
local texttableout2={}


--проверка что ачивка существует
if rallachieve[locrallcolonka][1] and GetAchievementLink(rallachieve[locrallcolonka][1]) then

if ralloptionsmanual[1]==1 then
	for i=1,#rallachieve[locrallcolonka] do
	if GetAchievementLink(rallachieve[locrallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[locrallcolonka][i])
		if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[locrallcolonka][i]==0 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl1.." '"..ralltableofinstancebyname[rallmanualch3].."':")
				table.insert(texttableout2,rallachiverepl1.." '"..ralltableofinstancebyname[rallmanualch3].."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[locrallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[locrallcolonka][i]))
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[locrallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

			if rallboss[locrallcolonka][i][1]==0 and ralltip[locrallcolonka]~=ramainbattleground and rallcontent[locrallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	psllinfframe2:AddMessage(rallachiverepl2)
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end
end



elseif ralloptionsmanual[2]==1 then


	for i=1,#rallachieve[locrallcolonka] do
	if GetAchievementLink(rallachieve[locrallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[locrallcolonka][i])

		if rallfullver[locrallcolonka][i]==0 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl4.." '"..ralltableofinstancebyname[rallmanualch3].."':")
				table.insert(texttableout2,rallachiverepl4.." '"..ralltableofinstancebyname[rallmanualch3].."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[locrallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[locrallcolonka][i]))
			
			if (completed and ralloptionTrackCharAchieves==false) or (completed and ralloptionTrackCharAchieves and wasEarnedByMe) then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel1..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallachdonel1..")|r"
			else
			
          --критерия
          if GetAchievementNumCriteria(rallachieve[locrallcolonka][i])>1 then
          local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],1)
          local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],2)
          if b1 and b4 and b5 and c1==nil then
            texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
            texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
          end
          end
      
      
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel2..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallachdonel2..")|r"
			end

			if rallboss[locrallcolonka][i][1]==0 and ralltip[locrallcolonka]~=ramainbattleground and rallcontent[locrallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	psllinfframe2:AddMessage(rallachiverepl5)
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end
end



elseif ralloptionsmanual[3]==1 then
	for i=1,#rallachieve[locrallcolonka] do
	if GetAchievementLink(rallachieve[locrallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[locrallcolonka][i])
		if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[locrallcolonka][i]==0 and rallmeta[locrallcolonka][i]==1 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl8.." '"..ralltableofinstancebyname[rallmanualch3].."':")
				table.insert(texttableout2,rallachiverepl8.." '"..ralltableofinstancebyname[rallmanualch3].."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[locrallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[locrallcolonka][i]))


			--критерия
			if GetAchievementNumCriteria(rallachieve[locrallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

			if rallboss[locrallcolonka][i][1]==0 and ralltip[locrallcolonka]~=ramainbattleground and rallcontent[locrallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	psllinfframe2:AddMessage(rallachiverepl9)
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end
end




elseif ralloptionsmanual[4]==1 then



	for i=1,#rallachieve[locrallcolonka] do
	if GetAchievementLink(rallachieve[locrallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[locrallcolonka][i])
		if rallfullver[locrallcolonka][i]==0 and rallmeta[locrallcolonka][i]==1 then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl10.." '"..ralltableofinstancebyname[rallmanualch3].."':")
				table.insert(texttableout2,rallachiverepl10.." '"..ralltableofinstancebyname[rallmanualch3].."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[locrallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[locrallcolonka][i]))


			if (completed and ralloptionTrackCharAchieves==false) or (completed and ralloptionTrackCharAchieves and wasEarnedByMe) then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel1..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallachdonel1..")|r"
			else
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[locrallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel2..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallachdonel2..")|r"
			end

			if rallboss[locrallcolonka][i][1]==0 and ralltip[locrallcolonka]~=ramainbattleground and rallcontent[locrallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	psllinfframe2:AddMessage(rallachiverepl11)
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end
end



elseif ralloptionsmanual[5]==1 then
	for i=1,#rallachieve[locrallcolonka] do
	if GetAchievementLink(rallachieve[locrallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[locrallcolonka][i])
		if completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false) then
			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl12.." '"..ralltableofinstancebyname[rallmanualch3].."':")
				table.insert(texttableout2,rallachiverepl12.." '"..ralltableofinstancebyname[rallmanualch3].."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[locrallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[locrallcolonka][i]))
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[locrallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

			if rallboss[locrallcolonka][i][1]==0 and ralltip[locrallcolonka]~=ramainbattleground and rallcontent[locrallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
		end
	end
	end

if #texttableout==0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	psllinfframe2:AddMessage(rallachiverepl2)
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end
end



elseif ralloptionsmanual[6]==1 then



	for i=1,#rallachieve[locrallcolonka] do
	if GetAchievementLink(rallachieve[locrallcolonka][i]) then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[locrallcolonka][i])

			if #texttableout==0 then
				table.insert(texttableout,"AchievementsReminder - "..rallachiverepl19.." '"..ralltableofinstancebyname[rallmanualch3].."':")
				table.insert(texttableout2,rallachiverepl19.." '"..ralltableofinstancebyname[rallmanualch3].."':")
			end
			table.insert(texttableout,GetAchievementLink(rallachieve[locrallcolonka][i]))
			table.insert(texttableout2,GetAchievementLink(rallachieve[locrallcolonka][i]))

			if (completed and ralloptionTrackCharAchieves==false) or (completed and ralloptionTrackCharAchieves and wasEarnedByMe) then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel1..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cff00ff00("..rallachdonel1..")|r"
			else
			
			--критерия
			if GetAchievementNumCriteria(rallachieve[locrallcolonka][i])>1 then
			local b1,_,_,b4,b5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],1)
			local c1,_,_,c4,c5=GetAchievementCriteriaInfo(rallachieve[locrallcolonka][i],2)
			if b1 and b4 and b5 and c1==nil then
        texttableout[#texttableout]=texttableout[#texttableout].." ("..b4.." / "..b5..")"
        texttableout2[#texttableout2]=texttableout2[#texttableout2].." ("..b4.." / "..b5..")"
      end
      end

					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallachdonel2..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallachdonel2..")|r"
			end

			if rallboss[locrallcolonka][i][1]==0 and ralltip[locrallcolonka]~=ramainbattleground and rallcontent[locrallcolonka]~=6 then
					texttableout[#texttableout]=texttableout[#texttableout].." ("..rallnotfromboss..")"
					texttableout2[#texttableout2]=texttableout2[#texttableout2].." |cffff0000("..rallnotfromboss..")|r"
			end
	end
	end

if #texttableout==0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	psllinfframe2:AddMessage(rallachiverepl5)
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end
end


end


else
	psllinfframe2:Clear()
	psllinfframe2:AddMessage("Error. Achievements were not found in Game Client.")
			if psllinfframe2:GetHeight()>39 and psllinfframe2:GetHeight()<41 then
			else
	psllinfframe2:SetHeight(40)
			end
end


--вывод репорта
if #texttableout>0 then
if psllinfframe2 then
	psllinfframe2:Clear()
	for i=1,#texttableout2 do
		psllinfframe2:AddMessage(texttableout2[i])
	end
	if psllinfframe2:GetHeight()>(#texttableout*12.4+10) and psllinfframe2:GetHeight()<(#texttableout*12.4+30) then
	else
		psllinfframe2:SetHeight(#texttableout*12.4+20) --ыытест
	end
end

--текст
if channel and channel~="sebe" then
rallreportinchat(texttableout,channel,nickforwhisp)
elseif channel=="sebe" then
	for i=1,#texttableout do
		if i==1 then
			print("|cff99ffffAchievementsReminder|r - "..texttableout2[i])
		else
			print(texttableout2[i])
		end
	end
end





end


end

end



end


--3 дропдаун меню

function openmenullch1()
if not DropDownMenullch1 then
CreateFrame("Frame", "DropDownMenullch1", zzralistach2, "UIDropDownMenuTemplate")
end
DropDownMenullch1:ClearAllPoints()
DropDownMenullch1:SetPoint("TOPLEFT", 20, -218)
DropDownMenullch1:Show()
local items = rallexpansions
local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenullch1, self:GetID())

rallmanualch1=self:GetID()
rallmanualch2=1
openmenullch2()
rallmanualch3=1
openmenullch3()

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end


UIDropDownMenu_Initialize(DropDownMenullch1, initialize)
UIDropDownMenu_SetWidth(DropDownMenullch1, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenullch1, 125)
UIDropDownMenu_SetSelectedID(DropDownMenullch1,rallmanualch1)
UIDropDownMenu_JustifyText(DropDownMenullch1, "LEFT")
end


function openmenullch2()
if not DropDownMenullch2 then
CreateFrame("Frame", "DropDownMenullch2", zzralistach2, "UIDropDownMenuTemplate")
end
DropDownMenullch2:ClearAllPoints()
DropDownMenullch2:SetPoint("TOPLEFT", 220, -218)
DropDownMenullch2:Show()


ralltableofinstancebyq={}
table.wipe(ralltableofinstancebyq)

  for i=1,#rallcontent do
    if rallcontent[i]==rallmanualch1 then
      local bil=0
      for a,cc in ipairs(ralltableofinstancebyq) do
        if cc==ralltip[i] then
          bil=1
        end
      end
      if bil==0 then
        table.insert(ralltableofinstancebyq,ralltip[i])
      end
    end
  end
table.sort(ralltableofinstancebyq)
if ralltableofinstancebyq[1] and ralltableofinstancebyq[1]=="10" and ralltableofinstancebyq[2] and ralltableofinstancebyq[2]=="25" and ralltableofinstancebyq[3] and ralltableofinstancebyq[3]=="5" then
	table.wipe(ralltableofinstancebyq)
	ralltableofinstancebyq={"5","10","25"}
end

local items = ralltableofinstancebyq
local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenullch2, self:GetID())

rallmanualch2=self:GetID()
rallmanualch3=1
openmenullch3()

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end


UIDropDownMenu_Initialize(DropDownMenullch2, initialize)
UIDropDownMenu_SetWidth(DropDownMenullch2, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenullch2, 125)
UIDropDownMenu_SetSelectedID(DropDownMenullch2,rallmanualch2)
UIDropDownMenu_JustifyText(DropDownMenullch2, "LEFT")
end


function openmenullch3()
if not DropDownMenullch3 then
CreateFrame("Frame", "DropDownMenullch3", zzralistach2, "UIDropDownMenuTemplate")
end
DropDownMenullch3:ClearAllPoints()
DropDownMenullch3:SetPoint("TOPLEFT", 420, -218)
DropDownMenullch3:Show()


ralltableofinstancebyname={}
table.wipe(ralltableofinstancebyname)

for i=1,#rallcontent do
  if rallcontent[i]==rallmanualch1 then
    local bil=0

    for a,cc in ipairs(ralltableofinstancebyname) do
      if cc==ralllocationnames[i] then
        bil=1
      end
    end

    if ralltip[i]~=ralltableofinstancebyq[rallmanualch2] then
      bil=1
    end
    if bil==0 then
      table.insert(ralltableofinstancebyname,ralllocationnames[i])
    end
  end
end
table.sort(ralltableofinstancebyname)


local items = ralltableofinstancebyname
local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenullch3, self:GetID())

rallmanualch3=self:GetID()



icllcheckachievesm2()
end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end
icllcheckachievesm2()

UIDropDownMenu_Initialize(DropDownMenullch3, initialize)
UIDropDownMenu_SetWidth(DropDownMenullch3, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenullch3, 125)
UIDropDownMenu_SetSelectedID(DropDownMenullch3,rallmanualch3)
UIDropDownMenu_JustifyText(DropDownMenullch3, "LEFT")
end


function ralltooltipchangenow()
if UnitAffectingCombat("player")==false then
local GTT = _G["GameTooltip"]
local a = select(2, GTT:GetUnit())
if a and (a=="mouseover" or a=="target") then

if UnitGUID(a) then
	local guui=UnitGUID(a)
	if guui then
		local a1=3 --tonumber(string.sub(guui,5,5))
		if a1==3 or a1==5 then
			local id=arGetUnitID(guui)
			local bil=0
			local _, _, _, _, ai5 = GetInstanceInfo()
			local i=1
			while i<=#ralltooltipready[1] do
				if ralltooltipready[1][i]==id and ralltooltipready[2][i]==ai5 then
					bil=i
					i=1000
				end
				i=i+1
			end

			if bil>0 then
				if #ralltooltipready[3][bil]>6 then
					GTT:AddLine(format(ralltooltiptxt2,#ralltooltipready[3][bil])..".") GTT:AddLine(ralltooltiptxt3) GTT:Show()
				else
					GTT:AddLine(ralltooltiptxt21..":")
					for gg=1,#ralltooltipready[3][bil] do
						local name = GetAchievementInfo(ralltooltipready[3][bil][gg])
						name=GetAchievementLink(ralltooltipready[3][bil][gg])
						GTT:AddLine(name)
					end
					GTT:Show()
				end
			end
		end
	end
end



end
end
end


function openmenullch34(bbb)
if not DropDownMenullch34 then
CreateFrame("Frame", "DropDownMenullch34", zzralistach3, "UIDropDownMenuTemplate")
end
DropDownMenullch34:ClearAllPoints()
DropDownMenullch34:SetPoint("TOPLEFT", 425, -130)
DropDownMenullch34:Show()

local listach={}
ralllistachid={}
table.wipe(ralllistachid)
ralltacticachopen=0
rallinfframe:ClearFocus()


if rallonlycurrzone then
ralltacticachopen=rallonlycurrzone
else
	for x=1,#ralllocationnames do
		if ralllocationnames[x]==ralltableofinstancebyname[rallmanualch3] and ralltip[x]==ralltableofinstancebyq[rallmanualch2] then
			ralltacticachopen=x
		end
	end
end

local istacticexist=0
local ourbosstargets={}
local tbil=0

if UnitGUID("target") then
	local iiid=arGetUnitID(UnitGUID("target"))
	if iiid~=0 then
		table.insert(ourbosstargets,iiid)
	end
end
for d=1,4 do
	if UnitGUID("party"..d.."-target") then
		local iiid=arGetUnitID(UnitGUID("party"..d.."-target"))
		if iiid~=0 then
			table.insert(ourbosstargets,iiid)
		end
	end
end


for bb=1,#rallachieve[ralltacticachopen] do
	if GetAchievementLink(rallachieve[ralltacticachopen][1]) then
	if ralloptionsmanual3[1]==1 then
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(rallachieve[ralltacticachopen][bb])
		if (completed==false or (completed and ralloptionTrackCharAchieves and wasEarnedByMe==false)) and rallfullver[ralltacticachopen][bb]==0 then
			local name=GetAchievementLink(rallachieve[ralltacticachopen][bb])
			if ralltactics[ralltacticachopen][bb] and ralltactics[ralltacticachopen][bb]~=0 and ralltacticsdif[ralltacticachopen][bb] and ralltacticsdif[ralltacticachopen][bb]==1 then
				name=name.." - "..ralltactictext2
				if istacticexist==0 then
					istacticexist=#listach+1
				end
			end
			if #ourbosstargets>0 then
				for sx=1,#rallboss[ralltacticachopen][bb] do
					for az=1,#ourbosstargets do
						if ourbosstargets[az]==rallboss[ralltacticachopen][bb][sx] then
							if tbil==0 then
								tbil=#listach+1
							end
						end
					end
				end
			end

			table.insert(listach,name)
			table.insert(ralllistachid,rallachieve[ralltacticachopen][bb])
		end
	elseif ralloptionsmanual3[2]==1 then
		if rallfullver[ralltacticachopen][bb]==0 then
			local name=GetAchievementLink(rallachieve[ralltacticachopen][bb])
			if ralltactics[ralltacticachopen][bb] and ralltactics[ralltacticachopen][bb]~=0 and ralltacticsdif[ralltacticachopen][bb] and ralltacticsdif[ralltacticachopen][bb]==1 then
				name=name.." - "..ralltactictext2
				if istacticexist==0 then
					istacticexist=#listach+1
				end
			end
			if #ourbosstargets>0 then
				for sx=1,#rallboss[ralltacticachopen][bb] do
					for az=1,#ourbosstargets do
						if ourbosstargets[az]==rallboss[ralltacticachopen][bb][sx] then
							if tbil==0 then
								tbil=#listach+1
							end
						end
					end
				end
			end
			table.insert(listach,name)
			table.insert(ralllistachid,rallachieve[ralltacticachopen][bb])
		end
	end
	end
end

		if bbb==nil then
if ralldontupdatemenu then
ralldontupdatemenu=nil
else
rallmanualch34=1
if tbil>0 then
	rallmanualch34=tbil
elseif istacticexist>0 then
	rallmanualch34=istacticexist
end

end
		elseif rallmanualch34 then
			if bbb==1 then
				if #listach>rallmanualch34 then
					rallmanualch34=rallmanualch34+1
				end
			elseif bbb==0 then
				if rallmanualch34>1 then
					rallmanualch34=rallmanualch34-1
				end
			end
		end

ralltacticrealid=1
for nm=1,#rallachieve[ralltacticachopen] do
	if rallachieve[ralltacticachopen][nm]==ralllistachid[rallmanualch34] then
		ralltacticrealid=nm
	end
end

zzralistach3_Button1:Show()
zzralistach3_Button2:Show()

if rallmanualch34>1 then
zzralistach3_ButtonP:Enable()
else
zzralistach3_ButtonP:Disable()
end
if #listach>rallmanualch34 then
zzralistach3_ButtonN:Enable()
else
zzralistach3_ButtonN:Disable()
end

rallinfframe:SetText("")
rallzoneandachname:Clear()
local aname="|cff00ff00"..ralllocationnames[ralltacticachopen].."|r"
if #listach==0 and ralloptionsmanual3[1]==1 then
listach={rallnotfoundachiv1}
rallzoneandachname:AddMessage(aname.." - "..rallnotfoundachiv1)
zzralistach3_Button1:Hide()
zzralistach3_Button2:Hide()
elseif #listach==0 and ralloptionsmanual3[2]==1 then
listach={rallnotfoundachiv2}
rallzoneandachname:AddMessage(aname.." - "..rallnotfoundachiv2)
zzralistach3_Button1:Hide()
zzralistach3_Button2:Hide()
else
rallzoneandachname:AddMessage(aname.." - "..GetAchievementLink(ralllistachid[rallmanualch34]))


--вывод тактики
if ralltactics[ralltacticachopen][ralltacticrealid]==0 then
	rallinfframe:SetText(ralluilooktactic3)
else
	rallinfframe:SetText(ralltactics[ralltacticachopen][ralltacticrealid])
end



end


local items = listach





local function OnClick(self)
rallinfframe:ClearFocus()

UIDropDownMenu_SetSelectedID(DropDownMenullch34, self:GetID())


if rallmanualch34~=self:GetID() then

rallmanualch34=self:GetID()
ralldontupdatemenu=1
openmenullch34()
end


end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end


UIDropDownMenu_Initialize(DropDownMenullch34, initialize)
UIDropDownMenu_SetWidth(DropDownMenullch34, 170)
UIDropDownMenu_SetButtonWidth(DropDownMenullch34, 185)
UIDropDownMenu_SetSelectedID(DropDownMenullch34,rallmanualch34)
UIDropDownMenu_JustifyText(DropDownMenullch34, "LEFT")
end


function rallsavetact()
rallinfframe:ClearFocus()

if string.len(rallinfframe:GetText())>5 then
	if rallinfframe:GetText()==ralluilooktactic3 then
		ralltactics[ralltacticachopen][ralltacticrealid]=0
	else
		ralltactics[ralltacticachopen][ralltacticrealid]=rallinfframe:GetText()
	end
else
ralltactics[ralltacticachopen][ralltacticrealid]=0
rallinfframe:SetText(ralluilooktactic3)
end
out("|cff99ffffAchievementsReminder|r - |cff00ff00"..ralluilooktactic4.."|r")
end


function rallsavetact2()
rallinfframe:ClearFocus()
if ralltacticsdef[ralltacticachopen] and ralltacticsdef[ralltacticachopen][ralltacticrealid] then
ralltactics[ralltacticachopen][ralltacticrealid]=ralltacticsdef[ralltacticachopen][ralltacticrealid]
if ralltactics[ralltacticachopen][ralltacticrealid]==0 then
	rallinfframe:SetText(ralluilooktactic3)
else
	rallinfframe:SetText(ralltactics[ralltacticachopen][ralltacticrealid])
end
else
ralltactics[ralltacticachopen][ralltacticrealid]=0
rallinfframe:SetText(ralluilooktactic3)
end
end



function rallwhispbutfun3()
rallinfframe:ClearFocus()

if rallinfframe:GetText()==ralluilooktactic3 or rallinfframe:GetText()=="" then
else
--тут вывод
local tabletext={"",}





local mtxt=rallinfframe:GetText()


if string.find(mtxt, "\n") or string.find(mtxt, " ") then
while (string.find(mtxt, "\n") or string.find(mtxt, " ")) do
	local first=0
	local first2=2
	if string.find(mtxt, "\n") then
		first=string.find(mtxt, "\n")
	end
	if first==0 or (string.find(mtxt, " ") and string.find(mtxt, " ")<first) then
		first=string.find(mtxt, " ")
		first2=1
	end

	if first2==2 then
		if string.len(tabletext[#tabletext])>220 then
			table.insert(tabletext,string.sub(mtxt,0,first-1))
		else
			tabletext[#tabletext]=tabletext[#tabletext]..string.sub(mtxt,0,first-1)
		end
		table.insert(tabletext,"")
	end

	if first2==1 then
		if string.len(tabletext[#tabletext])>220 then
			table.insert(tabletext,string.sub(mtxt,0,first-1).." ")
		else
			tabletext[#tabletext]=tabletext[#tabletext]..string.sub(mtxt,0,first-1).." "
		end
	end

	mtxt=string.sub(mtxt,first+1)
end

if string.len(mtxt)>0 then
	if string.len(tabletext[#tabletext])>220 then
		table.insert(tabletext,mtxt)
	else
		tabletext[#tabletext]=tabletext[#tabletext]..mtxt
	end
end

else
	if string.len(tabletext[#tabletext])>220 then
		table.insert(tabletext,mtxt)
	else
		tabletext[#tabletext]=tabletext[#tabletext]..mtxt
	end
end

if #tabletext>1 or string.len(tabletext[1])>2 then
local a1=GetAchievementLink(ralllistachid[rallmanualch34])
table.insert(tabletext,1,ralluilooktactic5..": "..ralllocationnames[ralltacticachopen].." - "..a1)
end

if string.len(rapsebf3:GetText())>0 then
rallreportinchat(tabletext,"whisper",rapsebf3:GetText())
else
rallreportinchat(tabletext,wherereportll33)
end



end

end


function ralltest()
--ыытест на норм базу данных
print ("запущен тест")
local b=#ralllocations
if b==#ralltip and b==#rallachieve and b==#rallboss and b==#ralltrack and b==#rallmeta and b==#rallfullver then
for i=1,#rallachieve do
	local a=#rallachieve[i]
	if a==#rallboss[i] and a==#ralltrack[i] and a==#rallmeta[i] and a==#rallfullver[i] then
	else
		print (i.. " что-то не так")
	end
end
else
print ("табл кривые")
print (b)
print (#ralltip)
print (#rallachieve)
print (#rallboss)
print (#ralltrack)
print (#rallmeta)
print (#rallfullver)
end
end

function ralltest2()
--GetAchievementLink
for i=1,#rallachieve do
	for j=1,#rallachieve[i] do
		if GetAchievementLink(rallachieve[i][j]) then
		else
			print (ralllocationnames[i])
			print (rallachieve[i][j])
			print (j)
		end
	end
end


end



function arbigmenuchatea(bigma)
if bigma<9 then
	wherereporttempbigma=rabigmenuchatlisten[bigma]
	else wherereporttempbigma=psfchatadd[bigma-8]
end
end

function arbigmenuchatea2(bigma2)
bigma2num=0
if (bigma2=="raid") then bigma2num=1
elseif (bigma2=="raid_warning") then bigma2num=2
elseif (bigma2=="officer") then bigma2num=3
elseif (bigma2=="party") then bigma2num=4
elseif (bigma2=="guild") then bigma2num=5
elseif (bigma2=="say") then bigma2num=6
elseif (bigma2=="yell") then bigma2num=7
elseif (bigma2=="sebe") then bigma2num=8
else
	if psfchatadd==nil or #psfchatadd==0 then
	bigma2num=0
	else
		for i=1,#psfchatadd do
			if string.lower(psfchatadd[i])==string.lower(bigma2) then
			bigma2num=i+8
			end
		end

	end
end

end


function arGetUnitID(guid)
if guid==nil or guid==false then
	return -1
end

if (guid.find(guid,"Creature") or guid.find(guid,"Pet-") or guid.find(guid,"GameObject") or guid.find(guid,"Vehicle")) then
	--Creature-0-3061-1136-29274-71979-00003EDC2C
	local t1,_,_,_,_,id,g = guid:match("([^,]+)-([^,]+)-([^,]+)-([^,]+)-([^,]+)-([^,]+)-([^,]+)")
	if id and tonumber(id) ~= nil then
		return tonumber(id)
	else
		return -1
	end
else
	return -1
end
end