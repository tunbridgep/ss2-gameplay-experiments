// ================================================================================
// Script for replacing AP and Anti-Pers rounds with standard rounds
class sargeReplaceRounds extends SqRootScript
{
	function OnSim()
	{
		if (!GetData("Setup") && message().starting)
		{
			print ("Ammo replace started");
			SetData("Setup",TRUE);
			Init();
		}
		else
		{
			print ("Not replacing object");
		}
	}

	//Run only once per map, not when reloading
	function Init()
	{
		print ("Ammo replace started");
		ReplaceAmmo();
	}
	
	function OnContained()
	{
		if (!GetData("Setup"))
			return;

		print ("contained in " + message().container);
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
			
		foreach (outLink in Link.GetAll(linkkind("~Contains"),self))
		{
			local realLink = sLink(outLink);
			print ("Link found: " + outLink);
			Container.Add(obj, realLink.dest);
		}
		
		//Destroy the source
		Object.Destroy(self);
	}
}