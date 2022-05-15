local connector_inventory_side = "back"
local buffer_inventory_side = "front"
local input_inventory_side = "top"


local connector_inventory = peripheral.wrap(connector_inventory_side)
local input_inventory = peripheral.wrap(input_inventory_side)
local buffer_inventory = peripheral.wrap(buffer_inventory_side)


settings.load()
rednet.open("bottom")
function sendToMonitor(msg)
    rednet.broadcast(msg, "monitor")
end

function getItemCount(itemName, inventory)
    local count = 0;
    for slot, item in pairs(inventory.list()) do
        if(item.name == itemName) then
            count = count + item.count
        end
    end
    return count
end

function getItemStorageCount(itemName)
    return getItemCount(itemName, connector_inventory)
end

function getItemsInputCount(itemName)
    return getItemCount(itemName, input_inventory)
end

function produceItem(itemName, needed, components, yield)
    local iterations = math.ceil(needed / yield)
    for k, component in pairs(components) do
        total = iterations * component.count
        print("Pulling "..total.." of component "..component.name..".")
        for i=1, total do
            connector_inventory.pushItems(buffer_inventory_side, getSlotFromName(component.name), 1)
        end
    end
end

function getSlotFromName(itemName)
    for slot, item in pairs(connector_inventory.list()) do
        if(item.name == itemName) then
            return slot
        end
    end
end

function waitForProducedItem(itemName, quantity)
    while(true) do
        print("Checking for storage input...")
        local inputCount = getItemsInputCount(itemName)
        print(inputCount.."/"..quantity.." in input found.")
        sendToMonitor(inputCount.."/"..quantity.." "..itemName)
        if(inputCount>=quantity) then
            print("Enough produced.")
            return
        end
        os.sleep(5)
    end
end

function storeItems()
    for slot, item in pairs(input_inventory.list()) do
        input_inventory.pushItems(connector_inventory_side, slot)
    end
end


while(true) do

    local items_threshold = settings.get("items_threshold")
    for k,v in pairs(items_threshold) do
        sendToMonitor("Warte auf arbeit...")
        local itemCount = getItemStorageCount(v.name)
        print("Item "..v.name.." has "..itemCount.." on storage.")
        print("Threshold for item is "..v.threshold..".")
        if(itemCount < v.threshold) then
            needed = v.threshold - itemCount
            print("Amount needed for "..v.name.." is "..needed..".")
            produceItem(v.name, needed, v.components, v.yield)
            print("Production has began.")
            waitForProducedItem(v.name, needed)
            print("Storing items.")
            storeItems()
            print("Items stored.")
        end
    end

    os.sleep(1)
end
