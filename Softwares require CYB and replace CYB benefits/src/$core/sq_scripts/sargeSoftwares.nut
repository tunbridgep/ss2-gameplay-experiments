//Re-add software if we don't have the requirements for it
class sargeSoftware extends SqRootScript
{
	function OnFrobInvEnd()
	{	
		local playerCYB = ShockGame.GetStat("Player",eStats.kStatCyber);
		local CYBreq = GetProperty("ReqStatsDesc","CYB");
		
		if (playerCYB < CYBreq)
		{
			//print ("Blocking message");
			ShockGame.AddText(GetStatString("CYB",CYBreq), "Player");
			BlockMessage();
		}
		else
		{
			//We have activated a software from inventory, send the message as if it was picked up normally
			//This allows other mods (like RSD) which add extra functionality to softs when picked up
			//to work correctly when expecting the item to be picked up, rather than used.
			PostMessage(self,"FrobWorldBegin");
			PostMessage(self,"FrobWorldEnd");
		}
	}
	
	function GetStatString(sVal, dVal)
	{
		local strText = Data.GetString("misc", "StatReq", "Item requires %s of %d");
		local s = strText.find("%s");
		strText = strText.slice(0, s) + sVal + strText.slice(s + 2);
		local d = strText.find("%d");
		strText = strText.slice(0, d) + dVal + strText.slice(d + 2);
		return strText;
	}
}