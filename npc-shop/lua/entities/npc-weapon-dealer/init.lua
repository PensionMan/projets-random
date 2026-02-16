AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("wepdealermsg")

function ENT:Initialize()

    self:SetModel( "models/player/combine_soldier.mdl" ) 
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE ) 
    self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject() 
    if phys:IsValid() then 
        phys:Wake() 
    end

    self:ResetSequence("idle_all_01")
end

local antinetspam = CurTime()

function ENT:Use(ply)
    if antinetspam > CurTime() || !IsValid(ply) then return end 
    antinetspam = CurTime() + 0.5

    net.Start("wepdealermsg")
    net.Send(ply)
end
