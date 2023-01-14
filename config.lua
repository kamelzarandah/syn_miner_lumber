Config = {}

Config.startkey = 0xD9D0E1C0 -- (Spacebar)
Config.stopkey = 0x3B24C470 --  (F)
Config.swingkey = 0x07B8BEAF -- Left Click


Config.miningswings = { -- number of swings per node randomized between min and max
    min = 1,
    max = 4
}

Config.items = { -- different item types 
    pickaxe = {draindura = 1,dura = 200, difficultymin = 4000, difficultymax = 2700, type = "mining"},
    hatchet = {draindura = 1,dura = 200, difficultymin = 4000, difficultymax = 2700, type = "lumber"},
    lumberaxe = {draindura = 1,dura = 300, difficultymin = 4000, difficultymax = 2700, type = "lumber"}
}

Config.jobs = {
    mining =  {"lemoyneminingco","twminingco"},
    lumber = {},
}

Config.rewardincrease = 2 -- reward increase for players with jobs listed above 

Config.rewards = { -- rewards for players 
    mining = {
        {name = "clay", label = "Clay", chance = 8, amount = 4},
        {name = "coal", label = "Coal", chance = 8, amount = 6},
        {name = "copper", label = "Copper", chance = 6, amount = 8},
        {name = "iron", label = "Iron", chance = 6, amount = 12},
        {name = "nitrite", label = "Nitrite", chance = 8, amount = 4},
        {name = "rock", label = "Rocks", chance = 10, amount = 4},
        {name = "salt", label = "Salt", chance = 10, amount = 4},
        {name = "goldnugget", label = "Gold Nuggets", chance = 3, amount = 2},
    },
    lumber = {
        {name = "sap", label = "Sap", chance = 8, amount = 2},
        {name = "honey", label = "Honey", chance = 5, amount = 2},
        {name = "wood", label = "Soft Wood", chance = 10, amount = 5},
        {name = "hwood", label = "Hard Wood", chance = 8, amount = 5},
        {name = "rubber", label = "Rubber", chance = 5, amount = 4},
        {name = "fibers", label = "Fibers", chance = 8, amount = 5},
        {name = "pulp", label = "Pulp", chance = 10, amount = 3},
    },
}
