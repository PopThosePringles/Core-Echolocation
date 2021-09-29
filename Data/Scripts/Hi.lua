local YOOTIL = require(script:GetCustomProperty("YOOTIL"))

local sphere = script:GetCustomProperty("sphere"):WaitForObject()
local pulse = script:GetCustomProperty("pulse"):WaitForObject()
local sketch = script:GetCustomProperty("sketch"):WaitForObject()

local local_player = Game.GetLocalPlayer()

local tween = nil
local tween_out = nil

sphere:AttachToPlayer(local_player, "pelvis")

function Tick(dt)
	pulse:SetWorldPosition(local_player:GetWorldPosition())

	if(local_player:GetVelocity().size > 60) then
		if(tween ~= nil) then
			tween:tween(dt)
		else
			tween_out = nil
			tween = YOOTIL.Tween:new(3, { 
				
				s = 0, x = sphere:GetWorldScale().x, 
				r = sketch:GetSmartProperty("Silhouette Line Color").r,
				g = sketch:GetSmartProperty("Silhouette Line Color").g,
				b = sketch:GetSmartProperty("Silhouette Line Color").b
			
			}, { 
				
				s = 1, x = 20, r = 1, g = 1, b = 1
			
			})

			tween:on_change(function(c)
				pulse:SetSmartProperty("Pulse Scale", c.s)
				sphere:SetWorldScale(Vector3.New(c.x, c.x, c.x))
				sketch:SetSmartProperty("Silhouette Line Color", Color.New(c.r, c.g, c.b))
				sketch:SetSmartProperty("Crease Line Color", Color.New(c.r, c.g, c.b))
			end)

			tween:on_complete(function()
				tween = nil
			end)
		end
	else
		tween = nil

		if(tween_out == nil and pulse:GetSmartProperty("Pulse Scale") > 0) then
			tween_out = YOOTIL.Tween:new(3, { s = pulse:GetSmartProperty("Pulse Scale"), x = sphere:GetWorldScale().x, 
		
				r = sketch:GetSmartProperty("Silhouette Line Color").r,
				g = sketch:GetSmartProperty("Silhouette Line Color").g,
				b = sketch:GetSmartProperty("Silhouette Line Color").b
		
			}, { s = 0, x = 8, r = 0, g = 0, b = 0 })

			tween_out:on_change(function(c)
				pulse:SetSmartProperty("Pulse Scale", c.s)
				sphere:SetWorldScale(Vector3.New(c.x, c.x, c.x))
				sketch:SetSmartProperty("Silhouette Line Color", Color.New(c.r, c.g, c.b))
				sketch:SetSmartProperty("Crease Line Color", Color.New(c.r, c.g, c.b))	
			end)

			tween_out:on_complete(function()
				tween_out = nil
			end)
		elseif(tween_out ~= nil) then
			tween_out:tween(dt)
		end
	end
end