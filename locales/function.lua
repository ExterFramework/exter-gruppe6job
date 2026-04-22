--[[ Functions of our Notifications (Using Default QBCore & ESX Notifications) ]]

-- Please if you only want to make translations, just change what is inside of the ("")

function NotifyGroupError()
    TriggerEvent("exter-tablet:Notify", 'Gruppe6', 'You need to create a Group', 'assets/g6-icon.png', 5000)
end

function ExploitTentativeError()
    Notify("What are you trying to do?", "error")
end

function NotifySpawnOccupied()
    Notify("Spawn spot is occupied!", "error")
end

function NotifyAlreadyVehicleSpawned()
    Notify("You already have a delivery vehicle spawned!", "error")
end

function WrongVehicle()
    Notify("Wrong vehicle!", "error")
end

function NotifyForceFinishjob()
    Notify("Finish your current job first!", "error")
end

function NotifyVehicleStoredSucessfully()
    Notify("Your Vehicle was sucessfully stored!", "sucess")
end

function DepositSuccessfully()
    Notify("You delivered the Cash Bags. Now end your work to be paid !", "success")
end

function NotifyCooldown()
    -- Convert milliseconds to minutes
    local minutes = math.floor(Config.CooldownTime / 60000)
    Notify("You have a cooldown of " .. minutes .. " minutes.", "error")
end