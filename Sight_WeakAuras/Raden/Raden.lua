function(allstates, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, destName, _, _, spellID = ...
        if subEvent == "SPELL_AURA_APPLIED" then
            if spellID == 306732 then --传电
                aura_env.cantDian = {}
                aura_env.dian = 0
            end
            if spellID == 312996 then --红圈
                aura_env.cantHong = {}
                aura_env.hong = 0
                aura_env.secondHong = aura_env.secondHong + 1
            end
            if spellID == 306273 then --传电阶段
                local _,_,_,_,duration,expirationTime = WA_GetUnitDebuff(destName, spellID)
                aura_env.dian = aura_env.dian + 1
                local unitGroup = select(3,GetRaidRosterInfo(UnitInRaid(destName)))
                --移除有DEBUFF的那个人
                if unitGroup 
                and (unitGroup == aura_env.config.option1.backupGroup 
                or unitGroup == aura_env.config.option1.mainGroup) then
                    aura_env.cantDian[destGUID] = true
                end
                local count = 0
                if destName ~= WeakAuras.me then
                    for unit in WA_IterateGroupMembers() do
                        local guidA = UnitGUID(unit)
                        local raidGroup = select(3, GetRaidRosterInfo(UnitInRaid(unit)))
                        --如果是主队伍的 count+1 然后下一位
                        if raidGroup == aura_env.config.option1.mainGroup then
                            count = count + 1
                            if count == aura_env.dian then
                                --backup的情况
                                if aura_env.cantDian[guidA] and aura_env.myGroup == aura_env.config.option1.backupGroup then
                                    for unit in WA_IterateGroupMembers(nil, true) do
                                        local guidB = UnitGUID(unit)
                                        if not aura_env.cantDian[guidB] 
                                        and guidB == WeakAuras.myGUID 
                                        and not UnitIsDeadOrGhost(unit) --人还没死
                                        -- 306279 = 动荡暴露
                                        -- 313077 = 红圈
                                        and not (WA_GetUnitDebuff(unit, 306279) or WA_GetUnitDebuff(unit, 313077)) --如果身上没有DEBUFF
                                        and UnitIsConnected(unit) -- 如果未掉线
                                        then
                                            --设置当前人的状态
                                            allstates[guidB] = {
                                                show = true,
                                                changed = true,
                                                progressType = "timed",
                                                --设置当前法术的持续时间
                                                duration = duration,
                                                expirationTime = expirationTime,
                                                -- 第一个人的标是mark1 以此类推
                                                mark = (aura_env.dian % 2 == 1 and ICON_LIST[aura_env.config.option1.mark1].."16|t") or (aura_env.dian % 2 == 0 and ICON_LIST[aura_env.config.option1.mark2].."16|t"),
                                                spam = (aura_env.dian % 2 == 1 and "{rt"..aura_env.config.option1.mark1.."}") or (aura_env.dian % 2 == 0 and "{rt"..aura_env.config.option1.mark2.."}"),
                                                autoHide = true,
                                            }
                                            break 
                                        end
                                    end
                                    --如果主队能分配即分配
                                elseif not aura_env.cantDian[guidA] 
                                and aura_env.myGroup == aura_env.config.option1.mainGroup 
                                and guidA == WeakAuras.myGUID 
                                and not UnitIsDeadOrGhost(unit)
                                and not (WA_GetUnitDebuff(unit, 306279) or WA_GetUnitDebuff(unit, 313077)) --if not instability exposure/unstable nightmare
                                and UnitIsConnected(unit)
                                then
                                    allstates[guidA] = {
                                        show = true,
                                        changed = true,
                                        progressType = "timed",
                                        duration = duration,
                                        expirationTime = expirationTime,
                                        mark = (aura_env.dian % 2 == 1 and ICON_LIST[aura_env.config.option1.mark1].."16|t") or (aura_env.dian % 2 == 0 and ICON_LIST[aura_env.config.option1.mark2].."16|t"),
                                        spam = (aura_env.dian % 2 == 1 and "{rt"..aura_env.config.option1.mark1.."}") or (aura_env.dian % 2 == 0 and "{rt"..aura_env.config.option1.mark2.."}"),
                                        autoHide = true,
                                    }
                                    break
                                end 
                            end
                        end
                    end
                else 
                    allstates[destGUID] = {
                        show = true,
                        changed = true,
                        progressType = "timed",
                        duration = duration,
                        expirationTime = expirationTime,
                        mark = (aura_env.dian % 2 == 1 and ICON_LIST[aura_env.config.option1.mark3].."16|t") or aura_env.dian % 2 == 0 and ICON_LIST[aura_env.config.option1.mark4].."16|t",
                        spam = (aura_env.dian % 2 == 1 and "{rt"..aura_env.config.option1.mark3.."}") or (aura_env.dian % 2 == 0 and "{rt"..aura_env.config.option1.mark4.."}"),
                        autoHide = true,
                    }
                end
            end
            -- 红圈
            if spellID == 313077 then
                if aura_env.secondHong == 1 then
                    local _,_,_,_,duration,expirationTime = WA_GetUnitDebuff(destName, spellID)
                aura_env.hong = aura_env.hong + 1
                local unitGroup = select(3,GetRaidRosterInfo(UnitInRaid(destName)))
                 --移除有DEBUFF的那个人
                if unitGroup 
                and (unitGroup == aura_env.config.option2.backupGroup 
                or unitGroup == aura_env.config.option2.mainGroup) then
                    aura_env.cantHong[destGUID] = true
                end
                local count = 0
                if destName ~= WeakAuras.me then
                    for unit in WA_IterateGroupMembers() do
                        local guidA = UnitGUID(unit)
                        local raidGroup = select(3, GetRaidRosterInfo(UnitInRaid(unit)))
                        if raidGroup == aura_env.config.option2.mainGroup then
                            count = count + 1
                            if count == aura_env.hong then
                                --让backup上
                                if aura_env.cantHong[guidA] and aura_env.myGroup == aura_env.config.option2.backupGroup then
                                    for unit in WA_IterateGroupMembers(nil, true) do
                                        local guidB = UnitGUID(unit)
                                        if not aura_env.cantHong[guidB] 
                                        and guidB == WeakAuras.myGUID 
                                        and not UnitIsDeadOrGhost(unit)
                                        and not (WA_GetUnitDebuff(unit, 306279) or WA_GetUnitDebuff(unit, 306273))
                                        and UnitIsConnected(unit)
                                        then
                                            allstates[guidB] = {
                                                show = true,
                                                changed = true,
                                                progressType = "timed",
                                                duration = duration,
                                                expirationTime = expirationTime,
                                                mark = ICON_LIST[aura_env.config.option2.mark1].."16|t",
                                                spam = "{rt"..aura_env.config.option2.mark1.."}",
                                                autoHide = true,
                                            }
                                            break 
                                        end
                                    end
                                elseif not aura_env.cantHong[guidA] 
                                and aura_env.myGroup == aura_env.config.option2.mainGroup 
                                and guidA == WeakAuras.myGUID 
                                and not UnitIsDeadOrGhost(unit)
                                and not (WA_GetUnitDebuff(unit, 306279) or WA_GetUnitDebuff(unit, 306273))
                                and UnitIsConnected(unit)
                                then
                                    allstates[guidA] = {
                                        show = true,
                                        changed = true,
                                        progressType = "timed",
                                        duration = duration,
                                        expirationTime = expirationTime,
                                        mark = ICON_LIST[aura_env.config.option2.mark1].."16|t",
                                        spam = "{rt"..aura_env.config.option2.mark1.."}",
                                        autoHide = true,
                                    }
                                    break
                                end 
                            end
                        end
                    end
                else 
                    allstates[destGUID] = {
                        show = true,
                        changed = true,
                        progressType = "timed",
                        duration = duration,
                        expirationTime = expirationTime,
                        mark = ICON_LIST[aura_env.config.option2.mark2].."16|t",
                        spam = "{rt"..aura_env.config.option2.mark2.."}",
                        autoHide = true,
                    }
                end
                --第二次红球
            elseif aura_env.secondHong == 2 
            then
                local _,_,_,_,duration,expirationTime = WA_GetUnitDebuff(destName, spellID)
                aura_env.hong = aura_env.hong + 1
                local unitGroup = select(3,GetRaidRosterInfo(UnitInRaid(destName)))
                 --移除有DEBUFF的那个人
                if unitGroup 
                and (unitGroup == aura_env.config.option2.backupGroup2 
                or unitGroup == aura_env.config.option2.mainGroup2) then
                    aura_env.cantHong[destGUID] = true
                end
                local count = 0
                if destName ~= WeakAuras.me then
                    for unit in WA_IterateGroupMembers() do
                        local guidA = UnitGUID(unit)
                        local raidGroup = select(3, GetRaidRosterInfo(UnitInRaid(unit)))
                        if raidGroup == aura_env.config.option2.mainGroup2 then
                            count = count + 1
                            if count == aura_env.hong then
                                --让backup上
                                if aura_env.cantHong[guidA] and aura_env.myGroup == aura_env.config.option2.backupGroup2 then
                                    for unit in WA_IterateGroupMembers(nil, true) do
                                        local guidB = UnitGUID(unit)
                                        if not aura_env.cantHong[guidB] 
                                        and guidB == WeakAuras.myGUID 
                                        and not UnitIsDeadOrGhost(unit)
                                        and not (WA_GetUnitDebuff(unit, 306279) or WA_GetUnitDebuff(unit, 306273))
                                        and UnitIsConnected(unit)
                                        then
                                            allstates[guidB] = {
                                                show = true,
                                                changed = true,
                                                progressType = "timed",
                                                duration = duration,
                                                expirationTime = expirationTime,
                                                mark = ICON_LIST[aura_env.config.option2.mark1].."16|t",
                                                spam = "{rt"..aura_env.config.option2.mark1.."}",
                                                autoHide = true,
                                            }
                                            break 
                                        end
                                    end
                                elseif not aura_env.cantHong[guidA] 
                                and aura_env.myGroup == aura_env.config.option2.mainGroup2 
                                and guidA == WeakAuras.myGUID 
                                and not UnitIsDeadOrGhost(unit)
                                and not (WA_GetUnitDebuff(unit, 306279) or WA_GetUnitDebuff(unit, 306273))
                                and UnitIsConnected(unit)
                                then
                                    allstates[guidA] = {
                                        show = true,
                                        changed = true,
                                        progressType = "timed",
                                        duration = duration,
                                        expirationTime = expirationTime,
                                        mark = ICON_LIST[aura_env.config.option2.mark1].."16|t",
                                        spam = "{rt"..aura_env.config.option2.mark1.."}",
                                        autoHide = true,
                                    }
                                    break
                                end 
                            end
                        end
                    end
                else 
                    allstates[destGUID] = {
                        show = true,
                        changed = true,
                        progressType = "timed",
                        duration = duration,
                        expirationTime = expirationTime,
                        mark = ICON_LIST[aura_env.config.option2.mark2].."16|t",
                        spam = "{rt"..aura_env.config.option2.mark2.."}",
                        autoHide = true,
                    }
                end
            end
        end
    end
    if event == "ENCOUNTER_START" then
        aura_env.cantDian = {}
        aura_env.cantHg = {}
        aura_env.dian = 0
        aura_env.hong = 0
        aura_env.secondHong = 0
        aura_env.myGroup = select(3,GetRaidRosterInfo(UnitInRaid("player")))
    end
    return true
end