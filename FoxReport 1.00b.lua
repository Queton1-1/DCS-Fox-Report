-- %%%%%%%%%%%%%%%%%%
-- %%% FOX REPORT %%%
-- %%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- None

--%%% CHANGELOG %%%
--[[
    1.00a
    - Initiale
--]]

-- %%% VARS %%%
local markId=1000
local EventsHandler={}
-- Unicodes lib : ☮☐☑☒▮▯⚑⚐✈⏣➳⟳⭮⚒⚔☄⛽⚓
-- LUA ORIGINAL
local Ran = math.random
local StrMatch = string.match
local StrSub = string.sub
-- LUA DCS API
local AddMark = trigger.action.markToAll
local OutText = trigger.action.outText
local fragData={}

function EventsHandler:onEvent(event)
    if event.id == world.event.S_EVENT_SHOT and event.initiator then
        if event.weapon:getDesc().category==1 and event.weapon:getDesc().missileCategory==1 then
            local xd = event.weapon:getTarget():getPosition().p.z - event.initiator:getPosition().p.z
            local yd = event.weapon:getTarget():getPosition().p.x - event.initiator:getPosition().p.x
            local dist = (math.sqrt(xd*xd + yd*yd))/1852
            local d=string.format("%03.1f", dist)
            fragData[#fragData+1]={event.weapon:getTarget():getObjectID(),event.initiator:getPosition().p.z,event.initiator:getPosition().p.x}
            markId=markId+1
            AddMark(markId , "SHOT : "..event.weapon:getTypeName().." from "..event.initiator:getTypeName().." dist:"..d.."nm | #"..event.weapon:getTarget():getObjectID().."\n" , event.weapon:getPoint() , false, nil)
            OutText("SHOT : "..event.weapon:getTypeName().." from "..event.initiator:getTypeName().." dist:"..d.."nm | #"..event.weapon:getTarget():getObjectID(), 5)
        end
    elseif event.id == world.event.S_EVENT_HIT and event.initiator then
        if event.weapon:getDesc().category==1 and event.weapon:getDesc().missileCategory==1 then
            local weaponTravel="?"
            for i=1, #fragData do
                if fragData[i][1] == event.target:getObjectID() then
                    local xd = event.target:getPosition().p.z - fragData[i][2]
                    local yd = event.target:getPosition().p.x - fragData[i][3]
                    local dist = (math.sqrt(xd*xd + yd*yd))/1852
                    weaponTravel=string.format("%03.1f", dist)
                end
            end
            markId=markId+1
            AddMark(markId , "HIT : "..event.weapon:getTypeName().." from "..event.initiator:getTypeName().."\nTravel: "..weaponTravel.."nm | #"..event.target:getObjectID().."\n" , event.weapon:getPoint() , false, nil)
            OutText("HIT : "..event.weapon:getTypeName().." from "..event.initiator:getTypeName().." - Travel: "..weaponTravel.."nm | #"..event.target:getObjectID(),5)
        end
    end
end
world.addEventHandler(EventsHandler)