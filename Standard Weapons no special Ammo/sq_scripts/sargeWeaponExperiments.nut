// ================================================================================
// Script for replacing AP and Anti-Pers rounds with standard rounds
class sargeReplaceRounds extends SqRootScript
{
	function OnSim()
	{
		if (message().starting && Object.HasMetaProperty(self, "Non-Standard Ammo Replacer"))
			ReplaceAmmo();
		
		Object.RemoveMetaProperty(self, "Non-Standard Ammo Replacer");
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
		
		//Destroy the source
		Object.Destroy(self);
	}
}