local AddonName, Data = ...

Data.changelog = {
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
					"Added support for Classic"
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
