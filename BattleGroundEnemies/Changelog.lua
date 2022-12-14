local AddonName, Data = ...

Data.changelog = {
	{
		Version = "10.0.2.6",
		Sections = {
			{
				Header = "Changes:",
				Entries = {
					"The addon now removes all auras (buffs and debuffs) for enemies that have no longer a unitID assigned. This prevents the addon from showing outdated auras.",
				}
			},
		}
	},
	{
		Version = "10.0.2.5",
		Sections = {
			{
				Header = "Changes:",
				Entries = {
					"Non Priority buffs and debuffs are now disabled for bg size 15 players since it leads to too much clutter.",
				}
			},
		}
	},
	{
		Version = "10.0.2.4",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed the flickering health bar.",
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"The addon will now check for up to 15 arena unitIDs, this is helpful in the Arena Brawl Packed House.",
				}
			},
		}
	},
	{
		Version = "10.0.2.3",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fix for the brawl Packed House.",
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"Reworked the way the addon handles player updates from diferent player sources. The addon now stores data from all that sources and combines them to create player bars. This also fixes the addon in the brawl Packed House."
				}
			},
		}
	},
	{
		Version = "10.0.2.2",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Removed leftover message from development, thanks to Doyansu233 and Clarkis2001 aat Curseforge for the report.",
					"Fixed an error that prevented targeting of enemy players in arena after they changed name, in arena the addon will now always target by unitID instad of playername, this is helpful for stealth players expecially since the addon can't update in combat due to Blizzards restrictions."
				}
			}
		}
	},
	{
		Version = "10.0.2.1",
		General = "This version fixes some problems i found during solo shuffle arenas and adds some features. It adds some allied races and improved auras.",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added racials Bag of Tricks, Fireblood, Light's Judgment, Bull Rush, Haymaker and Arcane Pulse",
					"The addon will now also show auras without a duration in the highest priority module.",
					"The addon will now use the scoreboard info to show the player names in the prep room before the first round starts when in a solo shuffle"
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"The addon will now show non priority buffs and debuffs that are applied by the player by or are dispellable by default.",
					"The enemy players are now always sorted by arena id when in arena, by default arena1 is the top player"
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"When the duration filter is enabled for auras it will only show the aura if it actually has a duration.",
					"Update LibSpellIconSelector library to avoid taint. Thanks to zaphon at GitHub for the report.",
					"Improved the handling of update in combat. This mostly affected name changes of stealth units at the beginning of an arena while in combat.",
					"Fixed error reported by Thenetbug at Curseforge that happened in rated Battlegrounds when the combat log scanning was getting switched off."
				}
			}
		}
	},
	{
		Version = "10.0.2.0",
		General = "This version fixes a error message and hopefully makes RBGs fully working. Please read the notes from version 9.2.7.2 below if you haven't been using a version 9.2.7.X before",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added a option to change the thickness of the borders used for your target and focus.",
					"Added a new icon selector that is used for the combat indicator."
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a error that occured when going from a BG into a arena reported by dankNstein_ at curseforge.",
					"Fixed a issue when the lost health option was selected for the health text."
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"This release should now fully workes in RBGs, thanks at l3uGsY at GitHub for testing things out and providing data :)",
					"Non priority auras will now show if they are dispellable or cast by you.",
					"Added back the aura scanning for enemies that are only targeted by group members and don't have any other unit IDs assigned."
				}
			}
		}
	},
	{
		Version = "10.0.0.3",
		General = "This version fixed a code loop.. Please read the notes from version 9.2.7.2 below if you haven't been using a version 9.2.7.X before",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a code loop which potentially can result in a game freeze. Thanks to everyone contributing and reporting :)",
				}
			}
		}
	},
	{
		Version = "10.0.0.2",
		General = "This version brings a new features and fixes reported errors and issues. Please read the notes from version 9.2.7.2 below if you haven't been using a version 9.2.7.X before",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added support for combat log scanning to detect enemy players in Rated Battlegrounds on Dragonflight. Please note that this means its no longer possible to get the spec of a player. Thanks at l3uGsY at Github for doing some tests.",
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a Lua error reported by creepshow11483 at curseforge.",
					"Fixed a Lua error reported by GeT_LeNiN at curseforge.",
					"Reduced the amount of aura scans for enemies targeted by Allies, this hopefully fixes the problem with the game being unresponsive",
					"Fixed a bug regarding custom aura filtering of non priority auras reported by Seadu at curseforge",
					"Fixed a issue where the powerbar was chaning color when a player had a alternative ressource update like a rogue gaining a combo point"
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"Player names are now truncated if they dont fit into the frame and dont wrap into two lines anymore.",
					"Updated the default settings for arena to avoid overlapping modules.",
					"Health text is now abbreviated if too long. (Same as its done on Default Blizzard frames)",
				}
			}
		}
	},
	{
		Version = "10.0.0.1",
		General = "Another bugfix update with other smaller changes. Please read the notes from version 9.2.7.2 below if you haven't been using a version 9.2.7.X before",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a typo that affected the target indicator symbols not to show up",
					"Fixed a typo that let to an error for aura updates",
					"Fixed a issue with incorrectly assigned to enemy players which let to stuff depending on it showing infos for different players like buffs, castbar, etc",
					"Fixed a issue were running the testmode before entering a BG let to battleground specifig buffs show up when a player was shown in a arena frame",
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"There are now 2 settings to disable arena frames, one to hide them battlegrounds and one for arenas"
				}
			}
		}
	},
	{
		Version = "10.0.0.0",
		General = "Just a small bugfix update. Please read the notes below if you haven't been using a version 9.2.7.X before",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added a new module 'Combat Indicator'. This module shows an icon depending on the state of the player. It can show an icon when the player is in combat or out of combat, it will show no icon if the status is unknown. (This can be the case for enemies that dont have a unitID assigned.) This module is not 100% finished yet and disabled by default. I will add a icon selector in the future, and its missing the testmode implementation. Feedback on this new feature is appreciated :)",
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"Toc update for 10.0.0"
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"Auras gathered by the new UNIT_AURA 2nd argument get a priority applied"
				}
			}
		}
	},
	{
		Version = "9.2.7.2",
		General = "This is the long awaited update with many changes and new features. It is recommended to reset the settings of the addon in the profile tab, especially when you didnt use the default settings. This is due to the fact that the saved variables format changed. So please take a few minutes and check out the testmode :)",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added seperate modules for important buffs and debuffs",
					"Unified code for the containers used by the DR Tracking and Buffs, Debuffs.",
					"Added a seperate module for class icons, the spec icon is stacked ontop of the class icon by default. This enables you to show the two icons side by side if wanted.",
					"Added the ability to add health numbers (percentage, lost health and current health)",
					"Added an option to disable target icons.",
					"Added the option to export and import profiles to and from a string.",
					"Added the option to reset modules individually to the default setting.",
					"Added an option to use the priority of Auras and Interrupts from BigDebuffs",
					"Pretty much all of the stuff is now individually movable and sizable",
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"Reworked the aura system once again. it now should update the auras of enemies more often if an unit ID is available.",
					"Only send infos about a missing localization entry once.",
					"Toc updates for Classic, TBCC, Wrath and Retail"
				}
			}
		}
	},
	{
		Version = "9.2.0.11",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a mistake in version string comparison which resulted in spam about a new available version. Thanks coyote_ii@curseforge for the report."
				}
			}
		}
	},
	{
		Version = "9.2.0.10",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"The addon frames should no longer be able to be placed outside the screen."
				}
			}
		}
	},
	{
		Version = "9.2.0.9",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a error message that happened in TBC or Classic. It was probably caused by some data not yet being available. Thanks to Maas1337@Github for reporting."
				}
			}
		}
	},
	{
		Version = "9.2.0.8",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a error message. Thanks to Soundsstream@curseforge for reporting"
				}
			}
		}
	},
	{
		Version = "9.2.0.7",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed an error that appeared in battlegrounds wich was caused by another addon or probably by disabling the default arena UI addon. Thank to Sharki519@curseforge for reporting."
				}
			}
		}
	},
	{
		Version = "9.2.0.6",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added absorbs to the healthbar, same functionality as the default Blizzard frames. This can be disabled in the healthbar settings."
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"The addon now works in the Comp Stomp brawl. "
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a issue with the Respawn timer icon staying on screen after the player is alive again.",
					"Fixed a bug where the Spec icon was overlayed by CC icons when you entered a new BG. Thanks for reporting that issue"
				}
			}
		}
	},
	{
		Version = "9.2.0.5",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added support for Classic",
					"Added a Castbar module which is enabled in Arenas by default."
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"Added a comma between the name list in the /bgev text",
					"print the newest available version when out of date",
					"The addon now uses the same package/zip for Classic, TBC and Retail",
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"Gladiator's resolve has no Cooldown."
				}
			}
		}
	},
	{
		Version = "9.2.0.4",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed two Lua errors after login"
				}
			}
		}
	},
	{
		Version = "9.2.0.3",
		Sections = {
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed the target indicators, which i broke accidentally in 9.2.0.0",
					"Fixed an issue that made allies disappear and reappear shortly after joining the group or after a reload"
				}
			}
		}
	},
	{
		Version = "9.2.0.0",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added support for arenas. Feedback appreciated",
					"Added support for the new pvp trinket Gladiator's Fastidious Resolve"
				}
			},
			{
				Header = "Bugfixes:",
				Entries = {
					"Fixed a bug reported by mltco78dhs@curseforge that happened in rated battlegrounds.",
					"Fixed a bug reported by zooloogorbonos and Air10000 that happened in open world"
				}
			},
			{
				Header = "Changes:",
				Entries = {
					"Toc update for 9.2"
				}
			}
		}
	},
	{
		Version = "9.1.0.0",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added support for arenas. It might still be a bit buggy and the default settings aren't really updated yet. Testmode is working. Feedback appreciated",
				}	
			},
			{
				Header = "Changes:",
				Entries = {
					"Toc update for 9.1"
				}
			}
		}
	},
	{
		Version = "9.0.5.6",
		Sections = {
			{
				Header = "New Features:",
				Entries = {
					"Added a new window that shows changes made in new releases"
				}
			}
		}
	},
	{
		Version = "9.0.5.5",
		Sections = {
			{
				Header = "New Features",
				Entries = {
					"Added first version of target calling, feedback appreciated. Check out the Rated Battleground section in the options. Read about how it works in the FAQ at https://github.com/BullseiWoWAddons/BattleGroundEnemies/wiki/FAQ"
				}
			}
		}
	}
}
