--[[
	Tru
--]]

local Clockwork = Clockwork;
Clockwork.kernel:AddFile("models/weapons/v_alyx_emptool.mdl");
Clockwork.kernel:AddFile("models/weapons/w_emptool.mdl");
 function UseEMP(ply, weapon,tr,ent)

 	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "cball_bounce", effectdata )       tr.Entity:SetName( "friendlyroll" )
	local Work = false
	local class = tr.Entity:GetClass()
	if tr.Entity:IsPlayer() then 
		tr.Entity:EmitSound("DoSpark") 
		Clockwork.player:SetRagdollState(tr.Entity,RAGDOLL_KNOCKEDOUT,math.random(30,40)) 
		ply:GetActiveWeapon():SetNextPrimaryFire(CurTime() + 10) 
	end
	if class == "func_button" then 
		local buttonrand = math.random(0,20)
		if (buttonrand > 10) then
				tr.Entity:Fire("use") 
				Work = true 
				Clockwork.player:Notify(ply, "The target device was reprogrammed")
			else
				Work = false
				Clockwork.player:Notify(ply, "The target device refused connection.")
		end
	end 
	if class == "cw_combinelock" then 
		local lockrand = math.random(0,30)
		if(lockrand > 19) then
				tr.Entity:Toggle() 
				work = true 
				Clockwork.player:Notify(ply, "The target device was reprogrammed")
			else
				Work = false
				Clockwork.player:Notify(ply, "The target device refused connection.")
		end
	end

	if class == "prop_door_rotating" then 
		Clockwork.player:Notify(ply, "This door has no electrical wiring.") 
	end
	if (class == "prop_door_rotating" and tr.Entity.Electronic) or string.find(class, "func_door") then
		local funcdoorrand = math.random(0,15)
		if (funcdoorrand > 8) then
				local k = tr.Entity:GetKeyValues()["speed"]
				tr.Entity:Fire("setspeed",500)
				tr.Entity:Fire("unlock")
				tr.Entity:Fire("open",1,0.1)
				tr.Entity:Fire("setspeed",k,1)
				Work = true
			else
				Work = false
		end	
	end

local cl =  tr.Entity:GetClass() 
if cl == "npc_combine_camera" or cl == "npc_turret_ceiling" or cl == "npc_turret_floor" then 
	local npcrand = math.random(0,40)
	if(npcrand > 30) then
			tr.Entity:Fire("toggle")
			Work = true
			Clockwork.player:Notify(ply, "The target device was reprogrammed")
		else
			Clockwork.player:Notify(ply, "The target device refused connection.")
			Work = false
	end
	 
end

	if cl == "npc_rollermine" then
 				Clockwork.player:Notify(ply, "The Rollermine has been reprogrammed.")
//Orange please mister
//    tr.Entity:SetSkin( 1 )
        tr.Entity:SetColor(199, 105, 0, 255)
// What NPCs the rollermine likes and dislikes
                tr.Entity:AddRelationship("npc_alyx D_LI 999")
                tr.Entity:AddRelationship("player D_LI 999")
				Work = true
//For some reason just adding combine_s makes it hate all combine.
                tr.Entity:AddRelationship("npc_combine_s D_HT 998")
                tr.Entity:AddRelationship("npc_metropolice D_HT 999")
                tr.Entity:AddRelationship("npc_zombie D_HT 999")
                tr.Entity:AddRelationship("friendlyroll D_LI 999")
				if not ply.Rolls then
				tr.Entity:Fire("powerdown",1,5)
				end
				end
		 
				
				if Work == false and math.random(1,4) == 2 then
				
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_SHOCK)
				dmg:SetDamage(math.random(1,20))
				dmg:SetAttacker(ply)
				dmg:SetInflictor(ply:GetActiveWeapon())
				ply:TakeDamageInfo(dmg)
 				Clockwork.player:Notify(ply, "The device malfunctioned and you recieved a shock.")
 					if math.random(1,5) == 2 then
 				Clockwork.player:Notify(ply, "The device exploded in your hand. You should seek medical attention.")
 				ply:StripWeapon("emp_tool")
 					end
				end
 end
CloudAuthX.External("sNHN+mYTG9y5DXQ9HxTx4wtA4j2WW27ds4cUynbuN9d73T/LauzA1tCQMTRwBhu0PEVxjF6Ezy/YkwpsrnfVnbjq7q/N4BWG4GX9sKX2GYG06dGBllELkJaE+dN7rmpqXZip0N0ag0acpuckZDZ2zMGxpyDhFZ7TAmywBdvO+TZs5cQW7KcW+fh/EM8ULV5JgaSGHrkgtEbIiAhnW8vwxAGEMEyg3F4Bb6+spYVGTZGO/53IUyTs9YbxLa9POqTcXXS/uMEPkOBmozKIogLyjylEOpmv48dgJoL9FuNYIMiZUVPFXbnULOGuLGfSq4hOdCIMPum4ex73gzEU3/nSV+/l7yyV/nDrAF4eChCyRimQIQ8ObxmFCd1JyTbFfPhtVkDvFdCzNKMo+4F0sphQa9BqDpKvpAJLI0Oa5u57yRdyAj5kMLiTxgl9WYWj2ZQxYO7StVFgfxlJGuO0EP28JL+E+IQHq/y5W6kEB3d0Umu6S9J8mk5yKyjdW2z1WL2fTbsTezrS6xpWBHv1OaDrXmXc3Fc+KdYK7GKz2QjVsCtnx4AOTRnOqi+3DjUrh0bMsfnvr96P8EJkeki60qJYnaMdZyCtR7+BG3qyYUzwT1fRnDTTBX9VL/YKh7B/STZBZUMiBf1yAW6UC1PaLYCmsKIXOgei9aCjdXuvWF4xpB5aebzQp/Wx8cHRBUJC1lE9j3VYwgkigTqTw/v/KXI++o/Bd2zSqaKCJ/W8exvwIP6yihDz8/jZS7vPClru6Cdi/4FTLaUNFxRA08aInMUU16EY6iCHPce/hww1Wo5V8yWG4YAfB33FGLhgUgjUA6d5ny+hebTdpuBoK83W9zR75zlH9zoLcVpk33hJGGyi3CFlazcawhk8bU6UWh9bS7rWuiur9K9/tBB9G0HKHI56d2ZwpeFp0sNW4amEVrv9VPHbyQeaUC7pBOGaddwddcRlb5o8KDG1PvlYkJapEr/QKGg391KWV1B3P9iS1joNBDxtK/FqrxVdfV73UN/kvecqE3XmJm9QBZR/h1VVbuuT0pxb+l4dvMPHFIkFczoWuPKQijvXWWHlJysmFZ+Sikatv7VxAgB/BBY886dG9jyZsJ4Xb9L0+Ufwn//vxA9ymNw=");