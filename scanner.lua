BARREL_BLOCK = "sc-goodies:iron_barrel"

CATEGORIES = { }
CATEGORIES.logs = "logs"
CATEGORIES.planks = "planks"
CATEGORIES.ores = "ores"
CATEGORIES.valuables = "valuables"
CATEGORIES.stones = "stones"
CATEGORIES.misc = "misc"

CATEGORIES_REGEX = {}
CATEGORIES_REGEX[CATEGORIES.logs] = "log"
CATEGORIES_REGEX[CATEGORIES.planks] = "plank"
CATEGORIES_REGEX[CATEGORIES.ores] = "ore"
CATEGORIES_REGEX[CATEGORIES.valuables] = "diamond|emerald|netherite"
CATEGORIES_REGEX[CATEGORIES.stones] = "stone"


function get_barrels()
    local peripherals = peripheral.getNames()
    local barrels = {}
    for _, name in ipairs(peripherals) do
        pName, pType = peripheral.getType(name)

        if pType == "inventory" then
            table.insert(barrels, name)
        end
    end
    return barrels
end

function get_barrel_contents(barrel_id)
    local contents = {}
    local size = peripheral.call(barrel_id, "size")
    for i = 1, size do
        local item = peripheral.call(barrel_id, "getItemDetail", i)
        if item then
            table.insert(contents, item)
        end
    end
    return contents
end

function categorize_item(item)
    for category, regex in pairs(CATEGORIES_REGEX) do
        if string.match(item.name, regex) then
            return category
        end
    end
    return CATEGORIES.misc
end

function categorize_contents(contents)
    local categorized = {}
    for _, item in ipairs(contents) do
        local category = categorize_item(item)
        if not categorized[category] then
            categorized[category] = {}
        end
        table.insert(categorized[category], item)
    end
    return categorized
end

barrels = get_barrels()
for _, barrel in ipairs(barrels) do
    local contents = get_barrel_contents(barrel)
    local categorized = categorize_contents(contents)
    print("Barrel: " .. barrel)
    for category, items in pairs(categorized) do
        print("  " .. category .. ":")
        for _, item in ipairs(items) do
            print("    - " .. item.name .. " x" .. item.count)
        end
    end
end