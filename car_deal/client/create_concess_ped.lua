function create_concess_ped ()
    local pedModel = GetHashKey(Config.concess_ped.model)

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    
    local ped = CreatePed(4, pedModel, Config.concess_ped.pos.x, Config.concess_ped.pos.y, Config.concess_ped.pos.z - 1, Config.concess_ped.pos.w, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, false)
    SetPedCanSwitchWeapon(ped, false)
    SetEntityInvincible(ped, true)
    SetPedCanBeDraggedOut(ped, false)
    SetPedCanBeKnockedOffVehicle(ped, 1)
    SetPedCanBeTargetted(ped, false)
    SetPedCanBeTargettedByPlayer(ped, PlayerPedId(), false)
    SetEntityProofs(ped, true, true, true, true, true, true, true, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 17, true)
    FreezeEntityPosition(ped, true)
    SetPedConfigFlag(ped, 281, true) -- CPED_CONFIG_FLAG_DisableMelee
    SetPedConfigFlag(ped, 208, true) -- CPED_CONFIG_FLAG_DisableStoppingVehicleEngine  
    SetPedConfigFlag(ped, 122, true) -- CPED_CONFIG_FLAG_NoCriticalHits
    SetPedConfigFlag(ped, 166, true) -- CPED_CONFIG_FLAG_DisablePedAvoidance
    SetPedConfigFlag(ped, 170, true) -- CPED_CONFIG_FLAG_DisablePanicInVehicle
    SetEntityCollision(ped, true, true)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedWetness(ped)
    SetPedSweat(ped, 0.0)
end
