# ExterFramework - Gruppe6 Job System

- Hello, first of all thank you for purchasing our script !
- Don't forget to configure the `shared/config.lua` file according to your server.
- To translate everything, just check our `locales folder` and check our `shared/config.lua`

- Feel free to open a support ticket to resolve your problem/question. - exter Developments - 

## REQUIRED DEPENDENCIES:

- exter-tablet - Important, This will be the tablet that is working with everything :)
- exter-contacts - optional, you can use any get my contacts script with a promo if you already bought this, or use anything else, it has to have a reputation system tho!
- exter-groupsystem - Important, This will make able to you work on our Gruppe6 together with Friends :)
- interact - Important, This is the Interactions that we have for Everything ! 
- exter-status  - We recommend to use our Job Tasks UI for a better experience ;)

## NPC DIALOG CONFIG WILL BE INSIDE OF OUR `exter-contacts`

- If you use something else please set it accordingly!!!

## Items to be added to QBCore `qb-core/shared/items.lua` :

````lua

g6cashbag = { name = 'g6cashbag', label = 'Gruppe6 Cash Bag', weight = 50000, type = 'item', image = 'g6bag.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Bag filled with money from banks' },

g6markedcash = { name = 'g6markedcash', label = 'Marked Gruppe6 Cash', weight = 500, type = 'item', image = 'np_cash-roll.png', unique = false, useable = true, shouldClose = true, combinable = true, description = 'Marked Cash obtained from Gruppe6 shipments' },

g6badge = { name = 'g6badge', label = 'Gruppe6 Badge', weight = 50000, type = 'item', image = 'g6badge.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'This is a Gruppe6 Badge' },

g6pallet = { name = 'g6pallet', label = 'Gruppe6 Badge', weight = 50000, type = 'item', image = 'g6pallet_2.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Pallets filled with money from banks' },

````

# If you have any issue with save stash items with your exter_inventory or any inventory that you are using for QBCore

- Please replace this code on your Inventory at server-side part.

```lua
local function SaveStashItems(stashId, items)
	if (Stashes[stashId] and Stashes[stashId].label == "Stash-None") or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['stash'] = stashId,
		['items'] = json.encode(items)
	})

	if Stashes[stashId] then
		Stashes[stashId].isOpen = false
	end
end

RegisterNetEvent('inventory:server:SetStashItems', function(stashId, items)
	SaveStashItems(stashId, items)
end)

````

