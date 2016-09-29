local LUI_Aura = Apollo.GetAddon("LUI_Aura")
local GeminiColor = Apollo.GetPackage("GeminiColor").tPackage
local Settings = {}

function Settings:Init(parent)
    Apollo.LinkAddon(parent, self)
    Apollo.RegisterTimerHandler("LUI_IconTimer", "OnLoadIcons", self)
    self.parent = parent
end

function Settings:OnLoad()
    self.text = {
        visibility = {
            ["solo"] = "Solo",
            ["group"] = "In Group",
            ["raid"] = "In Raid",
            ["infight"] = "In combat",
            ["combat"] = "Out of combat",
            ["pvp"] = "PvP flagged",
        },
        threat = {
            ["0"] = "None",
            ["1"] = "Tanking",
            ["2"] = "Not Tanking",
            ["3"] = "Not on Threat Table",
            ["4"] = "Lower than tank",
            ["5"] = "Higher than tank",
            ["6"] = "Tanking but not highest",
            ["7"] = "Tanking and highest",
        },
        circumstances = {
            ["IsInCombat"] = "Is in Combat",
            ["IsInYourGroup"] = "Is in your Group",
            ["IsElite"] = "Is Elite",
            ["IsDead"] = "Is Dead",
            ["IsAccountFriend"] = "Is Account Friend",
            ["IsFriend"] = "Is Friend",
            ["IsACharacter"] = "Is a Character",
            ["IsIgnored"] = "Is Ignored",
            ["IsCasting"] = "Is Casting",
            ["IsInCCState"] = "Is in CC State",
            ["IsVulnerable"] = "Is Vulnerable (Moo)",
            ["IsMentoring"] = "Is Mentoring",
            ["IsMounted"] = "Is Mounted",
            ["IsPvPFlagged"] = "Is PvP Flagged",
            ["IsRallied"] = "Is Rallied",
            ["IsRival"] = "Is Rival",
            ["IsRare"] = "Is Rare",
            ["IsShieldOverloaded"] = "Is Shield Overloaded",
            ["IsTagged"] = "Is Tagged",
            ["IsTaggedByMe"] = "Is Tagged by me",
            ["IsThePlayer"] = "Is the Player",
            ["CanGrantXp"] = "Is granting Experience",
        },
        operator = {
            ["isEqual"] = "==",
            ["notEqual"] = "!=",
            ["greater"] = ">",
            ["smaller"] = "<",
            ["greaterOrEqual"] = ">=",
            ["smallerOrEqual"] = "<=",
        }
    }

    self.presets = {
        bars = {
            ["Linear: Default"] = {
                sprite_fill = "BasicSprites:WhiteFill",
                sprite_empty = "BasicSprites:WhiteFill",
                sprite_bg = "BasicSprites:WhiteFill",
                sprite_border = "border_thin",
                animation = "Linear",
                direction = "Right",
                color_fill = { r = 127, g = 255, b = 0, a = 255 },
                color_empty = { r = 45, g = 88, b = 0, a = 255 },
                color_bg = { r = 0, g = 0, b = 0, a = 255 },
                color_border = { r = 0, g = 0, b = 0, a = 125 },
                border_size = 5,
                spacing = 0,
                width = 250,
                height = 24,
            },
            ["Radial: Default"] = {
                sprite_fill = "circle_medium",
                sprite_bg = "circle_medium",
                sprite_bg = "circle_medium",
                sprite_border = "",
                animation = "Radial",
                direction = "Clockwise",
                color_fill = { r = 127, g = 255, b = 0, a = 255 },
                color_bg = { r = 30, g = 40, b = 12, a = 255 },
                spacing = 0,
                width = 150,
                height = 150,
                radialmin = 90,
                radialmax = 90,
            },
        },
        animations = {
            ["Fade"] = {
                enable = true,
                duration = 0.35,
                effect = "Fade",
                slideEnable = false,
                zoomEnable = false,
            },
            ["Shrink"] = {
                enable = true,
                duration = 0.35,
                effect = "Fade",
                slideEnable = false,
                zoomEnable = true,
                zoomScale = 0,
            },
            ["Grow"] = {
                enable = true,
                duration = 0.35,
                effect = "Fade",
                slideEnable = false,
                zoomEnable = true,
                zoomScale = 2.5,
            },
            ["SlideBottom"] = {
                enable = true,
                duration = 0.25,
                effect = "Fade",
                slideEnable = true,
                slideOffsetX = 0,
                slideOffsetY = -75,
                zoomEnable = false,
            },
            ["SlideLeft"] = {
                enable = true,
                duration = 0.25,
                effect = "Fade",
                slideEnable = true,
                slideOffsetX = -75,
                slideOffsetY = 0,
                zoomEnable = false,
            },
            ["SlideRight"] = {
                enable = true,
                duration = 0.25,
                effect = "Fade",
                slideEnable = true,
                slideOffsetX = 75,
                slideOffsetY = 0,
                zoomEnable = false,
            },
            ["SlideTop"] = {
                enable = true,
                duration = 0.25,
                effect = "Fade",
                slideEnable = true,
                slideOffsetX = 0,
                slideOffsetY = 75,
                zoomEnable = false,
            },
        },
        animationDropdown = {
            ["Start"] = {
                [1] = { animation = "Fade", label = "Fade In" },
                [2] = { animation = "Grow", label = "Shrink" },
                [3] = { animation = "Shrink", label = "Grow" },
                [4] = { animation = "SlideBottom", label = "Slide from Top" },
                [5] = { animation = "SlideTop", label = "Slide from Bottom" },
                [6] = { animation = "SlideLeft", label = "Slide from Left" },
                [7] = { animation = "SlideRight", label = "Slide from Right" },
            },
            ["End"] = {
                [1] = { animation = "Fade", label = "Fade Out" },
                [2] = { animation = "Shrink", label = "Shrink" },
                [3] = { animation = "Grow", label = "Grow" },
                [4] = { animation = "SlideBottom", label = "Slide to Top" },
                [5] = { animation = "SlideTop", label = "Slide to Bottom" },
                [6] = { animation = "SlideLeft", label = "Slide to Left" },
                [7] = { animation = "SlideRight", label = "Slide to Right" },
            },
        },
    }

    self.sprites = {
        ["icons"] = {
            "UI_HighLevel",
            "UI_Icon_Alert",
            "UI_COMM_Icon_Dominion",
            "UI_COMM_Icon_Exile",
            "UI_COMM_Icon_Strain",
            "UI_COMM_Icon_Drusera",
            "CRB_Basekit:kitAccent_Glow_Blue",
            "CRB_Basekit:kitAccent_Glow_GoldTex",
            "UI_CRB_ShadowMonk_0",
            "UI_CRB_ShadowMonk_1",
            "UI_CRB_ShadowMonk_2",
            "UI_CRB_ShadowMonk_3",
            "UI_CRB_ShadowMonk_4",
            "UI_CRB_ShadowMonk_5",
            "UI_CRB_ShadowMonk_6",
            "UI_CRB_ShadowMonk_7",
            "UI_CRB_ShadowMonk_8",
            "UI_CRB_ShadowMonk_9",
            "CRB_ActionBarFrameSprites:sprResourceBar_Sprint_RunIconBlue",
            "CRB_ActionBarFrameSprites:sprResourceBar_Sprint_RunIconRed",
            "CRB_ActionBarFrameSprites:sprResourceBar_Sprint_RunIconSilver",
            "UI_CRB_Basekit_Stop",
            "UI_Holo_CloseCancel",
            "UI_CRB_Crafting_Plus",
            "UI_CRB_Triangle_Glow",
            "UI_CRB_Hexagon_Glow",
            "UI_CRB_Hexagon2_Glow",
            "UI_CRB_Adventure_Blue",
            "UI_CRB_Adventure_Red",
            "UI_CRB_Adventure_Gray",
            "UI_CRB_Basekit_RedGlow",
            "UI_CRB_Basekit_EyeGlow",
            "UI_CRB_Basekit_EyeBlue",
            "UI_CRB_ArrowGreen",
            "UI_CRB_ArrowRed",
            "UI_CRB_ArrowYellow",
            "UI_CRB_HoldTheLine",
            "UI_CRB_HoldTheLine_Glow",
            "UI_CRB_HoldTheLine2",
            "UI_CRB_HoldTheLine2_Glow",
            "UI_CRB_ChallengeTracker01",
            "UI_CRB_ChallengeTracker02",
            "UI_CRB_ChallengeTracker03",
            "UI_CRB_ChallengeTracker04",
            "UI_CRB_Nameplates_Skullz",
            "UI_CRB_Reputation",
            "UI_CRB_Scientist",
            "UI_CRB_Soldier",
            "CRB_MegamapSprites:sprMap_IconCompletion_World",
            "CRB_MegamapSprites:sprMap_IconCompletion_Zone",
            "CRB_TargetFrameSprites:sprTF_PathExplorer",
            "CRB_TargetFrameSprites:sprTF_PathScientist",
            "CRB_TargetFrameSprites:sprTF_PathSettler",
            "CRB_TargetFrameSprites:sprTF_PathSoldier",
            "UI_CRB_SpellslingerEye",
            "UI_CRB_Vulnerable",
            "Icon_Windows_UI_CRB_FieldStudy_Playful",
            "Icon_Windows_UI_CRB_FieldStudy_Aggressive",
            "UI_CRB_PlayerPathContent_Hint",
            "go",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Copper",
            "IconSprites:Icon_Windows_UI_CRB_Coin_ElderGems",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Gold",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Influence",
            "IconSprites:Icon_Windows_UI_CRB_Coin_War",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Platinum",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Prestige",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Raid",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Reknown",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Silver",
            "IconSprites:Icon_Windows_UI_CRB_Coin_Token",
            "IconSprites:Icon_Windows_UI_CRB_Coin_TradeskillVoucher",
            "IconSprites:Icon_Windows_UI_CRB_Disconnect",
            "IconSprites:Icon_Windows_UI_CRB_Lock_Holo",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Bomb",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Chicken",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Crosshair",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Ghost",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Mask",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Octopus",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Pig",
            "IconSprites:Icon_Windows_UI_CRB_Marker_Toaster",
            "IconSprites:Icon_Windows_UI_CRB_Marker_UFO",
            "IconSprites:Icon_Windows_UI_CRB_Questlog_Call",
            "IconSprites:Icon_Windows_UI_CRB_Rival",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Fusion",
            "IconSprites:Icon_Windows_UI_Icon_Scanbot",
            "IconSprites:Icon_Windows_UI_SabotageBomb_Blue",
            "IconSprites:Icon_Windows_UI_SabotageBomb_Neutral",
            "IconSprites:Icon_Windows_UI_SabotageBomb_Red",
            "IconSprites:Icon_ItemMisc_ui_icon_error",
            "IconSprites:Icon_CCStates_Stun",
            "IconSprites:Icon_CraftingUI_Item_Crafting_LemonWedge",
            "IconSprites:Icon_CraftingUI_Item_Crafting_Big_Cheese_Wedge",
            "IconSprites:Icon_CraftingUI_Item_Crafting_Small_CheeseWedge",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Blue",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Cyan",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Green",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Magenta",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Orange",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Purple",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Red",
            "IconSprites:Icon_ItemMisc_UI_CandyBowl_Yellow",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_Datascape_Chest",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_Datascape_Feet",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_Datascape_Hands",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_Datascape_Head",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_Datascape_Legs",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_Datascape_Shoulder",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_GeneticArchives_Chest",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_GeneticArchives_Feet",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_GeneticArchives_Hands",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_GeneticArchives_Head",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_GeneticArchives_Legs",
            "IconSprites:Icon_ItemMisc_UI_Icon_Token_GeneticArchives_Shoulder",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Dexterity",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Magic",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Strength",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Technology",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Wisdom",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_PowerCore_Blue",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_PowerCore_Green",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_PowerCore_Orange",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_PowerCore_Purple",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Special_1",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Special_2",
            "IconSprites:Icon_ItemMisc_UI_Item_Crafting_Special_3",
            "IconSprites:Icon_ItemMisc_Amp_Blue",
            "IconSprites:Icon_ItemMisc_Amp_Green",
            "IconSprites:Icon_ItemMisc_Amp_Orange",
            "IconSprites:Icon_ItemMisc_Amp_Purple",
            "IconSprites:Icon_ItemMisc_Amp_Red",
            "IconSprites:Icon_ItemMisc_Amp_Yellow",
            "Icon_CraftingUI_Item_Crafting_Bottle_FireSauce",
            "IconSprites:Icon_CraftingUI_Item_Crafting_Bottle_OliveOil",
            "IconSprites:Icon_CraftingUI_Item_Crafting_BottleWine",
            "IconSprites:Icon_ItemMisc_UI_Item_SquirgHat",
            "IconSprites:Icon_ItemMisc_Medishot_AoEHeal",
            "IconSprites:Icon_ItemMisc_Medishot_HealOverTime",
            "IconSprites:Icon_ItemMisc_Medishot_HealOverTime_InstantHeal",
            "IconSprites:Icon_ItemMisc_Medishot_InstantHeal",
            "IconSprites:Icon_ItemMisc_Medishot_InstantHeal_ShieldHeal",
            "faction_dominion",
            "faction_exiles",
            "star_bronze",
            "star_silver",
            "star_gold",
            "star_red",
            "star_dark",
            "star_transparent",
            "flame_blue_001",
            "flame_blue_002",
            "flame_blue_003",
            "flame_blue_004",
            "flame_blue_005",
            "flame_blue_006",
            "flame_pink_001",
            "flame_pink_002",
            "flame_pink_003",
            "flame_pink_004",
            "flame_pink_005",
            "flame_pink_006",
            "flame_white_001",
            "flame_white_002",
            "flame_white_003",
            "flame_white_004",
            "flame_white_005",
            "flame_white_006",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Salvage",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Air",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Earth",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Fire",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Life",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Logic",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Omni",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Water",
            "IconSprites:Icon_Windows_UI_CRB_Tooltip_Shadow",
            "UI_CharC_Ico_Exile_Lrg",
            "UI_Achievement_Icon_Group",
            "UI_Achievement_Icon_Solo",
            "UI_BK3_Holo_OptionsIcon_Combat",
            "UI_BK3_Holo_OptionsIcon_Sound",
            "Icon_Windows_UI_CRB_Attribute_Insight",
            "Icon_Windows_UI_CRB_Attribute_Moxie",
            "Icon_Windows_UI_CRB_Attribute_Technology",
            "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Fatigue",
            "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Feed",
            "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Food",
            "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Survivor",
            "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Water",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Armor",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_AssaultPower",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_BruteForce",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_CriticalHit",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_CriticalSeverity",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Deflect",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Finesse",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Grit",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Health",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Insight",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Moxie",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Recovery",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Shield",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Strikethrough",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_SupportPower",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_Technology",
            "IconSprites:Icon_Windows_UI_CRB_Dice",
            "IconSprites:Icon_Windows_UI_CRB_GiftPresentGreen",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Aggressive",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Guarding",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Hungry",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Hunting",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Injured",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Love",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Playful",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Scared",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Singing",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Sleeping",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Social",
            "IconSprites:Icon_Windows_UI_CRB_FieldStudy_Working",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_New20ManRaid",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_New40ManRaid",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewAbility",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewActionBarSlot",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewAdventure",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewCapitalCity",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewClassFeature",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewClassImprovement",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewContentFeature",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewDungeon",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewGearSlot",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewGeneralFeature",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewPvPBattleground",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewPvPFeature",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewSocialFeature",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_NewZone",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_UpgradedGeneralFeature",
            "IconSprites:Icon_Windows_UI_CRB_LevelUp_UpgradedClassAbility",
            "Crafting_RunecraftingSprites:sprRunecrafting_Fire",
            "Crafting_RunecraftingSprites:sprRunecrafting_Air",
            "Crafting_RunecraftingSprites:sprRunecrafting_Earth",
            "Crafting_RunecraftingSprites:sprRunecrafting_Fusion",
            "Crafting_RunecraftingSprites:sprRunecrafting_Life",
            "Crafting_RunecraftingSprites:sprRunecrafting_Logic",
            "Crafting_RunecraftingSprites:sprRunecrafting_Omni",
            "Crafting_RunecraftingSprites:sprRunecrafting_Water",
            "Crafting_RunecraftingSprites:sprRunecrafting_Fire_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Air_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Earth_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Fusion_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Life_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Logic_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Omni_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_Water_Colored",
            "Crafting_RunecraftingSprites:sprRunecrafting_FireFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_AirFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_EarthFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_FusionFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_LifeFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_LogicFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_OmniFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_WaterFade",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Fire",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Air",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Earth",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Fusion",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Life",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Logic",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Omni",
            "Crafting_RunecraftingSprites:sprRunecrafting_Btn_Water",
            "IconSprites:Icon_Windows_UI_RuneSlot_Air_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Earth_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Fire_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Fusion_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Life_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Logic_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Omni_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Water_Empty",
            "IconSprites:Icon_Windows_UI_RuneSlot_Air_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Earth_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Fire_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Fusion_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Life_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Logic_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Omni_Used",
            "IconSprites:Icon_Windows_UI_RuneSlot_Water_Used",
            "IconSprites:Icon_Windows_UI_CRB_AccountInventory_AccountBound",
            "IconSprites:Icon_Windows_UI_CRB_AccountInventory_CharacterBound",
            "IconSprites:Icon_Windows_UI_CRB_AccountInventory_CharacterWings",
            "IconSprites:Icon_Windows_UI_CRB_AccountInventory_Mail",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_FocusRecovery",
            "IconSprites:Icon_Windows_UI_CRB_Attribute_ShieldCap",
            "IconSprites:Icon_Mission_Explorer_ActivateChecklist",
            "IconSprites:Icon_Mission_Explorer_ClaimTerritory",
            "IconSprites:Icon_Mission_Explorer_ExplorerDoor",
            "IconSprites:Icon_Mission_Explorer_ExploreZone",
            "IconSprites:Icon_Mission_Explorer_PowerMap",
            "IconSprites:Icon_Mission_Explorer_ScavengerHunt",
            "IconSprites:Icon_Mission_Explorer_Vista",
            "IconSprites:Icon_Mission_Scientist_Activate",
            "IconSprites:Icon_Mission_Scientist_DatachronDiscovery",
            "IconSprites:Icon_Mission_Scientist_DatacubeDiscovery",
            "IconSprites:Icon_Mission_Scientist_FieldStudy",
            "IconSprites:Icon_Mission_Scientist_ReverseEngineering",
            "IconSprites:Icon_Mission_Scientist_SpecimenSurvey",
            "IconSprites:Icon_Mission_Settler_DepotImprovements",
            "IconSprites:Icon_Mission_Settler_InfastructureImprovements",
            "IconSprites:Icon_Mission_Settler_Mayoral",
            "IconSprites:Icon_Mission_Settler_Posse",
            "IconSprites:Icon_Mission_Settler_Scout",
            "IconSprites:Icon_Mission_Settler_Sheriff",
            "IconSprites:Icon_Mission_Settler_Surveilance",
            "IconSprites:Icon_Mission_Soldier_Assassinate",
            "IconSprites:Icon_Mission_Soldier_Demolition",
            "IconSprites:Icon_Mission_Soldier_Rescue",
            "IconSprites:Icon_Mission_Soldier_Swat",
            "IconSprites:Icon_Mission_Scientist_ScanCreature",
            "IconSprites:Icon_Mission_Scientist_ScanElemental",
            "IconSprites:Icon_Mission_Scientist_ScanHistory",
            "IconSprites:Icon_Mission_Scientist_ScanMagic",
            "IconSprites:Icon_Mission_Scientist_ScanMineral",
            "IconSprites:Icon_Mission_Scientist_ScanMission",
            "IconSprites:Icon_Mission_Scientist_ScanPlant",
            "IconSprites:Icon_Mission_Scientist_ScanRaw",
            "IconSprites:Icon_Mission_Scientist_ScanTech",
            "IconSprites:Icon_Mission_Soldier_HoldoutConquer",
            "IconSprites:Icon_Mission_Soldier_HoldoutFortify",
            "IconSprites:Icon_Mission_Soldier_HoldoutProtect",
            "IconSprites:Icon_Mission_Soldier_HoldoutRushDown",
            "IconSprites:Icon_Mission_Soldier_HoldoutSecurity",
            "IconSprites:Icon_Mission_Soldier_HoldoutTimed",
            "path_soldier",
            "path_scientist",
            "path_explorer",
            "path_settler",
            "class_warrior",
            "class_esper",
            "class_spellslinger",
            "class_stalker",
            "class_engineer",
            "class_medic",
            "class_esper1",
            "class_medic1",
            "class_stalker1",
            "class_warrior1",
            "class_engineer1",
            "class_spellslinger1",
            "class_esper2",
            "class_medic2",
            "class_stalker2",
            "class_warrior2",
            "class_engineer2",
            "class_spellslinger2",
            "class_esper3",
            "class_medic3",
            "class_warrior3",
            "class_engineer3",
            "class_spellslinger3",
            "IconSprites:Icon_Guild_UI_Guild_Blueprint",
            "IconSprites:Icon_Guild_UI_Guild_Candles",
            "IconSprites:Icon_Guild_UI_Guild_Donut",
            "IconSprites:Icon_Guild_UI_Guild_Flute",
            "IconSprites:Icon_Guild_UI_Guild_Hand",
            "IconSprites:Icon_Guild_UI_Guild_Key",
            "IconSprites:Icon_Guild_UI_Guild_Leaf",
            "IconSprites:Icon_Guild_UI_Guild_Lopp",
            "IconSprites:Icon_Guild_UI_Guild_Pearl",
            "IconSprites:Icon_Guild_UI_Guild_Potion",
            "IconSprites:Icon_Guild_UI_Guild_Sandwich",
            "IconSprites:Icon_Guild_UI_Guild_Skull",
            "IconSprites:Icon_Guild_UI_Guild_Steak",
            "IconSprites:Icon_Guild_UI_Guild_Stick",
            "IconSprites:Icon_Guild_UI_Guild_Syringe",
            "comic-eyes-01",
            "comic-eyes-02",
            "comic-eyes-03",
            "comic-eyes-04",
            "comic-eyes-05",
            "comic-eyes-06",
            "comic-eyes-07",
            "comic-eyes-08",
            "comic-eyes-09",
            "comic-eyes-10",
            "comic-eyes-11",
            "comic-eyes-12",
            "monster-01",
            "monster-02",
            "monster-03",
            "monster-04",
            "monster-05",
            "monster-06",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Architect",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Armorer",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Cooking",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Farmer",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Miner",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Outfitter",
            "IconSprites:Icon_Achievement_UI_Tradeskills_RelicHunter",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Survivalist",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Tailor",
            "IconSprites:Icon_Achievement_UI_Tradeskills_Technologist",
            "IconSprites:Icon_Achievement_UI_Tradeskills_WeaponCrafting",
            "IconSprites:Icon_Windows_UI_CRB_GiftPresent",
            "IconSprites:Icon_Windows_UI_CRB_Infinity",
            "IconSprites:Icon_Windows_UI_CRB_TargetTemp",
            "auramastery_swirl",
            "auramastery_boom",
            "auramastery_crosshair",
            "auramastery_exclaim1",
            "auramastery_exclaim2",
            "auramastery_heart",
            "auramastery_lightning",
            "auramastery_paw",
            "auramastery_tick",
            "auramastery_fireball",
            "auramastery_flower",
            "twirl",
            "aim-01",
            "aim-02",
            "aim-03",
            "aim-04",
            "aim-05",
            "danger-01",
            "danger-02",
            "danger-03",
            "danger-04",
            "danger-05",
            "danger-06",
            "danger-07",
            "danger-08",
            "danger-09",
            "danger-10",
            "danger-11",
            "danger-12",
            "eyes-01",
            "eyes-02",
            "eyes-03",
            "star",
            "triangle-01",
            "triangle-02",
            "cross",
            "heart",
            "ghost",
            "run-01",
            "run-02",
            "science",
            "shield",
            "skull-01",
            "skull-02",
            "skull-03",
            "skull-04",
            "skull-05",
            "skull-06",
            "skull-07",
            "skull-08",
            "skull-09",
            "skull-10",
            "skull-11",
            "skull-12",
            "skull-13",
            "vector_001",
            "vector_002",
            "vector_003",
            "vector_004",
            "vector_005",
            "vector_006",
            "vector_007",
            "vector_008",
            "vector_009",
            "vector_010",
            "vector_011",
            "vector_012",
            "vector_013",
            "vector_014",
            "vector_015",
            "vector_016",
            "vector_017",
            "vector_018",
            "vector_019",
            "vector_020",
            "vector_021",
            "vector_022",
            "vector_023",
            "vector_024",
            "vector_025",
            "vector_026",
            "vector_027",
            "vector_028",
            "vector_029",
            "vector_030",
            "vector_031",
            "vector_032",
            "vector_033",
            "vector_034",
            "vector_035",
            "vector_036",
            "vector_037",
            "vector_038",
            "vector_039",
            "vector_040",
            "vector_041",
            "vector_042",
            "vector_043",
            "vector_044",
            "vector_045",
            "vector_046",
            "vector_047",
            "vector_048",
            "vector_049",
            "vector_050",
            "vector_051",
            "vector_052",
            "vector_053",
            "vector_054",
            "vector_055",
            "vector_056",
            "vector_057",
            "vector_058",
            "vector_059",
            "vector_060",
            "vector_061",
            "vector_062",
            "vector_063",
            "vector_064",
            "vector_065",
            "vector_066",
            "vector_067",
            "vector_068",
            "vector_069",
            "vector_070",
            "vector_071",
            "vector_072",
            "vector_073",
            "vector_074",
            "vector_075",
            "vector_076",
            "vector_077",
            "vector_078",
            "vector_079",
            "space_001",
            "space_002",
            "space_003",
            "space_004",
            "space_005",
            "space_006",
            "space_007",
            "space_008",
            "space_009",
            "space_010",
            "space_011",
            "space_012",
            "space_013",
            "space_014",
            "space_015",
            "space_016",
            "space_017",
            "space_018",
            "space_019",
            "space_020",
            "space_021",
            "face_001",
            "face_002",
            "face_003",
            "face_004",
            "face_005",
            "face_006",
            "face_007",
            "face_008",
            "face_009",
            "face_010",
            "face_011",
            "face_012",
            "face_013",
            "face_014",
            "smiley_001",
            "smiley_002",
            "smiley_003",
            "smiley_004",
            "smiley_005",
            "smiley_006",
            "smiley_007",
            "smiley_008",
            "smiley_009",
            "smiley_010",
            "smiley_011",
            "smiley_012",
            "smiley_013",
            "smiley_014",
            "smiley_015",
            "smiley_016",
            "smiley_017",
            "smiley_018",
            "smiley_019",
            "smiley_020",
            "smiley_021",
            "smiley_022",
            "shield_001",
            "shield_002",
            "shield_003",
            "shield_004",
            "shield_005",
            "shield_006",
            "shield_007",
            "shield_008",
            "shield_009",
            "shield_010",
            "shield_011",
            "shield_012",
            "shield_013",
            "shield_014",
            "shield_015",
            "shield_016",
            "shield_017",
            "shield_018",
            "shield_019",
            "shield_020",
            "shield_021",
            "shield_022",
            "shield_023",
            "shield_024",
            "shield_025",
            "animal_001",
            "animal_002",
            "animal_003",
            "animal_004",
            "animal_005",
            "animal_006",
            "animal_007",
            "animal_008",
            "animal_009",
            "animal_010",
            "animal_011",
            "animal_012",
            "animal_013",
            "animal_014",
            "animal_015",
            "animal_016",
            "animal_017",
            "animal_018",
            "animal_019",
            "animal_020",
            "animal_021",
            "animal_022",
            "animal_023",
            "animal_024",
            "animal_025",
            "animal_026",
            "animal_027",
            "animal_028",
            "animal_029",
            "animal_030",
            "animal_031",
            "animal_032",
            "animal_033",
            "animal_034",
            "animal_035",
            "animal_036",
            "animal_037",
            "animal_038",
            "animal_039",
            "animal_040",
            "animal_041",
            "animal_042",
            "animal_043",
            "animal_044",
            "animal_045",
            "animal_046",
            "animal_047",
            "animal_048",
            "animal_049",
            "animal_050",
            "scary_001",
            "scary_002",
            "scary_003",
            "scary_004",
            "scary_005",
            "scary_006",
            "scary_007",
            "scary_008",
            "scary_009",
            "scary_010",
            "scary_011",
            "scary_012",
            "scary_013",
            "scary_014",
            "scary_015",
            "scary_016",
            "scary_017",
            "scary_018",
            "scary_019",
            "scary_020",
            "scary_021",
            "scary_022",
            "scary_023",
            "scary_024",
            "scary_025",
            "scary_026",
            "scary_027",
            "scary_028",
            "scary_029",
            "scary_030",
            "scary_031",
            "scary_032",
            "scary_033",
            "scary_034",
            "scary_035",
            "scary_036",
            "scary_037",
            "scary_038",
            "scary_039",
            "scary_040",
            "scary_041",
            "scary_042",
            "scary_043",
            "scary_044",
            "scary_045",
            "scary_046",
            "target_001",
            "target_002",
            "target_003",
            "target_004",
            "target_005",
            "target_006",
            "target_007",
            "target_008",
            "target_009",
            "target_010",
            "target_011",
            "target_012",
            "target_013",
            "target_014",
            "target_015",
            "target_016",
            "target_017",
            "target_018",
            "target_019",
            "target_020",
            "target_021",
            "target_022",
            "target_023",
            "target_024",
            "target_025",
            "target_026",
            "target_027",
            "target_028",
            "target_029",
            "target_030",
            "target_031",
            "target_032",
            "target_033",
            "target_034",
            "target_035",
            "target_036",
            "target_037",
            "target_038",
            "target_039",
            "target_040",
            "target_041",
            "target_042",
            "target_043",
            "target_044",
            "target_045",
            "target_046",
            "target_047",
            "target_048",
            "fire_001",
            "fire_002",
            "fire_003",
            "fire_004",
            "fire_005",
            "fire_006",
            "fire_007",
            "fire_008",
            "fire_009",
            "fire_010",
            "fire_011",
            "fire_012",
            "fire_013",
            "fire_014",
            "fire_015",
            "fire_016",
            "fire_017",
            "fire_018",
            "water_001",
            "water_002",
            "water_003",
            "water_004",
            "water_005",
            "water_006",
            "air_001",
            "air_002",
            "air_003",
            "air_004",
            "air_005",
            "air_006",
            "air_007",
            "thunder-01",
            "thunder-02",
            "lightning_001",
            "lightning_002",
            "lightning_003",
            "lightning_004",
            "lightning_005",
            "lightning_006",
            "lightning_007",
            "lightning_008",
            "meteor_001",
            "meteor_002",
            "meteor_003",
            "meteor_004",
            "meteor_005",
            "attention_001",
            "attention_002",
            "attention_003",
            "attention_004",
            "attention_005",
            "attention_006",
            "attention_007",
            "attention_008",
            "attention_009",
            "attention_010",
            "attention_011",
            "attention_012",
            "attention_013",
            "attention_014",
            "attention_015",
            "attention_016",
            "toxic_001",
            "toxic_002",
            "toxic_003",
            "toxic_004",
            "toxic_005",
            "toxic_006",
            "toxic_007",
            "toxic_008",
            "weapon_001",
            "weapon_002",
            "weapon_003",
            "weapon_004",
            "weapon_005",
            "weapon_006",
            "weapon_007",
            "weapon_008",
        },
        ["forms"] = {
            "BasicSprites:WhiteFill",
            "BasicSprites:WhiteCircle",
            "BK3:sprHolo_Accent_Circle",
            "ClientSprites:ComboStarEmpty",
            "ClientSprites:ComboStarFull",
            "ClientSprites:QuestJewel_SilverRing",
            "CRB_MinimapSprites:sprMM_IndicatorRing",
            "ClientSprites:HuddieLevelCircle",
            "ClientSprites:MiniMapObject",
            "CRB_ActionBarFrameSprites:sprResourceBar_DodgeFlashFullSolid",
            "CRB_Basekit:kitIcon_Holo_DownArrow",
            "CRB_Basekit:kitIcon_Holo_UpArrow",
            "CRB_BreakoutSprites:spr_BreakoutStun_BlueRadialProg",
            "CRB_BreakoutSprites:spr_BreakoutStun_RedRadialProg",
            "CRB_CraftingSprites:sprCraft_TEMP_GreenSemiCircle",
            "UI_CRB_Crafting_RingBlue",
            "UI_CRB_Crafting_RingGlow",
            "UI_CRB_DatachronRing_Blue",
            "UI_CRB_DatachronRing_Red",
            "UI_CRB_DatachronRing_Holo",
            "UI_CRB_DatachronRing_Green",
            "UI_CRB_MedicResource_Green",
            "UI_CRB_MedicResource_GreenGlow",
            "UI_CRB_PSLogo",
            "UI_ClusterHealthGreen",
            "UI_ClusterHealthShield",
            "UI_ClusterHealthYellow",
            "UI_ClusterHealthRed",
            "auramastery_arcanehud1",
            "auramastery_arcanehud2",
            "auramastery_arcanehudbottom1",
            "auramastery_arcanehudleft1",
            "auramastery_arcanehudright1",
            "auramastery_arcanehudtop1",
            "auramastery_circle",
            "auramastery_curvebottom1",
            "auramastery_curvebottomleft1",
            "auramastery_curvebottomright1",
            "auramastery_curvehud1",
            "auramastery_curvehud2",
            "auramastery_curvehud3",
            "auramastery_curvehud4",
            "auramastery_curvehud5",
            "auramastery_curvehud6",
            "auramastery_curvehud7",
            "auramastery_curvehud8",
            "auramastery_curvehud9",
            "auramastery_curvehud10",
            "auramastery_curvehudbottom1",
            "auramastery_curvehudbottom2",
            "auramastery_curvehudbottom3",
            "auramastery_curvehudbottom4",
            "auramastery_curvehudbottom5",
            "auramastery_curvehudbottom6",
            "auramastery_curvehudleft1",
            "auramastery_curvehudleft2",
            "auramastery_curvehudright1",
            "auramastery_curvehudright2",
            "auramastery_curvehudtop1",
            "auramastery_curvehudtop2",
            "auramastery_curvehudtop3",
            "auramastery_curvehudtop4",
            "auramastery_curvehudtop5",
            "auramastery_curveleft1",
            "auramastery_curveright1",
            "auramastery_curvetop1",
            "auramastery_curvetopleft1",
            "auramastery_curvetopright1",
            "auramastery_featherhud1",
            "auramastery_featherhud2",
            "auramastery_featherhudbottom1",
            "auramastery_featherhudleft1",
            "auramastery_featherhudright1",
            "auramastery_featherhudtop1",
            "auramastery_flamehud1",
            "auramastery_flamehud2",
            "auramastery_flamehudbottom1",
            "auramastery_flamehudleft1",
            "auramastery_flamehudright1",
            "auramastery_flamehudtop1",
            "auramastery_hud1",
            "auramastery_hudbottom1",
            "auramastery_hudleft1",
            "auramastery_hudright1",
            "auramastery_hudtop1",
            "auramastery_leaveshud1",
            "auramastery_leaveshud2",
            "auramastery_leaveshud3",
            "auramastery_leaveshud4",
            "auramastery_leaveshudbottom1",
            "auramastery_leaveshudbottom2",
            "auramastery_leaveshudleft1",
            "auramastery_leaveshudleft2",
            "auramastery_leaveshudright1",
            "auramastery_leaveshudtop1",
            "auramastery_leaveshudtop2",
            "auramastery_strobe1",
            "auramastery_strobeleft1",
            "auramastery_stroberight1",
        },
        ["text"] = {
            "CRB_NumberFloaters:sprNumber_Physical0",
            "CRB_NumberFloaters:sprNumber_Physical1",
            "CRB_NumberFloaters:sprNumber_Physical2",
            "CRB_NumberFloaters:sprNumber_Physical3",
            "CRB_NumberFloaters:sprNumber_Physical4",
            "CRB_NumberFloaters:sprNumber_Physical5",
            "CRB_NumberFloaters:sprNumber_Physical6",
            "CRB_NumberFloaters:sprNumber_Physical7",
            "CRB_NumberFloaters:sprNumber_Physical8",
            "CRB_NumberFloaters:sprNumber_Physical9",
            "CRB_CritNumberFloaters:sprCritNumber_Physical0",
            "CRB_CritNumberFloaters:sprCritNumber_Physical1",
            "CRB_CritNumberFloaters:sprCritNumber_Physical2",
            "CRB_CritNumberFloaters:sprCritNumber_Physical3",
            "CRB_CritNumberFloaters:sprCritNumber_Physical4",
            "CRB_CritNumberFloaters:sprCritNumber_Physical5",
            "CRB_CritNumberFloaters:sprCritNumber_Physical6",
            "CRB_CritNumberFloaters:sprCritNumber_Physical7",
            "CRB_CritNumberFloaters:sprCritNumber_Physical8",
            "CRB_CritNumberFloaters:sprCritNumber_Physical9",
            "CRB_NumberFloaters:sprFloater_Normal0",
            "CRB_NumberFloaters:sprFloater_Normal1",
            "CRB_NumberFloaters:sprFloater_Normal2",
            "CRB_NumberFloaters:sprFloater_Normal3",
            "CRB_NumberFloaters:sprFloater_Normal4",
            "CRB_NumberFloaters:sprFloater_Normal5",
            "CRB_NumberFloaters:sprFloater_Normal6",
            "CRB_NumberFloaters:sprFloater_Normal7",
            "CRB_NumberFloaters:sprFloater_Normal8",
            "CRB_NumberFloaters:sprFloater_Normal9",
            "UI_CRB_Esper_01",
            "UI_CRB_Esper_02",
            "UI_CRB_Esper_03",
            "UI_CRB_Esper_04",
            "UI_CRB_Esper_05",
        },
        ["border"] = {
            "border_thin",
            "border_medium",
            "border_thick",
            "CRB_ActionBarIconSprites:sprActionBar_GreenBorder",
            "CRB_ActionBarIconSprites:sprActionBar_OrangeBorder",
            "CRB_ActionBarIconSprites:sprActionBar_YellowBorder",
            "CRB_ActionBarIconSprites:sprAS_ButtonPress",
            "CRB_ActionBarIconSprites:sprAS_ChannelCast",
            "CRB_ActionBarIconSprites:sprAS_Chnl_Flash",
            "CRB_ActionBarIconSprites:sprAS_Chnl_Highlight",
            "border_alert",
            "border_alert2",
            "CRB_ActionBarIconSprites:sprAS_Prompt_Interrupt2",
            "CRB_ActionBarIconSprites:sprAS_Prompt_Resource_Scalable",
            "border_stealth",
            "border_stealth_slow",
            "CRB_ActionBarSprites:ActionBarToggledState",
            "ClientSprites:AB_Activate",
            "CRB_PlayerPathSprites:sprPP_ButtonGlow",
            "CRB_PlayerPathSprites:sprPP_ButtonGlowBase",
            "CRB_PlayerPathSprites:sprPP_ButtonGlowOver",
            "CRB_PlayerPathSprites:sprPP_ListGlow",
            "CRB_PlayerPathSprites:sprPP_ListGlowBase",
            "CRB_PlayerPathSprites:sprPP_ListGlowOver",
            "Anim_Inventory_New:sprInventory_NewItemScale",
            "CRB_Anim_Outline:spr_Anim_OutlineStretch",
            "CRB_Anim_Outline:spr_Anim_OutlineStretch_Delay",
            "CRB_Anim_Outline:spr_Anim_OutlineStretch_Slow2x",
            "CRB_DatachronSprites:sprDC_CallPulseAnimation",
            "CRB_DatachronSprites:sprDC_MissedPulseAnimation",
            "border_red",
            "border_red_pulse",
            "CRB_CurrencySprites:sprHeadingFrame",
            "MTX:UI_BK3_MTX_Nav_Framing",
            "MTX:UI_BK3_MTX_NCoinReminderPulse",
            "BK3:UI_BK3_ItemQualityBlue",
            "BK3:UI_BK3_ItemQualityGreen",
            "BK3:UI_BK3_ItemQualityMagenta",
            "BK3:UI_BK3_ItemQualityOrange",
            "BK3:UI_BK3_ItemQualityPurple",
            "BK3:UI_BK3_ItemQualityGrey",
            "BK3:UI_BK3_ItemQualityWhite",
            "BK3:UI_BK3_Holo_Snippet_Alert",
            "BK3:UI_BK3_Options_Telegraph_Outline",
            "CRB_Tooltips:sprTooltip_SquareFrame_Blue",
            "CRB_Tooltips:sprTooltip_SquareFrame_DarkModded",
            "CRB_Tooltips:sprTooltip_SquareFrame_Green",
            "CRB_Tooltips:sprTooltip_SquareFrame_Orange",
            "CRB_Tooltips:sprTooltip_SquareFrame_Pink",
            "CRB_Tooltips:sprTooltip_SquareFrame_Purple",
            "CRB_Tooltips:sprTooltip_SquareFrame_Silver",
            "CRB_Tooltips:sprTooltip_SquareFrame_UnitRed",
            "CRB_Tooltips:sprTooltip_SquareFrame_UnitTeal",
            "CRB_Tooltips:sprTooltip_SquareFrame_UnitYellow",
            "CRB_Tooltips:sprTooltip_SquareFrame_White",
            "HologramSprites:HoloFrame1",
            "BK3:sprMetal_ExpandMenu_MedSmall_Framing",
            "BK3:sprMetal_ExpandMenu_Large_Framing",
            "CRB_MegamapSprites:sprMap_SignalLost_Framing",
            "CRB_MegamapSprites:sprMap_SignalLost_FramingOrange",
            "Anim_Inventory_New:sprInventory_NewItemScale",
            "BK3:sprHolo_Accent_Rounded",
            "BK3:sprHolo_Accent_Square",
            "BK3:sprHolo_Accent_Circle",
            "ClientSprites:QuestJewel_SilverRing",
            "CRB_MinimapSprites:sprMM_IndicatorRing",
            "ClientSprites:BagWindowClick",
            "ClientSprites:BagWindowMouseOver",
            "ClientSprites:IconicButtonBase",
            "ClientSprites:IconicButtonEdgeGlow",
            "ClientSprites:IconicButtonInnerGlow1",
            "ClientSprites:IconicButtonInnerGlow2",
            "ClientSprites:IconicButtonInnerGlow3",
            "CRB_Basekit:kitAccent_Frame_BlueStroke",
            "CRB_Basekit:kitAccent_Frame_OrangeStroke",
            "CRB_Basekit:kitAccent_Frame_OrangeStrokePulse",
            "CRB_Basekit:kitAccent_Frame_OrangeCorners",
            "CRB_Basekit:kitBase_HoloBlue_IconBaseStretch",
            "CRB_Basekit:kitInnerFrame_MetalGold_Small",
            "CRB_Basekit:kitInnerFrame_MetalGrey_Small",
            "CRB_Basekit:kitInnerFrame_MetalGold_Plain",
            "CRB_CharacterCreateSprites:sprCharC_MTXCharacterIndicator",
        },
        ["spells"] = {
            "IconSprites:Icon_BuffBattlegrounds_Mask_Carrier",
            "IconSprites:Icon_BuffBattlegrounds_Power_Up_Damage",
            "IconSprites:Icon_Modifier_damage_absorption_001",
            "IconSprites:Icon_BuffDebuff_Physical_Damage_Resistance_Buff",
            "IconSprites:Icon_BuffBattlegrounds_Power_Up_Health",
            "IconSprites:Icon_BuffBattlegrounds_Power_Up_Speed",
            "IconSprites:Icon_Modifier_dodge_001",
            "IconSprites:Icon_Modifier_movement_speedup_001",
            "IconSprites:Icon_BuffDebuff_Assault_Power_Buff",
            "IconSprites:Icon_BuffDebuff_Assault_Power_Debuff",
            "IconSprites:Icon_BuffDebuff_Daily_Buffs",
            "IconSprites:Icon_BuffDebuff_Knockdown_Proc",
            "IconSprites:Icon_BuffDebuff_Modifier_Armor",
            "IconSprites:Icon_BuffDebuff_Modifier_Elemental_Fire",
            "IconSprites:Icon_BuffDebuff_Modifier_Elemental_Life",
            "IconSprites:Icon_BuffDebuff_Modifier_Elemental_XP",
            "IconSprites:Icon_BuffDebuff_Moment_of_Opportunity",
            "IconSprites:Icon_BuffDebuff_Moment_of_Opportunity_Alt_02",
            "IconSprites:Icon_BuffDebuff_Money_Loot_Drop_Increase_Buff",
            "IconSprites:Icon_BuffDebuff_Path_XP_Buff",
            "IconSprites:Icon_BuffDebuff_Physical_Proc",
            "IconSprites:Icon_BuffDebuff_Reactive_Heal_Proc",
            "IconSprites:Icon_BuffDebuff_Reactive_Shield_Proc",
            "IconSprites:Icon_BuffDebuff_Reputation_Increase_Buff",
            "IconSprites:Icon_BuffDebuff_Slow_Fall_Buff",
            "IconSprites:Icon_BuffDebuff_Spiritual",
            "IconSprites:Icon_BuffDebuff_Stun_Proc",
            "IconSprites:Icon_BuffDebuff_Support_Power_Buff",
            "IconSprites:Icon_BuffDebuff_Support_Power_Debuff",
            "IconSprites:Icon_BuffDebuff_Tradeskill_Harvest_Increase_Buff",
            "IconSprites:Icon_BuffDebuff_Vendor_Discounts_Spell_Indicator_Buff",
            "IconSprites:Icon_BuffWarplots_Bomb_Carrier_Icon",
            "IconSprites:Icon_BuffWarplots_Boss_Summon",
            "IconSprites:Icon_BuffWarplots_capture_node",
            "IconSprites:Icon_BuffWarplots_critical_hit",
            "IconSprites:Icon_BuffWarplots_deflection",
            "IconSprites:Icon_BuffWarplots_deployable",
            "IconSprites:Icon_BuffWarplots_Direct_Boss",
            "IconSprites:Icon_BuffWarplots_Direct_Boss_Alt_01",
            "IconSprites:Icon_BuffWarplots_Direct_Boss_Alt_02",
            "IconSprites:Icon_BuffWarplots_Direct_Boss_Alt_03",
            "IconSprites:Icon_BuffWarplots_double_time",
            "IconSprites:Icon_BuffWarplots_fire_damage_over_time",
            "IconSprites:Icon_BuffWarplots_mitigation",
            "IconSprites:Icon_BuffWarplots_radar",
            "IconSprites:Icon_BuffWarplots_repair",
            "IconSprites:Icon_BuffWarplots_Resource_Carrier_Icon",
            "IconSprites:Icon_BuffWarplots_strikethrough",
            "IconSprites:Icon_BuffWarplots_upgrade",
            "IconSprites:Icon_BuffWarplots_Warplot_Teleport",
            "IconSprites:Icon_BuffWorldPvP_Diminishing_Returns",
            "IconSprites:Icon_BuffWorldPvP_No_XP",
            "IconSprites:Icon_Modifier_xp_001",
            "IconSprites:Icon_ItemMisc_ContractPoints",
            "IconSprites:Icon_Modifier_elemental_air_001",
            "IconSprites:Icon_Modifier_elemental_earth_001",
            "IconSprites:Icon_Modifier_elemental_fire_001",
            "IconSprites:Icon_Modifier_elemental_life_001",
            "IconSprites:Icon_Modifier_elemental_logic_001",
            "IconSprites:Icon_Modifier_elemental_water_001",
            "IconSprites:Icon_Modifier_endurance_max_001",
            "IconSprites:Icon_Modifier_endurance_regen_001",
            "IconSprites:Icon_Modifier_harvesting_001",
            "IconSprites:Icon_Modifier_armor_001",
            "IconSprites:Icon_Modifier_armor_interupt_001",
            "IconSprites:Icon_Modifier_cash_001",
            "IconSprites:Icon_Modifier_crit_chance_001",
            "IconSprites:Icon_Modifier_crit_severity_001",
            "IconSprites:Icon_Modifier_attribute_magic_001",
            "IconSprites:Icon_Modifier_attribute_strength_001",
            "IconSprites:Icon_Modifier_attribute_tech_001",
            "IconSprites:Icon_Modifier_health_001",
            "IconSprites:Icon_Modifier_health_max_001",
            "IconSprites:Icon_Modifier_health_regen_001",
            "IconSprites:Icon_Modifier_hit_chance_001",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Dynamic",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Ethereal",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Geomatic",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Infernal",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Inspiring",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Mystical",
            "IconSprites:Icon_ItemMisc_WeaponEffects_SuperChilled",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Tempestuous",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Umbral",
            "IconSprites:Icon_ItemMisc_WeaponEffects_Verdant",
            "IconSprites:Icon_ItemMisc_Icon_Toy_OsunDisguise",
            "IconSprites:Icon_ItemMisc_Icon_Toy_Wfest_Gold_Cider",
            "IconSprites:Icon_ItemMisc_Icon_WfestSnow_Hit",
            "IconSprites:Icon_ItemMisc_Icon_WfestSnow_NotHit",
            "IconSprites:Icon_ItemMisc_LoppStatue_Toy",
            "IconSprites:Icon_ItemMisc_OsunStatue_Toy",
            "IconSprites:Icon_Windows_UI_CRB_TSpell_CallNPC",
            "IconSprites:Icon_ItemMisc_bag_0001",
            "IconSprites:Icon_ItemMisc_bag_0002",
            "IconSprites:Icon_ItemMisc_bag_0003",
            "IconSprites:Icon_ItemMisc_bag_0004",
            "IconSprites:Icon_ItemMisc_claw_0001",
            "IconSprites:Icon_ItemMisc_claw_0002",
            "IconSprites:Icon_ItemMisc_claw_0003",
            "IconSprites:Icon_ItemMisc_claw_0004",
            "IconSprites:Icon_ItemMisc_egg_0001",
            "IconSprites:Icon_ItemMisc_egg_0002",
            "IconSprites:Icon_ItemMisc_egg_0003",
            "IconSprites:Icon_ItemMisc_egg_0004",
            "IconSprites:Icon_ItemMisc_fur_0001",
            "IconSprites:Icon_ItemMisc_fur_0002",
            "IconSprites:Icon_ItemMisc_fur_0003",
            "IconSprites:Icon_ItemMisc_fur_0004",
            "IconSprites:Icon_ItemMisc_herb_0001",
            "IconSprites:Icon_ItemMisc_herb_0002",
            "IconSprites:Icon_ItemMisc_herb_0003",
            "IconSprites:Icon_ItemMisc_herb_0004",
            "IconSprites:Icon_ItemMisc_meat_0001",
            "IconSprites:Icon_ItemMisc_meat_0002",
            "IconSprites:Icon_ItemMisc_meat_0003",
            "IconSprites:Icon_ItemMisc_meat_0004",
            "IconSprites:Icon_ItemMisc_letter_0001",
            "IconSprites:Icon_ItemMisc_letter_0002",
            "IconSprites:Icon_ItemMisc_letter_0003",
            "IconSprites:Icon_ItemMisc_letter_0004",
            "IconSprites:Icon_ItemMisc_gadget_0001",
            "IconSprites:Icon_ItemMisc_gadget_0002",
            "IconSprites:Icon_ItemMisc_gadget_0003",
            "IconSprites:Icon_ItemMisc_gadget_0004",
            "IconSprites:Icon_ItemMisc_pick_0001",
            "IconSprites:Icon_ItemMisc_potion_0001",
            "IconSprites:Icon_ItemMisc_potion_0002",
            "IconSprites:Icon_ItemMisc_potion_0003",
            "IconSprites:Icon_ItemMisc_potion_0004",
            "IconSprites:Icon_ItemMisc_stone_0001",
            "IconSprites:Icon_ItemMisc_stone_0003",
            "IconSprites:Icon_ItemMisc_stone_0004",
            "IconSprites:Icon_ItemMisc_tool_0001",
            "IconSprites:Icon_ItemMisc_tool_0002",
            "IconSprites:Icon_ItemMisc_tool_0003",
            "IconSprites:Icon_ItemMisc_tool_0004",
            "IconSprites:Icon_ItemMisc_tooth_0001",
            "IconSprites:Icon_ItemMisc_tooth_0002",
            "IconSprites:Icon_ItemMisc_tooth_0003",
            "IconSprites:Icon_ItemMisc_tooth_0004",
            "IconSprites:Icon_ItemWeaponSword_sword2H_0001",
            "IconSprites:Icon_ItemWeaponSword_sword2H_0002",
            "IconSprites:Icon_ItemWeaponSword_sword2H_0003",
            "IconSprites:Icon_ItemWeaponSword_sword2H_0004",
            "IconSprites:Icon_TradeskillTalent_Architect_Book_01",
            "IconSprites:Icon_TradeskillTalent_Architect_Book_02",
            "IconSprites:Icon_TradeskillTalent_Architect_Book_03",
            "IconSprites:Icon_TradeskillTalent_Architect_Book_04",
            "IconSprites:Icon_ItemArmorFace_UI_Item_Arcane_Face",
            "IconSprites:Icon_ItemArmorFace_UI_Item_Battle_Face",
            "IconSprites:Icon_ItemArmorFace_UI_Item_Focal_Face",
            "IconSprites:Icon_ItemArmorFace_UI_Item_Reflex_Face",
            "IconSprites:Icon_ItemArmorWaist_UI_Item_Arcane_Buckle",
            "IconSprites:Icon_ItemArmorWaist_UI_Item_Battle_Buckle",
            "IconSprites:Icon_ItemMisc_EnergizedHeavyWater",
            "IconSprites:Icon_ItemMisc_DynamicOmniplasm",
            "IconSprites:Icon_ItemMisc_AcceleratedOmniplasm",
            "IconSprites:Icon_ItemMisc_AntiEntropicFuel",
            "IconSprites:Icon_ItemMisc_AdvancedOmniplasm",
            "IconSprites:Icon_ItemMisc_AirEnergyBall",
            "IconSprites:Icon_ItemMisc_AncientWood",
            "IconSprites:Icon_ItemMisc_AncestralForceStone",
            "IconSprites:Icon_ItemMisc_AnnihiliteIngot",
            "IconSprites:Icon_ItemMisc_Anniversary_BoomBox",
            "IconSprites:Icon_ItemMisc_Anniversary_Cupcake",
            "IconSprites:Icon_ItemMisc_Anniversary_LootBox",
            "IconSprites:Icon_ItemMisc_Anniversary_Rowsdower",
            "IconSprites:Icon_ItemMisc_Boom_Box",
            "IconSprites:Icon_ItemMisc_GenericVoucher",
            "IconSprites:Icon_ItemMisc_Icons_Firework_NewYear",
            "IconSprites:Icon_ItemMisc_Icon_Exploding_Squirg",
            "IconSprites:Icon_ItemMisc_Icon_Generic_House_Gift",
            "IconSprites:Icon_ItemMisc_Blood",
            "IconSprites:Icon_ItemMisc_Magma_Grenade",
            "IconSprites:Icon_ItemMisc_EMP_Grenade",
            "IconSprites:Icon_ItemMisc_Eldan_Grenade",
            "IconSprites:Icon_ItemMisc_UI_Item_Bomb",
            "IconSprites:Icon_ItemWeapon_Generic_Detonator_02",
            "IconSprites:Icon_ItemWeapon_Generic_Tech_Bomb",
            "IconSprites:Icon_ItemWeapon_EMP_Detonator",
            "IconSprites:Icon_ItemWeapon_Eldan_Detonator",
            "IconSprites:Icon_ItemWeapon_Flash_Detonator",
            "IconSprites:Icon_ItemWeapon_Frost_Detonator",
            "IconSprites:Icon_ItemWeapon_Magma_Detonator",
            "IconSprites:Icon_ItemWeapon_Sticky_Detonator",
            "IconSprites:Icon_ItemWeapon_Toxic_Detonator",
            "IconSprites:Icon_ItemWeapon_Water_Detonator",
            "IconSprites:Icon_ItemWeapon_Eldan_Grenade",
            "IconSprites:Icon_ItemWeapon_Flash_Grenade",
            "IconSprites:Icon_ItemWeapon_Frost_Grenade",
            "IconSprites:Icon_ItemWeapon_Magma_Grenade",
            "IconSprites:Icon_ItemWeapon_Sticky_Grenade",
            "IconSprites:Icon_ItemWeapon_Toxic_Grenade",
            "IconSprites:Icon_ItemWeapon_Water_Grenade",
            "IconSprites:Icon_ItemMisc_Canteen",
            "IconSprites:Icon_ItemMisc_Bottle_01",
            "IconSprites:Icon_ItemMisc_Bottle_02",
            "IconSprites:Icon_ItemMisc_BioMemeticMud",
            "IconSprites:Icon_ItemMisc_dart_board",
            "IconSprites:Icon_ItemMisc_Feather",
            "IconSprites:Icon_ItemMisc_Flower_01",
            "IconSprites:Icon_ItemMisc_Flower_02",
            "IconSprites:Icon_ItemMisc_Flower_03",
            "IconSprites:Icon_ItemMisc_UI_Item_Lopp",
            "IconSprites:Icon_ItemMisc_UncorruptibleSoulstone",
            "IconSprites:Icon_ItemMisc_Generic_Torch",
            "IconSprites:Icon_ItemMisc_Candle",
            "IconSprites:Icon_ItemMisc_UI_Item_Candles",
            "IconSprites:Icon_ItemMisc_Burger",
            "IconSprites:Icon_ItemMisc_Glowmelon_Pie",
            "IconSprites:Icon_ItemMisc_Gourmet_pultry",
            "IconSprites:Icon_ItemMisc_Grilled_steak",
            "IconSprites:Icon_ItemMisc_Grilled_fish_filet",
            "IconSprites:Icon_ItemMisc_Grumgourd_pie",
            "IconSprites:Icon_ItemMisc_Juicy_Pultry",
            "IconSprites:Icon_ItemMisc_Meat_kabob",
            "IconSprites:Icon_ItemMisc_Meat_pasta",
            "IconSprites:Icon_ItemMisc_Meat_pie",
            "IconSprites:Icon_ItemMisc_BaconUncooked",
            "IconSprites:Icon_ItemMisc_Bowlofsoup_broth",
            "IconSprites:Icon_ItemMisc_Bowlofsoup_chunky",
            "IconSprites:Icon_ItemMisc_Bowlofsoup_creamy",
            "IconSprites:Icon_ItemMisc_Bowlofsoup_tomato",
            "IconSprites:Icon_ItemMisc_Shredded_Meat",
            "IconSprites:Icon_ItemMisc_Bread",
            "IconSprites:Icon_ItemMisc_Bug_kabobs",
            "IconSprites:Icon_ItemMisc_Bug_pasta",
            "IconSprites:Icon_ItemMisc_Bug_ricebowl",
            "IconSprites:Icon_ItemMisc_BlueRenewshroom",
            "IconSprites:Icon_ItemMisc_Binoculars",
            "IconSprites:Icon_ItemMisc_EarthEnergyBall",
            "IconSprites:Icon_ItemMisc_LifeEnergyBall",
            "IconSprites:Icon_ItemMisc_LogicEnergyBall",
            "IconSprites:Icon_ItemMisc_WaterEnergyBall",
            "IconSprites:Icon_ItemMisc_LustrousXenolithicStone",
            "IconSprites:Icon_ItemMisc_AugmentedLeather",
            "IconSprites:Icon_ItemMisc_UI_Item_Medpack",
            "IconSprites:Icon_ItemMisc_UI_Item_Potion_001",
            "IconSprites:Icon_ItemMisc_Venom",
            "IconSprites:Icon_ItemMisc_UI_Item_Sammich",
            "IconSprites:Icon_ItemMisc_Gadget_01",
            "IconSprites:Icon_ItemMisc_Gadget_02",
            "IconSprites:Icon_ItemMisc_Gadget_03",
            "IconSprites:Icon_ItemMisc_Gadget_04",
            "IconSprites:Icon_ItemMisc_Gadget_05",
            "IconSprites:Icon_ItemMisc_Coin_01",
            "IconSprites:Icon_ItemMisc_Coin_02",
            "IconSprites:Icon_ItemMisc_Claw_01",
            "IconSprites:Icon_ItemMisc_Claw_02",
            "IconSprites:Icon_ItemMisc_Data_Rod",
            "IconSprites:Icon_ItemMisc_DiamondGem",
            "IconSprites:Icon_ItemMisc_DominionIcon",
            "IconSprites:Icon_ItemMisc_ExileIcon",
            "IconSprites:Icon_ItemMisc_EldanInsignia",
            "IconSprites:Icon_ItemMisc_EldanPowerFragment",
            "IconSprites:Icon_ItemMisc_EldenPowercore",
            "IconSprites:Icon_ItemMisc_EldenInfuser",
            "IconSprites:Icon_ItemMisc_Generic_magic_sparkle",
            "IconSprites:Icon_ItemMisc_GenericVoucher",
            "IconSprites:Icon_ItemMisc_Training_dummy",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Air_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Air_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Air_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Air_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Air_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_AirWater_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_AirWater_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_AirWater_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_AirWater_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_AirWater_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Earth_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Earth_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Earth_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Earth_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Earth_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_EarthFire_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_EarthFire_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_EarthFire_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_EarthFire_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_EarthFire_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Fire_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Fire_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Fire_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Fire_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Fire_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_FireAir_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_FireAir_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_FireAir_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_FireAir_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_FireAir_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Water_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Water_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Water_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Water_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_Water_04",
            "IconSprites:Icon_TradeskillAdditiveTechnology_WaterEarth_00",
            "IconSprites:Icon_TradeskillAdditiveTechnology_WaterEarth_01",
            "IconSprites:Icon_TradeskillAdditiveTechnology_WaterEarth_02",
            "IconSprites:Icon_TradeskillAdditiveTechnology_WaterEarth_03",
            "IconSprites:Icon_TradeskillAdditiveTechnology_WaterEarth_04",
            "icon_boost_blue",
            "icon_boost_green",
            "icon_boost_purple",
            "icon_boost_red",
            "icon_stuffed",
            "icon_food_moxie",
            "icon_food_grit",
            "icon_potion",
            "icon_medishot-01",
            "icon_medishot-02",
            "icon_medishot-03",
            "icon_medishot-04",
            "icon_medishot-05",
            "icon_fieldtech-01",
            "icon_fieldtech-02",
            "icon_fieldtech-03",
            "icon_fieldtech-04",
            "icon_fieldtech-05",
            "icon_fieldtech-06",
            "icon_fieldtech-07",
            "icon_fieldtech-08",
            "icon_fieldtech-09",
            "icon_fieldtech-10",
            "icon_fieldtech-11",
        },
        ["animations"] = {
            "PlayerPathContent_TEMP:spr_Crafting_TEMP_Stretch_QuestZonePulse",
            "MTX:UI_BK3_MTX_LoyaltyTierBottom_Anim",
            "LoginIncentives:sprLoginIncentives_Spinner",
            "LoginIncentives:sprLoginIncentives_SpinnerComposite",
            "LoginIncentives:sprLoginIncentives_SpinnerReverse",
            "zonemap:UI_ZoneMap_RewardProgressEndResultsComposite",
            "zonemap:UI_ZoneMap_RewardProgressEndResultSpinner1",
            "zonemap:UI_ZoneMap_RewardProgressEndResultSpinner2",
            "GachaSprites:UI_Gacha_Fortune_Anim",
            "ClientSprites:SpellChargeEdgeGlow",
            "ClientSprites:sprItem_NewQuest",
            "ClientSprites:sprItem_New",
            "CRB_Anim_Spinner:sprAnim_SpinnerSmall",
            "CSI:anim_CSI_IconHandHold",
            "CSI:anim_CSI_IconHandPress",
            "charactercreate:sprCharC_btnNext_Pulse",
        },
        ["bars"] = {
            ["linear"] = {
                "bar_basic",
                "bar_fire",
                "bar_metal",
                "bar_minimalist",
                "bar_aluminium",
                "bar_angelique",
                "bar_antonia",
                "bar_armory",
                "bar_banto",
                "bar_bettina",
                "bar_flat",
                "bar_jasmin",
                "bar_larissa",
                "bar_otravi",
                "bar_sam",
                "bar_stella",
                "bar_empathy1",
                "bar_empathy2",
                "bar_empathy3",
                "bar_empathy4",
                "bar_empathy5",
                "bar_empathy6",
                "bar_empathy7",
                "bar_empathy8",
                "bar_empathy9",
                "bar_empathy10",
                "bar_empathy11",
                "bar_empathy12",
                "bar_fer1",
                "bar_fer2",
                "bar_fer3",
                "bar_fer4",
                "bar_fer5",
                "bar_fer6",
                "bar_fer7",
                "bar_fer8",
                "bar_fer9",
                "bar_fer10",
                "bar_fer11",
                "bar_fer12",
                "bar_fer13",
                "bar_fer14",
                "bar_phish1",
                "bar_phish2",
                "bar_phish3",
                "bar_phish4",
                "bar_phish5",
                "bar_phish6",
                "bar_phish7",
                "bar_phish8",
                "bar_phish9",
                "bar_phish10",
                "bar_phish11",
                "bar_phish12",
                "bar_phish13",
                "bar_phish14",
                "bar_phish15",
                "bar_phish16",
                "bar_phish17",
                "bar_phish18",
                "bar_phish19",
                "bar_phish20",
                "bar_phish21",
                "bar_phish22",
                "bar_phish23",
                "bar_phish24",
                "bar_phish25",
                "bar_phish26",
                "bar_castbar1",
                "bar_castbar2",
                "bar_castbar3",
                "tex_001",
                "tex_002",
                "tex_003",
                "tex_004",
                "tex_005",
                "tex_006",
                "tex_007",
                "tex_008",
                "tex_009",
                "tex_010",
                "tex_011",
                "tex_012",
                "tex_013",
                "tex_014",
                "tex_015",
                "tex_016",
                "tex_017",
                "tex_018",
                "tex_019",
                "tex_020",
                "tex_021",
                "tex_022",
                "tex_023",
                "tex_024",
                "tex_025",
                "tex_026",
                "tex_027",
                "tex_028",
                "tex_029",
                "tex_030",
                "tex_031",
                "tex_032",
                "tex_033",
                "tex_034",
                "tex_035",
                "bar_gradient1",
                "bar_gradient2",
                "bar_gradient3",
                "bar_action_green",
                "bar_action_orange",
                "bar_action_red",
                "bar_action_blue",
                "bar_action_purple",
                "bar_action_white",
                "bar_actionbar_blue",
                "bar_actionbar_orange",
                "bar_actionbar_white",
                "bar_datachron_glow",
                "bar_datachron_green",
                "bar_datachron_orange",
                "bar_datachron_red",
                "bar_thin_red",
                "bar_thin_orange",
                "bar_telegraph_red",
                "bar_telegraph_orange",
                "bar_telegraph_gray",
                "bar_telegraph_purple",
                "bar_telegraph_white",
                "bar_telegraph_blue",
                "bar_raid_green",
                "bar_raid_orange",
                "bar_raid_red",
                "bar_raid_small_green",
                "bar_raid_small_orange",
                "bar_raid_small_red",
                "custom_001",
                "custom_002",
                "custom_003",
                "custom_004",
                "custom_005",
                "custom_006",
                "custom_round",
                "custom_thin",
                "custom_oblique",
                "custom_square",
                "bg_001",
            },
            ["radial"] = {
                "BasicSprites:WhiteCircle",
                "circle_thin",
                "circle_thin_half_top",
                "circle_thin_half_right",
                "circle_thin_half_bottom",
                "circle_thin_half_left",
                "circle_medium",
                "circle_medium_half_top",
                "circle_medium_half_right",
                "circle_medium_half_bottom",
                "circle_medium_half_left",
                "circle_thick",
                "circle_thick_half_top",
                "circle_thick_half_right",
                "circle_thick_half_bottom",
                "circle_thick_half_left",
                "circle_lines",
                "circle_lines_half_top",
                "circle_lines_half_right",
                "circle_lines_half_bottom",
                "circle_lines_half_left",
            },
        },
    }

    self.soundFiles = {
        ["alarm"] = "Sounds\\alarm.wav",
        ["alert"] = "Sounds\\alert.wav",
        ["beware"] = "Sounds\\beware.wav",
        ["cat"] = "Sounds\\cat.wav",
        ["come-on-1"] = "Sounds\\come-on-1.wav",
        ["come-on-come-on-1"] = "Sounds\\come-on-come-on-1.wav",
        ["espark"] = "Sounds\\espark.wav",
        ["focus"] = "Sounds\\focus.wav",
        ["get-away-from-me"] = "Sounds\\get-away-from-me.wav",
        ["go-go"] = "Sounds\\go-go.wav",
        ["go-go-go"] = "Sounds\\go-go-go.wav",
        ["go-head"] = "Sounds\\go-head.wav",
        ["huh"] = "Sounds\\huh.wav",
        ["im-in-touble"] = "Sounds\\im-in-touble.wav",
        ["info"] = "Sounds\\info.wav",
        ["long"] = "Sounds\\long.wav",
        ["okay-come-on"] = "Sounds\\okay-come-on.wav",
        ["pssst-1"] = "Sounds\\pssst-1.wav",
        ["pssst-2"] = "Sounds\\pssst-2.wav",
        ["rrrou-1"] = "Sounds\\rrrou-1.wav",
        ["rrrou-2"] = "Sounds\\rrrou-2.wav",
        ["shh-shh"] = "Sounds\\shh-shh.wav",
        ["sneeze"] = "Sounds\\sneeze.wav",
        ["sonar"] = "Sounds\\sonar.wav",
        ["u-hmm-1"] = "Sounds\\u-hmm-1.wav",
        ["unbelievable"] = "Sounds\\unbelievable.wav",
        ["urghhh"] = "Sounds\\urghhh.wav",
        ["vengeance"] = "Sounds\\vengeance.wav",
        ["wait-a-minute"] = "Sounds\\wait-a-minute.wav",
        ["what-2"] = "Sounds\\what-2.wav",
        ["you-can-do-it"] = "Sounds\\you-can-do-it.wav",
        ["you-got-it-1"] = "Sounds\\you-got-it-1.wav",
        ["youre-almost-there"] = "Sounds\\youre-almost-there.wav",
        ["youre-my-man"] = "Sounds\\youre-my-man.wav",
        ["run-away"] = "Sounds\\run-away.wav",
        ["inferno"] = "Sounds\\inferno.wav",
        ["burn"] = "Sounds\\burn.wav",
        ["destruction"] = "Sounds\\destruction.wav",
    }

    self.stats = {
        ["Basic Attributes"] = {"Health","Shield","Absorb","Focus","Class Resource","Interrupt Armor","Assault Power","Support Power"},
        ["Offensive Attributes"] = {"Strikethrough","Critical Hit Chance","Critical Hit Severity","Multi-Hit Chance","Multi-Hit Severity","Vigor","Armor Pierce"},
        ["Defensive Attributes"] = {"Physical Mitigation","Technology Mitigation","Magic Mitigation","Glance Chance","Glance Mitigation","Critical Mitigation","Deflect Chance","Deflect Critical Hit Chance"},
        ["Utility Attributes"] = {"Lifesteal","Focus Pool","Focus Recovery Rate","Reflect Chance","Reflect Damage","Intensity"},
        ["PvP Attributes"] = {"PvP Damage","PvP Healing","PvP Defense"},
    }

    self.triggerTypes = {
        ["Ability"] = {
            label = "Ability",
            tooltip = "Checks if the specified Ability is part of your current Actionset.",
        },
        ["Attribute"] = {
            label = "Attribute",
            tooltip = "Track all kinds of stats on player, target, focus or tot unit.",
        },
        ["Cast"] = {
            label = "Cast",
            tooltip = "Track casts of player, target, focus or tot unit.",
        },
        ["Cooldown"] = {
            label = "Cooldown",
            tooltip = "Tracks the cooldowns of your abilities. Recommended setting to fail in behaviour dropdown.",
        },
        ["Buff"] = {
            label = "Buff",
            tooltip = "Tracks buffs on player, target, focus or tot unit.",
        },
        ["Debuff"] = {
            label = "Debuff",
            tooltip = "Tracks debuffs on player, target, focus or tot unit.",
        },
        ["Gadget"] = {
            label = "Gadget",
            tooltip = "Checks the cooldown of your currently equipped gadget.",
        },
        ["Innate"] = {
            label = "Innate",
            tooltip = "Tracks the cooldown of your innate abilities.",
        },
        ["Unit"] = {
            label = "Unit",
            tooltip = "Tracks unit specific properties and circumstances.",
        },
        ["AMP Cooldown"] = {
            label = "AMP Cooldown",
            tooltip = "Tracks the duration since when AMP related buffs/debuffs are missing to calculate the remaining cooldown time.",
        },
        ["Keybind"] = {
            label = "Keybind",
            tooltip = "Tracks the keybind you've set. When the key is pressed, the trigger will activate until the specified duration ends.",
        },
        ["Script"] = {
            label = "Script",
            tooltip = "Scriptable trigger for advanced users. Code must return a boolean (true/false).",
        },
        ["Threat"] = {
            label = "Threat",
            tooltip = "Tracks your threat on target, focus or tot unit."
        }
    }

    self.media = Apollo.GetAddon("LUI_Media")

    -- Load Settings Form
    self.wndSettings = Apollo.LoadForm(self.parent.xmlDoc, "LUIAura_Config", nil, self)
    self.wndSettings:SetSizingMinimum(900, 700)

    local screenWidth,screenHeight = Apollo.GetScreenSize()
    local configWidth = math.abs(self.parent.config.offset.left) + math.abs(self.parent.config.offset.right) + 50
    local configHeight = math.abs(self.parent.config.offset.top) + math.abs(self.parent.config.offset.bottom) + 50

    if (configWidth > screenWidth) or (configHeight > screenHeight) then
        self.wndSettings:SetAnchorOffsets(-450,-350,450,350)
    else
        self.wndSettings:SetAnchorOffsets(
            self.parent.config.offset.left,
            self.parent.config.offset.top,
            self.parent.config.offset.right,
            self.parent.config.offset.bottom
        )
    end

    if not self.text.classes then
        self.text.classes = {}

        for k,v in pairs(GameLib.CodeEnumClass) do
            self.text.classes[tostring(v)] = k
        end
    end

    if not self.text.hostility then
        self.text.hostility = {}

        for k,v in pairs(Unit.CodeEnumDisposition) do
            self.text.hostility[tostring(v)] = k
        end
    end

    if not self.text.rank then
        self.text.rank = {}

        for k,v in pairs(Unit.CodeEnumRank) do
            self.text.rank[tostring(v)] = k
        end
    end

    if not self.text.difficulty then
        self.text.difficulty = {}

        for k,v in pairs(Unit.CodeEnumEliteness) do
            self.text.difficulty[tostring(v)] = k
        end
    end

    -- Show Auras / Hide Settings
    self.wndSettings:FindChild("Auras"):Show(true, true)
    self.wndSettings:FindChild("Settings"):Show(false, true)

    self.wndSettings:FindChild("BGHolo_Full"):Show(false,true)
    self.wndSettings:FindChild("BGHolo"):Show(true,true)

    -- Action Button Timer
    self.timer = ApolloTimer.Create(0.01, true, "OnActionButton", self)

    -- Build Settings
    self:BuildSettings()

    -- Find System Chat Channel
    for idx, channelCurrent in ipairs(ChatSystemLib.GetChannels()) do
        if channelCurrent:GetName() == "System" then
            self.system = channelCurrent:GetUniqueId()
        elseif channelCurrent:GetName() == "Systeme" then
            self.system = channelCurrent:GetUniqueId()
        end
    end
end

function Settings:Print(message)
    if self.system then
        ChatSystemLib.PostOnChannel(self.system,message,"")
    else
        Print(message)
    end
end

function Settings:ShowChangelog()
    if not self.wndChangelog then
        self.wndChangelog = Apollo.LoadForm(self.parent.xmlDoc, "LUIChangelog", nil, self)
    end

    local changelog = {
        [1] = {1,"Added Redmoon Terror to Zone-Whitelist."},
        [2] = {1,"Updated API Version."},
    }

    local nHeight = 0

    for idx,message in ipairs(changelog) do
        local wndChange = Apollo.LoadForm(self.parent.xmlDoc, "Items:Changelog", self.wndChangelog:FindChild("Changelog"), self)
        wndChange:FindChild("Message"):SetText(message[2])

        if message[1] > 1 then
            local nLeft, nTop, nRight, nBottom = wndChange:GetAnchorOffsets()
            wndChange:SetAnchorOffsets(nLeft,nTop,nRight,(wndChange:FindChild("Message"):GetHeight()*message[1])+14)
        end

        nHeight = nHeight + wndChange:GetHeight()
    end

    if nHeight < self.wndChangelog:FindChild("Changelog"):GetHeight() then
        local nLeft, nTop, nRight, nBottom = self.wndChangelog:GetAnchorOffsets()
        local newHeight = (nHeight + 210) / 2
        self.wndChangelog:SetAnchorOffsets(nLeft, newHeight*-1,nRight,newHeight)
    end

    self.wndChangelog:FindChild("Label"):SetText("LUI Aura v"..tostring(self.parent.version))
    self.wndChangelog:FindChild("Changelog"):ArrangeChildrenVert()
    self.wndChangelog:Show(true)
end

function Settings:OnChangelogBtn(wndHandler,wndControl)
    if not wndHandler == wndControl then
        return
    end

    if self.wndChangelog then
        self.wndChangelog:Show(false)
        self.wndChangelog:Destroy()
    end
end

function Settings:OnDonate(wndHandler, wndControl)
    self.wndSettings:FindChild("Seperator"):Show(not wndHandler:IsChecked(),true)
    self.wndSettings:FindChild("DonateSeperator"):Show(wndHandler:IsChecked(),true)
    self.wndSettings:FindChild("DonateForm"):Show(wndHandler:IsChecked())
end

function Settings:OnDonationChanged(wndHandler, wndControl)
    local amount = self.wndSettings:FindChild("DonateForm"):FindChild("CashWindow"):GetAmount()
    local recipient = "Loui NaN"

    if GameLib.GetPlayerUnit():GetFaction() ~= 166 then
        recipient = "Loui x"
    end

    if amount > 0 then
        self.wndSettings:FindChild("DonateForm"):FindChild("DonateSendBtn"):SetActionData(GameLib.CodeEnumConfirmButtonType.SendMail, recipient, "Jabbit", "LUI Aura Donation", tostring(GameLib.GetPlayerUnit():GetName()) .. " donated something for you!", nil, MailSystemLib.MailDeliverySpeed_Instant, 0, self.wndSettings:FindChild("DonateForm"):FindChild("CashWindow"):GetCurrency())
        self.wndSettings:FindChild("DonateForm"):FindChild("DonateSendBtn"):Enable(true)
    else
        self.wndSettings:FindChild("DonateForm"):FindChild("DonateSendBtn"):Enable(false)
    end
end

function Settings:OnDonationSent()
    self.wndSettings:FindChild("DonateBtn"):SetCheck(false)
    self.wndSettings:FindChild("DonateForm"):Show(false)
    self.wndSettings:FindChild("DonateSeperator"):Show(false)
    self.wndSettings:FindChild("DonateForm"):FindChild("CashWindow"):SetAmount(0)
    self.wndSettings:FindChild("DonateForm"):FindChild("DonateSendBtn"):Enable(false)
    self:Print("Thank you very much!!! <3")
end

function Settings:OnActionButton()
    local progress

    if self.wndDeleteBtn and self.wndDeleteBtn:FindChild("timer") then
        progress = self.wndDeleteBtn:FindChild("timer"):GetProgress() + 0.006

        if progress >= 1 then
            self.wndDeleteBtn:AddEventHandler("ButtonSignal", "OnDelete")
            self.wndDeleteBtn:FindChild("timer"):SetBarColor("White")
            self.wndDeleteBtn:FindChild("timer"):SetProgress(0.999)
            self.timer:Stop()
        else
            self.wndDeleteBtn:FindChild("timer"):SetProgress(progress)
        end
    end
end

function Settings:OnAnimationStart(wndHandler, wndControl)
    if wndControl:GetName() == "DeleteBtn" then
        self.wndDeleteBtn = wndControl
        self.wndDeleteBtn:FindChild("timer"):SetTextColor("UI_BtnTextHoloListFlyby")
        self.timer:Start()
    end
end

function Settings:OnAnimationStop(wndHandler, wndControl)
    if self.wndDeleteBtn and self.wndDeleteBtn:FindChild("timer") then
        self.wndDeleteBtn:RemoveEventHandler("ButtonSignal")
        self.wndDeleteBtn:FindChild("timer"):SetFillSprite("CRB_CharacterCreateSprites:btnCharC_OptionMainFlyby")
        self.wndDeleteBtn:FindChild("timer"):SetBarColor("UI_AlphaPercent35")
        self.wndDeleteBtn:FindChild("timer"):SetTextColor("UI_BtnTextHoloListNormal")
        self.wndDeleteBtn:FindChild("timer"):SetProgress(0)
        self.wndDeleteBtn = nil
        self.timer:Stop()
    end
end

function Settings:OnMouseDown(wndHandler, wndControl)
    if self.wndDeleteBtn ~= nil then
        if self.wndDeleteBtn:FindChild("timer"):GetProgress() >= 0.999 then
            self.wndDeleteBtn:FindChild("timer"):SetFillSprite("CRB_CharacterCreateSprites:btnCharC_OptionMainPressed")
        end
    end
end

function Settings:OnMouseUp(wndHandler, wndControl)
    if self.wndDeleteBtn then
        wndControl:FindChild("timer"):SetFillSprite("CRB_CharacterCreateSprites:btnCharC_OptionMainFlyby")
    end
end

function Settings:OnToggleShare()
    if self.wndShare then
        if self.wndShare:IsShown() then
            self.wndShare:Close()
        else
            self.wndShare:FindChild("Status"):Show(not self.parent.share or not self.parent.share:IsReady(),true)
            self.wndShare:Invoke()
        end
    else
        self.wndShare = Apollo.LoadForm(self.parent.xmlDoc, "ShareForm", nil, self)
        self.wndShare:FindChild("Status"):Show(not self.parent.share or not self.parent.share:IsReady(),true)
    end
end

function Settings:OnSetShare(wndHandler, wndControl)
    if wndHandler ~= wndControl then
        return
    end

    self.parent.sharing = wndControl:IsChecked()
end

function Settings:OnConnect(wndHandler, wndControl)
    if wndHandler ~= wndControl then
        return
    end

    if not self.parent.share or not self.parent.share:IsReady() then
        self:Print("Reconnecting...")
        self.parent:Connect(true)
    else
        self:Print("You are already connected!")
    end
end

function Settings:OnReconnect()
    self.wndShare:FindChild("Status"):Show(false)
    self:Print("Connected!")
end

function Settings:OnReceive(message)
    if type(message.export) ~= "string" then
        return
    end

    if not self.parent.sharing then
        return
    end

    local JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage

    local wndShareItem = Apollo.LoadForm(self.parent.xmlDoc, "Items:ShareItem", self.wndShare:FindChild("List"), self)
    wndShareItem:FindChild("ItemName"):SetText(message.setting.name)
    wndShareItem:FindChild("ItemType"):SetText(message.headline .. " from ".. message.sender)
    wndShareItem:FindChild("CopyButton"):SetActionData(GameLib.CodeEnumConfirmButtonType.CopyToClipboard, JSON.encode(message))

    self.wndShare:FindChild("List"):ArrangeChildrenVert(0)
end

function Settings:OnDeleteShareItem(wndHandler, wndControl)
    wndControl:GetParent():Destroy()
    self.wndShare:FindChild("List"):ArrangeChildrenVert(0)
end

function Settings:Strip(setting,eType)
    if eType == "group" then
        if setting.auras ~= nil then
            for _,aura in pairs(setting.auras) do
                aura = self.parent:RemoveDefaults(aura,setting)
                aura = self:Strip(aura,"aura")
            end
        end

        setting = self.parent:RemoveDefaults(setting, self.parent:Copy(self.parent.options.group))
    elseif eType == "aura" then
        if setting.triggers ~= nil then
            for _,trigger in pairs(setting.triggers) do
                trigger = self:Strip(trigger,"trigger")
            end
        end
    elseif eType == "trigger" then
        setting = self.parent:RemoveDefaults(setting, self.parent:Copy(self.parent.options.trigger))

        if setting.triggers ~= nil then
            for _,trigger in pairs(setting.triggers) do
                trigger = self:Strip(trigger,"trigger")
            end
        end
    end

    return setting
end

function Settings:OnSend()
    local tMessage = {
        sender = GameLib.GetPlayerUnit():GetName()
    }

    if self.wndLastGroupSelected ~= nil then
        tMessage.headline = "Aura Group"
        tMessage.export = "group"
    elseif self.wndLastAuraSelected ~= nil then
        tMessage.headline = "Aura"
        tMessage.export = "aura"
    elseif self.wndLastTriggerSelected ~= nil then
        tMessage.headline = "Trigger"
        tMessage.export = "trigger"
    elseif self.wndLastChildSelected ~= nil then
        tMessage.headline = "Trigger"
        tMessage.export = "trigger"
    else
        self:Print("Please choose a setting to share.")
        return
    end

    tMessage.setting = self:Strip(self.parent:Copy(self:GetVar()),tMessage.export)

    local JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
    local strMsg = JSON.encode(tMessage)

    if self.parent.share then
        self.parent.share:SendMessage(tostring(strMsg))

        if tMessage.setting.name ~= nil then
            self:Print("You shared " .. tMessage.setting.name .. " successful.")
        end
    else
        self:Print("Sharing not possible, please reload your UI. /reloadui")
    end
end

function Settings:OnToggleMenu()
    if self.wndSettings then
        if self.wndSettings:IsShown() then
            self.wndSettings:Close()
        else
            self.wndSettings:Invoke()
        end
    else
        self:OnLoad()
    end
end

function Settings:BuildSettings()
    self.wndLastGroupSelected = nil
    self.wndLastAuraSelected = nil
    self.wndLastTriggerSelected = nil
    self.wndLastChildSelected = nil

    local wndMeasure = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:MainGroupAura", nil, self)
    self.nMainGroupHeight = wndMeasure:GetHeight()
    wndMeasure:Destroy()

    wndMeasure = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:TopGroupAura", nil, self)
    self.nTopGroupHeight = wndMeasure:GetHeight()
    wndMeasure:Destroy()

    wndMeasure = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:MiddleGroupAura", nil, self)
    self.nMiddleGroupHeight = wndMeasure:GetHeight()
    wndMeasure:Destroy()

    wndMeasure = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:BottomItem", nil, self)
    self.nBottomItemHeight = wndMeasure:GetHeight()
    wndMeasure:Destroy()

    -- Hide Donation Form
    self.wndSettings:FindChild("DonateForm"):Show(false,true)
    self.wndSettings:FindChild("DonateSeperator"):Show(false,true)
    self.wndSettings:FindChild("DonateBtn"):Show((GameLib.GetRealmName() == "Jabbit"),true)
    self.wndSettings:FindChild("DonateForm"):FindChild("DonateSendBtn"):Enable(false)

    self:CheckButtons()
    self:BuildTree()
    self:BuildGlobalSettings()
end

-- ########################################################################################################################################
-- # BUILD NAVIGATION
-- ########################################################################################################################################

function Settings:OnSettings(wndHandler, wndControl)
    local value = wndHandler:IsChecked()

    self.wndSettings:FindChild("Settings"):Show(value,true)
    self.wndSettings:FindChild("Auras"):Show(not value,true)
    self.wndSettings:FindChild("MainNav"):Show(not value,true)
    self.wndSettings:FindChild("BGHolo_Full"):Show(value,true)
    self.wndSettings:FindChild("BGHolo"):Show(not value,true)

    local containerWidth = self.wndSettings:FindChild("Global"):FindChild("AuraList"):GetWidth() / 2
    local count = 0

    for _,shareItem in pairs(self.wndSettings:FindChild("Global"):FindChild("AuraList"):GetChildren()) do
        shareItem:SetAnchorPoints(0,0,0,0)
        shareItem:SetAnchorOffsets(0,0,containerWidth,80)
        count = count + 1
    end

    self.wndSettings:FindChild("Global"):FindChild("Container"):SetAnchorOffsets(0,0,0,(225+(80*(math.ceil(count/2)))))
    self.wndSettings:FindChild("Global"):RecalculateContentExtents()
    self.wndSettings:FindChild("Global"):FindChild("AuraList"):ArrangeChildrenTiles()

    self:ResetAuras()
    self:CheckButtons()
end

function Settings:BuildTree(mainId,topId,midId,bottomId)
    local wndLeftScroll = self.wndSettings:FindChild("LeftScroll")
    wndLeftScroll:DestroyChildren()

    if not self.parent.config.groups then
        return
    end

    for groupId, group in ipairs(self.parent.config.groups) do
        local wndMainGroup = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:MainGroupAura", wndLeftScroll, self)
        local wndMainContents = wndMainGroup:FindChild("GroupContents")
        wndMainGroup:SetData(groupId)

        for auraId, aura in ipairs(self.parent.config.groups[groupId].auras) do
            local wndTopGroup = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:TopGroupAura", wndMainContents, self)
            local wndTopContents = wndTopGroup:FindChild("GroupContents")
            wndTopGroup:SetData(auraId)

            for triggerId, trigger in ipairs(aura.triggers) do
                local wndMiddleGroup = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:MiddleGroupAura", wndTopContents, self)
                local wndMidContents = wndMiddleGroup:FindChild("GroupContents")
                wndMiddleGroup:SetData(triggerId)

                if trigger.triggerType == "Group" then
                    for childTriggerId, childTrigger in pairs(trigger.triggers) do
                        local wndBottomGroup = Apollo.LoadForm(self.parent.xmlDoc, "Navigation:BottomItem", wndMidContents, self)
                        wndBottomGroup:SetData(childTriggerId)

                        local wndBottomGroupBtn = wndBottomGroup:FindChild("BottomItemBtn")
                        wndBottomGroupBtn:SetData({wndMainGroup, wndTopGroup, wndMiddleGroup, wndBottomGroup})
                        wndBottomGroupBtn:SetText(childTrigger.name)

                        if mainId == groupId and topId == auraId and midId == triggerId and bottomId == childTriggerId then
                            wndBottomGroupBtn:SetCheck(true)
                            self.wndLastGroupSelected = nil
                            self.wndLastAuraSelected = nil
                            self.wndLastTriggerSelected = nil
                            self.wndLastChildSelected = wndBottomGroupBtn
                            self:BuildRightPanelAuras(wndBottomGroupBtn)
                        end
                    end
                end

                local bMiddleGroupHasChildren = #wndMidContents:GetChildren() > 0
                local wndMiddleGroupBtn = wndMiddleGroup:FindChild("MiddleGroupBtn")

                if bMiddleGroupHasChildren then
                    wndMiddleGroupBtn:RemoveStyleEx("RadioDisallowNonSelection")
                end

                wndMiddleGroupBtn:SetData({wndMainGroup, wndTopGroup, wndMiddleGroup})
                wndMiddleGroupBtn:SetText(trigger.name)

                if bMiddleGroupHasChildren then
                    wndMiddleGroupBtn:FindChild("ExpandBtn"):Show(true)
                else
                    wndMiddleGroupBtn:FindChild("ExpandBtn"):Show(false)
                end
                --wndMiddleGroupBtn:ChangeArt(bMiddleGroupHasChildren and "BK3:btnMetal_ExpandMenu_Med" or "BK3:btnMetal_ExpandMenu_MedClean")

                wndMiddleGroup:FindChild("MiddleExpandBtn"):SetData(wndMiddleGroup)
                wndMiddleGroup:FindChild("MiddleExpandBtn"):Show(false)
                wndMidContents:ArrangeChildrenVert(0)

                if mainId == groupId and topId == auraId and midId == triggerId then
                    wndMiddleGroupBtn:SetCheck(true)
                end

                if not bottomId and mainId == groupId and topId == auraId and midId == triggerId then
                    self.wndLastGroupSelected = nil
                    self.wndLastAuraSelected = nil
                    self.wndLastTriggerSelected = wndMiddleGroupBtn
                    self.wndLastChildSelected = nil
                    self:BuildRightPanelAuras(wndMiddleGroupBtn)
                end
            end

            local bTopGroupHasChildren = #wndTopContents:GetChildren() > 0
            local wndTopGroupBtn = wndTopGroup:FindChild("TopGroupBtn")

            self:StyleButton(wndTopGroupBtn,"aura",aura.enable)

            wndTopGroupBtn:SetData({wndMainGroup,wndTopGroup})
            wndTopGroupBtn:SetText(aura.name)
            wndTopGroupBtn:ChangeArt(bTopGroupHasChildren and "BK3:btnMetal_ExpandMenu_Med" or "BK3:btnMetal_ExpandMenu_MedClean")

            wndTopContents:ArrangeChildrenVert(0)

            if mainId == groupId and topId == auraId then
                wndTopGroupBtn:SetCheck(true)
            end

            if not midId and mainId == groupId and topId == auraId then
                self.wndLastGroupSelected = nil
                self.wndLastAuraSelected = wndTopGroupBtn
                self.wndLastTriggerSelected = nil
                self.wndLastChildSelected = nil
                self:BuildRightPanelAuras(wndTopGroupBtn)
            end
        end

        local bMainGroupHasChildren = #wndMainContents:GetChildren() > 0
        local wndMainGroupBtn = wndMainGroup:FindChild("MainGroupBtn")

        self:StyleButton(wndMainGroupBtn,"group",group.enable)

        wndMainGroupBtn:SetData({wndMainGroup})
        wndMainGroupBtn:SetText(self.parent.config.groups[groupId].name)

        wndMainContents:ArrangeChildrenVert(0)

        if mainId == groupId then
            wndMainGroupBtn:SetCheck(true)
        end

        if not topId and not midId and mainId == groupId then
            self.wndLastGroupSelected = wndMainGroupBtn
            self.wndLastAuraSelected = nil
            self.wndLastTriggerSelected = nil
            self.wndLastChildSelected = nil
            self:BuildRightPanelAuras(wndMainGroupBtn)
        end
    end

    self:ResizeTree()
end

function Settings:StyleButton(button,sType,enable)
    if not button or not sType then
        return
    end

    if sType == "group" then
        if enable == true then
            button:SetNormalTextColor("UI_BtnTextGoldListNormal")
            button:SetPressedTextColor("UI_BtnTextGoldListPressed")
            button:SetFlybyTextColor("UI_BtnTextGoldListFlyby")
            button:SetPressedFlybyTextColor("UI_BtnTextGoldListPressedFlyby")
            button:SetBGColor("ffd7d7d7")
        else
            button:SetNormalTextColor("UI_BtnTextGoldListDisabled")
            button:SetFlybyTextColor("UI_BtnTextGoldListDisabled")
            button:SetPressedTextColor("UI_BtnTextGoldListDisabled")
            button:SetPressedFlybyTextColor("UI_BtnTextGoldListDisabled")
            button:SetBGColor("ff969696")
        end
    end

    if sType == "aura" then
        if enable == true then
            button:SetNormalTextColor("UI_BtnTextGoldListNormal")
            button:SetPressedTextColor("UI_BtnTextGoldListPressed")
            button:SetFlybyTextColor("UI_BtnTextGoldListFlyby")
            button:SetPressedFlybyTextColor("UI_BtnTextGoldListPressedFlyby")
            button:SetBGColor("ffffffff")
        else
            button:SetNormalTextColor("UI_BtnTextGoldListDisabled")
            button:SetFlybyTextColor("UI_BtnTextGoldListDisabled")
            button:SetPressedTextColor("UI_BtnTextGoldListDisabled")
            button:SetPressedFlybyTextColor("UI_BtnTextGoldListDisabled")
            button:SetBGColor("ff969696")
        end
    end
end

function Settings:ResizeTree()
    local wndLeftScroll = self.wndSettings:FindChild("LeftScroll")
    local nVScrollPos = wndLeftScroll:GetVScrollPos()

    for mainKey,wndMainGroup in pairs(wndLeftScroll:GetChildren()) do
        local wndMainContents = wndMainGroup:FindChild("GroupContents")
        local wndMainButton = wndMainGroup:FindChild("MainGroupBtn")
        local nTopHeight = 0

        if wndMainButton:IsChecked() and wndMainContents:IsShown() then
            for key, wndTopGroup in pairs(wndMainContents:GetChildren()) do
                local wndTopContents = wndTopGroup:FindChild("GroupContents")
                local wndTopButton = wndTopGroup:FindChild("TopGroupBtn")
                local nMiddleHeight = 2

                if wndTopButton:IsChecked() and wndTopContents:IsShown() then
                    for key2, wndMiddleGroup in pairs(wndTopContents:GetChildren()) do
                        local nBottomHeight = 1

                        if wndMiddleGroup:FindChild("MiddleExpandBtn"):IsChecked() then
                            wndTopButton:SetCheck(true)
                            nBottomHeight = wndMiddleGroup:FindChild("GroupContents"):ArrangeChildrenVert(0)

                            if nBottomHeight > 0 then
                                nBottomHeight = nBottomHeight + 5
                            end
                        end

                        local nLeft, nTop, nRight, nBottom = wndMiddleGroup:GetAnchorOffsets()
                        wndMiddleGroup:SetAnchorOffsets(nLeft, nTop, nRight, nTop + nBottomHeight + self.nMiddleGroupHeight)
                        nMiddleHeight = nMiddleHeight + nBottomHeight + self.nMiddleGroupHeight
                    end
                end

                local nLeft, nTop, nRight, nBottom = wndTopGroup:GetAnchorOffsets()
                wndTopGroup:SetAnchorOffsets(nLeft, nTop, nRight, nTop + nMiddleHeight + self.nTopGroupHeight)
                nTopHeight = nTopHeight + nMiddleHeight + self.nTopGroupHeight
                wndTopContents:ArrangeChildrenVert(0)
            end

            if nTopHeight > 0 then
                nTopHeight = nTopHeight + 14
            end

            wndMainGroup:FindChild("Divider"):Show(nTopHeight > 0,true)
        end

        local nLeft, nTop, nRight, nBottom = wndMainGroup:GetAnchorOffsets()
        wndMainGroup:SetAnchorOffsets(nLeft, nTop, nRight, nTop + nTopHeight + self.nMainGroupHeight)
        wndMainContents:ArrangeChildrenVert(0)
    end

    wndLeftScroll:ArrangeChildrenVert(0)
    wndLeftScroll:SetVScrollPos(nVScrollPos)
end

function Settings:OnMainGroupSelectAuras(wndHandler, wndControl)
    if self.wndLastGroupSelected == wndControl then
        self:ResetAuras()
        self:CheckButtons()
        return
    elseif not wndHandler or not wndHandler:GetData() then
        return
    end

    wndHandler:SetCheck(true)

    self.wndLastGroupSelected = wndControl
    self.wndLastAuraSelected = nil
    self.wndLastTriggerSelected = nil
    self.wndLastChildSelected = nil

    self:CheckButtons()
    self:BuildRightPanelAuras(wndHandler)
end

function Settings:OnTopGroupSelectAuras(wndHandler, wndControl)
    if self.wndLastAuraSelected == wndControl then
        self.wndLastGroupSelected = nil
        self.wndLastAuraSelected = nil
        self.wndLastTriggerSelected = nil
        self.wndLastChildSelected = nil

        for k, wndMid in pairs(wndHandler:GetParent():FindChild("GroupContents"):GetChildren()) do
            local wndMidBtn = wndMid:FindChild("MiddleGroupBtn")
            wndMid:FindChild("GroupContents"):Show(false)
            wndMid:FindChild("MiddleExpandBtn"):SetCheck(false)
            wndMidBtn:SetCheck(false)
        end

        self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
        self:ResizeTree()
        self:CheckButtons()
        return
    elseif not wndHandler or not wndHandler:GetData() then
        return
    end

    wndHandler:SetCheck(true)

    self.wndLastGroupSelected = nil
    self.wndLastAuraSelected = wndControl
    self.wndLastTriggerSelected = nil
    self.wndLastChildSelected = nil

    self:CheckButtons()
    self:BuildRightPanelAuras(wndHandler)
end

function Settings:OnMoveTrigger(wndHandler,wndControl)
    if wndHandler ~= wndControl then
        return
    end

    local middleGroupBtn = wndControl:GetParent():GetData()

    local groupId = middleGroupBtn[1]:GetData()
    local auraId = middleGroupBtn[2]:GetData()
    local triggerId = middleGroupBtn[3]:GetData()
    local childId = middleGroupBtn[4] and middleGroupBtn[4]:GetData() or nil

    if not groupId or not auraId or not triggerId then
        return
    end

    local direction = (wndControl:GetName() == "UpBtn") and "up" or "down"
    local directionId = (direction == "up") and -1 or 1
    local parent = self.parent.config.groups[groupId].runtime.auras[auraId]
    local sourceMove, sourceChange

    if childId then
        if (direction == "up" and childId == 1) or (direction == "down" and childId == self.parent:Count(parent.triggers[triggerId].triggers)) then
            return
        end
    else
        if (direction == "up" and triggerId == 1) or (direction == "down" and triggerId == self.parent:Count(parent.triggers)) then
            return
        end
    end

    self.parent.pause = true

    if childId then
        local childMove = self.parent:Copy(parent.triggers[triggerId].triggers[childId])
        local childChange = self.parent:Copy(parent.triggers[triggerId].triggers[childId+directionId])

        self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId] = childChange
        self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId+directionId] = childMove

        self:ReplaceSources(parent,tostring(triggerId).."-"..tostring(childId),tostring(triggerId).."-"..tostring(childId+directionId))
        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId,triggerId,childId+directionId)
    else
        local triggerMove = self.parent:Copy(parent.triggers[triggerId])
        local triggerChange = self.parent:Copy(parent.triggers[triggerId+directionId])

        self.parent.config.groups[groupId].auras[auraId].triggers[triggerId] = triggerChange
        self.parent.config.groups[groupId].auras[auraId].triggers[triggerId+directionId] = triggerMove

        self:ReplaceSources(groupId,auraId,tostring(triggerId),tostring(triggerId+directionId))
        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId,triggerId+directionId)
    end

    self.parent.pause = nil
end

function Settings:ReplaceSources(groupId,auraId,s1,s2)
    if not groupId or not auraId or not s1 or not s2 then
        return
    end

    local aura = self.parent.config.groups[groupId].auras[auraId]

    if aura.dynamic ~= nil and aura.dynamic.source ~= nil and aura.dynamic.source ~= "" then
        if string.sub(aura.dynamic.source,0,string.len(s1)) == s1 then
            aura.dynamic.source = s2 .. string.sub(aura.dynamic.source,string.len(s1)+1)
        elseif string.sub(aura.dynamic.source,0,string.len(s2)) == s2 then
            aura.dynamic.source = s1 .. string.sub(aura.dynamic.source,string.len(s2)+1)
        end
    end

    if aura.icon ~= nil and aura.icon.source ~= nil and aura.icon.source ~= "" then
        if string.sub(aura.icon.source,0,string.len(s1)) == s1 then
            aura.icon.source = s2 .. string.sub(aura.icon.source,string.len(s1)+1)
        elseif string.sub(aura.icon.source,0,string.len(s2)) == s2 then
            aura.icon.source = s1 .. string.sub(aura.icon.source,string.len(s2)+1)
        end
    end

    if aura.overlay ~= nil and aura.overlay.source ~= nil and aura.overlay.source ~= "" then
        if string.sub(aura.overlay.source,0,string.len(s1)) == s1 then
            aura.overlay.source = s2 .. string.sub(aura.overlay.source,string.len(s1)+1)
        elseif string.sub(aura.overlay.source,0,string.len(s2)) == s2 then
            aura.overlay.source = s1 .. string.sub(aura.overlay.source,string.len(s2)+1)
        end
    end

    if aura.bar ~= nil and aura.bar.source ~= nil and aura.bar.source ~= "" then
        if string.sub(aura.bar.source,0,string.len(s1)) == s1 then
            aura.bar.source = s2 .. string.sub(aura.bar.source,string.len(s1)+1)
        elseif string.sub(aura.bar.source,0,string.len(s2)) == s2 then
            aura.bar.source = s1 .. string.sub(aura.bar.source,string.len(s2)+1)
        end
    end

    if aura.duration ~= nil and aura.duration.duration ~= nil and aura.duration.duration ~= "" then
        if string.sub(aura.duration.source,0,string.len(s1)) == s1 then
            aura.duration.source = s2 .. string.sub(aura.duration.source,string.len(s1)+1)
        elseif string.sub(aura.duration.source,0,string.len(s2)) == s2 then
            aura.duration.source = s1 .. string.sub(aura.duration.source,string.len(s2)+1)
        end
    end

    if aura.stacks ~= nil and aura.stacks.duration ~= nil and aura.stacks.duration ~= "" then
        if string.sub(aura.stacks.source,0,string.len(s1)) == s1 then
            aura.stacks.source = s2 .. string.sub(aura.stacks.source,string.len(s1)+1)
        elseif string.sub(aura.stacks.source,0,string.len(s2)) == s2 then
            aura.stacks.source = s1 .. string.sub(aura.stacks.source,string.len(s2)+1)
        end
    end

    if aura.charges ~= nil and aura.charges.duration ~= nil and aura.charges.duration ~= "" then
        if string.sub(aura.charges.source,0,string.len(s1)) == s1 then
            aura.charges.source = s2 .. string.sub(aura.charges.source,string.len(s1)+1)
        elseif string.sub(aura.charges.source,0,string.len(s2)) == s2 then
            aura.charges.source = s1 .. string.sub(aura.dynamic.source,string.len(s2)+1)
        end
    end

    if aura.text ~= nil and aura.text.duration ~= nil and aura.text.duration ~= "" then
        if string.sub(aura.text.source,0,string.len(s1)) == s1 then
            aura.text.source = s2 .. string.sub(aura.text.source,string.len(s1)+1)
        elseif string.sub(aura.text.source,0,string.len(s2)) == s2 then
            aura.text.source = s1 .. string.sub(aura.text.source,string.len(s2)+1)
        end
    end
end

function Settings:OnTriggerEnter(wndHandler,wndControl)
    if not wndHandler == wndControl then
        return
    end

    if wndControl and wndControl:GetName() == "MiddleGroupBtn" or wndControl:GetName() == "BottomItemBtn" then
        wndControl:FindChild("UpBtn"):Show(true)
        wndControl:FindChild("DownBtn"):Show(true)
    end
end

function Settings:OnTriggerExit(wndHandler,wndControl)
    if not wndHandler == wndControl then
        return
    end

    if wndControl and wndControl:GetName() == "MiddleGroupBtn" or wndControl:GetName() == "BottomItemBtn" then
        wndControl:FindChild("UpBtn"):Show(false)
        wndControl:FindChild("DownBtn"):Show(false)
    end
end

function Settings:OnMiddleGroupSelectAuras(wndHandler, wndControl)
    if self.wndLastTriggerSelected == wndControl then
        if wndControl:FindChild("ExpandBtn"):IsShown() then
            self.wndLastGroupSelected = nil
            self.wndLastAuraSelected = nil
            self.wndLastTriggerSelected = nil
            self.wndLastChildSelected = nil

            wndHandler:GetParent():FindChild("MiddleExpandBtn"):SetCheck(false)

            for k, wndBottom in pairs(wndHandler:GetParent():FindChild("GroupContents"):GetChildren()) do
                wndBottom:FindChild("BottomItemBtn"):SetCheck(false)
            end

            self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
            self:ResizeTree()
            self:CheckButtons()
            return
        else
            wndControl:SetCheck(true)
            return
        end
    elseif not wndHandler or not wndHandler:GetData() then
        return
    end

    wndHandler:SetCheck(true)

    self.wndLastGroupSelected = nil
    self.wndLastAuraSelected = nil
    self.wndLastTriggerSelected = wndControl
    self.wndLastChildSelected = nil

    self:CheckButtons()
    self:BuildRightPanelAuras(wndHandler)
end

function Settings:OnBottomItemSelect(wndHandler, wndControl)
    if self.wndLastChildSelected == wndControl then
        wndControl:SetCheck(true)
        return
    elseif not wndHandler or not wndHandler:GetData() then
        return
    end

    self.wndLastGroupSelected = nil
    self.wndLastAuraSelected = nil
    self.wndLastTriggerSelected = nil
    self.wndLastChildSelected = wndHandler

    self:CheckButtons()
    self:BuildRightPanelAuras(wndHandler)
end

function Settings:UnselectAllAuras()
    for k, wndMain in pairs(self.wndSettings:FindChild("LeftScroll"):GetChildren()) do
        local wndMainGroupBtn = wndMain:FindChild("MainGroupBtn")
        wndMain:FindChild("GroupContents"):Show(false)
        wndMainGroupBtn:SetCheck(false)

        for key, wndTop in pairs(wndMain:FindChild("GroupContents"):GetChildren()) do
            local wndTopGroupBtn = wndTop:FindChild("TopGroupBtn")
            wndTop:FindChild("GroupContents"):Show(false)
            wndTopGroupBtn:SetCheck(false)

            for key2, wndMid in pairs(wndTop:FindChild("GroupContents"):GetChildren()) do
                local wndMidGroupBtn = wndMid:FindChild("MiddleGroupBtn")
                wndMidGroupBtn:SetCheck(false)
                wndMid:FindChild("MiddleExpandBtn"):SetCheck(false)

                for key3, wndBot in pairs(wndMid:FindChild("GroupContents"):GetChildren()) do
                    local wndBotItemBtn = wndBot:FindChild("BottomItemBtn")
                    wndBotItemBtn:SetCheck(false)
                end
            end
        end
    end
end

function Settings:CheckButtons()
    local newMainGroup = self.wndSettings:FindChild("NewMainGroupButton")
    local newAura = self.wndSettings:FindChild("NewAuraButton")
    local newGroup = self.wndSettings:FindChild("NewGroupButton")
    local newTrigger = self.wndSettings:FindChild("NewTriggerButton")

    if self.wndSettings:FindChild("Frame:Main:Settings"):IsShown() then
        newMainGroup:Show(false)
        newAura:Show(false)
        newGroup:Show(false)
        newTrigger:Show(false)
    elseif self.wndSettings:FindChild("Frame:Main:Auras"):IsShown() then
        newMainGroup:Show(true)
        newAura:Show(true)
        newGroup:Show(true)
        newTrigger:Show(true)

        newAura:Enable(false)
        newGroup:Enable(false)
        newTrigger:Enable(false)

        if self.wndLastGroupSelected ~= nil then
            newAura:Enable(true)
        else
            if self.wndLastAuraSelected ~= nil then
                newGroup:Enable(true)
                newTrigger:Enable(true)
            else
                if self.wndLastTriggerSelected ~= nil then
                    local middleGroup = self.wndLastTriggerSelected
                    local groupId = middleGroup:GetData()[1]:GetData()
                    local auraId = middleGroup:GetData()[2]:GetData()
                    local triggerId = middleGroup:GetData()[3]:GetData()

                    if self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggerType == "Group" then
                        newTrigger:Enable(true)
                    end
                end
            end
        end
    end

    -- Import / Export Buttons
    self:LoadExport()
end

function Settings:ResetAuras(rebuild)
    if rebuild == true then
        self:BuildTree()
    else
        self:UnselectAllAuras()
        self:ResizeTree()
    end

    self.wndLastGroupSelected = nil
    self.wndLastAuraSelected = nil
    self.wndLastTriggerSelected = nil
    self.wndLastChildSelected = nil

    self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
end

function Settings:OnSubTabBtn(wndHandler, wndControl)
    for _,child in pairs(wndControl:GetParent():GetParent():GetChildren()) do
        if child:GetName() ~= "TopTabContainer" then
            if child:GetName() == wndControl:GetName() then
                self.activeTab = wndControl:GetName()
                child:Show(true)
            else
                child:Show(false)
            end
        end
    end
end

-- ########################################################################################################################################
-- # BUILD SETTINGS
-- ########################################################################################################################################

function Settings:BuildRightPanelAuras(wndCurr)
    local bIsChecked = wndCurr:IsChecked()
    local wndMainGroup = wndCurr:GetData()[1]
    local wndTopGroup = wndCurr:GetData()[2]
    local wndMiddleGroup = wndCurr:GetData()[3]
    local wndBottomGroup = wndCurr:GetData()[4]
    local groupId = nil
    local auraId = nil
    local triggerId = nil
    local childId = nil

    -- Close Tree
    self:UnselectAllAuras()

    -- Main Group Expanding
    if wndMainGroup then
        groupId = wndMainGroup:GetData()
        wndMainGroup:FindChild("MainGroupBtn"):SetCheck(true)
        wndMainGroup:FindChild("GroupContents"):Show(true)
    end

    -- Top Group Expanding
    if wndTopGroup then
        auraId = wndTopGroup:GetData()
        wndTopGroup:FindChild("TopGroupBtn"):SetCheck(true)
        wndTopGroup:FindChild("GroupContents"):Show(true)
    end

    -- Middle Expanding
    if wndMiddleGroup then
        triggerId = wndMiddleGroup:GetData()
        wndMiddleGroup:FindChild("MiddleExpandBtn"):SetCheck(true)
        wndMiddleGroup:FindChild("MiddleGroupBtn"):SetCheck(true)
        wndMiddleGroup:FindChild("GroupContents"):Show(true)
    end

    -- Bottom Expanding
    if wndBottomGroup then
        childId = wndBottomGroup:GetData()
        wndBottomGroup:FindChild("BottomItemBtn"):SetCheck(true)
    end

    wndCurr:SetCheck(bIsChecked)

    -- Update tree
    self:ResizeTree()

    local wndRightScroll = self.wndSettings:FindChild("Auras"):FindChild("RightScroll")
    wndRightScroll:DestroyChildren()

    if self.wndRight then
        self.wndRight:Destroy()
    end

    if triggerId then
        if childId then
            self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Trigger", wndRightScroll, self)
            self:BuildMainTriggerSettings(groupId,auraId,triggerId,childId)
        else
            if self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggerType == "Group" then
                self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Group", wndRightScroll, self)
                self:BuildGroupSettings(groupId,auraId,triggerId)
            else
                self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Trigger", wndRightScroll, self)
                self:BuildMainTriggerSettings(groupId,auraId,triggerId)
            end
        end
    else
        if auraId then
            self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Aura", wndRightScroll, self)
            self:BuildAuraSettings(groupId,auraId)
        else
            self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:MainGroup", wndRightScroll, self)
            self:BuildMainGroupSettings(groupId)
        end
    end

    self.wndRight:RecalculateContentExtents()
end

-- ########################################################################################################################################
-- # BUILD AURA SETTINGS
-- ########################################################################################################################################

function Settings:BuildAuraSettings(groupId,auraId)
    local aura = self.parent.config.groups[groupId].runtime.auras[auraId]

    if self.activeTab ~= nil then
        if
            self.activeTab ~= "GeneralTab" and
            self.activeTab ~= "AppearanceTab" and
            self.activeTab ~= "BarTab" and
            self.activeTab ~= "TextTab" and
            self.activeTab ~= "AnimationTab"
        then
            self.activeTab = "GeneralTab"
        end

        if aura.enable == false then
            self.activeTab = "GeneralTab"
        end
    else
        self.activeTab = "GeneralTab"
    end

    for _,child in pairs(self.wndRight:FindChild("TopTabContainer"):GetChildren()) do
        if child:GetName() == self.activeTab then
            child:SetCheck(true)
        else
            child:SetCheck(false)
        end
    end

    for _,child in pairs(self.wndRight:GetChildren()) do
        if child:GetName() ~= "TopTabContainer" then
            if child:GetName() == self.activeTab then
                child:Show(true, true)
            else
                child:Show(false, true)
            end
        end
    end

    -- Enable
    self.wndRight:FindChild("EnableCheckbox"):SetCheck(aura.enable)
    self.wndRight:FindChild("EnableCheckbox"):SetData({"enable","check"})

    -- Lock
    self.wndRight:FindChild("UnlockCheckbox"):SetCheck(aura.locked)
    self.wndRight:FindChild("UnlockCheckbox"):Show(not aura.dynamic.enable,true)

    -- Name
    self.wndRight:FindChild("NameText"):SetText(aura.name)
    self.wndRight:FindChild("NameText"):SetData("name")

    -- Description
    self.wndRight:FindChild("DescriptionText"):SetText(aura.desc)
    self.wndRight:FindChild("DescriptionText"):SetData("desc")

    -- Behavior Dropdown
    self.wndRight:FindChild("BehaviorDropdown"):AttachWindow(self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BehaviorDropdown"):SetText(aura.behavior)
    self.wndRight:FindChild("BehaviorDropdown"):SetData("behavior")

    for _,button in pairs(self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- General Tab
    self:AddDynamicGroupSettings(aura)
    self:AddVisibilitySettings(aura)
    self:AddZoneSettings(aura)

    -- Appearance Tab
    self:AddIconSettings(aura)
    self:AddBorderSettings(aura)
    self:AddOverlaySettings(aura)
    self:AddSoundSettings(aura)

    -- Bar Tab
    self:AddBarSettings(aura)

    -- Animation Tab
    self:AddAnimationSettings(aura)

    -- Text Tab
    self:AddTextSettings(aura,"Duration")
    self:AddTextSettings(aura,"Stacks")
    self:AddTextSettings(aura,"Charges")
    self:AddTextSettings(aura,"Text")

    self.wndRight:FindChild("TextTab"):RecalculateContentExtents()

    for _,child in pairs(self.wndRight:FindChild("GeneralTab"):GetChildren()) do
        self:ToggleSettings(child,aura.enable)
    end

    for _,child in pairs(self.wndRight:FindChild("TopTabContainer"):GetChildren()) do
        self:ToggleSettings(child,aura.enable)
    end
end

function Settings:AddTextSources(aura,setting,wndText,dropdown,isTrigger,triggerSourceId)
    if not aura or not setting or not wndText then
        return
    end

    local current = 1
    local offset = 0
    local sources = {}
    local label = "Choose"
    local currentSource = tostring(aura[setting].source)

    -- Add "Remove Source Option" to Dropdown
    local removeSource = Apollo.LoadForm(self.parent.xmlDoc, "Items:Dropdown:TopItem", wndText:FindChild(dropdown):FindChild("ChoiceContainer"), self)
    removeSource:SetText("Remove Source")
    removeSource:SetCheck(false)
    removeSource:SetAnchorOffsets(42,49,-44,81)
    removeSource:SetData("remove")

    if isTrigger then
        label = ""
        removeSource:AddEventHandler("ButtonCheck", "OnTriggerSourceChoose", self)
    else
        removeSource:AddEventHandler("ButtonCheck", "OnSourceChoose", self)
    end

    -- Add Text Sources
    if aura.runtime ~= nil and aura.runtime.sources ~= nil then

        for sourceId, source in pairs(aura.runtime.sources) do
            local skip = false

            if source.sType ~= nil and source.sName ~= nil then
                -- Check if we already showed that source
                for _,v in pairs(sources) do
                    if v.sType == source.sType and v.sName == source.sName then
                        skip = true
                    end

                    if source.sValueType ~= nil then
                        if v.sValueType and v.sValueType == source.sValueType then
                            skip = true
                        end
                    end
                end

                -- Check if we should display this source
                if source.sText[setting] == false then
                    skip = true
                end

                if skip == false then
                    current = current + 1
                    offset = 30 * (current -1)

                    -- Add Source to Array
                    table.insert(sources, {
                        sName = source.sName,
                        sType = source.sType,
                        sValueType = source.sValueType or nil
                    })

                    -- Add Sources
                    dropdownItem = Apollo.LoadForm(self.parent.xmlDoc, "Items:Dropdown:MidItem", wndText:FindChild(dropdown):FindChild("ChoiceContainer"), self)
                    dropdownItem:SetText(source.sLabel)
                    dropdownItem:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
                    dropdownItem:SetData(sourceId)

                    if triggerSourceId then
                        dropdownItem:SetCheck(sourceId == triggerSourceId)

                        if sourceId == triggerSourceId then
                            label = source.sLabel
                        end
                    else
                        dropdownItem:SetCheck(sourceId == currentSource)

                        if sourceId == currentSource then
                            label = source.sLabel
                        end
                    end

                    if isTrigger then
                        dropdownItem:AddEventHandler("ButtonCheck", "OnTriggerSourceChoose", self)
                    else
                        dropdownItem:AddEventHandler("ButtonCheck", "OnSourceChoose", self)
                    end
                end
            end
        end

        if current > 1 then

            local count = #wndText:FindChild(dropdown):FindChild("ChoiceContainer"):GetChildren()
            local i = 0

            -- Change Sprite on Last Item
            for _,button in pairs(wndText:FindChild(dropdown):FindChild("ChoiceContainer"):GetChildren()) do
                i = i + 1

                if i == count then
                    button:ChangeArt("BK3:btnHolo_ListView_Btm")
                end
            end

            -- Show Source Dropdown
            wndText:FindChild(dropdown):AttachWindow(wndText:FindChild(dropdown):FindChild("ChoiceContainer"))
            wndText:FindChild(dropdown):FindChild("ChoiceContainer"):Show(false)
            wndText:FindChild(dropdown):SetText(label)
            wndText:FindChild(dropdown):SetData(setting)
            wndText:FindChild(dropdown):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,350,77 + (current * 30))
        else
            wndText:FindChild(dropdown):Enable(false)
            wndText:FindChild(dropdown):SetData("locked")
            wndText:FindChild(dropdown):FindChild("ChoiceContainer"):Show(false)
        end
    else
        wndText:FindChild(dropdown):Enable(false)
        wndText:FindChild(dropdown):SetData("locked")
        wndText:FindChild(dropdown):FindChild("ChoiceContainer"):Show(false)
    end
end

function Settings:AddTextSettings(aura,textType,isGroup)
    local wndText = Apollo.LoadForm(self.parent.xmlDoc, "Options:Text:Container", self.wndRight:FindChild("TextTab"), self)
    local text = aura[string.lower(textType)]
    local setting = string.lower(textType)

    -- Label
    wndText:FindChild("Label"):SetText(textType)
    wndText:SetData(textType)

    -- Reset
    wndText:FindChild("ResetTextButton"):SetData({setting,"TextTab"})
    wndText:FindChild("ResetTextButton"):Show(not isGroup,true)

    -- Name
    if self.activeText ~= nil then
        wndText:Show(textType == self.activeText,true)
    else
        wndText:Show(textType == "Duration",true)
    end

    -- Text Sources
    if isGroup and isGroup == true then
        wndText:FindChild("TextSourceSetting"):Destroy()
        wndText:FindChild("TextAnchorSetting"):SetAnchorPoints(0,0,1,0)
        wndText:FindChild("TextAnchorSetting"):SetAnchorOffsets(0,10,0,60)
        wndText:FindChild("TextSettings"):SetAnchorOffsets(15,5,-15,275)
        wndText:SetAnchorOffsets(0,0,0,615)
    else
        self:AddTextSources(aura,setting,wndText,"TextSourceDropdown")
    end

    -- Text Dropdown
    wndText:FindChild("TextChooseDropdown"):AttachWindow(wndText:FindChild("TextChooseDropdown"):FindChild("ChoiceContainer"))
    wndText:FindChild("TextChooseDropdown"):FindChild("ChoiceContainer"):Show(false)

    for _,button in pairs(wndText:FindChild("TextChooseDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == textType then
            button:SetCheck(true)
            wndText:FindChild("TextChooseDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    -- Enable Text
    wndText:FindChild("EnableTextCheckbox"):SetCheck(text.enable or false)
    wndText:FindChild("EnableTextCheckbox"):SetData({{setting,"enable"}})

    -- Text Input
    local tooltip = "Values:\n{v} = Value\n{t} = Total"

    if textType == "Duration" then
        tooltip = "Values:\n{v} = Value\n{t} = Total\n \nModifiers:\np = Percentage\n \nExamples:\n{vp} = Value in percent"
    elseif textType == "Text" then
        tooltip = "Values:\n{v} = Value\n{t} = Total\n{d} = Deficit\n{l} = Label\n \nModifiers:\n1 = 1 decimal\n2 = 2 decimals\np = Percentage\ns = Short (k)\n \nExamples:\n{vp} = Value in percent\n{t2} = Total with 2 decimals\n{ts} = Total in short"
    end

    wndText:FindChild("TextInput"):SetText(text.input or "")
    wndText:FindChild("TextInput"):SetData({{setting,"input"}})
    wndText:FindChild("TextInput"):SetTooltip(tooltip)

    -- Text Anchor
    wndText:FindChild("TextAnchorDropdown"):AttachWindow(wndText:FindChild("TextAnchorDropdown"):FindChild("ChoiceContainer"))
    wndText:FindChild("TextAnchorDropdown"):FindChild("ChoiceContainer"):Show(false)
    wndText:FindChild("TextAnchorDropdown"):SetText("Choose")
    wndText:FindChild("TextAnchorDropdown"):SetData({{setting,"anchor"},"build"})

    for _,button in pairs(wndText:FindChild("TextAnchorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == text.anchor then
            button:SetCheck(true)
            wndText:FindChild("TextAnchorDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    -- Text Position
    wndText:FindChild("TextPositionDropdown"):AttachWindow(wndText:FindChild("TextPositionDropdown"):FindChild("ChoiceContainer"))
    wndText:FindChild("TextPositionDropdown"):FindChild("ChoiceContainer"):Show(false)
    wndText:FindChild("TextPositionDropdown"):SetText("Choose")
    wndText:FindChild("TextPositionDropdown"):SetData({{setting,"position"},"build"})

    for _,button in pairs(wndText:FindChild("TextPositionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == text.position then
            button:SetCheck(true)
            wndText:FindChild("TextPositionDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    -- Text Alignment
    wndText:FindChild("TextAlignDropdown"):AttachWindow(wndText:FindChild("TextAlignDropdown"):FindChild("ChoiceContainer"))
    wndText:FindChild("TextAlignDropdown"):FindChild("ChoiceContainer"):Show(false)
    wndText:FindChild("TextAlignDropdown"):SetText(text.align)
    wndText:FindChild("TextAlignDropdown"):SetData({{setting,"align"},"build"})

    for _,button in pairs(wndText:FindChild("TextAlignDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == text.align then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Text Font Color
    wndText:FindChild("TextColor"):SetData({setting,"color"})
    wndText:FindChild("TextColor"):FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        text.color.r,
        text.color.g,
        text.color.b,
        text.color.a
    ))
    wndText:FindChild("TextColor"):FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        text.color.r / 255,
        text.color.g / 255,
        text.color.b / 255,
        text.color.a / 255
    ))

    -- Text Font List
    grid = wndText:FindChild("TextFontList")
    grid:SetData(setting)

    for _, font in pairs(Apollo.GetGameFonts()) do
        grid:AddRow(font.name)
    end

    for row = 1, grid:GetRowCount() do
        if grid:GetCellText(row, 1) == text.font then
            grid:SelectCell(row,1)
            grid:EnsureCellVisible(row,1)
        end
    end

    -- Text Positioning
    wndText:FindChild("XPosText"):SetText(text.posX)
    wndText:FindChild("XPosText"):SetData({{setting,"posX"},"build"})

    wndText:FindChild("YPosText"):SetText(text.posY)
    wndText:FindChild("YPosText"):SetData({{setting,"posY"},"build"})

    wndText:FindChild("UpButton"):SetData(setting)
    wndText:FindChild("DownButton"):SetData(setting)
    wndText:FindChild("RightButton"):SetData(setting)
    wndText:FindChild("LeftButton"):SetData(setting)

    for _,child in pairs(wndText:GetChildren()) do
        self:ToggleSettings(child,text.enable)
    end
end

function Settings:ToggleSettings(wnd,state)
    local enable = (state ~= nil and state == true) and true or false
    local opacity = enable == true and 1 or 0.5

    if
        string.match(string.lower(wnd:GetName()),"enable") or
        string.match(string.lower(wnd:GetName()),"delete") or
        string.match(string.lower(wnd:GetName()),"textchoose") or
        wnd:GetName() == "BorderList" or
        wnd:GetName() == "Frame" or
        wnd:GetName() == "GeneralTab"
    then
        return
    end

    if enable == true and wnd:GetData() == "locked" then
        return
    end

    if wnd:GetData() == "ignore" then
        return
    end

    if
        not string.match(string.lower(wnd:GetName()),"config") and
        not string.match(string.lower(wnd:GetName()),"group") and
        not string.match(string.lower(wnd:GetName()),"settings") and
        wnd:GetName() ~= "Container" and
        wnd:GetName() ~= "Icon" and
        wnd:GetName() ~= "Bar" and
        wnd:GetName() ~= "Animation" and
        wnd:GetName() ~= "Text" and
        wnd:GetName() ~= "Border" and
        wnd:GetName() ~= "Sound" and
        wnd:GetName() ~= "Overlay"
    then
        wnd:Enable(state)

        if state == false and wnd:IsStyleOn("BlockOutIfDisabled") then
            wnd:SetStyle("BlockOutIfDisabled",false)
            wnd:SetOpacity(opacity)
        end

        if state == true and wnd:GetOpacity() == 0.5 then
            wnd:SetStyle("BlockOutIfDisabled",true)
            wnd:SetOpacity(opacity)
        end
    end

    if #wnd:GetChildren() > 0 then
        for _,child in pairs(wnd:GetChildren()) do
            self:ToggleSettings(child,state)
        end
    end
end

function Settings:AddIconSettings(aura,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Icon", self.wndRight:FindChild("IconGroup"), self)

    -- Show Icon
    self.wndRight:FindChild("EnableIconCheckbox"):SetCheck(aura.icon.enable)
    self.wndRight:FindChild("EnableIconCheckbox"):SetData({{"icon","enable"},"build"})

    -- Show Tooltip
    self.wndRight:FindChild("ShowDescCheckbox"):SetCheck(aura.icon.tooltip)
    self.wndRight:FindChild("ShowDescCheckbox"):SetData({{"icon","tooltip"},"build"})

    -- Reset
    self.wndRight:FindChild("ResetIconButton"):SetData({"icon","AppearanceTab"})
    self.wndRight:FindChild("ResetIconButton"):Show(not isGroup,true)

    -- Anchor
    self.wndRight:FindChild("IconAnchorDropdown"):AttachWindow(self.wndRight:FindChild("IconAnchorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("IconAnchorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("IconAnchorDropdown"):SetText(aura.icon.anchor or "Choose")
    self.wndRight:FindChild("IconAnchorDropdown"):SetData({{"icon","anchor"},"build"})
    self.wndRight:FindChild("IconAnchorSetting"):SetData("ignore")

    for _,button in pairs(self.wndRight:FindChild("IconAnchorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.icon.anchor then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Icon Width
    self.wndRight:FindChild("IconWidthText"):SetText(aura.icon.width or 0)
    self.wndRight:FindChild("IconWidthText"):SetData({{"icon","width"},"build"})

    -- Icon Height
    self.wndRight:FindChild("IconHeightText"):SetText(aura.icon.height or 0)
    self.wndRight:FindChild("IconHeightText"):SetData({{"icon","height"},"build"})

    -- Icon Strata
    self.wndRight:FindChild("IconStrataSetting"):FindChild("SliderText"):SetText((aura.icon.strata or 0))
    self.wndRight:FindChild("IconStrataSlider"):SetValue(aura.icon.strata or 0)
    self.wndRight:FindChild("IconStrataSlider"):SetData({{"icon","strata"},"build"})
    self.wndRight:FindChild("IconStrataSetting"):SetData("ignore")

    -- Icon
    self.wndRight:FindChild("IconSpriteText"):SetText(aura.icon.sprite or "")
    self.wndRight:FindChild("IconSpriteText"):SetData({{"icon","sprite"}})
    self.wndRight:FindChild("IconPreview"):FindChild("BrowseIcons"):SetData({{"icon","sprite"},"IconSpriteText"})

    self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetSprite(aura.icon.sprite)
    self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetBGColor(ApolloColor.new(
        aura.icon.color.r / 255,
        aura.icon.color.g / 255,
        aura.icon.color.b / 255,
        aura.icon.color.a / 255
    ))
    self:RefreshIconPreview()

    -- Icon Sources
    if isGroup and isGroup == true then
        self.wndRight:FindChild("IconSourceSetting"):Destroy()

        self.wndRight:FindChild("IconColorSetting"):SetAnchorPoints(0,0,1,0)
        self.wndRight:FindChild("IconColorSetting"):SetAnchorOffsets(0,5,0,57)
    else
        self:AddTextSources(aura,"icon",self.wndRight,"IconSourceDropdown")
    end

    -- Icon Positioning
    self.wndRight:FindChild("IconGroup"):FindChild("XPosText"):SetText(aura.icon.posX)
    self.wndRight:FindChild("IconGroup"):FindChild("XPosText"):SetData({{"icon","posX"},"build"})

    self.wndRight:FindChild("IconGroup"):FindChild("YPosText"):SetText(aura.icon.posY)
    self.wndRight:FindChild("IconGroup"):FindChild("YPosText"):SetData({{"icon","posY"},"build"})

    self.wndRight:FindChild("IconGroup"):FindChild("UpButton"):SetData("icon")
    self.wndRight:FindChild("IconGroup"):FindChild("DownButton"):SetData("icon")
    self.wndRight:FindChild("IconGroup"):FindChild("RightButton"):SetData("icon")
    self.wndRight:FindChild("IconGroup"):FindChild("LeftButton"):SetData("icon")

    if not isGroup and aura.dynamic.enable == true then
        self:ToggleSettings(self.wndRight:FindChild("IconPosition"),false)
        self.wndRight:FindChild("IconPosition"):SetData("locked")
    else
        self.wndRight:FindChild("IconPosition"):SetData("ignore")
    end

    -- Icon Color
    self.wndRight:FindChild("IconColor"):SetData({"icon","color"})
    self.wndRight:FindChild("IconColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.icon.color.r,
        aura.icon.color.g,
        aura.icon.color.b,
        aura.icon.color.a
    ))
    self.wndRight:FindChild("IconColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.icon.color.r / 255,
        aura.icon.color.g / 255,
        aura.icon.color.b / 255,
        aura.icon.color.a / 255
    ))

    for _,child in pairs(self.wndRight:FindChild("IconGroup"):GetChildren()) do
        self:ToggleSettings(child,aura.icon.enable)
    end
end

function Settings:AddVisibilitySettings(aura,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Visibility", self.wndRight:FindChild("VisibilityGroup"), self)

    -- Reset
    self.wndRight:FindChild("ResetVisibilityButton"):SetData({"visibility","GeneralTab"})
    self.wndRight:FindChild("ResetVisibilityButton"):Show(not isGroup,true)

    -- Actionsets
    local wndActionsets = self.wndRight:FindChild("ActionsetBox")

    for k,v in ipairs(aura.actionsets) do
        local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:Checkbox", wndActionsets, self)
        checkbox:FindChild("CheckboxBtn"):SetText("Actionset " .. k)
        checkbox:FindChild("CheckboxBtn"):SetCheck(v == true)
        checkbox:FindChild("CheckboxBtn"):SetData({{"actionsets",k},"check"})
    end

    wndActionsets:ArrangeChildrenVert()

    -- Stances
    local wndStances = self.wndRight:FindChild("StancesBox")
    local stanceCount = 0

    for idx, spellObject in pairs(GameLib.GetClassInnateAbilitySpells().tSpells) do
        if idx % 2 == 1 then
            local stanceAllowed = true
            stanceCount = stanceCount + 1

            if aura.stances[spellObject:GetName()] ~= nil and aura.stances[spellObject:GetName()] == false then
                stanceAllowed = false
            end

            local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:Checkbox", wndStances, self)
            checkbox:FindChild("CheckboxBtn"):SetText(spellObject:GetName())
            checkbox:FindChild("CheckboxBtn"):SetCheck(stanceAllowed)
            checkbox:FindChild("CheckboxBtn"):SetData({{"stances",spellObject:GetName()},"check"})
        end
    end

    wndStances:ArrangeChildrenVert()

    if stanceCount > 1 then
        self.wndRight:FindChild("CircumstancesGroup"):SetAnchorPoints(0,0,0.333,1)
        self.wndRight:FindChild("CircumstancesGroup"):SetAnchorOffsets(15,50,-5,-15)

        self.wndRight:FindChild("ActionsetGroup"):SetAnchorPoints(0.666,0,1,1)
        self.wndRight:FindChild("ActionsetGroup"):SetAnchorOffsets(5,50,-15,-15)

        self.wndRight:FindChild("StancesGroup"):SetAnchorPoints(0.333,0,0.666,1)
        self.wndRight:FindChild("StancesGroup"):SetAnchorOffsets(5,50,-5,-15)
        self.wndRight:FindChild("StancesGroup"):Show(true,true)
    else
        self.wndRight:FindChild("CircumstancesGroup"):SetAnchorPoints(0,0,0.5,1)
        self.wndRight:FindChild("CircumstancesGroup"):SetAnchorOffsets(15,50,-5,-15)

        self.wndRight:FindChild("ActionsetGroup"):SetAnchorPoints(0.5,0,1,1)
        self.wndRight:FindChild("ActionsetGroup"):SetAnchorOffsets(5,50,-15,-15)

        self.wndRight:FindChild("StancesGroup"):Show(false,true)
    end

    -- Visiblity
    local wndCircumstances = self.wndRight:FindChild("CircumstancesBox")

    for k,v in pairs(aura.visibility) do
        local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:Checkbox", wndCircumstances, self)
        checkbox:FindChild("CheckboxBtn"):SetText(self.text.visibility[k])
        checkbox:FindChild("CheckboxBtn"):SetCheck(v == true)
        checkbox:FindChild("CheckboxBtn"):SetData({{"visibility",k},"check"})

        if GameLib.IsPvpServer() == true and k == "pvp" then
            checkbox:Show(false,true)
        end
    end

    wndCircumstances:ArrangeChildrenVert()
end

function Settings:AddBorderSettings(aura,isGroup,isTrigger,isTriggerGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Border", self.wndRight:FindChild("BorderGroup"), self)

    -- Enable Border Checkbox
    self.wndRight:FindChild("EnableBorderCheckbox"):SetCheck(aura.border.enable or false)
    self.wndRight:FindChild("EnableBorderCheckbox"):SetData({{"border","enable"},"build"})

    -- Reset
    self.wndRight:FindChild("ResetBorderButton"):SetData({"border","AppearanceTab"})
    self.wndRight:FindChild("ResetBorderButton"):Show((not isGroup and not isTrigger and not isTriggerGroup),true)

    -- Border Behavior Dropdown
    self.wndRight:FindChild("BorderBehaviorDropdown"):AttachWindow(self.wndRight:FindChild("BorderBehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BorderBehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BorderBehaviorDropdown"):SetText(aura.border.behavior or "Choose")
    self.wndRight:FindChild("BorderBehaviorDropdown"):SetData({{"border","behavior"}})

    if isTrigger then
        self.wndRight:FindChild("BorderBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,137)
    elseif isTriggerGroup then
        self.wndRight:FindChild("BorderBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,167)
    else
        self.wndRight:FindChild("BorderBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,197)
    end

    for _,button in pairs(self.wndRight:FindChild("BorderBehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.border.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end

        if isTrigger then
            button:Show((button:GetName() == "Pass" or button:GetName() == "Fail"),true)
        elseif isTriggerGroup then
            button:Show((button:GetName() ~= "Pass" and button:GetName() ~= "Fail" and button:GetName() ~= "Always"),true)

            if button:GetName() == "All" then
                button:ChangeArt("BK3:btnHolo_ListView_Top")
                button:SetAnchorOffsets(42,49,-44,81)
            elseif button:GetName() == "Any" then
                button:SetAnchorOffsets(42,79,-44,111)
            elseif button:GetName() == "None" then
                button:SetAnchorOffsets(42,109,-44,141)
            end
        else
            button:Show((button:GetName() ~= "Pass" and button:GetName() ~= "Fail"),true)
        end
    end

    -- Border Sprite
    self.wndRight:FindChild("BorderSpriteText"):SetText(aura.border.sprite or "")
    self.wndRight:FindChild("BorderSpriteText"):SetData({{"border","sprite"},"build"})
    self.wndRight:FindChild("BorderSpriteSetting"):FindChild("BrowseBorders"):SetData({{"border","sprite"},"BorderSpriteText"})

    -- Border Color
    self.wndRight:FindChild("BorderColor"):SetData({"border","color"})
    self.wndRight:FindChild("BorderColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.border.color.r,
        aura.border.color.g,
        aura.border.color.b,
        aura.border.color.a
    ))
    self.wndRight:FindChild("BorderColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.border.color.r / 255,
        aura.border.color.g / 255,
        aura.border.color.b / 255,
        aura.border.color.a / 255
    ))

    -- Border Inset
    self.wndRight:FindChild("BorderInsetSetting"):FindChild("SliderText"):SetText((aura.border.inset or 0))
    self.wndRight:FindChild("InsetSlider"):SetValue(aura.border.inset or 0)
    self.wndRight:FindChild("InsetSlider"):SetData({{"border","inset"},"build"})

    if self.wndRight:FindChild("IconPreview") then
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):Show(aura.border.enable,true)
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetSprite(aura.border.sprite)
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetAnchorOffsets(
            aura.border.inset,
            aura.border.inset,
            aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset),
            aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset)
        )
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetBGColor(ApolloColor.new(
            aura.border.color.r / 255,
            aura.border.color.g / 255,
            aura.border.color.b / 255,
            aura.border.color.a / 255
        ))
    end

    for _,child in pairs(self.wndRight:FindChild("BorderGroup"):GetChildren()) do
        self:ToggleSettings(child,aura.border.enable)
    end
end

function Settings:AddDynamicGroupSettings(aura,isGroup)
    if isGroup and isGroup == true then
        -- Dynamic Group
        self.wndRight:FindChild("EnableDynamicCheckbox"):SetCheck(aura.dynamic.enable)
        self.wndRight:FindChild("EnableDynamicCheckbox"):SetData({{"dynamic","enable"}})

        -- Dynamic Group Direction
        self.wndRight:FindChild("DynamicDirectionDropdown"):AttachWindow(self.wndRight:FindChild("DynamicDirectionDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("DynamicDirectionDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("DynamicDirectionDropdown"):SetText(aura.dynamic.direction or "Choose")
        self.wndRight:FindChild("DynamicDirectionDropdown"):SetData({{"dynamic","direction"}})

        for _,button in pairs(self.wndRight:FindChild("DynamicDirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == aura.dynamic.direction then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Dynamic Group Growth
        self.wndRight:FindChild("DynamicGrowthDropdown"):AttachWindow(self.wndRight:FindChild("DynamicGrowthDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("DynamicGrowthDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("DynamicGrowthDropdown"):SetText(aura.dynamic.growth or "Choose")
        self.wndRight:FindChild("DynamicGrowthDropdown"):SetData({{"dynamic","growth"}})

        for _,button in pairs(self.wndRight:FindChild("DynamicGrowthDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == aura.dynamic.growth then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Dynamic Group Sortation
        self.wndRight:FindChild("DynamicSortationDropdown"):AttachWindow(self.wndRight:FindChild("DynamicSortationDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("DynamicSortationDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("DynamicSortationDropdown"):SetText(aura.dynamic.sort or "Choose")
        self.wndRight:FindChild("DynamicSortationDropdown"):SetData({{"dynamic","sort"}})

        for _,button in pairs(self.wndRight:FindChild("DynamicSortationDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == aura.dynamic.sort then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Dynamic Group Transition Effect
        self.wndRight:FindChild("DynamicTransitionDropdown"):AttachWindow(self.wndRight:FindChild("DynamicTransitionDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("DynamicTransitionDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("DynamicTransitionDropdown"):SetText("Choose")
        self.wndRight:FindChild("DynamicTransitionDropdown"):SetData({{"dynamic","transition"}})

        for _,button in pairs(self.wndRight:FindChild("DynamicTransitionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == tostring(aura.dynamic.transition) then
                button:SetCheck(true)
                self.wndRight:FindChild("DynamicTransitionDropdown"):SetText(button:GetText())
            else
                button:SetCheck(false)
            end
        end

        -- Dynamic Group Transition Duration
        self.wndRight:FindChild("DynamicDurationSetting"):FindChild("SliderText"):SetText(aura.dynamic.duration or 0.25)
        self.wndRight:FindChild("DynamicDurationSetting"):FindChild("TransitionSlider"):SetValue(aura.dynamic.duration or 0.25)
        self.wndRight:FindChild("DynamicDurationSetting"):FindChild("TransitionSlider"):SetData({{"dynamic","duration"}})

        -- Dynamic Group Spacing X
        self.wndRight:FindChild("DynamicSpacingXSetting"):FindChild("SliderText"):SetText(aura.dynamic.spacingX or 3)
        self.wndRight:FindChild("DynamicSpacingXSetting"):FindChild("SpacingSlider"):SetValue(aura.dynamic.spacingX or 3)
        self.wndRight:FindChild("DynamicSpacingXSetting"):FindChild("SpacingSlider"):SetData({{"dynamic","spacingX"}})

        -- Dynamic Group Spacing Y
        self.wndRight:FindChild("DynamicSpacingYSetting"):FindChild("SliderText"):SetText(aura.dynamic.spacingY or 3)
        self.wndRight:FindChild("DynamicSpacingYSetting"):FindChild("SpacingSlider"):SetValue(aura.dynamic.spacingY or 3)
        self.wndRight:FindChild("DynamicSpacingYSetting"):FindChild("SpacingSlider"):SetData({{"dynamic","spacingY"}})

        -- Dynamic Group Rows
        self.wndRight:FindChild("DynamicRowsSetting"):FindChild("SliderText"):SetText(aura.dynamic.rows or 3)
        self.wndRight:FindChild("DynamicRowsSetting"):FindChild("RowSlider"):SetValue(aura.dynamic.rows or 3)
        self.wndRight:FindChild("DynamicRowsSetting"):FindChild("RowSlider"):SetData({{"dynamic","rows"}})

        -- Dynamic Group Columns
        self.wndRight:FindChild("DynamicColumnsSetting"):FindChild("SliderText"):SetText(aura.dynamic.columns or 10)
        self.wndRight:FindChild("DynamicColumnsSetting"):FindChild("ColumnSlider"):SetValue(aura.dynamic.columns or 10)
        self.wndRight:FindChild("DynamicColumnsSetting"):FindChild("ColumnSlider"):SetData({{"dynamic","columns"}})

        for _,child in pairs(self.wndRight:FindChild("DynamicGroup"):GetChildren()) do
            self:ToggleSettings(child,aura.dynamic.enable)
        end

        self.wndRight:FindChild("DynamicSettings"):SetData(aura.dynamic.enable and "" or "locked")
    else
        if aura.dynamic.enable and aura.dynamic.enable == true then
            -- Dynamic Group Source
            self:AddTextSources(aura,"dynamic",self.wndRight,"DynamicSourceDropdown")

            -- Dynamic Group Priority
            self.wndRight:FindChild("DynamicPrioritySetting"):FindChild("SliderText"):SetText(aura.dynamic.priority or 0)
            self.wndRight:FindChild("DynamicPrioritySetting"):FindChild("PrioritySlider"):SetValue(aura.dynamic.priority or 0)
            self.wndRight:FindChild("DynamicPrioritySetting"):FindChild("PrioritySlider"):SetData({{"dynamic","priority"}})

            self.wndRight:FindChild("VisibilityGroup"):SetAnchorOffsets(0,200,0,595)
            self.wndRight:FindChild("GeneralTab"):FindChild("Container"):SetAnchorOffsets(0,0,0,1260)
        else
            self.wndRight:FindChild("DynamicGroup"):Destroy()
        end
    end
end

function Settings:AddOverlaySettings(aura,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Overlay", self.wndRight:FindChild("OverlayGroup"), self)

    -- Enable
    self.wndRight:FindChild("EnableOverlayCheckbox"):SetCheck(aura.overlay.enable or false)
    self.wndRight:FindChild("EnableOverlayCheckbox"):SetData({{"overlay","enable"},"build"})

    -- Reset
    self.wndRight:FindChild("ResetOverlayButton"):SetData({"overlay","AppearanceTab"})
    self.wndRight:FindChild("ResetOverlayButton"):Show(not isGroup,true)

    -- Invert
    self.wndRight:FindChild("InvertOverlayCheckbox"):SetCheck(aura.overlay.invert)
    self.wndRight:FindChild("InvertOverlayCheckbox"):SetData({{"overlay","invert"},"build"})

    -- Text Sources
    if isGroup and isGroup == true then
        self.wndRight:FindChild("OverlaySourceSetting"):Destroy()

        self.wndRight:FindChild("OverlayStyleSetting"):SetAnchorPoints(0,0,1,0)
        self.wndRight:FindChild("OverlayStyleSetting"):SetAnchorOffsets(0,10,0,60)
    else
        self:AddTextSources(aura,"overlay",self.wndRight,"OverlaySourceDropdown")
    end

    -- Overlay Type Dropdown
    self.wndRight:FindChild("OverlayStyleDropdown"):AttachWindow(self.wndRight:FindChild("OverlayStyleDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("OverlayStyleDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("OverlayStyleDropdown"):SetText(aura.overlay.animation or "Choose")
    self.wndRight:FindChild("OverlayStyleDropdown"):SetData({{"overlay","animation"},"build"})

    for _,button in pairs(self.wndRight:FindChild("OverlayStyleDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.overlay.animation then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Overlay Direction Dropdown
    self.wndRight:FindChild("OverlayDirectionDropdown"):AttachWindow(self.wndRight:FindChild("OverlayDirectionDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("OverlayDirectionDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("OverlayDirectionDropdown"):SetData({{"overlay","direction"},"build"})

    for _,button in pairs(self.wndRight:FindChild("OverlayDirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.overlay.direction then
            button:SetCheck(true)
            self.wndRight:FindChild("OverlayDirectionDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end

        if aura.overlay.animation == "Radial" then
            if button:GetName() ~= "Clockwise" and button:GetName() ~= "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData("")
            end
        elseif aura.overlay.animation == "Linear" then
            if button:GetName() == "Clockwise" or button:GetName() == "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData()
            end
        end
    end

    -- Overlay Shape Dropdown
    self.wndRight:FindChild("OverlayShapeDropdown"):AttachWindow(self.wndRight:FindChild("OverlayShapeDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("OverlayShapeDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("OverlayShapeDropdown"):SetText(aura.overlay.shape)
    self.wndRight:FindChild("OverlayShapeDropdown"):SetData({{"overlay","shape"},"build"})

    for _,button in pairs(self.wndRight:FindChild("OverlayShapeDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.overlay.shape then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Duration Overlay Color
    self.wndRight:FindChild("DurationOverlayColor"):SetData({"overlay","color"})
    self.wndRight:FindChild("DurationOverlayBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.overlay.color.r,
        aura.overlay.color.g,
        aura.overlay.color.b,
        aura.overlay.color.a
    ))
    self.wndRight:FindChild("DurationOverlayBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.overlay.color.r / 255,
        aura.overlay.color.g / 255,
        aura.overlay.color.b / 255,
        aura.overlay.color.a / 255
    ))

    for _,child in pairs(self.wndRight:FindChild("OverlayGroup"):GetChildren()) do
        self:ToggleSettings(child,aura.overlay.enable)
    end
end

function Settings:AddSourceSettings(trigger,isTriggerGroup)
    local current = 0
    local count = 7
    local sources = {
        dynamic = "Dynamic Group",
        overlay = "Overlay",
        bar = "Progress Bar",
        duration = "Duration Text",
        stacks = "Stacks Text",
        charges = "Charges Text",
        text = "Individual Text",
        icon = "Icon",
        bar = "Progress Bar"
    }

    for k,v in pairs(sources) do
        local source = Apollo.LoadForm(self.parent.xmlDoc, "Items:Source", self.wndRight:FindChild("SourceOptions"), self)
        current = current + 1

        if current == 1 then
            source:SetAnchorOffsets(0,0,0,60)
            source:FindChild("SourceCheckbox"):SetAnchorOffsets(10,7,40,-2)
            source:FindChild("Label"):SetAnchorOffsets(50,3,275,0)
            source:FindChild("SourceSetting"):SetAnchorOffsets(275,7,0,3)
        elseif current == count then
            source:FindChild("Divider"):Show(false,true)
        end

        source:SetName(k)
        source:FindChild("Label"):SetText(v)

        -- Enable Checkbox
        source:FindChild("SourceCheckbox"):SetCheck(trigger.sources[k] ~= nil and true or false)
        source:FindChild("SourceCheckbox"):SetData({{"sources",k},"build"})

        -- Text Sources
        local groupId,auraId,triggerId,childId = self:GetIdentifiers()
        local aura = self.parent.config.groups[groupId].runtime.auras[auraId]
        self:AddTextSources(aura,k,source,"SourceDropdown",true,((trigger.sources[k] ~= nil and trigger.sources[k].source ~= "") and trigger.sources[k].source or nil))

        -- Behavior Dropdown
        source:FindChild("SourceBehaviorDropdown"):AttachWindow(source:FindChild("SourceBehaviorDropdown"):FindChild("ChoiceContainer"))
        source:FindChild("SourceBehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
        source:FindChild("SourceBehaviorDropdown"):SetText((trigger.sources[k] ~= nil and trigger.sources[k].behavior ~= "") and trigger.sources[k].behavior or "Choose")
        source:FindChild("SourceBehaviorDropdown"):SetData({{"sources",k,"behavior"},"build"})

        if isTriggerGroup then
            source:FindChild("SourceBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,167)
        else
            source:FindChild("SourceBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,137)
        end

        for _,button in pairs(source:FindChild("SourceBehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == (trigger.sources[k] ~= nil and trigger.sources[k].behavior or "Choose") then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end

            if isTriggerGroup then
                button:Show((button:GetName() ~= "Pass" and button:GetName() ~= "Fail"),true)
            else
                button:Show((button:GetName() == "Pass" or button:GetName() == "Fail"),true)
            end
        end

        self:ToggleSettings(source:FindChild("SourceSetting"),trigger.sources[k] ~= nil)
    end

    self.wndRight:FindChild("SourceOptions"):ArrangeChildrenVert()
end

function Settings:AddSoundSettings(aura,isGroup,isTrigger,isTriggerGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Sound", self.wndRight:FindChild("SoundGroup"), self)

    -- Enable Sound Checkbox
    self.wndRight:FindChild("EnableSoundCheckbox"):SetCheck(aura.sound.enable or false)
    self.wndRight:FindChild("EnableSoundCheckbox"):SetData({{"sound","enable"}})

    -- Reset
    self.wndRight:FindChild("ResetSoundButton"):SetData({"sound","AppearanceTab"})
    self.wndRight:FindChild("ResetSoundButton"):Show((not isGroup and not isTrigger and not isTriggerGroup),true)

    -- Force Unmute Checkbox
    self.wndRight:FindChild("ForceSoundCheckbox"):SetCheck(aura.sound.force or false)
    self.wndRight:FindChild("ForceSoundCheckbox"):SetData({{"sound","force"}})

    -- Sound Behavior Dropdown
    self.wndRight:FindChild("SoundBehaviorDropdown"):AttachWindow(self.wndRight:FindChild("SoundBehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("SoundBehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("SoundBehaviorDropdown"):SetText(aura.sound.behavior or "Choose")
    self.wndRight:FindChild("SoundBehaviorDropdown"):SetData({{"sound","behavior"}})

    if isTrigger then
        self.wndRight:FindChild("SoundBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,137)
    else
        self.wndRight:FindChild("SoundBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,167)
    end

    for _,button in pairs(self.wndRight:FindChild("SoundBehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.sound.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end

        if isTrigger then
            button:Show((button:GetName() == "Pass" or button:GetName() == "Fail"),true)
        else
            button:Show((button:GetName() ~= "Pass" and button:GetName() ~= "Fail"),true)
        end
    end

    -- Sound Volume Slider
    self.wndRight:FindChild("SoundVolumeSetting"):FindChild("SliderText"):SetText((aura.sound.volume or 1))
    self.wndRight:FindChild("SoundSlider"):SetValue(aura.sound.volume or 1)
    self.wndRight:FindChild("SoundSlider"):SetData({{"sound","volume"}})

    local grid = self.wndRight:FindChild("SoundList")

    -- LUI Media
    if self.media then
        for soundName,soundFile in pairs(self.media:Load("sounds")) do
            grid:AddRow(soundName,nil,"..\\LUI_Media\\sounds\\"..tostring(soundFile))
        end
    end

    -- Add Custom Sounds
    for soundName,soundFile in self.parent:Sort(self.soundFiles) do
        grid:AddRow(soundName,nil,soundFile)
    end

    -- Add WildStar Sounds
    for soundName,soundFile in self.parent:Sort(Sound) do
        if type(soundFile) == "number" then
            grid:AddRow(soundName,nil,soundFile)
        end
    end

    -- Select active sound
    for row = 1, grid:GetRowCount() do
        if grid:GetCellLuaData(row, 1) == aura.sound.file then
            grid:SelectCell(row,1)
            grid:EnsureCellVisible(row,1)
        end
    end

    for _,child in pairs(self.wndRight:FindChild("SoundGroup"):GetChildren()) do
        self:ToggleSettings(child,aura.sound.enable)
    end
end

function Settings:AddAnimationSettings(aura,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Animation", self.wndRight:FindChild("AnimationTab"):FindChild("AnimationSettings"), self)

    if not self.animationType then
        self.animationType = "Start"
    end

    -- Reset
    self.wndRight:FindChild("ResetAnimationButton"):SetData({{"animation",self.animationType},"AnimationTab"})
    self.wndRight:FindChild("ResetAnimationButton"):Show(not isGroup,true)

    -- Animation Type Dropdown
    self.wndRight:FindChild("AnimationChooseDropdown"):AttachWindow(self.wndRight:FindChild("AnimationChooseDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("AnimationChooseDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("AnimationChooseDropdown"):SetText(self.animationType or "Choose")

    for _,button in pairs(self.wndRight:FindChild("AnimationChooseDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == self.animationType then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Add Presets
    local presetCount = #self.presets.animationDropdown[self.animationType]

    for k,preset in ipairs(self.presets.animationDropdown[self.animationType]) do
        local dropdownItem = nil
        local item = "Items:Dropdown:MidItem"
        local offset = 30 * (k -1)

        if presetCount > 1 then
            if k == 1 then
                item = "Items:Dropdown:TopItem"
            elseif k == presetCount then
                item = "Items:Dropdown:BottomItem"
            end
        else
            item = "Items:Dropdown:SingleItem"
        end

        local button = Apollo.LoadForm(self.parent.xmlDoc, item, self.wndRight:FindChild("AnimationPresetDropdown"):FindChild("ChoiceContainer"), self)
        button:SetText(preset.label)
        button:SetData({
            strName = preset.animation,
            strAnimation = self.animationType
        })
        button:SetCheck(false)
        button:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
        button:AddEventHandler("ButtonCheck", "OnChooseAnimationPreset", self)
    end

    self.wndRight:FindChild("AnimationPresetDropdown"):AttachWindow(self.wndRight:FindChild("AnimationPresetDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("AnimationPresetDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,350,77 + (presetCount * 30))
    self.wndRight:FindChild("AnimationPresetDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("AnimationPresetDropdown"):SetText("Choose")

    -- Animation Label
    self.wndRight:FindChild("AnimationConfigSetting"):FindChild("Label"):SetText(self.animationType .. " Animation")

    -- Enable Animation Checkbox
    self.wndRight:FindChild("EnableAnimationCheckbox"):SetCheck(aura.animation[self.animationType].enable)
    self.wndRight:FindChild("EnableAnimationCheckbox"):SetData({{"animation",self.animationType,"enable"},"build"})

    -- Animation Duration
    self.wndRight:FindChild("AnimationConfigSetting"):FindChild("DurationSetting"):FindChild("SliderText"):SetText(aura.animation[self.animationType].duration or 0)
    self.wndRight:FindChild("AnimationDurationSlider"):SetValue(aura.animation[self.animationType].duration or 0)
    self.wndRight:FindChild("AnimationDurationSlider"):SetData({{"animation",self.animationType,"duration"},"build"})

    -- Animation Effect Dropdown
    self.wndRight:FindChild("AnimationEffectDropdown"):AttachWindow(self.wndRight:FindChild("AnimationEffectDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("AnimationEffectDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("AnimationEffectDropdown"):SetText(aura.animation[self.animationType].effect or "Choose")
    self.wndRight:FindChild("AnimationEffectDropdown"):SetData({{"animation",self.animationType,"effect"},"build"})

    for _,button in pairs(self.wndRight:FindChild("AnimationEffectDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.animation[self.animationType].effect then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Enable Zoom Checkbox
    self.wndRight:FindChild("AnimationZoomCheckbox"):SetCheck(aura.animation[self.animationType].zoomEnable)
    self.wndRight:FindChild("AnimationZoomCheckbox"):SetData({{"animation",self.animationType,"zoomEnable"},"build"})

    -- Zoom Scale Slider
    self.wndRight:FindChild("AnimationZoomSetting"):FindChild("ScaleSetting"):FindChild("SliderText"):SetText(aura.animation[self.animationType].zoomScale or 0)
    self.wndRight:FindChild("ZoomScaleSlider"):SetValue(aura.animation[self.animationType].zoomScale or 0)
    self.wndRight:FindChild("ZoomScaleSlider"):SetData({{"animation",self.animationType,"zoomScale"},"build"})

    -- Enable Slide Checkbox
    self.wndRight:FindChild("AnimationSlideCheckbox"):SetCheck(aura.animation[self.animationType].slideEnable)
    self.wndRight:FindChild("AnimationSlideCheckbox"):SetData({{"animation",self.animationType,"slideEnable"},"build"})

    -- Slide Offset X Slider
    self.wndRight:FindChild("AnimationSlideSetting"):FindChild("OffsetXSetting"):FindChild("SliderText"):SetText(aura.animation[self.animationType].slideOffsetX or 0)
    self.wndRight:FindChild("SlideOffsetXSlider"):SetValue(aura.animation[self.animationType].slideOffsetX or 0)
    self.wndRight:FindChild("SlideOffsetXSlider"):SetData({{"animation",self.animationType,"slideOffsetX"},"build"})

    -- Slide Offset Y Slider
    self.wndRight:FindChild("AnimationSlideSetting"):FindChild("OffsetYSetting"):FindChild("SliderText"):SetText(aura.animation[self.animationType].slideOffsetY or 0)
    self.wndRight:FindChild("SlideOffsetYSlider"):SetValue(aura.animation[self.animationType].slideOffsetY or 0)
    self.wndRight:FindChild("SlideOffsetYSlider"):SetData({{"animation",self.animationType,"slideOffsetY"},"build"})

    -- Animation Slide Dropdown
    self.wndRight:FindChild("SlideTransitionDropdown"):AttachWindow(self.wndRight:FindChild("SlideTransitionDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("SlideTransitionDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("SlideTransitionDropdown"):SetText("Choose")
    self.wndRight:FindChild("SlideTransitionDropdown"):SetData({{"animation",self.animationType,"slideTransition"},"build"})

    for _,button in pairs(self.wndRight:FindChild("SlideTransitionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == tostring(aura.animation[self.animationType].slideTransition) then
            button:SetCheck(true)
            self.wndRight:FindChild("SlideTransitionDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    for _,child in pairs(self.wndRight:FindChild("AnimationSettings"):GetChildren()) do
        self:ToggleSettings(child,aura.animation[self.animationType].enable)
    end
end

function Settings:AddBarSettings(aura,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Bar", self.wndRight:FindChild("BarTab"):FindChild("Container"), self)

    -- Reset
    self.wndRight:FindChild("ResetBarButton"):SetData({"bar","BarTab"})
    self.wndRight:FindChild("ResetBarButton"):Show(not isGroup,true)

    -- Add Presets
    local currentPreset = 0
    local presetCount = 0

    for k,_ in pairs(self.presets.bars) do
        presetCount = presetCount + 1
    end

    for presetName,_ in pairs(self.presets.bars) do
        currentPreset = currentPreset + 1
        local dropdownItem = nil
        local item = "Items:Dropdown:MidItem"
        local offset = 30 * (currentPreset -1)

        if presetCount > 1 then
            if currentPreset == 1 then
                item = "Items:Dropdown:TopItem"
            elseif currentPreset == presetCount then
                item = "Items:Dropdown:BottomItem"
            end
        else
            item = "Items:Dropdown:SingleItem"
        end

        -- Stack Sources
        local preset = Apollo.LoadForm(self.parent.xmlDoc, item, self.wndRight:FindChild("BarPresetDropdown"):FindChild("ChoiceContainer"), self)
        preset:SetText(presetName)
        preset:SetCheck(false)
        preset:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
        preset:AddEventHandler("ButtonCheck", "OnChooseBarPreset", self)
    end

    self.wndRight:FindChild("BarPresetDropdown"):AttachWindow(self.wndRight:FindChild("BarPresetDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BarPresetDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,350,77 + (presetCount * 30))
    self.wndRight:FindChild("BarPresetDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BarPresetDropdown"):SetText("Choose")

    -- Enable Progress Bar
    self.wndRight:FindChild("EnableProgressCheckbox"):SetCheck(aura.bar.enable)
    self.wndRight:FindChild("EnableProgressCheckbox"):SetData({{"bar","enable"},"build"})

    -- Invert Progress Bar
    self.wndRight:FindChild("InvertProgressCheckbox"):SetCheck(aura.bar.invert)
    self.wndRight:FindChild("InvertProgressCheckbox"):SetData({{"bar","invert"},"build"})

    -- Text Sources
    if isGroup and isGroup == true then
        self.wndRight:FindChild("ProgressSourceSetting"):Destroy()
        self.wndRight:FindChild("PositionSetting"):SetAnchorOffsets(0,0,0,50)
        self.wndRight:FindChild("ProgressSettings"):SetAnchorOffsets(15,5,-15,480)
    else
        self:AddTextSources(aura,"bar",self.wndRight,"ProgressSourceDropdown")
    end

    -- Bar Fill Texture
    self.wndRight:FindChild("FillTextureText"):SetText(aura.bar.sprite_fill or "")
    self.wndRight:FindChild("FillTextureText"):SetData({{"bar","sprite_fill"},"build"})
    self.wndRight:FindChild("FillTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_fill"},"FillTextureText"})

    -- Bar Empty Texture
    self.wndRight:FindChild("EmptyTextureText"):SetText(aura.bar.sprite_empty or "")
    self.wndRight:FindChild("EmptyTextureText"):SetData({{"bar","sprite_empty"},"build"})
    self.wndRight:FindChild("EmptyTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_empty"},"EmptyTextureText"})

    -- Bar Background Texture
    self.wndRight:FindChild("BGTextureText"):SetText(aura.bar.sprite_bg or "")
    self.wndRight:FindChild("BGTextureText"):SetData({{"bar","sprite_bg"},"build"})
    self.wndRight:FindChild("BGTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_bg"},"BGTextureText"})

    -- Border Sprite
    self.wndRight:FindChild("BorderTextureText"):SetText(aura.bar.sprite_border or "")
    self.wndRight:FindChild("BorderTextureText"):SetData({{"bar","sprite_border"},"build"})
    self.wndRight:FindChild("BorderTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_border"},"BorderTextureText"})

    -- Border Inset
    self.wndRight:FindChild("ProgressInsetSetting"):FindChild("SliderText"):SetText((aura.bar.border_inset or 0))
    self.wndRight:FindChild("ProgressInsetSlider"):SetValue(aura.bar.border_inset or 0)
    self.wndRight:FindChild("ProgressInsetSlider"):SetData({{"bar","border_inset"},"build"})

    -- Bar Spacing Slider
    self.wndRight:FindChild("ProgressGroup"):FindChild("SpacingSetting"):FindChild("SliderText"):SetText(aura.bar.spacing or 0)
    self.wndRight:FindChild("ProgressGroup"):FindChild("BarSpacingSlider"):SetValue(aura.bar.spacing or 0)
    self.wndRight:FindChild("ProgressGroup"):FindChild("BarSpacingSlider"):SetData({{"bar","spacing"},"build"})

    if self.wndRight:FindChild("IconPreview") then
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):Show(aura.border.enable,true)
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetSprite(aura.border.sprite)
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetAnchorOffsets(
            aura.border.inset,
            aura.border.inset,
            aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset),
            aura.border.inset >= 0 and -aura.border.inset or math.abs(aura.border.inset)
        )
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetBGColor(ApolloColor.new(
            aura.border.color.r / 255,
            aura.border.color.g / 255,
            aura.border.color.b / 255,
            aura.border.color.a / 255
        ))
    end

    -- Bar Width
    self.wndRight:FindChild("ProgressWidthText"):SetText(aura.bar.width or 0)
    self.wndRight:FindChild("ProgressWidthText"):SetData({{"bar","width"},"build"})

    -- Bar Height
    self.wndRight:FindChild("ProgressHeightText"):SetText(aura.bar.height or 0)
    self.wndRight:FindChild("ProgressHeightText"):SetData({{"bar","height"},"build"})

    -- Bar Radial Degree
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("RadialMinText"):SetText(aura.bar.radialmin)
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("RadialMinText"):SetData({{"bar","radialmin"},"build"})

    self.wndRight:FindChild("ProgressPosSettings"):FindChild("RadialMaxText"):SetText(aura.bar.radialmax)
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("RadialMaxText"):SetData({{"bar","radialmax"},"build"})

    -- Bar Position
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("XPosText"):SetText(aura.bar.posX)
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("XPosText"):SetData({{"bar","posX"},"build"})

    self.wndRight:FindChild("ProgressPosSettings"):FindChild("YPosText"):SetText(aura.bar.posY)
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("YPosText"):SetData({{"bar","posY"},"build"})

    self.wndRight:FindChild("ProgressPosSettings"):FindChild("UpButton"):SetData("bar")
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("DownButton"):SetData("bar")
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("RightButton"):SetData("bar")
    self.wndRight:FindChild("ProgressPosSettings"):FindChild("LeftButton"):SetData("bar")

    -- Bar Fill Color
    self.wndRight:FindChild("FillColor"):SetData({"bar","color_fill"})
    self.wndRight:FindChild("FillColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.bar.color_fill.r,
        aura.bar.color_fill.g,
        aura.bar.color_fill.b,
        aura.bar.color_fill.a
    ))
    self.wndRight:FindChild("FillColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.bar.color_fill.r / 255,
        aura.bar.color_fill.g / 255,
        aura.bar.color_fill.b / 255,
        aura.bar.color_fill.a / 255
    ))

    -- Bar Empty Color
    self.wndRight:FindChild("EmptyColor"):SetData({"bar","color_empty"})
    self.wndRight:FindChild("EmptyColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.bar.color_empty.r,
        aura.bar.color_empty.g,
        aura.bar.color_empty.b,
        aura.bar.color_empty.a
    ))
    self.wndRight:FindChild("EmptyColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.bar.color_empty.r / 255,
        aura.bar.color_empty.g / 255,
        aura.bar.color_empty.b / 255,
        aura.bar.color_empty.a / 255
    ))

    -- Bar Background Color
    self.wndRight:FindChild("BGColor"):SetData({"bar","color_bg"})
    self.wndRight:FindChild("BGColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.bar.color_bg.r,
        aura.bar.color_bg.g,
        aura.bar.color_bg.b,
        aura.bar.color_bg.a
    ))
    self.wndRight:FindChild("BGColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.bar.color_bg.r / 255,
        aura.bar.color_bg.g / 255,
        aura.bar.color_bg.b / 255,
        aura.bar.color_bg.a / 255
    ))

    -- Bar Border Color
    self.wndRight:FindChild("ProgressBorderColor"):SetData({"bar","color_border"})
    self.wndRight:FindChild("ProgressBorderColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        aura.bar.color_border.r,
        aura.bar.color_border.g,
        aura.bar.color_border.b,
        aura.bar.color_border.a
    ))
    self.wndRight:FindChild("ProgressBorderColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        aura.bar.color_border.r / 255,
        aura.bar.color_border.g / 255,
        aura.bar.color_border.b / 255,
        aura.bar.color_border.a / 255
    ))

    -- Bar Position Dropdown
    self.wndRight:FindChild("PositionDropdown"):AttachWindow(self.wndRight:FindChild("PositionDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("PositionDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("PositionDropdown"):SetText("Choose")
    self.wndRight:FindChild("PositionDropdown"):SetData({{"bar","position"},"build"})

    for _,button in pairs(self.wndRight:FindChild("PositionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.bar.position then
            button:SetCheck(true)
            self.wndRight:FindChild("PositionDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    -- Bar Animation Dropdown
    self.wndRight:FindChild("AnimationDropdown"):AttachWindow(self.wndRight:FindChild("AnimationDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("AnimationDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("AnimationDropdown"):SetText("Choose")
    self.wndRight:FindChild("AnimationDropdown"):SetData({{"bar","animation"},"build"})

    self:ToggleSettings(self.wndRight:FindChild("EmptyTextureSetting"),(aura.bar.animation == "Linear"))
    self:ToggleSettings(self.wndRight:FindChild("EmptyColorSetting"),(aura.bar.animation == "Linear"))
    self:ToggleSettings(self.wndRight:FindChild("RadialMinBox"),(aura.bar.animation == "Radial"))
    self:ToggleSettings(self.wndRight:FindChild("RadialMaxBox"),(aura.bar.animation == "Radial"))

    self.wndRight:FindChild("EmptyTextureSetting"):SetData((aura.bar.animation == "Radial") and "locked" or "")
    self.wndRight:FindChild("EmptyColorSetting"):SetData((aura.bar.animation == "Radial") and "locked" or "")
    self.wndRight:FindChild("RadialMinBox"):SetData((aura.bar.animation == "Linear") and "locked" or "")
    self.wndRight:FindChild("RadialMaxBox"):SetData((aura.bar.animation == "Linear") and "locked" or "")

    for _,button in pairs(self.wndRight:FindChild("AnimationDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.bar.animation then
            button:SetCheck(true)
            self.wndRight:FindChild("AnimationDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    -- Bar Direction Dropdown
    self.wndRight:FindChild("ProgressGroup"):FindChild("DirectionDropdown"):AttachWindow(self.wndRight:FindChild("ProgressGroup"):FindChild("DirectionDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("ProgressGroup"):FindChild("DirectionDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("ProgressGroup"):FindChild("DirectionDropdown"):SetData({{"bar","direction"},"build"})

    for _,button in pairs(self.wndRight:FindChild("ProgressGroup"):FindChild("DirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == aura.bar.direction then
            button:SetCheck(true)
            self.wndRight:FindChild("ProgressGroup"):FindChild("DirectionDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end

        if aura.bar.animation == "Radial" then
            if button:GetName() ~= "Clockwise" and button:GetName() ~= "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData("")
            end
        elseif aura.bar.animation == "Linear" then
            if button:GetName() == "Clockwise" or button:GetName() == "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData()
            end
        end
    end

    -- Disable inactive
    for _,child in pairs(self.wndRight:FindChild("ProgressGroup"):GetChildren()) do
        self:ToggleSettings(child,aura.bar.enable)
    end
end

-- ########################################################################################################################################
-- # BUILD TRIGGER SETTINGS
-- ########################################################################################################################################

function Settings:BuildMainTriggerSettings(groupId, auraId, triggerId, childId)
    local aura = self.parent.config.groups[groupId].runtime.auras[auraId]
    local trigger = nil

    if childId then
        trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId]
    else
        trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId]
    end

    if not trigger then
        return
    end

    if self.activeTab ~= nil then
        if self.activeTab ~= "GeneralTab" and self.activeTab ~= "TriggerEffectsTab" then
            self.activeTab = "GeneralTab"
        end

        if trigger.enable == false then
            self.activeTab = "GeneralTab"
        end
    else
        self.activeTab = "GeneralTab"
    end

    for _,child in pairs(self.wndRight:FindChild("TopTabContainer"):GetChildren()) do
        if child:GetName() == self.activeTab then
            child:SetCheck(true)
        else
            child:SetCheck(false)
        end
    end

    for _,child in pairs(self.wndRight:GetChildren()) do
        if child:GetName() ~= "TopTabContainer" then
            if child:GetName() == self.activeTab then
                child:Show(true, true)
            else
                child:Show(false, true)
            end
        end
    end

    -- Enable
    self.wndRight:FindChild("EnableCheckbox"):SetCheck(trigger.enable)
    self.wndRight:FindChild("EnableCheckbox"):SetData({"enable","check"})

    -- Name
    self.wndRight:FindChild("NameText"):SetText(trigger.name)
    self.wndRight:FindChild("NameText"):SetData("name")

    -- Behavior Dropdown
    self.wndRight:FindChild("BehaviorDropdown"):AttachWindow(self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BehaviorDropdown"):SetText(trigger.behavior or "Choose")
    self.wndRight:FindChild("BehaviorDropdown"):SetData("behavior")

    for _,button in pairs(self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == trigger.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    -- Trigger Dropdown
    self.wndRight:FindChild("TriggerDropdown"):FindChild("ChoiceContainer"):DestroyChildren()
    local currentTrigger = 0
    local triggerCount = 0

    for k,_ in pairs(self.triggerTypes) do
        triggerCount = triggerCount + 1
    end

    for tId,tTrigger in self.parent:Sort(self.triggerTypes) do
        currentTrigger = currentTrigger + 1
        local dropdownItem = nil
        local item = "Items:Dropdown:MidItem"
        local offset = 30 * (currentTrigger -1)

        if triggerCount > 1 then
            if currentTrigger == 1 then
                item = "Items:Dropdown:TopItem"
            elseif currentTrigger == triggerCount then
                item = "Items:Dropdown:BottomItem"
            end
        else
            item = "Items:Dropdown:SingleItem"
        end

        -- Stack Sources
        local triggerItem = Apollo.LoadForm(self.parent.xmlDoc, item, self.wndRight:FindChild("TriggerDropdown"):FindChild("ChoiceContainer"), self)
        triggerItem:SetText(tTrigger.label)
        triggerItem:SetTooltip(tTrigger.tooltip)
        triggerItem:SetData(tId)
        triggerItem:SetCheck(trigger.triggerType == tId)
        triggerItem:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
        triggerItem:AddEventHandler("ButtonCheck", "OnChooseTrigger", self)
    end

    self.wndRight:FindChild("TriggerDropdown"):AttachWindow(self.wndRight:FindChild("TriggerDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("TriggerDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,350,77 + (triggerCount * 30))
    self.wndRight:FindChild("TriggerDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("TriggerDropdown"):SetText(trigger.triggerType or "Choose")

    self:AddTriggerEffects(aura,trigger,false)

    for _,child in pairs(self.wndRight:FindChild("GeneralGroup"):GetChildren()) do
        self:ToggleSettings(child,trigger.enable)
    end

    self:BuildTriggerSettings(groupId, auraId, triggerId, childId)
end

function Settings:BuildTriggerSettings(groupId, auraId, triggerId, childId)
    local trigger = nil
    local ttype = nil
    local wndtrigger = nil

    if childId then
        trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId]
    else
        trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId]
    end

    if not trigger then
        return
    end

    self.wndRight:FindChild("TriggerContainer"):DestroyChildren()

    if trigger.triggerType then
        ttype = trigger.triggerType
        wndTrigger = Apollo.LoadForm(self.parent.xmlDoc, "Triggers:"..trigger.triggerType, self.wndRight:FindChild("TriggerContainer"), self)
        if wndTrigger then
            self.wndRight:FindChild("TriggerContainer"):SetAnchorOffsets(0,10,0,10 + wndTrigger:GetHeight())
            self.wndRight:FindChild("TriggerContainer"):GetParent():SetAnchorOffsets(0,0,0,10 + self.wndRight:FindChild("GeneralGroup"):GetHeight() + wndTrigger:GetHeight())
        else
            self.wndRight:FindChild("TriggerContainer"):GetParent():SetAnchorOffsets(0,0,0,self.wndRight:FindChild("GeneralGroup"):GetHeight())
        end
    else
        self.wndRight:FindChild("TriggerContainer"):GetParent():SetAnchorOffsets(0,0,0,self.wndRight:FindChild("GeneralGroup"):GetHeight())
        return
    end

    -- Spell Name
    if ttype == "Cast" or ttype == "Ability" or ttype == "Cooldown" or ttype == "Buff" or ttype == "Debuff" or ttype == "AMP Cooldown" or ttype == "Gadget" then
        self.wndRight:FindChild("SpellName"):SetText(trigger.spellName or "")
        self.wndRight:FindChild("SpellName"):SetData({"spellName","build"})
    end

    -- Unit
    if ttype == "Cast" or ttype == "Buff" or ttype == "Debuff" or ttype == "Attribute" or ttype == "AMP Cooldown" or ttype == "Unit" then
        self.wndRight:FindChild("UnitDropdown"):AttachWindow(self.wndRight:FindChild("UnitDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("UnitDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("UnitDropdown"):SetText(trigger.unit or "Choose")
        self.wndRight:FindChild("UnitDropdown"):SetData({"unit","build"})

        for _,button in pairs(self.wndRight:FindChild("UnitDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == trigger.unit then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end
    end

    -- Gadget
    if ttype == "Gadget" then
        self.wndRight:FindChild("ItemDropdown"):AttachWindow(self.wndRight:FindChild("ItemDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("ItemDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("ItemDropdown"):SetText(trigger.gadget or "")
        self.wndRight:FindChild("ItemDropdown"):SetData({"gadget","build"})

        for _,button in pairs(self.wndRight:FindChild("ItemDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == trigger.gadget then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end
    end

    -- Script
    if ttype == "Script" then
        self.wndRight:FindChild("ScriptText"):SetText(trigger.script or "")
    end

    -- Duration
    if ttype == "Cooldown" or ttype == "Buff" or ttype == "Debuff" or ttype == "Gadget" or ttype == "Innate" or ttype == "AMP Cooldown" or ttype == "Cast" then
        -- Textbox
        self.wndRight:FindChild("DurationText"):SetText(trigger.duration.value or "")
        self.wndRight:FindChild("DurationText"):SetData({{"duration","value"}})

        -- Operator
        self.wndRight:FindChild("DurationDropdown"):AttachWindow(self.wndRight:FindChild("DurationDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("DurationDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("DurationDropdown"):SetTextRaw(trigger.duration.operator or "")
        self.wndRight:FindChild("DurationDropdown"):SetData({{"duration","operator"}})

        for _,button in pairs(self.wndRight:FindChild("DurationDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if self.text.operator[button:GetName()] == trigger.duration.operator then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end
    end

    -- Charges
    if ttype == "Cooldown" then
        -- Textbox
        self.wndRight:FindChild("ChargesText"):SetText(trigger.charges.value or "")
        self.wndRight:FindChild("ChargesText"):SetData({{"charges","value"}})

        -- Operator
        self.wndRight:FindChild("ChargesDropdown"):AttachWindow(self.wndRight:FindChild("ChargesDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("ChargesDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("ChargesDropdown"):SetTextRaw(trigger.charges.operator or "")
        self.wndRight:FindChild("ChargesDropdown"):SetData({{"charges","operator"}})

        for _,button in pairs(self.wndRight:FindChild("ChargesDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if self.text.operator[button:GetName()] == trigger.charges.operator then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end
    end

    -- Stacks
    if ttype == "Buff" or ttype == "Debuff" then
        -- Textbox
        self.wndRight:FindChild("StacksText"):SetText(trigger.stacks.value or "")
        self.wndRight:FindChild("StacksText"):SetData({{"stacks","value"}})

        -- Operator
        self.wndRight:FindChild("StacksDropdown"):AttachWindow(self.wndRight:FindChild("StacksDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("StacksDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("StacksDropdown"):SetTextRaw(trigger.stacks.operator or "")
        self.wndRight:FindChild("StacksDropdown"):SetData({{"stacks","operator"}})

        for _,button in pairs(self.wndRight:FindChild("StacksDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if self.text.operator[button:GetName()] == trigger.stacks.operator then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Threshold Slider
        self.wndRight:FindChild("ThresholdSetting"):FindChild("SliderText"):SetText(trigger.duration.threshold or 0)
        self.wndRight:FindChild("ThresholdSlider"):SetValue(trigger.duration.threshold or 0)
        self.wndRight:FindChild("ThresholdSlider"):SetData({{"duration","threshold"}})

        -- Ownership Checkbox
        self.wndRight:FindChild("OwnerSetting"):FindChild("CheckboxBtn"):SetData({"spellOwner","build"})
        self.wndRight:FindChild("OwnerSetting"):FindChild("Pass"):Show(trigger.spellOwner == true,true)
        self.wndRight:FindChild("OwnerSetting"):FindChild("Fail"):Show(trigger.spellOwner == false,true)
        self.wndRight:FindChild("OwnerSetting"):FindChild("Fail"):FindChild("Hover"):Show(false,true)
    end

    if ttype == "Attribute" then
        for title,attributes in pairs(self.stats) do
            local category = Apollo.LoadForm(self.parent.xmlDoc, "Items:AttributeGroup", wndTrigger, self)
            category:FindChild("Label"):SetText(title)
            local count = 0
            local height = 0
            local divider = nil

            for _,attribute in pairs(attributes) do
                local setting = Apollo.LoadForm(self.parent.xmlDoc, "Items:Attribute", category:FindChild("Settings"), self)
                setting:FindChild("Label"):SetText(attribute)
                setting:Show(true)
                count = count + 1
                height = setting:GetHeight()
                divider = setting:FindChild("Divider")

                local value = ""
                local operator = ""
                local percent = false
                local enable = false
                local showPercent = false

                if trigger.attributes and trigger.attributes[attribute] then
                    enable = trigger.attributes[attribute].enable
                    value = trigger.attributes[attribute].value
                    operator = trigger.attributes[attribute].operator
                    percent = trigger.attributes[attribute].percent
                end

                if attribute == "Health" or attribute == "Shield" or attribute == "Absorb" or attribute == "Focus" or attribute == "Class Resource" then
                    showPercent = true
                end

                -- Enable
                setting:FindChild("AttributeCheckbox"):SetCheck(enable or false)
                setting:FindChild("AttributeCheckbox"):SetData({{"attributes",attribute},"build"})

                -- Textbox
                setting:FindChild("ValueText"):SetText(value or "")
                setting:FindChild("ValueText"):SetData({{"attributes",attribute,"value"},"build"})

                -- Operator
                setting:FindChild("OperatorDropdown"):AttachWindow(setting:FindChild("OperatorDropdown"):FindChild("ChoiceContainer"))
                setting:FindChild("OperatorDropdown"):FindChild("ChoiceContainer"):Show(false)
                setting:FindChild("OperatorDropdown"):SetTextRaw(operator or "")
                setting:FindChild("OperatorDropdown"):SetData({{"attributes",attribute,"operator"},"build"})

                for _,button in pairs(setting:FindChild("OperatorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
                    if self.text.operator[button:GetName()] == operator then
                        button:SetCheck(true)
                    else
                        button:SetCheck(false)
                    end
                end

                -- Percent
                setting:FindChild("PercentCheckbox"):SetCheck(percent or false)
                setting:FindChild("PercentCheckbox"):SetData({{"attributes",attribute,"percent"},"build"})
                setting:FindChild("PercentCheckbox"):Show(showPercent,true)

                if count == 1 then
                    setting:SetAnchorOffsets(0,0,0,67)
                    setting:FindChild("AttributeCheckbox"):SetAnchorOffsets(10,7,40,-2)
                    setting:FindChild("Label"):SetAnchorOffsets(50,3,275,0)
                    setting:FindChild("ValueSetting"):SetAnchorOffsets(275,7,0,-3)
                end

                self:ToggleSettings(setting:FindChild("ValueSetting"),enable)
                setting:FindChild("ValueSetting"):SetData(enable and "" or "locked")
            end

            divider:Show(false,true)
            category:FindChild("Settings"):ArrangeChildrenVert()
            category:SetAnchorOffsets(0,0,0,65 + 18 + (count * height))
        end

        wndTrigger:ArrangeChildrenVert()

        self.wndRight:FindChild("TriggerContainer"):SetAnchorOffsets(0,10,0,10 + wndTrigger:GetHeight())
        self.wndRight:FindChild("TriggerContainer"):GetParent():SetAnchorOffsets(0,0,0,10 + self.wndRight:FindChild("GeneralGroup"):GetHeight() + wndTrigger:GetHeight())
    end

    if ttype == "Keybind" then
        -- Key Textbox
        self.wndRight:FindChild("KeyButton"):SetText(trigger.keybind.text or "Press Key")

        -- Duration Slider
        self.wndRight:FindChild("DurationSetting"):FindChild("SliderText"):SetText(trigger.keybind.duration or 0)
        self.wndRight:FindChild("DurationSlider"):SetValue(trigger.keybind.duration or 0)
        self.wndRight:FindChild("DurationSlider"):SetData({{"keybind","duration"}})
    end

    if ttype == "AMP Cooldown" then
        -- Aura Type Dropdown
        self.wndRight:FindChild("TypeDropdown"):AttachWindow(self.wndRight:FindChild("TypeDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("TypeDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("TypeDropdown"):SetTextRaw(trigger.auraType or "Choose")
        self.wndRight:FindChild("TypeDropdown"):SetData({"auraType","build"})

        for _,button in pairs(self.wndRight:FindChild("TypeDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == trigger.auraType then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Duration Slider
        self.wndRight:FindChild("TimeSetting"):FindChild("SliderText"):SetText(trigger.time or 0)
        self.wndRight:FindChild("TimeSlider"):SetValue(trigger.time or 0)
        self.wndRight:FindChild("TimeSlider"):SetData("time")

        -- Ownership Checkbox
        self.wndRight:FindChild("OwnerSetting"):FindChild("CheckboxBtn"):SetData({"spellOwner","build"})
        self.wndRight:FindChild("OwnerSetting"):FindChild("Pass"):Show(trigger.spellOwner == true,true)
        self.wndRight:FindChild("OwnerSetting"):FindChild("Fail"):Show(trigger.spellOwner == false,true)
        self.wndRight:FindChild("OwnerSetting"):FindChild("Fail"):FindChild("Hover"):Show(false,true)
    end

    if ttype == "Threat" then
        -- Threat Textbox
        self.wndRight:FindChild("ThreatText"):SetText(trigger.threat.value or "")
        self.wndRight:FindChild("ThreatText"):SetData({{"threat","value"}})

        -- Threat Operator
        self.wndRight:FindChild("ThreatDropdown"):AttachWindow(self.wndRight:FindChild("ThreatDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("ThreatDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("ThreatDropdown"):SetTextRaw(trigger.threat.operator or "")
        self.wndRight:FindChild("ThreatDropdown"):SetData({{"threat","operator"}})

        for _,button in pairs(self.wndRight:FindChild("ThreatDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if self.text.operator[button:GetName()] == trigger.threat.operator then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Status Dropdown
        self.wndRight:FindChild("StatusDropdown"):FindChild("ChoiceContainer"):DestroyChildren()
        local sCount = 8
        local sCurrent = 0

        for id,status in self.parent:Sort(self.text.threat) do
            local dropdownItem = nil
            local item = "Items:Dropdown:MidItem"
            local offset = 30 * sCurrent

            if sCount > 1 then
                if sCurrent == 0 then
                    item = "Items:Dropdown:TopItem"
                elseif sCurrent == (sCount -1) then
                    item = "Items:Dropdown:BottomItem"
                end
            else
                item = "Items:Dropdown:SingleItem"
            end

            -- Stack Sources
            local triggerItem = Apollo.LoadForm(self.parent.xmlDoc, item, self.wndRight:FindChild("StatusDropdown"):FindChild("ChoiceContainer"), self)
            triggerItem:SetText(self.text.threat[tostring(sCurrent)])
            triggerItem:SetData(sCurrent)
            triggerItem:SetCheck(trigger.threat.status == sCurrent)
            triggerItem:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
            triggerItem:AddEventHandler("ButtonCheck", "OnThreatTriggerChoose", self)

            sCurrent = sCurrent + 1
        end

        self.wndRight:FindChild("StatusDropdown"):AttachWindow(self.wndRight:FindChild("StatusDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("StatusDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,350,77 + (sCount * 30))
        self.wndRight:FindChild("StatusDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("StatusDropdown"):SetData({{"threat","status"},"build"})
        self.wndRight:FindChild("StatusDropdown"):SetText(trigger.threat.status and self.text.threat[tostring(trigger.threat.status)] or "Choose")
    end

    if ttype == "Unit" then
        -- Unit Name
        self.wndRight:FindChild("UnitName"):SetText(trigger.unitName or "")
        self.wndRight:FindChild("UnitName"):SetData({"unitName","build"})

        -- Level Textbox
        self.wndRight:FindChild("LevelText"):SetText(trigger.level.value or "")
        self.wndRight:FindChild("LevelText"):SetData({{"level","value"},"build"})

        -- Operator
        self.wndRight:FindChild("LevelDropdown"):AttachWindow(self.wndRight:FindChild("LevelDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("LevelDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("LevelDropdown"):SetTextRaw(trigger.level.operator or "")
        self.wndRight:FindChild("LevelDropdown"):SetData({{"level","operator"},"build"})

        for _,button in pairs(self.wndRight:FindChild("LevelDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if self.text.operator[button:GetName()] == trigger.level.operator then
                button:SetCheck(true)
            else
                button:SetCheck(false)
            end
        end

        -- Class
        local wndClass = self.wndRight:FindChild("ClassBox")

        for k,v in self.parent:Sort(self.text.classes) do
            local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:CheckboxTriple", wndClass, self)
            checkbox:FindChild("Label"):SetText(v)
            checkbox:FindChild("CheckboxBtn"):SetData({{"class",k},"build"})
            checkbox:FindChild("Pass"):Show(trigger.class[k] == true,true)
            checkbox:FindChild("Fail"):Show(trigger.class[k] == false,true)
            checkbox:FindChild("Fail"):FindChild("Hover"):Show(false,true)
        end

        -- Hostility
        local wndHostility = self.wndRight:FindChild("HostilityBox")

        for k,v in self.parent:Sort(self.text.hostility) do
            local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:CheckboxTriple", wndHostility, self)
            checkbox:FindChild("Label"):SetText(v)
            checkbox:FindChild("CheckboxBtn"):SetData({{"hostility",k},"build"})
            checkbox:FindChild("Pass"):Show(trigger.hostility[k] == true,true)
            checkbox:FindChild("Fail"):Show(trigger.hostility[k] == false,true)
            checkbox:FindChild("Fail"):FindChild("Hover"):Show(false,true)
        end

        -- Rank
        local wndRank = self.wndRight:FindChild("RankBox")

        for k,v in self.parent:Sort(self.text.rank) do
            local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:CheckboxTriple", wndRank, self)
            checkbox:FindChild("Label"):SetText(v)
            checkbox:FindChild("CheckboxBtn"):SetData({{"rank",k},"build"})
            checkbox:FindChild("Pass"):Show(trigger.rank[k] == true,true)
            checkbox:FindChild("Fail"):Show(trigger.rank[k] == false,true)
            checkbox:FindChild("Fail"):FindChild("Hover"):Show(false,true)
        end

        -- Difficulty
        local wndDifficulty = self.wndRight:FindChild("DifficultyBox")

        for k,v in self.parent:Sort(self.text.difficulty) do
            local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:CheckboxTriple", wndDifficulty, self)
            checkbox:FindChild("Label"):SetText(v)
            checkbox:FindChild("CheckboxBtn"):SetData({{"difficulty",k},"build"})
            checkbox:FindChild("Pass"):Show(trigger.difficulty[k] == true,true)
            checkbox:FindChild("Fail"):Show(trigger.difficulty[k] == false,true)
            checkbox:FindChild("Fail"):FindChild("Hover"):Show(false,true)
        end

        -- Circumstances
        local wndCircumstances = self.wndRight:FindChild("CircumstancesBox")

        for k,v in self.parent:Sort(self.text.circumstances) do
            local checkbox = Apollo.LoadForm(self.parent.xmlDoc, "Items:CheckboxTriple", wndCircumstances, self)
            checkbox:FindChild("Label"):SetText(v)
            checkbox:SetAnchorPoints(0,0,0.333,0)
            checkbox:FindChild("CheckboxBtn"):SetData({{"circumstances",k},"build"})
            checkbox:FindChild("Pass"):Show(trigger.circumstances[k] == true,true)
            checkbox:FindChild("Fail"):Show(trigger.circumstances[k] == false,true)
            checkbox:FindChild("Fail"):FindChild("Hover"):Show(false,true)
        end

        wndClass:ArrangeChildrenVert()
        wndHostility:ArrangeChildrenVert()
        wndRank:ArrangeChildrenVert()
        wndDifficulty:ArrangeChildrenVert()
        wndCircumstances:ArrangeChildrenTiles()
    end

    for _,child in pairs(self.wndRight:FindChild("TriggerContainer"):GetChildren()) do
        self:ToggleSettings(child,trigger.enable)
    end

    self.wndRight:RecalculateContentExtents()
end

-- ########################################################################################################################################
-- # BUILD MAIN GROUP SETTINGS
-- ########################################################################################################################################

function Settings:BuildMainGroupSettings(groupId)
    local group = self.parent.config.groups[groupId]

    if self.activeTab ~= nil then
        if
            self.activeTab ~= "GeneralTab" and
            self.activeTab ~= "AppearanceTab" and
            self.activeTab ~= "BarTab" and
            self.activeTab ~= "TextTab" and
            self.activeTab ~= "AnimationTab"
        then
            self.activeTab = "GeneralTab"
        end

        if group.enable == false then
            self.activeTab = "GeneralTab"
        end
    else
        self.activeTab = "GeneralTab"
    end

    for _,child in pairs(self.wndRight:FindChild("TopTabContainer"):GetChildren()) do
        if child:GetName() == self.activeTab then
            child:SetCheck(true)
        else
            child:SetCheck(false)
        end
    end

    for _,child in pairs(self.wndRight:GetChildren()) do
        if child:GetName() ~= "TopTabContainer" then
            if child:GetName() == self.activeTab then
                child:Show(true, true)
            else
                child:Show(false, true)
            end
        end
    end

    -- Enable
    self.wndRight:FindChild("EnableCheckbox"):SetCheck(group.enable)
    self.wndRight:FindChild("EnableCheckbox"):SetData({"enable","check"})

    -- Locked
    self.wndRight:FindChild("UnlockCheckbox"):SetCheck(group.locked)

    -- Name
    self.wndRight:FindChild("NameText"):SetText(group.name)
    self.wndRight:FindChild("NameText"):SetData("name")

    -- General Tab
    self:AddDynamicGroupSettings(group,true)
    self:AddVisibilitySettings(group,true)
    self:AddZoneSettings(group,true)

    -- Appearance Tab
    self:AddIconSettings(group,true)
    self:AddBorderSettings(group,true)
    self:AddOverlaySettings(group,true)
    self:AddSoundSettings(group,true)

    -- Bar Tab
    self:AddBarSettings(group,true)

    -- Animation Tab
    self:AddAnimationSettings(group,true)

    -- Text Tab
    self:AddTextSettings(group,"Duration",true)
    self:AddTextSettings(group,"Stacks",true)
    self:AddTextSettings(group,"Charges",true)
    self:AddTextSettings(group,"Text",true)

    self.wndRight:FindChild("TextTab"):RecalculateContentExtents()

    for _,child in pairs(self.wndRight:FindChild("GeneralTab"):GetChildren()) do
        self:ToggleSettings(child,group.enable)
    end

    for _,child in pairs(self.wndRight:FindChild("TopTabContainer"):GetChildren()) do
        self:ToggleSettings(child,group.enable)
    end
end

-- ########################################################################################################################################
-- # BUILD TRIGGER GROUP SETTINGS
-- ########################################################################################################################################

function Settings:BuildGroupSettings(groupId, auraId, triggerId)
    local aura = self.parent.config.groups[groupId].runtime.auras[auraId]
    local trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId]

    if self.activeTab ~= nil then
        if self.activeTab ~= "GeneralTab" and self.activeTab ~= "TriggerEffectsTab" then
            self.activeTab = "GeneralTab"
        end

        if trigger.enable == false then
            self.activeTab = "GeneralTab"
        end
    else
        self.activeTab = "GeneralTab"
    end

    for _,child in pairs(self.wndRight:FindChild("TopTabContainer"):GetChildren()) do
        if child:GetName() == self.activeTab then
            child:SetCheck(true)
        else
            child:SetCheck(false)
        end
    end

    for _,child in pairs(self.wndRight:GetChildren()) do
        if child:GetName() ~= "TopTabContainer" then
            if child:GetName() == self.activeTab then
                child:Show(true, true)
            else
                child:Show(false, true)
            end
        end
    end

    -- Enable
    self.wndRight:FindChild("EnableCheckbox"):SetCheck(trigger.enable)
    self.wndRight:FindChild("EnableCheckbox"):SetData({"enable","check"})

    -- Name
    self.wndRight:FindChild("NameText"):SetText(trigger.name)
    self.wndRight:FindChild("NameText"):SetData("name")

    -- Behavior Dropdown
    self.wndRight:FindChild("BehaviorDropdown"):AttachWindow(self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BehaviorDropdown"):SetText(trigger.behavior)
    self.wndRight:FindChild("BehaviorDropdown"):SetData("behavior")

    for _,button in pairs(self.wndRight:FindChild("BehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == trigger.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end
    end

    self:AddTriggerEffects(aura,trigger,true)
end

-- ########################################################################################################################################
-- # BUILD GLOBAL SETTINGS
-- ########################################################################################################################################

function Settings:BuildGlobalSettings()
    local wndFullScroll = self.wndSettings:FindChild("FullScroll")
    wndGlobal = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Global", wndFullScroll, self)

    -- Interval
    wndGlobal:FindChild("IntervalSetting"):FindChild("SliderText"):SetText(tostring(self.parent.config.interval) .. " ms")
    wndGlobal:FindChild("IntervalSlider"):SetValue(self.parent.config.interval)
    wndGlobal:FindChild("IntervalSlider"):SetData("interval")

    -- Add Default Auras
    local JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
    local tSetting = nil

    for idx,group in pairs(self.parent.defaults.groups) do
        tSetting = {
            export = "group",
            setting = group,
        }

        local wndDefaultItem = Apollo.LoadForm(self.parent.xmlDoc, "Items:ShareItem", wndGlobal:FindChild("AuraList"), self)
        wndDefaultItem:SetAnchorPoints(0,0,0.5,0)
        wndDefaultItem:FindChild("ItemName"):SetText(group.name)
        wndDefaultItem:FindChild("ItemType"):SetText(#group.auras == 1 and tostring(#group.auras).." Aura" or tostring(#group.auras).." Auras")
        wndDefaultItem:FindChild("CopyButton"):SetActionData(GameLib.CodeEnumConfirmButtonType.CopyToClipboard, JSON.encode(tSetting))
        wndDefaultItem:FindChild("CopyButton"):SetAnchorOffsets(-184,8,-15,-8)
        wndDefaultItem:FindChild("DeleteBtn"):Show(false,true)
    end

    wndGlobal:FindChild("AuraList"):ArrangeChildrenTiles()
end

-- ########################################################################################################################################
-- # TRIGGER EFFECTS
-- ########################################################################################################################################

function Settings:AddTriggerEffects(aura,trigger,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Trigger:Container", self.wndRight:FindChild("TriggerEffectsTab"):FindChild("Container"), self)

    -- Enable Icon Checkbox
    self.wndRight:FindChild("EnableIconCheckbox"):SetCheck(trigger.icon.enable or false)
    self.wndRight:FindChild("EnableIconCheckbox"):SetData({{"icon","enable"},"build"})

    -- Icon Sprite
    self.wndRight:FindChild("IconSpriteText"):SetText(trigger.icon.sprite or aura.icon.sprite)
    self.wndRight:FindChild("SpriteSetting"):FindChild("BrowseIcons"):SetData({{"icon","sprite"},"IconSpriteText"})

    -- Icon Behavior Dropdown
    self.wndRight:FindChild("IconBehaviorDropdown"):AttachWindow(self.wndRight:FindChild("IconBehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("IconBehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("IconBehaviorDropdown"):SetText(trigger.icon.behavior or "Choose")
    self.wndRight:FindChild("IconBehaviorDropdown"):SetData({{"icon","behavior"},"build"})

    if isGroup then
        self.wndRight:FindChild("IconBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,167)
    else
        self.wndRight:FindChild("IconBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,137)
    end

    for _,button in pairs(self.wndRight:FindChild("IconBehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == trigger.icon.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end

        if isGroup then
            button:Show((button:GetName() ~= "Pass" and button:GetName() ~= "Fail"),true)
        else
            button:Show((button:GetName() == "Pass" or button:GetName() == "Fail"),true)
        end
    end

    -- Icon Color
    self.wndRight:FindChild("IconColor"):SetData({"icon","color"})
    self.wndRight:FindChild("IconColorBtn"):SetData(trigger.icon.color or aura.icon.color)
    self.wndRight:FindChild("IconColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        trigger.icon.color and trigger.icon.color.r or aura.icon.color.r,
        trigger.icon.color and trigger.icon.color.g or aura.icon.color.g,
        trigger.icon.color and trigger.icon.color.b or aura.icon.color.b,
        trigger.icon.color and trigger.icon.color.a or aura.icon.color.a
    ))
    self.wndRight:FindChild("IconColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        trigger.icon.color and trigger.icon.color.r / 255 or aura.icon.color.r / 255,
        trigger.icon.color and trigger.icon.color.g / 255 or aura.icon.color.g / 255,
        trigger.icon.color and trigger.icon.color.b / 255 or aura.icon.color.b / 255,
        trigger.icon.color and trigger.icon.color.a / 255 or aura.icon.color.a / 255
    ))

    for _,child in pairs(self.wndRight:FindChild("IconGroup"):GetChildren()) do
        self:ToggleSettings(child,trigger.icon.enable)
    end

    -- Enable Bar Checkbox
    self.wndRight:FindChild("EnableBarCheckbox"):SetCheck(trigger.bar.enable or false)
    self.wndRight:FindChild("EnableBarCheckbox"):SetData({{"bar","enable"},"build"})

    -- Invert Bar Checkbox
    local invert = aura.bar.invert

    if trigger.bar.invert ~= nil then
        invert = trigger.bar.invert
    end

    self.wndRight:FindChild("InvertBarCheckbox"):SetCheck(invert)
    self.wndRight:FindChild("InvertBarCheckbox"):SetData({{"bar","invert"},"build"})

    -- Bar Behavior Dropdown
    self.wndRight:FindChild("BarBehaviorDropdown"):AttachWindow(self.wndRight:FindChild("BarBehaviorDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BarBehaviorDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BarBehaviorDropdown"):SetText(trigger.bar.behavior or "Choose")
    self.wndRight:FindChild("BarBehaviorDropdown"):SetData({{"bar","behavior"},"build"})

    if isGroup then
        self.wndRight:FindChild("BarBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,167)
    else
        self.wndRight:FindChild("BarBehaviorDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-19,-25,246,137)
    end

    for _,button in pairs(self.wndRight:FindChild("BarBehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == trigger.bar.behavior then
            button:SetCheck(true)
        else
            button:SetCheck(false)
        end

        if isGroup then
            button:Show((button:GetName() ~= "Pass" and button:GetName() ~= "Fail"),true)
        else
            button:Show((button:GetName() == "Pass" or button:GetName() == "Fail"),true)
        end
    end

    -- Bar Fill Texture
    self.wndRight:FindChild("BarFillTextureText"):SetText(trigger.bar.sprite_fill or aura.bar.sprite_fill)
    self.wndRight:FindChild("BarFillTextureText"):SetData({{"bar","sprite_fill"},"build"})
    self.wndRight:FindChild("BarFillTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_fill"},"BarFillTextureText"})

    -- Bar Empty Texture
    self.wndRight:FindChild("BarEmptyTextureText"):SetText(trigger.bar.sprite_empty or aura.bar.sprite_empty)
    self.wndRight:FindChild("BarEmptyTextureText"):SetData({{"bar","sprite_empty"},"build"})
    self.wndRight:FindChild("BarEmptyTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_empty"},"BarEmptyTextureText"})

    -- Bar Background Texture
    self.wndRight:FindChild("BarBGTextureText"):SetText(trigger.bar.sprite_bg or aura.bar.sprite_bg)
    self.wndRight:FindChild("BarBGTextureText"):SetData({{"bar","sprite_bg"},"build"})
    self.wndRight:FindChild("BarBGTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_bg"},"BarBGTextureText"})

    -- Border Sprite
    self.wndRight:FindChild("BarBorderTextureText"):SetText(trigger.bar.sprite_border or aura.bar.sprite_border)
    self.wndRight:FindChild("BarBorderTextureText"):SetData({{"bar","sprite_border"},"build"})
    self.wndRight:FindChild("BarBorderTextureSetting"):FindChild("BrowseTextures"):SetData({{"bar","sprite_border"},"BarBorderTextureText"})

    -- Border Inset
    self.wndRight:FindChild("BarBorderInsetSetting"):FindChild("SliderText"):SetText(trigger.bar.border_inset or aura.bar.border_inset)
    self.wndRight:FindChild("BarBorderInsetSlider"):SetValue(trigger.bar.border_inset or aura.bar.border_inset)
    self.wndRight:FindChild("BarBorderInsetSlider"):SetData({{"bar","border_inset"},"build"})

    -- Bar Spacing Slider
    self.wndRight:FindChild("BarSpacingSetting"):FindChild("SliderText"):SetText(trigger.bar.spacing or aura.bar.spacing)
    self.wndRight:FindChild("BarSpacingSlider"):SetValue(trigger.bar.spacing or aura.bar.spacing)
    self.wndRight:FindChild("BarSpacingSlider"):SetData({{"bar","spacing"},"build"})

    -- Bar Fill Color
    self.wndRight:FindChild("BarFillColor"):SetData({"bar","color_fill"})
    self.wndRight:FindChild("BarFillColorBtn"):SetData(trigger.bar.color_fill or aura.bar.color_fill)
    self.wndRight:FindChild("BarFillColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        trigger.bar.color_fill and trigger.bar.color_fill.r or aura.bar.color_fill.r,
        trigger.bar.color_fill and trigger.bar.color_fill.g or aura.bar.color_fill.g,
        trigger.bar.color_fill and trigger.bar.color_fill.b or aura.bar.color_fill.b,
        trigger.bar.color_fill and trigger.bar.color_fill.a or aura.bar.color_fill.a
    ))
    self.wndRight:FindChild("BarFillColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        trigger.bar.color_fill and trigger.bar.color_fill.r / 255 or aura.bar.color_fill.r / 255,
        trigger.bar.color_fill and trigger.bar.color_fill.g / 255 or aura.bar.color_fill.g / 255,
        trigger.bar.color_fill and trigger.bar.color_fill.b / 255 or aura.bar.color_fill.b / 255,
        trigger.bar.color_fill and trigger.bar.color_fill.a / 255 or aura.bar.color_fill.a / 255
    ))

    -- Bar Empty Color
    self.wndRight:FindChild("BarEmptyColor"):SetData({"bar","color_empty"})
    self.wndRight:FindChild("BarEmptyColorBtn"):SetData(trigger.bar.color_empty or aura.bar.color_empty)
    self.wndRight:FindChild("BarEmptyColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        trigger.bar.color_empty and trigger.bar.color_empty.r or aura.bar.color_empty.r,
        trigger.bar.color_empty and trigger.bar.color_empty.g or aura.bar.color_empty.g,
        trigger.bar.color_empty and trigger.bar.color_empty.b or aura.bar.color_empty.b,
        trigger.bar.color_empty and trigger.bar.color_empty.a or aura.bar.color_empty.a
    ))
    self.wndRight:FindChild("BarEmptyColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        trigger.bar.color_empty and trigger.bar.color_empty.r / 255 or aura.bar.color_empty.r / 255,
        trigger.bar.color_empty and trigger.bar.color_empty.g / 255 or aura.bar.color_empty.g / 255,
        trigger.bar.color_empty and trigger.bar.color_empty.b / 255 or aura.bar.color_empty.b / 255,
        trigger.bar.color_empty and trigger.bar.color_empty.a / 255 or aura.bar.color_empty.a / 255
    ))

    -- Bar Background Color
    self.wndRight:FindChild("BarBGColor"):SetData({"bar","color_bg"})
    self.wndRight:FindChild("BarBGColorBtn"):SetData(trigger.bar.color_bg or aura.bar.color_bg)
    self.wndRight:FindChild("BarBGColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        trigger.bar.color_bg and trigger.bar.color_bg.r or aura.bar.color_bg.r,
        trigger.bar.color_bg and trigger.bar.color_bg.g or aura.bar.color_bg.g,
        trigger.bar.color_bg and trigger.bar.color_bg.b or aura.bar.color_bg.b,
        trigger.bar.color_bg and trigger.bar.color_bg.a or aura.bar.color_bg.a
    ))
    self.wndRight:FindChild("BarBGColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        trigger.bar.color_bg and trigger.bar.color_bg.r / 255 or aura.bar.color_bg.r / 255,
        trigger.bar.color_bg and trigger.bar.color_bg.g / 255 or aura.bar.color_bg.g / 255,
        trigger.bar.color_bg and trigger.bar.color_bg.b / 255 or aura.bar.color_bg.b / 255,
        trigger.bar.color_bg and trigger.bar.color_bg.a / 255 or aura.bar.color_bg.a / 255
    ))

    -- Bar Border Color
    self.wndRight:FindChild("BarBorderColor"):SetData({"bar","color_border"})
    self.wndRight:FindChild("BarBorderColorBtn"):SetData(trigger.bar.color_border or aura.bar.color_border)
    self.wndRight:FindChild("BarBorderColorBtn"):GetParent():FindChild("ColorText"):SetText(GeminiColor:RGBAToHex(
        trigger.bar.color_border and trigger.bar.color_border.r or aura.bar.color_border.r,
        trigger.bar.color_border and trigger.bar.color_border.g or aura.bar.color_border.g,
        trigger.bar.color_border and trigger.bar.color_border.b or aura.bar.color_border.b,
        trigger.bar.color_border and trigger.bar.color_border.a or aura.bar.color_border.a
    ))
    self.wndRight:FindChild("BarBorderColorBtn"):GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(
        trigger.bar.color_border and trigger.bar.color_border.r / 255 or aura.bar.color_border.r / 255,
        trigger.bar.color_border and trigger.bar.color_border.g / 255 or aura.bar.color_border.g / 255,
        trigger.bar.color_border and trigger.bar.color_border.b / 255 or aura.bar.color_border.b / 255,
        trigger.bar.color_border and trigger.bar.color_border.a / 255 or aura.bar.color_border.a / 255
    ))

    -- Bar Direction Dropdown
    self.wndRight:FindChild("BarDirectionDropdown"):AttachWindow(self.wndRight:FindChild("BarDirectionDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("BarDirectionDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("BarDirectionDropdown"):SetData({{"bar","direction"},"build"})
    self.wndRight:FindChild("BarDirectionDropdown"):SetText("Choose")

    for _,button in pairs(self.wndRight:FindChild("BarDirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if button:GetName() == trigger.bar.direction then
            button:SetCheck(true)
            self.wndRight:FindChild("BarDirectionDropdown"):SetText(button:GetText())
        else
            button:SetCheck(false)
        end
    end

    if self.wndRight:FindChild("BarDirectionDropdown"):GetText() == "Choose" then
        for _,button in pairs(self.wndRight:FindChild("BarDirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            if button:GetName() == aura.bar.direction then
                self.wndRight:FindChild("BarDirectionDropdown"):SetText(button:GetText())
            end
        end
    end

    for _,child in pairs(self.wndRight:FindChild("BarGroup"):GetChildren()) do
        self:ToggleSettings(child,trigger.bar.enable)
    end

    self:AddBorderSettings(trigger,false,not isGroup,isGroup)
    self:AddSoundSettings(trigger,false,not isGroup,isGroup)
    self:AddSourceSettings(trigger,isGroup)
end

-- ########################################################################################################################################
-- # LOCATION SETTING
-- ########################################################################################################################################

function Settings:AddZoneSettings(aura,isGroup)
    Apollo.LoadForm(self.parent.xmlDoc, "Options:Zones", self.wndRight:FindChild("ZonesGroup"), self)

    -- Zone Whitelist
    if #aura.zones >= 1 then
        local grid = self.wndRight:FindChild("ZonesGrid")

        for _,v in pairs(aura.zones) do
            grid:AddRow(v.strName)
        end
    end

    -- Zone Dropdown
    local currentZone = 0
    local countZones = 0

    for k,v in pairs(self.parent.zones) do
        countZones = countZones + 1
    end

    for zoneName,zone in self.parent:Sort(self.parent.zones) do
        currentZone = currentZone + 1

        local dropdownItem = nil
        local item = "Items:Dropdown:MidItem"
        local offset = 30 * (currentZone -1)

        if countZones > 1 then
            if currentZone == 1 then
                item = "Items:Dropdown:TopItem"
            elseif currentZone == countZones then
                item = "Items:Dropdown:BottomItem"
            end
        else
            item = "Items:Dropdown:SingleItem"
        end

        dropdownItem = Apollo.LoadForm(self.parent.xmlDoc, item, self.wndRight:FindChild("ZoneDropdown"):FindChild("ChoiceContainer"), self)
        dropdownItem:SetText(zoneName)
        dropdownItem:SetCheck(false)
        dropdownItem:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
        dropdownItem:SetData(zone)
        dropdownItem:AddEventHandler("ButtonCheck", "OnZoneChoose", self)
    end

    self.wndRight:FindChild("ZoneDropdown"):AttachWindow(self.wndRight:FindChild("ZoneDropdown"):FindChild("ChoiceContainer"))
    self.wndRight:FindChild("ZoneDropdown"):FindChild("ChoiceContainer"):Show(false)
    self.wndRight:FindChild("ZoneDropdown"):SetText("Zones")
    self.wndRight:FindChild("ZoneDropdown"):FindChild("ChoiceContainer"):SetAnchorPoints(0,1,1,1)
    self.wndRight:FindChild("ZoneDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-25,-35,25,67 + (countZones * 30))

    -- Disable Subzone Dropdown
    self.wndRight:FindChild("SubzoneDropdown"):Enable(false)
    self.wndRight:FindChild("SubzoneDropdown"):SetData("locked")
    self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"):Show(false)
end

-- ########################################################################################################################################
-- # FORMS
-- ########################################################################################################################################

function Settings:OnCheckbox(wndHandler, wndControl)
    local setting = wndControl:GetData()
    local value = wndHandler:IsChecked()
    local radio = nil

    self:SetVar(value,setting)

    if type(setting) == "table" and type(setting[1]) == "table" then
        if setting[1][2] and setting[1][2] == "enable" then
            if setting[1][1] == "dynamic" then
                self.wndRight:FindChild("DynamicSettings"):SetData("")
            end

            self:ToggleSettings(wndControl:GetParent():GetParent(),value)

            if setting[1][1] == "dynamic" then
                self.wndRight:FindChild("DynamicSettings"):SetData(value and "" or "locked")
            end
        end
    end

    if self.wndLastGroupSelected ~= nil or self.wndLastAuraSelected ~= nil then
        if type(setting) == "table" and setting[1] == "enable" then
            self:ToggleSettings(wndControl:GetParent():GetParent():GetParent(),value)
            self:ToggleSettings(self.wndRight:FindChild("TopTabContainer"),value)
            self.wndRight:FindChild("UnlockCheckbox"):SetCheck(true)
            self:OnUnlock()

            if self.wndLastGroupSelected ~= nil then
                self:StyleButton(self.wndLastGroupSelected,"group",value)
            else
                self:StyleButton(self.wndLastAuraSelected,"aura",value)
            end

        elseif type(setting) == "table" and type(setting[1]) == "table" then
            if self.wndRight:FindChild("IconPreview") then
                if setting[1][1] == "icon" and setting[1][2] == "enable" then
                    self.wndRight:FindChild("IconPreview"):FindChild("Icon"):Show(value)
                elseif setting[1][1] == "border" and setting[1][2] == "enable" then
                    self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):Show(value)
                end
            end
        end
    end

    if self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
        if setting == "percent" then
            self:InsertTextSource()
        elseif setting == "enable" then
            self:ToggleSettings(wndControl:GetParent():GetParent():GetParent(),value)
            self:ToggleSettings(self.wndRight:FindChild("TopTabContainer"),value)
        end
    end

    if type(setting) == "table" and type(setting[1]) == "table" and setting[1][1] == "animation" and setting[1][3] == "enable" then
        self:ToggleSettings(self.wndRight:FindChild("AnimationSettings"),value)
    end
end

function Settings:OnTriggerSourceChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local source = wndControl:GetData()
    local name = wndControl:GetText()
    local setting = dropdown:GetData()

    if dropdown:GetParent():GetParent():GetName() == "dynamic" then
        setting = "dynamic"
    end

    if type(source) == "string" and source == "remove" then
        dropdown:SetText("Choose")
        self:SetVar("",{{"sources",setting,"source"},"build"})
    elseif type(source) == "string" and source == "none" then
        dropdown:SetText("None")
        self:SetVar("",{{"sources",setting,"source"},"build"})
    else
        dropdown:SetText(name)
        self:SetVar(source,{{"sources",setting,"source"},"build"})
    end

    wndControl:GetParent():Close()
end

function Settings:OnSourceCheckbox(wndHandler, wndControl)
    local setting = wndControl:GetData()
    local state = wndHandler:IsChecked()
    local value = nil

    if state == true then
        wndControl:GetParent():FindChild("SourceSetting"):SetData("")
        value = {
            behavior = "",
            source = "",
        }
    else
        wndControl:GetParent():FindChild("SourceSetting"):SetData("locked")
        wndControl:GetParent():FindChild("SourceBehaviorDropdown"):SetText("Choose")
        wndControl:GetParent():FindChild("SourceDropdown"):SetText("")

        for _,button in pairs(wndControl:GetParent():FindChild("SourceBehaviorDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            button:SetCheck(false)
        end

        for _,button in pairs(wndControl:GetParent():FindChild("SourceDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            button:SetCheck(false)
        end
    end

    self:ToggleSettings(wndControl:GetParent():FindChild("SourceSetting"),state)
    self:SetVar(value,setting)
end

function Settings:OnAttributeCheckbox(wndHandler, wndControl)
    local setting = wndControl:GetData()
    local state = wndHandler:IsChecked()
    local value = nil

    if state == true then
        wndControl:GetParent():FindChild("ValueSetting"):SetData("")
        value = {
            enable = true,
            operator = self.text.operator[wndControl:GetParent():FindChild("OperatorDropdown"):GetName()],
            value = tonumber(wndControl:GetParent():FindChild("ValueText"):GetText()),
            percent = wndControl:GetParent():FindChild("PercentCheckbox"):IsChecked(),
        }
    end

    self:SetVar(value,setting)
    self:ToggleSettings(wndControl:GetParent():FindChild("ValueSetting"),state)

    if state == false then
        wndControl:GetParent():FindChild("ValueSetting"):SetData("locked")
    end
end

function Settings:OnTripleCheckbox(wndHandler, wndControl)
    local setting = wndControl:GetData()
    local value = nil

    if wndControl:FindChild("Pass"):IsShown() then
        wndHandler:FindChild("Pass"):SetSprite("BK3:btnHolo_CheckPressed")
        wndHandler:FindChild("Fail"):FindChild("Hover"):Show(true)
        wndControl:FindChild("Pass"):Show(false)
        wndControl:FindChild("Fail"):Show(true)
        value = false
    elseif wndControl:FindChild("Fail"):IsShown() then
        wndControl:FindChild("Pass"):Show(false)
        wndControl:FindChild("Fail"):Show(false)
    else
        wndHandler:ChangeArt("BK3:btnHolo_CheckDisabled")
        wndHandler:FindChild("Pass"):SetSprite("BK3:btnHolo_CheckPressedFlyby")
        wndControl:FindChild("Pass"):Show(true)
        wndControl:FindChild("Fail"):Show(false)
        value = true
    end

    self:SetVar(value,setting)
end

function Settings:OnEnterTripleCheckbox(wndHandler, wndControl)
    if wndHandler:FindChild("Pass"):IsShown() then
        wndHandler:FindChild("Pass"):SetSprite("BK3:btnHolo_CheckPressedFlyby")
    elseif wndHandler:FindChild("Fail"):IsShown() then
        wndHandler:FindChild("Fail"):FindChild("Hover"):Show(true)
    else
        wndHandler:ChangeArt("BK3:btnHolo_CheckFlyby")
    end
end

function Settings:OnLeaveTripleCheckbox(wndHandler, wndControl)
    wndHandler:ChangeArt("BK3:btnHolo_CheckDisabled")
    wndHandler:FindChild("Pass"):SetSprite("BK3:btnHolo_CheckPressed")
    wndHandler:FindChild("Fail"):FindChild("Hover"):Show(false)
end

function Settings:OnSliderChange(wndHandler, wndControl)
    local setting = wndControl:GetData()
    local value = wndHandler:GetValue()
    local name = wndControl:GetName()
    local textBox = wndControl:GetParent():GetParent():FindChild("SliderText")

    if name == "IntervalSlider" then

        textBox:SetText(tostring(math.floor(value)) .. " ms")
        self:SetVar(math.floor(value),setting)

    elseif name == "DurationSlider" then

        textBox:SetText(self.parent:Round(value,2))
        self:SetVar(self.parent:Round(value,2),setting)
        self:InsertTextSource()

    elseif name == "TimeSlider" then

        textBox:SetText(self.parent:Round(value,2))
        self:SetVar(self.parent:Round(value,2),setting)
        self:InsertTextSource()

    elseif name == "SoundSlider" then

        textBox:SetText(self.parent:Round(value,1))
        self:SetVar(self.parent:Round(value,1),setting)

    elseif name == "ThresholdSlider" then

        textBox:SetText(self.parent:Round(value,2))
        self:SetVar(self.parent:Round(value,2),setting)

    elseif name == "InsetSlider" then

        textBox:SetText(value)
        self:SetVar(value,setting)

        if self.wndRight:FindChild("IconPreview") then
            self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetAnchorOffsets(
                value,
                value,
                value >= 0 and -value or math.abs(value),
                value >= 0 and -value or math.abs(value)
            )
        end

    elseif name == "AnimationDurationSlider" or name == "TransitionSlider" then

        textBox:SetText(self.parent:Round(value,2))
        self:SetVar(self.parent:Round(value,2),setting)

    elseif name == "ZoomScaleSlider" then

        textBox:SetText(self.parent:Round(value,2))
        self:SetVar(self.parent:Round(value,2),setting)

    else

        textBox:SetText(value)
        self:SetVar(value,setting)

    end
end

function Settings:OnDropdownToggle(wndHandler, wndControl)
    if wndHandler ~= wndControl then
        return
    end

    wndControl:FindChild("ChoiceContainer"):Show(wndControl:IsChecked())
end

function Settings:OnChooseAnimationPreset(wndHandler, wndControl)
    local animation = wndControl:GetData()

    if not animation or type(animation) ~= "table" then
        return
    end

    if not self.presets.animations[animation.strName] then
        return
    end

    for k,v in pairs(self.presets.animations[animation.strName]) do
        self:SetVar(v,{{"animation",animation.strAnimation,k},"nobuild"})
    end

    local groupId, auraId, triggerId, childId = self:GetIdentifiers()

    self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
    self.wndRight:Destroy()

    if auraId then
        self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Aura", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
        self:BuildAuraSettings(groupId,auraId)
        self.parent:BuildAura(groupId,auraId)
    else
        self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:MainGroup", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
        self:BuildMainGroupSettings(groupId)
        self.parent:BuildGroup(groupId)
    end
end

function Settings:OnChooseBarPreset(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local value = wndControl:GetText()
    local groupId, auraId = self:GetIdentifiers()

    if not self.presets.bars[value] then
        return
    end

    for k,v in pairs(self.presets.bars[value]) do
        self:SetVar(v,{{"bar",k},"nobuild"})
    end

    self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
    self.wndRight:Destroy()

    if auraId then
        self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Aura", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
        self:BuildAuraSettings(groupId,auraId)
        self.parent:BuildAura(groupId,auraId)
    else
        self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:MainGroup", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
        self:BuildMainGroupSettings(groupId)
        self.parent:BuildGroup(groupId)
    end
end

function Settings:OnChangeBarAnimation(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local setting = dropdown:GetData()
    local value = wndControl:GetName()
    local direction = self:GetVar("bar","direction")
    local new = nil

    self:SetVar(value,{{"bar","animation"},"build"})
    wndControl:GetParent():Close()
    dropdown:SetText(wndControl:GetText())

    self.wndRight:FindChild("EmptyTextureSetting"):SetData((value == "Radial") and "locked" or "")
    self.wndRight:FindChild("EmptyColorSetting"):SetData((value == "Radial") and "locked" or "")
    self.wndRight:FindChild("RadialMinBox"):SetData((value == "Linear") and "locked" or "")
    self.wndRight:FindChild("RadialMaxBox"):SetData((value == "Linear") and "locked" or "")

    self:ToggleSettings(self.wndRight:FindChild("EmptyTextureSetting"),(value == "Linear"))
    self:ToggleSettings(self.wndRight:FindChild("EmptyColorSetting"),(value == "Linear"))
    self:ToggleSettings(self.wndRight:FindChild("RadialMinBox"),(value == "Radial"))
    self:ToggleSettings(self.wndRight:FindChild("RadialMaxBox"),(value == "Radial"))

    if value == "Radial" then
        if direction ~= "Clockwise" and direction ~= "Invert" then
            self:SetVar("Invert",{{"bar","direction"},"build"})
            new = "Invert"
        end
    elseif value == "Linear" then
        if direction == "Clockwise" or direction == "Invert" then
            self:SetVar("Left",{{"bar","direction"},"build"})
            new = "Left"
        end
    end

    for _,button in pairs(self.wndRight:FindChild("DirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if value == "Radial" then
            if button:GetName() ~= "Clockwise" and button:GetName() ~= "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData("")
            end
        elseif value == "Linear" then
            if button:GetName() == "Clockwise" or button:GetName() == "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData("")
            end
        end

        if new ~= nil then
            if button:GetName() == new then
                button:SetCheck(true)
                self.wndRight:FindChild("DirectionDropdown"):SetText(button:GetText())
            else
                button:SetCheck(false)
            end
        end
    end
end

function Settings:OnChangeOverlayAnimation(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local setting = dropdown:GetData()
    local value = wndControl:GetName()
    local direction = self:GetVar("overlay","direction")
    local new = nil

    self:SetVar(value,{{"overlay","animation"},"build"})
    wndControl:GetParent():Close()
    dropdown:SetText(wndControl:GetText())

    if value == "Radial" then
        if direction ~= "Clockwise" and direction ~= "Invert" then
            self:SetVar("Invert",{{"overlay","direction"},"build"})
            new = "Invert"
        end
    elseif value == "Linear" then
        if direction == "Clockwise" or direction == "Invert" then
            self:SetVar("Left",{{"overlay","direction"},"build"})
            new = "Left"
        end
    end

    for _,button in pairs(self.wndRight:FindChild("OverlayDirectionDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        if value == "Radial" then
            if button:GetName() ~= "Clockwise" and button:GetName() ~= "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData("")
            end
        elseif value == "Linear" then
            if button:GetName() == "Clockwise" or button:GetName() == "Invert" then
                button:Enable(false)
                button:SetData("locked")
            else
                button:Enable(true)
                button:SetData("")
            end
        end

        if new ~= nil then
            if button:GetName() == new then
                button:SetCheck(true)
                self.wndRight:FindChild("OverlayDirectionDropdown"):SetText(button:GetText())
            else
                button:SetCheck(false)
            end
        end
    end
end

function Settings:OnOperatorChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local setting = dropdown:GetData()
    local value = wndControl:GetName()

    value = self.text.operator[value]

    self:SetVar(value,setting)
    dropdown:SetTextRaw(value)
    wndControl:GetParent():Close()
end

function Settings:OnAnimationChoose(wndHandler, wndControl)
    self.animationType = wndControl:GetName()
    wndControl:GetParent():Close()

    local groupId, auraId, triggerId, childId = self:GetIdentifiers()

    self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
    self.wndRight:Destroy()

    if auraId then
        self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Aura", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
        self:BuildAuraSettings(groupId,auraId)
    else
        self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:MainGroup", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
        self:BuildMainGroupSettings(groupId)
    end
end

function Settings:OnTextChoose(wndHandler, wndControl)
    local text = wndControl:GetName()
    wndControl:GetParent():Close()

    for _,group in pairs(self.wndRight:FindChild("TextTab"):GetChildren()) do
        if group:GetData() == text then
            for _,button in pairs(group:FindChild("TextChooseDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
                if button:GetName() == text then
                    button:SetCheck(true)
                else
                    button:SetCheck(false)
                end
            end

            group:Show(true,true)
            self.activeText = text
        else
            group:Show(false,true)
        end
    end
end

function Settings:OnDropdownChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local setting = dropdown:GetData()
    local value = wndControl:GetName()
    local arg = (type(setting) == "table") and setting[1] or setting

    self:SetVar(value,setting)
    dropdown:SetText(wndControl:GetText())
    wndControl:GetParent():Close()

    if self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
        if arg == "unit" or arg == "auraType" or arg == "valueType" then
            self:InsertTextSource()
        end
    end
end

function Settings:OnNameChange(wndHandler, wndControl)
    local value = wndHandler:GetText()

    if not value then
        return
    end

    if self:GetVar("icon","sprite") ~= self.parent.options.group.icon.sprite then
        return
    end

    for i = 1, 99999, 1 do
        tSpell = GameLib.GetSpell(i)
        tName = tSpell:GetName()

        if tName and (string.lower(value) == string.lower(tName)) then
            local tIcon = tSpell:GetIcon()

            if tIcon ~= nil and tIcon ~= "" then
                self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetSprite(tIcon)
                   self.wndRight:FindChild("IconSpriteText"):SetText(tIcon)
                   self:SetVar(tIcon,{{"icon","sprite"},"build"})
                   break
            end
        end
    end
end

function Settings:OnTextChange(wndHandler, wndControl)
    local setting = wndControl:GetData()
    local value = wndHandler:GetText()
    local allowEmpty = false
    local key = nil
    local child = nil
    local grandchild = nil

    if type(setting) == "table" then
        key = setting[1]

        if type(setting[1]) == "table" then
            key = setting[1][1] or nil
            child = setting[1][2] or nil
            grandchild = setting[1][3] or nil
        end
    else
        key = setting
    end

    if tonumber(value) ~= nil then
        value = tonumber(value)
    end

    -- Allow Empty Text
    if
        key == "spellName" or
        key == "unitName" or
        child == "input" or
        child == "sprite_fill" or
        child == "sprite_empty" or
        child == "sprite_bg" or
        child == "sprite_border"
    then
        allowEmpty = true
    end

    -- Integers only
    if
        key == "value" or
        child == "value" or
        key == "id" or
        child == "width" or
        child == "height" or
        child == "posX" or
        child == "posY" or
        grandchild == "value"
    then
        allowEmpty = true

        if tonumber(value) == nil and value ~= "" then
            self:Print("Please enter a number.")
            return
        end
    end

    if key == "radialmin" or key == "radialmax" then
        allowEmpty = false

        if tonumber(value) == nil and value ~= "" then
            self:Print("Please enter a number.")
            return
        end
    end

    -- Convert Spell IDs to strings
    if key == "id" or key == "spellName" then
        value = tostring(value)
    end

    if allowEmpty or (value ~= nil and value ~= "") then
        self:SetVar(value,setting)

        if key == "name" then
            if self.wndLastGroupSelected ~= nil then
                self.wndLastGroupSelected:FindChild("MainGroupBtn"):SetText(value)
            elseif self.wndLastAuraSelected ~= nil then
                self.wndLastAuraSelected:FindChild("TopGroupBtn"):SetText(value)
            elseif self.wndLastTriggerSelected ~= nil then
                self.wndLastTriggerSelected:FindChild("MiddleGroupBtn"):SetText(value)
            elseif self.wndLastChildSelected ~= nil then
                self.wndLastChildSelected:FindChild("BottomItemBtn"):SetText(value)
            end
        end

        if self.wndLastAuraSelected ~= nil or self.wndLastGroupSelected ~= nil then
            if key == "icon" and (child == "width" or child == "height") then
                self:RefreshIconPreview()
            end
        elseif self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
            if key == "spellName" or (key == "keybind" and child == "text") then
                self:InsertTextSource()
            end
        end
    end
end

function Settings:OnSoundSelect(wndControl, wndHandler, iRow, iCol)
    local soundFile = wndControl:GetCellLuaData(iRow, 1)

    self:SetVar(soundFile,{{"sound","file"}})
    self.parent:PlaySound(self:GetVar("sound"))
end

function Settings:OnSpriteChange(wndHandler, wndControl)
    local value = wndHandler:GetText()

    if self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
        self:SetVar(value,{{"icon","sprite"},"build"})
    else
        self:SetVar(value,{{"icon","sprite"},"build"})
        self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetSprite(value)
    end
end

function Settings:OnUnlock(wndHandler, wndControl)
    local groupId, auraId, triggerId, childId = self:GetIdentifiers()
    local value = true

    if wndHandler then
        value = wndHandler:IsChecked()
    end

    if self.wndLastAuraSelected ~= nil then
        self.parent.tWndAuras[groupId][auraId]:SetStyle("Moveable", not value)
        self.parent.tWndAuras[groupId][auraId]:FindChild("lock"):Show(not value)
    end

    if self.wndLastGroupSelected ~= nil then
        if self.parent.config.groups[groupId].dynamic.enable and self.parent.config.groups[groupId].dynamic.enable == true then
            for auraId,_ in pairs(self.parent.config.groups[groupId].auras) do
                if self.parent.config.groups[groupId].auras[auraId].enable == true then
                    self.parent.config.groups[groupId].auras[auraId].locked = value
                end
            end
        else
            for auraId,_ in pairs(self.parent.tWndAuras[groupId]) do
                if self.parent.config.groups[groupId].auras[auraId].enable == true then
                    self.parent.tWndAuras[groupId][auraId]:SetStyle("Moveable", not value)
                    self.parent.tWndAuras[groupId][auraId]:FindChild("lock"):Show(not value)
                end
            end

            for auraId,_ in pairs(self.parent.config.groups[groupId].auras) do
                if self.parent.config.groups[groupId].auras[auraId].enable == true then
                    self.parent.config.groups[groupId].auras[auraId].locked = value
                end
            end
        end
    end

    self:SetVar(value,"locked")
    self.parent:CheckCircumstances(true)
end

-- ########################################################################################################################################
-- # AURA SPECIFIC FORMS
-- ########################################################################################################################################

function Settings:OnSourceChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local source = wndControl:GetData()
    local name = wndControl:GetText()
    local setting = dropdown:GetData()

    if type(source) == "string" and source == "remove" then
        dropdown:SetText("Choose")
        self:SetVar("",{{setting,"source"},"build"})
    elseif type(source) == "string" and source == "none" then
        dropdown:SetText("None")
        self:SetVar("",{{setting,"source"},"build"})
    else
        dropdown:SetText(name)
        self:SetVar(source,{{setting,"source"},"build"})
    end

    if setting == "text" then
        if type(source) == "string" then
            self.wndRight:FindChild("TextInput"):Enable(true)
        else
            self.wndRight:FindChild("TextInput"):Enable(false)
        end
    end

    wndControl:GetParent():Close()
end

function Settings:RemoveTextSource()
    local groupId, auraId, triggerId, childId = self:GetIdentifiers()

    if not auraId or not triggerId then
        return
    end

    local aura = self.parent.config.groups[groupId].auras[auraId]
    local sourceId = ""

    if childId then
        sourceId = tostring(triggerId).."-"..tostring(childId)
    else
        sourceId = tostring(triggerId)
    end

    if aura.bar and aura.bar.source and aura.bar.source == sourceId then
        aura.bar.source = ""
    end

    if aura.overlay and aura.overlay.source and aura.overlay.source == sourceId then
        aura.overlay.source = ""
    end

    if aura.duration and aura.duration.source and aura.duration.source == sourceId then
        aura.duration.source = ""
    end

    if aura.stacks and aura.stacks.source and aura.stacks.source == sourceId then
        aura.stacks.source = ""
    end

    if aura.charges and aura.charges.source and aura.charges.source == sourceId then
        aura.charges.source = ""
    end

    if aura.text and aura.text.source and aura.text.source == sourceId then
        aura.text.source = ""
    end

    if aura.dynamic and aura.dynamic.source and aura.dynamic.source == sourceId then
        aura.dynamic.source = ""
    end

    if aura.icon and aura.icon.source and aura.icon.source == sourceId then
        aura.icon.source = ""
    end

    for triggerId = 1, #aura.triggers do
        local trigger = aura.triggers[triggerId]

        for _,tSource in pairs(trigger.sources) do
            if tSource.source == sourceId then
                tSource.source = ""
            end
        end

        if trigger.triggers ~= nil then
            for childId = 1, #trigger.triggers do
                local child = trigger.triggers[childId]

                for _,tSource in pairs(child.sources) do
                    if tSource.source == sourceId then
                        tSource.source = ""
                    end
                end

            end
        end
    end

    -- Rebuíld Aura
    self.parent:BuildAura(groupId,auraId)
end

function Settings:InsertTextSource()
    local groupId, auraId, triggerId, childId = self:GetIdentifiers()
    local aura = self.parent.config.groups[groupId].auras[auraId]

    local bar = false
    local overlay = false
    local duration = false
    local stacks = false
    local charges = false
    local text = false
    local icon = false

    local source = ""
    local trigger = {}

    if childId then
        trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId]
        source = tostring(triggerId).."-"..tostring(childId)
    else
        trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId]
        source = tostring(triggerId)
    end

    if trigger.triggerType == "Gadget" or trigger.triggerType == "Innate" then
        duration = true
        overlay = true
        bar = true
        icon = true
    elseif trigger.triggerType == "Threat" then
        bar = true
        text = true
    elseif trigger.triggerType == "Keybind" then
        if trigger.behavior == "Pass" and trigger.keybind.text and trigger.keybind.duration then
            duration = true
            overlay = true
            bar = true
        end
    elseif trigger.triggerType == "Cast" then
        if trigger.unit then
            duration = true
            overlay = true
            bar = true
            icon = true
            text = true
        end
    elseif trigger.triggerType == "Ability" or trigger.triggerType == "Cooldown" then
        if trigger.spellName then
            duration = true
            overlay = true
            bar = true
            charges = true
            icon = true
            text = true
        end
    elseif trigger.triggerType == "Buff" or trigger.triggerType == "Debuff" then
        if trigger.spellName and trigger.unit then
            duration = true
            overlay = true
            bar = true
            stacks = true
            icon = true
        end
    elseif trigger.triggerType == "AMP Cooldown" then
        if trigger.spellName and trigger.unit and trigger.auraType and trigger.time ~= nil then
            duration = true
            overlay = true
            bar = true
        end
    end

    if bar == true and (aura.bar == nil or aura.bar.source == nil or aura.bar.source == "") then
        if aura.bar == nil then
            aura.bar = {}
        end

        aura.bar.source = source
    end

    if overlay == true and (aura.overlay == nil or aura.overlay.source == nil or aura.overlay.source == "") then
        if aura.overlay == nil then
            aura.overlay = {}
        end

        aura.overlay.source = source
    end

    if duration == true and (aura.duration == nil or aura.duration.source == nil or aura.duration.source == "") then
        if aura.duration == nil then
            aura.duration = {}
        end

        aura.duration.source = source
    end

    if duration == true and (aura.dynamic == nil or aura.dynamic.source == nil or aura.dynamic.source == "") then
        if aura.dynamic == nil then
            aura.dynamic = {}
        end

        aura.dynamic.source = source
    end

    if stacks == true and (aura.stacks == nil or aura.stacks.source == nil or aura.stacks.source == "") then
        if aura.stacks == nil then
            aura.stacks = {}
        end

        aura.stacks.source = source
    end

    if charges == true and (aura.charges == nil or aura.charges.source == nil or aura.charges.source == "") then
        if aura.charges == nil then
            aura.charges = {}
        end

        aura.charges.source = source
    end

    if icon == true and (aura.icon == nil or aura.icon.source == nil or aura.icon.source == "") then
        if aura.icon == nil then
            aura.icon = {}
        end

        aura.icon.source = source
    end

    if text == true and (aura.text == nil or aura.text.source == nil or aura.text.source == "") then
        if aura.text == nil then
            aura.text = {}
        end

        aura.text.source = source
    end

    -- Rebuíld Aura
    self.parent:BuildAura(groupId,auraId)
end

-- ########################################################################################################################################
-- # TRIGGER SPECIFIC FORMS
-- ########################################################################################################################################

function Settings:OnChooseTrigger(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local value = wndHandler:GetData()

    if self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
        dropdown:SetText(value)
        wndControl:GetParent():Close()

        -- Backup existing trigger settings
        local backup = self.parent:Copy(self:GetVar())

        -- Reset trigger settings
        self:SetVar(self.parent:Copy(self.parent.options.trigger))

        -- Restrore trigger settings
        self:SetVar(backup.enable,"enable")
        self:SetVar(backup.name,"name")
        self:SetVar(backup.behavior,"behavior")
        self:SetVar(backup.color,"color")
        self:SetVar(backup.border,"border")
        self:SetVar(backup.sound,"sound")

        -- Set New Trigger Type
        self:SetVar(value,"triggerType")

        -- Change Trigger Name
        if backup.name == "NewTrigger" or backup.name == backup.triggerType then
            self:SetVar(value,"name")
            self.wndRight:FindChild("NameText"):SetText(value)

            if self.wndLastTriggerSelected ~= nil then
                self.wndLastTriggerSelected:FindChild("MiddleGroupBtn"):SetText(value)
            elseif self.wndLastChildSelected ~= nil then
                self.wndLastChildSelected:FindChild("BottomItemBtn"):SetText(value)
            end
        end

        -- Update Text Source
        self:RemoveTextSource()

        -- Insert Text Source
        self:InsertTextSource()

        -- Load Trigger Settings
        self:BuildTriggerSettings(self:GetIdentifiers())

        -- Rebuíld Aura
        self.parent:BuildAura(self:GetIdentifiers())
    end
end

function Settings:OnThreatTriggerChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local setting = dropdown:GetData()
    local value = wndControl:GetData()

    self:SetVar(tonumber(value),setting)
    dropdown:SetText(self.text.threat[tostring(value)])
    wndControl:GetParent():Close()
end

function Settings:OnKeybindSelect(wndHandler, wndControl, eMouseButton)
    if wndHandler ~= wndControl then
        return false
    end

    wndControl:SetCheck(true)
    wndControl:SetFocus()
end

function Settings:OnKeybindSetWheel(wndHandler, wndControl, nX, nY, nDelta, eModifier)
    if not wndControl:FindChild("KeyButton") or not wndControl:FindChild("KeyButton"):IsChecked() then
        return false
    end

    local nCode = GameLib.CodeEnumInputMouse.WheelUp

    if nDelta < 0 then
        nCode = GameLib.CodeEnumInputMouse.WheelDown
    end

    local input = {
        eDevice = GameLib.CodeEnumInputDevice.Mouse,
        nCode = nCode,
        eModifier = eModifier,
    }

    input.strName = GameLib.GetInputKeyNameText(input)
    self:OnKeybindSave(wndControl:FindChild("KeyButton"),input)
end

function Settings:OnKeybindSetMouse(wndHandler, wndControl, eMouseButton)
    if eMouseButton == GameLib.CodeEnumInputMouse.Left or eMouseButton == GameLib.CodeEnumInputMouse.Right then
         return false
    end

    if not wndControl:FindChild("KeyButton") or not wndControl:FindChild("KeyButton"):IsChecked() then
        return false
    end

    local eModifier = Apollo.GetMetaKeysDown()

    local input = {
        eDevice = GameLib.CodeEnumInputDevice.Mouse,
        nCode = eMouseButton,
        eModifier = eModifier,
    }

    input.strName = GameLib.GetInputKeyNameText(input)

    self:OnKeybindSave(wndControl:FindChild("KeyButton"),input)
end

function Settings:OnKeybindSet(wndHandler, wndControl, strKeyName, nCode, eModifier)
    if wndHandler ~= wndControl then
        return false
    end

    if not wndControl:IsChecked() then
        return
    end

    if strKeyName == "ESC" then
        wndControl:SetCheck(false)
        return
    end

    if not GameLib.IsKeyBindable(nCode, eModifier) then
        return false
    end

    local input = {
        eDevice = GameLib.CodeEnumInputDevice.Keyboard,
        nCode = nCode,
        eModifier = eModifier,
    }

    input.strName = GameLib.GetInputKeyNameText(input)
    self:OnKeybindSave(wndControl,input)
end

function Settings:OnKeybindSave(wndControl, input)
    if self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
        self:SetVar(input.strName,{{"keybind","text"}})
        self:SetVar(input.nCode,{{"keybind","key"}})
        self:SetVar(input.eModifier,{{"keybind","modifier"}})

        wndControl:SetText(input.strName)
        wndControl:SetCheck(false)
        self:InsertTextSource()
        self.parent:BuildAura(self:GetIdentifiers())
    end
end

function Settings:OnSaveScript(wndHandler, wndControl)
    local value = wndControl:GetParent():FindChild("ScriptText"):GetText()

    if value ~= nil and value ~= "" then
        if self.wndLastTriggerSelected ~= nil or self.wndLastChildSelected ~= nil then
            self:SetVar(value,"script")
            self:Print("Script saved.")
        end
    end
end

function Settings:OnZoneChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local parent = wndControl:GetData()
    local name = wndControl:GetText()

    for _,child in pairs(self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
        child:Destroy()
    end

    if parent.subzones ~= nil then
        local currentZone = 0
        local countZones = 0

        for k,v in pairs(parent.subzones) do
            countZones = countZones + 1
        end

        for zoneName,id in self.parent:Sort(parent.subzones) do
            currentZone = currentZone + 1
            local dropdownItem = nil
            local item = "Items:Dropdown:MidItem"
            local offset = 30 * (currentZone -1)

            if countZones > 1 then
                if currentZone == 1 then
                    item = "Items:Dropdown:TopItem"
                elseif currentZone == countZones then
                    item = "Items:Dropdown:BottomItem"
                end
            else
                item = "Items:Dropdown:SingleItem"
            end

            dropdownItem = Apollo.LoadForm(self.parent.xmlDoc, item, self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"), self)
            dropdownItem:SetText(zoneName)
            dropdownItem:SetCheck(false)
            dropdownItem:SetAnchorOffsets(42,49 + offset,-44,81 + offset)
            dropdownItem:SetData(id)
            dropdownItem:AddEventHandler("ButtonCheck", "OnSubzoneChoose", self)
        end

        self.wndRight:FindChild("SubzoneDropdown"):AttachWindow(self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"))
        self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"):Show(false)
        self.wndRight:FindChild("SubzoneDropdown"):SetText("Subzones")
        self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"):SetAnchorPoints(0,1,1,1)
        self.wndRight:FindChild("SubzoneDropdown"):FindChild("ChoiceContainer"):SetAnchorOffsets(-25,-35,25,67 + (countZones * 30))
        self.wndRight:FindChild("SubzoneDropdown"):Enable(true)
    end

    dropdown:SetText(name)
    wndControl:GetParent():Close()
end

function Settings:OnSubzoneChoose(wndHandler, wndControl)
    local dropdown = wndControl:GetParent():GetParent()
    local name = wndControl:GetText()
    dropdown:SetText(name)
    wndControl:GetParent():Close()
end

function Settings:OnAddZone(wndHandler, wndControl)
    local grid = wndControl:GetParent():GetParent():FindChild("ZonesGrid")
    local aura = self:GetVar()

    local parentName = self.wndRight:FindChild("ZoneDropdown"):GetText()
    local zoneName = self.wndRight:FindChild("SubzoneDropdown"):GetText()
    local fullName = parentName .. ": " .. zoneName

    if parentName == "Zones" or zoneName == "Subzones" then
        self:Print("Please choose a zone first.")
        return
    end

    local alreadyExists = false

    for _,zone in pairs(aura.zones) do
        if fullName == zone.strName then
            alreadyExists = true
        end
    end

    if not alreadyExists then
        local continentId = 0
        local parentZoneId = 0
        local id = 0

        if type(self.parent.zones[parentName].subzones[zoneName]) ~= "table" then
            continentId = self.parent.zones[parentName].continentId or 0
            parentZoneId = self.parent.zones[parentName].parentZoneId or 0
            id = self.parent.zones[parentName].subzones[zoneName]
        else
            continentId = self.parent.zones[parentName].subzones[zoneName].continentId or 0
            parentZoneId = self.parent.zones[parentName].subzones[zoneName].parentZoneId or 0
            id = self.parent.zones[parentName].subzones[zoneName].id or 0
        end

        grid:AddRow(fullName)

        table.insert(aura.zones, {
            strName = fullName,
            continentId = continentId,
            parentZoneId = parentZoneId,
            id = id,
        })

        self:SetVar(aura.zones,{"zones"})

        self.wndRight:FindChild("ZoneDropdown"):SetText("Zones")
        self.wndRight:FindChild("SubzoneDropdown"):SetText("Subzones")
        self.wndRight:FindChild("SubzoneDropdown"):Enable(false)

        for _,child in pairs(self.wndRight:FindChild("ZoneDropdown"):FindChild("ChoiceContainer"):GetChildren()) do
            child:SetCheck(false)
        end

        self.parent:CheckCircumstances()
    end
end

function Settings:OnDeleteZone(wndHandler, wndControl)
    local grid = wndControl:GetParent():GetParent():FindChild("ZonesGrid")
    local row = grid:GetCurrentRow()

    if row then
        local text = grid:GetCellText(row, 1)
        local aura = self:GetVar()

        grid:DeleteRow(row)

        for k,v in pairs(aura.zones) do
            if v.strName == text then
                table.remove(aura.zones,k)
            end
        end

        self:SetVar(aura.zones,{"zones"})
    else
        self:Print("Please choose a zone first.")
        return
    end

    self.parent:CheckCircumstances()
end

-- ########################################################################################################################################
-- # MISC
-- ########################################################################################################################################

function Settings:OnResetSettings(wndHandler, wndControl)
    local groupId, auraId, triggerId, childId = self:GetIdentifiers()
    local setting = wndControl:GetData()
    local pos = self.wndSettings:FindChild("Aura"):FindChild(setting[2]):GetVScrollPos()

    if type(setting[1]) == "string" and setting[1] == "visibility" then
        self:SetVar(nil,{{"actionsets"},"nobuild"})
        self:SetVar(nil,{{"stances"},"nobuild"})
        self:SetVar(nil,{{"visibility"},"nobuild"})
    else
        self:SetVar(nil,{setting[1],"nobuild"})
    end

    self.wndSettings:FindChild("Auras"):FindChild("RightScroll"):DestroyChildren()
    self.wndRight:Destroy()

    self.wndRight = Apollo.LoadForm(self.parent.xmlDoc, "Settings:Aura", self.wndSettings:FindChild("Auras"):FindChild("RightScroll"), self)
    self.wndSettings:FindChild("Aura"):FindChild(setting[2]):SetVScrollPos(pos)

    local groupId, auraId, triggerId, childId = self:GetIdentifiers()
    self.parent:BuildAura(groupId,auraId)

    self:BuildAuraSettings(groupId,auraId)

    if type(setting[1]) == "string" and setting[1] == "visibility" then
        self.parent:CheckCircumstances()
    end
end

function Settings:OnBtnChooseColor(wndHandler, wndControl)
    local setting = wndControl:GetParent():GetData()
    local tColor = wndControl:GetData() or self:GetVar(unpack(setting))

    if tColor ~= nil then
        local sColor = GeminiColor:RGBAPercToHex(
            tColor.r / 255,
            tColor.g / 255,
            tColor.b / 255,
            tColor.a / 255
        )

        GeminiColor:ShowColorPicker(self, {
            callback = "OnColorPicker",
            strInitialColor = sColor,
            bCustomColor = true,
            bAlpha = true
        }, wndControl)
    end
end

function Settings:OnColorPicker(wndHandler, wndControl)
    local setting = wndControl:GetParent():GetData()

    if type(wndHandler) ~= "string" then
        sColor = wndHandler:GetText()
    else
        sColor = wndHandler
    end

    if sColor == nil or string.len(sColor) ~= 8 then
        return
    end

    local nR, nG, nB, nA = GeminiColor:HexToRGBAPerc(sColor)
    local newColor = {
        r = nR * 255,
        g = nG * 255,
        b = nB * 255,
        a = nA * 255
    }

    for _,button in pairs(wndControl:GetParent():GetChildren()) do
        if string.find(button:GetName(),"Btn") then
            button:SetData(newColor)
        end
    end

    wndControl:GetParent():FindChild("ColorBackground"):SetBGColor(ApolloColor.new(nR, nG, nB, nA))
    wndControl:GetParent():FindChild("ColorText"):SetText(sColor)

    self:SetVar(newColor,{setting,"build"})

    if self.wndLastGroupSelected ~= nil or self.wndLastAuraSelected ~= nil then
        if self.wndRight:FindChild("IconPreview") then
            if setting[1] == "icon" and setting[2] and setting[2] == "color" then
                self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetBGColor(ApolloColor.new(nR,nG,nB,nA))
            elseif setting[1] == "border" and setting[2] and setting[2] == "color" then
                self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetBGColor(ApolloColor.new(nR,nG,nB,nA))
            end
        end
    end
end

function Settings:OnNewItem(wndHandler, wndControl)
    if not wndHandler:IsEnabled() then
        return
    end

    local groupId, auraId, triggerId, childId = self:GetIdentifiers()
    local setting = wndControl:GetName()

    if setting == "NewMainGroupButton" then
        -- New Aura Group
        table.insert(self.parent.config.groups, self.parent:Copy(self.parent.options.group))

        self:ResetAuras(true)
        self.parent:BuildAuras()
        self:BuildTree(table.maxn(self.parent.config.groups))
        self:CheckButtons()
    elseif setting == "NewAuraButton" and self.wndLastGroupSelected ~= nil then
        -- New Aura
        table.insert(self.parent.config.groups[groupId].auras, self.parent:Copy(self.parent.options.aura))

        self.parent:BuildAuras()
        self:BuildTree(groupId,table.maxn(self.parent.config.groups[groupId].auras))
        self:CheckButtons()
    elseif setting == "NewTriggerButton" and self.wndLastAuraSelected ~= nil then
        -- New Trigger
        table.insert(self.parent.config.groups[groupId].auras[auraId].triggers, self.parent:Copy(self.parent.options.trigger))

        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId,table.maxn(self.parent.config.groups[groupId].auras[auraId].triggers))
        self:CheckButtons()
    elseif setting == "NewTriggerButton" and self.wndLastTriggerSelected ~= nil then
        -- New Trigger Child
        table.insert(self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers, self.parent:Copy(self.parent.options.trigger))

        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId,triggerId,table.maxn(self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers))
        self:CheckButtons()
    elseif setting == "NewGroupButton" and self.wndLastAuraSelected ~= nil then
        local group = self.parent:Copy(self.parent.options.trigger)

        -- Extend trigger with group settings
        group.triggerType = "Group"
        group.name = "NewGroup"
        group.behavior = "Any"
        group.triggers = {}

        -- Insert Dummy Trigger Child
        table.insert(group.triggers, self.parent:Copy(self.parent.options.trigger))

        -- Insert Trigger Group
        table.insert(self.parent.config.groups[groupId].auras[auraId].triggers, group)

        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId,table.maxn(self.parent.config.groups[groupId].auras[auraId].triggers))
        self:CheckButtons()
    end
end

function Settings:OnDelete(wndHandler, wndControl)
    local groupId, auraId, triggerId, childId = self:GetIdentifiers()

    if self.wndLastGroupSelected ~= nil then
        -- Remove Group
        table.remove(self.parent.config.groups,groupId)

        self:ResetAuras(true)
        self.parent:BuildAuras()
        self:CheckButtons()
    elseif self.wndLastAuraSelected ~= nil then
        -- Remove Aura
        table.remove(self.parent.config.groups[groupId].auras,auraId)

        self.parent:BuildAuras()
        self:BuildTree(groupId)
        self:CheckButtons()
    elseif self.wndLastTriggerSelected ~= nil then
        -- Remove Text Sources
        self:RemoveTextSource()

        -- Remove Trigger
        table.remove(self.parent.config.groups[groupId].auras[auraId].triggers,triggerId)

        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId)
        self:CheckButtons()
    elseif self.wndLastChildSelected ~= nil then
        -- Remove Text Sources
        self:RemoveTextSource()

        -- Remove Trigger
        table.remove(self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers,childId)

        self.parent:BuildAuras()
        self:BuildTree(groupId,auraId,triggerId)
        self:CheckButtons()
    end
end

function Settings:OnFontChange(wndControl, wndHandler, iRow, iCol)
    local setting = wndControl:GetData()
    local font = wndControl:GetCellText(iRow, 1)

    self:SetVar(font,{{setting,"font"},"build"})
end

function Settings:OnMoveBtn(wndHandler, wndControl)
    local button = wndControl:GetName()
    local setting = wndControl:GetData()

    if not setting then
        return
    end

    local text = nil
    local pos = nil
    local value = nil

    if button == "UpButton" then
        text = wndControl:GetParent():FindChild("YPosText")
        pos = "posY"
        value = 1
    elseif button == "LeftButton" then
        text = wndControl:GetParent():FindChild("XPosText")
        pos = "posX"
        value = 1
    elseif button == "DownButton" then
        text = wndControl:GetParent():FindChild("YPosText")
        pos = "posY"
        value = -1
    elseif button == "RightButton" then
        text = wndControl:GetParent():FindChild("XPosText")
        pos = "posX"
        value = -1
    else
        return
    end

    value = self:GetVar(setting,pos) - value
    self:SetVar(value,{{setting,pos},"build"})

    text:SetText(value)
end

function Settings:LoadExport()
    local profile = {}

    if self.wndLastGroupSelected ~= nil then
        profile.export = "group"
        profile.setting = self.parent:Copy(self:GetVar())
    elseif self.wndLastAuraSelected ~= nil then
        local groupId = self.wndLastAuraSelected:GetData()[1]:GetData()
        local auraId = self.wndLastAuraSelected:GetData()[2]:GetData()

        if groupId and auraId then
            profile.export = "aura"
            profile.setting = self.parent:Copy(self.parent.config.groups[groupId].runtime.auras[auraId])
            profile.setting.dynamic.enable = false
        end
    elseif self.wndLastTriggerSelected ~= nil then
        profile.export = "trigger"
        profile.setting = self.parent:Copy(self:GetVar())
    elseif self.wndLastChildSelected ~= nil then
        profile.export = "trigger"
        profile.setting = self.parent:Copy(self:GetVar())
    end

    if profile.setting then
        profile.setting = self.parent:StripTable(self:Strip(profile.setting,profile.export))
    end

    local JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
    local strProfile = JSON.encode(profile)

    if string.len(strProfile) >= 31700 then
        self.wndSettings:FindChild("ExportButton"):SetData(false)
        strProfile = "Profile too large to export"
    else
        self.wndSettings:FindChild("ExportButton"):SetData(true)
    end

    self.wndSettings:FindChild("ExportButton"):SetActionData(GameLib.CodeEnumConfirmButtonType.CopyToClipboard, strProfile)
end

function Settings:OnExport(wndHandler, wndControl)
    if wndControl:GetData() == false then
        self:Print("Profile too large to export")
    else
        local profile = self:GetVar()

        if profile.name ~= nil then
            self:Print("Copied " .. profile.name .. " to your clipboard.")
        else
            self:Print("Please choose something to export.")
        end
    end
end

function Settings:ImportSettings()
    self.wndSettings:FindChild("Clipboard"):SetText("")
    self.wndSettings:FindChild("Clipboard"):PasteTextFromClipboard()

    local clipboard = self.wndSettings:FindChild("Clipboard"):GetText()

    if not clipboard then
        self:Print("Nothing to import")
        return
    end

    local JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
    local profile, pos, err = JSON.decode(clipboard)

    if not profile or not profile.export then
        self:Print("Nothing to Import.")
        return
    end

    local groupId = nil
    local auraId = nil
    local triggerId = nil

    if profile.export == "group" then

        for auraId, aura in ipairs(profile.setting.auras) do
            aura = self.parent:InsertDefaults(self.parent:CheckCompatibility(aura,"aura"), self.parent:Copy(self.parent.options.aura))

            for triggerId, trigger in ipairs(aura.triggers) do
                trigger = self.parent:InsertDefaults(self.parent:CheckCompatibility(trigger,"trigger"), self.parent:Copy(self.parent.options.trigger))

                if trigger.triggers ~= nil then
                    for childTriggerId, childTrigger in ipairs(trigger.triggers) do
                        childTrigger = self.parent:InsertDefaults(self.parent:CheckCompatibility(childTrigger,"trigger"), self.parent:Copy(self.parent.options.trigger))
                    end
                end
            end
        end

        table.insert(self.parent.config.groups, self.parent:InsertDefaults(self.parent:CheckCompatibility(profile.setting,"group"), self.parent:Copy(self.parent.options.group)))

        self:ResetAuras(true)
        self.parent:BuildAuras()

        self:Print("Imported " .. profile.setting.name .. " successful.")

    elseif profile.export == "aura" then

        if self.wndLastGroupSelected ~= nil then
            groupId = self.wndLastGroupSelected:GetData()[1]:GetData()

            for triggerId, trigger in ipairs(profile.setting.triggers) do
                trigger = self.parent:InsertDefaults(self.parent:CheckCompatibility(trigger,"trigger"), self.parent:Copy(self.parent.options.trigger))

                if trigger.triggers ~= nil then
                    for childTriggerId, childTrigger in ipairs(trigger.triggers) do
                        childTrigger = self.parent:InsertDefaults(self.parent:CheckCompatibility(childTrigger,"trigger"), self.parent:Copy(self.parent.options.trigger))
                    end
                end
            end

            table.insert(self.parent.config.groups[groupId].auras, self.parent:InsertDefaults(self.parent:CheckCompatibility(profile.setting,"aura"), self.parent:Copy(self.parent.options.aura)))

            self:BuildTree(groupId)
            self:CheckButtons()
            self.parent:BuildAuras()

            self:Print("Imported " .. profile.setting.name .. " successful.")
        else
            self:Print("Please select a group to import aura.")
            return
        end

    elseif profile.export == "trigger" then

        if self.wndLastAuraSelected ~= nil then

            groupId = self.wndLastAuraSelected:GetData()[1]:GetData()
            auraId = self.wndLastAuraSelected:GetData()[2]:GetData()

            if profile.setting.triggers ~= nil then
                for childTriggerId, childTrigger in ipairs(profile.setting.triggers) do
                    childTrigger = self.parent:InsertDefaults(self.parent:CheckCompatibility(childTrigger,"trigger"), self.parent:Copy(self.parent.options.trigger))
                end
            end

            table.insert(self.parent.config.groups[groupId].auras[auraId].triggers, self.parent:InsertDefaults(self.parent:CheckCompatibility(profile.setting,"trigger"), self.parent:Copy(self.parent.options.trigger)))

            self:BuildTree(groupId,auraId)
            self:CheckButtons()
            self.parent:BuildAuras()

            self:Print("Imported " .. profile.setting.name .. " successful.")

         elseif self.wndLastTriggerSelected ~= nil then

            groupId = self.wndLastTriggerSelected:GetData()[1]:GetData()
            auraId = self.wndLastTriggerSelected:GetData()[2]:GetData()
            triggerId = self.wndLastTriggerSelected:GetData()[3]:GetData()
            local trigger = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId]

            if trigger.triggerType == "Group" then
                if profile.setting.triggerType ~= "Group" then
                    table.insert(trigger.triggers, self.parent:InsertDefaults(self.parent:CheckCompatibility(profile.setting,"trigger"), self.parent:Copy(self.parent.options.trigger)))

                    self:BuildTree(groupId,auraId,triggerId)
                    self:CheckButtons()
                    self.parent:BuildAuras()

                    self:Print("Imported " .. profile.setting.name .. " successful.")
                else
                    self:Print("Please select an aura to import trigger group.")
                    return
                end
            else
                self:Print("Please select an aura or trigger group to import trigger.")
                return
            end

        else
            self:Print("Please select an aura or trigger group to import trigger.")
            return
        end
    else
        self:Print("Nothing to Import.")
        return
    end
end

function Settings:OnSpellSearchBtn()
    local show = false

    if self.wndSpells then
        if self.wndSpells:IsShown() then
            self.wndSpells:Close()
        else
            self.wndSpells:Invoke()
            show = true
        end
    else
        self.wndSpells = Apollo.LoadForm(self.parent.xmlDoc, "SpellsForm", nil, self)
        show = true
    end

    if show == true then
        Apollo.RegisterEventHandler("BuffAdded", "OnSpellAdded", self)

        for _,button in pairs(self.wndSpells:FindChild("Tabs"):GetChildren()) do
            button:SetCheck(button:GetName() == "Player")
        end

        for _,list in pairs(self.wndSpells:FindChild("List"):GetChildren()) do
            list:Show(list:GetName() == "Player", true)
        end

        self:OnSpellResetBtn()
        self:UpdateSpells("Player")
    else
        Apollo.RemoveEventHandler("BuffAdded", self)
    end
end

function Settings:OnSpellSearch(wndHandler,wndControl)
    local text = wndControl:GetText():gsub("^%s*(.-)%s*$", "%1")

    if not text or text == "" then
        return
    end

    self.wndSpells:FindChild("List"):FindChild("Search"):FindChild("Result"):DestroyChildren()

    for i = 1, 99999, 1 do
        local spell = GameLib.GetSpell(i)
        local spellName = spell:GetName()

        if spellName and string.match(spellName,text) then
            self:AddSpell("Result",spell)
        end
    end
end

function Settings:OnSpellResetBtn(wndHandler,wndControl)
    for _,list in pairs(self.wndSpells:FindChild("List"):GetChildren()) do
        if list:GetName() == "Search" then
            list:FindChild("Filter"):FindChild("SpellName"):SetText("")
            list:FindChild("Result"):DestroyChildren()
        else
            list:DestroyChildren()
        end
    end

    local activeTab = nil

    for _,button in pairs(self.wndSpells:FindChild("Tabs"):GetChildren()) do
        if button:IsChecked() then
            activeTab = button:GetName()
        end
    end

    if activeTab and activeTab ~= "Search" then
        self:UpdateSpells(activeTab)
    end
end

function Settings:UpdateSpells(target)
    if not target then
        return
    end

    local unit = nil

    if target == "Player" then
        unit = self.parent.unitPlayer or nil
    elseif target == "Target" then
        unit = self.parent.unitTarget or nil
    elseif target == "Focus" then
        unit = self.parent.unitFocus or nil
    elseif target == "ToT" then
        unit = self.parent.unitToT or nil
    end

    if not unit then
        return
    end

    local spells = unit:GetBuffs()

    for spellId=1, #spells.arBeneficial do
        local spell = spells.arBeneficial[spellId]
        self:AddSpell(target,spell)
    end

    for spellId=1, #spells.arHarmful do
        local spell = spells.arHarmful[spellId]
        self:AddSpell(target,spell)
    end
end

function Settings:OnSpellTabBtn(wndHandler, wndControl)
    for _,list in pairs(self.wndSpells:FindChild("List"):GetChildren()) do
        if list:GetName() == wndControl:GetName() then
            list:Show(true, true)
            self:UpdateSpells(list:GetName())
        else
            list:Show(false,true)
        end
    end
end

function Settings:OnSpellAdded(unit,spell)
    if not unit or not spell then return end

    local unitName = unit:GetName()
    local target = nil

    if self.parent.unitPlayer and unitName == self.parent.unitPlayer:GetName() then
        self:AddSpell("Player",spell)
    end

    if self.parent.unitTarget and unitName == self.parent.unitTarget:GetName() then
        self:AddSpell("Target",spell)
    end

    if self.parent.unitFocus and unitName == self.parent.unitFocus:GetName() then
        self:AddSpell("Focus",spell)
    end

    if self.parent.unitToT and unitName == self.parent.unitToT:GetName() then
        self:AddSpell("ToT",spell)
    end
end

function Settings:AddSpell(unit,spell)
    if not unit or not spell then
        return
    end

    local parent = nil

    if spell.splEffect then
        parent = spell
        spell = spell.splEffect
    end

    for _,buff in pairs(self.wndSpells:FindChild("List"):FindChild(unit):GetChildren()) do
        if buff:FindChild("SpellId"):GetText() == tostring(spell:GetId()) then
            return
        end
    end

    if not spell:GetName() then
        return
    end

    local wndSpellItem = Apollo.LoadForm(self.parent.xmlDoc, "Items:Spell", self.wndSpells:FindChild("List"):FindChild(unit), self)
    wndSpellItem:SetData(spell)
    wndSpellItem:FindChild("SpellName"):SetText(spell:GetName())
    wndSpellItem:FindChild("SpellId"):SetText(tostring(spell:GetId()))

    if spell:GetIcon() then
        wndSpellItem:FindChild("SpellIcon"):SetSprite(spell:GetIcon())
    end

    if Tooltip then
        Tooltip.GetSpellTooltipForm(self, wndSpellItem, spell, {bFutureSpell = false})
    end

    if spell:IsBeneficial() then
        wndSpellItem:FindChild("SpellName"):SetTextColor("ff15f721")
    else
        wndSpellItem:FindChild("SpellName"):SetTextColor("fffa0a0a")
    end

    self.wndSpells:FindChild("List"):FindChild(unit):ArrangeChildrenTiles(0)
end

function Settings:BrowseIcons(wndHandler, wndControl)
    if self.wndBrowse == nil then
        self.wndBrowse = Apollo.LoadForm(self.parent.xmlDoc, "BrowseForm", nil, self)
        self.wndBrowse:FindChild("SearchEditBox"):SetText("")
        self.wndBrowse:FindChild("ChooseBtn"):SetData(wndControl:GetData())
        self.loadIcons = true

        Apollo.CreateTimer("LUI_IconTimer", 0.1, false)
        Apollo.StartTimer("LUI_IconTimer")
    else
        self.wndBrowse:FindChild("SearchEditBox"):SetText("")
        self.wndBrowse:FindChild("ChooseBtn"):SetData(wndControl:GetData())
        self:OnLoadIcons()
        self.wndBrowse:Invoke()
    end
end

function Settings:OnLoadIcons(search)
    if not search then
        local activeTab = "Icons"

        if self.wndBrowse:FindChild("ChooseBtn"):GetData()[1][1] then
            if self.wndBrowse:FindChild("ChooseBtn"):GetData()[1][1] == "bar" then
                activeTab = "Bars"
            elseif self.wndBrowse:FindChild("ChooseBtn"):GetData()[1][1] == "border" then
                activeTab = "Borders"
            end
        end

        if self.wndBrowse:FindChild("ChooseBtn"):GetData()[1][2] and self.wndBrowse:FindChild("ChooseBtn"):GetData()[1][2] == "sprite_border" then
            activeTab = "Borders"
        end

        for _,child in pairs(self.wndBrowse:FindChild("IconTabContainer"):GetChildren()) do
            child:SetCheck(child:GetName() == activeTab)
        end

        for _,child in pairs(self.wndBrowse:FindChild("IconContainer"):GetChildren()) do
            child:Show(child:GetName() == activeTab)
        end
    end

    -- Get current Icon
    local strSelectedIconSprite = self.wndSettings:FindChild(self.wndBrowse:FindChild("ChooseBtn"):GetData()[2]):GetText()

    -- Load Icons
    local wndIconList = self.wndBrowse:FindChild("IconContainer"):FindChild("Icons")
    local wndSpellList = self.wndBrowse:FindChild("IconContainer"):FindChild("Spells")
    local wndFormList = self.wndBrowse:FindChild("IconContainer"):FindChild("Forms")
    local wndTextList = self.wndBrowse:FindChild("IconContainer"):FindChild("Text")
    local wndBarList = self.wndBrowse:FindChild("IconContainer"):FindChild("Bars")
    local wndBorderList = self.wndBrowse:FindChild("IconContainer"):FindChild("Borders")
    local wndAnimationList = self.wndBrowse:FindChild("IconContainer"):FindChild("Animations")

    if self.loadIcons == true then
        -- Load Icons
        for idx = 1, #self.sprites["icons"] do
            local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndIconList, self)
            wndIcon:FindChild("Sprite"):SetSprite(self.sprites["icons"][idx])

            if strSelectedIconSprite == self.sprites["icons"][idx] then
               self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            end
        end

        -- Load Spells
        local spellIcons = MacrosLib.GetMacroIconList()

        for idx = 1, #spellIcons do
             local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndSpellList, self)
             wndIcon:FindChild("Sprite"):SetSprite(spellIcons[idx])

             if strSelectedIconSprite == spellIcons[idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
             end
        end

        -- Load Custom Spells
        for idx = 1, #self.sprites["spells"] do
             local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndSpellList, self)
             wndIcon:FindChild("Sprite"):SetSprite(self.sprites["spells"][idx])

             if strSelectedIconSprite == self.sprites["spells"][idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
             end
        end

        -- Load Animations
        for idx = 1, #self.sprites["animations"] do
            local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Animation", wndAnimationList, self)
            wndIcon:FindChild("Sprite"):SetSprite(self.sprites["animations"][idx])

            if strSelectedIconSprite == self.sprites["animations"][idx] then
               self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            end
        end

        -- Load Forms
        for idx = 1, #self.sprites["forms"] do
             local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndFormList, self)
             wndIcon:FindChild("Sprite"):SetSprite(self.sprites["forms"][idx])

             if strSelectedIconSprite == self.sprites["forms"][idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
             end
        end

        -- Load Text
        for idx = 1, #self.sprites["text"] do
             local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndTextList, self)
             wndIcon:FindChild("Sprite"):SetSprite(self.sprites["text"][idx])

             if strSelectedIconSprite == self.sprites["text"][idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
             end
        end

        -- Load Bars (linear)
        for idx = 1, #self.sprites["bars"]["linear"] do
             local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Bar", wndBarList, self)
             wndIcon:FindChild("Sprite"):SetSprite(self.sprites["bars"]["linear"][idx])

             if strSelectedIconSprite == self.sprites["bars"]["linear"][idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
             end
        end

        -- Load Bars (radial)
        for idx = 1, #self.sprites["bars"]["radial"] do
             local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Bar2", wndBarList, self)
             wndIcon:FindChild("Sprite"):SetSprite(self.sprites["bars"]["radial"][idx])

             if strSelectedIconSprite == self.sprites["bars"]["radial"][idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
             end
        end

        -- Load Borders
        for idx = 1, #self.sprites["border"] do
            local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndBorderList, self)
            wndIcon:FindChild("Sprite"):SetSprite(self.sprites["border"][idx])

            if strSelectedIconSprite == self.sprites["border"][idx] then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            end
        end

        -- LUI Media
        if self.media then
            local icons = self.media:Load("icons")
            local spells = self.media:Load("spells")
            local bars_linear = self.media:Load({"bars","linear"})
            local bars_radial = self.media:Load({"bars","radial"})
            local text = self.media:Load("text")
            local forms = self.media:Load("forms")
            local borders = self.media:Load("borders")
            local animations = self.media:Load("animations")

            -- Icons
            for idx = 1, #icons do
                local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndIconList, self)
                wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(icons[idx]))

                if strSelectedIconSprite == "LUI_Media:"..tostring(icons[idx]) then
                   self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                end
            end

            -- Spells
            for idx = 1, #spells do
                local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndSpellList, self)
                wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(spells[idx]))

                if strSelectedIconSprite == "LUI_Media:"..tostring(spells[idx]) then
                    self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                end
            end

            -- Animations
            for idx = 1, #animations do
                local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Animation", wndAnimationList, self)
                wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(animations[idx]))

                if strSelectedIconSprite == "LUI_Media:"..tostring(animations[idx]) then
                   self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                end
            end

            -- Forms
            for idx = 1, #forms do
                 local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndFormList, self)
                 wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(forms[idx]))

                 if strSelectedIconSprite == "LUI_Media:"..tostring(forms[idx]) then
                    self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                 end
            end

            -- Text
            for idx = 1, #text do
                 local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndTextList, self)
                 wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(text[idx]))

                 if strSelectedIconSprite == "LUI_Media:"..tostring(text[idx]) then
                    self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                 end
            end

            -- Bars (linear)
            for idx = 1, #bars_linear do
                 local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Bar", wndBarList, self)
                 wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(bars_linear[idx]))

                 if strSelectedIconSprite == "LUI_Media:"..tostring(bars_linear[idx]) then
                    self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                 end
            end

            -- Bars (radial)
            for idx = 1, #bars_radial do
                 local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Bar2", wndBarList, self)
                 wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(bars_radial[idx]))

                 if strSelectedIconSprite == "LUI_Media:"..tostring(bars_radial[idx]) then
                    self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                 end
            end

            -- Borders
            for idx = 1, #borders do
                local wndIcon = Apollo.LoadForm(self.parent.xmlDoc, "Items:Icon", wndBorderList, self)
                wndIcon:FindChild("Sprite"):SetSprite("LUI_Media:"..tostring(borders[idx]))

                if strSelectedIconSprite == "LUI_Media:"..tostring(borders[idx]) then
                    self:SelectIcon(wndIcon:FindChild("SelectBtn"))
                end
            end
        end
    else
        -- Refresh Icons
        for idx,wndIcon in pairs(wndIconList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end

        -- Refresh Spells
        for idx,wndIcon in pairs(wndSpellList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end

        -- Refresh Animations
        for idx,wndIcon in pairs(wndAnimationList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end

        -- Refresh Forms
        for idx,wndIcon in pairs(wndFormList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end

        -- Refresh Texts
        for idx,wndIcon in pairs(wndTextList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end

        -- Refresh Bars
        for idx,wndIcon in pairs(wndBarList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end

        -- Refresh Borders
        for idx,wndIcon in pairs(wndBorderList:GetChildren()) do
            wndIcon:Show(true,true)

            if strSelectedIconSprite == wndIcon:FindChild("Sprite"):GetSprite() then
                self:SelectIcon(wndIcon:FindChild("SelectBtn"))
            else
                wndIcon:FindChild("SelectBtn"):SetCheck(false)
            end
        end
    end

    -- Search Icons
    if search ~= nil and search ~= "" then
        local searchArray = self:Split(search)

        -- Filter Icons
        for idx,wndIcon in pairs(wndIconList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end

        -- Filter Spells
        for idx,wndIcon in pairs(wndSpellList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end

        -- Filter Animations
        for idx,wndIcon in pairs(wndAnimationList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end

        -- Filter Forms
        for idx,wndIcon in pairs(wndFormList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end

        -- Filter Text
        for idx,wndIcon in pairs(wndTextList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end

        -- Filter Bars
        for idx,wndIcon in pairs(wndBarList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end

        -- Filter Borders
        for idx,wndIcon in pairs(wndBorderList:GetChildren()) do
            local show = false

            for k,v in pairs(searchArray) do
                if string.find(string.lower(wndIcon:FindChild("Sprite"):GetSprite()), v) then
                    show = true
                end
            end

            wndIcon:Show(show,true)
        end
    end

    -- Arrange Icons
    wndIconList:ArrangeChildrenTiles()
    wndSpellList:ArrangeChildrenTiles()
    wndFormList:ArrangeChildrenTiles()
    wndTextList:ArrangeChildrenTiles()
    wndBarList:ArrangeChildrenTiles()
    wndBorderList:ArrangeChildrenTiles()
    wndAnimationList:ArrangeChildrenTiles()

    self.loadIcons = false
end

function Settings:Split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = string.lower(string.gsub(str,'[^a-zA-Z]',''))
            i = i + 1
    end
    return t
end

function Settings:OnSearchClearBtn(wndHandler, wndControl)
    self.wndBrowse:FindChild("SearchEditBox"):SetText("")
    self.wndBrowse:FindChild("SearchClearBtn"):Show(false)
    self.wndBrowse:FindChild("SearchClearBtn"):SetFocus()
    self:OnLoadIcons()
end

function Settings:OnSearchEditBoxChanged(wndHandler, wndControl)
    self.wndBrowse:FindChild("SearchClearBtn"):Show(string.len(wndHandler:GetText() or "") > 0)
end

function Settings:OnSearchCommitBtn(wndHandler, wndControl)
    self.wndBrowse:FindChild("SearchClearBtn"):SetFocus()
    self:OnLoadIcons(self.wndBrowse:FindChild("SearchEditBox"):GetText())
end

function Settings:OnBrowseTabBtn(wndHandler, wndControl)
    for _,child in pairs(self.wndBrowse:FindChild("IconContainer"):GetChildren()) do
        if tostring(child:GetName()) == tostring(wndControl:GetName()) then
            child:Show(true)
        else
            child:Show(false)
        end
    end
end

function Settings:OnIconSelect(wndHandler, wndControl, eMouseButton)
    if eMouseButton == GameLib.CodeEnumInputMouse.Right then
         return false
    end

    self:SelectIcon(wndControl)
end

function Settings:SelectIcon(wndControl)
    if self.wndSelectedIcon ~= nil then
        self.wndSelectedIcon:SetCheck(false)
    end

    self.wndSelectedIcon = wndControl
    self.wndSelectedIcon:SetCheck(true)
end

function Settings:OnIconOK(wndHandler, wndControl)
    if self.wndSelectedIcon ~= nil then
        local strIcon = self.wndSelectedIcon:FindChild("Sprite"):GetSprite()
           local data = wndControl:GetData()[1]
           local text = wndControl:GetData()[2]

           if self.wndSettings:FindChild(text) then
               self.wndSettings:FindChild(text):SetText(strIcon)
           end

           self:SetVar(strIcon,{data,"build"})

           if self.wndRight:FindChild("IconPreview") then
               if data[1] and data[1] == "icon" then
                   self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetSprite(strIcon)
               elseif data[1] and data[1] == "border" then
                   self.wndRight:FindChild("IconPreview"):FindChild("Icon"):FindChild("Border"):SetSprite(strIcon)
               end
           end
    end

    self.wndBrowse:Close()
end

function Settings:OnBrowseCancel()
    self.wndBrowse:Close()
end

function Settings:OnWindowChanged(wndHandler, wndControl)
    if wndHandler ~= wndControl or wndControl:GetName() ~= "LUIAura_Config" then
        return
    end

    local nLeft, nTop, nRight, nBottom = self.wndSettings:GetAnchorOffsets()

    self.parent.config.offset = {
        left = nLeft,
        top = nTop,
        right = nRight,
        bottom = nBottom,
    }
end

function Settings:RefreshIconPreview()
    local aura = self:GetVar()
    local width = aura.icon.width or 333
    local height = aura.icon.height or 64

    if width > 190 then
        height = (height / width) * 190
        width = 190
    end

    if height > 190 then
        width = (width / height) * 190
        height = 190
    end

    self.wndRight:FindChild("IconPreview"):FindChild("Icon"):SetAnchorOffsets(
        -(width/2),
        -(height/2),
        (width/2),
        (height/2)
    )
end

function Settings:DisableNav(wndHandler,wndControl)
    if wndControl:GetParent():GetName() == "ZoneDropdown" and self.wndLastAuraSelected ~= nil then
        if self.wndSettings:FindChild("NewGroupButton") then
            self.wndSettings:FindChild("NewGroupButton"):Enable(not wndControl:IsShown())
        end

        if self.wndSettings:FindChild("NewTriggerButton") then
            self.wndSettings:FindChild("NewTriggerButton"):Enable(not wndControl:IsShown())
        end
    else
        if self.wndSettings:FindChild("ImportButton") then
            self.wndSettings:FindChild("ImportButton"):Enable(not wndControl:IsShown())
        end

        if self.wndSettings:FindChild("ExportButton") then
            self.wndSettings:FindChild("ExportButton"):Enable(not wndControl:IsShown())
        end
    end
end

function Settings:DisableText(wndHandler,wndControl)
    -- Time Remaining
    if self.wndRight:FindChild("DurationText") then
        self:ToggleSettings(self.wndRight:FindChild("DurationText"),not wndControl:IsShown())
    end

    -- Stack Count
    if self.wndRight:FindChild("StacksText") then
        self:ToggleSettings(self.wndRight:FindChild("StacksText"),not wndControl:IsShown())
    end

    -- Charge Count
    if self.wndRight:FindChild("ChargesText") then
        self:ToggleSettings(self.wndRight:FindChild("ChargesText"),not wndControl:IsShown())
    end

    -- Gadget Item Name
    if self.wndRight:FindChild("SpellName") then
        self:ToggleSettings(self.wndRight:FindChild("SpellName"),not wndControl:IsShown())
    end

    -- Buff / Debuff Threshold Slider
    if self.wndRight:FindChild("ThresholdSlider") then
        self:ToggleSettings(self.wndRight:FindChild("ThresholdSlider"),not wndControl:IsShown())
    end

    -- AMP Cooldown Duration Slider
    if self.wndRight:FindChild("TimeSlider") then
        self:ToggleSettings(self.wndRight:FindChild("TimeSlider"),not wndControl:IsShown())
    end

    -- Attribute Trigger
    if self.wndRight:FindChild("Attribute") then
        for _,group in pairs(self.wndRight:FindChild("Attribute"):GetChildren()) do
            if group:GetName() ~= "GeneralGroup" then
                for _,attribute in pairs(group:FindChild("Settings"):GetChildren()) do
                    self:ToggleSettings(attribute:FindChild("ValueText"),not wndControl:IsShown())
                end
            end
        end
    end

    -- Source Trigger Effect
    if self.wndRight:FindChild("SourceGroup") then
        for _,source in pairs(self.wndRight:FindChild("SourceOptions"):GetChildren()) do
            if source:FindChild("SourceCheckbox"):IsChecked() then
                self:ToggleSettings(source:FindChild("SourceDropdown"),not wndControl:IsShown())
            end
        end
    end
end

-- ########################################################################################################################################
-- # HELPER
-- ########################################################################################################################################

function Settings:InTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

function Settings:GetIdentifiers()
    local groupId,auraId,triggerId,childId

    if self.wndLastGroupSelected ~= nil then
        groupId = self.wndLastGroupSelected:GetData()[1]:GetData()
    elseif self.wndLastAuraSelected ~= nil then
        groupId = self.wndLastAuraSelected:GetData()[1]:GetData()
        auraId = self.wndLastAuraSelected:GetData()[2]:GetData()
    elseif self.wndLastTriggerSelected ~= nil then
        groupId = self.wndLastTriggerSelected:GetData()[1]:GetData()
        auraId = self.wndLastTriggerSelected:GetData()[2]:GetData()
        triggerId = self.wndLastTriggerSelected:GetData()[3]:GetData()
    elseif self.wndLastChildSelected ~= nil then
        groupId = self.wndLastChildSelected:GetData()[1]:GetData()
        auraId = self.wndLastChildSelected:GetData()[2]:GetData()
        triggerId = self.wndLastChildSelected:GetData()[3]:GetData()
        childId = self.wndLastChildSelected:GetData()[4]:GetData()
    end

    return groupId,auraId,triggerId,childId
end

function Settings:GetVar(key,child,grandchild)
    local groupId,auraId,triggerId,childId = self:GetIdentifiers()
    local setting = nil

    if groupId ~= nil then
        if auraId  ~= nil then
            if triggerId ~= nil then
                if childId ~= nil then
                    setting = self.parent.config.groups[groupId].runtime.auras[auraId].triggers[triggerId].triggers[childId]
                else
                    setting = self.parent.config.groups[groupId].runtime.auras[auraId].triggers[triggerId]
                end
            else
                setting = self.parent.config.groups[groupId].runtime.auras[auraId]
            end
        else
            setting = self.parent.config.groups[groupId]
        end
    else
        setting = self.parent.config
    end

    return self:SelectVar(setting,key,child,grandchild) or nil
end

function Settings:SelectVar(setting,key,child,grandchild)
    if not setting then
        return nil
    end

    if key then
        if child then
            if grandchild then
                return setting[key][child][grandchild] or nil
            else
                return setting[key][child] or nil
            end
        else
            return setting[key] or nil
        end
    else
        return setting or nil
    end
end

function Settings:Save(value,action,key,child,grandchild)
    local groupId,auraId,triggerId,childId = self:GetIdentifiers()
    local setting = nil

    if groupId ~= nil then
        if auraId ~= nil then
            if triggerId ~= nil then
                if childId ~= nil then
                    setting = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId].triggers[childId]
                else
                    setting = self.parent.config.groups[groupId].auras[auraId].triggers[triggerId]
                end
            else
                setting = self.parent.config.groups[groupId].auras[auraId]
            end
        else
            setting = self.parent.config.groups[groupId]
        end
    else
        setting = self.parent.config
    end

    if setting then
        self:UpdateVar(setting,key,child,grandchild,value)
        setting = nil
    end

    if groupId ~= nil then
        if auraId ~= nil then
            if triggerId ~= nil then
                if childId ~= nil then
                    setting = self.parent.config.groups[groupId].runtime.auras[auraId].triggers[triggerId].triggers[childId]
                else
                    setting = self.parent.config.groups[groupId].runtime.auras[auraId].triggers[triggerId]
                end
            else
                setting = self.parent.config.groups[groupId].runtime.auras[auraId]
            end
        end
    end

    if setting then
        self:UpdateVar(setting,key,child,grandchild,value)
        setting = nil
    end

    if action ~= "nobuild" and groupId then
        if auraId then
            self.parent:BuildAura(groupId,auraId)
        else
            self.parent:BuildGroup(groupId)
        end
    end

    if action == "check" then
        self.parent:CheckCircumstances(true)
    end
end

function Settings:UpdateVar(setting,key,child,grandchild,value)
    if setting == nil then
        return
    end

    if key then
        if child then
            if grandchild then
                if not setting[key] then
                    setting[key] = {}
                end

                if not setting[key][child] then
                    setting[key][child] = {}
                end

                setting[key][child][grandchild] = value
            else
                if not setting[key] then
                    setting[key] = {}
                end

                setting[key][child] = value
            end
        else
            setting[key] = value
        end
    else
        setting = value
    end
end

function Settings:SetVar(value,setting)
    local path = {}
    local action = nil

    if type(setting) == "string" then
        path = {setting}
    elseif type(setting) == "table" then
        if type(setting[1]) == "string" then
            path = {setting[1]}
        else
            path = setting[1]
        end

        if setting[2] ~= nil then
            action = setting[2]
        end
    end

    self:Save(value,action,unpack(path))
end

LUI_Aura.Settings = Settings
