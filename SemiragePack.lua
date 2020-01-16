--[[ SemiragePack by Mario aka Vacbroza | Mario#8112]]
local SCRIPT_FILE_NAME = GetScriptName();
local SCRIPT_FILE_ADDR = "https://wg1341850.virtualuser.de/aw-lua/SemiragePack.lua";
local VERSION_FILE_ADDR = "https://wg1341850.virtualuser.de/aw-lua/version.txt";
local SCRIPT_FILE_ADDR_GIT = "https://raw.githubusercontent.com/stormops/Aimware-SemiragePack/master/SemiragePack.lua";
local VERSION_FILE_ADDR_GIT = "https://raw.githubusercontent.com/stormops/Aimware-SemiragePack/master/version.txt";
local VERSION_NUMBER = 1.7;
last_update_sent = globals.TickCount();
last_update_retrieved = globals.TickCount();
version_check_done = false;
update_downloaded = false;
update_available = false;
use_git_link = false;

function updateEventHandler()
    if (update_available and not update_downloaded) then
        if (gui.GetValue("lua_allow_cfg") == false) then
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[Semirage Pack] An update is available, please enable Lua Allow Config and Lua Editing in the settings tab");
        elseif (use_git_link) then
            local new_version_content = http.Get(SCRIPT_FILE_ADDR_GIT);
            local old_script = file.Open(SCRIPT_FILE_NAME, "w");
            old_script:Write(new_version_content);
            old_script:Close();
            update_available = false;
            update_downloaded = true;
			print("dl: "..SCRIPT_FILE_ADDR_GIT);
		elseif (use_git_link == false) then
		    local new_version_content = http.Get(SCRIPT_FILE_ADDR);
            local old_script = file.Open(SCRIPT_FILE_NAME, "w");
            old_script:Write(new_version_content);
            old_script:Close();
            update_available = false;
            update_downloaded = true;
			print("dl: "..SCRIPT_FILE_ADDR);
        end
    end

    if (update_downloaded) then
        draw.Color(255, 0, 0, 255);
        draw.Text(0, 0, "[Semirage Pack] An update has automatically been downloaded, please reload the script");
        return;
    end

    if (not version_check_done) then
        if (gui.GetValue("lua_allow_http") == false) then
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[Semirage Pack] Please enable Lua HTTP Connections in your settings tab to get the newest version");
            return;
        end

        version_check_done = true;
        local version = tonumber(http.Get(VERSION_FILE_ADDR));
		local version_git = tonumber(http.Get(VERSION_FILE_ADDR_GIT));
		if (version == "") then
			if (version_git > VERSION_NUMBER) then
				update_available = true;
				use_git_link = true;
				print("use git cuz empty")
				print("version: "..version)
				print("version_git: "..version_git)
			end
		elseif (version_git > version and version_git > VERSION_NUMBER) then
			update_available = true;
			use_git_link = true;
			print("use git cuz newer")
			print("version: "..version)
			print("version_git: "..version_git)
        elseif (version > version_git and version > VERSION_NUMBER) then
            update_available = true;
			use_git_link = false;
			print("no git")
			print("version: "..version)
			print("version_git: "..version_git)
		else
			print("")
			print("[Error]")
			print("version: "..version)
			print("version_git: "..version_git)
			print("")
        end
    end
end
callbacks.Register("Draw", updateEventHandler);

desyncing_players_list_font = draw.CreateFont("Verdana", 14, 120);
desyncing_players_font = draw.CreateFont("Verdana", 12, 110);
rifk7_font2 = draw.CreateFont("Verdana", 16, 110);
rifk7_font = draw.CreateFont("Verdana", 17, 120);
FontTahoma = draw.CreateFont("Tahoma", 18);
FTahoma = draw.CreateFont("Tahoma", 17);
groupbox_pos_left = 0;
groupbox_pos_right = 0;

function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end

function TIME_TO_TICKS(time)
	local TICK_INTERVAL	= globals.TickInterval();
	return round((0.5 + (time) / TICK_INTERVAL), 0);
end

function TIME_TO_TICKS_TEST(time)
	local TICK_INTERVAL	= globals.TickInterval();
	return (time) / TICK_INTERVAL;
end

function TICKS_TO_TIME(ticks)
	local TICK_INTERVAL	= globals.TickInterval();
	return TICK_INTERVAL * ticks;
end

function angle_difference(b1,b2)
    r = (b2 - b1) % 360;
    if (r < -180) then
      r = r+360;
    end
    if (r >= 180) then
      r = r-360;
    end
    return(r);
end

function AngleNormalize2(angle)
	angle = math.fmod(math.fmod(angle + 360, 360), 360)
	if (angle > 180) then
		angle = angle-360;
	end
	if (angle < -180) then
		angle = angle+360;
	end
	return angle;
end

function NormalizeAngle(angle)
    if(angle ~= angle or angle == 1/0) then
        return 0;
    end
    if(angle >= -180 and angle <= 180) then
        return angle;
    end
    local out = math.fmod(math.fmod(angle + 360, 360), 360);
    if(out > 180) then
        out = out - 360;
    end
    return out;
end

function GetVelocity(pEntity)
	VelocityX = pEntity:GetPropFloat("localdata", "m_vecVelocity[0]");
	VelocityY = pEntity:GetPropFloat("localdata", "m_vecVelocity[1]");
	VelocityZ = pEntity:GetPropFloat("localdata", "m_vecVelocity[2]");
	fl_speed = math.sqrt(VelocityX ^ 2 + VelocityY ^ 2)
	return fl_speed;
end

function math_atan2(Y,X)
	local pi = 3.14159265358979;
	local product = 0;
	if tonumber(Y) == nil or tonumber(X) == nil then
		return 0;
	end
	if X == 0 and Y == 0 then 
		return 0;
	end
	if X == 0 then
		product = pi / 2;
		if Y < 0 then 
			product = product * 3;
		end
	else
		product = atancustom(Y / X);
		if X < 0 then
			product = product + pi;
		end
	end
	return product;
end

function atancustom(r)
	return r/(1+(r*r/(3+(4*r*r)/(5+(9*r*r)/(7+(16*r*r)/(9+(25*r*r)/(11+(36*r*r)/(13+(49*r*r)/(15+(64*r*r)/(17+(81*r*r)))))))))));
end

--[[ Timer ]]
mario_timer = mario_timer or {}
mario_timers = {}

function mario_timer.Create(name, delay, times, func)
   table.insert(mario_timers, {["name"] = name, ["delay"] = delay, ["times"] = times, ["func"] = func, ["lastTime"] = globals.RealTime()})
end

function mario_timer.Remove(name)
	for k,v in pairs(mario_timers or {}) do   
		if (name == v["name"]) then
			table.remove(mario_timers, k)
		end
	end
end

function mario_timer.Tick()
	for k,v in pairs(mario_timers or {}) do

	if (v["times"] <= 0 ) then
		table.remove(mario_timers, k)
		return mario_timer.Tick()
	end

	if (v["lastTime"] + v["delay"] <= globals.RealTime()) then 
		mario_timers[k]["lastTime"] = globals.RealTime()
		mario_timers[k]["times"] = mario_timers[k]["times"] - 1
		v["func"]()
		end   
	end
end
callbacks.Register( "Draw", "mario_timerTick", mario_timer.Tick)
--[[]]

Sidebar_MainGuiKey = gui.GetValue( "msc_menutoggle" )	--getting the Menu Key number. default "45" ( insert ) 
script_refreshed = false 
isOpenSidebar = true 

function SidebarmenuToggleCheck() 
	if input.IsButtonPressed(Sidebar_MainGuiKey) then 
		if isOpenSidebar and Sidebar_menukey_pressed ~= true then 
			Sidebar_menukey_pressed = true 
			isOpenSidebar = false 
		elseif Sidebar_menukey_pressed ~= false then 
			Sidebar_menukey_pressed = false 
			isOpenSidebar = true 
		end
	end 
end 
callbacks.Register("Draw", "Aw Sidebar Menu Open", SidebarmenuToggleCheck) 

function isGuiOpenSidebar()
	return isOpenSidebar 
end

sbmenu_x, sbmenu_y = gui.GetValue( "wnd_menu" )
LegitDesync_WindowBox = gui.Window("wnd_lua_desync", "Legit Desync", sbmenu_x+800, sbmenu_y, 400, 600 )
bDesync_menu = false
LegitDesync_WindowBox:SetActive(false)

function draw.RoundedBlock(left,top,height,width)
	draw.RoundedRectFill( left, top, left+width, top+height )
end

--[[ Panel ]]
Settings_Ref = gui.Reference("SETTINGS", "Miscellaneous")
Text_SideMenu = gui.Text( Settings_Ref,
 "[ 					      Semirage Panel	 				      ]" )
Checkbox_SideMenu = gui.Checkbox( Settings_Ref, "lua_wnd_extwnd_show", "Enable", 1 )
Slider_InSpeed = gui.Slider( Settings_Ref, "lua_wnd_extwnd_inspeed", "Roll-In Speed", 22,0,100 )
Slider_OutSpeed = gui.Slider( Settings_Ref, "lua_wnd_extwnd_outspeed", "Roll-Out Speed", 22,0,100 )
xpos, ypos = gui.GetValue( "wnd_menu" )
ltop,rtop,rfreespace,lfreespace,xr_in,xl_in,xr_out,xl_out = 0,0,0,0,0,0,0,0
HideLeftMenu,HideRightMenu,RightBar_In,LeftBar_In,RightBar_Out,LeftBar_Out = false,false,false,false,false,false
dfreespace = 15
SidePanelLeftSize = 245	--set value to resize left panel
SidePanelRightSize = 245	--set value to resize right panel
fadeOpacityLeft = 220
fadeOpacityBgLeft = 150
fadeOpacityRight = 220
fadeOpacityBgRight = 150
InSpeed = 22
OutSpeed = 22
mouseX, mouseY = input.GetMousePos()
sp_xpos, sp_ypos = gui.GetValue( "wnd_menu" )
Window_pMenuRight = gui.Window("lua_wnd_spright", "ᴹᵃᵈᵉ ᵇʸ ᴹᵃʳᶦᵒ", sp_xpos, sp_ypos, SidePanelRightSize, 580)
Window_pMenuLeft = gui.Window("lua_wnd_spleft", "Welcome "..client.GetConVar('name').. "!", sp_xpos, sp_ypos, SidePanelLeftSize, 580)
Groupbox_pMenuLeft = gui.Groupbox( Window_pMenuLeft, "", 0, 0, SidePanelLeftSize, 572 )
Groupbox_pMenuRight = gui.Groupbox( Window_pMenuRight, "", 0, 0, SidePanelRightSize, 572 )

if Checkbox_SideMenu:GetValue() then
	sp_xpos, sp_ypos = gui.GetValue( "wnd_menu" )
	Window_pMenuLeft:SetActive(0)
	Window_pMenuRight:SetActive(0)
	Window_pMenuLeft:SetActive(1)
	Window_pMenuRight:SetActive(1)
else
	sp_xpos, sp_ypos = gui.GetValue( "wnd_menu" )
	Window_pMenuLeft:SetActive(1)
	Window_pMenuRight:SetActive(1)
	Window_pMenuLeft:SetActive(0)
	Window_pMenuRight:SetActive(0)
end

lsp = lsp or {}
rsp = rsp or {}

rpanel_active = nil
lpanel_active = nil
function pMenuRight(xpos,ypos)
	if Checkbox_SideMenu:GetValue() and isGuiOpenSidebar() then
		mouseX, mouseY = input.GetMousePos()
		Window_pMenuRight:SetValue((xpos + 800), ypos)
		if HideRightMenu then
			if xr_in < SidePanelRightSize and RightBar_In == false then
				mario_timer.Create("rightbar_scroll_in", 0.05, 1, function()
					xr_in = xr_in + InSpeed
				end)
				if gui.GetValue( "wnd_lua_desync" ) ~= nil and (bDesync_menu) then
					xr, yr = gui.GetValue( "wnd_lua_desync" )
					xr_pos = xr+400
					yr_pos = yr+290
				else
					xr, yr = Window_pMenuRight:GetValue()
					xr_pos = xr
					yr_pos = yr+290
				end
				draw.Color(232, 232, 232, fadeOpacityRight)
				draw.RoundedBlock(xr_pos, yr,600,10)
				Window_pMenuRight:SetValue((xpos + 800)-(xr_in+5), ypos)
			elseif xr_in >= SidePanelRightSize then
				if gui.GetValue( "wnd_lua_desync" ) ~= nil and (bDesync_menu) then
					xr, yr = gui.GetValue( "wnd_lua_desync" )
					yr_pos = yr+290
				else
					xr, yr = Window_pMenuRight:GetValue()
					yr_pos = yr+290
				end
				if rpanel_active ~= false then
					rpanel_active = false
					Window_pMenuRight:SetActive(0)
				end
				if gui.GetValue( "wnd_lua_desync" ) ~= nil and (bDesync_menu) then
					xr, yr = gui.GetValue( "wnd_lua_desync" )
					xr_pos = xr+400
					yr_pos = yr+290
				else
					xr, yr = Window_pMenuRight:GetValue()
					xr_pos = xr
					yr_pos = yr+290
				end
				RightBar_In = true
			end
			if not (mouseX > xr_pos and xr_pos+20 > mouseX and mouseY > yr_pos-300 and yr_pos+300 > mouseY) then
				if fadeOpacityRight >= 20 and stopfader ~= true then
					fadingR = true
					mario_timer.Create("SidePanel_fade1", 0.1, 1, function()
						fadeOpacityRight = fadeOpacityRight - 1
						fadeOpacityBgRight = fadeOpacityRight
					end)
				elseif fadingR and fadeOpacityRight <= 20 then
					fadingR = false
					stopfader = true
				end

				draw.Color(232, 232, 232, fadeOpacityRight)
				draw.RoundedBlock(xr_pos, yr,600,10)

			else
				if (input.IsButtonPressed("mouse1")) then
					draw.Color(232, 232, 232, fadeOpacityRight)
					draw.RoundedBlock(xr_pos, yr,600,10)
					HideRightMenu = false
					RightBar_In = false
					xr_in = 0
				end
				draw.Color(232, 232, 232, fadeOpacityRight)
				draw.RoundedBlock(xr_pos, yr,600,10)

				fadingR = false
				fadeOpacityRight = 220
				fadeOpacityBgRight = 150
				stopfader = false
			end
		else
			if xr_out < SidePanelRightSize and RightBar_Out == false then
				mario_timer.Create("rightbar_scroll_out", 0.05, 1, function()
					xr_out = xr_out + OutSpeed
				end)
				if gui.GetValue( "wnd_lua_desync" ) ~= nil and (bDesync_menu) then
					xr, yr = gui.GetValue( "wnd_lua_desync" )
					xr_pos = xr+xr_out-5
					yr_pos = yr+290
				else
					xr, yr = Window_pMenuRight:GetValue()
					xr_pos = ((xr+xr_out-5))
					yr_pos = yr+290
				end
				
				draw.Color(232, 232, 232, fadeOpacityRight)
				draw.RoundedBlock(xr_pos, yr,600,10)
				Window_pMenuRight:SetValue(((xpos + 800)+(xr_out-5))-SidePanelRightSize, ypos)
				RightBar_Out = false
			else
				if gui.GetValue( "wnd_lua_desync" ) ~= nil and (bDesync_menu) then
					xr, yr = gui.GetValue( "wnd_lua_desync" )
					xr_out = 0
					xr_pos = (xr-xr_out)+400
					yr_pos = yr+290
				else
					xr, yr = Window_pMenuRight:GetValue()
					xr_out = 0
					xr_pos = (xr-xr_out)+SidePanelRightSize
					yr_pos = yr+290
				end

				draw.Color(232, 232, 232, fadeOpacityRight)
				draw.RoundedBlock(xr_pos, yr,600,10)
				RightBar_Out = true
			end
			if rpanel_active ~= true then
				Window_pMenuRight:SetActive(1)
				rpanel_active = true
			end
			if not (mouseX > xr_pos and xr_pos+20 > mouseX and mouseY > yr_pos-300 and yr_pos+300 > mouseY) then
				if fadeOpacityRight >= 20 and stopfadel ~= true then
					fadingR = true
					mario_timer.Create("SidePanel_fade2", 0.1, 1, function()
						fadeOpacityRight = fadeOpacityRight - 1
						fadeOpacityBgRight = fadeOpacityRight
					end)
				elseif fadingR and fadeOpacityRight <= 20 then
					fadingR = false
					stopfadel = true
				end

				draw.Color(232, 232, 232, fadeOpacityRight)
				draw.RoundedBlock(xr_pos, yr,600,10)
			else
				if (input.IsButtonPressed("mouse1")) then
					fadingR = false
					draw.Color(232, 232, 232, fadeOpacityRight)
					draw.RoundedBlock(xr_pos, yr,600,10)
					xr_in = 0
					HideRightMenu = true
					RightBar_Out = false
				end
				fadingR = false
				fadeOpacityRight = 220
				fadeOpacityBgRight = 150
				stopfadel = false
			end
		end
	elseif rpanel_active ~= false then
		Window_pMenuRight:SetActive(0)
		rpanel_active = false
	end
end

function pMenuLeft(xpos,ypos)
	if Checkbox_SideMenu:GetValue() and isGuiOpenSidebar() then
		Window_pMenuLeft:SetValue((xpos - SidePanelLeftSize), ypos)
		mouseX, mouseY = input.GetMousePos()
		if HideLeftMenu then
			if xl_in < SidePanelLeftSize and LeftBar_In == false then
				mario_timer.Create("leftbar_scroll_in", 0.05, 1, function()
					xl_in = xl_in + InSpeed
				end)
				xl, yl = Window_pMenuLeft:GetValue()
				Window_pMenuLeft:SetValue((xpos-SidePanelLeftSize)+(xl_in-5), ypos)

			elseif xl_in >= SidePanelLeftSize and lpanel_active ~= false then
				lpanel_active = false
				Window_pMenuLeft:SetActive(0)
				xl_in = 0
				LeftBar_In = true
			end
			xl, yl = Window_pMenuLeft:GetValue()
			xl_pos = xl+SidePanelLeftSize-10
			yl_pos = yl+290
			draw.Color(232, 232, 232, fadeOpacityLeft)
			draw.RoundedBlock(xl_pos, yl,600,10)
			if not (mouseX > xl_pos-10 and xl_pos+10 > mouseX and mouseY > yl_pos-300 and yl_pos+300 > mouseY) then
				if fadeOpacityLeft >= 20 and stopfadel ~= true then
					fadingL = true
					mario_timer.Create("SidePanel_fade3", 0.1, 1, function()
						fadeOpacityLeft = fadeOpacityLeft - 1
						fadeOpacityBgLeft = fadeOpacityLeft
					end)
				elseif fadingL and fadeOpacityLeft <= 20 then
					fadingL = false
					stopfadel = true
				end
				draw.Color(232, 232, 232, fadeOpacityLeft)
				draw.RoundedBlock(xl_pos, yl,600,10)
			else
				if (input.IsButtonPressed("mouse1")) then
					draw.Color(232, 232, 232, fadeOpacityLeft)
					draw.RoundedBlock(xl_pos, yl,600,10)
					HideLeftMenu = false
					LeftBar_In = false
				end
				fadingL = false
				fadeOpacityLeft = 220
				fadeOpacityBgLeft = 150
				stopfadel = false
			end
		else
			if xl_out < SidePanelLeftSize and LeftBar_Out == false then
				mario_timer.Create("leftbar_scroll_out", 0.05, 1, function()
					xl_out = xl_out + OutSpeed
				end)

				xl, yl = Window_pMenuLeft:GetValue()
				xl_pos = (xl)+SidePanelLeftSize
				yl_pos = yl+290
				draw.Color(232, 232, 232, fadeOpacityLeft)
				draw.RoundedBlock(xl_pos, yl,600,10)
				Window_pMenuLeft:SetValue(((xpos)-(xl_out+5)), ypos)
				LeftBar_Out = false
			else
				xl, yl = Window_pMenuLeft:GetValue()

				xl_pos = ((xl-10))
				yl_pos = yl+290
				draw.Color(232, 232, 232, fadeOpacityLeft)
				draw.RoundedBlock(xl_pos, yl,600,10)
				LeftBar_Out = true
			end
			if lpanel_active ~= true then
				Window_pMenuLeft:SetActive(1)
				lpanel_active = true
			end

			if not (mouseX > xl_pos-10 and xl_pos+10 > mouseX and mouseY > yl_pos-300 and yl_pos+300 > mouseY) then
				if fadeOpacityLeft >= 20 and stopfadel ~= true then
					fadingL = true
					mario_timer.Create("SidePanel_fade4", 0.1, 1, function()
						fadeOpacityLeft = fadeOpacityLeft - 1
						fadeOpacityBgLeft = fadeOpacityLeft
					end)
				elseif fadingL and fadeOpacityLeft <= 20 then
					fadingL = false
					stopfadel = true
				end

				draw.Color(232, 232, 232, fadeOpacityLeft)
				draw.RoundedBlock(xl_pos, yl,600,10)

			else
				if (input.IsButtonPressed("mouse1")) then
					draw.Color(232, 232, 232, fadeOpacityLeft)
					draw.RoundedBlock(xl_pos, yl,600,10)
					HideLeftMenu = true
					LeftBar_Out = false
					xl_out = 0

				end
				fadingL = false
				fadeOpacityLeft = 220
				fadeOpacityBgLeft = 150
				stopfadel = false
			end
		end
	elseif lpanel_active ~= false then
		Window_pMenuLeft:SetActive(0)
		lpanel_active = false
	end
end

function pMenu()
	InSpeed = math.floor(Slider_InSpeed:GetValue())
	OutSpeed = math.floor(Slider_OutSpeed:GetValue())

	if Checkbox_SideMenu:GetValue() then
		if Window_pMenuLeft ~= nil then		  
			if isGuiOpenSidebar() then
				xpos, ypos = gui.GetValue( "wnd_menu" )
				pMenuRight(xpos, ypos)
				pMenuLeft(xpos, ypos)
			else
				xpos, ypos = gui.GetValue( "wnd_menu" )
				pMenuRight(xpos, ypos)
				pMenuLeft(xpos, ypos)
				if lpanel_active ~= false or rpanel_active ~= false then
					Window_pMenuLeft:SetActive(0)
					Window_pMenuRight:SetActive(0)
					lpanel_active = false
					rpanel_active = false
				end
			end
		end
	elseif lpanel_active ~= false or rpanel_active ~= false then
		Window_pMenuLeft:SetActive(1)
		Window_pMenuRight:SetActive(1)
		Window_pMenuLeft:SetActive(0)
		Window_pMenuRight:SetActive(0)
		lpanel_active = false
		rpanel_active = false
	end
end
callbacks.Register( "Draw", "Side Panel", pMenu )

if Checkbox_SideMenu:GetValue() ~= nil then
	function lsp.Reference() return Groupbox_pMenuLeft end
	function rsp.Reference() return Groupbox_pMenuRight end

	function lsp.Groupbox(title,hight)
		if title ~= nil and hight ~= nil then
			temp_top = ltop + lfreespace
			ltop = ltop + hight + lfreespace
			lfreespace = dfreespace
		else
			title = "nil"
			hight = 0
		end
	return gui.Groupbox( Groupbox_pMenuLeft, title, -16, temp_top, 245, hight )
	end
			
	function rsp.Groupbox(title,hight)
		if title ~= nil and hight ~= nil then
			temp_top = rtop + rfreespace
			rtop = rtop + hight + rfreespace
			rfreespace = dfreespace
		else
			title = "nil"
			hight = 0
		end
	return  gui.Groupbox( Groupbox_pMenuRight, title, -16, temp_top, 245, hight )
	end
end

--[[ Indicators Groupbox ]]
Indicators_Ref = rsp.Reference()
GroupBox_Indicators = gui.Groupbox(Indicators_Ref, "Indicators", -16, 0, 245, 220)
groupbox_pos_right = groupbox_pos_right + 220
RageTrigger_Checkbox = gui.Checkbox(GroupBox_Indicators, "lbot_indicator_ragetrigger_enable", "Rage Trigger", 1)
AutoWall_Checkbox = gui.Checkbox(GroupBox_Indicators, "lbot_indicator_autowall_enable", "Auto Wall", 1)
ForceBaim_Checkbox = gui.Checkbox(GroupBox_Indicators, "lbot_indicator_forcebaim_enable", "Force Baim", 1)
Fakelag_Checkbox = gui.Checkbox(GroupBox_Indicators, "lbot_indicator_fakelag_enable", "Fakelag", 1)
indi_xpos = gui.Slider(GroupBox_Indicators, "lbot_extra_xpos", "X Position", 1, 0, 1920);
indi_ypos = gui.Slider(GroupBox_Indicators, "lbot_extra_ypos", "Y Position", 1, 0, 1080);

function drawRbotTriggerIndicator()
	if RageTrigger_Checkbox:GetValue() then
		if (ky1 or ky2 or ky3) then
			draw.SetFont(rifk7_font);
			draw.Color(0,255,0,90);
		else
			draw.SetFont(rifk7_font2);
			draw.Color(0, 0, 0, 10);
		end
	end
	draw.Text(indi_xpos:GetValue(),indi_ypos:GetValue()+0,"[TRIGGER]");
	draw.TextShadow(indi_xpos:GetValue(),indi_ypos:GetValue()+0,"[TRIGGER]");
end

function doDrawForceBaimIndicator()
	if ForceBaim_Checkbox:GetValue() then
		if forcebaim_state then
			draw.Color(0,255,0,90);
			draw.SetFont(rifk7_font);
		else
			draw.Color(0, 0, 0, 10);
			draw.SetFont(rifk7_font2);
		end
		draw.Text(indi_xpos:GetValue(),indi_ypos:GetValue()+40,"[F-BAIM]");
		draw.TextShadow(indi_xpos:GetValue(),indi_ypos:GetValue()+40,"[F-BAIM]");
	end
end

function doDrawFakelag()
	if Fakelag_Checkbox:GetValue() then
		if key_hold_fakelag or key_toggle_fakelag then
			draw.Color(0,255,0,90);
			draw.SetFont(rifk7_font);
		else
			draw.Color(0, 0, 0, 10);
			draw.SetFont(rifk7_font2);
		end
		draw.Text(indi_xpos:GetValue(),indi_ypos:GetValue()+60,"[FAKELAG]");
		draw.TextShadow(indi_xpos:GetValue(),indi_ypos:GetValue()+60,"[FAKELAG]");
	end
end

function doDrawIndicatorAW()
	if AutoWall_Checkbox:GetValue() then
		if awtogglecount==2 then
			draw.Color(0,255,0,90);
			draw.SetFont(rifk7_font);
		elseif awtogglecount==1 then
			draw.Color(0, 0, 0, 10);
			draw.SetFont(rifk7_font2);
		end
		draw.Text(indi_xpos:GetValue(),indi_ypos:GetValue()+20,"[AUTOWALL]");
		draw.TextShadow(indi_xpos:GetValue(),indi_ypos:GetValue()+20,"[AUTOWALL]");
	end
end

--[[ Legit Desync Extras Groupbox ]]
LegitDesyncFreeze_Extra_Ref = rsp.Reference()
GroupBox_LegitDesyncFreeze_Extra = gui.Groupbox(LegitDesyncFreeze_Extra_Ref, "Legit Desync Extras", -16, groupbox_pos_right+10, 245, 195)
groupbox_pos_right = groupbox_pos_right+10 + 200
flip_legit_desync=gui.Keybox(GroupBox_LegitDesyncFreeze_Extra, "lbot_extra_legitaa_flipkey", "Flip Key", 0);
off_legit_desync=gui.Keybox(GroupBox_LegitDesyncFreeze_Extra, "lbot_extra_legitaa_offkey", "Off Key", 0);
LegitDesync_OnFreeze_Checkbox = gui.Checkbox(GroupBox_LegitDesyncFreeze_Extra, "lbot_antiaim_freeze_enable", "Disable On Freeze", 0)
LegitDesync_Ping_Checkbox = gui.Checkbox(GroupBox_LegitDesyncFreeze_Extra, "lbot_desync_ping_enable", "Disable On Ping", 0);
LegitDesync_PingWarning_Checkbox = gui.Checkbox(GroupBox_LegitDesyncFreeze_Extra, "lbot_desync_ping_warning_enable", "Ping Warning", 0);
LegitDesync_Ping_Slider = gui.Slider(GroupBox_LegitDesyncFreeze_Extra, "lbot_desync_ping", "Ping", 70, 0, 1000);

lbot_antiaim_var = 0;
LegitDesync_Ping_VarRestored = nil;
LegitDesync_Ping_VarSaved = nil;
LegitDesync_Ping_ping,LegitDesync_Ping_LegitDesync_Ping_screenX,LegitDesync_Ping_screenY,ping_spike = nil,nil,nil,nil;
LegitDesync_Ping_drawing_fade = 0;

callbacks.Register('Draw', function()
	if LegitDesync_Ping_Checkbox:GetValue() or LegitDesync_PingWarning_Checkbox:GetValue() then
		if gui.GetValue("lbot_antiaim") ~= 0 and LegitDesync_Ping_VarSaved ~= true then
			lbot_antiaim_var = gui.GetValue("lbot_antiaim");
			LegitDesync_Ping_VarSaved = true;
		end
		if entities.GetLocalPlayer() == nil or gui.GetValue("msc_fakelatency_enable") then return end		
		LegitDesync_Ping_ping = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex());
		if LegitDesync_Ping_ping == nil then return end
		if (LegitDesync_Ping_ping >= round(LegitDesync_Ping_Slider:GetValue(), 0)) then
			if ping_spike ~= true then
				LegitDesync_Ping_drawing_fade = 0;
				ping_spike = true;
			end
		elseif (LegitDesync_Ping_ping < round(LegitDesync_Ping_Slider:GetValue(), 0)) then
			if ping_spike ~= false then
				ping_spike = false;
			end
		end
		if ping_spike and LegitDesync_Ping_Checkbox:GetValue() then
			if gui.GetValue("lbot_antiaim") ~= 0 then
				lbot_antiaim_var = gui.GetValue("lbot_antiaim");
			end
			gui.SetValue("lbot_antiaim",0);
			LegitDesync_Ping_VarRestored = false;
		elseif LegitDesync_Ping_VarRestored ~= true then
			gui.SetValue("lbot_antiaim",lbot_antiaim_var);
			lbot_antiaim_var = 0;
			LegitDesync_Ping_VarRestored = true;
		end
		if ping_spike and LegitDesync_PingWarning_Checkbox:GetValue() then
			LegitDesync_Ping_LegitDesync_Ping_screenX, LegitDesync_Ping_screenY = draw.GetScreenSize();
			if LegitDesync_Ping_LegitDesync_Ping_screenX == nil then return end
			draw.SetFont(FTahoma);
			if LegitDesync_Ping_drawing_fade == 15 then
				remove_fade = false;
			elseif LegitDesync_Ping_drawing_fade == 255 then
				remove_fade = true;
			end
			if remove_fade then
				LegitDesync_Ping_drawing_fade = (LegitDesync_Ping_drawing_fade - 5);
			else
				LegitDesync_Ping_drawing_fade = (LegitDesync_Ping_drawing_fade + 5);
			end
			draw.Color(255, 0, 0, LegitDesync_Ping_drawing_fade)
			if ping_spike then
				draw.Text((LegitDesync_Ping_LegitDesync_Ping_screenX / 2) - 100, (LegitDesync_Ping_screenY / 2) - 60, "[Ping Spike]");
			end
		end	
	end
end)

local aa_set_on;
function flipAA()
	if off_legit_desync:GetValue()~= 0 then
		if input.IsButtonDown(off_legit_desync:GetValue()) then
			gui.SetValue("lbot_antiaim",0);
			gui.SetValue("lbot_antiaim",0);
		end
	end
	
	if flip_legit_desync:GetValue()~= 0 then
		if input.IsButtonPressed(flip_legit_desync:GetValue()) and aa_set_on ~= true then
			gui.SetValue("lbot_antiaim",2);
			gui.SetValue("lbot_antiaim",2);
			aa_set_on = true;
		elseif input.IsButtonPressed(flip_legit_desync:GetValue()) and aa_set_on ~= false then
			gui.SetValue("lbot_antiaim",3);
			gui.SetValue("lbot_antiaim",3);
			aa_set_on = false;
		end
	end
end
callbacks.Register("Draw", "flipAA", flipAA)

local save_val
local restored = false
RoundFreeze = false

function OnFreeze(event)
	if LegitDesync_OnFreeze_Checkbox:GetValue() then
		if entities.GetLocalPlayer() == nil then
			RoundFreeze = false
		end
		if event:GetName() == "round_start" then
			RoundFreeze = true
		end
		if event:GetName() == "round_freeze_end" then
			RoundFreeze = false
		end
	elseif RoundFreeze == true then
		RoundFreeze = false
	end
end
callbacks.Register("FireGameEvent", "RoundFreezeCheck", OnFreeze)
client.AllowListener("round_start")
client.AllowListener("player_spawned")
client.AllowListener("round_freeze_end")

local function turnOff()
	local lbot_aa = gui.GetValue("lbot_antiaim")
	if lbot_aa ~= save_val and RoundFreeze ~= true then
		save_val = lbot_aa
	end
	if RoundFreeze then
		gui.SetValue("lbot_antiaim", 0)
		restored = false
	elseif restored == false and entities.GetLocalPlayer() ~= nil then
		gui.SetValue("lbot_antiaim", save_val)
		restored = true
	end
end
callbacks.Register("Draw", "turn_off_desync", turnOff)

--[[ Legit Desync Indicator ]]
local ref_ld_indi = rsp.Reference()
GroupBox_ld_indi = gui.Groupbox(ref_ld_indi, "Legit Desync Indicator", -16, groupbox_pos_right+10, 245, 265)
groupbox_pos_right = groupbox_pos_right + 10 + 265
local arrow_indicator = gui.Checkbox(GroupBox_ld_indi, arrow_indicator, "Arrow Indicator", 0)
local distance = gui.Slider(GroupBox_ld_indi, distance, "Indicator Gap", 70, 15, 250)
local rounddist = 0
local scaleslider = gui.Slider(GroupBox_ld_indi, scaleslider, "Indicator Scale", 1, 0.5, 5)
local iclr = gui.ColorEntry( "lua_clr_legitaa_arrow_inactive", "Legit Desync Indicator Inactive", 0, 0, 0, 60 )
local aclr = gui.ColorEntry( "lua_clr_legitaa_arrow_active", "Legit Desync Indicator Active", 200, 25, 25, 60 )
local IndicatorText_Checkbox = gui.Checkbox(GroupBox_ld_indi, "lua_indicator_text", "Text Indicator", false)
local IndicatorTextX = gui.Slider(GroupBox_ld_indi, "lua_indicator_text_x", "X", 70, 0, 1920)
local IndicatorTextY = gui.Slider(GroupBox_ld_indi, "lua_indicator_text_y", "Y", 700, 0, 1080)

local function idk()
	rounddist = math.floor(distance:GetValue())
	distance:SetValue(rounddist)
	
	if entities.GetLocalPlayer() == nil then
		return
	end
	
	if arrow_indicator:GetValue() then
		local w,h = draw.GetScreenSize()
		local scale = scaleslider:GetValue()
		if gui.GetValue("lbot_antiaim") == 0 then
			draw.Color(iclr:GetValue())
			draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
			draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
		elseif gui.GetValue("lbot_antiaim") == 3 then
			draw.Color(aclr:GetValue())
			draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
			draw.Color(iclr:GetValue())
			draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
		elseif gui.GetValue("lbot_antiaim") == 2 then
			draw.Color(iclr:GetValue())
			draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
			draw.Color(aclr:GetValue())
			draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
		end
	end

	if IndicatorText_Checkbox:GetValue() then
		local FontTahoma = draw.CreateFont("Tahoma", 18)
		draw.SetFont(FontTahoma)
		if gui.GetValue("lbot_antiaim") == 0 then
			draw.Color(0, 0, 0, 40)
			draw.Text(IndicatorTextX:GetValue(), IndicatorTextY:GetValue(), "[OFF]")
		elseif gui.GetValue("lbot_antiaim") == 2 then
			draw.Color(220, 20, 50, 150)
			draw.Text(IndicatorTextX:GetValue(), IndicatorTextY:GetValue(), "[RIGHT]")
		elseif gui.GetValue("lbot_antiaim") == 3 then
			draw.Color(20, 220, 50, 150)
			draw.Text(IndicatorTextX:GetValue(), IndicatorTextY:GetValue(), "[LEFT]")
		end
	end
end
callbacks.Register("Draw", idk)

--[[ Extras ]]
local Ref_extras = rsp.Reference()
GroupBox_extras = gui.Groupbox(Ref_extras, "Extras", -16, groupbox_pos_right+10, 245, 240)
groupbox_pos_right = groupbox_pos_right + 10 + 240
FDD_Checkbox_Enable = gui.Checkbox(GroupBox_extras, "lua_fakeduckdetect", "Fake Duck Detect", false)

storedTick = 0
crouched_ticks = { }

function toBits(num)
	local t = { }
	while num > 0 do
		rest = math.fmod(num,2)
		t[#t+1] = rest
		num = (num-rest) / 2
	end

	return t
end

callbacks.Register("DrawESP", "FD_Indicator", function(Builder)
	if FDD_Checkbox_Enable:GetValue() == true then
		local g_Local = entities.GetLocalPlayer()
		local Entity = Builder:GetEntity()

		if g_Local == nil or Entity == nil or not Entity:IsPlayer() or not Entity:IsAlive() then
			return
		end

		local index = Entity:GetIndex()
		local m_flDuckAmount = Entity:GetProp("m_flDuckAmount")
		local m_flDuckSpeed = Entity:GetProp("m_flDuckSpeed")
		local m_fFlags = Entity:GetProp("m_fFlags")

		if crouched_ticks[index] == nil then 
			crouched_ticks[index] = 0
		end

		if m_flDuckSpeed ~= nil and m_flDuckAmount ~= nil then
			if m_flDuckSpeed == 8 and m_flDuckAmount <= 0.9 and m_flDuckAmount > 0.01 and toBits(m_fFlags)[1] == 1 then
				if storedTick ~= globals.TickCount() then
					crouched_ticks[index] = crouched_ticks[index] + 1
					storedTick = globals.TickCount()
				end

				if crouched_ticks[index] >= 5 then 
					Builder:Color(255, 255, 0, 255)
					Builder:AddTextTop("Fake Duck")
				end
			else
				crouched_ticks[index] = 0
			end
		end
	end
end)
Ref_LegitAutoRevolver = rsp.Reference()
LegitAutoRevolver_Active = gui.Checkbox(GroupBox_extras, "lua_lbot_autorevolver_enable", "Auto Revolver", false)
LegitAutoRevolver_Keybox = gui.Keybox(GroupBox_extras, "lua_lbot_autorevolver_key", "Auto Revolver Key", "")
LegitAutoRevolver_Speed = gui.Slider(GroupBox_extras, "lua_lbot_autorevolver_speed", "Cock Speed", 5, 5, 50)
LegitAutoRevolver_Ticks = gui.Slider(GroupBox_extras, "lua_lbot_autorevolver_ticks", "Revolver ticks", 0, 0, 50)

local function GetWeapon( localPlayerBool )
	if ( localPlayerBool == nil or localPlayerBool == false ) then
		local players = entities.FindByClass( "CCSPlayer" )
		for i = 1, #players do
			local player = players[ i ]
			local weapon = player:GetPropEntity("m_hActiveWeapon")

			return weapon
		end
	elseif ( localPlayerBool == true and entities.GetLocalPlayer() ~= nil ) then
		local LocalPlayer = entities.GetLocalPlayer()
		local weapon = LocalPlayer:GetPropEntity("m_hActiveWeapon")

		return weapon
	else
		return
	end
end

local function GetFireReadyTime( Weapon )
	if ( Weapon ~= nil ) then
		local Time = Weapon:GetPropFloat("m_flPostponeFireReadyTime")
		
		return Time
	else
		return
	end
end

local function onRevolverCock(Cmd)
	if ( LegitAutoRevolver_Active:GetValue() and entities.GetLocalPlayer() ~= nil and entities.GetLocalPlayer():GetHealth() > 0 ) then
		local localPlayer = entities.GetLocalPlayer()

		if ( localPlayer:GetHealth() > 0 ) then

			if ( Cmd:GetButtons() & (1 << 0) > 0 ) then
				return
			end

			local Weapon = GetWeapon(true)

			if ( Weapon:GetClass() == "CDEagle" and Weapon:GetWeaponID() == 64 ) then
				Cmd:SetButtons(Cmd:GetButtons() | (1 << 0))

				local FireReadyTime = GetFireReadyTime( Weapon )

				if ( FireReadyTime > 0 and FireReadyTime - (LegitAutoRevolver_Speed:GetValue() / 100) < globals.CurTime() ) then
					Cmd:SetButtons(Cmd:GetButtons() & ~(1 << 0))
					if ( FireReadyTime + globals.TickInterval() * 16 + (LegitAutoRevolver_Ticks:GetValue() / 100) > globals.CurTime() ) then
						Cmd:SetButtons(Cmd:GetButtons() | (1 << 11))
					end
				end
			end
		end
	end
end
callbacks.Register("CreateMove", "Auto Revolver Cock", onRevolverCock)

local Checkbox_RadarOnMenu = gui.Checkbox( GroupBox_extras, "msc_radar_menu", "Hide Radar In Menu", 1 )
local Checkbox_SpecOnMenu = gui.Checkbox( GroupBox_extras, "msc_spec_menu", "Hide Spectators In Menu", 1 )
saved_Prop = nil;
saved_Prop_spec = nil;
manual_disabled = nil;
manual_enabled = nil;
manual_disabled_spec = nil;
manual_enabled_spec = nil;
radar_state = nil;
spec_state = nil;

MainGuiKey = gui.GetValue( "msc_menutoggle" )
local isOpen = true

local function menuToggleCheck()
	if input.IsButtonPressed(MainGuiKey) then
		if isOpen and menukey_pressed ~= true then
			menukey_pressed = true
			isOpen = false
		elseif menukey_pressed ~= false then
			menukey_pressed = false
			isOpen = true
		end
	end
end
callbacks.Register("Draw", "Aw HideRadar Menu Open", menuToggleCheck)

local function isGuiOpen()
	return isOpen
end

local function onSpecMenu()
	if Checkbox_SpecOnMenu:GetValue() then
		if saved_Prop_spec == nil then
			saved_Prop_spec = gui.GetValue("msc_showspec")
		end
		if isGuiOpen() and gui.GetValue("msc_showspec") == false and manual_disabled_spec ~= true and spec_state then
			saved_Prop_spec = gui.GetValue("msc_showspec")
			manual_disabled_spec = true
			manual_enabled_spec = false
		elseif isGuiOpen() == true and manual_disabled_spec == true and gui.GetValue("msc_showspec") then
			saved_Prop_spec = gui.GetValue("msc_showspec")
			manual_disabled_spec = false
			manual_enabled_spec = true
		end
		if isGuiOpen() and entities.GetLocalPlayer() ~= nil then
			if spec_state ~= true then
				spec_state = true
				gui.SetValue("msc_showspec", saved_Prop_spec)
			end
		elseif entities.GetLocalPlayer() ~= nil then
			spec_state = false
			gui.SetValue("msc_showspec", false)
		end		
		if isGuiOpen() and entities.GetLocalPlayer() == nil then
			if spec_state ~= true then
				spec_state = true
				gui.SetValue("msc_showspec", saved_Prop_spec)
			end
		elseif entities.GetLocalPlayer() == nil then
			spec_state = false
			gui.SetValue("msc_showspec", false)
		end	
		if manual_disabled_spec and gui.GetValue("msc_showspec") == true then
			spec_state = false
			gui.SetValue("msc_showspec", false)
		elseif manual_enabled_spec or manual_disabled_spec ~= true then
			if isGuiOpen() ~= true and entities.GetLocalPlayer() ~= nil then
				gui.SetValue("msc_showspec", saved_Prop_spec)
			end
			if isGuiOpen() and entities.GetLocalPlayer() == nil then
				if spec_state ~= true then
					spec_state = true
					gui.SetValue("msc_showspec", saved_Prop_spec)
				end
			elseif spec_state ~= false and entities.GetLocalPlayer() == nil then
				spec_state = false
				gui.SetValue("msc_showspec", false)
			end
		end
	elseif saved_Prop_spec ~= nil then
		if saved_Prop_spec == false then
			manual_disabled_spec = false
			manual_enabled_spec = true
		else
			manual_disabled_spec = true
			manual_enabled_spec = false
		end
		gui.SetValue("msc_showspec", saved_Prop_spec)
		saved_Prop_spec = nil
		spec_state = nil
	end
end

local function onRadarMenu()
	if Checkbox_RadarOnMenu:GetValue() then
		if saved_Prop == nil then
			saved_Prop = gui.GetValue("esp_radar")
		end
		if isGuiOpen() and gui.GetValue("esp_radar") == false and manual_disabled ~= true and radar_state then
			saved_Prop = false
			manual_disabled = true
			manual_enabled = false
		elseif isGuiOpen() == true and manual_disabled == true and gui.GetValue("esp_radar") then
			saved_Prop = true
			manual_disabled = false
			manual_enabled = true
		end
		if isGuiOpen() and entities.GetLocalPlayer() ~= nil then
			if radar_state ~= true then
				radar_state = true
				gui.SetValue("esp_radar", saved_Prop)
			end
		elseif entities.GetLocalPlayer() ~= nil then
			radar_state = false
			gui.SetValue("esp_radar", false)
		end

		if isGuiOpen() and entities.GetLocalPlayer() == nil then
			if radar_state ~= true then
				radar_state = true
				gui.SetValue("esp_radar", saved_Prop)
			end
		elseif entities.GetLocalPlayer() == nil then
			radar_state = false
			gui.SetValue("esp_radar", false)
		end
		
		if manual_disabled and gui.GetValue("esp_radar") == true then
			radar_state = false
			gui.SetValue("esp_radar", false)
		elseif manual_enabled or manual_disabled ~= true then
			if isGuiOpen() ~= true and entities.GetLocalPlayer() ~= nil then
				gui.SetValue("esp_radar", saved_Prop)
			end
			if isGuiOpen() and entities.GetLocalPlayer() == nil then
				if radar_state ~= true then
					radar_state = true
					gui.SetValue("esp_radar", saved_Prop)
				end
			elseif radar_state ~= false and entities.GetLocalPlayer() == nil then
				radar_state = false
				gui.SetValue("esp_radar", false)
			end
		end
	elseif saved_Prop ~= nil then
		if saved_Propc == false then
			manual_disabled = false
			manual_enabled = true
		else
			manual_disabled = true
			manual_enabled = false
		end
		gui.SetValue("esp_radar", saved_Prop)
		saved_Prop = nil
		radar_state = nil
	end
end

local function onMenu()
	onRadarMenu();
	onSpecMenu();
end
callbacks.Register("Draw", "Disable Radar/Spectators On Menu", onMenu);

--[[ Fake Duck ]]
IN_DUCK = (1 << 2);
IN_ATTACK = (1 << 0);
IN_BULLRUSH = (1 << 22);
local do_ = false;
local count = 0;
local LegitFakeDuck_Extra_Ref = lsp.Reference();
GroupBox_LegitFakeDuck_Extra = gui.Groupbox(LegitFakeDuck_Extra_Ref, "Fake Duck", -16, 0, 245, 220)
groupbox_pos_left = groupbox_pos_left + 210
local FastDuck_Checkbox = gui.Checkbox(GroupBox_LegitFakeDuck_Extra, "lua_fastduck", "Fast Duck", 0);
local LegitFakeDuck_Keybox = gui.Keybox(GroupBox_LegitFakeDuck_Extra, "lua_fakeduck", "Legit Fake Duck", 0);
Text_SideMenu = gui.Text( GroupBox_LegitFakeDuck_Extra,
 "Dont change those vars ! Only for testing !" )
local choke_amount2 = gui.Editbox(GroupBox_LegitFakeDuck_Extra, "lua_fakeduck_choke2", "14");
local choke_amount3 = gui.Editbox(GroupBox_LegitFakeDuck_Extra, "lua_fakeduck_choke3", "6");
local choke_amount = gui.Editbox(GroupBox_LegitFakeDuck_Extra, "lua_fakeduck_choke", "7");
local shot_delay = gui.Editbox(GroupBox_LegitFakeDuck_Extra, "lua_fakeduck_shotdelay", "0.08");
local count_add = gui.Editbox(GroupBox_LegitFakeDuck_Extra, "lua_fakeduck_addcount", "1");

function fakeduck_shotDelay(UserCmd)
	if not (shot_delay:GetValue() == "" or shot_delay:GetValue() == nil) then
		if input.IsButtonDown(LegitFakeDuck_Keybox:GetValue()) then
			local g_Local = entities.GetLocalPlayer();
			local m_flDuckAmount = g_Local:GetProp("m_flDuckAmount");
			if m_flDuckAmount > tonumber(shot_delay:GetValue()) and (UserCmd:GetButtons() & IN_ATTACK > 0) then
				UserCmd:SetButtons(UserCmd:GetButtons() & ~IN_ATTACK);
			end
		end
	end
end

local should_fakeduck = true;
function doFakeduck(UserCmd)
	if not (choke_amount:GetValue() == "" or choke_amount:GetValue() == nil) or (choke_amount2:GetValue() == "" or choke_amount2:GetValue() == nil) then
		if FastDuck_Checkbox:GetValue() then
			UserCmd:SetButtons(UserCmd:GetButtons() | IN_BULLRUSH);
		end
		if gui.GetValue("rbot_active") and LegitFakeDuck_Keybox:GetValue() == gui.GetValue("rbot_antiaim_fakeduck") then
			should_fakeduck = false
		elseif should_fakeduck ~= true then
			should_fakeduck = true
		end
		if input.IsButtonDown(LegitFakeDuck_Keybox:GetValue()) and should_fakeduck then
			UserCmd:SetSendPacket(false);
			if (count % (round(tonumber(choke_amount2:GetValue()),0)) == 0) then
				do_ = true;
			elseif (count % (round(tonumber(choke_amount2:GetValue()),0)) == round(tonumber(choke_amount3:GetValue()),0)) then
				UserCmd:SetSendPacket(true)
			elseif (count % (round(tonumber(choke_amount2:GetValue()),0)) == round(tonumber(choke_amount:GetValue()),0)) then
				do_ = false;
			end
			if (do_) then
				UserCmd:SetButtons(UserCmd:GetButtons() | IN_DUCK);
			else
				UserCmd:SetButtons(UserCmd:GetButtons() & ~IN_DUCK);
			end
			if (shot_delay:GetValue() ~= "" and shot_delay:GetValue() ~= nil) then
				count = count + count_add:GetValue();
			else
				count = count + 1;
			end
		else
			do_ = false;
			count = 0;
			if FastDuck_Checkbox:GetValue() == false then
				UserCmd:SetButtons(UserCmd:GetButtons() & ~IN_BULLRUSH);
			end
		end
	end
end

callbacks.Register('CreateMove', function(UserCmd)
	local g_Local = entities.GetLocalPlayer();
	if g_Local == nil then
		return;
	end
	if LegitFakeDuck_Keybox:GetValue() > 0 then
		doFakeduck(UserCmd);
		fakeduck_shotDelay(UserCmd);
	end
end)

--[[ Resolver Extras ]]
Resolver_Extras_Ref = lsp.Reference();
GroupBox_Resolver_Extras = gui.Groupbox(Resolver_Extras_Ref, "Resolver Extras", -16, groupbox_pos_left+10, 245, 170);
groupbox_pos_left = groupbox_pos_left+10+170;
local manual_resolve_key = gui.Keybox(GroupBox_Resolver_Extras, "lua_manual_resolve_key", "Manual Resolver", 0);
local legit_resolver = gui.Checkbox(GroupBox_Resolver_Extras, "rbot_autoresolver", "Experimental Legit Resolver", 0);
local auto_resolver_enabled = gui.Checkbox(GroupBox_Resolver_Extras, "rbot_autoresolver", "Automatic Resolver", 0);
local warningEnabled = gui.Checkbox(GroupBox_Resolver_Extras, "rbot_autoresolver_detection", "Desync Detection", 0);
local listEnabled = gui.Checkbox(GroupBox_Resolver_Extras, "rbot_autoresolver_list", "Desync List", 0);
local listExtraInfoEnabled = gui.Checkbox(GroupBox_Resolver_Extras, "rbot_autoresolver_list_extra_info", "Desync List Extra Info", 0);

isDesyncing = {};
lastSimtime = {};
tempChokedTicks = {};
isDesyncing2 = {};
chokedTicks = {};
desyncCooldown = {};
lby_angle = {};
lby_angle2 = {};
flTargetTime = {};
deltaTime = {};
SimTime = {};

local lastTick = 1;
local pLocal = entities.GetLocalPlayer();
local resolverTextCount = 0;
local ListTextWidth, ListTextHeight;
curTargetIdx = nil;

function GetMaxAngle(player)
	VelocityX = player:GetPropFloat("localdata", "m_vecVelocity[0]")
	VelocityY = player:GetPropFloat("localdata", "m_vecVelocity[1]")
	VelocityZ = player:GetPropFloat("localdata", "m_vecVelocity[2]")
	fl_speed = math.sqrt(VelocityX ^ 2 + VelocityY ^ 2)
	maxdesync = (59 - 58 * fl_speed / 580)
	return maxdesync
end

function math_clamp(curVal, minVal, maxVal)
    if curVal < minVal then
        return minVal
    elseif curVal > maxVal then
        return maxVal
    end
    return curVal
end

function aimbotTargetHook(pEntity)
	if auto_resolver_enabled:GetValue() then
		if pEntity == nil then
			return;
		end
		curTargetIdx = pEntity:GetIndex();
	end
end

function drawHook()
	pLocal = entities.GetLocalPlayer();
	if pLocal == nil then
		return;
	end
	if listEnabled:GetValue() then
		if engine.GetMapName() ~= "" and resolverTextCount > 0 then
			draw.Color(240, 240, 255, 150);
			draw.SetFont(desyncing_players_list_font);
			draw.Text(10, 490, "[ Suspicious Players ]")
		end
		ListTextWidth, ListTextHeight = draw.GetTextSize("List Text")
	end

	if auto_resolver_enabled:GetValue() then
		resolverTextCount = 0;
		for pEntityIndex, pEntity in pairs(entities.FindByClass("CCSPlayer")) do
			if not (pEntity:IsAlive()) or pEntity == nil then
				desyncCooldown[pEntityIndex] = nil;
				isDesyncing[pEntityIndex] = false;
				isDesyncing2[pEntityIndex] = false;
			end
			if pEntity:GetTeamNumber() ~= pLocal:GetTeamNumber() and pEntity:IsAlive() and (pEntityIndex ~= pLocal:GetIndex()) then
				TickDiff = globals.TickCount()-lastTick
				if globals.TickCount() == lastTick+1 then
				--print("TickDiff: "..TickDiff)
					if lastSimtime[pEntityIndex] ~= nil then
						if desyncCooldown[pEntityIndex] == nil then
							desyncCooldown[pEntityIndex] = globals.TickCount();
						end
						lby_angle2[pEntityIndex] = math.abs(AngleNormalize2( pEntity:GetProp('m_angEyeAngles[1]') - pEntity:GetProp('m_flLowerBodyYawTarget')));
						--pEntity:GetPropFloat("AnimTimeMustBeFirst",'m_flAnimTime') 
						if pEntity:GetPropFloat("m_flSimulationTime") == lastSimtime[pEntityIndex] then
							lby_angle[pEntityIndex] = math.abs(AngleNormalize2( pEntity:GetProp('m_angEyeAngles[1]') - pEntity:GetProp('m_flLowerBodyYawTarget')));
							if chokedTicks[pEntityIndex] == nil then
								chokedTicks[pEntityIndex] = 1;
								tempChokedTicks[pEntityIndex] = 1;
							else
								chokedTicks[pEntityIndex] = chokedTicks[pEntityIndex]+1;
								tempChokedTicks[pEntityIndex] = tempChokedTicks[pEntityIndex]+1;
							end
							if tempChokedTicks[pEntityIndex] > 40 then
								if (lby_angle[pEntityIndex] >= GetMaxAngle(pEntity)) then
									isDesyncing2[pEntityIndex] = true;
								else
									isDesyncing2[pEntityIndex] = false;
								end
								if isDesyncing[pEntityIndex] ~= true then
									desyncCooldown[pEntityIndex] = globals.TickCount();
								end
								isDesyncing[pEntityIndex] = true;
								if (isDesyncing[pEntityIndex] and desyncCooldown[pEntityIndex] > globals.TickCount()-500) then
									desyncCooldown[pEntityIndex] = desyncCooldown[pEntityIndex]-1;
								end
							else
								isDesyncing[pEntityIndex] = false;
							end
						elseif desyncCooldown[pEntityIndex] <= globals.TickCount()-40 then
							if (isDesyncing[pEntityIndex] and desyncCooldown[pEntityIndex] > globals.TickCount()-400) then
								desyncCooldown[pEntityIndex] = desyncCooldown[pEntityIndex]-1;
							elseif (desyncCooldown[pEntityIndex] <= globals.TickCount()-40) and isDesyncing[pEntityIndex] ~= false then
								tempChokedTicks[pEntityIndex] = 0;
								isDesyncing[pEntityIndex] = false;
								if (lby_angle2[pEntityIndex] >= GetMaxAngle(pEntity)) then
									isDesyncing2[pEntityIndex] = true;
								else
									isDesyncing2[pEntityIndex] = false;
								end
							end
						else
							--print("m_flSimulationTime: "..pEntity:GetPropFloat("m_flSimulationTime").."   lastSimtime[pEntityIndex]: "..lastSimtime[pEntityIndex])
						end
					end
					lastSimtime[pEntityIndex] = pEntity:GetPropFloat("m_flSimulationTime");
				end

				if engine.GetMapName() ~= "" then
					if isDesyncing[pEntityIndex] or isDesyncing2[pEntityIndex] then
						if listEnabled:GetValue() then
							if listExtraInfoEnabled:GetValue() then
								local pos = 510 + (ListTextHeight * resolverTextCount)
								draw.Color(255, 220, 220, 230);
								draw.SetFont(desyncing_players_font);
								draw.Text(15, pos, pEntity:GetName().. " [ Choked Ticks: " .. tempChokedTicks[pEntityIndex].." | LBY: "..lby_angle[pEntityIndex].." ]");
							else
								local pos = 510 + (ListTextHeight * resolverTextCount)
								draw.Color(255, 220, 220, 230);
								draw.SetFont(desyncing_players_font);
								draw.Text(15, pos, pEntity:GetName())
							end
						end
					resolverTextCount = resolverTextCount+1
					end
				end
			end
			if curTargetIdx ~= nil then
				if (isDesyncing2[pEntityIndex] or isDesyncing[pEntityIndex]) and (pEntityIndex == curTargetIdx) and gui.SetValue("rbot_resolver") ~= 1 then
					gui.SetValue("rbot_resolver", 1);
				elseif(isDesyncing2[pEntityIndex] == false or isDesyncing[pEntityIndex] == false) and (pEntityIndex == curTargetIdx) and gui.SetValue("rbot_resolver") ~= 0 then
					gui.SetValue("rbot_resolver", 0);
				end
			end
		end
		lastTick = globals.TickCount();
	end
end

function drawEspHook(builder)
	if warningEnabled:GetValue() then
		local pEntity = builder:GetEntity()
		if entities.GetLocalPlayer() == nil then
			return;
		end
		if pEntity:IsAlive() and pEntity:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber() then
			if isDesyncing2[pEntity:GetIndex()] then
				builder:Color(255, 25, 25, 200);
				builder:AddTextBottom("[ Desync ]");
			elseif isDesyncing[pEntity:GetIndex()] and isDesyncing2[pEntity:GetIndex()] ~= true then
				builder:Color(255, 188, 0, 120);
				builder:AddTextBottom("[ Choking ]");
			end
		end
	end
end
callbacks.Register("Draw", drawHook)
callbacks.Register("AimbotTarget", aimbotTargetHook)
callbacks.Register("DrawESP", drawEspHook)

besttarget = nil;
nearest_target = nil;
nearest_target_dist = nil;
function NearestPlayerCrosshair()
	midx, midy = draw.GetScreenSize();
	midx = midx/2;
	midy = midy/2;
	
	players = entities.FindByClass( "CCSPlayer" );
	lp = entities.GetLocalPlayer();
	if lp == nil or not lp:IsAlive() then
		return;
	end
		besttarget = nil;
		bestdis = 0;
	for i = 1, #players do
		current = players[i];
		if current:IsAlive() and current:GetTeamNumber() ~= lp:GetTeamNumber() then
			sx , sy = client.WorldToScreen(current:GetAbsOrigin());
			if sx ~= nil and sy ~= nil then
				currentdis = math.sqrt((midx - sx)^2 + (midy - sy)^2);
				if besttarget == nil or currentdis < bestdis then
					besttarget = current;
					nearest_target = current;
					bestdis = currentdis;
					nearest_target_dist = currentdis;
				end
			end
		end
	end
end

function getNearestEnemy()
	local enemy_players = entities.FindByClass( "CBaseEntity" );
	
	local own_x, own_y, own_z = entities.GetLocalPlayer():GetAbsOrigin();
	local own_pitch = entities.GetLocalPlayer():GetProp('m_angEyeAngles[0]')
	local own_yaw = entities.GetLocalPlayer():GetProp('m_angEyeAngles[1]')
	local closest_enemy = nil
	local closest_distance = 999999999
	        
	for i = 1, #enemy_players do

		local enemy = enemy_players[i]
		
		if enemy:GetTeamNumber() == entities.GetLocalPlayer():GetTeamNumber() then
			return;
		end
		
		local enemy_x, enemy_y, enemy_z = enemy:GetHitboxPosition(0)
	            
		local x = enemy_x - own_x
		local y = enemy_y - own_y
		local z = enemy_z - own_z 
		local yaw = ((math.atan2(y, x) * 180 / math.pi))
		local pitch = -(math.atan2(z, math.sqrt((x)^2 + (y)^2)) * 180 / math.pi)
		local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
		local pitch_dif = math.abs(own_pitch - pitch ) % 360
            
		if yaw_dif > 180 then yaw_dif = 360 - yaw_dif end
		local real_dif = math.sqrt((yaw_dif)^2 + (pitch_dif)^2)
			if closest_distance > real_dif then
			closest_distance = real_dif
			closest_enemy = enemy
		end
	end
	
	if closest_enemy ~= nil then
		print("closest_enemy: "..closest_enemy:GetName())
		nearest_target = closest_enemy;
		nearest_target_dist = closest_distance;
		return closest_enemy, closest_distance
	end
	return nil, nil
end

lbydiff = {};
resolvedPlayers = {};
function LegitResolve()	
	if legit_resolver:GetValue() then
		pLocal = entities.GetLocalPlayer();
		if pLocal == nil then
			return;
		end
		for pEntityIndex, pEntity in pairs(entities.FindByClass("CCSPlayer")) do
			if pEntityIndex == pLocal:GetIndex() then
				return;
			end
			if manual_resolvedPlayers[pEntityIndex] then
				resolvedPlayers[pEntityIndex] = false;
				return;
			end
			if GetVelocity(pEntity) >= 1 then
				resolvedPlayers[pEntityIndex] = false;
				return;
			end
			if pEntityIndex ~= pLocal:GetIndex() then
				return;
			end
			if resolvedPlayers[pEntityIndex] ~= true then
				lbydiff[pEntityIndex] = AngleNormalize2(pEntity:GetProp('m_angEyeAngles[1]')-pEntity:GetProp('m_flLowerBodyYawTarget'))
			end
			if lbydiff[pEntityIndex] >= 57 then
				pEntity:SetProp("m_flLowerBodyYawTarget",AngleNormalize2(pEntity:GetProp('m_angEyeAngles[1]')+(lbydiff[pEntityIndex])));
				resolvedPlayers[pEntityIndex] = true;
			elseif lbydiff[pEntityIndex] <= -57 then
				pEntity:SetProp("m_flLowerBodyYawTarget",AngleNormalize2(pEntity:GetProp('m_angEyeAngles[1]')+(lbydiff[pEntityIndex])));
				resolvedPlayers[pEntityIndex] = true;
			end
		end
	end
end
callbacks.Register("Draw","Legit Resolve",LegitResolve);

manual_lbydiff = {};
manual_resolvedPlayers = {};
manual_angeldir = {};
manual_press_count = {};
function manualResolve()
	if manual_resolve_key:GetValue() ~= 0 then
		if pLocal == nil then
			return;
		end
		NearestPlayerCrosshair();
		for manual_resolvedPlayerIndex, manual_resolvedPlayer in pairs(manual_resolvedPlayers) do
			local mEnt = entities.GetByIndex(manual_resolvedPlayerIndex);
			if mEnt == nil then
				return;
			end
			if not (mEnt:IsAlive()) then
				manual_resolvedPlayers[manual_resolvedPlayerIndex] = false;
			end
			if manual_angeldir[manual_resolvedPlayerIndex] == "Left" then
				mEnt:SetProp("m_flLowerBodyYawTarget",AngleNormalize2(mEnt:GetProp('m_angEyeAngles[1]')-GetMaxAngle(mEnt)));
			elseif manual_angeldir[manual_resolvedPlayerIndex] == "Right" then
				mEnt:SetProp("m_flLowerBodyYawTarget",AngleNormalize2(mEnt:GetProp('m_angEyeAngles[1]')+GetMaxAngle(mEnt)));
			elseif manual_angeldir[manual_resolvedPlayerIndex] == "Off" then
				mEnt:SetProp("m_flLowerBodyYawTarget",mEnt:GetProp('m_angEyeAngles[1]'));
				manual_angeldir[manual_resolvedPlayerIndex] = "";
			end
		end
		if input.IsButtonReleased(manual_resolve_key:GetValue()) then
			if besttarget == nil then
				return;
			end
			if manual_press_count[besttarget:GetIndex()] == nil then
				manual_press_count[besttarget:GetIndex()] = 0;
			end
			if besttarget == nil or besttarget:GetIndex() == pLocal:GetIndex() then
				return;
			end
			manual_lbydiff[besttarget:GetIndex()] = AngleNormalize2(besttarget:GetProp('m_angEyeAngles[1]')-besttarget:GetProp('m_flLowerBodyYawTarget'))
			if manual_press_count[besttarget:GetIndex()] == 2 then
				manual_angeldir[besttarget:GetIndex()] = "Off";
				manual_resolvedPlayers[besttarget:GetIndex()] = false;
				manual_press_count[besttarget:GetIndex()] = 0;
			elseif manual_angeldir[besttarget:GetIndex()] == "Left" then
				manual_angeldir[besttarget:GetIndex()] = "Right";
				manual_resolvedPlayers[besttarget:GetIndex()] = true;
				manual_press_count[besttarget:GetIndex()] = manual_press_count[besttarget:GetIndex()] + 1;
			elseif manual_angeldir[besttarget:GetIndex()] == "Right" then
				manual_angeldir[besttarget:GetIndex()] = "Left";
				manual_resolvedPlayers[besttarget:GetIndex()] = true;
				manual_press_count[besttarget:GetIndex()] = manual_press_count[besttarget:GetIndex()] + 1;
			elseif manual_lbydiff[besttarget:GetIndex()] >= 57 then --L
				manual_angeldir[besttarget:GetIndex()] = "Right";
				manual_resolvedPlayers[besttarget:GetIndex()] = true;
				manual_press_count[besttarget:GetIndex()] = manual_press_count[besttarget:GetIndex()] + 1;
			elseif manual_lbydiff[besttarget:GetIndex()] <= -57 then --R
				manual_angeldir[besttarget:GetIndex()] = "Left";
				manual_resolvedPlayers[besttarget:GetIndex()] = true;
				manual_press_count[besttarget:GetIndex()] = manual_press_count[besttarget:GetIndex()] + 1;
			else
				manual_angeldir[besttarget:GetIndex()] = "Left";
				manual_resolvedPlayers[besttarget:GetIndex()] = true;
				manual_press_count[besttarget:GetIndex()] = manual_press_count[besttarget:GetIndex()] + 1;
			end
		end
	end
end
callbacks.Register("Draw","manual Resolve",manualResolve);

function drawSetPlayer(builder)
	local pEntity = builder:GetEntity()
	if resolvedPlayers[pEntity:GetIndex()] and pEntity:IsAlive() then
		builder:Color(235, 25, 25, 170);
		builder:AddTextBottom("[ Resolved ]");
	elseif manual_resolvedPlayers[pEntity:GetIndex()] then
		builder:Color(25, 25, 235, 170);
		builder:AddTextBottom("[ Manual "..manual_angeldir[pEntity:GetIndex()].." ]");
	end
end
callbacks.Register("DrawESP", drawSetPlayer)

--[[ Legit Bot On Key ]]
lbotkey_Ref = lsp.Reference()
GroupBox_lbotkey_Extra = gui.Groupbox(lbotkey_Ref, "LegitBot On Key", -16, groupbox_pos_left+10, 245, 75)
groupbox_pos_left = groupbox_pos_left+10+75
lbotkey_enable = gui.Checkbox(GroupBox_lbotkey_Extra, "lua_lbot_on_key_enable", "Enable", 0)
LbotFireKey = gui.Keybox(GroupBox_lbotkey_Extra, "lua_lbot_onkey_key", "On Key", 0);
b_lbotkey_active = false;
rbot_trigger_on = false;

function lbot_on_key()
	if lbotkey_enable:GetValue() and LbotFireKey:GetValue() ~= 0 then
		matchAntiAim();
		if LbotFireKey <= 0 then
			b_lbotkey_active = false;
			return;
		end
		if input.IsButtonDown(LbotFireKey:GetValue()) then
			b_lbotkey_active = true;
			gui.SetValue("rbot_active",0);
			gui.SetValue("lbot_active",1);
		elseif b_lbotkey_active then
			b_lbotkey_active = false;
			gui.SetValue("rbot_active",1);
			gui.SetValue("lbot_active",0);
			if not rbot_trigger_on then
				gui.SetValue("rbot_enable",0);
			end
			b_lbotkey_active = false;
		end	
	elseif b_lbotkey_active ~= false then
		b_lbotkey_active = false;
	end
end
callbacks.Register("Draw","LBotOnKey",lbot_on_key);

--[[ Rage Trigger Groupbox ]]
local Rt_Extra_Ref = lsp.Reference()
GroupBox_Rt_Extra = gui.Groupbox(Rt_Extra_Ref, "Rage Trigger", -16, groupbox_pos_left+10, 245, 440)
groupbox_pos_left = groupbox_pos_left+10+440
local Trigger_Active = gui.Checkbox(GroupBox_Rt_Extra, "lua_rbot_trg_enable", "Rage Trigger", 0)
local Trigger_Toggle = gui.Checkbox(GroupBox_Rt_Extra, "lua_rbot_toggle_enable", "Toggle Mode", 0)
local Trigger_Key = gui.Keybox(GroupBox_Rt_Extra, "lua_lbot_rage_key", "Rage Key", 0)
local Trigger_Key2 = gui.Keybox(GroupBox_Rt_Extra, "lua_lbot_rage_key2", "Rage Key 2", 0)
local Trigger_Key3 = gui.Keybox(GroupBox_Rt_Extra, "lua_lbot_rage_key3", "Rage Key 3", 0)
local AutoWallTrigger_Key = gui.Keybox(GroupBox_Rt_Extra, "lua_lbot_rage_aw_key", "AutoWall Rage Key", 0)
local LegitAutoWall_Enable = gui.Checkbox(GroupBox_Rt_Extra, "lua_rbot_legitautowall_enable", "Legit Auto Wall", 0)
local Dynamic_Fov_Mode = gui.Combobox(GroupBox_Rt_Extra, "lua_rbot_dynamicfov_mode", "Dynamic Fov", "Off","Static", "Auto");
local Dynamic_Fov_Draw = gui.Checkbox(GroupBox_Rt_Extra, "lua_rbot_dynamicfov_draw", "Draw Dynamic Fov", 0)
local Dynamic_Fov_Max = gui.Slider(GroupBox_Rt_Extra, "lua_rbot_dynamicfov_max","Dynamic Fov Max", 0,0,180);
local Dynamic_Fov_Min = gui.Slider(GroupBox_Rt_Extra, "lua_rbot_dynamicfov_min","Dynamic Fov Min", 0,0,180);
local Dynamic_Fov_Auto_Factor = gui.Slider(GroupBox_Rt_Extra, "lua_rbot_dynamicfov_auto_factor","Dynamic Fov Auto Factor", 30,0,250);
local onNextShot = gui.Checkbox(GroupBox_Rt_Extra, "lua_rbot_trg_nextshot", "On Next Primary Attack", 0)
local rt_delay_timer = gui.Slider(GroupBox_Rt_Extra, "lua_rbot_trg_delay","Target Switch Delay", 0.0,0,1.0);

--[[ Legit Auto Wall ]]
aw_x1, aw_y1, aw_z1 = nil;
aw_z = nil;
aw_clientx, aw_clienty, aw_clientz = nil;
function entities_check(l_aw_target)
   local LocalPlayer = entities.GetLocalPlayer();

   if LocalPlayer ~= nil then
       aw_x1, aw_y1, aw_z1 = LocalPlayer:GetAbsOrigin()
       if (math.floor((entities.GetLocalPlayer():GetPropInt("m_fFlags") % 4) / 2) == 1) then
           aw_z = 46
       else
           aw_z = 64
       end
       aw_clientx, aw_clienty, aw_clientz = client.WorldToScreen(aw_x1, aw_y1, aw_z1 + aw_z)
       return LocalPlayer
   end
end

function body_vis(l_aw_target)
  local body = false
      local t3 = 0
      local t4 = 0
      local stomach = 0
      for i = 2, 3 do
          if i == 3 then
              stomach = -5
          end
          local x2, y2, z2 = l_aw_target:GetHitboxPosition(i)
          if x2 ~= nil then
               for x = -6, 6, 6 do
                  local c = engine.TraceLine(aw_x1, aw_y1, aw_z1 + aw_z, x2 - (x / 2), y2, z2 + stomach, 1);
                  t3 = c + i + t3
                  t4 = t4 + i + 1
              end
          end
      end
       if t3 < t4 then
          body = true
      else
          body = false
      end
  return body
end

function head_vis(l_aw_target)
   local head = false
       local t3 = 0
       local t4 = 0
       for i = -2, 2, 2 do
           local x2, y2, z2 = l_aw_target:GetHitboxPosition(0)
           if x2 ~= nil then
               local c = engine.TraceLine(aw_x1, aw_y1, aw_z1 + aw_z, x2 - i, y2, z2 + 4, 1);
               t3 = c + i + t3
               t4 = t4 + i + 1
           end
       end
       if t3 < t4 then
           head = true
       else
           head = false
       end
   return head
end

function feet_vis(l_aw_target)
   local feet = false
       local t3 = 0
       local t4 = 0
       for i = 6, 7 do
           local x2, y2, z2 = l_aw_target:GetHitboxPosition(i)
           if x2 ~= nil then
               local c = engine.TraceLine(aw_x1, aw_y1, aw_z1 + aw_z, x2, y2, z2, 1);
               t3 = c + i + t3
               t4 = t4 + i + 1
           end
       end
       if t3 < t4 then
           feet = true
       else
           feet = false
       end
   end
   if feet then
   return feet
end

l_aw_target_vis = false;
function curTargetIdx_vis()
	if LegitAutoWall_Enable:GetValue() then
		--local vis = false
		--[[if mode == 0 then
			if not head_vis(curTargetIdx) then
				vis = false
			else
				vis = true
			end
		end
		if mode == 1 then
			if not head_vis(curTargetIdx) and not body_vis(curTargetIdx) then
				vis = false
			else
				vis = true
			end
		end
		if mode == 2 then]]
		aimBotTarget = entities.GetByIndex(curTargetIdx);
		if aimBotTarget ~= nil and entities_check(aimBotTarget) ~= nil then
			if aimBotTarget:IsAlive() ~= true then
				return;
			end
			if not feet_vis(aimBotTarget) and not head_vis(aimBotTarget) and not body_vis(aimBotTarget) then
				vis = false
			else
				vis = true
			end
		end
		NearestPlayerCrosshair();
		if nearest_target ~= nil and entities_check(nearest_target) ~= nil then
			if nearest_target:IsAlive() ~= true then
				return;
			end
			if not feet_vis(nearest_target) and not head_vis(nearest_target) and not body_vis(nearest_target) then
				l_aw_target_vis = false
			else
				l_aw_target_vis = true
			end
		end
		return l_aw_target_vis
	end
end
callbacks.Register("Draw", "curTargetIdx_vis", curTargetIdx_vis);

local l_aw_off;
function LegitAutoWall()
	if LegitAutoWall_Enable:GetValue() then
		if l_aw_target_vis then
			if l_aw_off then
				gui.SetValue("rbot_shared_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_pistol_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_revolver_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_smg_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_rifle_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_shotgun_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_scout_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_autosniper_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("rbot_sniper_autowall",autowall_mode:GetValue()+1);	
				gui.SetValue("lbot_pistol_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("lbot_smg_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("lbot_rifle_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("lbot_shotgun_autowall",autowall_mode:GetValue()+1);
				gui.SetValue("lbot_sniper_autowall",autowall_mode:GetValue()+1);
				l_aw_off = false;
				print("on")
			end
		else
			if l_aw_off ~= true then
				gui.SetValue("rbot_shared_autowall",0);
				gui.SetValue("rbot_pistol_autowall",0);
				gui.SetValue("rbot_revolver_autowall",0);
				gui.SetValue("rbot_smg_autowall",0);
				gui.SetValue("rbot_rifle_autowall",0);
				gui.SetValue("rbot_shotgun_autowall",0);
				gui.SetValue("rbot_scout_autowall",0);
				gui.SetValue("rbot_autosniper_autowall",0);
				gui.SetValue("rbot_sniper_autowall",0);	
				gui.SetValue("lbot_pistol_autowall",0);
				gui.SetValue("lbot_smg_autowall",0);
				gui.SetValue("lbot_rifle_autowall",0);
				gui.SetValue("lbot_shotgun_autowall",0);
				gui.SetValue("lbot_sniper_autowall",0);
				print("off")
				l_aw_off = true;
			end
			
		end
	end
end
callbacks.Register("Draw", "Legit Auto Wall", LegitAutoWall);

--[[ Dynamic FOV ]]
local dynamicfov_new_fov = 0
function doDynamicFOV()
	if Dynamic_Fov_Mode:GetValue() ~= 0 then
		local local_player = entities.GetLocalPlayer();
	 	local old_fov = gui.GetValue("rbot_fov");
	    local min_fov = Dynamic_Fov_Min:GetValue();
	    local max_fov = Dynamic_Fov_Max:GetValue();
		
		if local_player == nil then
			return;
		end
		
		NearestPlayerCrosshair();

	    local own_x, own_y, own_z = local_player:GetAbsOrigin()
 
		if nearest_target ~= nil then
			local nearest_target_x, nearest_target_y, nearest_target_z = nearest_target:GetHitboxPosition(0)
			if nearest_target_x == nil then
				return;
			end
			local real_distance = math.sqrt((own_x - nearest_target_x)^2 + (own_y - nearest_target_y)^2 + (own_z - nearest_target_z)^2)
			if Dynamic_Fov_Mode:GetValue() == 1 then
				dynamicfov_new_fov = max_fov - ((max_fov - min_fov) * (real_distance - 250) / 1000)
			elseif Dynamic_Fov_Mode:GetValue() == 2  then
				dynamicfov_new_fov = (3800 / real_distance) * (Dynamic_Fov_Auto_Factor:GetValue() * 0.01)
			end
			if (dynamicfov_new_fov > max_fov) then
				dynamicfov_new_fov = max_fov
			elseif dynamicfov_new_fov < min_fov then
				dynamicfov_new_fov = min_fov
			end
	    else 
	        dynamicfov_new_fov = min_fov
	    end

	    dynamicfov_new_fov = round(dynamicfov_new_fov, 0)
	    if dynamicfov_new_fov ~= old_fov then
			gui.SetValue("rbot_fov", dynamicfov_new_fov)
	    end
	end
end
callbacks.Register( 'Draw', 'Dynamic FOV', doDynamicFOV )

function draw_Circle(x, y, radius, r, g, b, a)
	for i = 1, 360 do
	  local angle = i * math.pi / 180
	  local ptx, pty = x + radius * math.cos( angle ), y + radius * math.sin( angle )
	  draw.Color(r, g, b, a);
	  draw.Line( ptx, pty, ptx-1, pty-1 )
	end
end

function doDynamicFOV_Draw()
	if (Dynamic_Fov_Mode:GetValue() ~= 0 and Dynamic_Fov_Draw:GetValue()) then
		local screen_width, screen_height = draw.GetScreenSize();
		local screen_width_mid, screen_height_mid = screen_width/2, screen_height/2
		local vm_fov = client.GetConVar('viewmodel_fov')
		local fov_radius = dynamicfov_new_fov / vm_fov * screen_width / 2
		draw_Circle(screen_width/2, screen_height/2, fov_radius-2, 200,200,200,200)
	end
end
callbacks.Register( 'Draw', 'Dynamic FOV Draw', doDynamicFOV_Draw )

--[[ Target Switch Delay ]]
local input_toggled = false;
local can_shoot;
local should_delay = false;
local function killed_player( Event )
	if rt_delay_timer:GetValue() ~= 0 then
	
		local lp = entities.GetLocalPlayer();
		if (lp == nil) then
			return;
		end
		if ( Event:GetName() == "player_death" ) then
			local ME = client.GetLocalPlayerIndex()
			local INT_UID = Event:GetInt( "userid" )
			local INT_ATTACKER = Event:GetInt( "attacker" )
			local NAME_Victim = client.GetPlayerNameByUserID( INT_UID )
			local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID )
			local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER )
			local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER )
			if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then
				if should_delay ~= true then
					should_delay = true;
				elseif should_delay ~= false then
					should_delay = false;
				end
			end
		end
	end
end
client.AllowListener( "player_death" )
callbacks.Register( "FireGameEvent", "killed player", killed_player )

callbacks.Register('CreateMove', function(UserCmd)
	local local_player = entities.GetLocalPlayer()
	if local_player == nil then
		return
	end
	local weapon = local_player:GetPropEntity("m_hActiveWeapon")
	if weapon == nil then
		return
	end
	local m_flNextPrimaryAttack = weapon:GetPropFloat("LocalActiveWeaponData", "m_flNextPrimaryAttack")
	--local m_nTickBase = local_player:GetProp("localdata","m_nTickBase");
	local pWepType = local_player:GetWeaponType()
	can_shoot = (m_flNextPrimaryAttack < globals.CurTime()+globals.TickInterval())
	if engine.GetServerIP() == "loopback" then
		can_shoot = (m_flNextPrimaryAttack < globals.CurTime()+globals.TickInterval())
	elseif pWepType == 2 then --[[ mps ]]
		can_shoot = (m_flNextPrimaryAttack < globals.CurTime()+globals.TickInterval()+0.08)
	else
		can_shoot = (m_flNextPrimaryAttack < globals.CurTime()+globals.TickInterval()+0.099)
	end
end)

function rbot_enable()
	gui.SetValue( "rbot_enable", 1)
end

function rbot_disable()
	gui.SetValue( "rbot_enable", 0)
end

function rbot_active()
	if b_lbotkey_active == false then
		gui.SetValue( "rbot_active", 1)
	end
end

function matchAntiAim()
	stand = gui.GetValue( "rbot_antiaim_stand_desync")
	move = gui.GetValue( "rbot_antiaim_move_desync")
	edge = gui.GetValue( "rbot_antiaim_edge_desync")
	if gui.GetValue( "lbot_antiaim") > 0 then
		gui.SetValue( "rbot_antiaim_enable",1 )
		gui.SetValue( "rbot_antiaim_stand_real", 0)
		gui.SetValue( "rbot_antiaim_move_real", 0)
		gui.SetValue( "rbot_antiaim_edge_real", 0)
		gui.SetValue( "rbot_antiaim_stand_pitch_real", 0)
		gui.SetValue( "rbot_antiaim_move_pitch_real", 0)
		gui.SetValue( "rbot_antiaim_edge_pitch_real", 0)
		gui.SetValue( "rbot_antiaim_at_targets", 0)
		gui.SetValue( "rbot_antiaim_autodir", 0)
		gui.SetValue( "rbot_antiaim_on_dormant", 1)		
		gui.SetValue( "rbot_antiaim_stand_desync", gui.GetValue( "lbot_antiaim"))
		gui.SetValue( "rbot_antiaim_move_desync", gui.GetValue( "lbot_antiaim"))
		gui.SetValue( "rbot_antiaim_edge_desync", gui.GetValue( "lbot_antiaim"))
	elseif stand ~= 0 or move ~= 0 or edge ~= 0 then
		gui.SetValue( "rbot_antiaim_stand_desync", 0)
		gui.SetValue( "rbot_antiaim_move_desync", 0)
		gui.SetValue( "rbot_antiaim_edge_desync", 0)
	end
end

function rbot_deactive()
	rbot_trigger_on = false;
	if not lbotkey_enable:GetValue() then
		if gui.GetValue( "rbot_active") then
			should_delay = false;
			gui.SetValue( "rbot_active", 0);
		end
	end
end

rbot_aimkey_val = 0;
rbot_aimkey_saved = false;
function restore_rbot_aimkey()
	if rbot_aimkey_saved then
		rbot_aimkey_saved = false;
		gui.SetValue("rbot_aimkey", rbot_aimkey_val);
	end
end

function disable_rbot_aimkey()
	if bot_aimkey_saved ~= true then
		bot_aimkey_saved = true;
		rbot_aimkey_val = gui.GetValue("rbot_aimkey");
	end
	if gui.GetValue("rbot_aimkey") > 0 then
		gui.SetValue("rbot_aimkey", 0);
	end
end

local timer_started = false;
local function triggerFunc()
	rbot_trigger_on = true
	matchAntiAim();
	if onNextShot:GetValue() then
		if can_shoot then
			if (rt_delay_timer:GetValue() ~= 0 ) then
				if should_delay and timer_started ~= true then
					timer_started = true
					mario_timer.Create("target_delay", rt_delay_timer:GetValue(), 1, function()
						should_delay = false;
					end)
					rbot_disable()
				elseif should_delay == false then
					timer_started = false;
					rbot_enable();
				end
			else
				rbot_enable();
			end
		elseif (gui.GetValue( "rbot_enable") ~= 0) then
			rbot_disable();
		end
	elseif (rt_delay_timer:GetValue() ~= 0 ) then
		if should_delay and timer_started ~= true then
			timer_started = true;
			mario_timer.Create("target_delay2", rt_delay_timer:GetValue(), 1, function()
				should_delay = false;
			end)
			rbot_disable();
		elseif should_delay ~= true then
			timer_started = false;
			rbot_enable();
		end
	else
		rbot_enable();
	end
	rbot_active();
end

--[[ Rage Trigger ]]
local current_target;
ky1,ky2,ky3,awky,rbotkey = false,false,false,false,false;
local toggle1,toggle2,toggle3 = false,false,false;
local SetWepCfg;
function RageTrigger(UserCmd)
	local rbot_shared = gui.GetValue("rbot_sharedweaponcfg")
	local rbot_shared_autowall = gui.GetValue("rbot_shared_autowall")
	local local_player = entities.GetLocalPlayer()
	
	if local_player == nil then
		return
	end
		
	local pWepId = local_player:GetWeaponID()
	local pWepType = local_player:GetWeaponType()

	if Trigger_Active:GetValue() then
		matchAntiAim()
		if toggle1 then
			disable_rbot_aimkey();
			triggerFunc();
		elseif toggle2 then
			disable_rbot_aimkey();
			triggerFunc();
		elseif toggle3 then
			disable_rbot_aimkey();
			triggerFunc();
		end
		if gui.GetValue("rbot_aimkey") > 0 then
			if input.IsButtonDown(gui.GetValue("rbot_aimkey")) and not (ky3 or ky2 or ky1 or awky) then
				triggerFunc();
				rbotkey = true;
			elseif rbotkey then
				rbotkey = false;
				rbot_deactive();
				rbot_disable();
			end
		end
		if AutoWallTrigger_Key:GetValue() ~= 0 then
			if input.IsButtonDown(AutoWallTrigger_Key:GetValue()) and not (ky3 or ky2 or ky1 or rbotkey) then
				disable_rbot_aimkey();
				awky = true;
				SetAutoWallOn();
				awtogglecount=2;
				triggerFunc();
			elseif awky then
				awky = false;
				SetAutoWallOff();
				awtogglecount=1;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			end
		end
		if Trigger_Toggle:GetValue() ~= true and toggle1 then
			toggle1 = false;
		end
		if Trigger_Key:GetValue() ~= 0 then
			if Trigger_Toggle:GetValue() ~= true and input.IsButtonDown(Trigger_Key:GetValue()) and not (ky3 or ky2 or awky or rbotkey) then
				disable_rbot_aimkey();
				triggerFunc();
				ky1 = true;
			elseif ky1 and Trigger_Toggle:GetValue() ~= true then
				ky1 = false;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			elseif Trigger_Toggle:GetValue() and toggle1 == false and input.IsButtonPressed(Trigger_Key:GetValue()) and not (ky3 or ky2 or awky or rbotkey) then
				ky1 = true;
				toggle1 = true;
			elseif Trigger_Toggle:GetValue() and toggle1 and ky1 and input.IsButtonPressed(Trigger_Key:GetValue()) and not (ky3 or ky2 or awky or rbotkey) then
				ky1 = false;
				toggle1 = false;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			end
		end
		if Trigger_Key2:GetValue() ~= 0 then
			if Trigger_Toggle:GetValue() ~= true and input.IsButtonDown(Trigger_Key2:GetValue()) and not (ky1 or ky3 or awky or rbotkey) then
				disable_rbot_aimkey();
				triggerFunc();
				ky2 = true;
			elseif Trigger_Toggle:GetValue() ~= true and ky2 then
				ky2 = false;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			elseif Trigger_Toggle:GetValue() and toggle1 == false and input.IsButtonPressed(Trigger_Key:GetValue()) and not (ky1 or ky3 or awky or rbotkey) then
				ky2 = true;
				toggle2 = true;
			elseif Trigger_Toggle:GetValue() and toggle1 and ky1 and input.IsButtonPressed(Trigger_Key:GetValue()) and not (ky1 or ky3 or awky or rbotkey) then
				ky2 = false;
				toggle2 = false;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			end
		end
		if Trigger_Key3:GetValue() ~= 0 then
			if Trigger_Toggle:GetValue() ~= true and input.IsButtonDown(Trigger_Key3:GetValue()) and not (ky1 or ky2 or awky or rbotkey) then
				disable_rbot_aimkey();
				triggerFunc();
				ky3 = true;
			elseif Trigger_Toggle:GetValue() ~= true and ky3 then
				ky3 = false;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			elseif Trigger_Toggle:GetValue() and toggle1 == false and input.IsButtonPressed(Trigger_Key:GetValue()) and not (ky1 or ky2 or awky or rbotkey) then
				ky3 = true;
				toggle3 = true;
			elseif Trigger_Toggle:GetValue() and toggle1 and ky1 and input.IsButtonPressed(Trigger_Key:GetValue()) and not (ky1 or ky2 or awky or rbotkey) then
				ky3 = false;
				toggle3 = false;
				rbot_deactive();
				rbot_disable();
				restore_rbot_aimkey();
			end
		end
	end	
	drawRbotTriggerIndicator();
end
callbacks.Register( 'Draw', 'Rage Trigger', RageTrigger )

local aw_Main=lsp.Reference();
GroupBox_aw_Main = gui.Groupbox(aw_Main, "AutoWall On Key", -16, groupbox_pos_left+10, 245, 220);
groupbox_pos_left = groupbox_pos_left+10+220
local awtoggle=gui.Keybox(GroupBox_aw_Main, "lbot_extra_awtoggle", "Toggle Autowall", 0);
autowall_mode = gui.Combobox(GroupBox_aw_Main, "lbot_extra_keymode_awmode", "AutoWall Mode", "Accurate", "Optimized");
Key_mode_aw = gui.Combobox(GroupBox_aw_Main, "lbot_extra_keymode_aw", "Key Mode AutoWall", "Toggle", "Hold");
forcebaim_key=gui.Keybox(GroupBox_aw_Main, "forcebaim_key", "Force Baim", 0);
Key_mode_baim = gui.Combobox(GroupBox_aw_Main, "lbot_extra_keymode_baim", "Key Mode ForceBaim", "Toggle", "Hold");
forcebaim_set_value = gui.SetValue
forcebaim_get_value = gui.GetValue
forcebaim_state = false

local hBox_priority,hBox_head,hBox_neck,hBox_chest,hBox_stomach,hBox_pelvis,hBox_arms,hBox_legs,hBox_walking,hBox_priority1,hBox_head1,hBox_neck1,hBox_chest1,hBox_stomach1,hBox_pelvis1,hBox_arms1,hBox_legs1,hBox_walking1,hBox_priority2,hBox_head2,hBox_neck2,hBox_chest2,hBox_stomach2,hBox_pelvis2,hBox_arms2,hBox_legs2,hBox_walking2,hBox_priority3,hBox_head3,hBox_neck3,hBox_chest3,hBox_stomach3,hBox_pelvis3,hBox_arms3,hBox_legs3,hBox_walking3,hBox_priority4,hBox_head4,hBox_neck4,hBox_chest4,hBox_stomach4,hBox_pelvis4,hBox_arms4,hBox_legs4,hBox_walking4,hBox_walking11,hBox_priority5,hBox_head5,hBox_neck5,hBox_chest5,hBox_stomach5,hBox_pelvis5,hBox_arms5,hBox_legs5,hBox_walking5,hBox_priority6,hBox_head6,hBox_neck6,hBox_chest6,hBox_stomach6,hBox_pelvis6,hBox_arms6,hBox_legs6,hBox_walking6,hBox_priority7,hBox_head7,hBox_neck7,hBox_chest7,hBox_stomach7,hBox_pelvis7,hBox_arms7,hBox_legs7,hBox_walking7,hBox_priority8,hBox_head8,hBox_neck8,hBox_chest8,hBox_stomach8,hBox_pelvis8,hBox_arms8,hBox_legs8,hBox_walking8,hBox_priority9,hBox_head9,hBox_neck9,hBox_chest9,hBox_stomach9,hBox_pelvis9,hBox_arms9,hBox_legs9,hBox_walking9 = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;

local LeftCount=0;
local RightCount=0;
local ControlleCount=0;
awtogglecount=0;
local button_down = false;
local b_aw_toggle;

function SetAutoWallOn()
	if b_aw_toggle ~= true then
		gui.SetValue("rbot_shared_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_pistol_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_revolver_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_smg_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_rifle_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_shotgun_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_scout_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_autosniper_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("rbot_sniper_autowall",autowall_mode:GetValue()+1);	
		gui.SetValue("lbot_pistol_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("lbot_smg_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("lbot_rifle_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("lbot_shotgun_autowall",autowall_mode:GetValue()+1);
		gui.SetValue("lbot_sniper_autowall",autowall_mode:GetValue()+1);
		b_aw_toggle = true
	end
end

function SetAutoWallOff()
	if b_aw_toggle ~= false then
		gui.SetValue("rbot_shared_autowall",0);
		gui.SetValue("rbot_pistol_autowall",0);
		gui.SetValue("rbot_revolver_autowall",0);
		gui.SetValue("rbot_smg_autowall",0);
		gui.SetValue("rbot_rifle_autowall",0);
		gui.SetValue("rbot_shotgun_autowall",0);
		gui.SetValue("rbot_scout_autowall",0);
		gui.SetValue("rbot_autosniper_autowall",0);
		gui.SetValue("rbot_sniper_autowall",0);
		gui.SetValue("rbot_lmg_autowall",0);	
		gui.SetValue("lbot_pistol_autowall",0);
		gui.SetValue("lbot_smg_autowall",0);
		gui.SetValue("lbot_rifle_autowall",0);
		gui.SetValue("lbot_shotgun_autowall",0);
		gui.SetValue("lbot_sniper_autowall",0);
		b_aw_toggle = false;
	end
end


function autowall_toggle()
	local w, h = draw.GetScreenSize();
	draw.SetFont(rifk7_font)

	-- Autowall
	if awtoggle:GetValue()~= 0 then
		if Key_mode_aw:GetValue() == 0 then
			--[[ Toggle ]]
			if input.IsButtonPressed(awtoggle:GetValue()) then
				awtogglecount=awtogglecount+1;
			end
		elseif Key_mode_aw:GetValue() == 1 then
			--[[ Hold ]]
			if input.IsButtonDown(awtoggle:GetValue()) and button_down ~= true then
				button_down = true;
				awtogglecount=2;
			elseif input.IsButtonReleased(awtoggle:GetValue()) and button_down == true then
				button_down = false;
				awtogglecount=1;
			end
		end
	elseif awtogglecount ~= 0 then
		awtogglecount=0;
	end
	if entities.GetLocalPlayer() ~= nil then
		doDrawIndicatorAW();
	end
	if awtogglecount==1 then
		SetAutoWallOff();
	elseif awtogglecount==2 then
		SetAutoWallOn();
	else
		awtogglecount=1;
	end	
	draw.SetFont(normal);
end

hBox_priority = forcebaim_get_value("rbot_autosniper_hitbox");hBox_head = forcebaim_get_value("rbot_autosniper_hitbox_head");hBox_neck = forcebaim_get_value("rbot_autosniper_hitbox_neck")hBox_chest = forcebaim_get_value("rbot_autosniper_hitbox_chest")hBox_stomach = forcebaim_get_value("rbot_autosniper_hitbox_stomach")hBox_pelvis = forcebaim_get_value("rbot_autosniper_hitbox_pelvis")hBox_arms = forcebaim_get_value("rbot_autosniper_hitbox_arms")hBox_legs = forcebaim_get_value("rbot_autosniper_hitbox_legs")hBox_walking = forcebaim_get_value("rbot_autosniper_headifwalking")

hBox_priority1 = forcebaim_get_value("rbot_sniper_hitbox")hBox_head1 = forcebaim_get_value("rbot_sniper_hitbox_head")hBox_neck1 = forcebaim_get_value("rbot_sniper_hitbox_neck")hBox_stomach1 = forcebaim_get_value("rbot_sniper_hitbox_stomach")hBox_pelvis1 = forcebaim_get_value("rbot_sniper_hitbox_pelvis")hBox_arms1 = forcebaim_get_value("rbot_sniper_hitbox_arms")hBox_walking1 = forcebaim_get_value("rbot_sniper_headifwalking")
	 
hBox_priority2 = forcebaim_get_value("rbot_scout_hitbox")hBox_head2 = forcebaim_get_value("rbot_scout_hitbox_head")hBox_chest2 = forcebaim_get_value("rbot_scout_hitbox_chest")hBox_stomach2 = forcebaim_get_value("rbot_scout_hitbox_stomach")hBox_pelvis2 = forcebaim_get_value("rbot_scout_hitbox_pelvis")hBox_legs2 = forcebaim_get_value("rbot_scout_hitbox_legs")hBox_walking2 = forcebaim_get_value("rbot_scout_headifwalking")
	 
hBox_priority3 = forcebaim_get_value("rbot_rifle_hitbox")hBox_head3 = forcebaim_get_value("rbot_rifle_hitbox_head")hBox_chest3 = forcebaim_get_value("rbot_rifle_hitbox_chest")hBox_stomach3 = forcebaim_get_value("rbot_rifle_hitbox_stomach")hBox_arms3 = forcebaim_get_value("rbot_rifle_hitbox_arms")hBox_legs3 = forcebaim_get_value("rbot_rifle_hitbox_legs")hBox_walking3 = forcebaim_get_value("rbot_rifle_headifwalking")
	 
hBox_priority4 = forcebaim_get_value("rbot_pistol_hitbox")hBox_head4 = forcebaim_get_value("rbot_pistol_hitbox_head")hBox_neck4 = forcebaim_get_value("rbot_pistol_hitbox_neck")hBox_stomach4 = forcebaim_get_value("rbot_pistol_hitbox_stomach")hBox_arms4 = forcebaim_get_value("rbot_pistol_hitbox_arms")hBox_walking4 = forcebaim_get_value("rbot_pistol_headifwalking")hBox_walking11 = forcebaim_get_value("rbot_pistol_headifwalking")
	 
hBox_priority5 = forcebaim_get_value("rbot_revolver_hitbox")hBox_head5 = forcebaim_get_value("rbot_revolver_hitbox_head")hBox_neck5 = forcebaim_get_value("rbot_revolver_hitbox_neck")hBox_chest5 = forcebaim_get_value("rbot_revolver_hitbox_chest")hBox_stomach5 = forcebaim_get_value("rbot_revolver_hitbox_stomach")hBox_arms5 = forcebaim_get_value("rbot_revolver_hitbox_arms")hBox_legs5 = forcebaim_get_value("rbot_revolver_hitbox_legs")hBox_walking5 = forcebaim_get_value("rbot_revolver_headifwalking")
	 
hBox_priority6 = forcebaim_get_value("rbot_smg_hitbox")hBox_head6 = forcebaim_get_value("rbot_smg_hitbox_head")hBox_neck6 = forcebaim_get_value("rbot_smg_hitbox_neck")hBox_stomach6 = forcebaim_get_value("rbot_smg_hitbox_stomach")hBox_pelvis6 = forcebaim_get_value("rbot_smg_hitbox_pelvis")hBox_arms6 = forcebaim_get_value("rbot_smg_hitbox_arms")hBox_legs6 = forcebaim_get_value("rbot_smg_hitbox_legs")hBox_walking6 = forcebaim_get_value("rbot_smg_headifwalking")
	 
hBox_priority7 = forcebaim_get_value("rbot_lmg_hitbox")hBox_neck7 = forcebaim_get_value("rbot_lmg_hitbox_neck")hBox_stomach7 = forcebaim_get_value("rbot_lmg_hitbox_stomach")hBox_arms7 = forcebaim_get_value("rbot_lmg_hitbox_arms")hBox_legs7 = forcebaim_get_value("rbot_lmg_hitbox_legs")hBox_walking7 = forcebaim_get_value("rbot_lmg_headifwalking")
	 
hBox_priority8 = forcebaim_get_value("rbot_shotgun_hitbox")hBox_head8 = forcebaim_get_value("rbot_shotgun_hitbox_head")hBox_chest8 = forcebaim_get_value("rbot_shotgun_hitbox_chest")hBox_stomach8 = forcebaim_get_value("rbot_shotgun_hitbox_stomach")hBox_pelvis8 = forcebaim_get_value("rbot_shotgun_hitbox_pelvis")hBox_arms8 = forcebaim_get_value("rbot_shotgun_hitbox_arms")hBox_legs8 = forcebaim_get_value("rbot_shotgun_hitbox_legs")hBox_walking8 = forcebaim_get_value("rbot_shotgun_headifwalking")
				
hBox_priority9 = forcebaim_get_value("rbot_shared_hitbox")hBox_head9 = forcebaim_get_value("rbot_shared_hitbox_head")hBox_neck9 = forcebaim_get_value("rbot_shared_hitbox_neck")hBox_stomach9 = forcebaim_get_value("rbot_shared_hitbox_stomach")hBox_pelvis9 = forcebaim_get_value("rbot_shared_hitbox_pelvis")hBox_arms9 = forcebaim_get_value("rbot_shared_hitbox_arms")hBox_legs9 = forcebaim_get_value("rbot_shared_hitbox_legs")hBox_walking9 = forcebaim_get_value("rbot_shared_headifwalking")

local button_down2 = false;
local saved_vars = false;
local setbaimvars = false;
local function ForceBodyaim()
	local w, h = draw.GetScreenSize();
	
	if forcebaim_key:GetValue() ~= 0 then 
	
		if entities.GetLocalPlayer() ~= nil then
			doDrawForceBaimIndicator();
		end
		--[[ Toggle ]]
		if Key_mode_baim:GetValue() == 0 and input.IsButtonPressed(forcebaim_key:GetValue()) then
			if forcebaim_state then
				forcebaim_state = false;
			elseif forcebaim_state == false then
				forcebaim_state = true;
			end
		end
		
		--[[ Hold ]]
		if Key_mode_baim:GetValue() == 1 then
			if input.IsButtonDown(forcebaim_key:GetValue()) and forcebaim_state ~= true and button_down2 ~= true then
				button_down2 = true;
				forcebaim_state = true;
			elseif input.IsButtonReleased(forcebaim_key:GetValue()) and forcebaim_state and button_down2 == true then
				button_down2 = false;
				forcebaim_state = false;
			end
		end
		
		if forcebaim_state == false and setbaimvars ~= true and saved_vars ~= true then
			hBox_priority = forcebaim_get_value("rbot_autosniper_hitbox")
			hBox_head = forcebaim_get_value("rbot_autosniper_hitbox_head")
			hBox_neck = forcebaim_get_value("rbot_autosniper_hitbox_neck")
			hBox_chest = forcebaim_get_value("rbot_autosniper_hitbox_chest")
			hBox_stomach = forcebaim_get_value("rbot_autosniper_hitbox_stomach")
			hBox_pelvis = forcebaim_get_value("rbot_autosniper_hitbox_pelvis")
			hBox_arms = forcebaim_get_value("rbot_autosniper_hitbox_arms")
			hBox_legs = forcebaim_get_value("rbot_autosniper_hitbox_legs")
			hBox_walking = forcebaim_get_value("rbot_autosniper_headifwalking")
	 
			hBox_priority1 = forcebaim_get_value("rbot_sniper_hitbox")
			hBox_head1 = forcebaim_get_value("rbot_sniper_hitbox_head")
			hBox_neck1 = forcebaim_get_value("rbot_sniper_hitbox_neck")
			hBox_chest1 = forcebaim_get_value("rbot_sniper_hitbox_chest")
			hBox_stomach1 = forcebaim_get_value("rbot_sniper_hitbox_stomach")
			hBox_pelvis1 = forcebaim_get_value("rbot_sniper_hitbox_pelvis")
			hBox_arms1 = forcebaim_get_value("rbot_sniper_hitbox_arms")
			hBox_legs1 = forcebaim_get_value("rbot_sniper_hitbox_legs")
			hBox_walking1 = forcebaim_get_value("rbot_sniper_headifwalking")
	 
			hBox_priority2 = forcebaim_get_value("rbot_scout_hitbox")
			hBox_head2 = forcebaim_get_value("rbot_scout_hitbox_head")
			hBox_neck2 = forcebaim_get_value("rbot_scout_hitbox_neck")
			hBox_chest2 = forcebaim_get_value("rbot_scout_hitbox_chest")
			hBox_stomach2 = forcebaim_get_value("rbot_scout_hitbox_stomach")
			hBox_pelvis2 = forcebaim_get_value("rbot_scout_hitbox_pelvis")
			hBox_arms2 = forcebaim_get_value("rbot_scout_hitbox_arms")
			hBox_legs2 = forcebaim_get_value("rbot_scout_hitbox_legs")
			hBox_walking2 = forcebaim_get_value("rbot_scout_headifwalking")
	 
			hBox_priority3 = forcebaim_get_value("rbot_rifle_hitbox")
			hBox_head3 = forcebaim_get_value("rbot_rifle_hitbox_head")
			hBox_neck3 = forcebaim_get_value("rbot_rifle_hitbox_neck")
			hBox_chest3 = forcebaim_get_value("rbot_rifle_hitbox_chest")
			hBox_stomach3 = forcebaim_get_value("rbot_rifle_hitbox_stomach")
			hBox_pelvis3 = forcebaim_get_value("rbot_rifle_hitbox_pelvis")
			hBox_arms3 = forcebaim_get_value("rbot_rifle_hitbox_arms")
			hBox_legs3 = forcebaim_get_value("rbot_rifle_hitbox_legs")
			hBox_walking3 = forcebaim_get_value("rbot_rifle_headifwalking")
	 
			hBox_priority4 = forcebaim_get_value("rbot_pistol_hitbox")
			hBox_head4 = forcebaim_get_value("rbot_pistol_hitbox_head")
			hBox_neck4 = forcebaim_get_value("rbot_pistol_hitbox_neck")
			hBox_chest4 = forcebaim_get_value("rbot_pistol_hitbox_chest")
			hBox_stomach4 = forcebaim_get_value("rbot_pistol_hitbox_stomach")
			hBox_pelvis4 = forcebaim_get_value("rbot_pistol_hitbox_pelvis")
			hBox_arms4 = forcebaim_get_value("rbot_pistol_hitbox_arms")
			hBox_legs4 = forcebaim_get_value("rbot_pistol_hitbox_legs")
			hBox_walking4 = forcebaim_get_value("rbot_pistol_headifwalking")
			hBox_walking11 = forcebaim_get_value("rbot_pistol_headifwalking")
	 
			hBox_priority5 = forcebaim_get_value("rbot_revolver_hitbox")
			hBox_head5 = forcebaim_get_value("rbot_revolver_hitbox_head")
			hBox_neck5 = forcebaim_get_value("rbot_revolver_hitbox_neck")
			hBox_chest5 = forcebaim_get_value("rbot_revolver_hitbox_chest")
			hBox_stomach5 = forcebaim_get_value("rbot_revolver_hitbox_stomach")
			hBox_pelvis5 = forcebaim_get_value("rbot_revolver_hitbox_pelvis")
			hBox_arms5 = forcebaim_get_value("rbot_revolver_hitbox_arms")
			hBox_legs5 = forcebaim_get_value("rbot_revolver_hitbox_legs")
			hBox_walking5 = forcebaim_get_value("rbot_revolver_headifwalking")
	 
			hBox_priority6 = forcebaim_get_value("rbot_smg_hitbox")
			hBox_head6 = forcebaim_get_value("rbot_smg_hitbox_head")
			hBox_neck6 = forcebaim_get_value("rbot_smg_hitbox_neck")
			hBox_chest6 = forcebaim_get_value("rbot_smg_hitbox_chest")
			hBox_stomach6 = forcebaim_get_value("rbot_smg_hitbox_stomach")
			hBox_pelvis6 = forcebaim_get_value("rbot_smg_hitbox_pelvis")
			hBox_arms6 = forcebaim_get_value("rbot_smg_hitbox_arms")
			hBox_legs6 = forcebaim_get_value("rbot_smg_hitbox_legs")
			hBox_walking6 = forcebaim_get_value("rbot_smg_headifwalking")
	 
			hBox_priority7 = forcebaim_get_value("rbot_lmg_hitbox")
			hBox_head7 = forcebaim_get_value("rbot_lmg_hitbox_head")
			hBox_neck7 = forcebaim_get_value("rbot_lmg_hitbox_neck")
			hBox_chest7 = forcebaim_get_value("rbot_lmg_hitbox_chest")
			hBox_stomach7 = forcebaim_get_value("rbot_lmg_hitbox_stomach")
			hBox_pelvis7 = forcebaim_get_value("rbot_lmg_hitbox_pelvis")
			hBox_arms7 = forcebaim_get_value("rbot_lmg_hitbox_arms")
			hBox_legs7 = forcebaim_get_value("rbot_lmg_hitbox_legs")
			hBox_walking7 = forcebaim_get_value("rbot_lmg_headifwalking")
	 
			hBox_priority8 = forcebaim_get_value("rbot_shotgun_hitbox")
			hBox_head8 = forcebaim_get_value("rbot_shotgun_hitbox_head")
			hBox_neck8 = forcebaim_get_value("rbot_shotgun_hitbox_neck")
			hBox_chest8 = forcebaim_get_value("rbot_shotgun_hitbox_chest")
			hBox_stomach8 = forcebaim_get_value("rbot_shotgun_hitbox_stomach")
			hBox_pelvis8 = forcebaim_get_value("rbot_shotgun_hitbox_pelvis")
			hBox_arms8 = forcebaim_get_value("rbot_shotgun_hitbox_arms")
			hBox_legs8 = forcebaim_get_value("rbot_shotgun_hitbox_legs")
			hBox_walking8 = forcebaim_get_value("rbot_shotgun_headifwalking")
				
			hBox_priority9 = forcebaim_get_value("rbot_shared_hitbox")
			hBox_head9 = forcebaim_get_value("rbot_shared_hitbox_head")
			hBox_neck9 = forcebaim_get_value("rbot_shared_hitbox_neck")
			hBox_chest9 = forcebaim_get_value("rbot_shared_hitbox_chest")
			hBox_stomach9 = forcebaim_get_value("rbot_shared_hitbox_stomach")
			hBox_pelvis9 = forcebaim_get_value("rbot_shared_hitbox_pelvis")
			hBox_arms9 = forcebaim_get_value("rbot_shared_hitbox_arms")
			hBox_legs9 = forcebaim_get_value("rbot_shared_hitbox_legs")
			hBox_walking9 = forcebaim_get_value("rbot_shared_headifwalking")
			saved_vars = true
		end
		
		if forcebaim_state and setbaimvars ~= true and saved_vars then
			setbaimvars = true	
			forcebaim_set_value("rbot_autosniper_hitbox", 3)
			forcebaim_set_value("rbot_autosniper_hitbox_head", 0)
			forcebaim_set_value("rbot_autosniper_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_autosniper_headifwalking", 0)
	 
			forcebaim_set_value("rbot_sniper_hitbox", 3)
			forcebaim_set_value("rbot_sniper_hitbox_head", 0)
			forcebaim_set_value("rbot_sniper_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_sniper_headifwalking", 0)
	 
			forcebaim_set_value("rbot_scout_hitbox", 3)
			forcebaim_set_value("rbot_scout_hitbox_head", 0)
			forcebaim_set_value("rbot_scout_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_scout_headifwalking", 0)
	 
			forcebaim_set_value("rbot_rifle_hitbox", 3)
			forcebaim_set_value("rbot_rifle_hitbox_head", 0)
			forcebaim_set_value("rbot_rifle_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_rifle_headifwalking", 0)
	 
			forcebaim_set_value("rbot_pistol_hitbox", 3)
			forcebaim_set_value("rbot_pistol_hitbox_head", 0)
			forcebaim_set_value("rbot_pistol_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_pistol_headifwalking", 0)
	 
			forcebaim_set_value("rbot_revolver_hitbox", 3)
			forcebaim_set_value("rbot_revolver_hitbox_head", 0)
			forcebaim_set_value("rbot_revolver_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_revolver_headifwalking", 0)
	 
			forcebaim_set_value("rbot_smg_hitbox", 3)
			forcebaim_set_value("rbot_smg_hitbox_head", 0)
			forcebaim_set_value("rbot_smg_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_smg_headifwalking", 0)
	 
			forcebaim_set_value("rbot_lmg_hitbox", 3)
			forcebaim_set_value("rbot_lmg_hitbox_head", 0)
			forcebaim_set_value("rbot_lmg_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_lmg_headifwalking", 0)
	 
			forcebaim_set_value("rbot_shotgun_hitbox", 3)
			forcebaim_set_value("rbot_shotgun_hitbox_head", 0)
			forcebaim_set_value("rbot_shotgun_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_shotgun_headifwalking", 0)
			
			forcebaim_set_value("rbot_shared_hitbox", 3)
			forcebaim_set_value("rbot_shared_hitbox_head", 0)
			forcebaim_set_value("rbot_shared_hitbox_neck", 0)
	 
			forcebaim_set_value("rbot_shared_headifwalking", 0)
		elseif forcebaim_state == false and saved_vars and setbaimvars ~= false then
			setbaimvars = false
			
			forcebaim_set_value("rbot_autosniper_hitbox", hBox_priority)
			forcebaim_set_value("rbot_autosniper_hitbox_head", hBox_head)
			forcebaim_set_value("rbot_autosniper_hitbox_neck", hBox_neck)
			forcebaim_set_value("rbot_autosniper_hitbox_chest", hBox_chest)
			forcebaim_set_value("rbot_autosniper_hitbox_stomach", hBox_stomach)
			forcebaim_set_value("rbot_autosniper_hitbox_pelvis", hBox_pelvis)
			forcebaim_set_value("rbot_autosniper_hitbox_arms", hBox_arms)
			forcebaim_set_value("rbot_autosniper_hitbox_legs", hBox_legs)
			forcebaim_set_value("rbot_autosniper_headifwalking", hBox_walking)
	 
			forcebaim_set_value("rbot_sniper_hitbox", hBox_priority1)
			forcebaim_set_value("rbot_sniper_hitbox_head", hBox_head1)
			forcebaim_set_value("rbot_sniper_hitbox_neck", hBox_neck1)
			forcebaim_set_value("rbot_sniper_hitbox_chest", hBox_chest1)
			forcebaim_set_value("rbot_sniper_hitbox_stomach", hBox_stomach1)
			forcebaim_set_value("rbot_sniper_hitbox_pelvis", hBox_pelvis1)
			forcebaim_set_value("rbot_sniper_hitbox_arms", hBox_arms1)
			forcebaim_set_value("rbot_sniper_hitbox_legs", hBox_legs1)
			forcebaim_set_value("rbot_sniper_headifwalking", hBox_walking1)
	 
			forcebaim_set_value("rbot_scout_hitbox", hBox_priority2)
			forcebaim_set_value("rbot_scout_hitbox_head", hBox_head2)
			forcebaim_set_value("rbot_scout_hitbox_neck", hBox_neck2)
			forcebaim_set_value("rbot_scout_hitbox_chest", hBox_chest2)
			forcebaim_set_value("rbot_scout_hitbox_stomach", hBox_stomach2)
			forcebaim_set_value("rbot_scout_hitbox_pelvis", hBox_pelvis2)
			forcebaim_set_value("rbot_scout_hitbox_arms", hBox_arms2)
			forcebaim_set_value("rbot_scout_hitbox_legs", hBox_legs2)
			forcebaim_set_value("rbot_scout_headifwalking", hBox_walking2)
	 
			forcebaim_set_value("rbot_rifle_hitbox", hBox_priority3)
			forcebaim_set_value("rbot_rifle_hitbox_head", hBox_head3)
			forcebaim_set_value("rbot_rifle_hitbox_neck", hBox_neck3)
			forcebaim_set_value("rbot_rifle_hitbox_chest", hBox_chest3)
			forcebaim_set_value("rbot_rifle_hitbox_stomach", hBox_stomach3)
			forcebaim_set_value("rbot_rifle_hitbox_pelvis", hBox_pelvis3)
			forcebaim_set_value("rbot_rifle_hitbox_arms", hBox_arms3)
			forcebaim_set_value("rbot_rifle_hitbox_legs", hBox_legs3)
			forcebaim_set_value("rbot_rifle_headifwalking", hBox_walking3)
	 
			forcebaim_set_value("rbot_pistol_hitbox", hBox_priority4)
			forcebaim_set_value("rbot_pistol_hitbox_head", hBox_head4)
			forcebaim_set_value("rbot_pistol_hitbox_neck", hBox_neck4)
			forcebaim_set_value("rbot_pistol_hitbox_chest", hBox_chest4)
			forcebaim_set_value("rbot_pistol_hitbox_stomach", hBox_stomach4)
			forcebaim_set_value("rbot_pistol_hitbox_pelvis", hBox_pelvis4)
			forcebaim_set_value("rbot_pistol_hitbox_arms", hBox_arms4)
			forcebaim_set_value("rbot_pistol_hitbox_legs", hBox_legs4)
			forcebaim_set_value("rbot_pistol_headifwalking", hBox_walking4)
	 
			forcebaim_set_value("rbot_revolver_hitbox", hBox_priority5)
			forcebaim_set_value("rbot_revolver_hitbox_head", hBox_head5)
			forcebaim_set_value("rbot_revolver_hitbox_neck", hBox_neck5)
			forcebaim_set_value("rbot_revolver_hitbox_chest", hBox_chest5)
			forcebaim_set_value("rbot_revolver_hitbox_stomach", hBox_stomach5)
			forcebaim_set_value("rbot_revolver_hitbox_pelvis", hBox_pelvis5)
			forcebaim_set_value("rbot_revolver_hitbox_arms", hBox_arms5)
			forcebaim_set_value("rbot_revolver_hitbox_legs", hBox_legs5)
			forcebaim_set_value("rbot_revolver_headifwalking", hBox_walking5)
	 
			forcebaim_set_value("rbot_smg_hitbox", hBox_priority6)
			forcebaim_set_value("rbot_smg_hitbox_head", hBox_head6)
			forcebaim_set_value("rbot_smg_hitbox_neck", hBox_neck6)
			forcebaim_set_value("rbot_smg_hitbox_chest", hBox_chest6)
			forcebaim_set_value("rbot_smg_hitbox_stomach", hBox_stomach6)
			forcebaim_set_value("rbot_smg_hitbox_pelvis", hBox_pelvis6)
			forcebaim_set_value("rbot_smg_hitbox_arms", hBox_arms6)
			forcebaim_set_value("rbot_smg_hitbox_legs", hBox_legs6)
			forcebaim_set_value("rbot_smg_headifwalking", hBox_walking6)
	 
			forcebaim_set_value("rbot_lmg_hitbox", hBox_priority7)
			forcebaim_set_value("rbot_lmg_hitbox_head", hBox_head7)
			forcebaim_set_value("rbot_lmg_hitbox_neck", hBox_neck7)
			forcebaim_set_value("rbot_lmg_hitbox_chest", hBox_chest7)
			forcebaim_set_value("rbot_lmg_hitbox_stomach", hBox_stomach7)
			forcebaim_set_value("rbot_lmg_hitbox_pelvis", hBox_pelvis7)
			forcebaim_set_value("rbot_lmg_hitbox_arms", hBox_arms7)
			forcebaim_set_value("rbot_lmg_hitbox_legs", hBox_legs7)
			forcebaim_set_value("rbot_lmg_headifwalking", hBox_walking7)
	 
			forcebaim_set_value("rbot_shotgun_hitbox", hBox_priority8)
			forcebaim_set_value("rbot_shotgun_hitbox_head", hBox_head8)
			forcebaim_set_value("rbot_shotgun_hitbox_neck", hBox_neck8)
			forcebaim_set_value("rbot_shotgun_hitbox_chest", hBox_chest8)
			forcebaim_set_value("rbot_shotgun_hitbox_stomach", hBox_stomach8)
			forcebaim_set_value("rbot_shotgun_hitbox_pelvis", hBox_pelvis8)
			forcebaim_set_value("rbot_shotgun_hitbox_arms", hBox_arms8)
			forcebaim_set_value("rbot_shotgun_hitbox_legs", hBox_legs8)
			forcebaim_set_value("rbot_shotgun_headifwalking", hBox_walking8)
				
			forcebaim_set_value("rbot_shared_hitbox", hBox_priority9)
			forcebaim_set_value("rbot_shared_hitbox_head", hBox_head9)
			forcebaim_set_value("rbot_shared_hitbox_neck", hBox_neck9)
			forcebaim_set_value("rbot_shared_hitbox_chest", hBox_chest9)
			forcebaim_set_value("rbot_shared_hitbox_stomach", hBox_stomach9)
			forcebaim_set_value("rbot_shared_hitbox_pelvis", hBox_pelvis9)
			forcebaim_set_value("rbot_shared_hitbox_arms", hBox_arms9)
			forcebaim_set_value("rbot_shared_hitbox_legs", hBox_legs9)
			forcebaim_set_value("rbot_shared_headifwalking", hBox_walking9)
			saved_vars = false
		end
	end
end
callbacks.Register("Draw", "aw_toggle", autowall_toggle);
callbacks.Register("Draw", "ForceBodyaim", ForceBodyaim)

--[[ Fakelag On Key Groupbox ]]
key_toggle_fakelag = nil;
key_hold_fakelag = nil;
local fakelag_toggle_ref = lsp.Reference();
GroupBox_fakelag_toggle = gui.Groupbox(fakelag_toggle_ref, "Fakelag On Key", -16, groupbox_pos_left+10, 245, 290)
groupbox_pos_left = groupbox_pos_left+10+290
local LagKey = gui.Keybox(GroupBox_fakelag_toggle, "lua_lagkey_key", "Lag On Key", 0);
local KeyMode = gui.Combobox(GroupBox_fakelag_toggle, "lua_lagkey_keymode", "Key Mode Fakelag", "Toggle", "Hold");
local LagMode = gui.Combobox(GroupBox_fakelag_toggle, "lua_lagkey_mode", "Mode", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek");
local LagValue = gui.Slider(GroupBox_fakelag_toggle, "lua_lagkey_lagvalue", "Lag Value", 15, 1, 61);
local LagDist = gui.Slider(GroupBox_fakelag_toggle, "lua_lagkey_lagdist", "Lag Dist", 13, 0, 50);
local LagLimit = gui.Slider(GroupBox_fakelag_toggle, "lua_lagkey_laglimit", "Lag Limit", 20, 0, 61);

local function lagOnKey()
	if LagKey:GetValue() == nil or LagKey:GetValue() <= 0 then
		return;
	end
	if entities.GetLocalPlayer() ~= nil then
		doDrawFakelag();
	end
	if KeyMode:GetValue() == 0 then --[[ Toggle ]]	
		if input.IsButtonPressed(LagKey:GetValue()) then
			if key_toggle_fakelag ~= true then
				key_toggle_fakelag = true;
			elseif key_toggle_fakelag ~= false then
				key_toggle_fakelag = false;
			end
		end
	elseif KeyMode:GetValue() == 1 then --[[ Hold ]]
		if input.IsButtonDown(LagKey:GetValue()) then
			if key_hold_fakelag ~= true then
				key_hold_fakelag = true;
			end
		elseif key_hold_fakelag ~= false then
			key_hold_fakelag = false;
		end
	end
	if changed_vars~=true and (lag_enable ~= gui.GetValue("msc_fakelag_enable") and lag_key ~= gui.GetValue("msc_fakelag_key") and lag_value ~= gui.GetValue("msc_fakelag_value") and lag_mode ~= gui.GetValue("msc_fakelag_mode")and lag_attack ~= gui.GetValue("msc_fakelag_attack") and lag_standing ~= gui.GetValue("msc_fakelag_standing") and lag_unducking ~= gui.GetValue("msc_fakelag_unducking") and lag_style ~= gui.GetValue("msc_fakelag_style") and lag_peekdist ~= gui.GetValue("msc_fakelag_peekdist") and lag_limit ~= gui.GetValue("msc_fakelag_limit")) then
		changed_vars = true;
	elseif changed_vars~=false then
		changed_vars = false;
	end
	if (key_hold_fakelag and KeyMode:GetValue() == 1) or (key_toggle_fakelag and KeyMode:GetValue() == 0) then
		if val_saved ~= true then
			lag_enable = gui.GetValue("msc_fakelag_enable");
			lag_key = gui.GetValue("msc_fakelag_key");
			lag_value = gui.GetValue("msc_fakelag_value");
			lag_mode = gui.GetValue("msc_fakelag_mode");
			lag_attack = gui.GetValue("msc_fakelag_attack");
			lag_standing = gui.GetValue("msc_fakelag_standing");
			lag_unducking = gui.GetValue("msc_fakelag_unducking");
			lag_style = gui.GetValue("msc_fakelag_style");
			lag_peekdist = gui.GetValue("msc_fakelag_peekdist");
			lag_limit = gui.GetValue("msc_fakelag_limit");
			val_saved = true;
		end

		gui.SetValue("msc_fakelag_enable",1);
		gui.SetValue("msc_fakelag_key",0);
		gui.SetValue("msc_fakelag_value",round(LagValue:GetValue(),0));
		gui.SetValue("msc_fakelag_mode",LagMode:GetValue());
		gui.SetValue("msc_fakelag_attack",lag_attack);
		gui.SetValue("msc_fakelag_standing",lag_standing);
		gui.SetValue("msc_fakelag_unducking",lag_unducking);
		gui.SetValue("msc_fakelag_style",0);
		gui.SetValue("msc_fakelag_peekdist",LagDist:GetValue());
		gui.SetValue("msc_fakelag_limit",round(LagLimit:GetValue(),0));

	elseif val_saved then
		if changed_vars ~= true then
			if lag_key <= 0 then
				gui.SetValue("msc_fakelag_enable",0);
			else
				gui.SetValue("msc_fakelag_enable",lag_enable);
			end
			gui.SetValue("msc_fakelag_key",lag_key);
			gui.SetValue("msc_fakelag_value",lag_value);
			gui.SetValue("msc_fakelag_mode",lag_mode);
			gui.SetValue("msc_fakelag_attack",lag_attack);
			gui.SetValue("msc_fakelag_standing",lag_standing);
			gui.SetValue("msc_fakelag_unducking",lag_unducking);
			gui.SetValue("msc_fakelag_style",lag_style);
			gui.SetValue("msc_fakelag_peekdist",lag_peekdist);
			gui.SetValue("msc_fakelag_limit",lag_limit);
		end
		val_saved = false;
	else
		return;
	end
end
callbacks.Register( "Draw", "Fakelag On Key", lagOnKey)

--[[ Clear CSGO ]]
local Ref_ClearCsgo = rsp.Reference()
local Text_SideMenu = gui.Text( Ref_ClearCsgo,
 "[ Can fix most fps drops ]" )
local function doClearCsgo()
	local date = os.date("%d/%m/%y %H:%M:%S")
	client.Command("clear", true)
	gui.Command("clear")
	print("[———————————————————————— Cleaning CSGO ————————————————————————]")
	client.Command("echo " .. "[------------------------- Cleaning CSGO -------------------------]", true)
	client.Command("clear_anim_cache", true)
	client.Command("echo " .. "- Cleared Animation Cache", true)
	print("- Cleared Animation Cache")
	client.Command("clear_debug_overlays", true)
	client.Command("echo " .. "- Cleared Debug Overlays", true)
	print("- Cleared Debug Overlays")
	--[[client.Command("clear_bombs", true)
	client.Command("echo " .. "- Cleared Bombs", true)]]
	client.Command("r_cleardecals", true)
	client.Command("echo " .. "- Cleared Decals", true)
	print("- Cleared Decals")
	client.Command("hud_takesshots 0", true)
	client.Command("echo " .. "- Disabled Auto-save scoreboard screenshot at the end of a map", true)
	print("- Disabled Auto-save scoreboard screenshot at the end of a map")
	client.Command("ai_clear_bad_links", true)
	client.Command("echo " .. "- Cleared bits set on nav links indicating link is unusable", true)
	print("- Cleared bits set on nav links indicating link is unusable")
	client.Command("cl_soundemitter_reload", true)
	client.Command("echo " .. "- Reloaded Soundemitter", true)
	print("- Reloaded Soundemitter")
	--[[client.Command("cl_soundscape_flush", true)
	client.Command("echo " .. "- Cleared Soundscapes", true)
	print("Cleared Soundscapes")]]
	client.Command("fs_clear_open_duplicate_times", true)
	client.Command("echo " .. "- Cleared duplicated Timers", true)
	print("- Cleared duplicated Timers")
	client.Command("fs_fios_flush_cache", true)
	client.Command("echo " .. "- Cleared fios cache", true)
	print("- Cleared fios cache")
	client.Command("scene_flush", true)
	client.Command("echo " .. "- Cleared Scene", true)
	print("- Cleared Scene")
	client.Command("snd_async_flush", true)
	client.Command("echo " .. "- Cleared all unlocked async audio data", true)
	print("- Cleared all unlocked async audio data")
	--[[client.Command("r_flushlod", true)
	client.Command("echo " .. "- Cleared and reloaded LODs", true)
	print("Cleared and reloaded LODs")]]
	client.Command("echo " .."[------------------------- CSGO Cleaned -------------------------]", true)
	client.Command("echo " .."["..date.."]", true)
	client.Command("echo " .. " ", true)
	print("[———————————————————————— CSGO Cleaned ————————————————————————]")
	print("["..date.."]")
	print(" ")
end
local clear_button = gui.Button( Ref_ClearCsgo, "Clear CSGO", doClearCsgo )