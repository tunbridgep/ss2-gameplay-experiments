class sargeHypoRecycler extends SqRootScript
{
	stackCount = null;

	//Run Once
	function OnBeginScript()
	{
		if (!GetData("Started"))
		{
			SetData("Started",true);
		}
	}

	function OnFrobInvBegin()
	{
		stackCount = GetProperty("StackCount");
	}
	
	function OnFrobInvEnd()
	{
		local newStackCount = GetProperty("StackCount");
		//local tinker = ShockGame.HasTrait("Player", eTrait.kTraitTinker);
		local tinker = true;
		
		local playerCYB = ShockGame.GetStat("Player",eStats.kStatCyber);
		local roll = Data.RandInt(0,8-playerCYB);
		
		if (stackCount != newStackCount && tinker && roll == 0)
		{
			local obj = Object.Create("Empty Hypo");
			ShockGame.AddInvObj(obj);
			ShockGame.RefreshInv();
		}
	}
}

class sargeEmptyHypo extends SqRootScript
{
	function CheckTinker()
	{
		return ShockGame.HasTrait("Player", eTrait.kTraitTinker);
	}

	function OnFrobToolEnd()
	{
		//ShockGame.PreventSwap();		
		local id = message().DstObjId;
		local giveItem = "";
		local researched = Property.Get(id, "ObjState") != eObjState.kObjStateUnresearched;
		local tinker = CheckTinker();
		
		//Determine item type
		if (ShockGame.GetArchetypeName(id) == "Red Serum Canister" && researched)
		{
			giveItem = "Med Patch"
		}
		else if (ShockGame.GetArchetypeName(id) == "White Serum Canister" && researched)
		{
			giveItem = "Psi Booster"
		}
		
		//Give Item
		
		if (giveItem == "")
		{
			//ShockGame.AddText("Can only be used on serum canisters", "Player");
		}
		else if (!tinker)
		{
			ShockGame.PreventSwap();
			ShockGame.AddText("You need the Tinker Trait to use a serum canister", "Player");
		}
		else
		{
			ShockGame.PreventSwap();
			local obj = Object.Create(giveItem);
			ShockGame.AddInvObj(obj);
			ShockGame.RefreshInv();
			//consumeItem(id);
			consumeItem(self);
		}
	}
	
	//Stolen from RSD
	function consumeItem(item)
	{
		// decrease stack count
		Container.StackAdd(item, -1);
		if (Property.Get(item,"StackCount") == 0) {
			ShockGame.DestroyInvObj(item);
		}
		// play success sound
		Sound.PlayEnvSchema(self, "Event Activate", 0, 0, eEnvSoundLoc.kEnvSoundAmbient);
	}
}

class sargeEmptyHypoNoTinker extends sargeEmptyHypo
{
	function CheckTinker()
	{
		return true;
	}
}