function(progress, startX, startY, scaleX, scaleY)
    local angle = (progress * 4 * math.pi) - (math.pi / 2)
    local newProgress = (math.sin(angle) + 1);
    return startX + (newProgress * (scaleX - startX)),
    startY + (progress * (scaleY - startY))
end

function(progress, r1, g1, b1, a1, r2, g2, b2, a2)
    local angle = (progress * 4 * math.pi) - (math.pi / 2)
    local newProgress = (math.sin(angle) + 1);
    return WeakAuras.GetHSVTransition(newProgress, r1, g1, b1, a1, r2, g2, b2, a2)
end