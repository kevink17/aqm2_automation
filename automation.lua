items_threshold = {
    { 
        name = "minecraft:copper_ingot",
        threshold = 100, 
        components =
        { 
            {
                 name = "modern_industrialization:copper_dust",
                count = 1
            } 
        },
        yield = 1
    },
    { 
        name = "techreborn:lead_ingot",
        threshold = 64, 
        components =
        { 
            {
                name = "modern_industrialization:lead_dust",
                count = 1
            } 
        },
        yield = 1
    },
    { 
        name = "techreborn:bronze_dust",
        threshold = 128, 
        components =
        { 
            {
                name = "modern_industrialization:copper_dust",
                count = 3
            },
            {
                name = "modern_industrialization:tin_dust",
                count = 1
            },
        },
        yield = 4
    },
    --{ "bronze_dust", 64, { {"copper_dust", 3, {"tin_dust",1 } } }
}

connector_inventory_side = "back"
buffer_inventory_side = "front"
input_inventory_side = "top"


connector_inventory = peripheral.wrap(connector_inventory_side)
input_inventory = peripheral.wrap(input_inventory_side)
buffer_inventory = peripheral.wrap(buffer_inventory_side)
--buffer_inventory.pullItems(connector_inventory_side, 1, 1)


function getItemCount(itemName, inventory)
    count = 0;
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
    iterations = math.ceil(needed / yield)
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
        inputCount = getItemsInputCount(itemName)
        print(inputCount.."/"..quantity.." in input found.")
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

    for k,v in pairs(items_threshold) do

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
