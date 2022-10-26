local AddonName, Data = ...

Data.changelog = {
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
