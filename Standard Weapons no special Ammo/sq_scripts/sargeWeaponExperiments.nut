// ================================================================================
// Script for replacing AP and Anti-Pers rounds with standard rounds
class sargeReplaceRounds extends SqRootScript
{
    static REPLACE_CHANCE = 50;

	function OnSim()
	{
		if (message().starting)
			ReplaceAmmo();
	}
	
	function FixLinks(obj,linkType)
	{
		foreach (outLink in Link.GetAll(linkkind(linkType),self))
		{
			local realLink = sLink(outLink);
			Link.Create(linkkind(linkType),obj,realLink.dest);
		}
	}
	
	//Replace with standard bullets
	function ReplaceAmmo()
	{

        local rand = Data.RandInt(0,100);

        if (rand > REPLACE_CHANCE)
            return;

		//Create standard bullets
		local arch = "Standard Clip";
		
		if (GetProperty("StackCount") == 6)
			arch = "Small Standard Clip";
		
		
		local obj = Object.Create(arch);
		Object.Teleport(obj, Object.Position(self), Object.Facing(self));
		
		//Fix contains links
		foreach (outLink in Link.GetAll(linkkind("~Contains"),self))
		{
			local realLink = sLink(outLink);
			Container.Add(obj, realLink.dest);
		}
		
		//Randomiser Compatibility
		FixLinks(obj,"Target");
		FixLinks(obj,"SwitchLink");
		FixLinks(obj,"~SwitchLink");
		
		//Remove MetaProp from new object so it doesn't change on map load
		Object.RemoveMetaProperty(obj, "Non-Standard Ammo Replacer");
		
		//Destroy the source
		Object.Destroy(self);
	}
}
