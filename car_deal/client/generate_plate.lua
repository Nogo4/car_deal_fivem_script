function generate_plate()
    local plate = ""
    
    for i = 1, 3 do
        local randomLetter = math.random(1, 26)
        plate = plate .. string.char(64 + randomLetter)
    end
    plate = plate .. "-"
    for i = 1, 3 do
        local randomNumber = math.random(0, 9)
        plate = plate .. tostring(randomNumber)
    end
    return plate
end
