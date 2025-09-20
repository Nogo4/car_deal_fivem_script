function loadVehicule(vl_name)
    local vehicle = GetHashKey(vl_name)

    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(1)
    end
    return vehicle
end
