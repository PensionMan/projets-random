if SERVER then
	
    AddCSLuaFile("cl_shopnpc.lua")
    AddCSLuaFile("sh_config.lua")

    include("sh_config.lua")
    include("sv_shopnpc.lua")

else 

    include("cl_shopnpc.lua")
    include("sh_config.lua")

end
