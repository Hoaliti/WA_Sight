function()
    if not WeakAuras.IsOptionsOpen() then
        if aura_env.state and aura_env.state.spam and (not aura_env.lastSay or aura_env.lastSay <= GetTime() - 1.5)  then
            aura_env.lastSay = GetTime()
            SendChatMessage(aura_env.state.spam, "YELL")  
        end
    end
end