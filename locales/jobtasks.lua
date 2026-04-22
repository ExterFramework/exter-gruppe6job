function GrabDeliveryVehicle()
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Grab your delivery vehicle"})
end

function ReturnTheDeliveryVehicle()
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Return the delivery vehicle back to HQ"})
end


function HeadToLocation()
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Head to location requesting a cash pickup"})
end

function GrabBagsInsideVault(tempPicked, tempPickups)
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Grab bags from inside the vault", tostring(round(tempPicked)).."/"..tostring(round(tempPickups)).. " Collected"})
end


function HeadtoCityVault()
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Head to city vault and deposit the money bags"})
end

function Signin()
    exports["exter-status"]:Show("Waiting for job offer", {})
end


function  HeadtoCityVaultXD()
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Head to the city vault"})
end

function ATMsReful()
  return {"Refill assigned ATMs"}
end

function ATMsRefill(textEntries)
    exports["exter-status"]:Show("Gruppe6 Contractor", textEntries)
end

function WaitingLeaders()
    exports["exter-status"]:Show("Gruppe6 Contractor", {"Waiting for leaders confirmation"})
end

function CloseTasksUI()
    exports["exter-status"]:Close()
end