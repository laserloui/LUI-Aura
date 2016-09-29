-----------------------------------------------------------------------------------------------
-- Client Lua Script for LUI_Aura
-- Copyright (c) NCsoft. All rights reserved
-- Made by Loui NaN
-- Proud Warrior of Bloodpact on EU-Jabbit
-----------------------------------------------------------------------------------------------

require "Window"
require "Unit"
require "GameLib"
require "GroupLib"
require "Apollo"
require "ApolloColor"
require "MacrosLib"
require "ActionSetLib"
require "Sound"
require "ChatSystemLib"
require "MailSystemLib"
require "ICCommLib"
require "ICComm"

local LUI_Aura = {}

local resourceIds = {
    [GameLib.CodeEnumClass.Warrior] = 1,
    [GameLib.CodeEnumClass.Engineer] = 1,
    [GameLib.CodeEnumClass.Stalker] = 3,
    [GameLib.CodeEnumClass.Esper] = 1,
    [GameLib.CodeEnumClass.Spellslinger] = 4,
    [GameLib.CodeEnumClass.Medic] = 1,
}

function LUI_Aura:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.lang = "en"
    self.Settings = nil
    self.tWndAuras = {}
    self.tWndGroups = {}
    self.icons = {}
    self.engineer = {
        ability = {},
        cooldown = {},
    }
    self.zones = {
        ["World"] = {
            subzones = {
                ["All Continents"] = "World",
                ["Olyssia"] = {
                    continentId = 8,
                    parentZoneId = 0,
                    id = 0,
                },
                ["Isigrol"] = {
                    continentId = 33,
                    parentZoneId = 0,
                    id = 0,
                },
                ["Alizar"] = {
                    continentId = 6,
                    parentZoneId = 0,
                    id = 0,
                },
                ["Arcterra"] = {
                    continentId = 92,
                    parentZoneId = 0,
                    id = 0,
                },
            },
        },
        ["Arenas"] = {
            subzones = {
                ["All Arenas"] = "Arenas",
                ["The Slaughterdome"] = {
                    continentId = 39,
                    parentZoneId = 0,
                    id = 66,
                },
                ["The Cryoplex"] = {
                    continentId = 94,
                    parentZoneId = 0,
                    id = 478,
                },
            },
        },
        ["Battlegrounds"] = {
            subzones = {
                ["All Battlegrounds"] = "Battlegrounds",
                ["Walatiki Temple"] = {
                    continentId = 40,
                    parentZoneId = 0,
                    id = 69,
                },
                ["Halls of the Bloodsworn"] = {
                    continentId = 53,
                    parentZoneId = 0,
                    id = 99,
                },
                ["Daggerstone Pass"] = {
                    continentId = 57,
                    parentZoneId = 0,
                    id = 103,
                },
            },
        },
        ["Expeditions"] = {
            subzones = {
                ["All Expeditions"] = "Expeditions",
                ["Fragment Zero"] = {
                    continentId = 83,
                    parentZoneId = 0,
                    id = 277,
                },
                ["Outpost M-13"] = {
                    continentId = 38,
                    parentZoneId = 63,
                    id = 0,
                },
                ["Infestation"] = {
                    continentId = 18,
                    parentZoneId = 0,
                    id = 25,
                },
                ["Rage Logic"] = {
                    continentId = 51,
                    parentZoneId = 93,
                    id = 0,
                },
                ["Space Madness"] = {
                    continentId = 58,
                    parentZoneId = 0,
                    id = 121,
                },
                ["Deepd Space Exploration"] = {
                    continentId = 60,
                    parentZoneId = 140,
                    id = 0,
                },
                ["Gauntlet"] = {
                    continentId = 62,
                    parentZoneId = 132,
                    id = 0,
                },
            },
        },
        ["Adventures"] = {
            subzones = {
                ["All Adventures"] = "Adventures",
                ["War of the Wilds"] = {
                    continentId = 23,
                    parentZoneId = 0,
                    id = 32,
                },
                ["The Siege of Tempest Refuge"] = {
                    continentId = 16,
                    parentZoneId = 0,
                    id = 23,
                },
                ["Crimelords of Whitevale"] = {
                    continentId = 26,
                    parentZoneId = 0,
                    id = 35,
                },
                ["The Malgrave Trail"] = {
                    continentId = 17,
                    parentZoneId = 0,
                    id = 24,
                },
                ["Bay of Betrayal"] = {
                    continentId = 84,
                    parentZoneId = 0,
                    id = 307,
                },
            },
        },
        ["Dungeons"] = {
            subzones = {
                ["All Dungeons"] = "Dungeons",
                ["Protogames Academy"] = {
                    continentId = 90,
                    parentZoneId = 469,
                    id = 0,
                },
                ["Stormtalon's Lair"] = {
                    continentId = 13,
                    parentZoneId = 0,
                    id = 19,
                },
                ["Ruins of Kel Voreth"] = {
                    continentId = 15,
                    parentZoneId = 0,
                    id = 21,
                },
                ["Skullcano"] = {
                    continentId = 14,
                    parentZoneId = 0,
                    id = 20,
                },
                ["Sanctuary of the Swordmaiden"] = {
                    continentId = 48,
                    parentZoneId = 0,
                    id = 85,
                },
                ["Ultimate Protogames"] = {
                    continentId = 69,
                    parentZoneId = 154,
                    id = 0,
                },
            },
        },
        ["Genetic Archives"] = {
            continentId = 67,
            parentZoneId = 147,
            subzones = {
                ["All Subzones"] = 0,
                ["Experiment X-89"] = 148,
                ["Kuralak the Defiler"] = 148,
                ["Phagetech Prototypes"] = 149,
                ["Phagemaw"] = 149,
                ["Phageborn Convergence"] = 149,
                ["Dreadphage Ohmna"] = 149,
            },
        },
        ["Datascape"] = {
            continentId = 52,
            parentZoneId = 98,
            subzones = {
                ["All Subzones"] = 0,
                ["System Daemons"] = 105,
                ["Limbo Infomatrix"] = 114,
                ["Volatillity Lattice"] = 116,
                ["Maelstrom Authority"] = 120,
                ["Gloomclaw"] = 115,
                ["Logic Wing"] = 111,
                ["Fire Wing"] = 110,
                ["Frost Wing"] = 109,
                ["Earth Wing"] = 108,
                ["Elemental Pairs"] = {117,118,119},
                ["Avatus"] = 104,
            },
        },
        ["Redmoon Terror"] = {
            continentId = 104,
            parentZoneId = 0,
            subzones = {
                ["All Subzones"] = 0,
                ["Shredder"] = 549,
                ["Robomination"] = 551,
                ["Engineers"] = 552,
                ["Mordechai Redmoon"] = 548,
                ["Octog"] = 548,
                ["Starmap"] = 548,
                ["Laveka"] = 548,
            },
        },
        ["Initialization Core Y-83"] = {
            continentId = 91,
            parentZoneId = 0,
            subzones = {
                ["All Subzones"] = 0,
            }
        },
    }
    self.options = {
        global = {
            version = 3.053,
            interval = 50,
            offset = {
                left = -600,
                top = -460,
                right = 600,
                bottom = 460,
            },
            groups = {},
        },
        group = {
            enable = true,
            locked = true,
            name = "NewGroup",
            auras = {},
            stances = {},
            zones = {},
            runtime = {},
            actionsets = {
                [1] = true,
                [2] = true,
                [3] = true,
                [4] = true,
            },
            visibility = {
                ["infight"] = true,
                ["combat"] = true,
                ["solo"] = true,
                ["group"] = true,
                ["raid"] = true,
                ["pvp"] = true,
            },
            animation = {
                ["Start"] = {
                    enable = false,
                    duration = 1,
                    effect = "None",
                    slideEnable = false,
                    slideTransition = 1,
                    slideOffsetX = 0,
                    slideOffsetY = 0,
                    zoomEnable = false,
                    zoomScale = 1,
                },
                ["End"] = {
                    enable = false,
                    duration = 1,
                    effect = "None",
                    slideEnable = false,
                    slideTransition = 1,
                    slideOffsetX = 0,
                    slideOffsetY = 0,
                    zoomEnable = false,
                    zoomScale = 1,
                },
            },
            dynamic = {
                enable = false,
                direction = "Right",
                growth = "Down",
                sort = "Longest",
                spacingX = 3,
                spacingY = 3,
                rows = 3,
                columns = 10,
                source = "",
                priority = 0,
                important = false,
                transition = 1,
                duration = 0.25,
            },
            sound = {
                enable = false,
                force = false,
            },
            icon = {
                enable = true,
                tooltip = false,
                sprite = "Icon_SkillMind_UI_espr_cnfs",
                strata = 6,
                anchor = "Screen",
                width = 64,
                height = 64,
                posX = 0,
                posY = 0,
                color = { r = 255, g = 255, b = 255, a = 255 },
                source = "",
            },
            overlay = {
                enable = true,
                invert = false,
                animation = "Radial",
                shape = "Icon",
                direction = "Invert",
                color = { r = 0, g = 0, b = 0, a = 160 },
                source = "",
            },
            border = {
                enable = false,
                behavior = "Always",
                sprite = "sprActionBar_YellowBorder",
                inset = 0,
                color = { r = 255, g = 255, b = 255, a = 255 },
            },
            bar = {
                enable = false,
                invert = false,
                direction = "Right",
                position = "CR",
                sprite_fill = "BasicSprites:WhiteFill",
                sprite_empty = "BasicSprites:WhiteFill",
                sprite_bg = "BasicSprites:WhiteFill",
                sprite_border = "border_thin",
                animation = "Linear",
                color_fill = { r = 127, g = 255, b = 0, a = 255 },
                color_empty = { r = 45, g = 88, b = 0, a = 255 },
                color_bg = { r = 0, g = 0, b = 0, a = 255 },
                color_border = { r = 0, g = 0, b = 0, a = 255 },
                spacing = 0,
                border_inset = 0,
                radialmin = 90,
                radialmax = 90,
                width = 250,
                height = 24,
                posX = 0,
                posY = 0,
                source = "",
            },
            duration = {
                enable = true,
                font = "CRB_FloaterSmall",
                anchor = "OI",
                position = "BC",
                align = "Center",
                input = "{v}",
                source = "",
                posX = 0,
                posY = 0,
                color = { r = 255, g = 255, b = 255, a = 255 },
            },
            stacks = {
                enable = true,
                font = "CRB_FloaterSmall",
                anchor = "II",
                position = "BR",
                align = "Right",
                input = "{v}",
                source = "",
                posX = -2,
                posY = 4,
                color = { r = 255, g = 255, b = 255, a = 255 },
            },
            charges = {
                enable = true,
                font = "CRB_FloaterSmall",
                anchor = "II",
                position = "TL",
                align = "Left",
                input = "{v}",
                source = "",
                posX = 0,
                posY = 0,
                color = { r = 255, g = 255, b = 255, a = 255 },
            },
            text = {
                enable = false,
                font = "CRB_FloaterSmall",
                anchor = "OI",
                position = "BC",
                align = "Center",
                input = "",
                source = "",
                posX = 0,
                posY = 0,
                color = { r = 255, g = 255, b = 255, a = 255 },
            },
        },
        aura = {
            enable = true,
            name = "NewAura",
            locked = true,
            behavior = "All",
            desc = "",
            triggers = {},
        },
        trigger = {
            enable = true,
            name = "NewTrigger",
            behavior = "Pass",
            runtime = {},
            keybind = {},
            duration = {},
            stacks = {},
            charges = {},
            attributes = {},
            level = {},
            class = {},
            hostility = {},
            rank = {},
            difficulty = {},
            circumstances = {},
            sources = {},
            threat = {},
            border = {
                enable = false,
                sprite = "border_alert",
                inset = 0,
                color = { r = 255, g = 255, b = 255, a = 255 },
            },
            sound = {
                enable = false,
                force = false,
            },
            icon = {
                enable = false,
            },
            bar = {
                enable = false,
            },
        }
    }
    self.defaults = {
        groups = {
            [1] = {
                name = "Datascape",
                zones = {
                    [1] = {
                        strName = "Datascape: All Subzones",
                        continentId = 52,
                        parentZoneId = 98,
                        id = 0,
                    },
                },
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = false,
                    ["group"] = false,
                    ["raid"] = true,
                    ["pvp"] = false,
                },
                auras = {
                    [1] = {
                        name = "Aggro Reset",
                        desc = "Notification for Aggro-resetting cast from Hydroflux and Pyrobane.",
                        behavior = "Any",
                        icon = {
                            sprite = "attention_005",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Elemental Pairs",
                                continentId = 52,
                                parentZoneId = 98,
                                id = {
                                    [1] = 117,
                                    [2] = 118,
                                    [3] = 119,
                                },
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Funeral Pyre",
                                triggerType = "Cast",
                                unit = "Target",
                                spellName = "Funeral Pyre",
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "attention_005",
                                    color = { r = 255, g = 0, b = 0, a = 255 },
                                },
                            },
                            [2] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Watery Grave",
                                triggerType = "Cast",
                                unit = "Target",
                                spellName = "Watery Grave",
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "attention_005",
                                    color = { r = 30, g = 150, b = 255, a = 255 },
                                },
                                sources = {
                                    overlay = {
                                        behavior = "Pass",
                                        source = "2",
                                    },
                                },
                            },
                        },
                    },
                    [2] = {
                        name = "Hypothermia",
                        desc = "Hydroflux + Pyrobane (Water+Fire):\nNotification for Frost Bomb.",
                        behavior = "All",
                        icon = {
                            sprite = "danger-06",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 0, g = 190, b = 255, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Elemental Pairs",
                                continentId = 52,
                                parentZoneId = 98,
                                id = {
                                    [1] = 117,
                                    [2] = 118,
                                    [3] = 119,
                                },
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Hypothermia",
                                unit = "Player",
                            },
                        },
                    },
                    [3] = {
                        name = "Heat Stroke",
                        desc = "Hydroflux + Pyrobane (Water+Fire):\nNotification for Fire Bomb.",
                        behavior = "All",
                        icon = {
                            sprite = "danger-06",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Elemental Pairs",
                                continentId = 52,
                                parentZoneId = 98,
                                id = {
                                    [1] = 117,
                                    [2] = 118,
                                    [3] = 119,
                                },
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Heat Stroke",
                                unit = "Player",
                            },
                        },
                    },
                    [4] = {
                        name = "Snake Snack",
                        desc = "Mnemesis Snake Debuff Notification.",
                        behavior = "All",
                        icon = {
                            sprite = "face_005",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 0, g = 255, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Elemental Pairs",
                                continentId = 52,
                                parentZoneId = 98,
                                id = {
                                    [1] = 117,
                                    [2] = 118,
                                    [3] = 119,
                                }
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Snake Snack",
                                unit = "Player",
                            },
                        },
                    },
                    [5] = {
                        name = "Twirl",
                        desc = "Aileron Twirl Notification: Run away little girl, RUN AWAY!",
                        behavior = "All",
                        icon = {
                            sprite = "vector_052",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Elemental Pairs",
                                continentId = 52,
                                parentZoneId = 98,
                                id = {
                                    [1] = 117,
                                    [2] = 118,
                                    [3] = 119,
                                }
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Twirl",
                                unit = "Player",
                            },
                        },
                    },
                    [6] = {
                        name = "Contagious Flames",
                        desc = "Pyrobane & Visceralus (Fire+Life):\nNotification for Flame Debuff to run into bee-hives.",
                        behavior = "All",
                        icon = {
                            sprite = "run-01",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        overlay = {
                            enable = false,
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Elemental Pairs",
                                continentId = 52,
                                parentZoneId = 98,
                                id = {
                                    [1] = 117,
                                    [2] = 118,
                                    [3] = 119,
                                }
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Contagious Flames",
                                unit = "Player",
                            },
                        },
                    },
                    [7] = {
                        name = "Crushing Blow",
                        desc = "Avatus Hand Spawn Cast that needs to be interrupted.",
                        behavior = "All",
                        icon = {
                            sprite = "attention_005",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Avatus",
                                continentId = 52,
                                parentZoneId = 98,
                                id = 104,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Cast",
                                triggerType = "Cast",
                                spellName = "Crushing Blow",
                                unit = "Target",
                            },
                        },
                    },
                    [8] = {
                        name = "Power Surge",
                        desc = "This cast from System Daemons needs always to be interrupted!",
                        behavior = "All",
                        icon = {
                            sprite = "attention_005",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: System Daemons",
                                continentId = 52,
                                parentZoneId = 98,
                                id = 105,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Cast",
                                triggerType = "Cast",
                                spellName = "Power Surge",
                                unit = "Target",
                            },
                        },
                    },
                    [9] = {
                        name = "Phase Punch",
                        desc = "Avatus sends you to Clone-Maze, get away from others.",
                        behavior = "All",
                        icon = {
                            sprite = "run-01",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 0, g = 190, b = 255, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = false,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Avatus",
                                continentId = 52,
                                parentZoneId = 98,
                                id = 104,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                unit = "Player",
                                spellName = "Phase Punch",
                            },
                        },
                    },
                    [10] = {
                        name = "Blue Room Purge",
                        desc = "Avatus Blue Room Notifications",
                        behavior = "Any",
                        icon = {
                            sprite = "vector_022",
                            width = 140,
                            height = 140,
                            posX = -70,
                            posY = 100,
                            color = { r = 255, g = 255, b = 255, a = 0 },
                        },
                        overlay = {
                            enable = false,
                        },
                        zones = {
                            [1] = {
                                strName = "Datascape: Avatus",
                                continentId = 52,
                                parentZoneId = 98,
                                id = 104,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Blue Disruption Matrix",
                                triggerType = "Buff",
                                unit = "Target",
                                spellName = "Blue Disruption Matrix",
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "vector_022",
                                    color = { r = 0, g = 190, b = 255, a = 255 },
                                },
                            },
                            [2] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Red Empowerment Matrix",
                                triggerType = "Buff",
                                unit = "Target",
                                spellName = "Red Empowerment Matrix",
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "vector_022",
                                    color = { r = 255, g = 0, b = 0, a = 255 },
                                },
                            },
                            [3] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Green Reconstitution Matrix",
                                triggerType = "Buff",
                                unit = "Target",
                                spellName = "Green Reconstitution Matrix",
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "vector_022",
                                    color = { r = 0, g = 255, b = 0, a = 255 },
                                },
                            },
                        },
                    }
                },
            },
            [2] = {
                name = "Genetic Archives",
                zones = {
                    [1] = {
                        strName = "Genetic Archives: All Subzones",
                        continentId = 67,
                        parentZoneId = 147,
                        id = 0,
                    },
                },
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = false,
                    ["group"] = false,
                    ["raid"] = true,
                    ["pvp"] = false,
                },
                auras = {
                    [1] = {
                        name = "Small Bomb",
                        desc = "Run to the edge with small bomb at Experiement X-89.",
                        behavior = "All",
                        icon = {
                            sprite = "danger-06",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Genetic Archives: Experiment X-89",
                                continentId = 67,
                                parentZoneId = 147,
                                id = 148,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Corruption Globule",
                                unit = "Player",
                            },
                        },
                    },
                    [2] = {
                        name = "Big Bomb",
                        desc = "Jump off the edge with big bomb at Experiement X-89.",
                        behavior = "All",
                        icon = {
                            sprite = "danger-06",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Genetic Archives: Experiment X-89",
                                continentId = 67,
                                parentZoneId = 147,
                                id = 148,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Strain Bomb",
                                unit = "Player",
                            },
                        },
                    },
                    [3] = {
                        name = "Prototypes Link",
                        desc = "Prototypes Linked, Move Away from your Linked Partner.",
                        behavior = "All",
                        icon = {
                            sprite = "run-01",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 215, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Genetic Archives: Phagetech Prototypes",
                                continentId = 67,
                                parentZoneId = 147,
                                id = 149,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Malicious Uplink",
                                unit = "Player",
                            },
                        },
                    },
                    [4] = {
                        name = "Devour",
                        desc = "This cast from Ohmna needs always to be interrupted!",
                        behavior = "All",
                        icon = {
                            sprite = "attention_005",
                            width = 120,
                            height = 120,
                            posX = -60,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        sound = {
                            enable = true,
                            force = false,
                            volume = 0.5,
                            behavior = "All",
                            file = "Sounds\alert.wav",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        zones = {
                            [1] = {
                                strName = "Genetic Archives: Dreadphage Ohmna",
                                continentId = 67,
                                parentZoneId = 147,
                                id = 149,
                            },
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Cast",
                                triggerType = "Cast",
                                spellName = "Devour",
                                unit = "Target",
                            },
                        },
                    },
                },
            },
            [3] = {
                name = "Initialization Core Y-83",
                zones = {
                    [1] = {
                        strName = "Initialization Core Y-83: All Subzones",
                        continentId = 91,
                        parentZoneId = 0,
                        id = 0,
                    },
                },
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = false,
                    ["group"] = false,
                    ["raid"] = true,
                    ["pvp"] = false,
                },
                auras = {
                    [1] = {
                        name = "Strain Incubation",
                        desc = "Shows duration of debuff which kills you if it ends. ",
                        behavior = "All",
                        icon = {
                            sprite = "vector_022",
                            width = 140,
                            height = 140,
                            posX = -70,
                            posY = 100,
                            color = { r = 255, g = 0, b = 0, a = 255 },
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Strain Incubation",
                                unit = "Player",
                            },
                        },
                    },
                },
            },
            [4] = {
                name = "Buffs",
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                overlay = {
                    enable = false,
                },
                icon = {
                    enable = true,
                    posX = 220,
                    posY = 0,
                    height = 50,
                    width = 50,
                },
                border = {
                    color = { r = 0, g = 0, b = 0, a = 255 },
                    behavior = "Always",
                    sprite = "border_thin",
                    inset = -1,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = false,
                    ["group"] = false,
                    ["raid"] = true,
                    ["pvp"] = false,
                },
                dynamic = {
                    enable = true,
                    rows = 1,
                    columns = 8,
                    sort = "Oldest",
                    direction = "Right",
                    growth = "Down",
                    spacingX = 3,
                    spacingY = 3,
                },
                zones = {
                    [1] = {
                        strName = "Datascape: All Subzones",
                        continentId = 52,
                        parentZoneId = 98,
                        id = 0,
                    },
                    [2] = {
                        strName = "Genetic Archives: All Subzones",
                        continentId = 67,
                        parentZoneId = 147,
                        id = 0,
                    },
                    [3] = {
                        strName = "Initialization Core Y-83: All Subzones",
                        continentId = 91,
                        parentZoneId = 0,
                        id = 0,
                    },
                },
                auras = {
                    [1] = {
                        name = "Bloodthirst",
                        desc = "Increases Damage Dealt by 8%.",
                        icon = {
                            sprite = "Icon_SkillStalker_Blood_Thirst",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Buff",
                                behavior = "Fail",
                                triggerType = "Buff",
                                unit = "Player",
                                spellName = "Bloodthirst",
                                duration = {
                                    threshold = 2,
                                },
                            },
                        },
                    },
                    [2] = {
                        name = "Void Pact",
                        desc = "Increases Assault and Support Power by 12%.",
                        icon = {
                            sprite = "Icon_SkillSpellslinger_void_pact",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Buff",
                                behavior = "Fail",
                                triggerType = "Buff",
                                unit = "Player",
                                spellName = "59544",
                                duration = {
                                    threshold = 2,
                                },
                            },
                        },
                    },
                    [3] = {
                        name = "Critical Priority",
                        desc = "Increases Critical Hit Chance by 6%.",
                        icon = {
                            sprite = "Icon_SkillAMP_AMP_CriticalChance_Buff",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Buff",
                                behavior = "Fail",
                                triggerType = "Buff",
                                unit = "Player",
                                spellName = "Critical Priority",
                                duration = {
                                    threshold = 2,
                                },
                            },
                        },
                    },
                    [4] = {
                        name = "Power Link",
                        desc = "Increases Damage Dealt by 8% and Armor Pierce by 6%.",
                        icon = {
                            sprite = "Icon_SkillWarrior_Power_Link",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Buff",
                                behavior = "Fail",
                                triggerType = "Buff",
                                unit = "Player",
                                spellName = "Power Link",
                                duration = {
                                    threshold = 2,
                                },
                            },
                        },
                    },
                    [5] = {
                        name = "Empowering Probes",
                        desc = "Increases Damage Dealt and Outgoing Healing by 5%.",
                        icon = {
                            sprite = "Icon_SkillMedic_empowerprobe",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Buff",
                                behavior = "Fail",
                                triggerType = "Buff",
                                unit = "Player",
                                spellName = "Empowering Probes",
                                duration = {
                                    threshold = 2,
                                },
                            },
                        },
                    },
                    [6] = {
                        name = "Volatile Injection",
                        desc = "Increases Multi-Hit Severity and Glance Chance by 8%.",
                        icon = {
                            sprite = "Icon_SkillEngineer_Volatile_Injection",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Buff",
                                behavior = "Fail",
                                triggerType = "Buff",
                                unit = "Player",
                                spellName = "Volatile Injection",
                                duration = {
                                    threshold = 2,
                                },
                            },
                        },
                    },
                },
            },
            [5] = {
                name = "Debuffs",
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                overlay = {
                    enable = false,
                },
                icon = {
                    enable = true,
                    posX = -220,
                    posY = 0,
                    height = 50,
                    width = 50,
                },
                border = {
                    color = { r = 0, g = 0, b = 0, a = 255 },
                    behavior = "Always",
                    sprite = "border_thin",
                    inset = -1,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = false,
                    ["group"] = false,
                    ["raid"] = true,
                    ["pvp"] = false,
                },
                dynamic = {
                    enable = true,
                    rows = 1,
                    columns = 8,
                    sort = "Oldest",
                    direction = "Left",
                    growth = "Down",
                    spacingX = 3,
                    spacingY = 3,
                },
                zones = {
                    [1] = {
                        strName = "Datascape: All Subzones",
                        continentId = 52,
                        parentZoneId = 98,
                        id = 0,
                    },
                    [2] = {
                        strName = "Genetic Archives: All Subzones",
                        continentId = 67,
                        parentZoneId = 147,
                        id = 0,
                    },
                    [3] = {
                        strName = "Initialization Core Y-83: All Subzones",
                        continentId = 91,
                        parentZoneId = 0,
                        id = 0,
                    },
                },
                auras = {
                    [1] = {
                        name = "Arcane Missiles",
                        desc = "Increases Magic Damage Taken by 10%.",
                        icon = {
                            sprite = "Icon_SkillSpellslinger_magic_missile",
                        },
                        behavior = "All",
                        dynamic = {
                            priority = 1,
                        },
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Arcane Missiles",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [2] = {
                        name = "Fissure",
                        desc = "Increases Technology Damage Taken by 10%.",
                        icon = {
                            sprite = "Icon_SkillMedic_Fissure",
                        },
                        behavior = "All",
                        dynamic = {
                            priority = 1,
                        },
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Fissure",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [3] = {
                        name = "Telekinetic Storm",
                        desc = "Deflect Chance is reduced by 5.0%.",
                        icon = {
                            sprite = "Icon_SkillEnergy_UI_srcr_elctrcshck",
                        },
                        behavior = "All",
                        dynamic = {
                            priority = 1,
                        },
                        triggers = {
                            [1] = {
                                name = "Debuffs",
                                behavior = "None",
                                triggerType = "Group",
                                triggers = {
                                    [1] = {
                                        name = "Telekinetic Storm",
                                        behavior = "Pass",
                                        triggerType = "Debuff",
                                        unit = "Target",
                                        spellName = "Telekinetic Storm",
                                        duration = {
                                            threshold = 2,
                                        },
                                    },
                                    [2] = {
                                        name = "Razor Disk",
                                        behavior = "Pass",
                                        triggerType = "Debuff",
                                        unit = "Target",
                                        spellName = "Razor Disk",
                                        duration = {
                                            threshold = 2,
                                        },
                                    },
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [4] = {
                        name = "Menacing Strike",
                        desc = "Reduces all Mitigation by 4.0%.",
                        icon = {
                            sprite = "Icon_SkillWarrior_Guarded_Strikes",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Debuffs",
                                behavior = "None",
                                triggerType = "Group",
                                triggers = {
                                    [1] = {
                                        name = "Menacing Strike",
                                        behavior = "Pass",
                                        triggerType = "Debuff",
                                        unit = "Target",
                                        spellName = "Menacing Strike",
                                        duration = {
                                            threshold = 2,
                                        },
                                    },
                                    [2] = {
                                        name = "Frenzy",
                                        behavior = "Pass",
                                        triggerType = "Debuff",
                                        unit = "Target",
                                        spellName = "Frenzy",
                                        duration = {
                                            threshold = 2,
                                        },
                                    },
                                    [3] = {
                                        name = "Particle Ejector",
                                        behavior = "Pass",
                                        triggerType = "Debuff",
                                        unit = "Target",
                                        spellName = "Particle Ejector",
                                        duration = {
                                            threshold = 2,
                                        },
                                    },
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [5] = {
                        name = "Haunt",
                        desc = "Reduces Magic Mitigation by 6%.",
                        icon = {
                            sprite = "Icon_SkillMind_UI_espr_phbmve",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Haunt",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [6] = {
                        name = "Bio Shell",
                        desc = "Reduces Technology Mitigation by 6%.",
                        icon = {
                            sprite = "Icon_SkillEngineer_BioShell",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Bio Shell",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [7] = {
                        name = "Smackdown",
                        desc = "Reduces Physical Mitigation by 6%.",
                        icon = {
                            sprite = "Icon_SkillPhysical_UI_wr_slap",
                        },
                        behavior = "All",
                        dynamic = {
                            priority = 1,
                        },
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Smackdown",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [8] = {
                        name = "Punish",
                        desc = "Increases Physical Damage Taken by 10%.",
                        icon = {
                            sprite = "Icon_SkillStalker_Punish",
                        },
                        behavior = "All",
                        dynamic = {
                            priority = 1,
                        },
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Punish",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                    [9] = {
                        name = "Pyrokinetic Flame",
                        desc = "Increases Assault and Support Power by 6%.",
                        icon = {
                            sprite = "Icon_SkillEsper_Dislodge_Essence",
                        },
                        behavior = "All",
                        triggers = {
                            [1] = {
                                name = "Debuff",
                                behavior = "Fail",
                                triggerType = "Debuff",
                                unit = "Target",
                                spellName = "Pyrokinetic Flame",
                                duration = {
                                    threshold = 2,
                                },
                            },
                            [2] = {
                                name = "Unit",
                                behavior = "Pass",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsDead"] = false
                                },
                                difficulty = {
                                    ["2"] = true,
                                    ["3"] = true,
                                },
                                hostility = {
                                    ["0"] = true,
                                },
                                rank = {
                                    ["4"] = true,
                                    ["5"] = true,
                                },
                            },
                        },
                    },
                },
            },
            [6] = {
                name = "Taunts",
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                overlay = {
                    enable = true,
                },
                icon = {
                    enable = true,
                    posX = 130,
                    posY = 60,
                    height = 64,
                    width = 64,
                },
                border = {
                    color = { r = 0, g = 0, b = 0, a = 255 },
                    behavior = "Always",
                    sprite = "border_thin",
                    inset = -1,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = false,
                    ["group"] = false,
                    ["raid"] = true,
                    ["pvp"] = false,
                },
                dynamic = {
                    enable = true,
                    rows = 1,
                    columns = 8,
                    sort = "Oldest",
                    direction = "Right",
                    growth = "Down",
                    spacingX = 3,
                    spacingY = 3,
                },
                auras = {
                    [1] = {
                        name = "Plasma Blast",
                        desc = "Warrior Taunt",
                        behavior = "All",
                        icon = {
                            sprite = "Icon_SkillWarrior_Plasma_Blast",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        dynamic = {
                            source = "1",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Plasma Blast",
                                unit = "Target",
                            },
                        },
                    },
                    [2] = {
                        name = "Code Red",
                        desc = "Engineer Taunt",
                        behavior = "All",
                        icon = {
                            sprite = "Icon_SkillEngineer_Code_Red",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        dynamic = {
                            source = "1",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Code Red",
                                unit = "Target",
                            },
                        },
                    },
                    [3] = {
                        name = "Reaver",
                        desc = "Stalker Taunt",
                        behavior = "All",
                        icon = {
                            sprite = "Icon_SkillStalker_Reaver",
                        },
                        overlay = {
                            enable = true,
                            source = "1",
                        },
                        dynamic = {
                            source = "1",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Debuff",
                                triggerType = "Debuff",
                                spellName = "Reaver",
                                unit = "Target",
                            },
                        },
                    },
                },
            },
            [7] = {
                name = "Target Castbar",
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                text = {
                    enable = false,
                },
                overlay = {
                    enable = false,
                },
                icon = {
                    enable = false,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = true,
                    ["solo"] = true,
                    ["group"] = true,
                    ["raid"] = true,
                    ["pvp"] = true,
                },
                dynamic = {
                    enable = false,
                },
                auras = {
                    [1] = {
                        name = "Castbar",
                        desc = "Target Castbar - Progress Bar",
                        behavior = "Any",
                        icon = {
                            enable = false,
                            width = 40,
                            height = 40,
                            posX = 91,
                            posY = 92,
                        },
                        duration = {
                            enable = true,
                            source = "1",
                            anchor = "IB",
                            font = "CRB_Header12",
                            posX = -10,
                            align = "Right",
                            format = "1",
                            position = "CR",
                        },
                        text = {
                            enable = true,
                            source = "1",
                            anchor = "IB",
                            font = "CRB_Header12",
                            posX = 10,
                            align = "Left",
                            format = "0",
                            position = "CL",
                            input = "{l}",
                        },
                        bar = {
                            enable = true,
                            invert = true,
                            direction = "Right",
                            position = "CR",
                            sprite_fill = "custom_002",
                            sprite_empty = "custom_002",
                            sprite_bg = "bar_empathy12",
                            sprite_border = "border_thin",
                            animation = "Linear",
                            color_fill = { r = 13, g = 167, b = 233, a = 255 },
                            color_empty = { r = 8, g = 67, b = 86, a = 170 },
                            color_bg = { r = 0, g = 0, b = 0, a = 0 },
                            color_border = { r = 0, g = 0, b = 0, a = 255 },
                            spacing = 0,
                            border_inset = 0,
                            width = 420,
                            height = 38,
                            posX = 2,
                            posY = 0,
                            source = "1",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Cast",
                                triggerType = "Cast",
                                spellName = "",
                                unit = "Target",
                            },
                            [2] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Unit",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsVulnerable"] = true,
                                },
                                bar = {
                                    enable = true,
                                    invert = false,
                                    behavior = "Pass",
                                    direction = "Left",
                                    color_fill = { r = 132, g = 21, b = 219, a = 255 },
                                    color_empty = { r = 49, g = 10, b = 62, a = 170 },
                                },
                                sources = {
                                    bar = {
                                        behavior = "Pass",
                                        source = "2",
                                    },
                                    duration = {
                                        behavior = "Pass",
                                        source = "2",
                                    },
                                },
                            },
                        },
                    },
                    [2] = {
                        name = "Interrupt Armor",
                        desc = "Target Castbar - Interrupt Armor Count",
                        behavior = "All",
                        visibility = {
                            ["combat"] = false,
                        },
                        icon = {
                            enable = true,
                            sprite = "spr_TargetFrame_InterruptArmor_Value",
                            posX = 567,
                            posY = 75,
                            width = 60,
                            height = 71,
                        },
                        text = {
                            enable = true,
                            source = "2-1-Interrupt Armor",
                            anchor = "II",
                            font = "CRB_Header14_O",
                            color = { r = 255, g = 150, b = 80, a = 255 },
                            posY = 1,
                            align = "Center",
                            format = "0",
                            position = "CC",
                            input = "{v}",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Cast",
                                triggerType = "Cast",
                                spellName = "",
                                unit = "Target",
                            },
                            [2] = {
                                enable = true,
                                behavior = "Any",
                                name = "Interrupt Armor",
                                triggerType = "Group",
                                triggers = {
                                    [1] = {
                                        enable = true,
                                        behavior = "Pass",
                                        name = "Infinite",
                                        triggerType = "Attribute",
                                        unit = "Target",
                                        icon = {
                                            enable = true,
                                            behavior = "Pass",
                                            sprite = "spr_TargetFrame_InterruptArmor_Infinite",
                                        },
                                        sources = {
                                            text = {
                                                behavior = "Pass",
                                                source = "",
                                            },
                                        },
                                        attributes = {
                                            ["Interrupt Armor"] = {
                                                enable = true,
                                                value = -1,
                                                percent = false,
                                                operator = "==",
                                            },
                                        },
                                    },
                                    [2] = {
                                        enable = true,
                                        behavior = "Pass",
                                        name = "Normal",
                                        triggerType = "Attribute",
                                        unit = "Target",
                                        attributes = {
                                            ["Interrupt Armor"] = {
                                                enable = true,
                                                value = 0,
                                                percent = false,
                                                operator = ">",
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                    [3] = {
                        name = "Moment of Oppertunity",
                        desc = "Target Castbar - MOO Indicator",
                        behavior = "All",
                        visibility = {
                            ["combat"] = false,
                        },
                        icon = {
                            enable = true,
                            sprite = "spr_TargetFrame_InterruptArmor_MoO",
                            posX = 567,
                            posY = 75,
                            width = 60,
                            height = 71,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                behavior = "Pass",
                                name = "Unit",
                                triggerType = "Unit",
                                unit = "Target",
                                circumstances = {
                                    ["IsVulnerable"] = true,
                                },
                            },
                        },
                    },
                },
            },
            [8] = {
                name = "Psi-Points (Esper)",
                icon = {
                    enable = true,
                    sprite = "WhiteFill",
                    color = { r = 13, g = 167, b = 233, a = 255 },
                    width = 44,
                    height = 30,
                    posX = -159,
                    posY = 310,
                },
                border = {
                    enable = true,
                    sprite = "border_thin",
                    behavior = "Always",
                    color = { r = 0, g = 0, b = 0, a = 255 },
                },
                dynamic = {
                    enable = true,
                    transition = "0",
                    direction = "Right",
                    sort = "Oldest",
                    spacingX = 2,
                },
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                text = {
                    enable = false,
                },
                overlay = {
                    enable = false,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = true,
                    ["group"] = true,
                    ["raid"] = true,
                    ["pvp"] = true,
                },
                auras = {
                    [1] = {
                        enable = true,
                        name = "1 Psi-Point",
                        behavior = "All",
                        dynamic = {
                            priority = 7,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 1,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                            },
                        },
                    },
                    [2] = {
                        enable = true,
                        name = "2 Psi-Points",
                        behavior = "All",
                        dynamic = {
                            priority = 6,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 2,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                            },
                        },
                    },
                    [3] = {
                        enable = true,
                        name = "3 Psi-Points",
                        behavior = "All",
                        dynamic = {
                            priority = 5,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 3,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                            },
                        },
                    },
                    [4] = {
                        enable = true,
                        name = "4 Psi-Points",
                        behavior = "All",
                        dynamic = {
                            priority = 4,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 4,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                            },
                        },
                    },
                    [5] = {
                        enable = true,
                        name = "5 Psi-Points",
                        behavior = "All",
                        dynamic = {
                            priority = 3,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 5,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                            },
                        },
                    },
                    [6] = {
                        enable = true,
                        name = "6 Psi-Points",
                        behavior = "All",
                        dynamic = {
                            priority = 2,
                        },
                        icon = {
                            color = { r = 255, g = 168, b = 0, a = 255 },
                            source = "",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Buff",
                                triggerType = "Buff",
                                behavior = "Pass",
                                unit = "Player",
                                spellName = "Mental Overflow",
                                stacks = {
                                    value = 1,
                                    operator = ">=",
                                },
                            },
                        },
                    },
                    [7] = {
                        enable = true,
                        name = "7 Psi-Points",
                        behavior = "All",
                        dynamic = {
                            priority = 1,
                        },
                        icon = {
                            color = { r = 255, g = 168, b = 0, a = 255 },
                            source = "",
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Buff",
                                triggerType = "Buff",
                                behavior = "Pass",
                                unit = "Player",
                                spellName = "Mental Overflow",
                                stacks = {
                                    value = 2,
                                    operator = ">=",
                                },
                            },
                        },
                    },
                },
            },
            [9] = {
                name = "Actuators (Medic)",
                icon = {
                    enable = true,
                    sprite = "WhiteFill",
                    color = { r = 100, g = 80, b = 0, a = 175 },
                    width = 78,
                    height = 20,
                    posX = -160,
                    posY = 319,
                },
                border = {
                    enable = true,
                    sprite = "border_thin",
                    behavior = "Always",
                    color = { r = 0, g = 0, b = 0, a = 255 },
                },
                dynamic = {
                    enable = true,
                    transition = "0",
                    direction = "Right",
                    sort = "Oldest",
                    spacingX = 2,
                },
                duration = {
                    enable = false,
                },
                stacks = {
                    enable = false,
                },
                charges = {
                    enable = false,
                },
                text = {
                    enable = false,
                },
                overlay = {
                    enable = false,
                },
                visibility = {
                    ["infight"] = true,
                    ["combat"] = false,
                    ["solo"] = true,
                    ["group"] = true,
                    ["raid"] = true,
                    ["pvp"] = true,
                },
                auras = {
                    [1] = {
                        enable = true,
                        name = "1 Actuator",
                        behavior = "Always",
                        dynamic = {
                            priority = 4,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 1,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "WhiteFill",
                                    color = { r = 255, g = 215, b = 0, a = 255 },
                                },
                            },
                        },
                    },
                    [2] = {
                        enable = true,
                        name = "2 Actuator",
                        behavior = "Always",
                        dynamic = {
                            priority = 3,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 2,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "WhiteFill",
                                    color = { r = 255, g = 215, b = 0, a = 255 },
                                },
                            },
                        },
                    },
                    [3] = {
                        enable = true,
                        name = "3 Actuator",
                        behavior = "Always",
                        dynamic = {
                            priority = 2,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 3,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "WhiteFill",
                                    color = { r = 255, g = 215, b = 0, a = 255 },
                                },
                            },
                        },
                    },
                    [4] = {
                        enable = true,
                        name = "4 Actuator",
                        behavior = "Always",
                        dynamic = {
                            priority = 1,
                        },
                        triggers = {
                            [1] = {
                                enable = true,
                                name = "Attribute",
                                triggerType = "Attribute",
                                behavior = "Pass",
                                unit = "Player",
                                attributes = {
                                    ["Class Resource"] = {
                                        enable = true,
                                        value = 4,
                                        percent = false,
                                        operator = ">=",
                                    },
                                },
                                icon = {
                                    enable = true,
                                    behavior = "Pass",
                                    sprite = "WhiteFill",
                                    color = { r = 255, g = 215, b = 0, a = 255 },
                                },
                            },
                        },
                    },
                },
            },
        },
    }

    self.keys = {
        [8] = "Backspace",
        [9] = "Tab",
        [13] = "Enter",
        [19] = "Pause Break",
        [20] = "Caps Lock",
        [27] = "Esc",
        [32] = "Space",
        [33] = "Page Up", [34] = "Page Down", [35] = "End", [36] = "Home",
        [37] = "Left", [38] = "Up", [39] = "Right", [40] = "Down", [45] = "Insert", [46] = "Delete",
        [48] = "0", [49] = "1", [50] = "2", [51] = "3", [52] = "4", [53] = "5", [54] = "6", [55] = "7", [56] = "8", [57] = "9",
        [65] = "A", [66] = "B", [67] = "C", [68] = "D", [69] = "E", [70] = "F", [71] = "G", [72] = "H",    [73] = "I",    [74] = "J",    [75] = "K",
        [76] = "L",    [77] = "M",    [78] = "N",    [79] = "O",    [80] = "P",    [81] = "Q",    [82] = "R",    [83] = "S",    [84] = "T",    [85] = "U",    [86] = "V",
        [87] = "W",    [88] = "X",    [89] = "Y",    [90] = "Z",    [91] = "L Win Key",    [92] = "R Win Key", [93] = "Menu Key",
        [96] = "Num 0", [97] = "Num 1",    [98] = "Num 2",    [99] = "Num 3",    [100] = "Num 4", [101] = "Num 5", [102] = "Num 6", [103] = "Num 7",
        [104] = "Num 8", [105] = "Num 9", [106] = "Num *", [107] = "Num +", [109] = "Num -", [110] = "Num .", [111] = "Num /",
        [112] = "F1", [113] = "F2", [114] = "F3", [115] = "F4", [116] = "F5", [117] = "F6",
        [118] = "F7", [119] = "F8", [120] = "F9", [121] = "F10", [122] = "F11", [123] = "F12",
        [144] = "Num Lock", [145] = "Scroll Lock",
        [188] = ",", [190] = ".", [191] = "/", [186] = ";", [222] = "'",
        [189] = "-", [187] = "=", [192] = "`", [219] = "[", [221] = "]",
        [192] = "`", [226] = "\\", [220] = "<",
    }

    self.keyMap = {
        ["Backspace"] = 14,
        ["Tab"] = 15,
        ["Enter"] = 28,
        ["Pause Break"] = 69,
        ["Caps Lock"] = 58,
        ["Esc"] = 1,
        ["Space"] = 57,
        ["Page Up"] = 329, ["Page Down"] = 337, ["End"] = 335, ["Home"] = 327,
        ["Left"] = 331, ["Up"] = 328, ["Right"] = 333, ["Down"] = 336, ["Insert"] = 338, ["Delete"] = 339,
        ["0"] = 11, ["1"] = 2, ["2"] = 3, ["3"] = 4, ["4"] = 5, ["5"] = 6, ["6"] = 7, ["7"] = 8, ["8"] = 9, ["9"] = 10,
        ["A"] = 30, ["B"] = 48, ["C"] = 46, ["D"] = 32, ["E"] = 18, ["F"] = 33, ["G"] = 34, ["H"] = 35, ["I"] = 23, ["J"] = 36, ["K"] = 37,
        ["L"] = 38, ["M"] = 50, ["N"] = 49, ["O"] = 24, ["P"] = 25, ["Q"] = 16, ["R"] = 19, ["S"] = 31, ["T"] = 20, ["U"] = 22, ["V"] = 47,
        ["W"] = 17, ["X"] = 45, ["Y"] = 44, ["Z"] = 21, ["L Win Key"] = 347, ["R Win Key"] = 348, ["Menu Key"] = 349,
        ["Num 0"] = 82, ["Num 1"] = 79, ["Num 2"] = 80, ["Num 3"] = 81, ["Num 4"] = 75, ["Num 5"] = 76, ["Num 6"] = 77, ["Num 7"] = 71,
        ["Num 8"] = 72, ["Num 9"] = 73, ["Num *"] = 55, ["Num +"] = 78, ["Num -"] = 74, ["Num ."] = 28, ["Num /"] = 309,
        ["F1"] = 59, ["F2"] = 60, ["F3"] = 61, ["F4"] = 62, ["F5"] = 63, ["F6"] = 64,
        ["F7"] = 65, ["F8"] = 66, ["F9"] = 67, ["F10"] = 68, ["F11"] = 87, ["F12"] = 88,
        ["Num Lock"] = 325, ["Scroll Lock"] = 70,
        [","] = 51, ["."] = 52, ["/"] = 43, ["-"] = 53, [";"] = 39, ["'"] = 40,
        ["-"] = 12, ["="] = 13, ["`"] = 41, ["["] = 26, ["]"] = 27,
        ["`"] = 41, ["\\"] = 86, ["<"] = 41,
    }

    self.strata = {
        [0] = "InWorldHudStratum",
        [1] = "FixedHudStratumLow",
        [2] = "FixedHudStratum",
        [3] = "FixedHudStratumHigh",
        [4] = "DefaultStratum",
        [5] = "TooltipStratum"
    }

    -- Engineeer Bot Spell Names
    self.bots = {
        ["en"] = {
            ["Artillerybot"] = "[Bot Ability] Barrage",
            ["Bruiserbot"] = "[Bot Ability] Blitz",
            ["Diminisherbot"] = "[Bot Ability] Strobe",
            ["Repairbot"] = "[Bot Ability] Shield Boost",
        },
        ["de"] = {
            ["Artilleriebot"] = "[Botfähigkeit] Sperrfeuer",
            ["Schlägerbot"] = "[Botfähigkeit] Überraschungsangriff",
            ["Reduziererbot"] = "[Botfähigkeit] Stroboskop",
            ["Reparaturbot"] = "[Botfähigkeit] Schildboost",
        },
        ["fr"] = {
            ["Bot d'artillerie"] = "[Aptitude de Bot] Barrage",
            ["Bot cogneur"] = "[Aptitude de Bot] Saut éclair",
            ["Bot réducteur"] = "[Aptitude de Bot] Stroboscope",
            ["Bricobot"] = "[Aptitude de Bot] Renforcement de bouclier",
        }
    }

    -- Engineeer Bot Ability SpellIDs to track cooldown
    self.engineer = {
        [27002] = { -- Artillerybot ([Bot Ability] Barrage)
            [1] = 51365,
            [2] = 56267,
            [3] = 56268,
            [4] = 56269,
            [5] = 56270,
            [6] = 56271,
            [7] = 56272,
            [8] = 56273,
            [9] = 56274
        },
        [27082] = { -- Bruiserbot ([Bot Ability] Blitz)
            [1] = 35501,
            [2] = 56334,
            [3] = 56335,
            [4] = 56336,
            [5] = 56337,
            [6] = 56338,
            [7] = 56339,
            [8] = 56340,
            [9] = 56341
        },
        [27021] = { -- Diminisherbot ([Bot Ability] Strobe)
            [1] = 70593,
            [2] = 70673,
            [3] = 70674,
            [4] = 70675,
            [5] = 70676,
            [6] = 70677,
            [7] = 70678,
            [8] = 70679,
            [9] = 70680
        },
        [26998] = { -- Repairbot ([Bot Ability] Shield Boost)
            [1] = 35657,
            [2] = 55864,
            [3] = 55865,
            [4] = 55866,
            [5] = 55867,
            [6] = 55868,
            [7] = 55869,
            [8] = 55870,
            [9] = 55871
        },
    }

    -- Spellslinger SpellIDs to track cooldown (thanks to Ninix from QtCooldown Addon)
    self.spellslinger = {
        [20684] = { -- Charged Shot
            [1] = { 34718, 34719 },
            [2] = { 48940, 48949 },
            [3] = { 48941, 48950 },
            [4] = { 48942, 48951 },
            [5] = { 48943, 48952 },
            [6] = { 48944, 48953 },
            [7] = { 48945, 48954 },
            [8] = { 48946, 48955 },
            [9] = { 48947, 48956 }
        },
        [20734] = { -- Wild Barrage
            [1] = { 34772, 34773 },
            [2] = { 48904, 48913 },
            [3] = { 48905, 48914 },
            [4] = { 48906, 48915 },
            [5] = { 48907, 48916 },
            [6] = { 48908, 48917 },
            [7] = { 48909, 48918 },
            [8] = { 48910, 48919 },
            [9] = { 48911, 48920 }
        },
        [21056] = { -- Rapid Fire
            [1] = { 35356, 35357, 35358, 35359, 38937, 51501 },
            [2] = { 51391, 51400, 51410, 51419 },
            [3] = { 51392, 51401, 51411, 51420 },
            [4] = { 51393, 51402, 51412, 51421 },
            [5] = { 51394, 51403, 51413, 51422 },
            [6] = { 51395, 51404, 51414, 51423 },
            [7] = { 51396, 51405, 51415, 51424 },
            [8] = { 51397, 51406, 51416, 51425 },
            [9] = { 51398, 51407, 51417, 51426 }
        },
        [21490] = { -- Astral Infusion
            [1] = { 35870, 54717 },
            [2] = { 49730, 54718 },
            [3] = { 49731, 54719 },
            [4] = { 49732, 54720 },
            [5] = { 49733, 54721 },
            [6] = { 49734, 54722 },
            [7] = { 49735, 54723 },
            [8] = { 49736, 54724 },
            [9] = { 49737, 54725 }
        },
        [21650] = { -- True Shot
            [1] = { 36052, 36085 },
            [2] = { 49078, 49114 },
            [3] = { 49079, 49115 },
            [4] = { 49080, 49116 },
            [5] = { 49081, 49117 },
            [6] = { 49082, 49118 },
            [7] = { 49083, 49119 },
            [8] = { 49084, 49121 },
            [9] = { 49085, 49122 }
        },
        [23274] = { -- Assassinate
            [1] = { 38905, 39324, 39325, 69215, 69224 },
            [2] = { 49051, 49060, 49069, 69216, 69225 },
            [3] = { 49052, 49061, 49070, 69217, 69226 },
            [4] = { 49053, 49062, 49071, 69218, 69227 },
            [5] = { 49054, 49063, 49072, 69219, 69228 },
            [6] = { 49055, 49064, 49073, 69220, 69229 },
            [7] = { 49056, 49065, 49074, 69221, 69230 },
            [8] = { 49057, 49066, 49075, 69222, 69231 },
            [9] = { 49058, 49067, 49076, 69223, 69232 }
        },
        [23418] = { -- Dual Fire
            [1] = { 39068, 53286 },
            [2] = { 49558, 53287 },
            [3] = { 49560, 53288 },
            [4] = { 49561, 53289 },
            [5] = { 49562, 53290 },
            [6] = { 49563, 53291 },
            [7] = { 49564, 53292 },
            [8] = { 49565, 53293 },
            [9] = { 49566, 53294 }
        },
        [23441] = { -- Runes of Protection
            [1] = { 39092, 39327, 69761 },
            [2] = { 49225, 49234 },
            [3] = { 49226, 49235 },
            [4] = { 49227, 49236 },
            [5] = { 49228, 49237 },
            [6] = { 49229, 49238 },
            [7] = { 49230, 49239 },
            [8] = { 49231, 49240 },
            [9] = { 49232, 49241 }
        },
        [23463] = { -- Healing Torrent
            [1] = { 39116, 39131 },
            [2] = { 49640, 49649 },
            [3] = { 49641, 49650 },
            [4] = { 49642, 49651 },
            [5] = { 49643, 49652 },
            [6] = { 49644, 49653 },
            [7] = { 49645, 49654 },
            [8] = { 49646, 49655 },
            [9] = { 49647, 49656 }
        },
        [23468] = { -- Healing Salve
            [1] = { 39121, 47601 },
            [2] = { 49586, 49631 },
            [3] = { 49587, 49632 },
            [4] = { 49588, 49633 },
            [5] = { 49589, 49634 },
            [6] = { 49590, 49635 },
            [7] = { 49591, 49636 },
            [8] = { 49592, 49637 },
            [9] = { 49593, 49638 }
        },
        [23479] = { -- Vitality Burst
            [1] = { 39132, 39133 },
            [2] = { 49658, 49667 },
            [3] = { 49659, 49668 },
            [4] = { 49660, 49669 },
            [5] = { 49661, 49670 },
            [6] = { 49662, 49671 },
            [7] = { 49663, 49672 },
            [8] = { 49664, 49673 },
            [9] = { 49665, 49674 }
        },
        [23481] = { -- Voidspring
            [1] = { 39134, 47600 },
            [2] = { 51800, 53475 },
            [3] = { 51801, 53476 },
            [4] = { 51802, 53477 },
            [5] = { 51803, 53478 },
            [6] = { 51804, 53479 },
            [7] = { 51805, 53480 },
            [8] = { 51806, 53481 },
            [9] = { 51807, 53482 }
        },
        [27504] = { -- Sustain
            [1] = { 43326, 43398 },
            [2] = { 51850, 51863 },
            [3] = { 51851, 51864 },
            [4] = { 51852, 51865 },
            [5] = { 51853, 51866 },
            [6] = { 51854, 51867 },
            [7] = { 51855, 51868 },
            [8] = { 51856, 51869 },
            [9] = { 51857, 51870 }
        },
        [27736] = { -- Arcane Missiles
            [1] = { 43570, 43619 },
            [2] = { 54941, 54989 },
            [3] = { 54942, 54990 },
            [4] = { 54943, 54991 },
            [5] = { 54944, 54992 },
            [6] = { 54945, 54993 },
            [7] = { 54946, 54994 },
            [8] = { 54947, 54995 },
            [9] = { 54948, 54996 }
        },
        [27774] = { -- Chill
            [1] = { 43609, 43613 },
            [2] = { 49178, 49198 },
            [3] = { 49179, 49199 },
            [4] = { 49180, 49200 },
            [5] = { 49181, 49201 },
            [6] = { 49182, 49202 },
            [7] = { 49183, 49203 },
            [8] = { 49184, 49204 },
            [9] = { 49185, 49205 }
        },
        [23959] = { -- Regenerative Pulse
            [1] = { 39646, 47078, 47079, 47080, 47081, 47082, 47090 },
            [2] = { 51691, 51702, 51711, 51720, 51729 },
            [3] = { 51692, 51703, 51712, 51721, 51730 },
            [4] = { 51693, 51704, 51713, 51722, 51731 },
            [5] = { 51695, 51705, 51714, 51723, 51732 },
            [6] = { 51696, 51706, 51715, 51724, 51733 },
            [7] = { 51697, 51707, 51716, 51725, 51734 },
            [8] = { 51698, 51708, 51717, 51726, 51735 },
            [9] = { 51699, 51709, 51718, 51727, 51736 }
        }
    }

    self.config = {}

    return o
end

function LUI_Aura:Init()
    Apollo.RegisterAddon(self, true, "LUI Aura", {"LUI_Media"})
end

function LUI_Aura:OnDependencyError(strDependency, strError)
    return true
end

function LUI_Aura:OnLoad()
    Apollo.LoadSprites("Icons.xml")
    Apollo.LoadSprites("Bars.xml")
    Apollo.LoadSprites("Borders.xml")
    self.xmlDoc = XmlDoc.CreateFromFile("LUI_Aura.xml")
    self.xmlDoc:RegisterCallback("OnDocLoaded", self)

    Apollo.RegisterEventHandler("NextFrame","OnNextFrame", self)
    Apollo.RegisterEventHandler("NextFrame", "OnFrame", self)
    Apollo.RegisterEventHandler("SystemKeyDown", "OnKeyDown", self)
    Apollo.RegisterEventHandler("MouseWheel", "OnMouseWheel", self)
    Apollo.RegisterEventHandler("MouseButtonUp", "OnMouseButtonUp", self)

    Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", "OnInterfaceMenuListHasLoaded", self)
    Apollo.RegisterEventHandler("StanceChanged", "OnStanceChanged", self)
    Apollo.RegisterEventHandler("ToggleMenu", "OnToggleMenu", self)
    Apollo.RegisterEventHandler("AbilityBookChange", "OnAbilityBookChange", self)
    Apollo.RegisterEventHandler("UnitEnteredCombat", "OnEnteredCombat", self)
    Apollo.RegisterEventHandler("UnitPvpFlagsChanged", "OnUnitPvpFlagsChanged", self)
    Apollo.RegisterEventHandler("TargetUnitChanged", "OnTargetUnitChanged", self)
    Apollo.RegisterEventHandler("AlternateTargetUnitChanged", "OnAlternateTargetUnitChanged", self)
    Apollo.RegisterEventHandler("CharacterCreated", "OnCharacterCreated", self)
    Apollo.RegisterEventHandler("TargetThreatListUpdated", "OnThreatUpdated", self)

    Apollo.RegisterEventHandler("BuffAdded", "OnBuffAdded", self)
    Apollo.RegisterEventHandler("BuffUpdated", "OnBuffUpdated", self)
    Apollo.RegisterEventHandler("BuffRemoved", "OnBuffRemoved", self)

    Apollo.RegisterEventHandler("StartSpellThreshold", "OnStartSpellThreshold", self)
    Apollo.RegisterEventHandler("UpdateSpellThreshold", "OnUpdateSpellThreshold", self)
    Apollo.RegisterEventHandler("ClearSpellThreshold", "OnClearSpellThreshold", self)

    Apollo.RegisterEventHandler("Group_Join", "OnGroupChange", self)
    Apollo.RegisterEventHandler("Group_Left", "OnGroupChange", self)
    Apollo.RegisterEventHandler("Group_Add", "OnGroupChange", self)
    Apollo.RegisterEventHandler("Group_Remove", "OnGroupChange", self)
    Apollo.RegisterEventHandler("Group_Disbanded", "OnGroupChange", self)
    Apollo.RegisterEventHandler("Group_FlagsChanged", "OnGroupChange", self)

    Apollo.RegisterEventHandler("ChangeWorld", "OnCheckMapZone", self)
    Apollo.RegisterEventHandler("SubZoneChanged", "OnCheckMapZone", self)

    Apollo.RegisterTimerHandler("LUI_CheckZoneTimer", "OnCheckMapZone", self)
    Apollo.RegisterTimerHandler("LUI_Connect", "Connect", self)
end

-- #########################################################################################################################################
-- #########################################################################################################################################
-- #
-- # BUILD STUFF
-- #
-- #########################################################################################################################################
-- #########################################################################################################################################

function LUI_Aura:OnDocLoaded()
    if self.xmlDoc == nil then
        return
    end

    self:LoadDefaults()
    self:GetLocale()

    -- Connect to ICComm Channel
    self:Connect()

    -- Init Settings
    self.Settings:Init(self)

    -- LoadFunctions()
    self:LoadFunctions()

    -- Check Volume Settings
    self:CheckVolumeSetting()

    -- Load Spell Icons
    self:LoadSpellIcons()

    -- Register Slash Commands
    Apollo.RegisterSlashCommand("LUIAura", "OnSlashCommand", self)
    Apollo.RegisterSlashCommand("luiaura", "OnSlashCommand", self)
    Apollo.RegisterSlashCommand("louiaura", "OnSlashCommand", self)
    Apollo.RegisterSlashCommand("la", "OnSlashCommand", self)

    -- Build stuff
    self.isReady = self:BuildAuras()

    -- Show Changelog
    self:CheckVersion()

    self.bDocLoaded = true
end

function LUI_Aura:Connect(reconnect)
    if not self.share then
        self.sharing = false
        self.share = ICCommLib.JoinChannel("LUIAura", ICCommLib.CodeEnumICCommChannelType.Group)
    end

    if self.share:IsReady() then
        self.share:SetReceivedMessageFunction("OnICCommMessageReceived", self)

        if reconnect and reconnect == true then
            self.Settings:OnReconnect()
        end
    else
        Apollo.CreateTimer("LUI_Connect", 3, false)
    end
end

function LUI_Aura:OnICCommMessageReceived(channel, strMessage, idMessage)
    local JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
    local message = JSON.decode(strMessage)

    if type(message) ~= "table" then
        return
    end

    self.Settings:OnReceive(message)
end

function LUI_Aura:BuildAuras()
    if not self.unitPlayer then
        self.unitPlayer = GameLib.GetPlayerUnit()
        return
    end

    -- Reset stuff
    self:ResetRuntime()
    self:HideAllAura()

    -- Load Auras
    for groupId=1,#self.config.groups do
        self:BuildGroup(groupId)
    end

    self.isBuild = true

    -- Check Circumstances
    self:CheckCircumstances()

    return true
end

function LUI_Aura:BuildGroup(groupId)
    self:RemoveAnimation(groupId)
    self:HideGroup(groupId)
    self.tWndAuras[groupId] = {}

    if not self.config.groups[groupId].runtime then
        self.config.groups[groupId].runtime = {}
    end

    if not self.config.groups[groupId].runtime.auras then
        self.config.groups[groupId].runtime.auras = {}
    end

    for auraId=1, #self.config.groups[groupId].auras do
        self:BuildAura(groupId,auraId)
    end

    if self.config.groups[groupId].dynamic.enable and self.config.groups[groupId].dynamic.enable == true then
        if self.config.groups[groupId].icon.anchor == "Screen" then
            self.tWndGroups[groupId] = Apollo.LoadForm(self.xmlDoc, "LUIGroup", self.strata[self.config.groups[groupId].icon.strata] or nil, self)
            self.tWndGroups[groupId]:Show(false,true)
            self.config.groups[groupId].runtime.valid = true
        else
            self.tWndGroups[groupId] = Apollo.LoadForm(self.xmlDoc, "LUIGroupFixed", self.strata[self.config.groups[groupId].icon.strata] or nil, self)
            self.tWndGroups[groupId]:Show(false,true)

            if self.functions[self.config.groups[groupId].icon.anchor]() ~= nil then
                self.tWndGroups[groupId]:SetUnit(self.functions[self.config.groups[groupId].icon.anchor]())
                self.config.groups[groupId].runtime.valid = true
            else
                self.config.groups[groupId].runtime.valid = false
            end
        end
    else
        self.config.groups[groupId].runtime.valid = true
    end
end

function LUI_Aura:BuildAura(groupId,auraId)
    local group = self:Copy(self.config.groups[groupId])

    self:RemoveAnimation(groupId,auraId)

    group.runtime = {}
    group.zones = {}
    group.auras = nil

    if not self.config.groups[groupId].runtime.auras[auraId] then
        self.config.groups[groupId].runtime.auras[auraId] = self:Merge(group,self:Copy(self.config.groups[groupId].auras[auraId]))
    else
        self.config.groups[groupId].runtime.auras[auraId] = self:Merge(self.config.groups[groupId].runtime.auras[auraId],self:Merge(group,self:Copy(self.config.groups[groupId].auras[auraId])))
    end

    local aura = self.config.groups[groupId].runtime.auras[auraId]
    local isDynamic = (aura.dynamic.enable == true and self.config.groups[groupId].icon.anchor ~= "Screen")
    aura.runtime.config = nil

    if self.tWndAuras[groupId][auraId] ~= nil then
        self.tWndAuras[groupId][auraId]:Show(false,true)
        self.tWndAuras[groupId][auraId]:Destroy()
    end

    if not aura.icon.anchor then
        aura.icon.anchor = "Screen"
    end

    if aura.icon.anchor == "Screen" and not isDynamic then
        self.tWndAuras[groupId][auraId] = Apollo.LoadForm(self.xmlDoc, "LUIAura", self.strata[aura.icon.strata] or nil, self)
        self.tWndAuras[groupId][auraId]:SetAnchorOffsets(
            aura.icon.posX,
            aura.icon.posY,
            aura.icon.posX + aura.icon.width,
            aura.icon.posY + aura.icon.height
        )
        aura.runtime.valid = true
    else
        self.tWndAuras[groupId][auraId] = Apollo.LoadForm(self.xmlDoc, "LUIAuraFixed", self.strata[aura.icon.strata] or nil, self)
        self.tWndAuras[groupId][auraId]:SetAnchorOffsets(
            -(aura.icon.width/2) + aura.icon.posX,
            -(aura.icon.height/2) + aura.icon.posY,
            (aura.icon.width/2) + aura.icon.posX,
            (aura.icon.height/2) + aura.icon.posY
        )

        if self.functions[aura.icon.anchor]() ~= nil then
            self.tWndAuras[groupId][auraId]:SetUnit(self.functions[aura.icon.anchor]())
            aura.runtime.valid = true
        else
            aura.runtime.valid = false
        end
    end

    local icon = self.tWndAuras[groupId][auraId]
    icon:SetData({groupId,auraId})
    icon:Show(false,true)
    aura.runtime.show = false
    aura.runtime.isShown = false

    -- Save Offsets for later
    local oL, oT, oR, oB = icon:GetAnchorOffsets()
    aura.runtime.offsets = {
        left = oL,
        top = oT,
        right = oR,
        bottom = oB
    }

    if aura.icon.tooltip == true and aura.desc ~= "" then
        icon:SetTooltip(aura.desc)
    end

    -- Lock Icon
    if aura.locked or aura.dynamic.enable then
        icon:FindChild("lock"):Show(false,true)
        icon:SetStyle("Moveable", false)
    else
        icon:FindChild("lock"):Show(true,true)
        icon:SetStyle("Moveable", true)
    end

    -- Set Icon Color
    icon:FindChild("icon"):SetBGColor(ApolloColor.new(
        aura.icon.color.r / 255,
        aura.icon.color.g / 255,
        aura.icon.color.b / 255,
        aura.icon.color.a / 255
    ))

    -- Show/Hide Icon
    icon:FindChild("icon"):Show(aura.icon.enable,true)
    aura.runtime.iconShown = (aura.icon.enable == true and aura.icon.sprite ~= "")

    -- Load Icon Sprite
    icon:FindChild("icon"):SetSprite(aura.icon.sprite or "")

    -- Hide Border
    icon:FindChild("border"):Show(false,true)
    icon:FindChild("border"):SetAnchorOffsets(
        aura.border.inset,
        aura.border.inset,
        aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset),
        aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset)
    )
    aura.runtime.borderShown = false

    -- Build Text Souces
    self:BuildTextSources(groupId,auraId)

    -- Build Bars
    self:BuildAuraBars(groupId,auraId)

    -- Build Overlay
    self:BuildAuraOverlay(groupId,auraId)

    -- Build Texts
    self:BuildAuraText(groupId,auraId,"duration")
    self:BuildAuraText(groupId,auraId,"stacks")
    self:BuildAuraText(groupId,auraId,"charges")
    self:BuildAuraText(groupId,auraId,"text")

    -- Load Trigger
    self:LoadTriggers(groupId,auraId)
end

function LUI_Aura:BuildTextSources(groupId,auraId)
    local aura = self.config.groups[groupId].runtime.auras[auraId]

    if not aura.runtime then
        aura.runtime = {}
    end

    aura.runtime.sources = {}

    if #aura.triggers >= 1 then
        for triggerId = 1, #aura.triggers do
            local trigger = aura.triggers[triggerId]

            if trigger.enable == true then
                if trigger.triggers ~= nil then
                    for childId = 1, #trigger.triggers do
                        local child = trigger.triggers[childId]

                        if child.enable == true then
                            if child.triggerType == "Attribute" then
                                if child.unit and child.unit ~= "" and child.attributes then
                                    for attribute,stat in pairs(child.attributes) do
                                        self.config.groups[groupId].runtime.auras[auraId].runtime.sources[tostring(triggerId).."-"..tostring(childId).."-"..attribute] = self:HelperCreateAttributeSource(child,attribute,stat) or ""
                                    end
                                end
                            else
                                self.config.groups[groupId].runtime.auras[auraId].runtime.sources[tostring(triggerId).."-"..tostring(childId)] = self:HelperCreateSource(trigger.triggers[childId]) or ""
                            end
                        end
                    end
                else
                    if trigger.triggerType == "Attribute" then
                        if trigger.unit and trigger.unit ~= "" and trigger.attributes then
                            for attribute,stat in pairs(trigger.attributes) do
                                if stat and type(stat) == "table" and stat.enable ~= nil and stat.enable == true then
                                    self.config.groups[groupId].runtime.auras[auraId].runtime.sources[tostring(triggerId).."-"..attribute] = self:HelperCreateAttributeSource(trigger,attribute,stat) or ""
                                end
                            end
                        end
                    else
                        self.config.groups[groupId].runtime.auras[auraId].runtime.sources[tostring(triggerId)] = self:HelperCreateSource(trigger) or ""
                    end
                end
            end
        end
    end
end

function LUI_Aura:HelperCreateAttributeSource(trigger,attribute,stat)
    local bar = false

    if attribute == "Health" or attribute == "Shield" or attribute == "Absorb" or attribute == "Focus" or attribute == "Class Resource" then
        bar = true
    end

    return {
        sType = trigger.triggerType,
        sValueType = attribute,
        sUnit = trigger.unit,
        sName = trigger.unit .. ": "..attribute,
        sLabel = trigger.unit .. ": "..attribute,
        sText = {
            bar = bar,
            overlay = false,
            duration = false,
            stacks = false,
            charges = false,
            text = true,
            icon = false,
        }
    }
end

function LUI_Aura:HelperCreateSource(trigger,triggerId,parentId)
    if trigger.triggerType == "Buff" or trigger.triggerType == "Debuff" then
        if trigger.spellName and trigger.unit then
            local sName = trigger.spellName
            local sLabel = trigger.triggerType..": "..trigger.spellName

            if trigger.spellOwner ~= nil then
                if trigger.spellOwner == true then
                    sName = tostring(trigger.spellName).."_self"
                    sLabel = trigger.triggerType..": "..tostring(trigger.spellName).." (self)"
                elseif trigger.spellOwner == false then
                    sName = tostring(trigger.spellName).."_other"
                    sLabel = trigger.triggerType..": "..tostring(trigger.spellName).." (not self)"
                end
            end

            return {
                sType = trigger.triggerType,
                sUnit = trigger.unit,
                sName = sName,
                sLabel = sLabel,
                sText = {
                    bar = true,
                    overlay = true,
                    duration = true,
                    stacks = true,
                    charges = false,
                    text = false,
                    icon = true,
                }
            }
        end
    elseif trigger.triggerType == "Cooldown" or trigger.triggerType == "Ability" then
        if trigger.spellName then
            return {
                sType = trigger.triggerType,
                sName = trigger.spellName,
                sLabel = trigger.triggerType .. ": "..trigger.spellName,
                sText = {
                    bar = true,
                    overlay = true,
                    duration = true,
                    stacks = false,
                    charges = true,
                    text = true,
                    icon = true,
                }
            }
        end
    elseif trigger.triggerType == "Cast" then
        if trigger.unit then
            return {
                sType = trigger.triggerType,
                sName = (trigger.spellName ~= "" and trigger.spellName or (trigger.triggerType .. ": "..trigger.unit)),
                sUnit = trigger.unit,
                sLabel = trigger.triggerType .. ": "..(trigger.spellName ~= "" and trigger.spellName or trigger.unit),
                sText = {
                    bar = true,
                    overlay = true,
                    duration = true,
                    stacks = false,
                    charges = false,
                    text = true,
                    icon = true,
                }
            }
        end
    elseif trigger.triggerType == "Keybind" then
        if trigger.behavior == "Pass" and trigger.keybind.text and trigger.keybind.duration then
            return {
                sType = trigger.triggerType,
                sName = trigger.keybind.text,
                sDuration = trigger.keybind.duration,
                sLabel = trigger.triggerType .. ": "..trigger.keybind.text,
                sText = {
                    bar = true,
                    overlay = true,
                    duration = true,
                    stacks = false,
                    charges = false,
                    text = false,
                    icon = false,
                }
            }
        end
    elseif trigger.triggerType == "AMP Cooldown" then
        if trigger.spellName and trigger.unit and trigger.auraType and trigger.time then
            local sName = trigger.spellName
            local sLabel = trigger.triggerType..": "..trigger.spellName

            if trigger.spellOwner ~= nil then
                if trigger.spellOwner == true then
                    sName = tostring(trigger.spellName).."_self"
                    sLabel = trigger.triggerType..": "..tostring(trigger.spellName).." (self)"
                elseif trigger.spellOwner == false then
                    sName = tostring(trigger.spellName).."_other"
                    sLabel = trigger.triggerType..": "..tostring(trigger.spellName).." (not self)"
                end
            end

            return {
                sType = trigger.triggerType,
                sName = sName,
                sUnit = trigger.unit,
                sAuraType = trigger.auraType,
                sDuration = trigger.time,
                sLabel = sLabel,
                sText = {
                    bar = true,
                    overlay = true,
                    duration = true,
                    stacks = false,
                    charges = false,
                    text = false,
                    icon = false,
                }
            }
        end
    elseif trigger.triggerType == "Gadget" then
        return {
            sType = trigger.triggerType,
            sName = "Gadget",
            sLabel = "Gadget",
            sText = {
                bar = true,
                overlay = true,
                duration = true,
                stacks = false,
                charges = false,
                text = false,
                icon = true,
            }
        }
    elseif trigger.triggerType == "Innate" then
        return {
            sType = trigger.triggerType,
            sName = "Innate",
            sLabel = "Innate",
            sText = {
                bar = true,
                overlay = true,
                duration = true,
                stacks = false,
                charges = false,
                text = false,
                icon = true,
            }
        }
    elseif trigger.triggerType == "Threat" then
        return {
            sType = trigger.triggerType,
            sName = "Threat",
            sLabel = "Threat",
            sText = {
                bar = true,
                overlay = true,
                duration = false,
                stacks = false,
                charges = false,
                text = true,
                icon = false,
            }
        }
    elseif trigger.triggerType == "Unit" then
        if trigger.unit and trigger.circumstances and trigger.circumstances["IsVulnerable"] ~= nil then
            return {
                sType = "MOO",
                sUnit = trigger.unit,
                sName = trigger.unit .. ": MOO",
                sLabel = trigger.unit .. ": MOO",
                sText = {
                    bar = true,
                    overlay = true,
                    duration = true,
                    stacks = false,
                    charges = false,
                    text = false,
                    icon = false,
                }
            }
        end
    end
end

function LUI_Aura:BuildAuraBars(groupId,auraId)
    local aura = self.config.groups[groupId].runtime.auras[auraId]
    local icon = self.tWndAuras[groupId][auraId]
    local bar = icon:FindChild("bar")
    aura.runtime.barShown = true

    if not aura.bar.enable == true then
        bar:Show(false,true)
        return
    end

    local progress = icon:FindChild("progress")
    progress:SetStyleEx("RadialBar", aura.bar.animation == "Radial")
    progress:SetStyleEx("Clockwise", (
        (aura.bar.direction == "Clockwise" and aura.bar.invert == true) or
        (aura.bar.direction == "Invert" and aura.bar.invert == false)
    ))
    progress:SetStyleEx("BRtoLT", (
        (aura.bar.direction == "Up" and aura.bar.invert == true) or
        (aura.bar.direction == "Down" and aura.bar.invert == false) or
        (aura.bar.direction == "Left" and aura.bar.invert == true) or
        (aura.bar.direction == "Right" and aura.bar.invert == false)
    ))
    progress:SetStyleEx("VerticallyAligned", (aura.bar.direction == "Up" or aura.bar.direction == "Down"))
    progress:SetMax(100)

    if aura.bar.animation == "Radial" then
        progress:SetEmptySprite()
        progress:SetFillSprite()
        progress:SetFullSprite(aura.bar.sprite_fill)

        progress:SetRadialMin(aura.bar.radialmin)
        progress:SetRadialMax(aura.bar.radialmax)

        progress:SetBGColor(ApolloColor.new(
            aura.bar.color_fill.r / 255,
            aura.bar.color_fill.g / 255,
            aura.bar.color_fill.b / 255,
            aura.bar.color_fill.a / 255
        ))
    else
        progress:SetEmptySprite(aura.bar.sprite_empty)
        progress:SetFillSprite(aura.bar.sprite_fill)
        progress:SetFullSprite()

        progress:SetBarColor(ApolloColor.new(
            aura.bar.color_fill.r / 255,
            aura.bar.color_fill.g / 255,
            aura.bar.color_fill.b / 255,
            aura.bar.color_fill.a / 255
        ))

        progress:SetBGColor(ApolloColor.new(
            aura.bar.color_empty.r / 255,
            aura.bar.color_empty.g / 255,
            aura.bar.color_empty.b / 255,
            aura.bar.color_empty.a / 255
        ))
    end

    bar:SetSprite(aura.bar.sprite_bg)
    bar:SetBGColor(ApolloColor.new(
        aura.bar.color_bg.r / 255,
        aura.bar.color_bg.g / 255,
        aura.bar.color_bg.b / 255,
        aura.bar.color_bg.a / 255
    ))

    -- Bar Positioning
    local width = aura.bar.width
    local height = aura.bar.height
    local posX = aura.bar.posX
    local posY = aura.bar.posY
    local anchor = {}
    local offsets = {}
    local position = {
        y = string.sub(aura.bar.position,0,1),
        x = string.sub(aura.bar.position,2,2)
    }

    anchor.y = position.y == "T" and 0 or position.y == "B" and 1 or 0.5
    anchor.x = position.x == "L" and 0 or position.x == "R" and 1 or 0.5

    offsets.left = anchor.x - 1
    offsets.right = anchor.x
    offsets.top = anchor.y - 1
    offsets.bottom = anchor.y

    bar:SetAnchorPoints(anchor.x, anchor.y, anchor.x, anchor.y)
    bar:SetAnchorOffsets(
        (offsets.left * width) + posX,
        (offsets.top * height) + posY,
        (offsets.right * width) + posX,
        (offsets.bottom * height) + posY
    )

    -- Progress Positioning
    local spacing = aura.bar.spacing or 0

    progress:SetAnchorOffsets(
        spacing,
        spacing,
        spacing * -1,
        spacing * -1
    )

    -- Border
    if aura.bar.sprite_border ~= "" then
        bar:FindChild("border"):SetSprite(aura.bar.sprite_border)
        bar:FindChild("border"):SetAnchorOffsets(
            aura.bar.border_inset,
            aura.bar.border_inset,
            aura.bar.border_inset >= 0 and -aura.bar.border_inset or math.abs(aura.bar.border_inset),
            aura.bar.border_inset >= 0 and -aura.bar.border_inset or math.abs(aura.bar.border_inset)
        )
        bar:FindChild("border"):SetBGColor(ApolloColor.new(
            aura.bar.color_border.r / 255,
            aura.bar.color_border.g / 255,
            aura.bar.color_border.b / 255,
            aura.bar.color_border.a / 255
        ))
        bar:FindChild("border"):Show(true,true)
    else
        bar:FindChild("border"):Show(false,true)
    end
end

function LUI_Aura:BuildAuraOverlay(groupId,auraId)
    local aura = self.config.groups[groupId].runtime.auras[auraId]
    local icon = self.tWndAuras[groupId][auraId]
    local overlay = icon:FindChild("overlay")

    if aura.overlay.shape == "Icon" then
        overlay:SetFullSprite(aura.icon.sprite)
    else
        overlay:SetFullSprite("BasicSprites:WhiteFill")
    end

    overlay:SetStyleEx("RadialBar", aura.overlay.animation == "Radial")
    overlay:SetStyleEx("Clockwise", (
        (aura.overlay.direction == "Clockwise" and aura.overlay.invert == true) or
        (aura.overlay.direction == "Invert" and aura.overlay.invert == false)
    ))
    overlay:SetStyleEx("BRtoLT", (
        (aura.overlay.direction == "Up" and aura.overlay.invert == true) or
        (aura.overlay.direction == "Down" and aura.overlay.invert == false) or
        (aura.overlay.direction == "Left" and aura.overlay.invert == true) or
        (aura.overlay.direction == "Right" and aura.overlay.invert == false)
    ))
    overlay:SetStyleEx("VerticallyAligned", (aura.overlay.direction == "Up" or aura.overlay.direction == "Down"))

    overlay:SetBarColor(ApolloColor.new(
        aura.overlay.color.r / 255,
        aura.overlay.color.g / 255,
        aura.overlay.color.b / 255,
        aura.overlay.color.a / 255
    ))
    overlay:SetBGColor(ApolloColor.new(
        aura.overlay.color.r / 255,
        aura.overlay.color.g / 255,
        aura.overlay.color.b / 255,
        aura.overlay.color.a / 255
    ))
    overlay:SetMax(100)
    overlay:Show(false,true)
end

function LUI_Aura:BuildAuraText(groupId,auraId,textType)
    local icon = self.tWndAuras[groupId][auraId]
    local bar = icon:FindChild("bar")
    local aura = self.config.groups[groupId].runtime.auras[auraId]
    local setting = aura[textType]
    local anchor = { x = 0.5, y = 0.5 }
    local offsets = { left = 0, right = 0, top = 0, bottom = 0}
    local inside = string.sub(setting.anchor,0,1) == "I"
    local parent = string.sub(setting.anchor,2,2) == "B" and bar or icon
    local text = Apollo.LoadForm(self.xmlDoc, "LUIText", parent, self)
    local height = 0
    local width = 300

    local position = {
        y = string.sub(setting.position,0,1),
        x = string.sub(setting.position,2,2)
    }

    local padding = {
        y = inside and 0 or position.y == "B" and 5 or position.y == "T" and -5 or 0,
        x = inside and 0 or (position.y == "C" and position.x == "R") and 5 or 0
    }

    for _, font in pairs(Apollo.GetGameFonts()) do
        if font.name == setting.font then
            height = height + (font.size * 1.5)
            break
        end
    end

    if setting.align == "Right" then
        height = height + 5
        padding.x = padding.x - 1
    end

    local textColor = ApolloColor.new(
        setting.color.r / 255,
        setting.color.g / 255,
        setting.color.b / 255,
        setting.color.a / 255
    )

    text:Show(true,true)
    text:SetName(textType)
    text:SetTextColor(textColor)
    text:SetFont(setting.font)
    text:SetTextFlags("DT_CENTER", setting.align == "Center")
    text:SetTextFlags("DT_RIGHT", setting.align == "Right")

    if position.y ~= "C" then
        anchor.y = position.y == "T" and 0 or position.y == "B" and 1 or 0.5
    end

    if position.x ~= "C" then
        anchor.x = position.x == "L" and 0 or position.x == "R" and 1 or 0.5
    end

    offsets.left = inside and -1 * anchor.x or anchor.x - 1
    offsets.right = inside and -1 * (anchor.x - 1) or anchor.x
    offsets.top = inside and -1 * anchor.y or anchor.y - 1
    offsets.bottom = inside and -1 * (anchor.y - 1) or anchor.y

    text:SetAnchorPoints(anchor.x, anchor.y, anchor.x, anchor.y)
    text:SetAnchorOffsets(
        (offsets.left * width) + padding.x + setting.posX,
        (offsets.top * height) + padding.y + setting.posY,
        (offsets.right * width) + padding.x + setting.posX,
        (offsets.bottom * height) + padding.y + setting.posY
    )
end

function LUI_Aura:RemoveTriggers(groupId,auraId)
    if not groupId or not auraId then
        return
    end

    local aura = self.config.groups[groupId].runtime.auras[auraId]

    if aura.runtime and aura.runtime.run == true then
        return
    end

    for triggerId=1, #aura.triggers do
        local trigger = aura.triggers[triggerId]
        self:RemoveTriggerFromWatch(trigger,groupId,auraId,triggerId)

        if trigger.triggers then
            for subTriggerId=1, #trigger.triggers do
                local subTrigger = trigger.triggers[subTriggerId]
                self:RemoveTriggerFromWatch(subTrigger,groupId,auraId,triggerId,subTriggerId)
            end
        end
    end
end

function LUI_Aura:RemoveTriggerFromWatch(trigger,groupId,auraId,triggerId,subTriggerId)
    if not trigger then
        return
    end

    if not self.trigger then
        return
    end

    local watchId = tostring(groupId).."-"..tostring(auraId).."-"..tostring(triggerId)

    if subTriggerId then
        watchId = watchId.."-"..tostring(subTriggerId)
    end

    if (trigger.triggerType == "Cooldown" or trigger.triggerType == "Ability" ) and trigger.spellName then
        if self:RemoveTriggerFromList(watchId,"cooldowns",tostring(trigger.spellName)) then
            if self.cooldowns then
                self.cooldowns[tostring(trigger.spellName)] = nil

                if self:Count(self.cooldowns) == 0 then
                    self.cooldowns = nil
                end
            end
        end

        return
    end

    if trigger.triggerType == "Cast" and trigger.unit then
        if self:RemoveTriggerFromList(watchId,"casts",trigger.unit) then
            if self.casts then
                self.casts[trigger.unit] = nil

                if self:Count(self.casts) == 0 then
                    self.casts = nil
                end
            end
        end

        return
    end

    if trigger.triggerType == "Gadget" then
        if self:RemoveTriggerFromList(watchId,"cooldowns","Gadget") then
            if self.cooldowns then
                self.cooldowns["Gadget"] = nil

                if self:Count(self.cooldowns) == 0 then
                    self.cooldowns = nil
                end
            end
        end

        return
    end

    if trigger.triggerType == "Innate" then
        if self:RemoveTriggerFromList(watchId,"cooldowns","Innate") then
            if self.cooldowns then
                self.cooldowns["Innate"] = nil

                if self:Count(self.cooldowns) == 0 then
                    self.cooldowns = nil
                end
            end
        end

        return
    end

    if (trigger.triggerType == "Buff" or trigger.triggerType == "Debuff") and trigger.spellName and trigger.unit then
        if trigger.spellOwner ~= nil then
            if trigger.spellOwner == true then
                if self:RemoveTriggerFromList(watchId,"spells",trigger.triggerType,trigger.unit,tostring(trigger.spellName).."_self") then
                    if self.spells and self.spells[trigger.triggerType] and self.spells[trigger.triggerType][trigger.unit] then
                        self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName).."_self"] = nil
                    end
                end
            elseif trigger.spellOwner == false then
                if self:RemoveTriggerFromList(watchId,"spells",trigger.triggerType,trigger.unit,tostring(trigger.spellName).."_other") then
                    if self.spells and self.spells[trigger.triggerType] and self.spells[trigger.triggerType][trigger.unit] then
                        self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName).."_other"] = nil
                    end
                end
            end
        else
            if self:RemoveTriggerFromList(watchId,"spells",trigger.triggerType,trigger.unit,tostring(trigger.spellName)) then
                if self.spells and self.spells[trigger.triggerType] and self.spells[trigger.triggerType][trigger.unit] then
                    self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName)] = nil
                end
            end
        end

        if self.spells and self.spells[trigger.triggerType] and self.spells[trigger.triggerType][trigger.unit] then
            if self:Count(self.spells[trigger.triggerType][trigger.unit]) == 0 then
                self.spells[trigger.triggerType][trigger.unit] = nil

                if self:Count(self.spells[trigger.triggerType]) == 0 then
                    self.spells[trigger.triggerType] = nil

                    if self:Count(self.spells) == 0 then
                        self.spells = nil
                    end
                end
            end
        end

        return
    end

    if trigger.triggerType == "Attribute" and trigger.unit then
        for attribute,_ in pairs(trigger.attributes) do
            if self:RemoveTriggerFromList(watchId,"stats",trigger.unit,attribute) then
                if self.stats and self.stats[trigger.unit] then
                    self.stats[trigger.unit][attribute] = nil
                end
            end
        end

        if self.stats and self.stats[trigger.unit] then
            if self:Count(self.stats[trigger.unit]) == 0 then
                self.stats[trigger.unit] = nil

                if self:Count(self.stats) == 0 then
                    self.stats = nil
                end
            end
        end

        return
    end

    if trigger.triggerType == "Keybind" and trigger.keybind.text then
        if self:RemoveTriggerFromList(watchId,"keybinds",trigger.keybind.text) then
            if self.keybinds then
                self.keybinds[trigger.keybind.text] = nil

                if self:Count(self.keybinds) == 0 then
                    self.keybinds = nil
                end
            end
        end

        return
    end

    if trigger.triggerType == "AMP Cooldown" and trigger.unit and trigger.auraType and trigger.spellName then
        if trigger.spellOwner ~= nil then
            if trigger.spellOwner == true then
                if self:RemoveTriggerFromList(watchId,"amp",trigger.auraType,trigger.unit,tostring(trigger.spellName).."_self") then
                    if self.amp and self.amp[trigger.auraType] and self.amp[trigger.auraType][trigger.unit] then
                        self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName).."_self"] = nil
                    end
                end
            elseif trigger.spellOwner == false then
                if self:RemoveTriggerFromList(watchId,"amp",trigger.auraType,trigger.unit,tostring(trigger.spellName).."_other") then
                    if self.amp and self.amp[trigger.auraType] and self.amp[trigger.auraType][trigger.unit] then
                        self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName).."_other"] = nil
                    end
                end
            end
        else
            if self:RemoveTriggerFromList(watchId,"amp",trigger.auraType,trigger.unit,tostring(trigger.spellName)) then
                if self.amp and self.amp[trigger.auraType] and self.amp[trigger.auraType][trigger.unit] then
                    self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName)] = nil
                end
            end
        end

        if self.amp and self.amp[trigger.auraType] and self.amp[trigger.auraType][trigger.unit] then
            if self:Count(self.amp[trigger.auraType][trigger.unit]) == 0 then
                self.amp[trigger.auraType][trigger.unit] = nil

                if self:Count(self.amp[trigger.auraType]) == 0 then
                    self.amp[trigger.auraType] = nil

                    if self:Count(self.amp) == 0 then
                        self.amp = nil
                    end
                end
            end
        end

        return
    end

    if trigger.triggerType == "Threat" then
        if self:RemoveTriggerFromList(watchId,"threat") then
            if self.threat then
                self.threat = nil
            end
        end

        return
    end

    if trigger.triggerType == "Unit" and trigger.unit then
        for k,v in pairs(trigger.circumstances) do
            if self:RemoveTriggerFromList(watchId,"units",trigger.unit,k) then
                if self.units and self.units[trigger.unit] then
                    self.units[trigger.unit][k] = nil
                end
            end

            if k == "IsVulnerable" then
                if self:RemoveTriggerFromList(watchId,"units",trigger.unit,"MOO") then
                    if self.units and self.units[trigger.unit] then
                        self.units[trigger.unit]["MOO"] = nil
                    end
                end
            end
        end

        return
    end
end

function LUI_Aura:RemoveTriggerFromList(watchId,triggerType,s1,s2,s3)
    if not watchId or not triggerType then
        return
    end

    if not self.trigger then
        return false
    end

    if not self.trigger[triggerType] then
        return false
    end

    if s1 and not self.trigger[triggerType][s1] then
        return false
    end

    if s2 and not self.trigger[triggerType][s1][s2] then
        return false
    end

    if s3 and not self.trigger[triggerType][s1][s2][s3] then
        return false
    end

    if s3 then
        if self.trigger[triggerType][s1][s2][s3][watchId] then
            self.trigger[triggerType][s1][s2][s3][watchId] = nil

            if self:Count(self.trigger[triggerType][s1][s2][s3]) == 0 then
                self.trigger[triggerType][s1][s2][s3] = nil

                if self:Count(self.trigger[triggerType][s1][s2]) == 0 then
                    self.trigger[triggerType][s1][s2] = nil

                    if self:Count(self.trigger[triggerType][s1]) == 0 then
                        self.trigger[triggerType][s1] = nil

                        if self:Count(self.trigger[triggerType]) == 0 then
                            self.trigger[triggerType] = nil
                        end
                    end
                end

                return true
            end
        end
    else
        if s2 then
            if self.trigger[triggerType][s1][s2][watchId] then
                self.trigger[triggerType][s1][s2][watchId] = nil

                if self:Count(self.trigger[triggerType][s1][s2]) == 0 then
                    self.trigger[triggerType][s1][s2] = nil

                    if self:Count(self.trigger[triggerType][s1]) == 0 then
                        self.trigger[triggerType][s1] = nil

                        if self:Count(self.trigger[triggerType]) == 0 then
                            self.trigger[triggerType] = nil
                        end
                    end

                    return true
                end
            end
        else
            if s1 then
                if self.trigger[triggerType][s1][watchId] then
                    self.trigger[triggerType][s1][watchId] = nil

                    if self:Count(self.trigger[triggerType][s1]) == 0 then
                        self.trigger[triggerType][s1] = nil

                        if self:Count(self.trigger[triggerType]) == 0 then
                            self.trigger[triggerType] = nil
                        end

                        return true
                    end
                end
            else
                if self.trigger[triggerType][watchId] then
                    self.trigger[triggerType][watchId] = nil

                    if self:Count(self.trigger[triggerType]) == 0 then
                        self.trigger[triggerType] = nil
                        return true
                    end
                end
            end
        end
    end

    return false
end

function LUI_Aura:LoadTriggers(groupId,auraId)
    if not groupId or not auraId then
        return
    end

    if not self.config.groups[groupId].runtime or not self.config.groups[groupId].runtime.run == true then
        return
    end

    local aura = self.config.groups[groupId].runtime.auras[auraId]

    if not aura.runtime or not aura.runtime.run == true then
        return
    end

    for triggerId=1, #aura.triggers do
        local trigger = aura.triggers[triggerId]

        if trigger.enable == true then
            self:AddTriggerToWatch(trigger,groupId,auraId,triggerId)
        else
            self:RemoveTriggerFromWatch(trigger,groupId,auraId,triggerId)
        end

        if trigger.triggers then
            for subTriggerId=1, #trigger.triggers do
                local subTrigger = trigger.triggers[subTriggerId]

                if subTrigger.enable == true then
                    self:AddTriggerToWatch(subTrigger,groupId,auraId,triggerId,subTriggerId)
                else
                    self:RemoveTriggerFromWatch(subTrigger,groupId,auraId,triggerId,subTriggerId)
                end
            end
        end
    end
end

function LUI_Aura:AddTriggerToList(watchId,triggerType,s1,s2,s3)
    if not watchId or not triggerType then
        return
    end

    if not self.trigger then
        self.trigger = {}
    end

    if not self.trigger[triggerType] then
        self.trigger[triggerType] = {}
    end

    if s1 and not self.trigger[triggerType][s1] then
        self.trigger[triggerType][s1] = {}
    end

    if s2 and not self.trigger[triggerType][s1][s2] then
        self.trigger[triggerType][s1][s2] = {}
    end

    if s3 and not self.trigger[triggerType][s1][s2][s3] then
        self.trigger[triggerType][s1][s2][s3] = {}
    end

    if s3 then
        self.trigger[triggerType][s1][s2][s3][watchId] = true
    else
        if s2 then
            self.trigger[triggerType][s1][s2][watchId] = true
        else
            if s1 then
                self.trigger[triggerType][s1][watchId] = true
            else
                self.trigger[triggerType][watchId] = true
            end
        end
    end
end

function LUI_Aura:AddTriggerToWatch(trigger,groupId,auraId,triggerId,subTriggerId)
    if not trigger then
        return
    end

    if not trigger.runtime then
        trigger.runtime = {}
    end

    trigger.runtime.borderShown = false
    trigger.runtime.iconShown = false

    if not trigger.enable == true then
        return
    end

    local watchId = tostring(groupId).."-"..tostring(auraId).."-"..tostring(triggerId)

    if subTriggerId then
        watchId = watchId.."-"..tostring(subTriggerId)
    end

    if (trigger.triggerType == "Cooldown" or trigger.triggerType == "Ability" ) and trigger.spellName then
        if not self.cooldowns then
            self.cooldowns = {}
        end

        if not self.cooldowns[tostring(trigger.spellName)] then
            self.cooldowns[tostring(trigger.spellName)] = {
                cdRemaining = 0,
                cdTotal = 0,
                chargesRemaining = 0,
                chargesMax = 0,
                icon = "",
            }
        end

        self:AddTriggerToList(watchId,"cooldowns",tostring(trigger.spellName))
        return
    end

    if trigger.triggerType == "Cast" and trigger.unit then
        if not self.casts then
            self.casts = {}
        end

        if not self.casts[trigger.unit] then
            self.casts[trigger.unit] = {
                active = false,
                threshold = false,
                spellName = "",
                icon = "",
                time = 0,
                current = 0,
                total = 0,
                percent = 0,
                tier = 0,
                max = 0,
                id = 0
            }
        end

        self:AddTriggerToList(watchId,"casts",trigger.unit)
        return
    end

    if trigger.triggerType == "Gadget" then
        if not self.cooldowns then
            self.cooldowns = {}
        end

        if not self.cooldowns["Gadget"] then
            self.cooldowns["Gadget"] = {
                cdRemaining = 0,
                cdTotal = 0,
                chargesRemaining = 0,
                chargesMax = 0,
                icon = "",
            }
        end

        self:AddTriggerToList(watchId,"cooldowns","Gadget")
        return
    end

    if trigger.triggerType == "Innate" then
        if not self.cooldowns then
            self.cooldowns = {}
        end

        if not self.cooldowns["Innate"] then
            self.cooldowns["Innate"] = {
                cdRemaining = 0,
                cdTotal = 0,
                chargesRemaining = 0,
                chargesMax = 0,
                icon = "",
            }
        end

        self:AddTriggerToList(watchId,"cooldowns","Innate")
        return
    end

    if (trigger.triggerType == "Buff" or trigger.triggerType == "Debuff") and trigger.spellName and trigger.unit then
        if not self.spells then
            self.spells = {}
        end

        if not self.spells[trigger.triggerType] then
            self.spells[trigger.triggerType] = {}
        end

        if not self.spells[trigger.triggerType][trigger.unit] then
            self.spells[trigger.triggerType][trigger.unit] = {}
        end

        if trigger.spellOwner ~= nil then
            if trigger.spellOwner == true then
                if not self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName).."_self"] then
                    self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName).."_self"] = {
                        active = false,
                        time = 0,
                        stacks = 0,
                    }
                end

                self:AddTriggerToList(watchId,"spells",trigger.triggerType,trigger.unit,tostring(trigger.spellName).."_self")
            elseif trigger.spellOwner == false then
                if not self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName).."_other"] then
                    self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName).."_other"] = {
                        active = false,
                        time = 0,
                        stacks = 0,
                    }
                end

                self:AddTriggerToList(watchId,"spells",trigger.triggerType,trigger.unit,tostring(trigger.spellName).."_other")
            end
        else
            if not self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName)] then
                self.spells[trigger.triggerType][trigger.unit][tostring(trigger.spellName)] = {
                    active = false,
                    time = 0,
                    stacks = 0,
                }
            end

            self:AddTriggerToList(watchId,"spells",trigger.triggerType,trigger.unit,tostring(trigger.spellName))
        end

        return
    end

    if trigger.triggerType == "Attribute" and trigger.unit then
        if not self.stats then
            self.stats = {}
        end

        if not self.stats[trigger.unit] then
            self.stats[trigger.unit] = {}
        end

        for attribute,_ in pairs(trigger.attributes) do
            if not self.stats[trigger.unit][attribute] then
                self.stats[trigger.unit][attribute] = {
                    current = 0,
                    max = 0,
                }
            end

            self:AddTriggerToList(watchId,"stats",trigger.unit,attribute)
        end

        return
    end

    if trigger.triggerType == "Keybind" and trigger.keybind.text then
        if not self.keybinds then
            self.keybinds = {}
        end

        if not self.keybinds[trigger.keybind.text] then
            self.keybinds[trigger.keybind.text] = 0
        end

        self:AddTriggerToList(watchId,"keybinds",trigger.keybind.text)
        return
    end

    if trigger.triggerType == "AMP Cooldown" and trigger.unit and trigger.auraType and trigger.spellName then
        if not self.amp then
            self.amp = {}
        end

        if not self.amp[trigger.auraType] then
            self.amp[trigger.auraType] = {}
        end

        if not self.amp[trigger.auraType][trigger.unit] then
            self.amp[trigger.auraType][trigger.unit] = {}
        end

        if trigger.spellOwner ~= nil then
            if trigger.spellOwner == true then
                if not self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName).."_self"] then
                    self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName).."_self"] = 0
                end

                self:AddTriggerToList(watchId,"amp",trigger.auraType,trigger.unit,tostring(trigger.spellName).."_self")
            elseif trigger.spellOwner == false then
                if not self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName).."_other"] then
                    self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName).."_other"] = 0
                end

                self:AddTriggerToList(watchId,"amp",trigger.auraType,trigger.unit,tostring(trigger.spellName).."_other")
            end
        else
            if not self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName)] then
                self.amp[trigger.auraType][trigger.unit][tostring(trigger.spellName)] = 0
            end

            self:AddTriggerToList(watchId,"amp",trigger.auraType,trigger.unit,tostring(trigger.spellName))
        end

        return
    end

    if trigger.triggerType == "Threat" then
        if not self.threat then
            self.threat = {
                value = 0,
                status = {}
            }
        end

        self:AddTriggerToList(watchId,"threat")
        return
    end

    if trigger.triggerType == "Unit" and trigger.unit then
        if not self.units then
            self.units = {}
        end

        if not self.units[trigger.unit] then
            self.units[trigger.unit] = {}
        end

        for k,v in pairs(trigger.circumstances) do
            if not self.units[trigger.unit][k] then
                self.units[trigger.unit][k] = false
            end

            self:AddTriggerToList(watchId,"unit",trigger.unit,k)

            if k == "IsVulnerable" then
                if not self.units[trigger.unit]["MOO"] then
                    self.units[trigger.unit]["MOO"] = {
                        time = 0,
                        current = 0,
                        total = 0
                    }
                end

                self:AddTriggerToList(watchId,"units",trigger.unit,"MOO")
            end
        end

        if not self.units[trigger.unit]["Name"] then
            self.units[trigger.unit]["Valid"] = false
            self.units[trigger.unit]["Name"] = ""
            self.units[trigger.unit]["Level"] = 0
            self.units[trigger.unit]["Class"] = 0
            self.units[trigger.unit]["Hostility"] = 0
            self.units[trigger.unit]["Rank"] = 0
            self.units[trigger.unit]["Difficulty"] = 0
        end

        return
    end
end

-- #########################################################################################################################################
-- #########################################################################################################################################
-- #
-- # REFRESH STUFF
-- #
-- #########################################################################################################################################
-- #########################################################################################################################################

function LUI_Aura:OnFrame()
    if not self.bDocLoaded then
        return
    end

    if self.pause then
        return
    end

    if not self.unitPlayer then
        self.unitPlayer = GameLib.GetPlayerUnit()
        return
    end

    if not self.lastCheck then
        self.lastCheck = Apollo.GetTickCount()
        return
    end

    if (Apollo.GetTickCount() - self.lastCheck) > self.config.interval then
        if self.unitTarget then
            self.unitToT = self.unitTarget:GetTarget()
        end

        if not self.isReady then
            self.isReady = self:BuildAuras()
            return
        end

        -- Update
        self:CheckCasts()
        self:CheckCooldowns()
        self:CheckStats()
        self:CheckUnits()

        -- Rebuild
        self:UpdateAuras()
        self.lastCheck = Apollo.GetTickCount()
    end
end

function LUI_Aura:OnNextFrame()
    self:CheckAnimations()
end

function LUI_Aura:CheckAnimations()
    if not self.animations then
        return
    end

    local tFinished = {}
    self.tick = Apollo.GetTickCount()

    for groupId,group in pairs(self.animations) do
        for auraId,aura in pairs(group) do
            for id,animation in pairs(aura) do

                if animation.id == "bar" or animation.id == "overlay" then
                    local percent = ((animation.duration - (self.tick - animation.time)) * 100) / animation.duration

                    if percent <= 0 then
                        percent = 0.01
                    elseif percent >= 100 then
                        percent = 99.999
                    end

                    if animation.invert ~= nil and animation.invert == true then
                        percent = 100 - percent
                    end

                    if percent >= 99.9 then
                        table.insert(tFinished,animation)
                    end

                    animation.wnd:SetProgress(percent)

                elseif animation.id == "start" then

                    -- #########################################################################################################################################
                    -- # START ANIMATION
                    -- #########################################################################################################################################

                    local run = true

                    if not animation.runtime then
                        animation.runtime = {}
                    end

                    local anim = animation.settings

                    if not anim then
                        table.insert(tFinished,animation)
                        run = false
                    end

                    if anim.duration <= 0 then
                        table.insert(tFinished,animation)
                        run = false
                    end

                    if run == true and not animation.runtime.hasStarted then

                        if self.animations[animation.groupId][animation.auraId]["end"] ~= nil then
                            self:RemoveAnimation(self.animations[animation.groupId][animation.auraId]["end"])
                        end

                        local tLoc = animation.wnd:GetLocation()
                        local oL,oT,oR,oB = tLoc:GetOffsets()

                        animation.runtime.tick = self.tick
                        animation.runtime.hasStarted = true

                        if anim.slideEnable == true and (anim.slideOffsetX ~= 0 or anim.slideOffsetY ~= 0) then
                            animation.wnd:SetAnchorOffsets(
                                oL + anim.slideOffsetX,
                                oT + anim.slideOffsetY,
                                oR + anim.slideOffsetX,
                                oB + anim.slideOffsetY
                            )

                            animation.wnd:TransitionMove(tLoc, anim.duration, tonumber(anim.slideTransition))
                        end

                        if anim.effect == "Fade" then
                            animation.wnd:Show(true,false,anim.duration or 1)
                        else
                            animation.wnd:Show(true,true)
                        end

                        if anim.zoomEnable == true and anim.zoomScale ~= 1 then
                            animation.wnd:SetScale(anim.zoomScale)
                        end
                    else
                        if ((self.tick - animation.runtime.tick) / 1000) > anim.duration then
                            animation.wnd:SetScale(1)
                            table.insert(tFinished,animation)
                        else
                            if anim.zoomEnable == true and anim.zoomScale ~= 1 then
                                local percent = (((self.tick - animation.runtime.tick) / 1000) * 100) / anim.duration

                                animation.wnd:SetScale(1 + (((anim.zoomScale - 1) / 100) * (100 - percent)))
                            end
                        end
                    end

                elseif animation.id == "end" then

                    -- #########################################################################################################################################
                    -- # END ANIMATION
                    -- #########################################################################################################################################

                    local run = true

                    if not animation.runtime then
                        animation.runtime = {}
                    end

                    local anim = animation.settings

                    if not anim then
                        table.insert(tFinished,animation)
                        run = false
                    end

                    if anim.duration <= 0 then
                        table.insert(tFinished,animation)
                        run = false
                    end

                    if run == true and not animation.runtime.hasStarted then

                        if self.animations[animation.groupId][animation.auraId]["start"] ~= nil then
                            self:RemoveAnimation(self.animations[animation.groupId][animation.auraId]["start"])
                        end

                        local tLoc = animation.wnd:GetLocation()
                        local oL,oT,oR,oB = tLoc:GetOffsets()

                        animation.runtime.tick = self.tick
                        animation.runtime.hasStarted = true

                        -- Slide Animation
                        if anim.slideEnable == true and (anim.slideOffsetX ~= 0 or anim.slideOffsetY ~= 0) then
                            tLoc:SetOffsets(
                                oL + anim.slideOffsetX,
                                oT + anim.slideOffsetY,
                                oR + anim.slideOffsetX,
                                oB + anim.slideOffsetY
                            )

                            animation.wnd:TransitionMove(tLoc, anim.duration, tonumber(anim.slideTransition))
                        end

                        if anim.effect == "Fade" then
                            animation.wnd:Show(false,false,anim.duration or 1)
                        end

                        if anim.zoomEnable == true and anim.zoomScale ~= 1 then
                            animation.wnd:SetScale(1)
                        end
                    else
                        if ((self.tick - animation.runtime.tick) / 1000) > anim.duration then
                            animation.wnd:Show(false,true)
                            animation.wnd:SetScale(1)
                            table.insert(tFinished,animation)
                            --self:RemoveAnimation(animation.groupId,animation.auraId)
                        else
                            if anim.zoomEnable == true and anim.zoomScale ~= 1 then
                                local percent = (((self.tick - animation.runtime.tick) / 1000)* 100) / anim.duration

                                animation.wnd:SetScale(1 + (((anim.zoomScale - 1) / 100) * percent))
                            end
                        end
                    end
                end

            end
        end
    end

    for _,animation in ipairs(tFinished) do
        self:RemoveAnimation(animation)
    end
end

function LUI_Aura:ResetThreat(reset)
    if not self.threat then
        return
    end

    if reset == true then
        self.threat.value = 0
    end

    for id,_ in pairs(self.threat.status) do
        self.threat.status[id] = false
    end
end

function LUI_Aura:OnThreatUpdated(...)
    if not self.threat then
        return
    end

    if select(1, ...) == nil then
        return
    end

    self:ResetThreat()

    local myName = self.unitPlayer:GetName()
    local isTanking = false
    local aggroUnit = nil
    local topUnit = nil

    local myValue = self.threat.value or 0
    local topValue = 0
    local secondValue = 0
    local aggroValue = 0

    local myPercentage = 0
    local topPercentage = 0

    for i=1, select('#', ...), 2 do
        local unit = select(i, ...)
        local threat = select(i+1, ...)

        if unit ~= nil then
            if i == 1 then
                aggroValue = threat
                aggroUnit = unit
                isTanking = ((unit:GetName() or "") == myName)
            end

            if unit:GetName() == myName then
                myValue = threat
            end

            if threat > topValue then
                topValue = threat
                topUnit = unit
            else
                if threat > secondValue then
                    secondValue = threat
                end
            end
        end
    end

    if myValue > 0 and aggroValue > 0 then
        topPercentage = topValue / aggroValue * 100

        if isTanking == true then
            if myValue == topValue and secondValue > 0 then
                myPercentage = myValue / secondValue * 100
            else
                myPercentage = myValue / topValue * 100
            end
        else
            myPercentage = myValue / aggroValue * 100
        end

        if myPercentage >= 0 then
            self.threat.value = myPercentage
        else
            self.threat.value = 0
        end
    else
        self.threat.value = 0
    end

    self.threat.status["1"] = (isTanking == true)                             -- Is Tanking
    self.threat.status["2"] = (isTanking == false)                            -- Is not Tanking
    self.threat.status["3"] = (myPercentage == 0)                            -- Is not on Threat List
    self.threat.status["4"] = (isTanking == false and myPercentage < 100)    -- Threat benieth tank
    self.threat.status["5"] = (isTanking == false and myPercentage >= 100)     -- Threat above tank
    self.threat.status["6"] = (isTanking == true and topPercentage < 100)     -- Tanking but not highest
    self.threat.status["7"] = (isTanking == true and topPercentage >= 100)     -- Tanking and highest
end

function LUI_Aura:CheckUnits()
    if not self.units then
        return
    end

    for unit,functions in pairs(self.units) do
        for func,_ in pairs(functions) do
            self.units[unit][func] = self.functions[func](self.functions[unit](),unit)
        end
    end
end

function LUI_Aura:CheckStats()
    if not self.stats then
        return
    end

    for unit,functions in pairs(self.stats) do
        for func,_ in pairs(functions) do
            self.stats[unit][func] = self.functions[func](self.functions[unit]())
        end
    end
end

function LUI_Aura:OnStartSpellThreshold(idSpell, nMaxThresholds)
    if not idSpell or not self.casts or not self.casts["Player"] then
        return
    end

    if self.casts["Player"].threshold == true and idSpell == self.casts["Player"].id then
        return
    end

    local splObject = GameLib.GetSpell(idSpell)

    if not splObject then
        return
    end

    local fPercentDone = GameLib.GetSpellThresholdTimePrcntDone(idSpell)
    local max = nMaxThresholds - 1
    local duration = splObject:GetThresholdTime() or 0
    local elapsed = (duration /  max) * fPercentDone --(duration / nMaxThresholds * fPercentDone) or 0

    self.casts["Player"] = {
        active = true,
        threshold = true,
        spellName = splObject:GetName() or "",
        icon = self.icons[splObject:GetName()] or "",
        time = Apollo.GetTickCount(),
        current = elapsed * 1000,
        total = duration * 1000,
        percent = (elapsed * 100) / duration,
        tier = 0,
        max = max,
        id = idSpell,
    }
end

function LUI_Aura:OnUpdateSpellThreshold(idSpell, nNewThreshold)
    if not idSpell or not self.casts or not self.casts["Player"] then
        return
    end

    if not self.casts["Player"].id or idSpell ~= self.casts["Player"].id then
        return
    end

    self.casts["Player"].tier = nNewThreshold - 1
end

function LUI_Aura:OnClearSpellThreshold(idSpell)
    if not idSpell or not self.casts or not self.casts["Player"] then
        return
    end

    if not self.casts["Player"].id or idSpell ~= self.casts["Player"].id then
        return
    end

    self.casts["Player"] = {
        active = false,
        threshold = false,
        spellName = "",
        icon = "",
        time = 0,
        current = 0,
        total = 0,
        percent = 0,
        tier = 0,
        max = 0,
        id = 0,
    }
end

function LUI_Aura:CheckCasts()
    if not self.casts then
        return
    end

    for unit,cast in pairs(self.casts) do
        local castName = self.functions["CastName"](self.functions[unit]()) or ""
        local duration = 0
        local elapsed = 0
        local percent = 0

        if self.casts[unit].threshold == true and self.casts[unit].id then
            local fPercentDone = GameLib.GetSpellThresholdTimePrcntDone(self.casts[unit].id)
            duration = self.casts[unit].total
            elapsed = (duration / self.casts[unit].max * fPercentDone) + (duration / self.casts[unit].max * self.casts[unit].tier)
            percent = (elapsed * 100) / duration

            if elapsed > duration then
                elapsed = duration / 100 * 99.89
                percent = 100
            end
        else
            duration = self.functions["CastDuration"](self.functions[unit]()) or 0
            elapsed = self.functions["CastElapsed"](self.functions[unit]()) or 0
            percent = (elapsed * 100) / duration
        end

        if castName ~= "" and duration > 0 then
            self.casts[unit].active = true
            self.casts[unit].spellName = castName or ""
            self.casts[unit].icon = self.icons[castName] or ""
            self.casts[unit].current = elapsed
            self.casts[unit].total = duration
            self.casts[unit].percent = percent

            if self.casts[unit].time > 0 and (self.casts[unit].time + self.casts[unit].total) > Apollo.GetTickCount() then
                self.casts[unit].time = self.casts[unit].time
            else
                self.casts[unit].time = Apollo.GetTickCount() - elapsed
            end
        else
            self.casts[unit].active = false
            self.casts[unit].threshold = false
            self.casts[unit].spellName = ""
            self.casts[unit].icon = ""
            self.casts[unit].time = 0
            self.casts[unit].current = 0
            self.casts[unit].total = 0
            self.casts[unit].percent = 0
            self.casts[unit].tier = 0
            self.casts[unit].max = 0
            self.casts[unit].id = 0
        end
    end
end

function LUI_Aura:CheckCooldowns()
    if not self.cooldowns then
        return
    end

    -- Check Abilities
    if self.abilities then
        for spellName,spells in pairs(self.abilities) do
            if self.cooldowns[spellName] ~= nil and spells then
                local cooldown = self.cooldowns[spellName]

                if type(spells) == "table" then
                    for _,spell in ipairs(spells) do
                        if spell then
                            cooldown.cdRemaining, cooldown.cdTotal, cooldown.chargesRemaining, cooldown.chargesMax = self:GetSpellCooldown(spell)
                            cooldown.active = not (cooldown.cdRemaining == 0 or cooldown.chargesRemaining > 0)
                            cooldown.icon = spell:GetIcon()

                            if (cooldown.cdRemaining ~= nil and cooldown.cdRemaining > 0) or (cooldown.chargesMax ~= nil and cooldown.chargesMax > 0) then
                                break
                            end
                        end
                    end
                else
                    cooldown.cdRemaining, cooldown.cdTotal, cooldown.chargesRemaining, cooldown.chargesMax = self:GetSpellCooldown(spells)
                    cooldown.active = not (cooldown.cdRemaining == 0 or cooldown.chargesRemaining > 0)
                    cooldown.icon = spells:GetIcon()
                end
            end
        end
    end

    -- Check Gadget
    if self.cooldowns["Gadget"] ~= nil then
        local spell = GameLib.GetGadgetAbility()
        local cooldown = self.cooldowns["Gadget"]

        if spell then
            cooldown.cdRemaining, cooldown.cdTotal, cooldown.chargesRemaining, cooldown.chargesMax = self:GetSpellCooldown(spell)
            cooldown.active = not (cooldown.cdRemaining == 0 or cooldown.chargesRemaining > 0)
            cooldown.name = spell:GetName()
            cooldown.icon = spell:GetIcon()
        end
    end

    -- Check Innate
    if self.cooldowns["Innate"] ~= nil then
        local cooldown = self.cooldowns["Innate"]
        cooldown.icon = self.stance:GetIcon()

        for i = 1, GameLib.GetClassInnateAbilitySpells().nSpellCount * 2, 2 do
            local spell = GameLib.GetClassInnateAbilitySpells().tSpells[i]

            if spell then
                cooldown.cdRemaining, cooldown.cdTotal, cooldown.chargesRemaining, cooldown.chargesMax = self:GetSpellCooldown(spell)
                cooldown.active = not (cooldown.cdRemaining == 0 or cooldown.chargesRemaining > 0)

                if cooldown.active == true then
                    break
                end
            end
        end
    end
end

function LUI_Aura:OnBuffAdded(unit,spell)
    self:OnBuffEvent(unit,spell,"add")
end

function LUI_Aura:OnBuffUpdated(unit,spell)
    self:OnBuffEvent(unit,spell,"update")
end

function LUI_Aura:OnBuffRemoved(unit,spell)
    self:OnBuffEvent(unit,spell,"remove")
end

function LUI_Aura:OnBuffEvent(unit,spell,action)
    if not unit or not spell or not action then return end

    local unitName = unit:GetName()

    if self.unitPlayer and unitName == self.unitPlayer:GetName() then
        self:CheckBuff("Player",spell,action)
    end

    if self.unitTarget and unit:GetId() == self.unitTarget:GetId() then
        self:CheckBuff("Target",spell,action)
    end

    if self.unitFocus and unit:GetId() == self.unitFocus:GetId() then
        self:CheckBuff("Focus",spell,action)
    end

    if self.unitToT and unit:GetId() == self.unitToT:GetId() then
        self:CheckBuff("ToT",spell,action)
    end
end

function LUI_Aura:CheckBuffs(target,unit)
    if not self.spells or not target then
        return
    end

    local check = false
    local checkBuffs = false
    local checkDebuffs = false

    -- Reset Buffs
    if self.spells["Buff"] and self.spells["Buff"][target] then
        for spellName, spell in pairs(self.spells["Buff"][target]) do
            self:UpdateBuff(target,"Buff",spellName,spell,"reset")
        end

        check = true
        checkBuffs = true
    end

    if self.spells["Debuff"] and self.spells["Debuff"][target] then
        for spellName, spell in pairs(self.spells["Debuff"][target]) do
            self:UpdateBuff(target,"Debuff",spellName,spell,"reset")
        end

        check = true
        checkDebuffs = true
    end

    if check == true and unit then
        local spells = unit:GetBuffs()

        if checkBuffs == true then
            if spells ~= nil and spells.arBeneficial ~= nil then
                if #self.spells["Buff"][target] then
                    for spellId=1, #spells.arBeneficial do
                        local spell = spells.arBeneficial[spellId]
                        self:CheckBuff(target,spell,"add")
                    end
                end
            end
        end

        if checkDebuffs == true then
            if spells ~= nil and spells.arHarmful ~= nil then
                if #self.spells["Debuff"][target] then
                    for spellId=1, #spells.arHarmful do
                        local spell = spells.arHarmful[spellId]
                        self:CheckBuff(target,spell,"add")
                    end
                end
            end
        end
    end
end

function LUI_Aura:CheckBuff(unit,spell,action)
    if not unit or not spell or not action then
        return
    end

    local auraType = spell.splEffect:IsBeneficial() and "Buff" or "Debuff"
    local spellId = tostring(spell.splEffect:GetId())
    local spellName = spell.splEffect:GetName()
    local owner = spell.unitCaster and spell.unitCaster:GetName() or nil

    if not spellName or not spellId then
        return
    end

    -- Check Spells
    if self.spells and self.spells[auraType] and self.spells[auraType][unit] then
        if self.spells[auraType][unit][spellName] then
            self:UpdateBuff(unit,auraType,spellName,spell,action)
        end

        if self.spells[auraType][unit][spellName.."_self"] and owner == self.unitPlayer:GetName() then
            self:UpdateBuff(unit,auraType,spellName.."_self",spell,action)
        end

        if self.spells[auraType][unit][spellName.."_other"] and owner ~= self.unitPlayer:GetName() then
            self:UpdateBuff(unit,auraType,spellName.."_other",spell,action)
        end

        if self.spells[auraType][unit][spellId] then
            self:UpdateBuff(unit,auraType,spellId,spell,action)
        end

        if self.spells[auraType][unit][spellId.."_self"] and owner == self.unitPlayer:GetName() then
            self:UpdateBuff(unit,auraType,spellId.."_self",spell,action)
        end

        if self.spells[auraType][unit][spellId.."_other"] and owner ~= self.unitPlayer:GetName() then
            self:UpdateBuff(unit,auraType,spellId.."_other",spell,action)
        end
    end

    -- Check AMPs
    if self.amp and self.amp[auraType] and self.amp[auraType][unit] then
        if self.amp[auraType][unit][spellName] ~= nil and self.amp[auraType][unit][spellName] == 0 then
            self.amp[auraType][unit][spellName] = Apollo.GetTickCount()
        end

        if self.amp[auraType][unit][spellName.."_self"] ~= nil and self.amp[auraType][unit][spellName.."_self"] == 0 and owner == self.unitPlayer:GetName() then
            self.amp[auraType][unit][spellName.."_self"] = Apollo.GetTickCount()
        end

        if self.amp[auraType][unit][spellName.."_other"] ~= nil and self.amp[auraType][unit][spellName.."_other"] == 0 and owner ~= self.unitPlayer:GetName() then
            self.amp[auraType][unit][spellName.."_other"] = Apollo.GetTickCount()
        end

        if self.amp[auraType][unit][spellId] ~= nil and self.amp[auraType][unit][spellId] == 0 then
            self.amp[auraType][unit][spellId] = Apollo.GetTickCount()
        end

        if self.amp[auraType][unit][spellId.."_self"] ~= nil and self.amp[auraType][unit][spellId.."_self"] == 0 and owner == self.unitPlayer:GetName() then
            self.amp[auraType][unit][spellId.."_self"] = Apollo.GetTickCount()
        end

        if self.amp[auraType][unit][spellId.."_other"] ~= nil and self.amp[auraType][unit][spellId.."_other"] == 0 and owner ~= self.unitPlayer:GetName() then
            self.amp[auraType][unit][spellId.."_other"] = Apollo.GetTickCount()
        end
    end
end

function LUI_Aura:UpdateBuff(unit,auraType,id,spell,action)
    if not unit or not auraType or not id or not spell or not action then
        return
    end

    if not self.spells then
        return
    end

    if not self.spells[auraType] then
        return
    end

    if not self.spells[auraType][unit] then
        return
    end

    if not self.spells[auraType][unit][id] then
        return
    end

    if action == "add" then
        local reset = false

        if self.spells[auraType][unit][id].time and self.spells[auraType][unit][id].time ~= 0 then
            if self.spells[auraType][unit][id].idBuff == spell.idBuff then
                if (self.spells[auraType][unit][id].cache or 0) < spell.fTimeRemaining then
                    reset = true
                end
            else
                reset = true
            end
        else
            reset = true
        end

        self.spells[auraType][unit][id] = {
            active = true,
            name = spell.splEffect:GetName(),
            id = spell.splEffect:GetId(),
            icon = spell.splEffect:GetIcon(),
            time = (reset == true) and Apollo.GetTickCount() or (self.spells[auraType][unit][id].time or 0),
            stacks = spell.nCount or 0,
            duration = ((self.spells[auraType][unit][id].duration or 0) < spell.fTimeRemaining) and spell.fTimeRemaining or (self.spells[auraType][unit][id].duration or 0),
            cache = spell.fTimeRemaining,
            idBuff = spell.idBuff
        }
    elseif action == "update" then
        self.spells[auraType][unit][id] = {
            active = true,
            name = spell.splEffect:GetName(),
            id = spell.splEffect:GetId(),
            icon = spell.splEffect:GetIcon(),
            time = Apollo.GetTickCount(),
            stacks = spell.nCount or 0,
            duration = ((self.spells[auraType][unit][id].duration or 0) < spell.fTimeRemaining) and spell.fTimeRemaining or (self.spells[auraType][unit][id].duration or 0),
            cache = spell.fTimeRemaining,
            idBuff = spell.idBuff
        }
    elseif action == "remove" then
        if spell and spell.splEffect and self.spells[auraType][unit][id].id ~= spell.splEffect:GetId() then
            return
        end

        self.spells[auraType][unit][id] = {
            active = false,
            time = 0,
            stacks = 0,
            duration = 0,
            cache = 0,
            idBuff = 0,
        }
    elseif action == "reset" then
        self.spells[auraType][unit][id].active = false
    end
end

-- #########################################################################################################################################
-- #########################################################################################################################################
-- #
-- # DO THE WORK
-- #
-- #########################################################################################################################################
-- #########################################################################################################################################

function LUI_Aura:UpdateAuras()
    if not self.tWndAuras then
        return
    end

    local tick = Apollo.GetTickCount()

    for groupId=1,#self.config.groups do
        local group = self.config.groups[groupId]

        if not group.locked and group.dynamic.enable == true then
             self:GroupConfigMode(groupId)
        else
            if group.runtime.run and group.runtime.run == true and group.runtime.valid and group.runtime.valid == true then
                -- Check Auras
                for auraId=1,#group.runtime.auras do
                    local aura = group.runtime.auras[auraId]

                    if aura.runtime.run and aura.runtime.run == true and aura.runtime.valid and aura.runtime.valid == true then
                        aura.runtime.iconChanged = false
                        aura.runtime.borderChanged = false
                        aura.runtime.barChanged = false
                        aura.runtime.barInvert = nil
                        aura.runtime.source = nil

                        if self:ProcessTriggers(aura,groupId,auraId) == true then
                            self:PostTriggerCheck(aura,groupId,auraId)
                            self:PostAuraCheck(aura,groupId,auraId)

                            if not aura.runtime.show == true then
                                aura.runtime.show = true

                                if not aura.dynamic.enable == true then
                                    aura.runtime.isShown = true
                                    self:ShowAura(groupId,auraId)
                                else
                                    if not aura.runtime.tick then
                                        aura.runtime.tick = tick
                                    end
                                end
                            end
                        else
                            aura.runtime.soundPlayed = false
                            aura.runtime.tick = nil

                            if aura.runtime.show == true then
                                aura.runtime.show = false
                                aura.runtime.isShown = false
                                self:HideAura(groupId,auraId)
                            end
                        end
                    else
                        aura.runtime.soundPlayed = false
                        aura.runtime.tick = nil

                        if not aura.locked then
                            self:AuraConfigMode(groupId,auraId)
                        else
                            if aura.runtime.show == true then
                                aura.runtime.show = false
                                aura.runtime.isShown = false
                                self:HideAura(groupId,auraId)
                            end
                        end
                    end
                end

                -- Build Groups
                if group.dynamic.enable == true then
                    self:ShowGroup(groupId)
                end
            else
                for auraId=1,#group.runtime.auras do
                    local aura = group.runtime.auras[auraId]

                    if not aura.locked then
                        self:AuraConfigMode(groupId,auraId)
                    else
                        if aura.runtime.show == true then
                            aura.runtime.show = false
                            aura.runtime.isShown = false
                            self:HideAura(groupId,auraId)
                        end
                    end
                end
            end
        end
    end
end

function LUI_Aura:ProcessTriggers(aura,groupId,auraId)
    if not aura or not groupId or not auraId then
        return false
    end

    aura.runtime.triggerCount = #aura.triggers
    aura.runtime.triggerPassed = 0
    local abort = false

    for triggerId=1,#aura.triggers do
        local trigger = aura.triggers[triggerId]

        if not trigger.runtime then
            trigger.runtime = {}
        end

        if trigger.enable == true and trigger.triggerType then
            trigger.runtime.checked = true

            if trigger.triggerType == "Group" then
                state = self:ProcessTriggers(trigger,groupId,auraId)
            else
                state = self:ProcessTrigger(trigger)
            end

            if state == true then
                if aura.behavior == "None" then
                    break
                end

                aura.runtime.triggerPassed = aura.runtime.triggerPassed + 1

                if aura.behavior == "Any" or aura.behavior == "Always" then
                    break
                end
            else
                if aura.behavior == "All" then
                    break
                end
            end
        else
            aura.runtime.triggerCount = aura.runtime.triggerCount - 1
        end
    end

    if aura.behavior == "Always" then
        aura.runtime.state = "Always"
        return true
    elseif aura.behavior == "All" and aura.runtime.triggerPassed == aura.runtime.triggerCount then
        aura.runtime.state = "All"
        return true
    elseif aura.behavior == "Any" and aura.runtime.triggerPassed ~= 0 then
        aura.runtime.state = "Any"
        return true
    elseif aura.behavior == "None" and aura.runtime.triggerPassed == 0 then
        aura.runtime.state = "None"
        return true
    else
        aura.runtime.state = "Fail"
        return false
    end
end

function LUI_Aura:ProcessTrigger(trigger)
    if not trigger then
        return true
    end

    if trigger.unit and trigger.unit == "Target" and not self.unitTarget then
        return self:GetVerdict(trigger,false)
    end

    if trigger.unit and trigger.unit == "Focus" and not self.unitFocus then
        return self:GetVerdict(trigger,false)
    end

    if trigger.unit and trigger.unit == "ToT" and not self.unitToT then
        return self:GetVerdict(trigger,false)
    end

    local state = nil

    if trigger.triggerType == "Ability" then
        state = self:ProcessTriggerAbility(trigger)
    end

    if trigger.triggerType == "Attribute" then
        state = self:ProcessTriggerAttribute(trigger)
    end

    if (trigger.triggerType == "Buff" or trigger.triggerType == "Debuff") then
        state = self:ProcessTriggerSpell(trigger)
    end

    if trigger.triggerType == "Gadget" then
        state = self:ProcessTriggerGadget(trigger)
    end

    if trigger.triggerType == "Innate" then
        state = self:ProcessTriggerInnate(trigger)
    end

    if trigger.triggerType == "Cooldown" then
        state = self:ProcessTriggerCooldown(trigger)
    end

    if trigger.triggerType == "Cast" then
        state = self:ProcessTriggerCast(trigger)
    end

    if trigger.triggerType == "Keybind" then
        state = self:ProcessTriggerKeybind(trigger)
    end

    if trigger.triggerType == "Script" then
        state = self:ProcessTriggerScript(trigger)
    end

    if trigger.triggerType == "AMP Cooldown" then
        state = self:ProcessTriggerAmp(trigger)
    end

    if trigger.triggerType == "Unit" then
        state = self:ProcessTriggerUnit(trigger)
    end

    if trigger.triggerType == "Threat" then
        state = self:ProcessTriggerThreat(trigger)
    end

    return self:GetVerdict(trigger,state)
end

function LUI_Aura:GetVerdict(trigger,state)
    if not trigger then
        return false
    end

    if not trigger.runtime then
        trigger.runtime = {}
    end

    if state == "abort" then
        trigger.runtime.state = "Fail"
        return false
    else
        if trigger.behavior == "Ignore" then
            trigger.runtime.state = (state == true) and "Ignore" or "Fail"
            return true
        elseif trigger.behavior == "Pass" then
            trigger.runtime.state = (state == true) and "Pass" or "Fail"
            return (state == true)
        elseif trigger.behavior == "Fail" then
            trigger.runtime.state = (state == false) and "Pass" or "Fail"
            return (state == false)
        else
            trigger.runtime.state = "Fail"
            return false
        end
    end
end

function LUI_Aura:ProcessTriggerThreat(trigger)
    if not self.threat or not trigger then
        return false
    end

    -- Check Threat Value
    if trigger.threat and trigger.threat.operator and trigger.threat.value and tonumber(trigger.threat.value) ~= nil then
        if not self:IsOperatorSatisfied(self.threat.value, trigger.threat.operator, trigger.threat.value) then
            return false
        end
    end

    -- Check Threat Status
    if trigger.threat and trigger.threat.status and trigger.threat.status > 0 then
        if not self.threat.status[tostring(trigger.threat.status)] then
            return false
        end
    end

    return true
end

function LUI_Aura:ProcessTriggerUnit(trigger)
    if not self.units or not trigger or not trigger.unit then
        return true
    end

    if not self.units[trigger.unit]["Valid"] == true then
        return false
    end

    -- Check Unit Circumstances
    for func,state in pairs(trigger.circumstances) do
        if state ~= nil then
            if self.units[trigger.unit][func] ~= state then
                return false
            end
        end
    end

    -- Check Name
    if trigger.unitName and trigger.unitName ~= "" then
        if trigger.unitName ~= self.units[trigger.unit]["Name"] then
            return false
        end
    end

    -- Check Level
    if trigger.level and trigger.level.operator and trigger.level.value and tonumber(trigger.level.value) ~= nil then
        if not self:IsOperatorSatisfied(self.units[trigger.unit]["Level"], trigger.level.operator, trigger.level.value) then
            return false
        end
    end

    -- Check Class
    local list = self:GetListType(trigger.class) -- whitelist / blacklist

    if list then
        if list == "white" then
            if self.units[trigger.unit]["Class"] ~= nil then
                if trigger.class[tostring(self.units[trigger.unit]["Class"])] ~= nil then
                    if trigger.class[tostring(self.units[trigger.unit]["Class"])] == false then
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        elseif list == "black" then
            if self.units[trigger.unit]["Class"] ~= nil then
                if trigger.class[tostring(self.units[trigger.unit]["Class"])] ~= nil then
                    if trigger.class[tostring(self.units[trigger.unit]["Class"])] == false then
                        return false
                    end
                end
            end
        end
    end

    -- Check Hostility
    list = self:GetListType(trigger.hostility)

    if list then
        if list == "white" then
            if self.units[trigger.unit]["Hostility"] ~= nil then
                if trigger.hostility[tostring(self.units[trigger.unit]["Hostility"])] ~= nil then
                    if trigger.hostility[tostring(self.units[trigger.unit]["Hostility"])] == false then
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        elseif list == "black" then
            if self.units[trigger.unit]["Hostility"] ~= nil then
                if trigger.hostility[tostring(self.units[trigger.unit]["Hostility"])] ~= nil then
                    if trigger.hostility[tostring(self.units[trigger.unit]["Hostility"])] == false then
                        return false
                    end
                end
            end
        end
    end

    -- Check Rank
    list = self:GetListType(trigger.rank)

    if list then
        if list == "white" then
            if self.units[trigger.unit]["Rank"] ~= nil then
                if trigger.rank[tostring(self.units[trigger.unit]["Rank"])] ~= nil then
                    if trigger.rank[tostring(self.units[trigger.unit]["Rank"])] == false then
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        elseif list == "black" then
            if self.units[trigger.unit]["Rank"] ~= nil then
                if trigger.rank[tostring(self.units[trigger.unit]["Rank"])] ~= nil then
                    if trigger.rank[tostring(self.units[trigger.unit]["Rank"])] == false then
                        return false
                    end
                end
            end
        end
    end

    -- Check Difficulty
    list = self:GetListType(trigger.difficulty)

    if list then
        if list == "white" then
            if self.units[trigger.unit]["Difficulty"] ~= nil then
                if trigger.difficulty[tostring(self.units[trigger.unit]["Difficulty"])] ~= nil then
                    if trigger.difficulty[tostring(self.units[trigger.unit]["Difficulty"])] == false then
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        elseif list == "black" then
            if self.units[trigger.unit]["Difficulty"] ~= nil then
                if trigger.difficulty[tostring(self.units[trigger.unit]["Difficulty"])] ~= nil then
                    if trigger.difficulty[tostring(self.units[trigger.unit]["Difficulty"])] == false then
                        return false
                    end
                end
            end
        end
    end

    return true
end

function LUI_Aura:ProcessTriggerAmp(trigger)
    if not self.amp or not trigger or not trigger.time or not trigger.spellName or not trigger.unit or not trigger.auraType then
        return true
    end

    local spellName = tostring(trigger.spellName)

    if trigger.spellOwner ~= nil then
        if trigger.spellOwner == true then
            spellName = tostring(trigger.spellName).."_self"
        elseif trigger.spellOwner == false then
            spellName = tostring(trigger.spellName).."_other"
        end
    end

    if not self.amp[trigger.auraType][trigger.unit][spellName] then
        return true
    else
        local timeSinceOccurence = (Apollo.GetTickCount() - self.amp[trigger.auraType][trigger.unit][spellName]) / 1000

        if timeSinceOccurence < trigger.time then
            local cdRemaining = trigger.time - timeSinceOccurence
            local durationState = true

            if trigger.duration.operator and trigger.duration.value and tonumber(trigger.duration.value) ~= nil then
                durationState = self:IsOperatorSatisfied(cdRemaining, trigger.duration.operator, trigger.duration.value)
            end

            return durationState
        else
            self.amp[trigger.auraType][trigger.unit][spellName] = 0
            return false
        end
    end
end

function LUI_Aura:ProcessTriggerKeybind(trigger)
    if not self.keybinds or not trigger or not trigger.keybind.text or not trigger.keybind.duration then
        return true
    end

    if not self.keybinds[trigger.keybind.text] then
        return true
    else
        local timeSinceKeypress = (Apollo.GetTickCount() - self.keybinds[trigger.keybind.text]) / 1000
        return timeSinceKeypress < trigger.keybind.duration
    end
end

function LUI_Aura:ProcessTriggerAbility(trigger)
    if not self.abilities or not trigger or not trigger.spellName then
        return true
    end

    if self.abilities[trigger.spellName] ~= nil then
        return true
    else
        return false
    end
end

function LUI_Aura:ProcessTriggerAttribute(trigger)
    if not self.stats or not trigger or not trigger.unit or not self.stats[trigger.unit] then
        return true
    end

    local state = true

    for attribute,stat in pairs(trigger.attributes) do
        if stat.operator and stat.value and stat.value ~= "" then
            if self.stats[trigger.unit][attribute] then
                if stat.percent == true then
                    state = self:IsOperatorSatisfied((self.stats[trigger.unit][attribute].current * 100 / self.stats[trigger.unit][attribute].max), stat.operator, stat.value)
                else
                    if attribute == "Interrupt Armor" then
                        if self.stats[trigger.unit][attribute].max == -1 then
                            state = self:IsOperatorSatisfied(self.stats[trigger.unit][attribute].max, stat.operator, stat.value)
                        else
                            state = self:IsOperatorSatisfied(self.stats[trigger.unit][attribute].current, stat.operator, stat.value)
                        end
                    else
                        state = self:IsOperatorSatisfied(self.stats[trigger.unit][attribute].current, stat.operator, stat.value)
                    end
                end

                if state == false then
                    return false
                end
            else
                return false
            end
        end
    end

    return state
end

function LUI_Aura:ProcessTriggerSpell(trigger)
    if not self.spells or not trigger or not trigger.unit or not trigger.spellName then
        return true
    end

    local spellName = tostring(trigger.spellName)

    if trigger.spellOwner ~= nil then
        if trigger.spellOwner == true then
            spellName = tostring(trigger.spellName).."_self"
        elseif trigger.spellOwner == false then
            spellName = tostring(trigger.spellName).."_other"
        end
    end

    if self.spells[trigger.triggerType][trigger.unit][spellName] and self.spells[trigger.triggerType][trigger.unit][spellName].active == true then
        local stacksState = true
        local durationState = true

        -- Check Stacks
        if trigger.stacks.operator and trigger.stacks.value and trigger.stacks.value ~= "" then
            stacksState = self:IsOperatorSatisfied(self.spells[trigger.triggerType][trigger.unit][spellName].stacks, trigger.stacks.operator, trigger.stacks.value)
        end

        -- Check Duration
        if trigger.duration.operator and trigger.duration.value and trigger.duration.value ~= "" then
            local time = self.spells[trigger.triggerType][trigger.unit][spellName].duration - ((Apollo.GetTickCount() - self.spells[trigger.triggerType][trigger.unit][spellName].time) / 1000)
            durationState = self:IsOperatorSatisfied(time, trigger.duration.operator, trigger.duration.value)
        end

        if trigger.duration.threshold and trigger.duration.threshold > 0 then
            trigger.runtime.lastOccurrence = Apollo.GetTickCount()
        end

        return (stacksState and durationState)
    else
        if trigger.duration.threshold and trigger.duration.threshold > 0 then
            if trigger.runtime.lastOccurrence and trigger.runtime.lastOccurrence > 0 then
                local lastOccurrence = ((Apollo.GetTickCount() - trigger.runtime.lastOccurrence) / 1000)
                if lastOccurrence < trigger.duration.threshold and lastOccurrence >= 0 then
                    return true
                else
                    trigger.runtime.lastOccurrence = 0
                end
            end
        end

        return false
    end
end

function LUI_Aura:ProcessTriggerGadget(trigger)
    if not self.cooldowns or not trigger then
        return false
    end

    local state = false

    if self.cooldowns["Gadget"] and self.cooldowns["Gadget"].active == true then
        if trigger.duration.operator and trigger.duration.value and trigger.duration.value ~= "" then
            state = self:IsOperatorSatisfied(self.cooldowns["Gadget"].cdRemaining, trigger.duration.operator, trigger.duration.value)
        else
            state = true
        end
    end

    if trigger.gadget and trigger.spellName then
        if trigger.gadget == "Pass" then
            if self.cooldowns["Gadget"] and self.cooldowns["Gadget"].name == trigger.spellName then
                return state
            else
                return not trigger.state
            end
        else
            if self.cooldowns["Gadget"] and self.cooldowns["Gadget"].name == trigger.spellName then
                return not trigger.state
            else
                return state
            end
        end
    else
        return state
    end
end

function LUI_Aura:ProcessTriggerInnate(trigger)
    if not self.cooldowns or not trigger then
        return false
    end

    if self.cooldowns["Innate"] and self.cooldowns["Innate"].active == true then
        if trigger.duration.operator and trigger.duration.value and trigger.duration.value ~= "" then
            return self:IsOperatorSatisfied(self.cooldowns["Innate"].cdRemaining, trigger.duration.operator, trigger.duration.value)
        else
            return true
        end
    else
        return false
    end
end

function LUI_Aura:ProcessTriggerScript(trigger)
    if not trigger then
        return false
    end

    if trigger.script ~= nil and trigger.script ~= "" then
        local script, loadScriptError = loadstring("local trigger = ...\n" .. trigger.script)
        if script ~= nil then
            local status, result = pcall(script, self)
            if not status then
                return "abort"
            else
                if type(result) ~= "boolean" then
                    return "abort"
                else
                    return result
                end
            end
        else
            return "abort"
        end
    end
end

function LUI_Aura:ProcessTriggerCast(trigger)
    if not self.casts or not trigger or not trigger.unit then
        return false
    end

    if not self.casts[trigger.unit] then
        return false
    end

    if not self.casts[trigger.unit].active == true then
        return false
    end

    if trigger.spellName and trigger.spellName ~= "" and trigger.spellName ~= self.casts[trigger.unit].spellName then
        return false
    end

    local checkDuration = trigger.duration.operator and trigger.duration.value and trigger.duration.value ~= ""

    if checkDuration == true and not self:IsOperatorSatisfied(self.casts[trigger.unit].percent, trigger.duration.operator, tonumber(trigger.duration.value)) then
        return false
    end

    return true
end

function LUI_Aura:ProcessTriggerCooldown(trigger)
    if not self.cooldowns or not trigger or not trigger.spellName then
        return false
    end

    local checkCharges = trigger.charges.operator and trigger.charges.value and trigger.charges.value ~= "" and self.cooldowns[trigger.spellName].chargesMax > 0
    local checkDuration = trigger.duration.operator and trigger.duration.value and trigger.duration.value ~= ""

    if not checkCharges and not checkDuration and not self.cooldowns[trigger.spellName].active then
        return false
    else
        if checkCharges == true and not self:IsOperatorSatisfied(self.cooldowns[trigger.spellName].chargesRemaining, trigger.charges.operator, tonumber(trigger.charges.value)) then
            return false
        end

        if checkDuration == true and not self:IsOperatorSatisfied(self.cooldowns[trigger.spellName].cdRemaining, trigger.duration.operator, tonumber(trigger.duration.value)) then
            return false
        end
    end

    return true
end

-- #########################################################################################################################################
-- #########################################################################################################################################
-- #
-- # POST UPDATE STUFF
-- #
-- #########################################################################################################################################
-- #########################################################################################################################################


function LUI_Aura:GetText(strType,strText,nValue,nTotal,nPercent,sLabel)
    if not strType or not strText then
        return ""
    end

    local value = nValue or 0
    local total = nTotal or 0
    local percent = nPercent or 0
    local label = sLabel or ""

    if strType == "duration" then

        if value > 60 then
            if value > 600 then
                value = string.format("%im", math.floor(value / 60), math.floor(value % 60))
            else
                value = string.format("%i:%02d", math.floor(value / 60), math.floor(value % 60))
            end
        else
            if value > 10 then
                value = string.format("%.0f", value)
            else
                value = Apollo.FormatNumber(value,1,true)
            end
        end

        if total > 60 then
            if total > 600 then
                total = string.format("%im", math.floor(total / 60), math.floor(total % 60))
            else
                total = string.format("%i:%02d", math.floor(total / 60), math.floor(total % 60))
            end
        else
            if total > 10 then
                total = string.format("%.0f", total)
            else
                total = Apollo.FormatNumber(total,1,true)
            end
        end

        strText = string.gsub(strText,"{v}",tostring(value))
        strText = string.gsub(strText,"{t}",tostring(total))
        strText = string.gsub(strText,"{vp}",tostring(math.ceil(percent)))
        strText = string.gsub(strText,"{tp}",tostring(100))

    elseif strType == "stacks" then

        strText = string.gsub(strText,"{v}",tostring(value))

    elseif strType == "charges" then

        strText = string.gsub(strText,"{v}",tostring(value))
        strText = string.gsub(strText,"{t}",tostring(total))

    elseif strType == "text" then

        if total > 0 then
            strText = string.gsub(strText,"{t}",tostring(Apollo.FormatNumber(total,0,true)))
            strText = string.gsub(strText,"{t1}",tostring(Apollo.FormatNumber(total,1,true)))
            strText = string.gsub(strText,"{t2}",tostring(Apollo.FormatNumber(total,2,true)))
            strText = string.gsub(strText,"{tp}","100")
            strText = string.gsub(strText,"{ts}",tostring(self:HelperFormatBigNumber(total)))
        else
            strText = string.gsub(strText,"{t}","")
            strText = string.gsub(strText,"{t1}","")
            strText = string.gsub(strText,"{t2}","")
            strText = string.gsub(strText,"{ts}","")
        end

        if value > 0 then
            strText = string.gsub(strText,"{v}",tostring(Apollo.FormatNumber(value,0,true)))
            strText = string.gsub(strText,"{v1}",tostring(Apollo.FormatNumber(value,1,true)))
            strText = string.gsub(strText,"{v2}",tostring(Apollo.FormatNumber(value,2,true)))
            strText = string.gsub(strText,"{vs}",tostring(self:HelperFormatBigNumber(value)))
        else
            strText = string.gsub(strText,"{v}","")
            strText = string.gsub(strText,"{v1}","")
            strText = string.gsub(strText,"{v2}","")
            strText = string.gsub(strText,"{vs}","")
        end

        strText = string.gsub(strText,"{vp}",tostring(math.ceil(percent)))

        local deficit = total - value
        local deficit_percent = (deficit * 100) / total

        if deficit > 0 then
            strText = string.gsub(strText,"{d}","-"..tostring(Apollo.FormatNumber(deficit,0,true)))
            strText = string.gsub(strText,"{d1}","-"..tostring(Apollo.FormatNumber(deficit,1,true)))
            strText = string.gsub(strText,"{d2}","-"..tostring(Apollo.FormatNumber(deficit,2,true)))
            strText = string.gsub(strText,"{dp}","-"..tostring(math.ceil(deficit_percent)))
            strText = string.gsub(strText,"{ds}","-"..tostring(self:HelperFormatBigNumber(deficit)))
        else
            strText = string.gsub(strText,"{d}","")
            strText = string.gsub(strText,"{d1}","")
            strText = string.gsub(strText,"{d2}","")
            strText = string.gsub(strText,"{dp}","")
            strText = string.gsub(strText,"{ds}","")
        end

        strText = string.gsub(strText,"{l}",tostring(label))
    end

    return strText
end

function LUI_Aura:GetSpell(source,eType)
    if not source then
        return
    end

    if eType == "duration" then
        if (source.sType == "Buff" or source.sType == "Debuff") and source.sUnit then
            if self.spells and self.spells[source.sType][source.sUnit][tostring(source.sName)] and self.spells[source.sType][source.sUnit][tostring(source.sName)].active == true then
                return self.spells[source.sType][source.sUnit][tostring(source.sName)]
            end
        elseif source.sType == "Cooldown" or source.sType == "Ability" or source.sType == "Gadget" or source.sType == "Innate" then
            if self.cooldowns and self.cooldowns[source.sName] and self.cooldowns[tostring(source.sName)].cdRemaining > 0 and self.cooldowns[tostring(source.sName)].cdRemaining < self.cooldowns[tostring(source.sName)].cdTotal then
                return self.cooldowns[source.sName]
            end
        elseif source.sType == "Cast" then
            if self.casts and self.casts[source.sUnit] and self.casts[source.sUnit].active == true then
                return self.casts[source.sUnit]
            end
        elseif source.sType == "Keybind" then
            if self.keybinds and self.keybinds[source.sName] then
                return self.keybinds[source.sName]
            end
        elseif source.sType == "AMP Cooldown" and source.sUnit and source.sAuraType then
            if self.amp and self.amp[source.sAuraType] and self.amp[source.sAuraType][source.sUnit] and self.amp[source.sAuraType][source.sUnit][tostring(source.sName)] then
                return self.amp[source.sAuraType][source.sUnit][tostring(source.sName)]
            end
        elseif source.sType == "Attribute" and source.sUnit and source.sValueType then
            if self.stats and self.stats[source.sUnit] and self.stats[source.sUnit][source.sValueType] then
                return self.stats[source.sUnit][source.sValueType]
            end
        elseif source.sType == "Threat" then
            return self.threat
        elseif source.sType == "MOO" then
            if self.units and self.units[source.sUnit] and self.units[source.sUnit]["MOO"] then
                return self.units[source.sUnit]["MOO"]
            end
        end
    elseif eType == "stacks" then
        if (source.sType == "Buff" or source.sType == "Debuff") and source.sUnit then
            if self.spells and self.spells[source.sType][source.sUnit][tostring(source.sName)] and self.spells[source.sType][source.sUnit][tostring(source.sName)].active == true then
                if self.spells[source.sType][source.sUnit][tostring(source.sName)].stacks ~= nil and self.spells[source.sType][source.sUnit][tostring(source.sName)].stacks > 1 then
                    return self.spells[source.sType][source.sUnit][tostring(source.sName)]
                end
            end
        end
    elseif eType == "charges" then
        if source.sType == "Cooldown" or source.sType == "Ability" then
            if self.cooldowns and self.cooldowns[tostring(source.sName)] and (self.cooldowns[tostring(source.sName)].chargesRemaining ~= nil and self.cooldowns[tostring(source.sName)].chargesRemaining > 0) then
                return self.cooldowns[source.sName]
            end
        end
    elseif eType == "text" then
        if source.sType == "Attribute" and source.sUnit and source.sValueType then
            if self.stats and self.stats[source.sUnit] and self.stats[source.sUnit][source.sValueType] then
                return self.stats[source.sUnit][source.sValueType]
            end
        elseif source.sType == "Cast" then
            if self.casts and self.casts[source.sUnit] and self.casts[source.sUnit].active == true then
                return self.casts[source.sUnit]
            end
        elseif source.sType == "Threat" then
            return self.threat
        elseif source.sType == "Ability" or source.sType == "Cooldown" then
            if self.shortcuts and self.shortcuts[source.sName] then
                return self.shortcuts[source.sName]
            end
        end
    elseif eType == "icon" then
        if (source.sType == "Buff" or source.sType == "Debuff") and source.sUnit then
            if self.spells and self.spells[source.sType][source.sUnit][tostring(source.sName)] then
                return self.spells[source.sType][source.sUnit][tostring(source.sName)]
            end
        elseif source.sType == "Cooldown" or source.sType == "Ability" or source.sType == "Gadget" or source.sType == "Innate" then
            if self.cooldowns and self.cooldowns[source.sName] then
                return self.cooldowns[source.sName]
            end
        elseif source.sType == "Cast" then
            if self.casts and self.casts[source.sUnit] and self.casts[source.sUnit].active == true then
                return self.casts[source.sUnit]
            end
        end
    end
end

function LUI_Aura:GetLabel(source,spell)
    if source.sType == "Cast" then
        return spell.spellName
    elseif source.sType == "Cooldown" or source.sType == "Ability" then
        return spell
    end
end

function LUI_Aura:GetDuration(source,tick,spell)
    local time,total,percent,current,static

    if source.sType == "Keybind" then
        time = spell
        total = source.sDuration * 1000
        current = (source.sDuration * 1000) - (tick - spell)
        static = true
    elseif source.sType == "AMP Cooldown" then
        time = spell
        total = source.sDuration * 1000
        current = (source.sDuration * 1000) - (tick - spell)
        static = true
    elseif source.sType == "Buff" or source.sType == "Debuff" then
        time = spell.time
        total = spell.duration * 1000
        current = (spell.duration * 1000) - (tick - spell.time)
        static = true
    elseif source.sType == "Cast" then
        time = spell.time
        total = spell.total
        current = spell.total - spell.current
        static = true
    elseif source.sType == "Attribute" then
        current = spell.current
        total = spell.max or 0
        static = false
    elseif source.sType == "Threat" then
        current = spell.value or 0
        total = 100
        static = false
    elseif source.sType == "Ability" or source.sType == "Cooldown" or source.sType == "Innate" or source.sType == "Gadget" then
        current = spell.cdRemaining * 1000
        total = spell.cdTotal * 1000
        static = false
    elseif source.sType == "MOO" then
        time = spell.time
        total = spell.total * 1000
        current = spell.current * 1000
        static = true
    end

    --if static == false then
        percent = current > 0 and ((current * 100) / total) or 0
    --else
        --percent = 0
    --end

    return time,total,percent,current,static
end

function LUI_Aura:PostAuraCheck(aura,groupId,auraId)
    if not aura or not groupId or not auraId then
        return
    end

    local source,spell,timeRemaining,time,total,percent,current,static,label
    local icon = self.tWndAuras[groupId][auraId]

    local overlay = icon:FindChild("overlay")
    local duration = icon:FindChild("duration")
    local stacks = icon:FindChild("stacks")
    local charges = icon:FindChild("charges")
    local text = icon:FindChild("text")
    local bar = icon:FindChild("bar")
    local tick = Apollo.GetTickCount()

    -- Icon
    if aura.icon and aura.icon.enable then
        if aura.icon.source and aura.icon.source ~= "" then
            if aura.runtime.source and aura.runtime.source["icon"] then
                source = aura.runtime.sources[aura.runtime.source["icon"]] or nil
            else
                source = aura.runtime.sources[aura.icon.source] or nil
            end

            spell = self:GetSpell(source,"icon") or nil

            if spell and spell.icon and spell.icon ~= "" then
                if (not aura.runtime.iconShown or (spell.icon ~= icon:FindChild("icon"):GetSprite())) and not aura.runtime.iconChanged then
                    icon:FindChild("icon"):SetSprite(spell.icon)
                    icon:FindChild("icon"):SetBGColor(ApolloColor.new(
                        aura.icon.color.r / 255,
                        aura.icon.color.g / 255,
                        aura.icon.color.b / 255,
                        aura.icon.color.a / 255
                    ))
                    icon:FindChild("icon"):Show(true,true)

                    if aura.overlay.shape == "Icon" then
                        overlay:SetFullSprite(spell.icon)
                    end

                    aura.runtime.iconShown = true
                end
            else
                if aura.icon.sprite and aura.icon.sprite ~= "" then
                    if (not aura.runtime.iconShown or (aura.icon.sprite ~= icon:FindChild("icon"):GetSprite())) and not aura.runtime.iconChanged then
                        icon:FindChild("icon"):SetSprite(aura.icon.sprite)
                        icon:FindChild("icon"):SetBGColor(ApolloColor.new(
                            aura.icon.color.r / 255,
                            aura.icon.color.g / 255,
                            aura.icon.color.b / 255,
                            aura.icon.color.a / 255
                        ))
                        icon:FindChild("icon"):Show(true,true)

                        if aura.overlay.shape == "Icon" then
                            overlay:SetFullSprite(aura.icon.sprite)
                        end

                        aura.runtime.iconShown = true
                    end
                else
                    icon:FindChild("icon"):SetSprite()

                    if aura.overlay.shape == "Icon" then
                        overlay:SetFullSprite()
                    end
                end
            end
        else
            if aura.icon.sprite and aura.icon.sprite ~= "" then
                if (not aura.runtime.iconShown or (aura.icon.sprite ~= icon:FindChild("icon"):GetSprite())) and not aura.runtime.iconChanged then
                    icon:FindChild("icon"):SetSprite(aura.icon.sprite)
                    icon:FindChild("icon"):SetBGColor(ApolloColor.new(
                        aura.icon.color.r / 255,
                        aura.icon.color.g / 255,
                        aura.icon.color.b / 255,
                        aura.icon.color.a / 255
                    ))
                    icon:FindChild("icon"):Show(true,true)

                    if aura.overlay.shape == "Icon" then
                        overlay:SetFullSprite(aura.icon.sprite)
                    end

                    aura.runtime.iconShown = true
                end
            end
        end
    end

    -- Border
    if aura.border and aura.border.enable and aura.border.sprite then
        if self:IsBehaviorMatched(aura,aura.border.behavior,true) == true then
            if not aura.runtime.borderShown and not aura.runtime.borderChanged then
                icon:FindChild("border"):SetSprite(aura.border.sprite or "")
                icon:FindChild("border"):SetAnchorOffsets(
                    aura.border.inset,
                    aura.border.inset,
                    aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset),
                    aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset)
                )
                icon:FindChild("border"):SetBGColor(ApolloColor.new(
                    aura.border.color.r / 255,
                    aura.border.color.g / 255,
                    aura.border.color.b / 255,
                    aura.border.color.a / 255
                ))
                icon:FindChild("border"):Show(true,true)
                aura.runtime.borderShown = true
            end
        else
            if aura.runtime.borderShown and not aura.runtime.borderChanged then
                icon:FindChild("border"):Show(false,true)
                aura.runtime.borderShown = false
            end
        end
    else
        if (aura.runtime.borderShown or aura.runtime.borderVisible) and not aura.runtime.borderChanged then
            icon:FindChild("border"):Show(false,true)
            aura.runtime.borderShown = false
            aura.runtime.borderVisible = false
        end
    end

    -- Sound
    if aura.sound and aura.sound.enable then
        if aura.behavior == aura.runtime.state and not aura.runtime.soundPlayed then
            self:PlaySound(aura.sound)
            aura.runtime.soundPlayed = true
        end
    end

    -- Dynamic Group
    if aura.dynamic.enable and aura.dynamic.enable == true then
        if aura.runtime.source and aura.runtime.source["dynamic"] then
            source = aura.runtime.sources[aura.runtime.source["dynamic"]] or nil
        else
            source = aura.runtime.sources[aura.dynamic.source] or nil
        end

        spell = self:GetSpell(source,"duration") or nil

        if spell then
            time,_,_ = self:GetDuration(source,tick,spell)
            aura.runtime.duration = time
        else
            aura.runtime.duration = 0
        end
    end

    -- Overlay
    if aura.overlay.enable and aura.overlay.source ~= nil and aura.overlay.source ~= "" then
        if aura.runtime.source and aura.runtime.source["overlay"] then
            source = aura.runtime.sources[aura.runtime.source["overlay"]] or nil
        else
            source = aura.runtime.sources[aura.overlay.source] or nil
        end

        spell = self:GetSpell(source,"duration") or nil

        if spell then

            time,total,percent,current,static = self:GetDuration(source,tick,spell)

            if static == true then
                -- Fluid Animation
                if current > 0.1 then
                    self:CreateAnimation({
                        wnd = overlay,
                        groupId = groupId,
                        auraId = auraId,
                        id = "overlay",
                        time = time,
                        duration = total,
                        invert = aura.overlay.invert
                    })
                    overlay:Show(true,true)
                else
                    self:RemoveAnimation({
                        wnd = overlay,
                        groupId = groupId,
                        auraId = auraId,
                        id = "overlay"
                    })
                    overlay:SetProgress(0)
                    overlay:Show(false,true)
                end
            else
                -- Clean Up First
                self:RemoveAnimation({
                    wnd = overlay,
                    groupId = groupId,
                    auraId = auraId,
                    id = "overlay"
                })

                -- Standard Animation
                if current > 0.1 then
                    self:CreateAnimationSlow({
                        wnd = overlay,
                        percent = percent,
                        invert = aura.overlay.invert
                    })
                    overlay:Show(true,true)
                else
                    overlay:SetProgress(0)
                    overlay:Show(false,true)
                end
            end
        else
            overlay:SetProgress(0)
            overlay:Show(false,true)
        end
    else
        overlay:SetProgress(0)
        overlay:Show(false,true)
    end

    -- Bar
    if aura.bar.enable and aura.bar.source ~= nil and aura.bar.source ~= "" then

        if not aura.runtime.barShown and not aura.runtime.barChanged then
            self:UpdateProgressBar(bar,aura,aura)
            aura.runtime.barShown = true
        end

        local invert = aura.bar.invert

        if aura.runtime.barInvert ~= nil then
            invert = aura.runtime.barInvert
        end

        if aura.runtime.source and aura.runtime.source["bar"] then
            source = aura.runtime.sources[aura.runtime.source["bar"]] or nil
        else
            source = aura.runtime.sources[aura.bar.source] or nil
        end

        spell = self:GetSpell(source,"duration") or nil

        if spell then
            time,total,percent,current,static = self:GetDuration(source,tick,spell)

            if static == true then
                -- Fluid Animation
                if current > 0.1 then
                    self:CreateAnimation({
                        wnd = bar:FindChild("progress"),
                        groupId = groupId,
                        auraId = auraId,
                        id = "bar",
                        time = time,
                        duration = total,
                        invert = invert
                    })
                    bar:Show(true,true)
                else
                    self:RemoveAnimation({
                        wnd = bar:FindChild("progress"),
                        groupId = groupId,
                        auraId = auraId,
                        id = "bar"
                    })
                    bar:FindChild("progress"):SetProgress(0)
                    bar:Show(false,true)
                end
            else
                -- Clean Up First
                self:RemoveAnimation({
                    wnd = bar:FindChild("progress"),
                    groupId = groupId,
                    auraId = auraId,
                    id = "bar"
                })

                -- Standard Animation
                if current > 0.1 then
                    if source.sType == "Threat" or source.sType == "Attribute" then -- Soooo dirty!!!
                        percent = 100 - percent
                    end

                    self:CreateAnimationSlow({
                        wnd = bar:FindChild("progress"),
                        percent = percent,
                        invert = invert
                    })
                    bar:Show(true,true)
                else
                    bar:FindChild("progress"):SetProgress(0)
                    bar:Show(false,true)
                end
            end
        else
            bar:FindChild("progress"):SetProgress(0)
            bar:Show(false,true)
        end
    else
        bar:FindChild("progress"):SetProgress(0)
        bar:Show(false,true)
    end

    -- Duration
    if aura.duration.enable and aura.duration.source ~= nil and aura.duration.source ~= "" then
        if aura.runtime.source and aura.runtime.source["duration"] then
            source = aura.runtime.sources[aura.runtime.source["duration"]] or nil
        else
            source = aura.runtime.sources[aura.duration.source] or nil
        end

        spell = self:GetSpell(source,"duration")

        if spell then
            time,total,percent,current,_ = self:GetDuration(source,tick,spell)

            if current > 0.1 then
                duration:SetText(self:GetText("duration",aura.duration.input,(current/1000),(total/1000),(100-percent)))
            else
                duration:SetText("")
            end
        else
            duration:SetText("")
        end
    else
        duration:SetText("")
    end

    -- Stacks
    if aura.stacks.enable and aura.stacks.source ~= nil and aura.stacks.source ~= "" then
        if aura.runtime.source and aura.runtime.source["stacks"] then
            source = aura.runtime.sources[aura.runtime.source["stacks"]] or nil
        else
            source = aura.runtime.sources[aura.stacks.source] or nil
        end

        spell = self:GetSpell(source,"stacks")

        if spell and spell.stacks > 1 then
            stacks:SetText(self:GetText("stacks",aura.stacks.input,spell.stacks))
        else
            stacks:SetText("")
        end
    else
        stacks:SetText("")
    end

    -- Charges
    if aura.charges.enable and aura.charges.source ~= nil and aura.charges.source ~= "" then
        if aura.runtime.source and aura.runtime.source["charges"] then
            source = aura.runtime.sources[aura.runtime.source["charges"]] or nil
        else
            source = aura.runtime.sources[aura.charges.source] or nil
        end

        spell = self:GetSpell(source,"charges")

        if spell and spell.chargesRemaining > 0 then
            charges:SetText(self:GetText("charges",aura.charges.input,spell.chargesRemaining,spell.chargesMax))
        else
            charges:SetText("")
        end
    else
        charges:SetText("")
    end

    -- Text
    if aura.text.enable then
        if aura.text.source ~= nil and aura.text.source ~= "" and aura.text.input ~= "" then
            if aura.runtime.source and aura.runtime.source["text"] then
                source = aura.runtime.sources[aura.runtime.source["text"]] or nil
            else
                source = aura.runtime.sources[aura.text.source] or nil
            end

            spell = self:GetSpell(source,"duration")
            sLabel = self:GetSpell(source,"text")

            if sLabel then
                label = self:GetLabel(source,sLabel) or ""
            else
                label = ""
            end

            if spell then
                time,total,percent,current,_ = self:GetDuration(source,tick,spell)
                text:SetText(self:GetText("text",aura.text.input,current,total,percent,label))
            else
                text:SetText(self:GetText("text",aura.text.input,0,0,0,label))
            end
        else
            if aura.text.input ~= nil then
                text:SetText(aura.text.input)
            else
                text:SetText("")
            end
        end
    else
        text:SetText("")
    end
end

function LUI_Aura:PostTriggerCheck(setting,groupId,auraId)
    if not setting or not groupId or not auraId then
        return false
    end

    local icon = self.tWndAuras[groupId][auraId]
    local aura = self.config.groups[groupId].runtime.auras[auraId]
    local overlay = icon:FindChild("overlay")
    local text = icon:FindChild("text")
    local duration = icon:FindChild("duration")
    local stacks = icon:FindChild("stacks")
    local charges = icon:FindChild("charges")
    local bar = icon:FindChild("bar")

    for triggerId=1,#setting.triggers do
        local trigger = setting.triggers[triggerId]

        if trigger.enable == true and trigger.triggerType then
            local isGroup = trigger.triggerType == "Group"

            if trigger.runtime.checked then
                -- Check for Sources
                if trigger.sources ~= nil then
                    for sType,tSource in pairs(trigger.sources) do
                        if tSource.source ~= nil and tSource.source ~= "" and self:IsBehaviorMatched(trigger,tSource.behavior,isGroup) == true then
                            if not aura.runtime.source then
                                aura.runtime.source = {}
                            end

                            aura.runtime.source[sType] = tSource.source
                        end
                    end
                end

                -- Check for Icon Effects
                if icon and trigger.icon and trigger.icon.enable then
                    if self:IsBehaviorMatched(trigger,trigger.icon.behavior,isGroup) == true then
                        aura.runtime.iconChanged = true
                        aura.runtime.iconShown = false

                        if not trigger.runtime.iconShown then
                            if trigger.icon.sprite and trigger.icon.sprite ~= "" then
                                icon:FindChild("icon"):SetSprite(trigger.icon.sprite or "")

                                if aura.overlay.enable == true and aura.overlay.shape == "Icon" then
                                    overlay:SetFullSprite(trigger.icon.sprite or "")
                                end
                            end

                            icon:FindChild("icon"):SetBGColor(ApolloColor.new(
                                trigger.icon.color and trigger.icon.color.r / 255 or aura.icon.color.r / 255,
                                trigger.icon.color and trigger.icon.color.g / 255 or aura.icon.color.g / 255,
                                trigger.icon.color and trigger.icon.color.b / 255 or aura.icon.color.b / 255,
                                trigger.icon.color and trigger.icon.color.a / 255 or aura.icon.color.a / 255
                            ))

                            trigger.runtime.iconShown = true
                        end
                    else
                        if trigger.runtime.iconShown then
                            trigger.runtime.iconShown = false
                        end
                    end
                end

                -- Check for Border Effect
                if icon and trigger.border and trigger.border.enable then
                    if self:IsBehaviorMatched(trigger,trigger.border.behavior,isGroup) == true then
                        aura.runtime.borderChanged = true
                        aura.runtime.borderShown = false

                        if not trigger.runtime.borderShown then
                            icon:FindChild("border"):SetSprite(trigger.border.sprite or "")
                            icon:FindChild("border"):SetAnchorOffsets(
                                trigger.border.inset,
                                trigger.border.inset,
                                trigger.border.inset >= 0 and -trigger.border.inset or math.abs(trigger.border.inset),
                                trigger.border.inset >= 0 and -trigger.border.inset or math.abs(trigger.border.inset)
                            )
                            icon:FindChild("border"):SetBGColor(ApolloColor.new(
                                trigger.border.color.r / 255,
                                trigger.border.color.g / 255,
                                trigger.border.color.b / 255,
                                trigger.border.color.a / 255
                            ))
                            icon:FindChild("border"):Show(true,true)
                            trigger.runtime.borderShown = true
                            aura.runtime.borderVisible = true
                        end
                    else
                        if trigger.runtime.borderShown then
                            trigger.runtime.borderShown = false
                        end
                    end
                end

                -- Check for Bar Effect
                if bar and trigger.bar and trigger.bar.enable then
                    if self:IsBehaviorMatched(trigger,trigger.bar.behavior,isGroup) == true then
                        aura.runtime.barChanged = true
                        aura.runtime.barShown = false
                        aura.runtime.barInvert = trigger.bar.invert

                        if not trigger.runtime.barShown then
                            self:UpdateProgressBar(bar,trigger,aura)
                            trigger.runtime.barShown = true
                        end
                    else
                        if trigger.runtime.barShown then
                            trigger.runtime.barShown = false
                        end
                    end
                end

                -- Check for Sound File
                if trigger.sound and trigger.sound.enable then
                    if self:IsBehaviorMatched(trigger,trigger.sound.behavior,isGroup) == true then
                        if not trigger.runtime.soundPlayed then
                            self:PlaySound(trigger.sound)
                            trigger.runtime.soundPlayed = true
                        end
                    else
                        trigger.runtime.soundPlayed = false
                    end
                end

                if isGroup == true then
                    self:PostTriggerCheck(trigger,groupId,auraId)
                end

                trigger.runtime.checked = nil
            else
                trigger.runtime.iconShown = false
                trigger.runtime.borderShown = false
                trigger.runtime.barShown = false
                trigger.runtime.soundPlayed = false
            end
        end
    end
end

function LUI_Aura:IsBehaviorMatched(trigger,effect,isGroup)
    if not trigger or not effect then
        return false
    end

    local behavior = trigger.runtime.state == "Ignore" and "Pass" or trigger.runtime.state

    if behavior == effect then
        return true
    else
        if isGroup == true then
            local count = trigger.runtime.triggerCount or 0
            local passed = trigger.runtime.triggerPassed or 0

            if effect == "Always" then
                return true
            elseif effect == "All" and passed == count then
                return true
            elseif effect == "Any" and passed > 0 then
                return true
            elseif effect == "None" and passed == 0 then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end

function LUI_Aura:UpdateProgressBar(bar,setting,aura)
    if not bar or not setting or not aura then
        return
    end

    local progress = bar:FindChild("progress")
    local direction = setting.bar.direction ~= nil and setting.bar.direction or aura.bar.direction
    local invert = aura.bar.invert
    local color_fill = setting.bar.color_fill or aura.bar.color_fill
    local color_empty = setting.bar.color_empty or aura.bar.color_empty
    local color_bg = setting.bar.color_bg or aura.bar.color_bg
    local color_border = setting.bar.color_border or aura.bar.color_border
    local sprite_fill = setting.bar.sprite_fill or aura.bar.sprite_fill
    local sprite_empty = setting.bar.sprite_empty or aura.bar.sprite_empty
    local sprite_bg = setting.bar.sprite_bg or aura.bar.sprite_bg
    local sprite_border = setting.bar.sprite_border or aura.bar.sprite_border
    local border_inset = setting.bar.border_inset ~= nil and setting.bar.border_inset or aura.bar.border_inset
    local spacing = setting.bar.spacing or aura.bar.spacing

    if setting.bar.invert ~= nil then
        invert = setting.bar.invert
    end

    progress:SetStyleEx("Clockwise", (
        (direction == "Clockwise" and invert == true) or
        (direction == "Invert" and invert == false)
    ))

    progress:SetStyleEx("BRtoLT", (
        (direction == "Up" and invert == true) or
        (direction == "Down" and invert == false) or
        (direction == "Left" and invert == true) or
        (direction == "Right" and invert == false)
    ))

    progress:SetStyleEx("VerticallyAligned", (
        direction == "Up" or direction == "Down")
    )

    progress:SetAnchorOffsets(
        spacing,
        spacing,
        spacing * -1,
        spacing * -1
    )

    if progress:IsStyleExOn("RadialBar") then
        progress:SetEmptySprite()
        progress:SetFillSprite()
        progress:SetFullSprite(sprite_fill)

        progress:SetBGColor(ApolloColor.new(
            color_fill.r / 255,
            color_fill.g / 255,
            color_fill.b / 255,
            color_fill.a / 255
        ))
    else
        progress:SetEmptySprite(sprite_empty)
        progress:SetFillSprite(sprite_fill)
        progress:SetFullSprite()

        progress:SetBGColor(ApolloColor.new(
            color_empty.r / 255,
            color_empty.g / 255,
            color_empty.b / 255,
            color_empty.a / 255
        ))

        progress:SetBarColor(ApolloColor.new(
            color_fill.r / 255,
            color_fill.g / 255,
            color_fill.b / 255,
            color_fill.a / 255
        ))
    end

    bar:SetSprite(sprite_bg)
    bar:SetBGColor(ApolloColor.new(
        color_bg.r / 255,
        color_bg.g / 255,
        color_bg.b / 255,
        color_bg.a / 255
    ))

    if sprite_border ~= "" then
        bar:FindChild("border"):SetSprite(sprite_border)
        bar:FindChild("border"):SetAnchorOffsets(
            border_inset,
            border_inset,
            border_inset >= 0 and -border_inset or math.abs(border_inset),
            border_inset >= 0 and -border_inset or math.abs(border_inset)
        )
        bar:FindChild("border"):SetBGColor(ApolloColor.new(
            color_border.r / 255,
            color_border.g / 255,
            color_border.b / 255,
            color_border.a / 255
        ))
        bar:FindChild("border"):Show(true,true)
    else
        bar:FindChild("border"):Show(false,true)
    end
end

-- #########################################################################################################################################
-- #########################################################################################################################################
-- #
-- # OTHER STUFF
-- #
-- #########################################################################################################################################
-- #########################################################################################################################################

function LUI_Aura:GetListType(list)
    if not list then
        return false
    end

    local count = 0
    local count_true = 0
    local count_false = 0

    for _,state in pairs(list) do
        count = count + 1

        if state == true then
            count_true = count_true + 1
        elseif state == false then
            count_false = count_false + 1
        end
    end

    if count > 0 then
        if count_true > 0 then
            return "white"
        else
            return "black"
        end
    else
        return false
    end
end

function LUI_Aura:ResetRuntime()
    self.cooldowns = nil
    self.casts = nil
    self.spells = nil
    self.stats = nil
    self.keybinds = nil
    self.amp = nil
    self.threat = nil
    self.units = nil
    self.trigger = nil

    for groupId=1,#self.config.groups do
        local group = self.config.groups[groupId]
        self.config.groups[groupId].runtime = {}

        for auraId=1,#group.auras do
            local aura = group.auras[auraId]
            self.config.groups[groupId].auras[auraId].runtime = {}

            for triggerId=1, #aura.triggers do
                local trigger = aura.triggers[triggerId]
                self.config.groups[groupId].auras[auraId].triggers[triggerId].runtime = {}

                if trigger.triggers then
                    for subTriggerId=1, #trigger.triggers do
                        self.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[subTriggerId].runtime = {}
                    end
                end
            end
        end
    end
end

function LUI_Aura:CheckCircumstances(skip)
    if not self.isBuild then
        return
    end

    self.unitPlayer = GameLib.GetPlayerUnit()

    if self.unitPlayer == nil then
        return false
    end

    self.classId = self.unitPlayer:GetClassId()
    self.InGroup = GroupLib.InGroup(self.unitPlayer:GetName())
    self.InRaid = GroupLib.InRaid(self.unitPlayer:GetName())
    self.InPvP = GameLib.IsPvpFlagged()
    self.InCombat = self.unitPlayer:IsInCombat()

    if not skip then
        self:LoadAbilities()
        self:OnTargetUnitChanged(GameLib.GetTargetUnit())
        self:OnAlternateTargetUnitChanged(self.unitPlayer:GetAlternateTarget())
    end

    for groupId=1, #self.config.groups do
        local runGroup = true

        if not self:CheckZone(self.config.groups[groupId]) then
            runGroup = false
        end

        if not self.config.groups[groupId].enable == true then
            runGroup = false
        end

        if not self.config.groups[groupId].runtime then
            self.config.groups[groupId].runtime = {}
        end

        if not self.config.groups[groupId].runtime.auras then
            runGroup = false
        end

        self.config.groups[groupId].runtime.run = runGroup

        if runGroup == true then
            for auraId=1, #self.config.groups[groupId].runtime.auras do
                local aura = self.config.groups[groupId].runtime.auras[auraId]
                local run = true

                if not self:CheckVisibility(aura) then
                    run = false
                end

                if not self:CheckZone(aura) then
                    run = false
                end

                if not self.config.groups[groupId].runtime.auras[auraId].runtime then
                    self.config.groups[groupId].runtime.auras[auraId].runtime = {}
                end

                self.config.groups[groupId].runtime.auras[auraId].runtime.run = run

                if run == true then
                    self:LoadTriggers(groupId,auraId)
                else
                    self:RemoveTriggers(groupId,auraId)
                end
            end
        else
            if self.config.groups[groupId].runtime.auras then
                for auraId=1, #self.config.groups[groupId].runtime.auras do
                    if not self.config.groups[groupId].runtime.auras[auraId].runtime then
                        self.config.groups[groupId].runtime.auras[auraId].runtime = {}
                    end

                    self.config.groups[groupId].runtime.auras[auraId].runtime.run = false
                    self:RemoveTriggers(groupId,auraId)
                end
            end
        end
    end

    self:CheckBuffs("Player", self.unitPlayer or nil)
    self:CheckBuffs("Target", self.unitTarget or nil)
    self:CheckBuffs("Focus", self.unitFocus or nil)
    self:CheckBuffs("ToT", self.unitToT or nil)

    return true
end

function LUI_Aura:CheckZone(aura)
    if not aura.zones or #aura.zones == 0 then
        return true
    end

    if not self.currZone then
        self:OnCheckMapZone()
        return false
    end

    for _,zone in pairs(aura.zones) do
        if type(zone.id) == "string" then
            for _,instance in pairs(self.zones[zone.id].subzones) do
                if self.currZone.continentId == instance.continentId and (instance.parentZoneId == 0 or self.currZone.parentZoneId == instance.parentZoneId) then
                    if type(instance.id) == "number" then
                        if instance.id == 0 then
                            return true
                        else
                            if instance.id == self.currZone.id then
                                return true
                            end
                        end
                    else
                        for _,id in pairs(instance.id) do
                            if id == self.currZone.id then
                                return true
                            end
                        end
                    end
                end
            end
        else
            if self.currZone.continentId == zone.continentId and (zone.parentZoneId == 0 or self.currZone.parentZoneId == zone.parentZoneId) then
                if type(zone.id) == "number" then
                    if zone.id == 0 then
                        return true
                    else
                        if zone.id == self.currZone.id then
                            return true
                        end
                    end
                else
                    for _,id in pairs(zone.id) do
                        if id == self.currZone.id then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

function LUI_Aura:OnCheckMapZone()
    local currZone = GameLib.GetCurrentZoneMap()

    if currZone then
        self.currZone = {
            strName = currZone.strName,
            continentId = currZone.continentId,
            parentZoneId = currZone.parentZoneId,
            id = currZone.id,
        }
        self:CheckCircumstances(true)
    else
        Apollo.CreateTimer("LUI_CheckZoneTimer", 5, false)
    end
end

function LUI_Aura:CheckVisibility(aura)
    if not aura.enable == true then
        return false
    end

    if not aura.locked then
        return false
    end

    if not aura.visibility["solo"] and not self.InGroup and not self.InRaid then
        return false
    end

    if not aura.visibility["raid"] and self.InRaid then
        return false
    end

    if not aura.visibility["group"] and self.InGroup and not self.InRaid then
        return false
    end

    if GameLib.IsPvpServer() == false and not aura.visibility["pvp"] and self.InPvP then
        return false
    end

    if not aura.visibility["combat"] and (not self.InCombat or self.InCombat == false) then
        return false
    end

    if not aura.visibility["infight"] and self.InCombat then
        return false
    end

    if not aura.actionsets[self.actionset] then
        return false
    end

    if aura.stances and aura.stances[self.stance:GetName()] ~= nil and not aura.stances[self.stance:GetName()] then
        return false
    end

    return true
end

function LUI_Aura:CheckDisposition(aura)
    if not aura.targets then
        return true
    end

    if aura.targets["hostile"] and self.TargetDisposition == 0 then
        return true
    end

    if aura.targets["neutral"] and self.TargetDisposition == 1 then
        return true
    end

    if aura.targets["friendly"] and self.TargetDisposition == 2 then
        return true
    end

    if aura.targets["boss"] and self.TargetDisposition == 0 and self.TargetRank >= 5 and self.TargetDifficulty >= 6 then
        return true
    end

    return false
end

function LUI_Aura:IsOperatorSatisfied(value, operator, compValue)
    if not operator then
        return false
    end

    local v1 = value or 0
    local v2 = compValue or 0

    if operator == "==" then
        return v1 == v2
    elseif operator == "!=" then
        return v1 ~= v2
    elseif operator == ">" then
        return v1 > v2
    elseif operator == "<" then
        return v1 < v2
    elseif operator == ">=" then
        return v1 >= v2
    elseif operator == "<=" then
        return v1 <= v2
    else
        return false
    end
end

function LUI_Aura:GetSpellCooldown(spell)
    local charges = spell:GetAbilityCharges()
    if charges and charges.nChargesMax > 0 then
        return (charges.fRechargePercentRemaining * charges.fRechargeTime) or 0, charges.fRechargeTime or 0, charges.nChargesRemaining or 0, charges.nChargesMax or 0
    else
        return spell:GetCooldownRemaining() or 0, spell:GetCooldownTime() or 0, 0, 0
    end
end

function LUI_Aura:GroupConfigMode(groupId)
    if not groupId then
        return
    end

    if not self.tWndGroups[groupId] then
        return
    end

    local group = self.config.groups[groupId]
    local spacingX = group.dynamic.spacingX or 3
    local spacingY = group.dynamic.spacingY or 3
    local rows = group.dynamic.rows
    local cols = group.dynamic.columns
    local count = 0
    local max = (rows * cols) - 1
    local currRow = 0
    local currCol = 0

    for k,v in ipairs(self:GetSortedAuras(groupId,true)) do
        local aura = group.runtime.auras[v.id]
        local auraId = v.id

        if count <= max then
            local icon = self.tWndAuras[groupId][auraId]
            local width = aura.icon.width
            local height = aura.icon.height
            local posX = group.icon.posX
            local posY = group.icon.posY

            if currCol == cols then
                currCol = 0
                currRow = currRow + 1
            end

            if aura.icon.enable == false and aura.bar.enable == true then
                height = aura.bar.height
            end

            -- Calculating Spacing
            if group.dynamic.growth == "Left" then
                posX = posX - ((width + spacingX) * currRow)
            elseif group.dynamic.growth == "Right" then
                posX = posX + ((width + spacingX) * currRow)
            elseif group.dynamic.growth == "Up" then
                posY = posY - ((height + spacingY) * currRow)
            elseif group.dynamic.growth == "Down" then
                posY = posY + ((height + spacingY) * currRow)
            end

            -- Positioning  Icon
            if group.dynamic.direction == "Left" then
                icon:SetAnchorOffsets(
                    posX - width - (width * currCol) - (spacingX * currCol),
                    posY,
                    posX - (width * currCol) - (spacingX * currCol),
                    posY + height
                )
            elseif group.dynamic.direction == "Right" then
                icon:SetAnchorOffsets(
                    posX + (width * currCol) + (spacingX * currCol),
                    posY,
                    posX + width + (width * currCol) + (spacingX * currCol),
                    posY + height
                )
            elseif group.dynamic.direction == "Up" then
                icon:SetAnchorOffsets(
                    posX,
                    posY - height - (height * currCol) - (spacingY * currCol),
                    posX + width,
                    posY - (height * currCol) - (spacingY * currCol)
                )
            elseif group.dynamic.direction == "Down" then
                icon:SetAnchorOffsets(
                    posX,
                    posY + (height * currCol) + (spacingY * currCol),
                    posX + width,
                    posY + height + (height * currCol) + (spacingY * currCol)
                )
            end

            self:AuraConfigMode(groupId,auraId)
            count = count + 1
            currCol = currCol + 1
        else
            if aura.runtime.show == true then
                aura.runtime.show = false
                aura.runtime.isShown = false
                self:HideAura(groupId,auraId)
            end
        end
    end

    if group.dynamic.direction == "Left" then
        self.tWndGroups[groupId]:SetAnchorOffsets(
            group.icon.posX + 10,
            group.icon.posY,
            group.icon.posX + 10 + 60,
            group.icon.posY + 60
        )
    elseif group.dynamic.direction == "Right" then
        self.tWndGroups[groupId]:SetAnchorOffsets(
            group.icon.posX - 10 - 60,
            group.icon.posY,
            group.icon.posX - 10,
            group.icon.posY + 60
        )
    elseif group.dynamic.direction == "Up" then
        self.tWndGroups[groupId]:SetAnchorOffsets(
            group.icon.posX,
            group.icon.posY + 10,
            group.icon.posX + 60,
            group.icon.posY + 10 + 60
        )
    elseif group.dynamic.direction == "Down" then
        self.tWndGroups[groupId]:SetAnchorOffsets(
            group.icon.posX,
            group.icon.posY - 10 - 60,
            group.icon.posX + 60,
            group.icon.posY - 10
        )
    end

    self.tWndGroups[groupId]:SetData(groupId)
    self.tWndGroups[groupId]:Show(true,true)
end

function LUI_Aura:AuraConfigMode(groupId,auraId)
    local aura = self.config.groups[groupId].runtime.auras[auraId]
    local icon = self.tWndAuras[groupId][auraId]

    local duration = icon:FindChild("duration")
    local border = icon:FindChild("border")
    local overlay = icon:FindChild("overlay")
    local stacks = icon:FindChild("stacks")
    local charges = icon:FindChild("charges")
    local text = icon:FindChild("text")
    local bar = icon:FindChild("bar")
    local tick = Apollo.GetTickCount()
    local createAnimation = false

    if not aura.runtime.config or (tick - aura.runtime.config) > 15000 then
        aura.runtime.config = Apollo.GetTickCount()
        createAnimation = true
    end

    local time = 15000 - (tick - aura.runtime.config)
    local total = 15000
    local percent = (time * 100000) / total
    local stackCount = 8
    local chargesRemaining = 2
    local chargesMax = 4

    -- Border
    if aura.border and aura.border.enable == true and aura.border.sprite ~= "" and aura.runtime.borderShown == false then
        border:SetSprite(aura.border.sprite or "")
        border:SetAnchorOffsets(
            aura.border.inset,
            aura.border.inset,
            aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset),
            aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset)
        )
        border:SetBGColor(ApolloColor.new(
            aura.border.color.r / 255,
            aura.border.color.g / 255,
            aura.border.color.b / 255,
            aura.border.color.a / 255
        ))
        border:Show(true,true)
        aura.runtime.borderShown = true
    end

    -- Overlay
    if aura.overlay.enable == true then
        if createAnimation == true then
            self:CreateAnimation({
                wnd = overlay,
                groupId = groupId,
                auraId = auraId,
                id = "overlay",
                time = Apollo.GetTickCount(),
                duration = total,
                invert = aura.overlay.invert
            })
        end
        overlay:Show(true,true)
    else
        overlay:Show(false,true)
        self:RemoveAnimation({
            wnd = overlay,
            groupId = groupId,
            auraId = auraId,
            id = "overlay"
        })
    end

    -- Bar
    if aura.bar.enable == true then
        if createAnimation == true then
            self:CreateAnimation({
                wnd = bar:FindChild("progress"),
                groupId = groupId,
                auraId = auraId,
                id = "bar",
                time = Apollo.GetTickCount(),
                duration = total,
                invert = aura.bar.invert
            })
        end
        bar:Show(true,true)
    else
        bar:Show(false,true)
        self:RemoveAnimation({
            wnd = bar:FindChild("progress"),
            groupId = groupId,
            auraId = auraId,
            id = "bar"
        })
    end

    -- Duration
    if aura.duration.enable == true then
        duration:SetText(self:GetText("duration",aura.duration.input,(time / 1000),(total / 1000),(math.ceil((time * 100) / total))))
    else
        duration:SetText("")
    end

    -- Stacks
    if aura.stacks.enable == true then
        stacks:SetText(self:GetText("stacks",aura.stacks.input,stackCount))
    else
        stacks:SetText("")
    end

    -- Charges
    if aura.charges.enable == true then
        charges:SetText(self:GetText("charges",aura.charges.input,chargesRemaining,chargesMax))
    else
        charges:SetText("")
    end

    -- Text
    if aura.text.enable == true then
        text:SetText(aura.text.input)
    else
        text:SetText("")
    end

    if not aura.runtime.show == true then
        aura.runtime.show = true
        aura.runtime.isShown = true
        icon:Show(true,true)
    end
end

function LUI_Aura:CreateAnimationSlow(tAnimation)
    if not tAnimation.wnd then
        return
    end

    if tAnimation.percent <= 0 then
        tAnimation.percent = 0.01
    elseif tAnimation.percent >= 100 then
        tAnimation.percent = 99.999
    end

    if tAnimation.invert ~= nil and tAnimation.invert == true then
        tAnimation.percent = 100 - tAnimation.percent
    end

    tAnimation.wnd:SetProgress(tAnimation.percent)
end

function LUI_Aura:CreateAnimation(tAnimation)
    if not self.animations then
        self.animations = {}
    end

    if not self.animations[tAnimation.groupId] then
        self.animations[tAnimation.groupId] = {}
    end

    if not self.animations[tAnimation.groupId][tAnimation.auraId] then
        self.animations[tAnimation.groupId][tAnimation.auraId] = {}
    end

    if not self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id] then
        self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id] = tAnimation
    else
        if self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id].time ~= nil and self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id].time ~= tAnimation.time then
            self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id] = tAnimation
        end
    end
end

function LUI_Aura:RemoveAnimation(tAnimation,auraId,id)
    if type(tAnimation) == "table" then
        if not tAnimation or not tAnimation.groupId or not tAnimation.auraId or not tAnimation.id then
            return
        end

        if self.animations and self.animations[tAnimation.groupId] and self.animations[tAnimation.groupId][tAnimation.auraId] then
            if self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id] and self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id].wnd and not self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id].settings then
                --self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id].wnd:SetProgress(0)
            end

            self.animations[tAnimation.groupId][tAnimation.auraId][tAnimation.id] = nil
        end
    else
        local groupId = tAnimation

        if groupId then
            if auraId then
                if id then
                    if self.animations and self.animations[groupId] and self.animations[groupId][auraId] then
                        if self.animations[groupId][auraId][id] and self.animations[groupId][auraId][id].wnd and not self.animations[groupId][auraId][id].settings then
                            --self.animations[groupId][auraId][id].wnd:SetProgress(0)
                        end

                        self.animations[groupId][auraId][id] = nil
                    end
                else
                    if self.animations and self.animations[groupId] and self.animations[groupId][auraId] then
                        for id,animation in pairs(self.animations[groupId][auraId]) do
                            if animation and animation.wnd and not animation.settings then
                                --animation.wnd:SetProgress(0)
                            end
                        end

                        self.animations[groupId][auraId] = nil
                    end
                end
            else
                if self.animations and self.animations[groupId] then
                    for auraId,aura in pairs(self.animations[groupId]) do
                        for id,animation in pairs(aura) do
                            if animation and animation.wnd and not animation.settings then
                                --animation.wnd:SetProgress(0)
                            end
                        end
                    end

                    self.animations[groupId] = nil
                end
            end
        end
    end
end

function LUI_Aura:PlaySound(sound)
    if self.bVolumeReset == nil or self.bVolumeReset == true then
        self.nVolumeMaster = Apollo.GetConsoleVariable("sound.volumeMaster")
        self.nVolumeMusic = Apollo.GetConsoleVariable("sound.volumeMusic")
        self.nVolumeVoice = Apollo.GetConsoleVariable("sound.volumeUI")
        self.nVolumeSfx = Apollo.GetConsoleVariable("sound.volumeSfx")
        self.nVolumeAmbient = Apollo.GetConsoleVariable("sound.volumeAmbient")
        self.nVolumeVoice = Apollo.GetConsoleVariable("sound.volumeVoice")
        self.bVolumeReset = false
    end

    if sound.force == true then
        Apollo.SetConsoleVariable("sound.volumeMaster", sound.volume or 0.5)
        Apollo.SetConsoleVariable("sound.volumeUI", sound.volume or 0.5)
        Apollo.SetConsoleVariable("sound.volumeMusic", 0)
        Apollo.SetConsoleVariable("sound.volumeSfx", 0)
        Apollo.SetConsoleVariable("sound.volumeAmbient", 0)
        Apollo.SetConsoleVariable("sound.volumeVoice", 0)
    else
        Apollo.SetConsoleVariable("sound.volumeUI", sound.volume)
    end

    if type(sound.file) == "string" then
        Sound.PlayFile(sound.file)
    else
        Sound.Play(sound.file)
    end

    if self.nVolumeTimer == nil then
        self.nVolumeTimer = ApolloTimer.Create(5, false, "RestoreVolumeTimer", self)
        self.nVolumeTimer:Start()
    else
        self.nVolumeTimer:Stop()
        self.nVolumeTimer:Start()
    end
end

-- #########################################################################################################################################
-- #########################################################################################################################################
-- #
-- # HELPER FUNCTIONS
-- #
-- #########################################################################################################################################
-- #########################################################################################################################################

function LUI_Aura:HelperFormatBigNumber(nArg)
    local strResult
    if nArg < 1000 then
        strResult = tostring(nArg)
    elseif nArg < 1000000 then
        if math.floor(nArg%1000/100) == 0 then
            strResult = String_GetWeaselString("$1ck", math.floor(nArg / 1000))
        else
            strResult = String_GetWeaselString("$1f1k", nArg / 1000)
        end
    elseif nArg < 1000000000 then
        if math.floor(nArg%1000000/100000) == 0 then
            strResult = String_GetWeaselString("$1cm", math.floor(nArg / 1000000))
        else
            strResult = String_GetWeaselString("$1f1m", nArg / 1000000)
        end
    elseif nArg < 1000000000000 then
        if math.floor(nArg%1000000/100000) == 0 then
            strResult = String_GetWeaselString("$1cb", math.floor(nArg / 1000000))
        else
            strResult = String_GetWeaselString("$1f1b", nArg / 1000000)
        end
    else
        strResult = tostring(nArg)
    end
    return strResult
end

function LUI_Aura:OnKeyDown(iKey)
    if not self.keybinds then
        return
    end

    if not self.keys[iKey] then
        return
    end

    local nCode = self.keyMap[self.keys[iKey]]
    local eModifier = Apollo.GetMetaKeysDown()

    if not nCode then
        return
    end

    if not GameLib.IsKeyBindable(nCode, eModifier) then
        return
    end

    local input = {
        eDevice = GameLib.CodeEnumInputDevice.Keyboard,
        nCode = nCode,
        eModifier = eModifier,
    }

    local keyName = GameLib.GetInputKeyNameText(input)

    if self.keybinds[keyName] then
        self.keybinds[keyName] = Apollo.GetTickCount()
    end
end

function LUI_Aura:OnMouseButtonUp(eMouseButton)
    if not self.keybinds then
        return
    end

    if eMouseButton == GameLib.CodeEnumInputMouse.Left or eMouseButton == GameLib.CodeEnumInputMouse.Right then
         return
    end

    local eModifier = Apollo.GetMetaKeysDown()

    local input = {
        eDevice = GameLib.CodeEnumInputDevice.Mouse,
        nCode = eMouseButton,
        eModifier = eModifier,
    }

    local keyName = GameLib.GetInputKeyNameText(input)

    if self.keybinds[keyName] then
        self.keybinds[keyName] = Apollo.GetTickCount()
    end
end

function LUI_Aura:OnMouseWheel(wndHandler, wndControl, nDelta)
    if not self.keybinds then
        return
    end

    local nCode = GameLib.CodeEnumInputMouse.WheelUp
    local eModifier = Apollo.GetMetaKeysDown()

    if nDelta < 0 then
        nCode = GameLib.CodeEnumInputMouse.WheelDown
    end

    local input = {
        eDevice = GameLib.CodeEnumInputDevice.Mouse,
        nCode = nCode,
        eModifier = eModifier,
    }

    local keyName = GameLib.GetInputKeyNameText(input)

    if self.keybinds[keyName] then
        self.keybinds[keyName] = Apollo.GetTickCount()
    end
end

function LUI_Aura:CheckVolumeSetting()
    local mute = Apollo.GetConsoleVariable("sound.mute")

    if mute then
        Apollo.SetConsoleVariable("sound.mute", false)
        Apollo.SetConsoleVariable("sound.volumeMaster", 0)
        Apollo.SetConsoleVariable("sound.volumeUI", 0)
        Apollo.SetConsoleVariable("sound.volumeMusic", 0)
        Apollo.SetConsoleVariable("sound.volumeSfx", 0)
        Apollo.SetConsoleVariable("sound.volumeAmbient", 0)
        Apollo.SetConsoleVariable("sound.volumeVoice", 0)
    end
end

function LUI_Aura:RestoreVolumeTimer()
    Apollo.SetConsoleVariable("sound.volumeMaster", self.nVolumeMaster)
    Apollo.SetConsoleVariable("sound.volumeMusic", self.nVolumeMusic)
    Apollo.SetConsoleVariable("sound.volumeUI", self.nVolumeVoice)
    Apollo.SetConsoleVariable("sound.volumeSfx", self.nVolumeSfx)
    Apollo.SetConsoleVariable("sound.volumeAmbient", self.nVolumeAmbient)
    Apollo.SetConsoleVariable("sound.volumeVoice", self.nVolumeVoice)

    self.bVolumeReset = true
end

function LUI_Aura:OnGroupChange()
    if self.unitPlayer ~= nil then
        self.InGroup = GroupLib.InGroup(self.unitPlayer:GetName())
        self.InRaid = GroupLib.InRaid(self.unitPlayer:GetName())
        self:CheckCircumstances(true)
    end
end

function LUI_Aura:RepositionUnit(sUnit,unit)
    if not sUnit then
        return
    end

    for groupId=1,#self.config.groups do
        local group = self.config.groups[groupId]

        if group.dynamic.enable == true and group.icon.anchor ~= "Screen" then
            if group.icon.anchor == sUnit then
                if unit then
                    group.runtime.valid = true

                    if self.tWndGroups[groupId] then
                        self.tWndGroups[groupId]:SetUnit(unit)
                    end
                else
                    group.runtime.valid = false

                    if self.tWndGroups[groupId] then
                        self.tWndGroups[groupId]:SetUnit()
                    end
                end
            end
        else
            group.runtime.valid = true
        end

        if group.runtime and group.runtime.auras then
            for auraId=1, #group.runtime.auras do
                local aura = group.runtime.auras[auraId]

                if aura.icon.anchor == "Screen" then
                    aura.runtime.valid = true
                else
                    if aura.icon.anchor == sUnit then
                        if unit then
                            aura.runtime.valid = true

                            if self.tWndAuras[groupId][auraId] then
                                self.tWndAuras[groupId][auraId]:SetUnit(unit)
                            end
                        else
                            aura.runtime.valid = false

                            if self.tWndAuras[groupId][auraId] then
                                self.tWndAuras[groupId][auraId]:SetUnit()
                            end
                        end
                    end
                end
            end
        end
    end
end

function LUI_Aura:OnTargetUnitChanged(unit)
    if unit ~= nil and unit:GetHealth() ~= nil and unit:GetMaxHealth() > 0 then
        self.unitTarget = unit
        self.unitToT = unit:GetTarget()
        self.TargetRank = unit:GetRank()
        self.TargetDifficulty = unit:GetDifficulty()
        self:ResetThreat(true)

        if self.unitPlayer ~= nil then
            self.TargetDisposition = self.unitPlayer:GetDispositionTo(unit)
        end
    else
        self.unitTarget = nil
        self.unitToT = nil
    end

    self:RepositionUnit("Target",self.unitTarget)
    self:RepositionUnit("ToT",self.unitToT)

    self:CheckBuffs("Target", self.unitTarget or nil)
    self:CheckBuffs("ToT", self.unitToT or nil)
end

function LUI_Aura:OnAlternateTargetUnitChanged(unit)
    if unit ~= nil and unit:GetHealth() ~= nil and unit:GetMaxHealth() > 0 then
        self.unitFocus = unit
    else
        self.unitFocus = nil
    end

    self:RepositionUnit("Focus",self.unitFocus)
    self:CheckBuffs("Focus",self.unitFocus or nil)
end

function LUI_Aura:OnUnitPvpFlagsChanged(unit)
    if unit:IsThePlayer() and self.unitPlayer ~= nil then
        self.InPvP = GameLib.IsPvpFlagged()
        self:CheckCircumstances(true)
    end
end

function LUI_Aura:OnEnteredCombat(unit, InCombat)
    if unit:IsThePlayer() and self.unitPlayer ~= nil then
        self.InCombat = InCombat
        self:CheckCircumstances(true)
    end
end

function LUI_Aura:OnStanceChanged()
    self.stance = GameLib.GetCurrentClassInnateAbilitySpell()
    self:CheckCircumstances(true)
end

function LUI_Aura:GetAbilitiesList()
    if self.abilitiesList == nil then
        self.abilitiesList = AbilityBook.GetAbilitiesList()
    end
    return self.abilitiesList
end

function LUI_Aura:LoadAbilities()
    self.abilities = {}
    self.actionset = AbilityBook.GetCurrentSpec()
    self.stance = GameLib.GetCurrentClassInnateAbilitySpell()
    self.abilitiesList = AbilityBook.GetAbilitiesList()
    self.shortcuts = {}

    local currentLAS = ActionSetLib.GetCurrentActionSet()
    local i = 1

    if currentLAS and self.abilitiesList then
        local abilities = {unpack(currentLAS, 1, 8)}
        local abilityTiers = self:ToMap(abilities)

        for k, v in ipairs(self.abilitiesList) do
            if abilityTiers[v.nId] then
                if self.spellslinger[v.nId] ~= nil then
                    self.abilities[v.strName] = {}

                    for _,spellId in ipairs(self.spellslinger[v.nId][v.nCurrentTier]) do
                        table.insert(self.abilities[v.strName],GameLib.GetSpell(spellId))
                    end
                else
                    local tier = v.tTiers[v.nCurrentTier]
                    if tier then
                        local s = tier.splObject
                        self.abilities[v.strName] = s

                        if self.engineer[v.nId] ~= nil then
                            if self.bots[self.lang][v.strName] ~= nil and self.engineer[v.nId][v.nCurrentTier] ~= nil then
                                self.abilities[self.bots[self.lang][v.strName]] = GameLib.GetSpell(self.engineer[v.nId][v.nCurrentTier])
                            end
                        end
                    end
                end

                if not self.shortcuts[v.strName] then
                    self.shortcuts[v.strName] = GameLib.GetKeyBinding("LimitedActionSet"..abilityTiers[v.nId]) or ""
                end

                i = i + 1
            end
        end
    else
        self.AbilityBookUpdateTimer:Start()
    end
end

function LUI_Aura:OnAbilityBookChange()
    if not self.AbilityBookUpdateTimer then
        self.AbilityBookUpdateTimer = ApolloTimer.Create(1, false, "OnUpdateAbilityBook", self)
    end

    self.AbilityBookUpdateTimer:Start()
end

function LUI_Aura:OnUpdateAbilityBook()
    self:LoadAbilities()
    self:CheckCircumstances(true)
end

function LUI_Aura:OnCharacterCreated()
    self:LoadAbilities()
end

function LUI_Aura:OnGroupMove(wndHandler, wndControl)
    local nLeft, nTop, nRight, nBottom = wndControl:GetAnchorOffsets()
    local groupId = wndControl:GetData()
    local spacingX = 0
    local spacingY = 0

    if self.config.groups[groupId].dynamic.direction == "Left" then
        spacingX = -10
        spacingY = 0
    elseif self.config.groups[groupId].dynamic.direction == "Right" then
        spacingX = 70
        spacingY = 0
    elseif self.config.groups[groupId].dynamic.direction == "Up" then
        spacingX = 0
        spacingY = -10
    elseif self.config.groups[groupId].dynamic.direction == "Down" then
        spacingX = 0
        spacingY = 70
    end

    self.config.groups[groupId].icon.posX = nLeft + spacingX
    self.config.groups[groupId].icon.posY = nTop + spacingY
end

function LUI_Aura:OnAuraMove(wndHandler, wndControl)
    local nLeft, nTop, nRight, nBottom = wndControl:GetAnchorOffsets()

    local groupId = wndControl:GetData()[1]
    local auraId = wndControl:GetData()[2]

    if groupId and auraId then
        if not self.config.groups[groupId].auras[auraId].icon then
            self.config.groups[groupId].auras[auraId].icon = {}
        end

        if wndControl:GetName() == "LUIAuraFixed" then
            local width = self.config.groups[groupId].runtime.auras[auraId].icon.width or 0
            local height = self.config.groups[groupId].runtime.auras[auraId].icon.height or 0

            nLeft =    nLeft + (width/2)
            nTop = nTop + (height/2)
        end

        self.config.groups[groupId].auras[auraId].icon.posX = nLeft
        self.config.groups[groupId].auras[auraId].icon.posY = nTop

        if not self.config.groups[groupId].runtime.auras[auraId].icon then
            self.config.groups[groupId].runtime.auras[auraId].icon = {}
        end

        self.config.groups[groupId].runtime.auras[auraId].icon.posX = nLeft
        self.config.groups[groupId].runtime.auras[auraId].icon.posY = nTop

        if self.Settings.wndSettings then
            local wndAura = self.Settings.wndLastAuraSelected
            if wndAura ~= nil and wndAura:GetData()[1]:GetData() == groupId and wndAura:GetData()[2]:GetData() == auraId then
                self.Settings.wndSettings:FindChild("IconGroup"):FindChild("XPosText"):SetText(nLeft)
                self.Settings.wndSettings:FindChild("IconGroup"):FindChild("YPosText"):SetText(nTop)
            end
        end
    end
end

function LUI_Aura:ShowGroup(groupId)
    if not groupId then
        return
    end

    local group = self.config.groups[groupId]
    local spacingX = group.dynamic.spacingX or 3
    local spacingY = group.dynamic.spacingY or 3
    local rows = group.dynamic.rows
    local cols = group.dynamic.columns
    local count = 0
    local max = (rows * cols) - 1
    local currRow = 0
    local currCol = 0
    local auras = self:GetSortedAuras(groupId) or {}

    for i=1,#auras do
        local auraId = auras[i].id
        local aura = group.runtime.auras[auraId]

        if count <= max then
            local icon = self.tWndAuras[groupId][auraId]
            local width = aura.icon.width
            local height = aura.icon.height
            local posX = group.icon.posX
            local posY = group.icon.posY
            local offsets = {}

            if aura.icon.enable == false and aura.bar.enable == true then
                height = aura.bar.height
            end

            if currCol == cols then
                currCol = 0
                currRow = currRow + 1
            end

            -- Calculating Spacing
            if group.dynamic.growth == "Left" then
                posX = posX - ((width + spacingX) * currRow)
            elseif group.dynamic.growth == "Right" then
                posX = posX + ((width + spacingX) * currRow)
            elseif group.dynamic.growth == "Up" then
                posY = posY - ((height + spacingY) * currRow)
            elseif group.dynamic.growth == "Down" then
                posY = posY + ((height + spacingY) * currRow)
            end

            -- Positioning  Icon
            if group.dynamic.direction == "Left" then
                offsets = {
                    left = posX - width - (width * currCol) - (spacingX * currCol),
                    top = posY,
                    right = posX - (width * currCol) - (spacingX * currCol),
                    bottom = posY + height
                }
            elseif group.dynamic.direction == "Right" then
                offsets = {
                    left = posX + (width * currCol) + (spacingX * currCol),
                    top = posY,
                    right = posX + width + (width * currCol) + (spacingX * currCol),
                    bottom = posY + height
                }
            elseif group.dynamic.direction == "Up" then
                offsets = {
                    left = posX,
                    top = posY - height - (height * currCol) - (spacingY * currCol),
                    right = posX + width,
                    bottom = posY - (height * currCol) - (spacingY * currCol)
                }
            elseif group.dynamic.direction == "Down" then
                offsets = {
                    left = posX,
                    top = posY + (height * currCol) + (spacingY * currCol),
                    right = posX + width,
                    bottom = posY + height + (height * currCol) + (spacingY * currCol)
                }
            end

            if aura.runtime.isShown == nil or aura.runtime.isShown == false then
                aura.runtime.position = count
                aura.runtime.isShown = true
                aura.runtime.offsets = offsets
                self:ShowAura(groupId,auraId)
            else
                if aura.runtime.position ~= count then
                    aura.runtime.position = count

                    if tonumber(group.dynamic.transition) == 0 then
                        icon:SetAnchorOffsets(
                            offsets.left,
                            offsets.top,
                            offsets.right,
                            offsets.bottom
                        )
                    else
                        local left,top,right,bottom = icon:GetAnchorPoints()
                        local tLoc = WindowLocation.new({
                            fPoints = {left,top,right,bottom},
                            nOffsets = {offsets.left,offsets.top,offsets.right,offsets.bottom}
                        })

                        icon:TransitionMove(tLoc, group.dynamic.duration, tonumber(group.dynamic.transition))
                        aura.runtime.position = count
                    end
                end
            end

            count = count + 1
            currCol = currCol + 1
        else
            if aura.runtime.show == true then
                aura.runtime.show = false
                aura.runtime.isShown = false
                self:HideAura(groupId,auraId)
            end
        end
    end
end

function LUI_Aura:ShowAura(groupId,auraId)
    if self.tWndAuras[groupId][auraId] ~= nil then
        local aura = self.config.groups[groupId].runtime.auras[auraId]

        -- Reset Aura Position
        if aura.runtime.offsets ~= nil then
            self.tWndAuras[groupId][auraId]:SetAnchorOffsets(
                aura.runtime.offsets.left,
                aura.runtime.offsets.top,
                aura.runtime.offsets.right,
                aura.runtime.offsets.bottom
            )
        end

        if aura.animation["Start"].enable == true then
            self:CreateAnimation({
                wnd = self.tWndAuras[groupId][auraId],
                groupId = groupId,
                auraId = auraId,
                time = Apollo.GetTickCount(),
                id = "start",
                settings = self:Copy(aura.animation["Start"])
            })
        else
            self.tWndAuras[groupId][auraId]:Show(true,true)
        end
    end
end

function LUI_Aura:HideAura(groupId,auraId)
    if self.tWndAuras[groupId][auraId] ~= nil then
        local aura = self.config.groups[groupId].runtime.auras[auraId]

        if aura.animation["End"].enable == true then
            self:CreateAnimation({
                wnd = self.tWndAuras[groupId][auraId],
                groupId = groupId,
                auraId = auraId,
                time = Apollo.GetTickCount(),
                id = "end",
                settings = self:Copy(aura.animation["End"])
            })
        else
            self.tWndAuras[groupId][auraId]:Show(false,true)
            self.tWndAuras[groupId][auraId]:FindChild("overlay"):SetProgress(0)
            self.tWndAuras[groupId][auraId]:FindChild("progress"):SetProgress(0)
            self:RemoveAnimation(groupId,auraId)
        end
    end
end

function LUI_Aura:HideGroup(groupId)
    if self.tWndAuras[groupId] ~= nil then
        for auraId=1,#self.tWndAuras[groupId] do
            self.tWndAuras[groupId][auraId]:Show(false,true)
            self.tWndAuras[groupId][auraId]:Destroy()
        end
    end

    if self.tWndGroups[groupId] ~= nil then
        self.tWndGroups[groupId]:Show(false,true)
        self.tWndGroups[groupId]:Destroy()
    end
end

function LUI_Aura:HideAllAura()
    if self.tWndAuras ~= nil then
        for groupId=1,#self.tWndAuras do
            if self.tWndAuras[groupId] ~= nil then
                for auraId=1,#self.tWndAuras[groupId] do
                    self.tWndAuras[groupId][auraId]:Show(false,true)
                    self.tWndAuras[groupId][auraId]:Destroy()
                end
            end

            if self.tWndGroups[groupId] ~= nil then
                self.tWndGroups[groupId]:Show(false,true)
                self.tWndGroups[groupId]:Destroy()
            end
        end
    end
end

function LUI_Aura:GetSortedAuras(groupId,configMode)
    local group = self.config.groups[groupId]
    local func = nil
    local tSorted = {}

    for idx=1,#group.runtime.auras do
        local aura = group.runtime.auras[idx]

        if (aura.runtime and (aura.runtime.run == true and aura.runtime.show == true)) or (configMode and configMode == true) then
            table.insert(tSorted, {
                id = idx,
                priority = aura.dynamic.priority,
                duration = aura.runtime.duration or 0,
                tick = aura.runtime.tick or 0,
            })
        end
    end

    if group.dynamic.sort == "Newest" then
        table.sort(tSorted, function(a, b)
            if a.priority ~= b.priority then
                return a.priority > b.priority
            end

            if a.tick ~= b.tick then
                return a.tick > b.tick
            end

            if a.duration ~= b.duration then
                return a.duration > b.duration
            end

            return a.id < b.id
        end)
    elseif group.dynamic.sort == "Oldest" then
        table.sort(tSorted, function(a, b)
            if a.priority ~= b.priority then
                return a.priority > b.priority
            end

            if a.tick ~= b.tick then
                return a.tick < b.tick
            end

            if a.duration ~= b.duration then
                return a.duration > b.duration
            end

            return a.id < b.id
        end)
    elseif group.dynamic.sort == "Shortest" then
        table.sort(tSorted, function(a, b)
            if a.priority ~= b.priority then
                return a.priority > b.priority
            end

            if a.duration ~= b.duration then
                return a.duration < b.duration
            end

            --if a.tick ~= b.tick then
            --    return a.tick > b.tick
            --end

            return a.id < b.id
        end)
    elseif group.dynamic.sort == "Longest" then
        table.sort(tSorted, function(a, b)
            if a.priority ~= b.priority then
                return a.priority > b.priority
            end

            if a.duration ~= b.duration then
                return a.duration > b.duration
            end

            --if a.tick ~= b.tick then
                --return a.tick > b.tick
            --end

            return a.id < b.id
        end)
    end

    return tSorted
end

function LUI_Aura:OnRestore(eType, tSavedData)
    if tSavedData ~= nil and tSavedData ~= "" then
        if eType == GameLib.CodeEnumAddonSaveLevel.Character then
            self.config = tSavedData
        elseif eType == GameLib.CodeEnumAddonSaveLevel.General then
            if tSavedData.version ~= nil then
                self.version = tSavedData.version
            end
        end
    end
end

function LUI_Aura:CheckVersion()
    if self.version then
        if self.version < self.options.global.version then
            self.version = self.options.global.version
            self.Settings:ShowChangelog()
        end
    else
        self.version = self.options.global.version
        self.Settings:ShowChangelog()
    end
end

function LUI_Aura:LoadDefaults()
    local check = false

    if not self.version or self.version < 3 then
        check = true
    end

    -- Extend config with missing global defaults
    self.config = self:InsertDefaults(self.config, self:Copy(self.options.global))

    -- Check for bars (deprecated)
    if self.config.bars ~= nil then
        self.config.bars = self:CheckCompatibility(self.config.bars,"bars")
    end

    for groupId=1,#self.config.groups do
        local group = self.config.groups[groupId]

        if check == true then
            group = self:CheckCompatibility(group,"group")
        end

        -- Extend group with missing defaults
        self.config.groups[groupId] = self:InsertDefaults(group,self:Copy(self.options.group))

        for auraId=1, #group.auras do
            local aura = group.auras[auraId]

            if check == true then
                aura = self:CheckCompatibility(aura,"aura")
            end

            -- Extend aura with missing defaults
            self.config.groups[groupId].auras[auraId] = self:InsertDefaults(aura,self:Copy(self.options.aura))

            for triggerId=1, #aura.triggers do
                local trigger = aura.triggers[triggerId]

                if check == true then
                    trigger = self:CheckCompatibility(trigger,"trigger")
                end

                -- Extend trigger with missing defaults
                self.config.groups[groupId].auras[auraId].triggers[triggerId] = self:InsertDefaults(trigger, self:Copy(self.options.trigger))

                if trigger.triggers ~= nil then
                    for childId=1, #trigger.triggers do
                        local child = trigger.triggers[childId]

                        if check == true then
                            child = self:CheckCompatibility(child,"trigger")
                        end

                        -- Extend trigger child with missing defaults
                        self.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId] = self:InsertDefaults(child, self:Copy(self.options.trigger))
                    end
                end
            end
        end
    end
end

function LUI_Aura:CheckCompatibility(setting,eType)
    if not setting or not eType then
        return
    end

    if eType == "aura" then

        if type(setting.icon) == "string" then
            local sprite = setting.icon
            setting.icon = {}

            setting.icon.sprite = sprite

            if setting.show ~= nil then
                setting.icon.enable = setting.show
                setting.show = nil
            end

            if setting.posX ~= nil then
                setting.icon.posX = setting.posX
                setting.icon.posY = setting.posY
                setting.posX = nil
                setting.posY = nil
            end

            if setting.color ~= nil then
                setting.icon.color = setting.color
                setting.color = nil
            end

            if setting.scale ~= nil then
                setting.icon.width = math.ceil(46 * setting.scale)
                setting.icon.height = math.ceil(46 * setting.scale)
                setting.scale = nil
            end
        end

        if not setting.overlay then
            setting.overlay = {}

            if setting.duration ~= nil then
                if setting.duration.overlay ~= nil then
                    setting.overlay.enable = setting.duration.overlay
                    setting.duration.overlay = nil
                end

                if setting.duration.overlayType ~= nil then
                    setting.overlay.animation = setting.duration.overlayType
                    setting.duration.overlayType = nil
                end

                if setting.duration.overlayShape ~= nil then
                    setting.overlay.shape = setting.duration.overlayShape
                    setting.duration.overlayShape = nil
                end

                if setting.duration.overlayDirection ~= nil then
                    setting.overlay.direction = setting.duration.overlayDirection
                    setting.duration.overlayDirection = nil
                end

                if setting.duration.overlayColor ~= nil then
                    setting.overlay.color = setting.duration.overlayColor
                    setting.duration.overlayColor = nil
                end
            end
        end

        if setting.duration and setting.duration.input and setting.duration.input == "{value}" then
            setting.duration.input = "{v}"
        end

        if setting.stacks and setting.stacks.input and setting.stacks.input == "{value}" then
            setting.stacks.input = "{v}"
        end

        if setting.charges and setting.charges.input and setting.charges.input == "{value}" then
            setting.charges.input = "{v}"
        end

        if setting.text and setting.text.input and setting.text.input == "{value}" then
            setting.text.input = "{v}"
        end

    elseif eType == "trigger" then

        if setting.triggerType == "Health" or setting.triggerType == "Resource" then

            if setting.valueType then
                setting.triggerType = "Attribute"
                setting.attributes = {
                    [setting.valueType] = {
                        enable = true,
                        operator = setting.operator or ">",
                        value = setting.value or 0,
                        percent = setting.percent or false,
                    }
                }
                setting.valueType = nil
                setting.operator = nil
                setting.value = nil
                setting.percent = nil
            end

        elseif setting.triggerType == "Interrupt Armor" then

            setting.attributes = {
                [setting.triggerType] = {
                    enable = true,
                    operator = setting.operator or ">",
                    value = setting.value or 0,
                    percent = setting.percent or false,
                }
            }
            setting.triggerType = "Attribute"
            setting.valueType = nil
            setting.operator = nil
            setting.value = nil
            setting.percent = nil

        end

    elseif eType == "bars" then

        self:Print("Update from very old version detected: Bars had to be removed. Please restore them under Global Settings.")
        setting = nil

    end

    return setting
end

function LUI_Aura:HelperConvertSource(aura,source)
    if not aura or not source or not source.sType then
        return ""
    end

    if #aura.triggers then
        for triggerId,trigger in ipairs(aura.triggers) do
            if trigger.triggerType == source.sType then
                if source.sType == "Gadget" or source.sType == "Innate" then
                    return tostring(triggerId)
                end

                if source.sType == "Keybind" and trigger.keybind.text == source.sName then
                    return tostring(triggerId)
                end

                if (source.sType == "Ability" or source.sType == "Cooldown") and trigger.spellName == source.sName then
                    return tostring(triggerId)
                end

                if (source.sType == "Buff" or source.sType == "Debuff" or source.sType == "AMP Cooldown") and trigger.spellName == source.sName and trigger.unit == source.sUnit then
                    return tostring(triggerId)
                end

                if source.sType == "Health" or source.sType == "Resource" and trigger.valueType == source.sValueType and trigger.unit == source.sUnit then
                    return tostring(triggerId)
                end

                if source.sType == "Interrupt Armor" and trigger.unit == source.sUnit then
                    return tostring(triggerId)
                end

                if source.sType == "Attribute" and trigger.unit == source.sUnit then
                    if trigger.attributes and #trigger.attributes then
                        for attribute,stat in pairs(trigger.attributes) do
                            if attribute == source.sValueType then
                                return tostring(triggerId).."-"..attribute
                            end
                        end
                    end
                end
            end

            if trigger.triggers and #trigger.triggers then
                for childId,child in ipairs(trigger.triggers) do
                    if child.triggerType == source.sType then
                        if source.sType == "Gadget" or source.sType == "Innate" then
                            return tostring(triggerId).."-"..tostring(childId)
                        end

                        if source.sType == "Keybind" and child.keybind.text == source.sName then
                            return tostring(triggerId).."-"..tostring(childId)
                        end

                        if (source.sType == "Ability" or source.sType == "Cooldown") and child.spellName == source.sName then
                            return tostring(triggerId).."-"..tostring(childId)
                        end

                        if (source.sType == "Buff" or source.sType == "Debuff" or source.sType == "AMP Cooldown") and child.spellName == source.sName and child.unit == source.sUnit then
                            return tostring(triggerId).."-"..tostring(childId)
                        end

                        if source.sType == "Health" or source.sType == "Resource" and child.valueType == source.sValueType and child.unit == source.sUnit then
                            return tostring(triggerId).."-"..tostring(childId)
                        end

                        if source.sType == "Interrupt Armor" and child.unit == source.sUnit then
                            return tostring(triggerId).."-"..tostring(childId)
                        end

                        if source.sType == "Attribute" and child.unit == source.sUnit then
                            if child.attributes and #child.attributes then
                                for attribute,stat in pairs(child.attributes) do
                                    if attribute == source.sValueType then
                                        return tostring(triggerId).."-"..tostring(childId).."-"..attribute
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function LUI_Aura:Merge(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            self:Merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

function LUI_Aura:StripTable(t)
    for k,v in pairs(t) do
        if t[k] ~= nil then
            if type(v) == 'table' then
                if k == "runtime" then
                    t[k] = nil
                else
                    if next(t[k]) == nil then
                        t[k] = nil
                    else
                        t[k] = self:StripTable(t[k])
                    end
                end
            else
                if t[k] == "" then
                    t[k] = nil
                end
            end
        end
    end

    return t
end

function LUI_Aura:RemoveDefaults(t,defaults)
    for k,v in pairs(defaults) do
        if t[k] ~= nil then
            if type(v) == 'table' then
                t[k] = self:RemoveDefaults(t[k],v)
            else
                if k ~= "r" and k ~= "g" and k ~= "b" and k ~= "a" then
                    if t[k] == v then
                        t[k] = nil
                    end
                end
            end
        end
    end

    return t
end

function LUI_Aura:InsertDefaults(t,defaults)
    for k,v in pairs(defaults) do
        if t[k] == nil then
            if type(v) == 'table' then
                t[k] = self:Copy(v)
            else
                t[k] = v
            end
        else
            if type(v) == 'table' then
                t[k] = self:InsertDefaults(t[k],v)
            end
        end
    end

    return t
end

function LUI_Aura:Copy(t)
    local o = {}

    for k,v in pairs(t) do
        if type(v) == 'table' then
            o[k] = self:Copy(v)
        else
            o[k] = v
        end
    end

    return o
end

function LUI_Aura:Extend(...)
    local args = {...}
    for i = 2, #args do
        for key, value in pairs(args[i]) do
            args[1][key] = value
        end
    end
    return args[1]
end

function LUI_Aura:Count(t)
    local count = 0

      for _ in pairs(t) do
          count = count + 1
      end

      return count
end

function LUI_Aura:Sort(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function LUI_Aura:Round(val, decimal)
    local exp = decimal and 10^decimal or 1
    return math.ceil(val * exp - 0.5) / exp
end

function LUI_Aura:ToMap(list)
    local map = {}
    for key, value in ipairs(list) do
        map[value] = key
    end
    return map
end

function LUI_Aura:OnSave(eType)
    if eType == GameLib.CodeEnumAddonSaveLevel.Character then
        self:ResetRuntime()
        return self.config
    elseif eType == GameLib.CodeEnumAddonSaveLevel.General then
        return {
            version = self.version
        }
    end
end

function LUI_Aura:OnConfigure()
    self.Settings:OnToggleMenu()
end

function LUI_Aura:OnToggleMenu()
    self.Settings:OnToggleMenu()
end

function LUI_Aura:OnSlashCommand()
    self.Settings:OnToggleMenu()
end

function LUI_Aura:OnInterfaceMenuListHasLoaded()
    Event_FireGenericEvent("InterfaceMenuList_NewAddOn","LUI Aura", {"ToggleMenu", "", "CRB_Basekit:kitIcon_Holo_HazardObserver" })
end

function LUI_Aura:GetLocale()
    local strCancel = Apollo.GetString(1)

    if strCancel == "Abbrechen" then
        self.lang = "de"
    elseif strCancel == "Annuler" then
        self.lang = "fr"
    else
        self.lang = "en"
    end
end

function LUI_Aura:LoadSpellIcons()
    if not self.icons then
        return
    end

    local abilities = self:GetAbilitiesList()

    if abilities ~= nil then
        for _, ability in pairs(abilities) do
            local icon = ability.tTiers[1].splObject:GetIcon()

            if icon and icon ~= "" and not self.icons[ability.strName] then
                self.icons[ability.strName] = icon
            end
        end
    end

    for i = 99999, 1, -1 do
        local spell = GameLib.GetSpell(i)

        if spell then
            local sName = spell:GetName() or ""
            local sIcon = spell:GetIcon() or ""
            local nDuration = spell:GetCastTime() or 0
            local tChannel = spell:GetChannelData() or nil

            if not self.icons[sName] and sName ~= "" and sIcon ~= "" and (nDuration > 0 or tChannel ~= nil) then
                self.icons[sName] = sIcon
            end
        end
    end
end

function LUI_Aura:LoadFunctions()
    self.functions = {
        -- Units
        ["Player"] = function() return self.unitPlayer or nil end,
        ["Target"] = function() return self.unitTarget or nil end,
        ["Focus"] = function() return self.unitFocus or nil end,
        ["ToT"] = function() return self.unitToT or nil end,
        -- Basic Stuff
        ["Valid"] = function(unit) return unit and true or false end,
        ["Name"] = function(unit) return (unit and unit:IsValid()) and unit:GetName() or "" end,
        ["Level"] = function(unit) return (unit and unit:IsValid()) and unit:GetLevel() or false end,
        ["Class"] = function(unit) return (unit and unit:IsValid() and unit:IsACharacter() == true) and unit:GetClassId() or false end,
        ["Hostility"] = function(unit) return (unit and unit:IsValid() and self.unitPlayer) and unit:GetDispositionTo(self.unitPlayer) or false end,
        ["Rank"] = function(unit) return (unit and unit:IsValid() and unit:IsACharacter() == false) and unit:GetRank() or false end,
        ["Difficulty"] = function(unit) return (unit and unit:IsValid() and unit:IsACharacter() == false) and unit:GetEliteness() or false end,
        -- Cast
        ["CastName"] = function(unit) return (unit and unit:IsValid()) and unit:GetCastName() or false end,
        ["CastElapsed"] = function(unit) return (unit and unit:IsValid()) and unit:GetCastElapsed() or 0 end,
        ["CastDuration"] = function(unit) return (unit and unit:IsValid()) and unit:GetCastDuration() or 0 end,
        -- Stats (Basic)
        ["Health"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetHealth() or 0, max = unit:GetMaxHealth() or 0} or false end,
        ["Shield"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetShieldCapacity() or 0, max = unit:GetShieldCapacityMax() or 0} or false end,
        ["Absorb"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetAbsorptionValue() or 0, max = unit:GetAbsorptionMax() or 0} or false end,
        ["Focus"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetFocus() or 0, max = unit:GetMaxFocus() or 0} or false end,
        ["Class Resource"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetResource(resourceIds[unit:GetClassId()] or 0) or 0, max = unit:GetMaxResource(resourceIds[unit:GetClassId()] or 0) or 0} or false end,
        ["Interrupt Armor"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetInterruptArmorValue() or 0, max = unit:GetInterruptArmorMax() or 0} or false end,
        ["Assault Power"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetAssaultPower() or 0} or false end,
        ["Support Power"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetSupportPower() or 0} or false end,
        -- Stats (Offensive)
        ["Strikethrough"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetStrikethroughChance().nAmount or 0} or false end,
        ["Critical Hit Chance"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetCritChance().nAmount or 0} or false end,
        ["Critical Hit Severity"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetCritSeverity().nAmount or 0} or false end,
        ["Multi-Hit Chance"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetMultiHitChance().nAmount or 0} or false end,
        ["Multi-Hit Severity"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetMultiHitAmount().nAmount or 0} or false end,
        ["Vigor"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetVigor().nAmount or 0} or false end,
        ["Armor Pierce"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetArmorPierce().nAmount or 0} or false end,
        -- Stats (Defensive)
        ["Physical Mitigation"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetPhysicalMitigation().nAmount or 0} or false end,
        ["Technology Mitigation"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetTechMitigation().nAmount or 0} or false end,
        ["Magic Mitigation"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetMagicMitigation().nAmount or 0} or false end,
        ["Glance Chance"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetGlanceChance().nAmount or 0} or false end,
        ["Glance Mitigation"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetGlanceAmount().nAmount or 0} or false end,
        ["Critical Mitigation"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetCriticalMitigation().nAmount or 0} or false end,
        ["Deflect Chance"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetDeflectChance().nAmount or 0} or false end,
        ["Deflect Critical Hit Chance"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetDeflectCritChance().nAmount or 0} or false end,
        -- Stats (Utility)
        ["Lifesteal"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetLifesteal().nAmount or 0} or false end,
        ["Focus Pool"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetMaxFocus() or 0} or false end,
        ["Focus Recovery Rate"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetFocusRegenInCombat().nAmount or 0} or false end,
        ["Reflect Chance"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetDamageReflectChance().nAmount or 0} or false end,
        ["Reflect Damage"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetDamageReflectAmount().nAmount or 0} or false end,
        ["Intensity"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetIntensity().nAmount or 0} or false end,
        -- Stats (PvP)
        ["PvP Damage"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetPvPDamageI().nAmount or 0} or false end,
        ["PvP Healing"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetPvPHealingI().nAmount or 0} or false end,
        ["PvP Defense"] = function(unit) return (unit and unit:IsValid()) and {current = unit:GetPvPDefenseI().nAmount or 0} or false end,
        -- Circumstances
        ["IsMounted"] = function(unit) return (unit and unit:IsValid()) and unit:IsValid() and unit:IsMounted() or false end,
        ["IsInCombat"] = function(unit) return (unit and unit:IsValid()) and unit:IsValid() and unit:IsInCombat() or false end,
        ["IsInYourGroup"] = function(unit) return (unit and unit:IsValid()) and unit:IsValid() and unit:IsInYourGroup() or false end,
        ["IsElite"] = function(unit) return (unit and unit:IsValid()) and unit:IsElite() or false end,
        ["IsDead"] = function(unit) return (unit and unit:IsValid()) and unit:IsDead() or false end,
        ["IsAccountFriend"] = function(unit) return (unit and unit:IsValid()) and unit:IsAccountFriend() or false end,
        ["IsFriend"] = function(unit) return (unit and unit:IsValid()) and unit:IsFriend() or false end,
        ["IsACharacter"] = function(unit) return (unit and unit:IsValid()) and unit:IsACharacter() or false end,
        ["IsIgnored"] = function(unit) return (unit and unit:IsValid()) and unit:IsIgnored() or false end,
        ["IsCasting"] = function(unit) return (unit and unit:IsValid()) and unit:IsCasting() or false end,
        ["IsMentoring"] = function(unit) return (unit and unit:IsValid()) and unit:IsMentoring() or false end,
        ["IsPvPFlagged"] = function(unit) return (unit and unit:IsValid()) and unit:IsPvpFlagged() or false end,
        ["IsRallied"] = function(unit) return (unit and unit:IsValid()) and unit:IsRallied() or false end,
        ["IsRival"] = function(unit) return (unit and unit:IsValid()) and unit:IsRival() or false end,
        ["IsRare"] = function(unit) return (unit and unit:IsValid()) and unit:IsRare() or false end,
        ["IsShieldOverloaded"] = function(unit) return (unit and unit:IsValid()) and unit:IsShieldOverloaded() or false end,
        ["IsTagged"] = function(unit) return (unit and unit:IsValid()) and unit:IsTagged() or false end,
        ["IsTaggedByMe"] = function(unit) return (unit and unit:IsValid()) and unit:IsTaggedByMe() or false end,
        ["IsThePlayer"] = function(unit) return (unit and unit:IsValid()) and unit:IsThePlayer() or false end,
        ["CanGrantXp"] = function(unit) return (unit and unit:IsValid()) and unit:CanGrantXp() or false end,
        ["IsVulnerable"] = function(unit) return (unit and unit:IsValid()) and unit:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Vulnerability) > 0 and true or false end,
        ["MOO"] = function(unit,unitName)
            if not unit then
                return false
            end

            if not unit:IsValid() then
                return false
            end

            local current = unit:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Vulnerability) or 0
            local time = Apollo.GetTickCount()

            if current > 0 then
                if self.units[unitName]["MOO"] == nil or self.units[unitName]["MOO"] == false then
                    return {
                        current = current,
                        total = current,
                        time = time
                    }
                else
                    if current > self.units[unitName]["MOO"].current then
                        return {
                            current = current,
                            total = current,
                            time = time
                        }
                    else
                        return {
                            current = current,
                            total = self.units[unitName]["MOO"].total,
                            time = self.units[unitName]["MOO"].time
                        }
                    end
                end
            else
                return false
            end
        end,
        ["IsInCCState"] = function(unit)
            if not unit then
                return false
            end

            if not unit:IsValid() then
                return false
            end

            for k,v in pairs(Unit.CodeEnumCCState) do
                if unit:IsInCCState(v) == true then
                    return true
                end
            end

            return false
        end,
    }
end

local LUI_AuraInst = LUI_Aura:new()
LUI_AuraInst:Init()
