 /*
	Inventory System
	by: Jax Teller
*/

#include <a_samp>
//#include <YSF>
#include <zcmd>

new PlayerText:Inv[MAX_PLAYERS][48];
new PlayerText:Index[MAX_PLAYERS][16];
new bool:InventoryStatus[MAX_PLAYERS];
new LastIndex[MAX_PLAYERS];
new OldIndex[MAX_PLAYERS];
new LastSelect[MAX_PLAYERS];
new bool:IndexFix[MAX_PLAYERS];

enum pInfo
{
	pItem[16]
}
new PlayerInfo[MAX_PLAYERS][pInfo];

new DropObject[125];
new TotalDrop;

main (){
	print(" - >> Inventory System by: Jax Teller");
}

public OnPlayerConnect(playerid)
{
    InventoryStatus[playerid] = false;
    IndexFix[playerid] = false;
   	LastIndex[playerid] = -1;
   	OldIndex[playerid] = -1;
	LastSelect[playerid] = -1;
    LoadBlueInventory(playerid);
    for(new i = 0; i < 16; i ++)
    {
        if(PlayerInfo[playerid][pItem][i] == 0)
        	PlayerInfo[playerid][pItem][i] = 19382;
    }
    PlayerInfo[playerid][pItem][2] = 2469;
    PlayerInfo[playerid][pItem][1] = 18906;
    PlayerInfo[playerid][pItem][0] = 19039;
    PlayerInfo[playerid][pItem][4] = 3026;
    ApplyAnimation(playerid,"goggles","goggles_put_on",0.0,0,0,0,0,0,0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, 4);
	return 1;
}
/*
public OnPlayerUpdate(playerid)
{
    new Keys,ud,lr;
    GetPlayerKeys(playerid,Keys,ud,lr);

	new Float:x[16], Float:y[16];
	new Float:x2[48], Float:y2[48];
	for(new i = 0; i < 16; i ++) PlayerTextDrawGetPos(playerid, Index[playerid][i], x[i], y[i]);
	for(new i = 0; i < 48; i ++) PlayerTextDrawGetPos(playerid, Inv[playerid][i], x2[i], y2[i]);

	if(GetPVarInt(playerid, "pos") == 0) return 1;
    if(ud == KEY_UP)
	{
 		for(new i = 0; i < 48; i ++)PlayerTextDrawHide(playerid, Inv[playerid][i]);
		for(new i = 0; i < 48; i ++)PlayerTextDrawSetPos(playerid, Inv[playerid][i], x2[i], y2[i] - 2);
		for(new i = 0; i < 48; i ++)PlayerTextDrawShow(playerid, Inv[playerid][i]);
	    for(new i = 0; i < 16; i ++)PlayerTextDrawHide(playerid, Index[playerid][i]);
		for(new i = 0; i < 16; i ++)PlayerTextDrawSetPos(playerid, Index[playerid][i], x[i], y[i] - 2);
		for(new i = 0; i < 16; i ++)PlayerTextDrawShow(playerid, Index[playerid][i]);
	}
    else if(ud == KEY_DOWN)
    {
		for(new i = 0; i < 48; i ++)PlayerTextDrawHide(playerid, Inv[playerid][i]);
		for(new i = 0; i < 48; i ++)PlayerTextDrawSetPos(playerid, Inv[playerid][i], x2[i], y2[i] + 2);
		for(new i = 0; i < 48; i ++)PlayerTextDrawShow(playerid, Inv[playerid][i]);
    	for(new i = 0; i < 16; i ++)PlayerTextDrawHide(playerid, Index[playerid][i]);
		for(new i = 0; i < 16; i ++)PlayerTextDrawSetPos(playerid, Index[playerid][i], x[i], y[i] + 2);
		for(new i = 0; i < 16; i ++)PlayerTextDrawShow(playerid, Index[playerid][i]);
    }

    if(lr == KEY_LEFT)
    {
  		for(new i = 0; i < 48; i ++)PlayerTextDrawHide(playerid, Inv[playerid][i]);
		for(new i = 0; i < 48; i ++)PlayerTextDrawSetPos(playerid, Inv[playerid][i], x2[i] - 2, y2[i]);
		for(new i = 0; i < 48; i ++)PlayerTextDrawShow(playerid, Inv[playerid][i]);
    	for(new i = 0; i < 16; i ++)PlayerTextDrawHide(playerid, Index[playerid][i]);
		for(new i = 0; i < 16; i ++)PlayerTextDrawSetPos(playerid, Index[playerid][i], x[i] - 2, y[i]);
		for(new i = 0; i < 16; i ++)PlayerTextDrawShow(playerid, Index[playerid][i]);
    }
    else if(lr == KEY_RIGHT)
    {
  		for(new i = 0; i < 48; i ++)PlayerTextDrawHide(playerid, Inv[playerid][i]);
		for(new i = 0; i < 48; i ++)PlayerTextDrawSetPos(playerid, Inv[playerid][i], x2[i] + 2, y2[i]);
		for(new i = 0; i < 48; i ++)PlayerTextDrawShow(playerid, Inv[playerid][i]);
   		for(new i = 0; i < 16; i ++)PlayerTextDrawHide(playerid, Index[playerid][i]);
		for(new i = 0; i < 16; i ++)PlayerTextDrawSetPos(playerid, Index[playerid][i], x[i] + 2, y[i]);
		for(new i = 0; i < 16; i ++)PlayerTextDrawShow(playerid, Index[playerid][i]);
    }
	return 1;
}
*/
public OnPlayerDeath(playerid)
{
	HideInventory(playerid);
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
	    if(InventoryStatus[playerid] == true)
	    {
	        HideInventory(playerid);
	    }
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	for(new i = 0; i < 16; i ++)
	{
	    if(playertextid == Index[playerid][i])
		{
		    if(GetPVarInt(playerid, "Object") == 0)
		    {
		        if(LastIndex[playerid] != -1)
		        {
					OldIndex[playerid] = LastIndex[playerid];
					IndexFix[playerid] = false;
				}
				LastIndex[playerid] = i;
				LastSelect[playerid] = PlayerInfo[playerid][pItem][i];

				if(OldIndex[playerid] != -1 && IndexFix[playerid] == false)
		        {
					if(PlayerInfo[playerid][pItem][i] != 19382) return 1;
					new old = OldIndex[playerid];
					PlayerTextDrawHide(playerid, Index[playerid][i]);
					PlayerTextDrawHide(playerid, Index[playerid][old]);
					PlayerInfo[playerid][pItem][i] = PlayerInfo[playerid][pItem][old];
					PlayerInfo[playerid][pItem][old] = 19382;
                    for(new d = 0; d < 16; d ++) PlayerTextDrawSetPreviewModel(playerid, Index[playerid][d], PlayerInfo[playerid][pItem][d]);
				 	PlayerTextDrawShow(playerid, Index[playerid][i]);
				 	PlayerTextDrawShow(playerid, Index[playerid][old]);
				 	OldIndex[playerid] = -1;
				 	IndexFix[playerid] = true;
					LastIndex[playerid] = -1;
				}

				PlayerPlaySound(playerid, 1130, 0, 0, 0);
			}
			else
			{
			    PlayerPlaySound(playerid, 1130, 0, 0, 0);
			    PlayerInfo[playerid][pItem][i] = GetPVarInt(playerid, "Object");
			    SetPVarInt(playerid, "Object", 0);
				PlayerTextDrawHide(playerid, Index[playerid][i]);
			 	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][i], PlayerInfo[playerid][pItem][i]);
			 	PlayerTextDrawShow(playerid, Index[playerid][i]);
			}
		}
	}
	if(playertextid == Inv[playerid][44])
	{
	    ShowPlayerDialog(playerid, 9849, DIALOG_STYLE_LIST, "{4682b4}Fe{2e8b57}re{ff1493}bi", "{4682b4}[1]{ffffff} Normal (Lurji)\n{2e8b57}[2]{ffffff} Mwavne\n{ff1493}[3]{ffffff} Vardisferi", "Archeva", "Gasvla");
	}
	if(playertextid == Inv[playerid][38])
	{
		switch(LastSelect[playerid])
		{
		    case 0: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Ar Agircheviat Nivti Gamosakeneblad"), LastSelect[playerid] = 0, LastIndex[playerid] = -1;
		    case 19382: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqvens Mier Archeuli Sloti Carielia"), LastSelect[playerid] = 0, LastIndex[playerid] = -1;
		    default: SetAccessories(playerid, LastSelect[playerid]), LastSelect[playerid] = 0, LastIndex[playerid] = -1;
		}
	}
	if(playertextid == Inv[playerid][39])
	{
		switch(LastSelect[playerid])
		{
		    case 0: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Ar Agircheviat Nivti Gamosakeneblad"), LastSelect[playerid] = 0, LastIndex[playerid] = -1;
		    case 19382: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqvens Mier Archeuli Sloti Carielia"), LastSelect[playerid] = 0, LastIndex[playerid] = -1;
		    default:
		    {
				new s = LastIndex[playerid];
			 	PlayerInfo[playerid][pItem][s] = 19382;
			 	PlayerTextDrawHide(playerid, Index[playerid][s]);
			 	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][s], PlayerInfo[playerid][pItem][s]);
			 	PlayerTextDrawShow(playerid, Index[playerid][s]);
		        new Float:x, Float:y, Float:z;
		        GetPlayerPos(playerid, x, y, z);
		        DropObject[TotalDrop] = CreateObject(LastSelect[playerid], x, y, z - 0.9, 0, 0, 0);
		        TotalDrop ++;
		        SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Daagdet Aksesuari"), LastSelect[playerid] = 0, LastIndex[playerid] = -1;
		    }
		}
	}
	if(playertextid == Inv[playerid][40])
	{
	    SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Moixsenit Kveala Gaketebuli Aksesuari");
	    for(new i = 0; i < 10; i ++)
	        RemovePlayerAttachedObject(playerid, i);
	}
	if(playertextid == Inv[playerid][46])
	{
	    SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Aris Normal Versia Ar Akvs YSF plagini");
		//TogglePlayerControllable(playerid, false);
		//SetPVarInt(playerid, "pos", 1);
		//SetTimerEx("ShowInventory",2000,false,"d",playerid);
		//SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Gamoikenet (UP) (DOWN) (LEFT) (RIGHT) (ENTER) Gilakebi");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 9849)
	{
		if(response)
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            if(GetPVarInt(playerid, "color") == 1 || GetPVarInt(playerid, "color") == 0) return SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Ukve Archeuli Gakvt Es Feri");
		            HideInventory(playerid);
		            for(new i = 0; i < 48; i ++) PlayerTextDrawDestroy(playerid, Inv[playerid][i]);
		            LoadBlueInventory(playerid);
                    SetTimerEx("ShowInventory",1000,false,"d",playerid);
		        }
      			case 1:
		        {
		            if(GetPVarInt(playerid, "color") == 2) return SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Ukve Archeuli Gakvt Es Feri");
		            HideInventory(playerid);
		            for(new i = 0; i < 48; i ++) PlayerTextDrawDestroy(playerid, Inv[playerid][i]);
		            LoadGreenInventory(playerid);
	                SetTimerEx("ShowInventory",1000,false,"d",playerid);
		        }
		        case 2:
		        {
		            if(GetPVarInt(playerid, "color") == 3) return SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqven Ukve Archeuli Gakvt Es Feri");
		            HideInventory(playerid);
		            for(new i = 0; i < 48; i ++) PlayerTextDrawDestroy(playerid, Inv[playerid][i]);
		            LoadPinkInventory(playerid);
			        SetTimerEx("ShowInventory",1000,false,"d",playerid);
		        }
		    }
		}
	}
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 16 && GetPVarInt(playerid, "pos") == 1)
	{
		if(GetPVarInt(playerid, "color") == 0) SelectTextDraw(playerid, 8438015);
	 	else if(GetPVarInt(playerid, "color") == 1) SelectTextDraw(playerid, 8438015);
		else if(GetPVarInt(playerid, "color") == 2) SelectTextDraw(playerid, 8405247);
		else if(GetPVarInt(playerid, "color") == 3) SelectTextDraw(playerid, -2147467009);
		TogglePlayerControllable(playerid, true);
		SetPVarInt(playerid, "pos", 0);
		SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Tqveni Inventory Dakenda");
		SetTimerEx("ShowInventory",1000,false,"d",playerid);
	}
	return 1;
}

CMD:mm(playerid)
{
	if(InventoryStatus[playerid] == true) return 1;
	ShowInventory(playerid);
	return 1;
}
CMD:pick(playerid)
{
	new axloa = 0;
	for(new i = 0; i < sizeof(DropObject); i ++)
	{
		new Float:x, Float:y, Float:z;
		GetObjectPos(DropObject[i], x, y, z);
		if(IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
		{
            ShowInventory(playerid);
		    SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Airchiet Sloti Romelshic Gnebavt Aksesuari");
		    SetPVarInt(playerid, "Object", GetObjectModel(DropObject[i]));
		    DestroyObject(DropObject[i]);
		    TotalDrop --;
		    axloa = 1;
		}
	}
	if(axloa == 0) return SendClientMessage(playerid, -1,  "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Axlos Araa Aksesuari");
	return 1;
}

forward ShowInventory(playerid);
public ShowInventory(playerid)
{
	new Float:hp; GetPlayerHealth(playerid, hp);
	new Float:arm; GetPlayerHealth(playerid, arm);
	PlayerTextDrawTextSize(playerid, Inv[playerid][15], hp / 2, 9.000);
	PlayerTextDrawTextSize(playerid, Inv[playerid][19], arm / 2, 9.000);
	PlayerTextDrawSetPreviewModel(playerid, Inv[playerid][12], GetPlayerSkin(playerid));
	for(new i = 0; i < 16; i ++) PlayerTextDrawSetPreviewModel(playerid, Index[playerid][i], PlayerInfo[playerid][pItem][i]);
	for(new i = 0; i < 48; i ++) PlayerTextDrawShow(playerid, Inv[playerid][i]);
	for(new i = 0; i < 16; i ++) PlayerTextDrawShow(playerid, Index[playerid][i]);
	if(GetPVarInt(playerid, "color") == 0) SelectTextDraw(playerid, 8438015);
 	else if(GetPVarInt(playerid, "color") == 1) SelectTextDraw(playerid, 8438015);
	else if(GetPVarInt(playerid, "color") == 2) SelectTextDraw(playerid, 8405247);
	else if(GetPVarInt(playerid, "color") == 3) SelectTextDraw(playerid, -2147467009);
	if(GetPVarInt(playerid, "pos") == 1) CancelSelectTextDraw(playerid);
	InventoryStatus[playerid] = true;
	return 1;
}
stock HideInventory(playerid)
{
	for(new i = 0; i < 48; i ++) PlayerTextDrawHide(playerid, Inv[playerid][i]);
	for(new i = 0; i < 16; i ++) PlayerTextDrawHide(playerid, Index[playerid][i]);
	CancelSelectTextDraw(playerid);
	InventoryStatus[playerid] = false;
	LastIndex[playerid] = -1;
	LastSelect[playerid] = -1;
	OldIndex[playerid] = -1;
	return 1;
}

stock SetAccessories(playerid, objectid)
{
	switch(objectid)
	{
	    case 2469: SetAccessoriesToSkin(playerid, 1, GetPlayerSkin(playerid), objectid);
	    case 3026: SetAccessoriesToSkin(playerid, 2, GetPlayerSkin(playerid), objectid);
	    case 18968,18969: SetAccessoriesToSkin(playerid, 3, GetPlayerSkin(playerid), objectid);
	    case 19624: SetAccessoriesToSkin(playerid, 4, GetPlayerSkin(playerid), objectid);
	    case 1607: SetAccessoriesToSkin(playerid, 5, GetPlayerSkin(playerid), objectid);
	    case 18910, 18909, 18908, 18907, 18906: SetAccessoriesToSkin(playerid, 6, GetPlayerSkin(playerid), objectid);
	    case 19035, 19034, 19033, 19032, 19031, 19030, 19029, 19028, 19027, 19026, 19025, 19024, 19023, 19022, 19021, 19020, 19019, 19018, 19017, 19016, 19015, 19014, 19013, 19012, 19011, 19010, 19009, 19008,19007, 19006: SetAccessoriesToSkin(playerid, 7, GetPlayerSkin(playerid), objectid);
	    case 19068, 19067: SetAccessoriesToSkin(playerid, 8, GetPlayerSkin(playerid), objectid);
		case 19039, 19040, 19041, 19042, 19043, 19044, 19045, 19046, 19048, 19049, 19050, 19051, 19053: SetAccessoriesToSkin(playerid, 9, GetPlayerSkin(playerid), objectid);
		case 19332: SetAccessoriesToSkin(playerid, 10, GetPlayerSkin(playerid), objectid);
		case 2404, 2406: SetAccessoriesToSkin(playerid, 11, GetPlayerSkin(playerid), objectid);
		case 19515: SetAccessoriesToSkin(playerid, 12, GetPlayerSkin(playerid), objectid);
		case 19076: SetAccessoriesToSkin(playerid, 13, GetPlayerSkin(playerid), objectid);
		case 1609: SetAccessoriesToSkin(playerid, 14, GetPlayerSkin(playerid), objectid);
		case 19878: SetAccessoriesToSkin(playerid, 15, GetPlayerSkin(playerid), objectid);
		case 19079: SetAccessoriesToSkin(playerid, 16, GetPlayerSkin(playerid), objectid);
		case 2226: SetAccessoriesToSkin(playerid, 17, GetPlayerSkin(playerid), objectid);
		case 11704: SetAccessoriesToSkin(playerid, 18, GetPlayerSkin(playerid), objectid);
	}
	ApplyAnimation(playerid,"goggles","goggles_put_on",4.1,0,0,0,0,0,1);
	return true;
}

stock LoadBlueInventory(playerid)
{
	SetPVarInt(playerid, "color", 1);
	Inv[playerid][0] = CreatePlayerTextDraw(playerid, 264.0000, 113.9333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][0], 239.0000, 18.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][0], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][0], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][0], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);

	Inv[playerid][1] = CreatePlayerTextDraw(playerid, 251.5000, 110.4222, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][1], 25.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][1], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][1], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][1], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][1], 0);

	Inv[playerid][2] = CreatePlayerTextDraw(playerid, 490.7000, 110.5666, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][2], 25.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][2], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][2], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][2], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][2], 0);

	Inv[playerid][3] = CreatePlayerTextDraw(playerid, 256.0000, 122.6444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][3], 256.0000, 13.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][3], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][3], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][3], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][3], 0);

	Inv[playerid][4] = CreatePlayerTextDraw(playerid, 265.0000, 119.5333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][4], 238.0000, 2.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][4], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][4], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][4], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][4], 0);

	Inv[playerid][5] = CreatePlayerTextDraw(playerid, 272.2004, 127.9332, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][5], 221.0000, 1.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][5], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][5], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][5], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][5], 0);

	Inv[playerid][6] = CreatePlayerTextDraw(playerid, 256.0000, 134.4666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][6], 256.0000, 2.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][6], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][6], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][6], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][6], 0);

	Inv[playerid][7] = CreatePlayerTextDraw(playerid, 256.0000, 146.2888, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][7], 96.0000, 170.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][7], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][7], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][7], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][7], 0);

	Inv[playerid][8] = CreatePlayerTextDraw(playerid, 259.5998, 151.0110, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][8], 88.0000, 161.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][8], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][8], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][8], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][8], 0);

	Inv[playerid][9] = CreatePlayerTextDraw(playerid, 396.5000, 160.6000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][9], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][9], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][9], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][9], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][9], 0);

	Inv[playerid][10] = CreatePlayerTextDraw(playerid, 396.5000, 160.6000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][10], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][10], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][10], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][10], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][10], 0);

	Inv[playerid][11] = CreatePlayerTextDraw(playerid, 396.5000, 160.6000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][11], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][11], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][11], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][11], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][11], 0);

	Inv[playerid][12] = CreatePlayerTextDraw(playerid, 232.0000, 154.3777, "");
	PlayerTextDrawTextSize(playerid, Inv[playerid][12], 90.0000, 90.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][12], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][12], 572661504);
	PlayerTextDrawFont(playerid, Inv[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inv[playerid][12], 123);
	PlayerTextDrawSetPreviewRot(playerid, Inv[playerid][12], 0.0000, 0.0000, 20.0000, 1.0000);

	Inv[playerid][13] = CreatePlayerTextDraw(playerid, 290.5000, 172.2221, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][13], 53.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][13], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][13], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][13], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][13], 0);

	Inv[playerid][14] = CreatePlayerTextDraw(playerid, 291.8000, 173.0444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][14], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][14], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][14], 791621631);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][14], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][14], 0);

	Inv[playerid][15] = CreatePlayerTextDraw(playerid, 291.8000, 173.0444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][15], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][15], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][15], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][15], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][15], 0);

	Inv[playerid][16] = CreatePlayerTextDraw(playerid, 311.0000, 172.5777, "HP");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][16], 0.2175, 1.0586);
	PlayerTextDrawAlignment(playerid, Inv[playerid][16], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][16], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][16], 0);

	Inv[playerid][17] = CreatePlayerTextDraw(playerid, 290.5000, 188.3999, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][17], 53.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][17], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][17], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][17], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][17], 0);

	Inv[playerid][18] = CreatePlayerTextDraw(playerid, 291.8000, 189.2221, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][18], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][18], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][18], 791621631);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][18], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][18], 0);

	Inv[playerid][19] = CreatePlayerTextDraw(playerid, 291.8000, 189.2222, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][19], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][19], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][19], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][19], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][19], 0);

	Inv[playerid][20] = CreatePlayerTextDraw(playerid, 306.7997, 188.7555, "ARM");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][20], 0.2175, 1.0586);
	PlayerTextDrawAlignment(playerid, Inv[playerid][20], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][20], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][20], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][20], 0);

	Inv[playerid][21] = CreatePlayerTextDraw(playerid, 302.0000, 250.3555, "REPORT");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][21], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][21], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][21], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][21], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][21], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][21], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][21], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][21], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][21], true);

	Inv[playerid][22] = CreatePlayerTextDraw(playerid, 301.9000, 270.4667, "DONATE");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][22], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][22], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][22], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][22], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][22], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][22], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][22], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][22], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][22], true);

	Inv[playerid][23] = CreatePlayerTextDraw(playerid, 301.9000, 289.7556, "QUEST");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][23], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][23], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][23], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][23], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][23], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][23], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][23], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][23], true);

	Inv[playerid][24] = CreatePlayerTextDraw(playerid, 268.5000, 253.3111, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][24], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][24], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][24], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][24], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][24], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][24], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][24], 0);

	Inv[playerid][25] = CreatePlayerTextDraw(playerid, 268.5000, 273.8444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][25], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][25], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][25], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][25], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][25], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][25], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][25], 0);

	Inv[playerid][26] = CreatePlayerTextDraw(playerid, 268.0000, 291.7667, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][26], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][26], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][26], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][26], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][26], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][26], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][26], 0);

	Inv[playerid][27] = CreatePlayerTextDraw(playerid, 256.0000, 317.1556, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][27], 96.0000, -3.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][27], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][27], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][27], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][27], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][27], 0);

	Inv[playerid][28] = CreatePlayerTextDraw(playerid, 354.0000, 140.0666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][28], 158.0000, 165.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][28], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][28], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][28], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][28], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][28], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][28], 0);

	Inv[playerid][29] = CreatePlayerTextDraw(playerid, 357.5000, 148.1555, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][29], 150.0000, 149.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][29], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][29], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][29], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][29], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][29], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][29], 0);

	Inv[playerid][30] = CreatePlayerTextDraw(playerid, 255.5000, 139.4444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][30], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][30], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][30], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][30], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][30], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][30], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][30], 0);

	Inv[playerid][31] = CreatePlayerTextDraw(playerid, 255.5000, 139.4444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][31], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][31], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][31], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][31], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][31], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][31], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][31], 0);

	Inv[playerid][32] = CreatePlayerTextDraw(playerid, 288.0000, 140.2221, "PLAYER");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][32], 0.2455, 1.1146);
	PlayerTextDrawAlignment(playerid, Inv[playerid][32], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][32], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][32], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][32], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][32], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][32], 0);

	Inv[playerid][33] = CreatePlayerTextDraw(playerid, 357.5000, 147.5333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][33], 150.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][33], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][33], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][33], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][33], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][33], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][33], 0);

	Inv[playerid][34] = CreatePlayerTextDraw(playerid, 356.5000, 147.5333, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][34], 157.0000, 10.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][34], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][34], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][34], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][34], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][34], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][34], 0);

	Inv[playerid][35] = CreatePlayerTextDraw(playerid, 408.5000, 147.6888, "INVENTORY");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][35], 0.2455, 1.1146);
	PlayerTextDrawAlignment(playerid, Inv[playerid][35], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][35], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][35], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][35], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][35], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][35], 0);

	Index[playerid][0] = CreatePlayerTextDraw(playerid, 364.5000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][0], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][0], 1);
	PlayerTextDrawColor(playerid, Index[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][0], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][0], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][0], true);

	Index[playerid][1] = CreatePlayerTextDraw(playerid, 399.0000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][1], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][1], 1);
	PlayerTextDrawColor(playerid, Index[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][1], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][1], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][1], true);

	Index[playerid][2] = CreatePlayerTextDraw(playerid, 433.5000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][2], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][2], 1);
	PlayerTextDrawColor(playerid, Index[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][2], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][2], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][2], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][2], true);

	Index[playerid][3] = CreatePlayerTextDraw(playerid, 468.0000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][3], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][3], 1);
	PlayerTextDrawColor(playerid, Index[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][3], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][3], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][3], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][3], true);

	Index[playerid][4] = CreatePlayerTextDraw(playerid, 364.5000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][4], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][4], 1);
	PlayerTextDrawColor(playerid, Index[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][4], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][4], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][4], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][4], true);

	Index[playerid][5] = CreatePlayerTextDraw(playerid, 399.0000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][5], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][5], 1);
	PlayerTextDrawColor(playerid, Index[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][5], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][5], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][5], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][5], true);

	Index[playerid][6] = CreatePlayerTextDraw(playerid, 433.5000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][6], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][6], 1);
	PlayerTextDrawColor(playerid, Index[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][6], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][6], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][6], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][6], true);

	Index[playerid][7] = CreatePlayerTextDraw(playerid, 468.0000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][7], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][7], 1);
	PlayerTextDrawColor(playerid, Index[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][7], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][7], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][7], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][7], true);

	Index[playerid][8] = CreatePlayerTextDraw(playerid, 364.5000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][8], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][8], 1);
	PlayerTextDrawColor(playerid, Index[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][8], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][8], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][8], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][8], 0.0000, 0.0000, 0.0000, 1.0000);
    PlayerTextDrawSetSelectable(playerid, Index[playerid][8], true);

	Index[playerid][9] = CreatePlayerTextDraw(playerid, 399.0000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][9], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][9], 1);
	PlayerTextDrawColor(playerid, Index[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][9], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][9], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][9], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][9], true);

	Index[playerid][10] = CreatePlayerTextDraw(playerid, 433.5000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][10], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][10], 1);
	PlayerTextDrawColor(playerid, Index[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][10], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][10], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][10], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][10], true);

	Index[playerid][11] = CreatePlayerTextDraw(playerid, 468.0000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][11], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][11], 1);
	PlayerTextDrawColor(playerid, Index[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][11], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][11], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][11], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][11], true);

	Index[playerid][12] = CreatePlayerTextDraw(playerid, 364.5000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][12], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][12], 1);
	PlayerTextDrawColor(playerid, Index[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][12], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][12], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][12], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][12], true);

	Index[playerid][13] = CreatePlayerTextDraw(playerid, 399.0000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][13], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][13], 1);
	PlayerTextDrawColor(playerid, Index[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][13], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][13], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][13], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][13], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][13], true);

	Index[playerid][14] = CreatePlayerTextDraw(playerid, 433.5000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][14], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][14], 1);
	PlayerTextDrawColor(playerid, Index[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][14], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][14], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][14], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][14], true);

	Index[playerid][15] = CreatePlayerTextDraw(playerid, 468.0000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][15], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][15], 1);
	PlayerTextDrawColor(playerid, Index[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][15], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][15], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][15], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][15], 0.0000, 0.0000, 0.0000, 1.0000);
	PlayerTextDrawSetSelectable(playerid, Index[playerid][15], true);

	Inv[playerid][36] = CreatePlayerTextDraw(playerid, 371.0000, 308.0667, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][36], 121.0000, 26.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][36], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][36], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][36], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][36], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][36], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][36], 0);

	Inv[playerid][37] = CreatePlayerTextDraw(playerid, 372.0999, 310.0777, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][37], 118.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][37], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][37], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][37], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][37], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][37], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][37], 0);

	Inv[playerid][38] = CreatePlayerTextDraw(playerid, 392.5000, 314.4444, "USE");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][38], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][38], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][38], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][38], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][38], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][38], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][38], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][38], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][38], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][38], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][38], true);

	Inv[playerid][39] = CreatePlayerTextDraw(playerid, 431.5000, 314.4444, "DROP");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][39], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][39], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][39], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][39], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][39], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][39], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][39], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][39], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][39], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][39], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][39], true);

	Inv[playerid][40] = CreatePlayerTextDraw(playerid, 470.0000, 314.4444, "OFF");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][40], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][40], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][40], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][40], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][40], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][40], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][40], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][40], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][40], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][40], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][40], true);

	Inv[playerid][41] = CreatePlayerTextDraw(playerid, 373.0000, 317.4000, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][41], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][41], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][41], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][41], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][41], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][41], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][41], 0);

	Inv[playerid][42] = CreatePlayerTextDraw(playerid, 410.5000, 318.6444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][42], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][42], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][42], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][42], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][42], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][42], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][42], 0);

	Inv[playerid][43] = CreatePlayerTextDraw(playerid, 450.0000, 318.6444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][43], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][43], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][43], 296878079);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][43], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][43], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][43], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][43], 0);

	Inv[playerid][44] = CreatePlayerTextDraw(playerid, 511.0000, 147.5332, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][44], 19.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][44], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][44], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][44], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][44], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][44], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][44], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][44], true);

	Inv[playerid][45] = CreatePlayerTextDraw(playerid, 516.5000, 150.9999, "C");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][45], 0.3665, 1.4319);
	PlayerTextDrawAlignment(playerid, Inv[playerid][45], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][45], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][45], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][45], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][45], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][45], 0);
	
	Inv[playerid][46] = CreatePlayerTextDraw(playerid, 511.0000, 164.4342, "LD_BEAT:chit"); // пусто
	PlayerTextDrawTextSize(playerid, Inv[playerid][46], 19.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][46], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][46], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][46], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][46], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][46], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][46], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][46], true);

	Inv[playerid][47] = CreatePlayerTextDraw(playerid, 517.5997, 168.3009, "P");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][47], 0.3665, 1.4319);
	PlayerTextDrawAlignment(playerid, Inv[playerid][47], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][47], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][47], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][47], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][47], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][47], 0);
}
stock LoadGreenInventory(playerid)
{
    SetPVarInt(playerid, "color", 2);
	Inv[playerid][0] = CreatePlayerTextDraw(playerid, 264.0000, 113.9333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][0], 239.0000, 18.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][0], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][0], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][0], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);

	Inv[playerid][1] = CreatePlayerTextDraw(playerid, 251.5000, 110.4222, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][1], 25.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][1], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][1], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][1], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][1], 0);

	Inv[playerid][2] = CreatePlayerTextDraw(playerid, 490.7000, 110.5666, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][2], 25.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][2], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][2], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][2], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][2], 0);

	Inv[playerid][3] = CreatePlayerTextDraw(playerid, 256.0000, 123.7444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][3], 256.0000, 13.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][3], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][3], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][3], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][3], 0);

	Inv[playerid][4] = CreatePlayerTextDraw(playerid, 265.0000, 119.5333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][4], 238.0000, 2.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][4], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][4], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][4], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][4], 0);

	Inv[playerid][5] = CreatePlayerTextDraw(playerid, 272.2004, 127.9332, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][5], 221.0000, 1.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][5], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][5], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][5], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][5], 0);

	Inv[playerid][6] = CreatePlayerTextDraw(playerid, 256.0000, 134.7666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][6], 256.0000, 2.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][6], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][6], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][6], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][6], 0);

	Inv[playerid][7] = CreatePlayerTextDraw(playerid, 256.0000, 145.2888, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][7], 96.0000, 170.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][7], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][7], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][7], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][7], 0);

	Inv[playerid][8] = CreatePlayerTextDraw(playerid, 259.5998, 151.0110, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][8], 88.0000, 161.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][8], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][8], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][8], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][8], 0);

	Inv[playerid][9] = CreatePlayerTextDraw(playerid, 396.5000, 160.6000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][9], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][9], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][9], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][9], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][9], 0);

	Inv[playerid][10] = CreatePlayerTextDraw(playerid, 385.5000, 182.7222, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][10], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][10], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][10], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][10], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][10], 0);

	Inv[playerid][11] = CreatePlayerTextDraw(playerid, 396.5000, 160.1000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][11], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][11], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][11], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][11], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][11], 0);

	Inv[playerid][12] = CreatePlayerTextDraw(playerid, 232.0000, 154.3777, "");
	PlayerTextDrawTextSize(playerid, Inv[playerid][12], 90.0000, 90.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][12], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][12], 572661504);
	PlayerTextDrawFont(playerid, Inv[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inv[playerid][12], 123);
	PlayerTextDrawSetPreviewRot(playerid, Inv[playerid][12], 0.0000, 0.0000, 20.0000, 1.0000);

	Inv[playerid][13] = CreatePlayerTextDraw(playerid, 290.5000, 172.2221, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][13], 53.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][13], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][13], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][13], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][13], 0);

	Inv[playerid][14] = CreatePlayerTextDraw(playerid, 291.8000, 173.0444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][14], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][14], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][14], 791621631);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][14], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][14], 0);

	Inv[playerid][15] = CreatePlayerTextDraw(playerid, 291.8000, 173.0444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][15], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][15], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][15], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][15], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][15], 0);

	Inv[playerid][16] = CreatePlayerTextDraw(playerid, 311.0000, 172.5777, "HP");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][16], 0.2175, 1.0586);
	PlayerTextDrawAlignment(playerid, Inv[playerid][16], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][16], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][16], 0);

	Inv[playerid][17] = CreatePlayerTextDraw(playerid, 290.5000, 188.3999, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][17], 53.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][17], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][17], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][17], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][17], 0);

	Inv[playerid][18] = CreatePlayerTextDraw(playerid, 291.8000, 189.2221, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][18], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][18], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][18], 791621631);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][18], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][18], 0);

	Inv[playerid][19] = CreatePlayerTextDraw(playerid, 291.8000, 189.6222, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][19], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][19], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][19], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][19], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][19], 0);

	Inv[playerid][20] = CreatePlayerTextDraw(playerid, 306.7997, 188.7555, "ARM");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][20], 0.2175, 1.0586);
	PlayerTextDrawAlignment(playerid, Inv[playerid][20], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][20], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][20], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][20], 0);

	Inv[playerid][21] = CreatePlayerTextDraw(playerid, 302.0000, 250.3555, "REPORT");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][21], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][21], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][21], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][21], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][21], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][21], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][21], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][21], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][21], true);

	Inv[playerid][22] = CreatePlayerTextDraw(playerid, 301.9000, 270.4667, "DONATE");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][22], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][22], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][22], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][22], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][22], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][22], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][22], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][22], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][22], true);

	Inv[playerid][23] = CreatePlayerTextDraw(playerid, 301.9000, 289.7556, "QUEST");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][23], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][23], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][23], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][23], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][23], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][23], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][23], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][23], true);

	Inv[playerid][24] = CreatePlayerTextDraw(playerid, 268.5000, 253.3111, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][24], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][24], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][24], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][24], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][24], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][24], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][24], 0);

	Inv[playerid][25] = CreatePlayerTextDraw(playerid, 268.5000, 273.8444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][25], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][25], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][25], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][25], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][25], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][25], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][25], 0);

	Inv[playerid][26] = CreatePlayerTextDraw(playerid, 268.0000, 291.7667, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][26], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][26], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][26], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][26], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][26], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][26], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][26], 0);

	Inv[playerid][27] = CreatePlayerTextDraw(playerid, 256.0000, 317.1556, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][27], 96.0000, -3.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][27], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][27], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][27], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][27], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][27], 0);

	Inv[playerid][28] = CreatePlayerTextDraw(playerid, 354.0000, 140.2666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][28], 158.0000, 165.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][28], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][28], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][28], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][28], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][28], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][28], 0);

	Inv[playerid][29] = CreatePlayerTextDraw(playerid, 357.5000, 148.1555, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][29], 150.0000, 149.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][29], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][29], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][29], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][29], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][29], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][29], 0);

	Inv[playerid][30] = CreatePlayerTextDraw(playerid, 255.5000, 139.4444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][30], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][30], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][30], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][30], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][30], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][30], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][30], 0);

	Inv[playerid][31] = CreatePlayerTextDraw(playerid, 255.5000, 139.4444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][31], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][31], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][31], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][31], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][31], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][31], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][31], 0);

	Inv[playerid][32] = CreatePlayerTextDraw(playerid, 288.0000, 140.2221, "PLAYER");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][32], 0.2455, 1.1146);
	PlayerTextDrawAlignment(playerid, Inv[playerid][32], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][32], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][32], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][32], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][32], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][32], 0);

	Inv[playerid][33] = CreatePlayerTextDraw(playerid, 357.5000, 147.5333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][33], 150.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][33], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][33], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][33], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][33], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][33], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][33], 0);

	Inv[playerid][34] = CreatePlayerTextDraw(playerid, 356.5000, 147.5333, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][34], 157.0000, 10.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][34], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][34], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][34], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][34], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][34], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][34], 0);

	Inv[playerid][35] = CreatePlayerTextDraw(playerid, 408.5000, 147.6888, "INVENTORY");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][35], 0.2455, 1.1146);
	PlayerTextDrawAlignment(playerid, Inv[playerid][35], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][35], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][35], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][35], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][35], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][35], 0);

	Index[playerid][0] = CreatePlayerTextDraw(playerid, 364.5000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][0], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][0], 1);
	PlayerTextDrawColor(playerid, Index[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][0], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][0], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][1] = CreatePlayerTextDraw(playerid, 399.0000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][1], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][1], 1);
	PlayerTextDrawColor(playerid, Index[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][1], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][1], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][2] = CreatePlayerTextDraw(playerid, 433.5000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][2], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][2], 1);
	PlayerTextDrawColor(playerid, Index[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][2], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][2], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][2], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][3] = CreatePlayerTextDraw(playerid, 468.0000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][3], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][3], 1);
	PlayerTextDrawColor(playerid, Index[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][3], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][3], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][3], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][4] = CreatePlayerTextDraw(playerid, 364.5000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][4], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][4], 1);
	PlayerTextDrawColor(playerid, Index[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][4], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][4], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][4], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][5] = CreatePlayerTextDraw(playerid, 399.0000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][5], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][5], 1);
	PlayerTextDrawColor(playerid, Index[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][5], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][5], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][5], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][6] = CreatePlayerTextDraw(playerid, 433.5000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][6], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][6], 1);
	PlayerTextDrawColor(playerid, Index[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][6], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][6], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][6], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][7] = CreatePlayerTextDraw(playerid, 468.0000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][7], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][7], 1);
	PlayerTextDrawColor(playerid, Index[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][7], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][7], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][7], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][8] = CreatePlayerTextDraw(playerid, 364.5000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][8], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][8], 1);
	PlayerTextDrawColor(playerid, Index[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][8], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][8], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][8], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][8], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][9] = CreatePlayerTextDraw(playerid, 399.0000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][9], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][9], 1);
	PlayerTextDrawColor(playerid, Index[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][9], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][9], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][9], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][10] = CreatePlayerTextDraw(playerid, 433.5000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][10], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][10], 1);
	PlayerTextDrawColor(playerid, Index[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][10], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][10], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][10], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][11] = CreatePlayerTextDraw(playerid, 468.0000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][11], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][11], 1);
	PlayerTextDrawColor(playerid, Index[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][11], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][11], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][11], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][12] = CreatePlayerTextDraw(playerid, 364.5000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][12], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][12], 1);
	PlayerTextDrawColor(playerid, Index[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][12], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][12], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][12], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][13] = CreatePlayerTextDraw(playerid, 399.0000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][13], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][13], 1);
	PlayerTextDrawColor(playerid, Index[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][13], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][13], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][13], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][13], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][14] = CreatePlayerTextDraw(playerid, 433.5000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][14], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][14], 1);
	PlayerTextDrawColor(playerid, Index[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][14], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][14], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][14], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][15] = CreatePlayerTextDraw(playerid, 468.0000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][15], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][15], 1);
	PlayerTextDrawColor(playerid, Index[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][15], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][15], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][15], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][15], 0.0000, 0.0000, 0.0000, 1.0000);

	Inv[playerid][36] = CreatePlayerTextDraw(playerid, 371.0000, 308.0667, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][36], 121.0000, 26.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][36], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][36], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][36], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][36], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][36], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][36], 0);

	Inv[playerid][37] = CreatePlayerTextDraw(playerid, 372.0999, 310.0777, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][37], 118.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][37], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][37], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][37], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][37], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][37], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][37], 0);

	Inv[playerid][38] = CreatePlayerTextDraw(playerid, 392.5000, 314.4444, "USE");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][38], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][38], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][38], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][38], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][38], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][38], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][38], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][38], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][38], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][38], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][38], true);

	Inv[playerid][39] = CreatePlayerTextDraw(playerid, 431.5000, 314.4444, "DROP");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][39], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][39], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][39], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][39], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][39], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][39], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][39], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][39], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][39], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][39], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][39], true);

	Inv[playerid][40] = CreatePlayerTextDraw(playerid, 470.0000, 314.4444, "OFF");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][40], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][40], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][40], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][40], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][40], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][40], 8405247);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][40], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][40], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][40], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][40], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][40], true);

	Inv[playerid][41] = CreatePlayerTextDraw(playerid, 373.0000, 317.4000, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][41], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][41], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][41], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][41], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][41], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][41], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][41], 0);

	Inv[playerid][42] = CreatePlayerTextDraw(playerid, 410.5000, 318.6444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][42], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][42], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][42], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][42], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][42], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][42], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][42], 0);

	Inv[playerid][43] = CreatePlayerTextDraw(playerid, 450.0000, 318.6444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][43], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][43], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][43], 13986559);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][43], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][43], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][43], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][43], 0);

	Inv[playerid][44] = CreatePlayerTextDraw(playerid, 511.0000, 147.5332, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][44], 19.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][44], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][44], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][44], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][44], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][44], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][44], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][44], true);

	Inv[playerid][45] = CreatePlayerTextDraw(playerid, 516.5000, 150.9999, "C");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][45], 0.3665, 1.4319);
	PlayerTextDrawAlignment(playerid, Inv[playerid][45], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][45], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][45], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][45], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][45], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][45], 0);
	
	for(new i = 0; i < 16; i ++) PlayerTextDrawSetSelectable(playerid, Index[playerid][i], true);
	
	Inv[playerid][46] = CreatePlayerTextDraw(playerid, 511.0000, 164.4342, "LD_BEAT:chit"); // пусто
	PlayerTextDrawTextSize(playerid, Inv[playerid][46], 19.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][46], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][46], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][46], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][46], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][46], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][46], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][46], true);

	Inv[playerid][47] = CreatePlayerTextDraw(playerid, 517.5997, 168.3009, "P");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][47], 0.3665, 1.4319);
	PlayerTextDrawAlignment(playerid, Inv[playerid][47], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][47], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][47], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][47], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][47], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][47], 0);
}
stock LoadPinkInventory(playerid)
{
    SetPVarInt(playerid, "color", 3);
	Inv[playerid][0] = CreatePlayerTextDraw(playerid, 264.0000, 113.9333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][0], 239.0000, 18.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][0], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][0], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][0], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][0], 0);

	Inv[playerid][1] = CreatePlayerTextDraw(playerid, 251.5000, 110.4222, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][1], 25.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][1], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][1], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][1], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][1], 0);

	Inv[playerid][2] = CreatePlayerTextDraw(playerid, 490.7000, 110.5666, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][2], 25.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][2], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][2], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][2], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][2], 0);

	Inv[playerid][3] = CreatePlayerTextDraw(playerid, 256.0000, 123.7444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][3], 256.0000, 13.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][3], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][3], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][3], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][3], 0);

	Inv[playerid][4] = CreatePlayerTextDraw(playerid, 265.0000, 119.5333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][4], 238.0000, 2.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][4], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][4], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][4], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][4], 0);

	Inv[playerid][5] = CreatePlayerTextDraw(playerid, 272.2004, 127.9332, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][5], 221.0000, 1.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][5], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][5], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][5], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][5], 0);

	Inv[playerid][6] = CreatePlayerTextDraw(playerid, 256.0000, 134.7666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][6], 256.0000, 2.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][6], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][6], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][6], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][6], 0);

	Inv[playerid][7] = CreatePlayerTextDraw(playerid, 256.0000, 145.2888, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][7], 96.0000, 170.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][7], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][7], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][7], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][7], 0);

	Inv[playerid][8] = CreatePlayerTextDraw(playerid, 259.5998, 151.0110, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][8], 88.0000, 161.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][8], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][8], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][8], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][8], 0);

	Inv[playerid][9] = CreatePlayerTextDraw(playerid, 396.5000, 160.6000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][9], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][9], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][9], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][9], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][9], 0);

	Inv[playerid][10] = CreatePlayerTextDraw(playerid, 385.5000, 182.7222, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][10], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][10], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][10], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][10], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][10], 0);

	Inv[playerid][11] = CreatePlayerTextDraw(playerid, 396.5000, 160.1000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][11], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][11], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][11], 8438015);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][11], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][11], 0);

	Inv[playerid][12] = CreatePlayerTextDraw(playerid, 232.0000, 154.3777, "");
	PlayerTextDrawTextSize(playerid, Inv[playerid][12], 90.0000, 90.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][12], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][12], 572661504);
	PlayerTextDrawFont(playerid, Inv[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inv[playerid][12], 123);
	PlayerTextDrawSetPreviewRot(playerid, Inv[playerid][12], 0.0000, 0.0000, 20.0000, 1.0000);

	Inv[playerid][13] = CreatePlayerTextDraw(playerid, 290.5000, 172.2221, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][13], 53.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][13], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][13], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][13], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][13], 0);

	Inv[playerid][14] = CreatePlayerTextDraw(playerid, 291.8000, 173.0444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][14], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][14], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][14], 791621631);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][14], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][14], 0);

	Inv[playerid][15] = CreatePlayerTextDraw(playerid, 291.8000, 173.0444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][15], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][15], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][15], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][15], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][15], 0);

	Inv[playerid][16] = CreatePlayerTextDraw(playerid, 311.0000, 172.5777, "HP");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][16], 0.2175, 1.0586);
	PlayerTextDrawAlignment(playerid, Inv[playerid][16], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][16], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][16], 0);

	Inv[playerid][17] = CreatePlayerTextDraw(playerid, 290.5000, 188.3999, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][17], 53.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][17], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][17], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][17], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][17], 0);

	Inv[playerid][18] = CreatePlayerTextDraw(playerid, 291.8000, 189.2221, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][18], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][18], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][18], 791621631);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][18], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][18], 0);

	Inv[playerid][19] = CreatePlayerTextDraw(playerid, 291.8000, 189.6222, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][19], 50.0000, 9.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][19], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][19], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][19], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][19], 0);

	Inv[playerid][20] = CreatePlayerTextDraw(playerid, 306.7997, 188.7555, "ARM");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][20], 0.2175, 1.0586);
	PlayerTextDrawAlignment(playerid, Inv[playerid][20], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][20], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][20], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][20], 0);

	Inv[playerid][21] = CreatePlayerTextDraw(playerid, 302.0000, 250.3555, "REPORT");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][21], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][21], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][21], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][21], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][21], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][21], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][21], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][21], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][21], true);

	Inv[playerid][22] = CreatePlayerTextDraw(playerid, 301.9000, 270.4667, "DONATE");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][22], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][22], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][22], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][22], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][22], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][22], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][22], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][22], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][22], true);

	Inv[playerid][23] = CreatePlayerTextDraw(playerid, 301.9000, 289.7556, "QUEST");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][23], 0.2860, 1.3760);
	PlayerTextDrawTextSize(playerid, Inv[playerid][23], 10.0000, 59.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][23], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][23], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][23], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][23], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][23], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][23], true);

	Inv[playerid][24] = CreatePlayerTextDraw(playerid, 268.5000, 253.3111, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][24], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][24], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][24], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][24], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][24], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][24], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][24], 0);

	Inv[playerid][25] = CreatePlayerTextDraw(playerid, 268.5000, 273.8444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][25], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][25], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][25], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][25], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][25], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][25], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][25], 0);

	Inv[playerid][26] = CreatePlayerTextDraw(playerid, 268.0000, 291.7667, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][26], 68.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][26], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][26], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][26], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][26], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][26], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][26], 0);

	Inv[playerid][27] = CreatePlayerTextDraw(playerid, 256.0000, 317.1556, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][27], 96.0000, -3.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][27], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][27], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][27], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][27], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][27], 0);

	Inv[playerid][28] = CreatePlayerTextDraw(playerid, 354.0000, 140.2666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][28], 158.0000, 165.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][28], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][28], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][28], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][28], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][28], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][28], 0);

	Inv[playerid][29] = CreatePlayerTextDraw(playerid, 357.5000, 148.1555, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][29], 150.0000, 149.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][29], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][29], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][29], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][29], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][29], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][29], 0);

	Inv[playerid][30] = CreatePlayerTextDraw(playerid, 255.5000, 139.4444, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][30], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][30], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][30], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][30], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][30], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][30], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][30], 0);

	Inv[playerid][31] = CreatePlayerTextDraw(playerid, 255.5000, 139.4444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][31], 97.0000, 12.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][31], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][31], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][31], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][31], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][31], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][31], 0);

	Inv[playerid][32] = CreatePlayerTextDraw(playerid, 288.0000, 140.2221, "PLAYER");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][32], 0.2455, 1.1146);
	PlayerTextDrawAlignment(playerid, Inv[playerid][32], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][32], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][32], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][32], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][32], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][32], 0);

	Inv[playerid][33] = CreatePlayerTextDraw(playerid, 357.5000, 147.5333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][33], 150.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][33], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][33], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][33], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][33], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][33], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][33], 0);

	Inv[playerid][34] = CreatePlayerTextDraw(playerid, 356.5000, 147.5333, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][34], 157.0000, 10.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][34], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][34], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][34], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][34], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][34], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][34], 0);

	Inv[playerid][35] = CreatePlayerTextDraw(playerid, 408.5000, 147.6888, "INVENTORY");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][35], 0.2455, 1.1146);
	PlayerTextDrawAlignment(playerid, Inv[playerid][35], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][35], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][35], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][35], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][35], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][35], 0);

	Index[playerid][0] = CreatePlayerTextDraw(playerid, 364.5000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][0], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][0], 1);
	PlayerTextDrawColor(playerid, Index[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][0], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][0], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][1] = CreatePlayerTextDraw(playerid, 399.0000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][1], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][1], 1);
	PlayerTextDrawColor(playerid, Index[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][1], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][1], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][2] = CreatePlayerTextDraw(playerid, 433.5000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][2], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][2], 1);
	PlayerTextDrawColor(playerid, Index[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][2], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][2], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][2], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][3] = CreatePlayerTextDraw(playerid, 468.0000, 163.0888, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][3], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][3], 1);
	PlayerTextDrawColor(playerid, Index[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][3], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][3], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][3], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][4] = CreatePlayerTextDraw(playerid, 364.5000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][4], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][4], 1);
	PlayerTextDrawColor(playerid, Index[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][4], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][4], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][4], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][5] = CreatePlayerTextDraw(playerid, 399.0000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][5], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][5], 1);
	PlayerTextDrawColor(playerid, Index[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][5], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][5], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][5], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][6] = CreatePlayerTextDraw(playerid, 433.5000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][6], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][6], 1);
	PlayerTextDrawColor(playerid, Index[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][6], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][6], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][6], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][7] = CreatePlayerTextDraw(playerid, 468.0000, 195.4444, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][7], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][7], 1);
	PlayerTextDrawColor(playerid, Index[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][7], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][7], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][7], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][8] = CreatePlayerTextDraw(playerid, 364.5000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][8], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][8], 1);
	PlayerTextDrawColor(playerid, Index[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][8], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][8], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][8], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][8], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][9] = CreatePlayerTextDraw(playerid, 399.0000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][9], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][9], 1);
	PlayerTextDrawColor(playerid, Index[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][9], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][9], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][9], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][10] = CreatePlayerTextDraw(playerid, 433.5000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][10], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][10], 1);
	PlayerTextDrawColor(playerid, Index[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][10], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][10], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][10], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][11] = CreatePlayerTextDraw(playerid, 468.0000, 227.8000, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][11], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][11], 1);
	PlayerTextDrawColor(playerid, Index[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][11], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][11], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][11], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][12] = CreatePlayerTextDraw(playerid, 364.5000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][12], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][12], 1);
	PlayerTextDrawColor(playerid, Index[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][12], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][12], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][12], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][13] = CreatePlayerTextDraw(playerid, 399.0000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][13], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][13], 1);
	PlayerTextDrawColor(playerid, Index[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][13], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][13], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][13], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][13], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][14] = CreatePlayerTextDraw(playerid, 433.5000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][14], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][14], 1);
	PlayerTextDrawColor(playerid, Index[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][14], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][14], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][14], 0.0000, 0.0000, 0.0000, 1.0000);

	Index[playerid][15] = CreatePlayerTextDraw(playerid, 468.0000, 260.1556, "");
	PlayerTextDrawTextSize(playerid, Index[playerid][15], 33.0000, 31.0000);
	PlayerTextDrawAlignment(playerid, Index[playerid][15], 1);
	PlayerTextDrawColor(playerid, Index[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, Index[playerid][15], 1061109759);
	PlayerTextDrawFont(playerid, Index[playerid][15], 5);
	PlayerTextDrawSetProportional(playerid, Index[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, Index[playerid][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, Index[playerid][15], 19382);
	PlayerTextDrawSetPreviewRot(playerid, Index[playerid][15], 0.0000, 0.0000, 0.0000, 1.0000);

	Inv[playerid][36] = CreatePlayerTextDraw(playerid, 371.0000, 308.0667, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][36], 121.0000, 26.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][36], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][36], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][36], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][36], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][36], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][36], 0);

	Inv[playerid][37] = CreatePlayerTextDraw(playerid, 372.0999, 310.0777, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, Inv[playerid][37], 118.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][37], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][37], 252645375);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][37], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][37], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][37], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][37], 0);

	Inv[playerid][38] = CreatePlayerTextDraw(playerid, 392.5000, 314.4444, "USE");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][38], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][38], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][38], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][38], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][38], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][38], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][38], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][38], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][38], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][38], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][38], true);

	Inv[playerid][39] = CreatePlayerTextDraw(playerid, 431.5000, 314.4444, "DROP");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][39], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][39], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][39], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][39], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][39], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][39], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][39], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][39], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][39], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][39], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][39], true);

	Inv[playerid][40] = CreatePlayerTextDraw(playerid, 470.0000, 314.4444, "OFF");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][40], 0.2890, 1.3884);
	PlayerTextDrawTextSize(playerid, Inv[playerid][40], 10.0000, 33.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][40], 2);
	PlayerTextDrawColor(playerid, Inv[playerid][40], -1);
	PlayerTextDrawUseBox(playerid, Inv[playerid][40], 1);
	PlayerTextDrawBoxColor(playerid, Inv[playerid][40], -2147467009);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][40], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][40], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][40], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][40], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][40], true);

	Inv[playerid][41] = CreatePlayerTextDraw(playerid, 373.0000, 317.4000, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][41], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][41], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][41], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][41], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][41], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][41], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][41], 0);

	Inv[playerid][42] = CreatePlayerTextDraw(playerid, 410.5000, 318.6444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][42], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][42], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][42], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][42], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][42], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][42], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][42], 0);

	Inv[playerid][43] = CreatePlayerTextDraw(playerid, 450.0000, 318.6444, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, Inv[playerid][43], 40.0000, 11.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][43], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][43], -838834177);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][43], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][43], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][43], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][43], 0);

	Inv[playerid][44] = CreatePlayerTextDraw(playerid, 511.0000, 147.5332, "LD_BEAT:chit");
	PlayerTextDrawTextSize(playerid, Inv[playerid][44], 19.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][44], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][44], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][44], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][44], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][44], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][44], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][44], true);

	Inv[playerid][45] = CreatePlayerTextDraw(playerid, 516.5000, 150.9999, "C");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][45], 0.3665, 1.4319);
	PlayerTextDrawAlignment(playerid, Inv[playerid][45], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][45], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][45], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][45], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][45], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][45], 0);
	for(new i = 0; i < 16; i ++) PlayerTextDrawSetSelectable(playerid, Index[playerid][i], true);
	
	Inv[playerid][46] = CreatePlayerTextDraw(playerid, 511.0000, 164.4342, "LD_BEAT:chit"); // пусто
	PlayerTextDrawTextSize(playerid, Inv[playerid][46], 19.0000, 22.0000);
	PlayerTextDrawAlignment(playerid, Inv[playerid][46], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][46], 522133503);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][46], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][46], 4);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][46], 0);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][46], 0);
	PlayerTextDrawSetSelectable(playerid, Inv[playerid][46], true);

	Inv[playerid][47] = CreatePlayerTextDraw(playerid, 517.5997, 168.3009, "P");
	PlayerTextDrawLetterSize(playerid, Inv[playerid][47], 0.3665, 1.4319);
	PlayerTextDrawAlignment(playerid, Inv[playerid][47], 1);
	PlayerTextDrawColor(playerid, Inv[playerid][47], -1);
	PlayerTextDrawBackgroundColor(playerid, Inv[playerid][47], 255);
	PlayerTextDrawFont(playerid, Inv[playerid][47], 1);
	PlayerTextDrawSetProportional(playerid, Inv[playerid][47], 1);
	PlayerTextDrawSetShadow(playerid, Inv[playerid][47], 0);
}

stock SetAccessoriesToSkin(playerid, type, skinid, objectid)
{
	if(type == 1)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
	    switch(skinid)
	    {
	    	case 1..311: SetPlayerAttachedObject(playerid, 1, 2469, 1, 0.0430, -0.0910, -0.0400, 90.9000, 0.0000, 79.6001, 0.6240, 0.7230, 0.7240, -1, -1);
		}
	}
	else if(type == 2)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.204000,-0.064999,-0.002999 ,  -0.600000,-1.100000,0.000000 ,  1.075999,0.918998,0.905000 );
			case 2: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.237000,-0.064999,-0.002999 ,  -0.600000,-1.100000,0.000000 ,  1.075999,0.918998,0.905000 );
			case 3: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.228000,-0.062999,-0.002999 ,  -0.600000,-1.100000,0.000000 ,  1.075999,0.918998,0.905000 );
			case 4: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.194000,-0.056999,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,0.918998,0.905000 );
			case 5: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.194000,-0.117999,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,1.000998,0.905000 );
			case 6: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.194000,-0.079999,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,1.000998,0.905000 );
			case 7: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.219000,-0.057999,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  1.075999,1.000998,0.905000 );
			case 8: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.207000,-0.061999,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.962998,0.834000 );
			case 9: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.207000,-0.058999,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.962998,0.834000 );
			case 10: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.262000,-0.071999,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.962998,0.834000 );
			case 11: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.189000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 12: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.184000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 13: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.116000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 14: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.158000,-0.068000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 15: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 17: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.156000,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 18: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.184999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 19: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.129999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 20: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.159999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 21: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.159999,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 22: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.243000,-0.077000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 23: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.167000,-0.077000,-0.014999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 24: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.145000,-0.077000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 25: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.145000,-0.077000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 28: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.145000,-0.077000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 29: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.188000,-0.103000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 30: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.188000,-0.103000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 31: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.239000,-0.103000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 32: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.173000,-0.068999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 33: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.199000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 34: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.150000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 35: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.161000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 36: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.161000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 37: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.161000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 38: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.222000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 39: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.222000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 40: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.172000,-0.080999,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 41: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.172000,-0.067000,-0.017999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 42: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.172000,-0.067000,-0.017999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 43: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.196000,-0.067000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 44: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.203000,-0.067000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 45: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.171999,-0.067000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 46: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 47: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 48: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 49: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 50: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.151999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 53: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.218999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 54: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.232999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 55: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.174999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 56: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.174999,-0.074000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 57: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.116999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 58: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.202999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 59: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 60: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 61: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 62: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 65: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.115999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 66: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 67: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 68: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 69: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.141999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 70: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.146999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 71: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.146999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 72: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.155999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 73: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.167999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 76: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.162999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 77: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.207999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 78: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.118999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 79: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.143999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 82: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.156999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 83: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.136999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 84: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.136999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.834000 );
			case 86: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  1.049000,0.911998,0.888999 );
			case 88: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.124999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.911998,0.753999 );
			case 89: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.124999,-0.085000,-0.010999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.911998,0.753999 );
			case 90: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.048999,-0.057000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.999998,0.826000 );
			case 91: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.048999,-0.057000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000 );
			case 93: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.048999,-0.067000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000 );
			case 94: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.122999,-0.067000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000 );
			case 95: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.113999,-0.067000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000 );
			case 96: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.022999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000 );
			case 97: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.071999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.696000 );
			case 98: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.058999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.806000 );
			case 100: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.046999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.719998,0.806000 );
			case 101: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.046999,-0.112000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.853998,0.900000 );
			case 102: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.055999,-0.081000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.840000,0.853998,0.900000 );
			case 103: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.055999,-0.123000,-0.008999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 104: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.097999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 105: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.035999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 106: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.088999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 107: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.093999,-0.101000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 108: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 109: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 110: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 111: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.051999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.987000 );
			case 112: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.107999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 113: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 114: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 115: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.082999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 116: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.082999,-0.069000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 117: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.105999,-0.080000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 118: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.105999,-0.080000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 119: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.105999,-0.080000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 120: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.105999,-0.080000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 121: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.101000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 122: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.101000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 123: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.098999,-0.101000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 124: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.096999,-0.076000,-0.015999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 125: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.096999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 126: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.096999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 127: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.105999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 128: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.112999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 129: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.186999,-0.076000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 130: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.153999,-0.085000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 131: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.069000,-0.003999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 132: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.175999,-0.069000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 133: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.089999,-0.078000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 134: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.156999,-0.064000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 135: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.093999,-0.094000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.881000 );
			case 136: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.161999,-0.082000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 137: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.111999,-0.086000,-0.006999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 142: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.076999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 143: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 144: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 146: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.094000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 147: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.099999,-0.068000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 148: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.099999,-0.068000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 150: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.099999,-0.060000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 151: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.099999,-0.081000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 152: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.115999,-0.064000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 153: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.089999,-0.072000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 154: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.107999,-0.072000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 155: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.086000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 156: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.083999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 157: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.089999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 158: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.089999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 159: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.089999,-0.086000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 160: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.105999,-0.065000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 161: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.067999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 162: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 163: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.050999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 164: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.050999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 165: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.127999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 166: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.127999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 170: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.065999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 171: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 172: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.095999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 173: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 174: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 175: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 176: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 177: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 179: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.081999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 180: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.079999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 181: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.066999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 182: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.088999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 183: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.088999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 184: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 185: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 186: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 187: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 188: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.083999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 189: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.094999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 190: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.058999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 191: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.058999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 192: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.065999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 193: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.065999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 194: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 195: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.044999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 198: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.075999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 200: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 201: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 202: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 203: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.072000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 204: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 206: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.075999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 207: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 208: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.095999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 210: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.154999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 211: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.063999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 212: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.148999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 213: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 214: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 215: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 216: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.092999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 217: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 219: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.083999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 220: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 221: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 222: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 223: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 224: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 225: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 226: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.103999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 227: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.043999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 228: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.068999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 229: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.139999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 230: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.103999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 233: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.067999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 234: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.131999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 235: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.131999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 236: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.131999,-0.072000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 239: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.045999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 240: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.085999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 247: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.072999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 248: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.075999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 250: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.078999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 252: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.063999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 253: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.113999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 254: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.062999,-0.078000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 255: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 258: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 259: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.077999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 261: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.130999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 262: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.082999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 263: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.088999,-0.078000,-0.002999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 265: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.089999,-0.078000,-0.011999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 266: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.097999,-0.078000,-0.011999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 267: SetPlayerAttachedObject (playerid, 1, objectid, 1,   0.121000,-0.078000,-0.030000 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 269: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.064999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 270: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.064999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 271: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 272: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.102999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 273: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.109999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 274: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.066999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 275: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.066999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 276: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.066999,-0.102000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 280: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.065999,-0.090000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 281: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.073999,-0.090000,-0.012999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 282: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.080999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 283: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.080999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 284: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.088999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 285: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.069999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 286: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.069999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 287: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.073999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 288: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.073999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 289: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.079999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 290: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.079999,-0.090000,-0.005999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 291: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.084999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 292: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.057999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 293: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.060999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 294: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.070999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 295: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.135999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 296: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.130999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 297: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.082999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 298: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.082999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 299: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.050999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 300: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 301: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 302: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 303: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 304: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 305: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.090000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 306: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 307: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 308: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 309: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 310: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			case 311: SetPlayerAttachedObject (playerid, 1, objectid, 1,   -0.074999,-0.086000,-0.009999 ,  -0.600000,-1.100000,2.399999 ,  0.894000,0.853998,0.809000 );
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 3)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid, 2);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120999,0.000000,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 3: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.140000,0.001999,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 4: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.161000,0.001999,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 5: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.152000,-0.004000,-0.000000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 7: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.152000,0.007999,-0.003000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 9: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,0.000999,-0.003000, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 11: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,0.000999,0.001999, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 12: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,-0.018000,0.001999, 3.400000,87.100013,88.299980, 1.000000,1.116000,1.000000);
			case 14: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,0.019999,0.001999, 3.400000,87.100013,88.299980, 1.014000,1.183000,1.000000);
			case 15: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.111000,-0.022000,0.001999, 3.400000,87.100013,88.299980, 0.920000,1.077000,1.000000);
			case 17: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 0.920000,1.077000,1.000000);
			case 18: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000);
			case 20: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.150000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000);
			case 21: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127000,0.004999,0.001999, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000);
			case 25: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127000,0.015999,0.004000, 3.400000,87.100013,88.299980, 1.010999,1.077000,1.000000);
			case 26: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127000,0.015999,0.004000, 3.400000,87.100013,88.299980, 1.095999,1.077000,1.000000);
			case 28: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127000,0.024999,-0.001000, 3.400000,87.100013,88.299980, 1.172999,1.160000,1.000000);
			case 30: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127000,0.016999,0.000999, 3.400000,87.100013,88.299980, 1.172999,1.160000,1.000000);
			case 40: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,-0.008000,0.003999, 3.400000,87.100013,88.299980, 1.172999,1.178000,1.000000);
			case 44: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,0.018999,0.003999, 3.400000,87.100013,88.299980, 0.858999,0.969000,1.000000);
			case 45: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,-0.012000,0.003999, 3.400000,87.100013,88.299980, 0.858999,0.990000,1.000000);
			case 46: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.144000,0.010999,0.003999, 3.400000,87.100013,88.299980, 0.959999,1.083999,1.000000);
			case 47: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.144000,-0.000000,0.003999, 3.400000,87.100013,88.299980, 0.959999,1.122000,1.000000);
			case 48: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.151000,-0.008000,-0.002000, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000);
			case 49: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,0.009999,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000);
			case 54: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,0.028999,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000);
			case 55: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,-0.011000,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000);
			case 56: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,-0.011000,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000);
			case 57: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.147000,0.022999,0.004999, 3.400000,87.100013,88.299980, 1.074999,1.185000,1.000000);
			case 58: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.109000,0.000999,0.004999, 3.400000,87.100013,88.299980, 0.882999,0.963999,1.000000);
			case 59: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.152000,-0.001000,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000);
			case 60: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.006999,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000);
			case 66: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.006999,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000);
			case 67: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.006999,0.000999, 3.400000,87.100013,88.299980, 1.024999,1.054999,1.001000);
			case 68: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.025999,0.001999, 3.400000,87.100013,88.299980, 0.942998,0.978999,1.001000);
			case 69: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,-0.012000,0.002999, 3.400000,87.100013,88.299980, 0.942998,1.102999,1.001000);
			case 70: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.006999,0.007000, 3.400000,87.100013,88.299980, 0.942998,1.102999,1.001000);
			case 72: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.006999,0.008000, 3.400000,87.100013,88.299980, 0.942998,1.102999,1.001000);
			case 73: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.014999,-0.001000, 3.400000,87.100013,88.299980, 0.997998,1.126000,1.001000);
			case 76: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.130000,-0.013000,-0.001000, 3.400000,87.100013,88.299980, 1.016998,1.159000,1.001000);
			case 79: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.112000,0.009999,0.008000, 3.400000,87.100013,88.299980, 0.954998,1.135000,1.001000);
			case 82: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.180000,0.009999,0.008000, 3.400000,87.100013,88.299980, 0.976998,1.135000,1.001000);
			case 83: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.172000,0.001999,0.008000, 3.400000,87.100013,88.299980, 1.003998,1.135000,1.001000);
			case 84: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.175000,-0.001000,0.008000, 3.400000,87.100013,88.299980, 1.005998,1.018000,1.001000);
			case 86: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.005998,1.018000,1.001000);
			case 90: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.108998,1.145000,1.001000);
			case 91: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,-0.001000,0.001999, 3.400000,87.100013,88.299980, 1.135998,1.145000,1.044000);
			case 95: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,-0.013000,0.001999, 3.400000,87.100013,88.299980, 0.939998,1.133000,1.044000);
			case 96: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.016999,0.003000, 3.400000,87.100013,88.299980, 1.019998,1.160000,1.044000);
			case 97: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.001999,0.003000, 3.400000,87.100013,88.299980, 1.055998,1.104000,1.044000);
			case 98: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,0.019999,0.003000, 3.400000,87.100013,88.299980, 1.055998,1.104000,1.044000);
			case 100: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,0.011999,0.005000, 3.400000,87.100013,88.299980, 1.116998,1.189000,1.044000);
			case 101: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,0.008999,0.005000, 3.400000,87.100013,88.299980, 1.116998,1.189000,1.044000);
			case 102: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.008999,-0.000999, 3.400000,87.100013,88.299980, 1.116998,1.320001,1.044000);
			case 103: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,0.003999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000);
			case 105: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,0.003999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000);
			case 106: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.147000,-0.010000,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000);
			case 108: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.138000,0.001999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000);
			case 109: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139000,0.006999,0.001000, 3.400000,87.100013,88.299980, 1.116998,1.184001,1.044000);
			case 111: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.134000,0.009000,0.000000, 1.699999,90.200042,89.400001, 1.000000,1.000000,1.000000);
			case 112: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.099000,0.009000,0.000000, 1.699999,90.200042,89.400001, 1.000000,1.000000,1.000000);
			case 113: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.145999,0.005000,0.000000, 1.699999,90.200042,89.400001, 1.012999,1.100999,1.000000);
			case 114: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.145999,0.005000,0.000000, 1.699999,90.200042,89.400001, 1.062999,1.139999,1.000000);
			case 117: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.112000,0.018999,0.000000, 1.699999,90.200042,89.400001, 0.937999,1.009999,1.000000);
			case 118: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.112000,0.018999,0.000000, 1.699999,90.200042,89.400001, 0.937999,1.009999,1.000000);
			case 119: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133999,0.010999,0.000999, 1.699999,90.200042,89.400001, 0.937999,1.099999,1.000000);
			case 120: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133999,-0.003000,0.000999, 1.699999,90.200042,89.400001, 1.072000,1.099999,1.000000);
			case 121: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133999,0.000999,0.000999, 1.699999,90.200042,89.400001, 1.072000,1.148000,1.000000);
			case 122: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133999,0.000999,0.000999, 1.699999,90.200042,89.400001, 0.972000,1.061000,1.000000);
			case 123: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.141000,0.000999,-0.003000, 1.699999,90.200042,89.400001, 1.165000,1.223000,1.000000);
			case 124: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.141000,0.006999,0.003999, 1.699999,90.200042,89.400001, 1.056000,1.085000,1.000000);
			case 125: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120999,0.006999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.085000,1.000000);
			case 126: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.134000,0.000999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000);
			case 127: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.134000,0.010999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000);
			case 128: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.150000,0.010999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000);
			case 131: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.109000,0.010999,-0.000000, 1.699999,90.200042,89.400001, 1.056000,1.106000,1.000000);
			case 132: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.042000,0.000999,-0.000000, 1.699999,90.200042,89.400001, 0.942000,0.921000,1.000000);
			case 142: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133000,0.000999,-0.001000, 1.699999,90.200042,89.400001, 0.942000,1.146000,1.000000);
			case 147: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,-0.013000,0.008999, 1.699999,90.200042,89.400001, 0.942000,1.009000,1.000000);
			case 150: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139000,-0.024000,0.008999, 1.699999,90.200042,89.400001, 0.942000,1.129000,1.000000);
			case 151: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139000,-0.029000,0.000999, 1.699999,90.200042,89.400001, 0.992000,1.235000,1.000000);
			case 154: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,-0.007000,0.000999, 1.699999,90.200042,89.400001, 0.992000,1.029000,1.000000);
			case 156: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.165000,-0.034000,0.000999, 1.699999,90.200042,89.400001, 0.992000,1.198000,1.000000);
			case 157: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,-0.000000,0.000999, 1.699999,90.200042,89.400001, 1.047000,1.198000,1.000000);
			case 160: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,0.003999,0.000999, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000);
			case 162: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.147000,0.003999,0.000999, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000);
			case 163: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.003999,0.000999, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000);
			case 164: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.003999,-0.001000, 1.699999,90.200042,89.400001, 0.854000,0.962999,1.000000);
			case 165: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.003999,-0.001000, 1.699999,90.200042,89.400001, 0.886000,1.061999,1.000000);
			case 166: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126000,0.003999,-0.001000, 1.699999,90.200042,89.400001, 0.886000,1.061999,1.000000);
			case 169: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126000,-0.013000,-0.001000, 1.699999,90.200042,89.400001, 1.030000,1.197999,1.000000);
			case 170: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126000,0.001999,-0.001000, 1.699999,90.200042,89.400001, 0.985000,1.197999,1.000000);
			case 171: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.141000,-0.005000,-0.001000, 1.699999,90.200042,89.400001, 1.070000,1.092000,1.000000);
			case 172: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136000,-0.005000,-0.001000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000);
			case 176: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136000,-0.000000,-0.001000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000);
			case 179: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.137000,0.004999,-0.001000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000);
			case 180: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.159000,-0.009000,-0.003000, 4.000000,90.900016,84.900016, 1.070000,1.179999,1.000000);
			case 182: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.909000,1.015999,1.000000);
			case 183: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.106999,1.000000);
			case 184: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126000,0.004999,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000);
			case 185: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.149000,-0.009000,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000);
			case 186: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.148000,-0.009000,0.000999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000);
			case 187: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.112000,-0.009000,0.004999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000);
			case 188: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.122000,0.004999,0.004999, 4.000000,90.900016,84.900016, 0.992000,1.112000,1.000000);
			case 189: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136000,-0.000000,0.004999, 4.000000,90.900016,84.900016, 1.079001,1.112000,1.070999);
			case 191: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.153000,-0.015000,0.004999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999);
			case 192: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.153000,-0.015000,0.004999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999);
			case 193: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.153000,-0.006000,0.004999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999);
			case 194: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.153000,-0.006000,0.000999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999);
			case 200: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.140000,-0.006000,0.000999, 4.000000,90.900016,84.900016, 1.126001,1.186000,1.070999);
			case 206: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.140000,0.020999,0.000999, 4.000000,90.900016,84.900016, 0.903001,1.018000,1.070999);
			case 207: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.090000,0.005999,0.000999, 4.000000,90.900016,84.900016, 0.903001,1.018000,1.070999);
			case 212: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.903001,1.018000,1.070999);
			case 213: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126000,0.007999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.116000,1.070999);
			case 217: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.140000,0.007999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.116000,1.070999);
			case 220: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,0.023999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.116000,1.070999);
			case 221: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.154000,-0.011000,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.283000,1.070999);
			case 222: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.151000,-0.024000,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.283000,1.070999);
			case 223: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.161000,0.002999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.113000,1.070999);
			case 226: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.122000,-0.016000,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999);
			case 227: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.122000,0.026999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999);
			case 228: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.147000,0.001999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999);
			case 229: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.101000,0.001999,0.000999, 4.000000,90.900016,84.900016, 1.023001,1.182000,1.070999);
			case 235: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.067000,0.007999,0.000999, 4.000000,90.900016,84.900016, 0.900001,1.023000,1.070999);
			case 236: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110000,-0.001000,0.000999, 4.000000,90.900016,84.900016, 0.900001,1.023000,1.070999);
			case 240: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.146000,-0.001000,0.000999, 4.000000,90.900016,84.900016, 0.995001,1.180000,1.070999);
			case 247: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.146000,-0.003000,0.000999, 4.000000,90.900016,84.900016, 1.114001,1.180000,1.070999);
			case 248: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.174000,-0.003000,0.000999, 4.000000,90.900016,84.900016, 1.114001,1.180000,1.070999);
			case 250: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.125000,0.007999,-0.007000, 4.000000,90.900016,84.900016, 1.022000,1.180000,1.070999);
			case 252: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.134000,0.004999,-0.007000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999);
			case 254: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142000,0.000999,-0.001000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999);
			case 258: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142000,0.000999,-0.001000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999);
			case 259: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142000,0.000999,-0.001000, 4.000000,90.900016,84.900016, 1.149001,1.213000,1.070999);
			case 262: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.122000,0.009999,-0.001000, 4.000000,90.900016,84.900016, 0.954001,1.015000,1.070999);
			case 265: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,0.009999,-0.001000, 4.000000,90.900016,84.900016, 0.954001,1.015000,1.070999);
			case 266: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.114000,0.009999,-0.001000, 4.000000,90.900016,84.900016, 0.954001,1.190000,1.070999);
			case 267: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.104000,0.002999,-0.001000, 4.000000,90.900016,84.900016, 1.005001,1.190000,1.070999);
			case 268: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.114000,0.002999,-0.001000, 4.000000,90.900016,84.900016, 1.005001,1.190000,1.070999);
			case 272: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.005001,1.190000,1.070999);
			case 273: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.099000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 274: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 275: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 276: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 280: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 281: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 282: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 286: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.060001,1.131000,1.070999);
			case 291: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.150000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 1.141000,1.131000,1.070999);
			case 292: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.098000,0.015999,-0.001000, 4.000000,90.900016,84.900016, 0.912000,1.110000,1.070999);
			case 294: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.143000,0.004999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.110000,1.070999);
			case 295: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.004999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.110000,1.070999);
			case 296: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.143000,-0.021000,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.110000,1.070999);
			case 297: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.155000,-0.010000,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999);
			case 299: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.155000,0.012999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999);
			case 300: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.012999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999);
			case 301: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.012999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999);
			case 302: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.014999,0.001999, 4.000000,90.900016,84.900016, 1.040000,1.182000,1.070999);
			case 303: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.090000,1.070999);
			case 304: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.090000,1.070999);
			case 305: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999);
			case 310: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999);
			case 311: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119000,0.014999,-0.001000, 4.000000,90.900016,84.900016, 1.040000,1.194000,1.070999);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 4)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.069000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 2: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.068000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 3: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.068000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 4: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.109000,0.025000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 5: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.132000,0.013000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 6: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.013000,0.010999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 7: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 8: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 9: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 10: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 11: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 12: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 13: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 14: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 15: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.069000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 16: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.069000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 17: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.069000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 18: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.074000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 19: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.074000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 20: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.074000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 21: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 22: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 23: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 24: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 25: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 26: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 27: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 28: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 29: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 30: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 31: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 32: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.029000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 33: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.022000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 34: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.031000,0.022000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 35: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.063000,0.031000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 36: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.063000,0.031000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 37: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.063000,0.031000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 38: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 39: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 40: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 41: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.080000,0.010999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 42: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.080000,0.026000,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 43: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.080000,0.021999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 44: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 45: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 46: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 47: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 48: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 49: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,0.008999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 50: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,-0.002000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 51: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 52: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 53: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 54: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.015999,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 59: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 60: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 61: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 62: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 63: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 64: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 65: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 66: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 67: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 68: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 69: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 70: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 71: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 72: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 73: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 74: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.089000,0.047000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 75: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.015000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 76: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.015000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 77: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 78: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 79: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 80: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 81: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 82: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 83: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.023000,0.028000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 84: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 85: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.083000,0.023000,0.016000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 86: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 87: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 88: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,-0.009999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 89: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,-0.009999, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 90: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 91: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 92: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 93: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 94: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 95: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 96: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 97: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 98: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 99: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 100: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 101: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 102: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 103: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 104: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 105: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 106: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 107: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 108: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 109: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 110: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 111: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 112: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 113: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 114: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 115: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 116: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 117: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 118: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.086000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 119: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.079000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 120: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 121: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 122: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 123: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 124: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 125: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 126: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.010000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 127: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.024000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 128: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 129: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 130: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 131: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.007000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 132: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 133: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 134: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 135: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.087000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 136: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.076000,0.023000,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 137: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 138: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 139: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 140: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 141: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 142: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.030000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 143: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 144: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.023000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 145: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.032000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 146: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.108000,0.032000,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 147: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.104000,0.036999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 148: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.104000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 149: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.094000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 150: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.101000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 151: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.101000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 152: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.101000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 153: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.081000,0.016999,0.003000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 154: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.102000,0.016999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 155: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.102000,0.016999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 156: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.102000,0.016999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 157: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.091000,0.009999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 158: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.009999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 159: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.018999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 160: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.089000,0.018999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 161: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.097000,0.018999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 162: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.014000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 163: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 164: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 165: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 166: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 167: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 168: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 169: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 170: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.020000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 171: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 172: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 173: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 174: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 175: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 176: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 177: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 178: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 179: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.022000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 180: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.015000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 181: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.015000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 182: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.090000,0.026999,0.015000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 183: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.081000,0.026999,0.009000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 184: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.021000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 185: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.021000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 186: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 187: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 188: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 189: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 190: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 191: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 192: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 193: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 194: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 195: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 196: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 197: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 198: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 199: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.005000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 200: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 201: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 202: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 203: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 204: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 205: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 206: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 207: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.013000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 208: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 209: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 210: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 211: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 212: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.093000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 213: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.093000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 214: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.093000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 215: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.111000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 216: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.111000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 217: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 218: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 219: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.099000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 220: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.109000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 221: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 222: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 223: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 224: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 225: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 226: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 227: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 228: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.106000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 229: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 230: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 231: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 232: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 233: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 234: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 235: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 236: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 237: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 238: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 239: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 240: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 241: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 242: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 243: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 244: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 245: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 246: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.012000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 247: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 248: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 249: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 250: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 251: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 252: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 253: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 254: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 255: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 256: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 257: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 258: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 259: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 260: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.088000,0.026999,0.017000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 261: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 262: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 263: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 264: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.070000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 265: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.102000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 266..310: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			case 311: SetPlayerAttachedObject (playerid, 3, objectid, 5,  0.077000,0.026999,0.008000, 0.000000,-89.999992,0.000000, 1.000000,1.000000,1.000000);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 5)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
		switch(skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.080000,-0.118999,-0.045999, 0.000000,113.100006,0.000000, 0.717999,1.000000,0.702999);
			case 2: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.023000,-0.130000,-0.034000, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000);
			case 3: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.023000,-0.127000,-0.034000, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000);
			case 4: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.063000,-0.119000,-0.034000, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000);
			case 5: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.082999,-0.159000,-0.052999, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000);
			case 6: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.082999,-0.148999,-0.052999, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000);
			case 7: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.082999,-0.120999,-0.052999, 0.000000,119.000015,0.000000, 0.688000,1.000000,0.696000);
			case 9: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.095999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000);
			case 12: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.076999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000);
			case 13: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.084999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000);
			case 14: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.089999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000);
			case 15: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.111999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000);
			case 17: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.096999,-0.052999, 8.699999,119.000015,-3.999999, 0.688000,1.000000,0.696000);
			case 18: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.108999,-0.052999, -8.800000,119.000007,8.100000, 0.688000,1.000000,0.696000);
			case 19: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.108999,-0.052999, 2.799998,119.000007,0.900001, 0.688000,1.000000,0.696000);
			case 20: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.110999,-0.052999, 10.099999,119.000007,-6.299997, 0.688000,1.000000,0.696000);
			case 21: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.119999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 22: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.142999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 23: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.129999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 24: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.117999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 25: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.117999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 28: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.106999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 29: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.145999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 30: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.105999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 32: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.079999,-0.052999, 8.299997,120.000000,-6.299997, 0.688000,1.000000,0.696000);
			case 33: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.102999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 34: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.102999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 35: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.113999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 36: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.113999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 37: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.112999,-0.113999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 43: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.094999,-0.112999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 44: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.094999,-0.092999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 45: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.134999,-0.106999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 46: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.134999,-0.134999,-0.052999, -2.700004,113.800003,4.400001, 0.688000,1.000000,0.696000);
			case 47: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.120999,-0.052999, 10.799995,114.099998,-4.700001, 0.688000,1.000000,0.696000);
			case 48: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.109999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 57: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.109999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 58: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.082999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 59: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.128999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 60: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.128999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 61: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.103999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 66: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.126999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 67: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.126999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 68: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.099999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 70: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.086000,-0.105999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 71: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.121999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 72: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.097999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 73: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.097999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 78: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.134999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 79: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.129999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 82: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.110999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 83: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.110999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 84: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.130999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 86: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.130999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 94: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.095999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 95: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.107000,-0.088999,-0.024999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 96: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.150000,-0.118999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 97: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.150000,-0.106999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 98: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.150000,-0.123999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 100: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.150000,-0.111999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 101: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.150000,-0.137999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 102: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.150000,-0.116999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 103: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.157000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 104: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.140999,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 105: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.163000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 106: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.134000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 107: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.134000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 108: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.104000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 109: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 110: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 111: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 112: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 113: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 114: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.109000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 115: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.117000,-0.014999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 116: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.099000,-0.130000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 119: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.121000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 120: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.132000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 121: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.141000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 122: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.108000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 123: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.123000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 124: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.083000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 125: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.109000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 126: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.123000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 127: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.127000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 128: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.097000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 132: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.090000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 133: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.099000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 134: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.087000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 135: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.120000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 136: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.084000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 137: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.087000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 141: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.083000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 142: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.141000,-0.135000,-0.032999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 143: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.058000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 144: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.058000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 147: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.058000,-0.102000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 148: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.088000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 150: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.077000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 153: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.098000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 154: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.112000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 155: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.139000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 156: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 158: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 159: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 160: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.089000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 161: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.109000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 162: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.101000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 164: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.103000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 165: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 166: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 167: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 168: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 169: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.083000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 170: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.116000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 171: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.110000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 172: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.076000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 173: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 174: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 175: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 176: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.134000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 177: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.134000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 179: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 180: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.122000,-0.130000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 181: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.162000,-0.096000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 182: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.070000,-0.120000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 183: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.070000,-0.099000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 184: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 185: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.126000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 186: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.126000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 187: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.102000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 188: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.100000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 189: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.119000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 200: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.107000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 202: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.102000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 203: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 204: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 206: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.101000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 208: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.122999,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 212: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.082000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 213: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.114000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 217: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.097000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 220: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 221: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 222: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 223: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.133000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 227: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 228: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 230: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.083000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 231: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.105000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 234: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.085000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 235: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.098000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 236: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.086000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 239: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.118000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 240: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.124000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 241: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.139000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 242: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.137000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 247: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 248: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.106000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 249: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.113000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 250: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.113000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 254: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 255: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.104000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 258: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.131000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 259: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.131000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 261: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 262: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 265: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.137000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 266: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.092000,-0.137000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 267: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.292000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 269: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.052000,-0.178000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 270: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.133000,-0.127000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 271: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 272: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.134000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 273: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.111000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 274: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 275: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 276: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 280: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 281: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 282: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 283: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 284: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.121000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 286: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.135000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 288: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 289: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 290: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.124000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 291: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.116000,-0.124000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 292: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.176000,-0.108000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 294: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.176000,-0.128000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 295: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.059000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 296: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.059000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 297: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.094000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 299: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.131000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 300: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 301: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 302: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 303: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 304: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 305: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.123000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 306: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 307: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 308: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 309: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.090000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 310: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			case 311: SetPlayerAttachedObject (playerid, 1, objectid, 1, 0.114000,-0.122000,-0.052999, 4.199994,119.299995,-4.700001, 0.688000,1.000000,0.696000);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 6)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid, 2);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,-0.001000,0.000000, -92.499984,-7.199993,-98.099990, 1.114999,1.000000,0.901000);
			case 3: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,0.006999,0.007000, -92.499984,-7.199993,-98.099990, 1.188999,1.256000,1.157000);
			case 4: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.141999,-0.000000,0.001999, -92.499984,-7.199993,-98.099990, 1.175999,1.256000,1.083999);
			case 5: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.141999,-0.000000,0.001999, -92.499984,-7.199993,-98.099990, 1.175999,1.256000,1.083999);
			case 7: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.123000,0.017000,0.001999, -84.299972,-5.799993,-98.099990, 1.216999,1.256000,1.011999);
			case 9: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.091000,0.003000,0.001999, -84.299972,-5.799993,-98.099990, 1.237999,1.256000,1.057999);
			case 14: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.104000,0.013000,0.006000, -91.399986,-5.799993,-92.200004, 1.262999,1.256000,1.122999);
			case 15: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.071000,-0.015999,-0.000000, -91.399986,-5.799993,-92.200004, 1.181999,1.256000,0.974999);
			case 17: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.100000,0.009000,-0.000000, -91.399986,-5.799993,-92.200004, 1.262999,1.256000,0.974999);
			case 18: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.085999,0.003000,-0.000000, -91.399986,-5.799993,-92.200004, 0.994999,1.256000,1.021000);
			case 20: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116999,0.003000,-0.000000, -91.399986,-5.799993,-92.200004, 1.037999,1.256000,1.094000);
			case 21: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116999,0.003000,-0.000000, -91.399986,-5.799993,-92.200004, 1.132999,1.256000,1.094000);
			case 25: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116999,0.003000,0.004000, -91.399986,-5.799993,-92.200004, 1.157999,1.056999,0.877000);
			case 26: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116999,0.003000,0.004000, -91.399986,-5.799993,-92.200004, 1.005999,1.056999,1.086000);
			case 30: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116999,0.003000,-0.002000, -91.399986,-5.799993,-92.200004, 1.277999,1.056999,1.107000);
			case 44: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.097999,0.016000,-0.000000, -91.399986,-5.799993,-92.200004, 1.022999,1.056999,0.863000);
			case 45: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.097999,-0.002999,-0.000000, -91.399986,-5.799993,-92.200004, 1.022999,1.056999,1.034000);
			case 46: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120999,0.020000,-0.000000, -91.399986,-5.799993,-92.200004, 1.135999,1.056999,1.154000);
			case 47: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120999,0.011000,-0.000000, -91.399986,-5.799993,-92.200004, 1.135999,1.056999,1.154000);
			case 48: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.130999,-0.004999,-0.000000, -91.399986,-5.799993,-92.200004, 1.189999,1.056999,1.195000);
			case 57: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.130999,0.024000,-0.000000, -91.399986,-5.799993,-92.200004, 1.189999,1.056999,1.195000);
			case 58: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.092000,0.002000,-0.000000, -91.399986,-5.799993,-92.200004, 1.002999,1.056999,0.939000);
			case 59: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126999,0.006000,-0.000000, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,1.119000);
			case 60: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107999,0.001000,-0.000000, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,0.950000);
			case 66: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107999,0.001000,0.000999, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,0.950000);
			case 68: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107999,0.027000,0.000999, -91.399986,-5.799993,-92.200004, 1.115999,1.301999,0.950000);
			case 69: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107999,-0.017999,0.003999, -91.399986,-5.799993,-92.200004, 1.160999,1.301999,0.950000);
			case 70: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107999,0.012000,0.004999, -91.399986,-5.799993,-92.200004, 1.160999,1.301999,0.950000);
			case 76: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107999,-0.019999,0.004999, -91.399986,-5.799993,-92.200004, 1.160999,1.301999,1.005000);
			case 86: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.096000,-0.010999,0.000999, -91.399986,-5.799993,-92.200004, 1.084999,1.358999,0.969000);
			case 91: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.096000,-0.010999,0.007000, -91.399986,-5.799993,-92.200004, 1.206999,1.358999,1.074000);
			case 95: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.096000,-0.010999,-0.000000, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,0.977000);
			case 96: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.114000,0.004000,0.001999, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,0.977000);
			case 97: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.092000,-0.004999,0.001999, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,0.977000);
			case 98: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.099000,0.021000,0.001999, -91.399986,-5.799993,-92.200004, 1.095999,1.358999,1.086000);
			case 100: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.007000,0.001999, -91.399986,-5.799993,-92.200004, 1.133999,1.358999,1.158000);
			case 101: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,0.003000,0.001999, -91.399986,-5.799993,-92.200004, 1.133999,1.358999,1.158000);
			case 106: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115000,-0.001999,-0.004000, -91.399986,-5.799993,-92.200004, 1.318998,1.358999,1.158000);
			case 111: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.197998,1.126999,0.946000);
			case 112: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.086000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.055998,1.126999,0.946000);
			case 113: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.126999,1.101000);
			case 117: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.080998,1.126999,0.975000);
			case 118: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.080998,1.126999,0.975000);
			case 119: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.105000,0.010000,0.001999, -91.399986,-5.799993,-92.200004, 1.167998,1.126999,0.975000);
			case 120: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,-0.005999,0.001999, -91.399986,-5.799993,-92.200004, 1.167998,1.126999,1.113000);
			case 121: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,0.000000,0.001999, -91.399986,-5.799993,-92.200004, 1.167998,1.126999,1.113000);
			case 123: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,0.000000,-0.002000, -91.399986,-5.799993,-92.200004, 1.242998,1.126999,1.113000);
			case 124: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,0.000000,-0.002000, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000);
			case 125: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120000,0.008000,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000);
			case 126: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,-0.009999,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000);
			case 127: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129000,0.008000,0.001999, -91.399986,-5.799993,-92.200004, 1.179998,1.157999,1.061000);
			case 147: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095000,-0.003999,0.006000, -91.399986,-5.799993,-92.200004, 1.119998,1.157999,1.061000);
			case 148: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095000,-0.003999,0.006000, -91.399986,-5.799993,-92.200004, 1.181998,1.157999,1.135000);
			case 151: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095000,-0.003999,0.006000, -91.399986,-5.799993,-92.200004, 1.449998,1.497999,1.211000);
			case 154: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095000,-0.003999,0.001999, -91.399986,-5.799993,-92.200004, 1.075998,1.218000,1.063000);
			case 156: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,-0.002999,0.001999, -91.399986,-5.799993,-92.200004, 1.325998,1.434000,1.209000);
			case 160: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.084000,0.015000,0.001999, -91.399986,-5.799993,-92.200004, 1.171998,1.086000,0.945000);
			case 162: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.007000,0.001999, -91.399986,-5.799993,-92.200004, 1.171998,1.086000,0.945000);
			case 163: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.007000,0.001999, -91.399986,-5.799993,-92.200004, 1.000998,1.086000,0.897000);
			case 164: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.002000,0.001999, -91.399986,-5.799993,-92.200004, 1.037998,1.086000,1.023000);
			case 165: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.002000,0.001999, -91.399986,-5.799993,-92.200004, 1.037998,1.086000,1.023000);
			case 166: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.010000,0.005000, -91.399986,-5.799993,-92.200004, 1.037998,1.086000,1.023000);
			case 170: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.010000,-0.001999, -91.399986,-5.799993,-92.200004, 1.091998,1.086000,1.215000);
			case 171: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,-0.007999,0.003000, -91.399986,-5.799993,-92.200004, 1.091998,1.086000,1.142000);
			case 176: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132000,-0.007999,0.003000, -91.399986,-5.799993,-92.200004, 1.157998,1.086000,1.142000);
			case 179: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.112000,0.006000,0.003000, -91.399986,-5.799993,-92.200004, 1.157998,1.086000,1.142000);
			case 180: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139000,-0.006000,0.000000, -91.399986,-5.799993,-92.200004, 1.157998,1.086000,1.142000);
			case 182: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.044998,1.086000,1.035000);
			case 183: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.044998,1.086000,1.035000);
			case 184: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000);
			case 185: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.135000,-0.002999,0.000000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000);
			case 186: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124000,-0.010000,0.000000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000);
			case 187: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,-0.010000,0.007000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000);
			case 188: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103000,-0.001000,0.007000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000);
			case 189: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.125000,-0.008000,0.007000, -91.399986,-5.799993,-92.200004, 1.115998,1.086000,1.088000);
			case 191: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.125000,-0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.160998,1.306000,1.239000);
			case 192: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.125000,-0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.160998,1.306000,1.239000);
			case 200: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.125000,-0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.222998,1.306000,1.103000);
			case 206: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.020999,0.001000, -91.399986,-5.799993,-92.200004, 1.038998,1.306000,0.880000);
			case 207: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.087000,0.006999,-0.000999, -91.399986,-5.799993,-92.200004, 1.038998,1.306000,0.880000);
			case 210: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.087000,-0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.038998,1.306000,0.880000);
			case 213: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.109000,-0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.180998,1.306000,0.950000);
			case 217: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.006000,0.002000, -91.399986,-5.799993,-92.200004, 1.180998,1.306000,0.950000);
			case 221: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,0.002000,0.002000, -91.399986,-5.799993,-92.200004, 1.301998,1.306000,1.174000);
			case 222: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,-0.007999,0.002000, -91.399986,-5.799993,-92.200004, 1.301998,1.306000,1.204000);
			case 223: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.017000,0.002000, -91.399986,-5.799993,-92.200004, 1.122998,1.306000,1.145000);
			case 227: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.017000,0.002000, -91.399986,-5.799993,-92.200004, 1.122998,1.306000,1.145000);
			case 228: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.004000,0.002000, -91.399986,-5.799993,-92.200004, 1.122998,1.306000,1.145000);
			case 229: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.097000,-0.009999,0.002000, -91.399986,-5.799993,-92.200004, 1.200998,1.306000,1.009000);
			case 234: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.116000,-0.020999,0.002000, -91.399986,-5.799993,-92.200004, 0.980998,1.115000,0.973000);
			case 235: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.064000,-0.004999,0.002000, -91.399986,-5.799993,-92.200004, 1.021999,1.115000,0.973000);
			case 236: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095000,-0.003999,0.002000, -91.399986,-5.799993,-92.200004, 1.051999,1.115000,1.028000);
			case 240: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.010000,0.002000, -91.399986,-5.799993,-92.200004, 1.131999,1.115000,1.182000);
			case 250: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.131999,1.115000,1.182000);
			case 252: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.131999,1.115000,1.182000);
			case 258: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128000,0.001000,0.002000, -91.399986,-5.799993,-92.200004, 1.237999,1.115000,1.182000);
			case 259: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.104000,-0.002999,0.002000, -91.399986,-5.799993,-92.200004, 1.302999,1.267000,1.182000);
			case 262: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.093000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.099999,1.267000,1.007000);
			case 265: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.093000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.099999,1.267000,1.007000);
			case 266: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.093000,0.002000,-0.000999, -91.399986,-5.799993,-92.200004, 1.200999,1.267000,0.945000);
			case 267: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.100000,-0.008999,0.001000, -91.399986,-5.799993,-92.200004, 1.152999,1.267000,0.993000);
			case 272: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.122000,0.000000,0.001000, -91.399986,-5.799993,-92.200004, 1.152999,1.267000,0.993000);
			case 273: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.081000,0.003000,0.001000, -91.399986,-5.799993,-92.200004, 1.152999,1.267000,0.993000);
			case 274: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.092000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000);
			case 275: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.092000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000);
			case 276: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.102000,0.012000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000);
			case 280: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.102000,0.016000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000);
			case 281: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.102000,0.004000,0.001000, -91.399986,-5.799993,-92.200004, 1.148999,1.267000,0.966000);
			case 282: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110000,0.011000,0.001000, -91.399986,-5.799993,-92.200004, 1.058999,1.267000,0.956000);
			case 286: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110000,0.005000,0.001000, -91.399986,-5.799993,-92.200004, 1.058999,1.267000,0.956000);
			case 292: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110000,-0.002999,0.001000, -91.399986,-5.799993,-92.200004, 1.058999,1.267000,0.956000);
			case 295: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110000,0.002000,0.001000, -91.399986,-5.799993,-92.200004, 1.177999,1.267000,1.027000);
			case 296: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,-0.017999,0.001000, -91.399986,-5.799993,-92.200004, 1.177999,1.267000,1.027000);
			case 300: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000);
			case 301: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000);
			case 302: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000);
			case 303: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.267000,0.925000);
			case 304: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000);
			case 305: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000);
			case 310: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000);
			case 311: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117000,0.006000,-0.000999, -91.399986,-5.799993,-92.200004, 1.137999,1.160000,0.918000);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 7)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.102998,0.030999,-0.001001, 0.000000,90.000000,90.500007, 1.000000,1.058000,1.000000);
			case 2: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.039999,-0.001001, 0.000000,90.000000,90.500007, 1.000000,1.058000,1.000000);
			case 3: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.104998,0.044999,-0.000001, 0.000000,90.000000,90.500007, 1.000000,1.099000,1.080000);
			case 4: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.128998,0.026999,-0.001000, 76.200012,73.100074,15.000033, 1.000000,1.130000,1.080000);
			case 5: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.128998,0.037999,-0.005000, 138.500000,87.300071,-47.999965, 1.000000,1.217000,1.080000);
			case 6: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.105997,0.029999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.017000,1.080000);
			case 7: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.098997,0.054999,-0.007000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 8: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088997,0.040999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 9: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.066997,0.034999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 10: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.081997,0.039999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 11: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.076998,0.039999,0.000999, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 12: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.076998,0.035999,0.001999, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 13: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.082998,0.031999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.134000,1.080000);
			case 14: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.094998,0.056999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 15: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079998,0.019999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 17: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.098998,0.035999,0.000999, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 19: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.081998,0.035999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 20: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.102998,0.030999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 21: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093998,0.047999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 22: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093998,0.047999,-0.007000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 23: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.102998,0.047999,-0.007000, 138.500000,87.300071,-47.999965, 1.000000,1.166000,1.080000);
			case 24: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.037999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.085000,1.080000);
			case 25: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.034999,0.000999, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 26: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086998,0.036999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 27: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.096998,0.036999,-0.003000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 28: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.096998,0.046999,-0.006000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 29: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.051999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 31: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.052999,-0.004000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 39: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.080998,0.034999,-0.005000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 40: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.071998,0.030999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 41: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079998,0.042999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 42: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.036999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,1.145000,1.080000);
			case 44: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.041999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,1.029000,1.027000);
			case 46: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.095998,0.059999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000);
			case 49: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093998,0.035999,-0.004000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000);
			case 50: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.105998,0.012999,-0.008000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000);
			case 54: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085998,0.052999,-0.000000, 138.500000,87.300071,-47.999965, 1.000000,1.155000,1.027000);
			case 58: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.028999,-0.002000, 138.500000,87.300071,-47.999965, 1.000000,0.994000,1.027000);
			case 59: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.036999,-0.001000, 138.500000,87.300071,-47.999965, 1.000000,1.100000,1.027000);
			case 60: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.050999,-0.005000, 138.500000,87.300071,-47.999965, 1.000000,1.130000,1.027000);
			case 61: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087998,0.048999,-0.004000, 138.500000,87.300071,-47.999965, 0.880000,0.993001,1.027000);
			case 66: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.097998,0.041999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 67: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.097998,0.041999,-0.000000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 68: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.051999,-0.002000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 69: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.070998,0.048999,-0.002000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 70: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.055999,0.005999, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 71: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.033999,-0.000000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 72: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.053999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 73: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.045999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.076001,1.027000);
			case 76: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.072998,0.041999,-0.001000, 138.500000,87.300071,-47.999965, 0.880000,1.127000,1.027000);
			case 78: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.114998,0.023999,0.007999, -121.799896,96.400039,-147.299835, 0.880000,0.983000,1.027000);
			case 79: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.094998,0.036999,0.009999, -121.799896,96.400039,-147.299835, 0.880000,0.983000,1.027000);
			case 83: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.042999,-0.000000, -121.799896,96.400039,-147.299835, 0.880000,0.983000,1.027000);
			case 90: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.076998,0.046999,-0.000000, -121.799896,96.400039,-147.299835, 0.880000,1.069000,1.027000);
			case 91: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.071998,0.040999,-0.000000, -121.799896,96.400039,-147.299835, 0.880000,1.069000,1.027000);
			case 93: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.071998,0.051999,-0.001000, -121.799896,96.400039,-147.299835, 0.880000,1.139000,1.027000);
			case 94: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.045998,0.024999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,0.950000,1.027000);
			case 95: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.084998,0.013999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,0.982000,1.027000);
			case 96: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.106998,0.041999,0.000999, -121.599906,96.400039,-147.299835, 0.880000,1.019000,1.027000);
			case 97: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.060998,0.040999,0.000999, -121.599906,96.400039,-147.299835, 0.880000,1.019000,1.027000);
			case 98: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.094998,0.068999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,1.069000,1.027000);
			case 101: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.042999,0.000999, -121.599906,96.400039,-147.299835, 0.880000,1.069000,1.027000);
			case 102: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.056999,-0.001000, -121.599906,96.400039,-147.299835, 0.880000,1.069000,1.027000);
			case 103: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.050999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,1.116000,1.027000);
			case 105: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.050999,-0.000000, -121.599906,96.400039,-147.299835, 0.880000,1.150000,1.027000);
			case 106: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.098998,0.050999,-0.003000, -121.599906,96.400039,-147.299835, 0.880000,1.150000,1.027000);
			case 107: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.100998,0.039999,-0.003000, -121.599906,96.400039,-147.299835, 1.020000,1.150000,1.027000);
			case 108: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085998,0.037999,0.002999, -121.599906,96.400039,-147.299835, 1.020000,1.150000,1.027000);
			case 109: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085998,0.044999,-0.004000, -121.599906,96.400039,-147.299835, 1.020000,1.147000,1.027000);
			case 110: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085998,0.044999,-0.004000, -121.599906,96.400039,-147.299835, 1.020000,1.126000,1.027000);
			case 111: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.108998,0.029999,-0.003000, -92.899909,88.200088,-176.599822, 1.020000,1.079000,1.027000);
			case 112: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.095998,0.027999,-0.003000, -92.899909,88.200088,-176.599822, 0.904000,0.976999,1.027000);
			case 113: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.109998,0.051999,-0.001000, -92.899909,88.200088,-176.599822, 0.904000,1.115000,1.027000);
			case 117: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085998,0.050999,-0.001000, -92.899909,90.100112,-176.599822, 0.904000,1.115000,1.027000);
			case 118: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085998,0.050999,-0.001000, -92.899909,90.100112,-176.599822, 0.904000,1.115000,1.027000);
			case 119: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.044999,-0.001000, -92.899909,94.700088,-176.599822, 0.904000,1.115000,1.027000);
			case 120: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.040999,0.001999, -92.899909,92.700088,-176.599822, 0.904000,1.115000,1.027000);
			case 121: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.029999,0.001999, -92.899909,100.800102,-176.599822, 1.055000,1.279000,1.162999);
			case 122: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.029999,0.001999, -92.899909,100.800102,-176.599822, 1.055000,1.122000,1.093999);
			case 124: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.101998,0.033999,-0.002001, -92.899909,96.000068,-176.599822, 1.055000,1.122000,1.093999);
			case 125: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.033999,-0.002001, -92.899909,92.200057,-174.999862, 1.025000,1.062000,1.093999);
			case 126: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090998,0.033999,-0.000001, -92.899909,92.200057,-175.999877, 1.025000,1.062000,1.093999);
			case 127: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.101998,0.041999,-0.001001, -92.899909,92.200057,-175.999877, 1.025000,1.062000,1.093999);
			case 128: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.101998,0.047999,-0.003000, -92.899909,92.200057,-175.999877, 1.025000,1.062000,1.093999);
			case 134: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.082998,0.029999,0.001999, -92.899909,103.300056,-179.899917, 0.871000,1.031000,1.093999);
			case 135: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.071998,0.037999,-0.002000, -92.899909,103.300056,-174.699890, 0.871000,1.031000,1.093999);
			case 136: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086998,0.025999,-0.002000, -92.899909,103.300056,-173.099945, 0.871000,1.031000,1.093999);
			case 142: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086998,0.049999,-0.005001, -92.899909,103.300056,-176.499954, 0.871000,1.085999,1.093999);
			case 147: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086998,0.031999,0.005999, -92.899909,103.300056,-176.499954, 0.871000,1.085999,1.093999);
			case 148: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.060998,0.045999,0.003999, -92.899909,97.400032,-176.499954, 0.871000,1.085999,1.093999);
			case 150: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.066998,0.043999,0.002999, -92.899909,97.400032,-176.499954, 0.871000,1.085999,1.093999);
			case 153: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.077998,0.023999,0.007999, -92.899909,105.900032,-176.499954, 0.871000,1.085999,1.093999);
			case 154: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.058998,0.040999,-0.002001, -92.899909,96.300025,-176.099960, 0.871000,1.085999,1.093999);
			case 155: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087998,0.052999,-0.005001, -92.899909,96.300025,-177.899948, 0.871000,1.085999,1.093999);
			case 160: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.100998,0.028999,-0.001000, -92.899909,96.300025,-177.899948, 0.871000,1.085999,1.093999);
			case 163: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.096998,0.030999,-0.001000, -92.899909,97.100036,-177.899948, 0.871000,1.085999,1.093999);
			case 164: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.096998,0.035999,-0.001000, -92.899909,97.100036,-177.899948, 0.871000,1.085999,1.093999);
			case 165: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.075998,0.046999,-0.000001, -92.899909,97.100036,-174.299972, 0.871000,1.085999,1.093999);
			case 166: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.074998,0.043999,-0.000001, -92.899909,97.100036,-175.899978, 0.871000,1.085999,1.093999);
			case 169: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.067998,0.040999,-0.000001, -92.899909,97.100036,-175.899978, 0.871000,1.085999,1.093999);
			case 170: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.053999,-0.005001, -92.899909,92.100044,-175.899978, 0.871000,1.069999,1.093999);
			case 171: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.042999,-0.001000, -92.899909,92.100044,-175.899978, 0.871000,1.116999,1.093999);
			case 172: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.067998,0.044999,0.001999, -92.899909,92.100044,-175.899978, 0.871000,1.116999,1.093999);
			case 176: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.095998,0.047999,-0.005001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999);
			case 177: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.095998,0.041999,-0.007001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999);
			case 179: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.095998,0.043999,-0.005001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999);
			case 180: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.099998,0.043999,-0.005001, -92.899909,92.100044,-175.899978, 0.980000,1.186999,1.093999);
			case 181: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.122998,0.036999,-0.003000, -92.899909,92.100044,-175.899978, 0.980000,1.043999,1.093999);
			case 182: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079998,0.033999,-0.003000, -92.899909,92.100044,-175.899978, 0.980000,1.043999,1.093999);
			case 183: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093998,0.028999,-0.003000, -92.899909,92.100044,-175.899978, 0.980000,1.043999,1.093999);
			case 184: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.050999,-0.006001, -92.899909,92.100044,-175.899978, 0.980000,1.078999,1.093999);
			case 186: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.034999,0.000999, -92.899909,92.100044,-176.700012, 0.980000,1.078999,1.093999);
			case 187: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.075998,0.023999,0.004999, -92.899909,105.300056,-176.700012, 0.980000,1.119999,1.093999);
			case 188: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.034999,-0.000001, -92.899909,105.300056,-173.700042, 0.980000,1.119999,1.093999);
			case 189: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.033999,0.000999, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999);
			case 190: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.040999,-0.003000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999);
			case 191: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.092998,0.040999,-0.003000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999);
			case 192: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087998,0.040999,-0.002000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999);
			case 193: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087998,0.037999,-0.001000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999);
			case 194: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087998,0.037999,-0.001000, -92.899909,92.900062,-173.700042, 0.980000,1.119999,1.093999);
			case 195: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087998,0.036999,0.000999, -92.899909,92.900062,-176.100021, 0.980000,1.119999,1.093999);
			case 200: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.095998,0.037999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,1.119999,1.093999);
			case 202: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.102998,0.041999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999);
			case 206: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.102998,0.041999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999);
			case 210: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.084998,0.022999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999);
			case 211: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.070998,0.040999,-0.001000, -92.899909,92.900062,-176.100021, 0.980000,0.981999,1.093999);
			case 212: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.096998,0.035999,-0.001000, -92.899909,92.900062,-176.100021, 0.839000,0.981999,1.093999);
			case 213: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.098998,0.048999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999);
			case 214: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.063998,0.045999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999);
			case 216: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.063998,0.044999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999);
			case 217: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093998,0.048999,-0.003001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999);
			case 219: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.068998,0.044999,-0.003001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999);
			case 220: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.054998,0.059999,-0.002001, -92.899909,92.900062,-176.100021, 0.839000,1.098999,1.093999);
			case 221: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.096998,0.046999,-0.001001, -92.899909,92.900062,-176.100021, 0.839000,1.161999,1.093999);
			case 222: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.053999,-0.001001, -92.899909,92.900062,-176.100021, 0.839000,1.161999,1.093999);
			case 223: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.071999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999);
			case 224: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.061998,0.045999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999);
			case 225: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.061998,0.045999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999);
			case 226: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.061998,0.045999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999);
			case 227: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.109998,0.057999,-0.000001, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999);
			case 228: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.101998,0.068999,-0.000000, -92.899909,90.000053,-176.100021, 0.839000,1.161999,1.093999);
			case 229: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.073998,0.035999,-0.000000, -92.899909,103.200050,-176.100021, 0.839000,1.161999,1.093999);
			case 230: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.055998,0.035999,-0.000000, -92.899909,103.200050,-176.100021, 0.839000,0.999000,1.093999);
			case 233: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.064998,0.048999,-0.000000, -92.899909,93.900032,-176.100021, 0.839000,0.999000,1.093999);
			case 235: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.053998,0.027999,-0.000000, -92.899909,93.900032,-176.100021, 0.839000,0.999000,1.093999);
			case 236: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.084998,0.038999,-0.000000, -92.899909,93.900032,-176.100021, 0.839000,1.093000,1.093999);
			case 239: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.101998,0.021999,0.004999, -92.899909,106.200004,-176.100021, 0.839000,0.959000,1.093999);
			case 240: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.089998,0.051999,0.000999, -92.899909,87.499969,-176.100021, 0.839000,1.129000,1.093999);
			case 247: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.099998,0.051999,0.000999, -92.899909,96.499946,-176.100021, 0.839000,1.129000,1.093999);
			case 248: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.062999,-0.001000, -92.899909,96.499946,-176.100021, 0.839000,1.182000,1.093999);
			case 250: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.054999,-0.004000, -92.899909,96.499946,-176.100021, 0.839000,1.033000,1.093999);
			case 252: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088998,0.045999,0.000999, -92.899909,96.499946,-176.100021, 0.839000,1.033000,1.093999);
			case 254: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.097998,0.048999,-0.001001, -92.899909,96.499946,-176.100021, 0.839000,1.134000,1.093999);
			case 255: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079998,0.031999,0.005999, -92.899909,96.499946,-176.100021, 0.839000,0.972000,0.954999);
			case 258: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086998,0.057999,0.001999, -92.899909,96.499946,-176.100021, 0.839000,1.079000,1.113999);
			case 259: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086998,0.057999,0.001999, -92.899909,96.499946,-176.100021, 0.839000,1.079000,1.113999);
			case 261: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.094998,0.023999,-0.001001, -92.899909,96.499946,-176.100021, 0.839000,0.945999,1.113999);
			case 262: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.081998,0.048999,-0.002001, -92.899909,88.299957,-177.600051, 0.839000,1.070999,1.113999);
			case 265: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.094997,0.037999,-0.000001, -92.899909,88.299957,-177.600051, 0.839000,1.070999,1.113999);
			case 266: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.103997,0.034999,-0.005001, -92.899909,88.299957,-177.600051, 0.839000,1.097000,1.113999);
			case 267: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.094997,0.036999,-0.001001, -92.899909,97.999961,-175.800079, 0.839000,1.097000,1.113999);
			case 270: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093997,0.036999,-0.001001, -92.899909,97.999961,-175.800079, 0.839000,1.097000,1.113999);
			case 272: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.093997,0.050999,-0.001001, -92.899909,97.999961,-175.800079, 0.839000,1.097000,1.113999);
			case 273: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079997,0.041999,-0.001001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.113999);
			case 274: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.088997,0.035999,-0.003001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.113999);
			case 275: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.113999);
			case 276: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086997,0.033999,-0.001001, -92.899909,91.199951,-177.200103, 0.839000,1.097000,1.027999);
			case 280: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086997,0.037999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 281: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085997,0.036999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 282: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 283: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.082997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 286: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.085997,0.035999,-0.002001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 287: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.072997,0.056999,0.007999, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 288: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086997,0.034999,-0.000001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 291: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.091998,0.050999,-0.000001, -92.899909,91.199951,-177.200103, 0.839000,1.060999,1.027999);
			case 292: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.075997,0.032000,-0.005001, 97.999969,81.400047,-4.900008, 0.878000,1.000000,1.000000);
			case 293: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.083997,0.038999,-0.008001, 97.999969,81.400047,-4.900008, 0.878000,1.000000,1.000000);
			case 295: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079997,0.045999,-0.000001, 95.799949,87.600059,-4.900008, 0.878000,1.087000,1.000000);
			case 296: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.079997,0.040999,-0.000001, 95.799949,67.300048,-4.900008, 0.878000,1.087000,1.000000);
			case 297: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090997,0.044999,-0.000001, 95.799949,81.400077,-4.900008, 0.878000,1.087000,1.000000);
			case 298: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090997,0.033999,-0.004001, 95.799949,81.400077,-4.900008, 0.878000,1.087000,1.000000);
			case 299: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.090997,0.052999,-0.000001, 95.799949,81.400077,-4.900008, 0.878000,1.087000,1.000000);
			case 300: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.083997,0.033999,-0.002001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 301: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.083997,0.033999,-0.002001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 302: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087997,0.033999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 303: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087997,0.033999,-0.001001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 304: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087997,0.033999,-0.001001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 305: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.087997,0.033999,-0.001001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 306: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.066997,0.048999,-0.004001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 307: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.066997,0.048999,-0.004001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 308: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.066997,0.048999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 309: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.066997,0.048999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 310: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086997,0.030999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			case 311: SetPlayerAttachedObject (playerid, 4, objectid, 2,  0.086997,0.030999,-0.003001, 95.799949,89.500076,-3.500008, 0.878000,1.042000,1.000000);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 8)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 2)) RemovePlayerAttachedObject(playerid, 2);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.140998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.000000,1.000000,1.000000);
			case 3: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.140998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.187000,1.000000);
			case 4: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.149998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.187000,1.000000);
			case 5: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.149998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.187000,1.000000);
			case 7: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.138998,0.016000,-0.002001, 0.000000,90.000000,89.900016, 1.217999,1.033000,1.000000);
			case 9: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.112998,0.004999,0.000998, 0.000000,90.000000,95.899993, 1.000000,1.000000,1.000000);
			case 10: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.098997,0.000999,0.000998, 0.000000,90.000000,95.899993, 1.175000,1.000000,1.000000);
			case 11: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115997,0.006999,0.000998, 0.000000,90.000000,95.899993, 1.092000,1.000000,1.000000);
			case 12: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115997,-0.006000,0.000998, 0.000000,90.000000,95.899993, 1.137000,1.050999,1.000000);
			case 14: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127997,0.021999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000);
			case 15: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.104998,-0.013999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000);
			case 17: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.123998,0.017000,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000);
			case 18: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.123997,-0.000999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000);
			case 20: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.138998,-0.000999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000);
			case 21: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126997,-0.000999,0.001998, 0.000000,90.000000,95.899993, 1.137000,1.091999,1.000000);
			case 25: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126997,0.017000,0.001998, 0.000000,90.000000,95.899993, 0.987000,1.091999,0.866999);
			case 26: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126997,0.017000,0.001998, 0.000000,90.000000,95.899993, 1.122000,1.091999,0.866999);
			case 28: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136997,0.021000,0.001998, 0.000000,90.000000,95.899993, 1.181999,1.091999,0.866999);
			case 30: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.130997,0.017000,-0.003001, 0.000000,90.000000,95.899993, 1.181999,1.091999,0.866999);
			case 39: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.104997,0.006000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999);
			case 40: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118997,0.006000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999);
			case 43: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.074997,0.006000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999);
			case 44: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103997,0.027000,-0.003001, 0.000000,90.000000,95.899993, 0.981000,1.091999,0.866999);
			case 45: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.103997,0.009000,-0.003001, 0.000000,90.000000,95.899993, 1.071000,1.091999,0.866999);
			case 46: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129997,0.022000,-0.003001, 0.000000,90.000000,95.899993, 1.071000,1.091999,0.866999);
			case 47: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129997,0.022000,-0.003001, 0.000000,90.000000,95.899993, 1.125999,1.091999,0.866999);
			case 48: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.147997,-0.002999,-0.003001, 0.000000,90.000000,95.899993, 1.125999,1.091999,0.866999);
			case 49: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110997,0.024000,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 54: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.127997,0.035999,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 55: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.123998,-0.014000,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 56: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.123998,-0.014000,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 57: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.158998,0.014999,-0.003001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 58: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.106998,0.005999,-0.002001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 59: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.145998,0.007999,-0.002001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 60: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132998,0.002999,-0.002001, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 62: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.132998,0.012999,0.008999, 0.000000,90.000000,95.899993, 0.964999,1.091999,0.866999);
			case 63: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.000999,0.004999, 0.000000,90.000000,95.899993, 1.104999,1.091999,0.866999);
			case 64: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.007999,0.004999, 0.000000,90.000000,95.899993, 1.104999,1.091999,0.866999);
			case 66: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,0.025999,0.004999, 0.000000,90.000000,95.899993, 1.104999,1.091999,0.866999);
			case 68: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,0.024999,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999);
			case 69: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,-0.004000,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999);
			case 70: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,0.019999,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999);
			case 72: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,0.005999,0.004999, 0.000000,90.000000,95.899993, 0.958999,1.091999,0.866999);
			case 75: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115997,0.015000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000);
			case 76: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115997,0.003000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000);
			case 82: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.151998,0.034000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000);
			case 83: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.151998,0.016000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000);
			case 84: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.157998,0.016000,-0.000001, 0.000000,90.000000,95.400001, 1.151999,1.069000,1.000000);
			case 85: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.157998,0.016000,-0.010001, 0.000000,90.000000,95.400001, 1.151999,1.240999,1.000000);
			case 86: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.101998,0.016000,-0.004000, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000);
			case 88: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.101998,0.027000,-0.004000, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000);
			case 89: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117998,0.007000,0.005999, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000);
			case 90: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117998,0.007000,0.005999, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000);
			case 91: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,-0.001999,0.005999, 0.000000,90.000000,95.400001, 1.151999,1.048999,1.000000);
			case 95: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.100998,-0.003999,0.005999, 0.000000,90.000000,95.400001, 0.967999,1.048999,1.000000);
			case 96: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128998,0.005000,0.005999, 0.000000,90.000000,95.400001, 0.967999,1.048999,1.000000);
			case 97: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107998,-0.011999,0.005999, 0.000000,90.000000,95.400001, 0.967999,1.048999,1.000000);
			case 98: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.122997,0.032000,0.005999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 100: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.131998,0.009000,0.005999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 101: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.143998,0.009000,0.005999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 102: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 103: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 105: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 106: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.002000,0.003999, 0.000000,90.000000,95.400001, 1.117999,1.048999,1.000000);
			case 111: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.002000,-0.002000, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000);
			case 112: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.101997,0.002000,-0.002000, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000);
			case 113: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.137997,0.002000,0.002999, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000);
			case 117: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.114997,0.012000,0.003999, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000);
			case 119: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117997,0.019000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000);
			case 120: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124997,0.004000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.048999,1.000000);
			case 121: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124997,0.004000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000);
			case 122: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118997,0.010000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000);
			case 123: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136997,0.007000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000);
			case 124: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136997,0.007000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000);
			case 125: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129997,0.000000,-0.000001, 0.000000,90.000000,95.400001, 0.980999,1.147000,1.000000);
			case 126: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,-0.003999,0.000999, 0.000000,90.000000,95.400001, 1.009999,1.147000,1.000000);
			case 127: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,-0.003999,0.000999, 0.000000,90.000000,95.400001, 1.009999,1.147000,1.000000);
			case 128: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,0.026000,-0.010001, 0.000000,90.000000,95.400001, 1.009999,1.147000,1.000000);
			case 129: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.100998,0.016000,-0.004000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000);
			case 130: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.065998,0.019000,-0.001000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000);
			case 132: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.035998,0.005000,-0.001000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000);
			case 138: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.128998,0.005000,-0.001000, 0.000000,90.000000,95.400001, 1.009999,0.949999,1.000000);
			case 144: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.173998,-0.007999,-0.001000, 0.000000,90.000000,95.400001, 1.009999,1.087000,1.000000);
			case 147: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,-0.001999,-0.001000, 0.000000,90.000000,95.400001, 1.009999,1.087000,1.000000);
			case 148: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,-0.001999,-0.001000, 0.000000,90.000000,95.400001, 1.009999,1.087000,1.000000);
			case 151: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.131998,-0.004999,0.010999, 0.000000,90.000000,95.400001, 1.176999,1.087000,1.000000);
			case 154: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.109998,0.009000,0.000999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 156: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.151998,-0.002999,0.005999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 157: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.012000,0.005999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 160: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.012000,0.005999, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 163: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 164: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 165: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 166: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,0.012000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 169: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.115998,-0.007999,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 170: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.126998,0.011000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 171: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133998,0.008000,-0.000000, 0.000000,90.000000,95.400001, 1.028999,1.087000,1.000000);
			case 176: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.133998,0.004000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 177: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.182998,-0.009999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 179: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.129998,0.000000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 180: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.154998,-0.003999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 182: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.111998,0.026000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 184: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.120998,0.014000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 185: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136998,0.004000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 186: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136998,0.004000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 187: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110998,-0.006999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 188: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.110998,0.006000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 189: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.136998,0.006000,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 190: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142998,-0.001999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 191: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142998,-0.001999,-0.000000, 0.000000,90.000000,95.400001, 1.062999,1.087000,1.000000);
			case 192: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000);
			case 193: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000);
			case 194: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000);
			case 200: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.137998,0.004999,0.002998, 0.000000,90.000000,96.400009, 1.207000,1.000000,1.000000);
			case 210: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.101998,0.001000,0.002998, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 213: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,0.001000,-0.001001, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 217: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.145998,0.004000,-0.009001, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 221: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.154998,-0.021999,0.001999, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 222: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.154998,-0.021999,0.001999, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 223: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.158998,0.011000,-0.004000, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 227: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.142997,0.015000,0.000999, 0.000000,90.000000,96.400009, 0.946999,1.000000,1.000000);
			case 228: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.150997,0.015000,0.000999, 0.000000,90.000000,96.400009, 1.231999,1.000000,1.000000);
			case 229: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.101998,0.005000,0.000999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000);
			case 234: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.107998,-0.001999,0.001999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000);
			case 235: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.076998,-0.001999,0.001999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000);
			case 236: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095998,0.010000,0.001999, 0.000000,90.000000,96.400009, 0.948999,1.000000,1.000000);
			case 240: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.139998,0.010000,0.001999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000);
			case 250: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119998,0.010000,0.001999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000);
			case 252: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.131998,0.010000,0.005999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000);
			case 258: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.131998,0.003000,0.005999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000);
			case 259: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.131998,0.003000,0.005999, 0.000000,90.000000,96.400009, 1.099999,1.000000,1.000000);
			case 262: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.095998,0.022000,-0.003000, 0.000000,90.000000,96.400009, 0.964999,1.000000,1.000000);
			case 265: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,0.010000,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.079000,1.000000);
			case 266: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,0.010000,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.079000,1.000000);
			case 267: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,-0.009999,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.079000,1.000000);
			case 268: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,0.004000,-0.001000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 272: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.138998,0.004000,-0.005000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 273: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.100998,0.004000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 274: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 275: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 276: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 280: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 281: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 282: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.025000,-0.003000, 0.000000,90.000000,96.400009, 0.987999,1.159999,1.000000);
			case 286: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.019000,-0.003000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 290: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.113998,0.013000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 291: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.141998,0.015000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 292: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 293: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.162998,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 294: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.151998,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 295: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.119997,0.009000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 296: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.137998,-0.005999,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 297: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.145998,0.007000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 298: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.145998,0.007000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 299: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.150998,0.007000,0.001999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 300: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.007000,0.007999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 301: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.007000,0.007999, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 302: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 303: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 304: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 305: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.124998,0.014000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 310: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.117998,0.003000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			case 311: SetPlayerAttachedObject (playerid, 2, objectid, 2, 0.118998,0.003000,-0.004000, 0.000000,90.000000,96.400009, 1.058999,1.159999,1.000000);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	else if(type == 9)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 5)) RemovePlayerAttachedObject(playerid, 5);
		switch (skinid)
		{
			case 1: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.003998,-0.001999, 51.200016,53.199977,142.800018, 0.963999,0.916999,1.000000);
			case 2: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.001999,-0.005999, 51.200016,53.199977,142.800018, 1.226999,1.173999,1.000000);
			case 3: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.001999,-0.007999, 51.200016,53.199977,142.800018, 1.226999,1.173999,1.000000);
			case 4: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.001999,-0.012999, 51.200016,53.199977,142.800018, 1.226999,1.173999,1.000000);
			case 5: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.011000,-0.018998,-0.000999, 51.200016,70.499969,142.800018, 1.354999,1.441999,1.000000);
			case 8: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.011000,-0.003998,-0.011999, 51.200016,70.499969,142.800018, 1.354999,1.441999,1.000000);
			case 11: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.011000,-0.007998,-0.001999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000);
			case 13: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.011000,-0.007998,-0.001999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000);
			case 14: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.011000,-0.007998,-0.001999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000);
			case 15: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.002998,-0.015999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000);
			case 18: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.010998,-0.012999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000);
			case 20: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.006998,-0.006999, 51.200016,70.499969,142.800018, 1.102999,1.100999,1.000000);
			case 21: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.006998,-0.006999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 23: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.006998,-0.006999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 24: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.018999,-0.009998,-0.011999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 25: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.008998,-0.008999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 26: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.008998,-0.008999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 28: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.008998,-0.005999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 30: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.003998,-0.005999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 31: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.003998,-0.005999, 51.200016,70.499969,142.800018, 1.236999,1.188999,1.000000);
			case 32: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.003998,0.008001, 51.200016,70.499969,142.800018, 0.964999,0.921999,1.000000);
			case 34: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.010999,-0.003998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 35: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.054000,-0.003998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 36: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.054000,-0.003998,-0.015999, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 37: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.054000,-0.003998,-0.015999, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 38: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.024000,-0.003998,-0.015999, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 40: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.024000,-0.003998,-0.010998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 41: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,-0.005998,0.001001, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 42: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,-0.005998,-0.012998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 43: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,-0.005998,-0.001998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 44: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,-0.005998,-0.001998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 45: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,-0.015998,-0.008998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 46: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,-0.008998,-0.008998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 47: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.004000,0.001001,-0.000998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 48: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,0.001001,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 49: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.007998,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 51: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.010998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 52: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.010998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 53: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.003998,-0.011998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 55: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.003998,-0.001998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 56: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.003998,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 57: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.026999,0.005001,-0.003998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 58: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003000,-0.003998,-0.007998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 59: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003000,-0.011998,-0.004998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 60: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003000,-0.002998,-0.000998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 61: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.011999,-0.014998,-0.000998, 51.200016,70.499969,142.800018, 1.078999,1.170999,1.000000);
			case 66: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.008998,-0.007998, 51.200016,70.499969,142.800018, 1.271999,1.359999,1.000000);
			case 67: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.008998,-0.007998, 51.200016,70.499969,142.800018, 1.271999,1.359999,1.000000);
			case 69: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.008998,-0.004998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000);
			case 72: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.008998,-0.004998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000);
			case 73: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.010998,-0.004998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000);
			case 78: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.010998,-0.003998, 51.200016,70.499969,142.800018, 0.990999,1.040999,1.000000);
			case 79: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.014998,-0.005998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000);
			case 86: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.014998,-0.005998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000);
			case 88: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,0.001001,-0.028998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000);
			case 90: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.004998,-0.007998, 51.200016,70.499969,142.800018, 1.145999,0.990999,1.000000);
			case 91: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.004998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000);
			case 93: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.004998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000);
			case 94: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.009998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000);
			case 95: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.001998,-0.004998, 51.200016,70.499969,142.800018, 0.925999,0.990999,1.000000);
			case 96: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.017998,-0.008998, 51.200016,70.499969,142.800018, 1.093999,1.223999,1.000000);
			case 97: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.040998,-0.008998, 51.200016,70.499969,142.800018, 1.093999,1.223999,1.000000);
			case 98: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.002998,0.001001, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000);
			case 100: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.002998,-0.002998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000);
			case 101: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.007998,-0.006998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000);
			case 102: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.003998,-0.004998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000);
			case 104: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.009999,0.001001,-0.001998, 51.200016,70.499969,142.800018, 1.216999,1.287999,1.000000);
			case 105: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.026999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.363999,1.386999,1.000000);
			case 106: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.026999,0.000001,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 107: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.014999,0.000001,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 108: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.014999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 109: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.014999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 110: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.014999,-0.003998,0.005001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 112: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.022999,-0.008998,-0.012998, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 114: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.001998,0.001001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 116: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.001998,0.001001, 51.200016,70.499969,142.800018, 1.281999,1.385999,1.000000);
			case 119: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.006000,-0.009998,-0.003998, 51.200016,70.499969,142.800018, 1.128999,1.127999,1.000000);
			case 121: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.004999,-0.007998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000);
			case 122: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.004999,-0.001998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000);
			case 124: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.004999,-0.010998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000);
			case 125: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.004999,-0.010998,-0.003998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000);
			case 126: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.007000,-0.010998,-0.010998, 51.200016,70.499969,142.800018, 1.232999,1.381999,1.000000);
			case 128: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.007000,-0.004998,-0.005998, 51.200016,70.499969,142.800018, 1.232999,1.202999,1.000000);
			case 129: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.024999,-0.005998,-0.005998, 51.200016,70.499969,142.800018, 1.232999,1.202999,1.000000);
			case 132: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.009999,-0.011998,0.013001, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000);
			case 133: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.009999,-0.005998,-0.008998, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000);
			case 134: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.009999,-0.012998,-0.005998, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000);
			case 142: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.004998,-0.001998, 51.200016,70.499969,142.800018, 1.088000,0.977999,1.000000);
			case 147: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.004998,-0.001998, 51.200016,70.499969,142.800018, 0.984000,0.977999,1.000000);
			case 149: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.015998,-0.001998, 51.200016,70.499969,142.800018, 1.120999,1.087999,1.000000);
			case 151: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.010998,-0.005998, 51.200016,70.499969,142.800018, 1.120999,1.087999,1.000000);
			case 154: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.013998,-0.005998, 51.200016,70.499969,142.800018, 1.120999,1.087999,1.000000);
			case 155: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.000998,-0.005998, 51.200016,70.499969,142.800018, 1.250000,1.087999,1.000000);
			case 156: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.009999,-0.000998,-0.009998, 51.200016,70.499969,142.800018, 1.064000,1.210999,1.000000);
			case 160: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.021000,-0.009998,-0.008998, 51.200016,70.499969,142.800018, 1.064000,1.210999,1.000000);
			case 163: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.021000,-0.009998,-0.003998, 51.200016,70.499969,142.800018, 1.212000,1.210999,1.000000);
			case 164: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.021000,-0.009998,-0.003998, 51.200016,70.499969,142.800018, 1.212000,1.210999,1.000000);
			case 165: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.021000,-0.004998,-0.004998, 51.200016,70.499969,142.800018, 1.310000,1.304999,1.000000);
			case 166: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.021000,-0.001998,-0.004998, 51.200016,70.499969,142.800018, 1.310000,1.304999,1.000000);
			case 167: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.021000,-0.010998,-0.013999, 51.200016,70.499969,142.800018, 1.310000,1.304999,1.000000);
			case 169: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.005998,-0.004998, 51.200016,70.499969,142.800018, 1.016000,1.304999,1.000000);
			case 170: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.005998,0.002001, 51.200016,70.499969,142.800018, 1.292000,1.304999,1.000000);
			case 171: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.005998,-0.007998, 51.200016,70.499969,142.800018, 1.292000,1.304999,1.000000);
			case 172: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.008998,0.001001, 51.200016,70.499969,142.800018, 0.956000,1.095999,1.000000);
			case 173: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.006998,0.000001, 51.200016,70.499969,142.800018, 1.195000,1.197999,1.000000);
			case 174: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.195000,1.197999,1.000000);
			case 175: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.450000,1.353999,1.000000);
			case 176: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 177: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.003998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 179: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.001998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 180: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.001998,0.000001, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 181: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.017998,-0.008998, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 184: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.011998,-0.001998, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 185: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.008998,-0.010999, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 188: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.001998,0.000000, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 189: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.007998,-0.008999, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 191: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.007998,-0.008999, 51.200016,70.499969,142.800018, 1.205000,1.137999,1.000000);
			case 192: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 193: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 194: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 195: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.007998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 196: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.003998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 198: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.014998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 200: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.021999,-0.008998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 201: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.021999,-0.008998,-0.000999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 202: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.007998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 206: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.007998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 207: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.007998,-0.004999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 209: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.007998,0.008000, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 210: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.007998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 211: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.011998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 214: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.011998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 215: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.006998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 216: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.006998,-0.003999, 51.200016,70.499969,142.800018, 1.041000,1.137999,1.000000);
			case 217: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.003998,-0.003999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 220: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.010998,-0.003999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 221: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 222: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 223: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 224: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 225: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.219999,1.255999,1.000000);
			case 226: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.005998,-0.006999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 229: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.003998,-0.006999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 231: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.003998,-0.006999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 233: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.006998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 234: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.006998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 235: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.012998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 236: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.012998,-0.002999, 51.200016,70.499969,142.800018, 1.074999,1.255999,1.000000);
			case 239: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.012998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 240: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 247: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 250: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.009998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 252: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 254: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.002998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 255: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.008998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 258: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 259: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 263: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.004998,-0.002999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 265: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 266: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 267: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 269: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.003999,-0.015998,-0.005999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 270: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.004998,0.005001, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 271: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.009000,-0.008998,-0.006999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 273: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.020000,-0.013998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 274: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 275: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 276: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.008000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 280: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 281: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 282: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 283: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.005998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 285: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.001000,-0.002998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 287: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.008998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 288: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 289: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 291: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.015000,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 292: SetPlayerAttachedObject (playerid, 5, objectid, 6, 0.001999,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 293: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.050999,-0.003998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 298: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.028999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 300: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 301: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 302: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 303: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 304: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 305: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 306: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 307: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 308: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 309: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 310: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			case 311: SetPlayerAttachedObject (playerid, 5, objectid, 6, -0.003999,-0.004998,-0.009999, 51.200016,70.499969,142.800018, 1.234999,1.255999,1.000000);
			default: SendClientMessage(playerid, -1, "{ffffff}[{4682b4}Inv{2e8b57}ent{ff1493}ory{ffffff}] Es Nivti Ar Ukendeba Tqvens Skins");
		}
	}
	return true;
}
