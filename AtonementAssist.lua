local frameBorders = {};

function HideFrameBorder(frame, borderIndex)

	if (frameBorders[frame] ~= nil) and (frameBorders[frame][borderIndex] ~= nil) then
		frameBorders[frame][borderIndex]:Hide();
	end
end

function ShowFrameBorder(frame, r, g, b, borderIndex)

	local border;
	local extraWidth = 0;
	
	--First time shown for this frame?
	if (frameBorders[frame] == nil) then --or (frameBorders[frame][borderIndex] == nil) then
		--Allocate space
		frameBorders[frame] = {};
	end
		
		--Space for border created?
	if (frameBorders[frame][borderIndex] == nil) then

		if (borderIndex == 2) then
			extraWidth = 7;
		end
		
		border=frame:CreateTexture(nil,"BACKGROUND",nil,-borderIndex-1);
		border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground");
		border:SetPoint("TOPLEFT",-5-extraWidth,0);
		border:SetPoint("BOTTOMRIGHT",5+extraWidth,0);
	
		border:SetVertexColor(r, g, b, 0.9)
		
		frameBorders[frame][borderIndex] = border;
	else
		border = frameBorders[frame][borderIndex];
	end
	
	border:SetVertexColor(r, g, b, 0.9)
	border:Show();

end

AA_CompactUnitFrame_UpdateAuras = function(frame)
	local frameName = frame:GetName();
	if not frameName then return end

	if (string.starts(frameName,"CompactRaid") or string.starts(frameName,"CompactParty")) then
			
		i=1;
		
		local buff = UnitBuff(frame.displayedUnit, i, "PLAYER");
                local playerSpec = GetSpecialization(); --1 = disc 2 = holy
                local buffToTrack = "Atonement";
		local foundBuff = false;
		local timeLeft = 0;

                if (playerSpec == 2) then --holy
                    buffToTrack = "Renew";
                end

		i=1;
		while buff do
			
			buff, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff(frame.displayedUnit, i);
			i = i + 1;
								
			if (buff == buffToTrack) then
				--timeLeft = expirationTime - GetTime();
				timeLeft = duration - GetTime(); --For some reason duration is now returning what expirationTime should be returning

				--print(timeLeft);
				--print(unitCaster);
			
				foundBuff=true;
			end

		end;	
		
		if (foundBuff) then
			local r, g, b = 0.0, 1.0, 0.0;
			
			if (timeLeft <= 5) then
				r, g, b = 1.0, 0.65, 0.0;
			end
						
			ShowFrameBorder(frame, r, g, b, 1);
		else
			HideFrameBorder(frame, 1);
		end
	
	end
	
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

--print("<----------- Force loading");
C_AddOns.LoadAddOn("Blizzard_CompactUnitFrames");
--print("<----------- Done");
   
hooksecurefunc("CompactUnitFrame_UpdateAuras", AA_CompactUnitFrame_UpdateAuras);
