--[[
	Bagnon Localization: Korean
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'koKR')
if not L then return end

--keybindings
L.ToggleBags = '인벤토리 온/오프'
L.ToggleBank = '은행 온/오프'
L.ToggleGuild = '길드 은행 온/오프'
L.ToggleVault = '공허 보관사 온/오프'

--terminal
L.Commands = '명령어:'
L.CmdShowInventory = '가방 온/오프'
L.CmdShowBank = '은행 온/오프'
L.CmdShowGuild = '길드 은행 온/오프'
L.CmdShowVault = '공허 보관사 온/오프'
L.CmdShowVersion = '현재 버전 정보 출력'
L.Updated = '업데이트 v%s'

--frames
L.TitleBags = '%s\의 인벤토리'
L.TitleBank = '%s\의 은행'

--tooltips
L.TipBags = '가방'
L.TipChangePlayer = '다른 캐릭터의 아이템 보기'
L.TipCleanBags = '클릭하여 가방을 자동으로 정리합니다.'
L.TipCleanBank = '<우-클릭> 은행을 자동으로 정리합니다.'
L.TipDepositReagents = '<좌-클릭> 모든 재료를 재료 은행에 넣습니다.'
L.TipFrameToggle = '<우-클릭> 다른 창 표시(은행 또는 공허 보관사)'
L.TipGoldOnRealm = '전체 %s'
L.TipHideBag = '이 가방을 감추려면 클릭하세요.'
L.TipHideBags = '<좌-클릭> 가방 감추기'
L.TipHideSearch = '클릭하면 검색 종료'
L.TipManageBank = '은행 관리'
L.TipResetPlayer = '<우-클릭> 현재 캐릭터 가방 표시'
L.PurchaseBag = '이 은행 슬롯을 구매하려면 클릭하세요.'
L.TipShowBag = '이 가방으로 보이게 하려면 클릭하세요.'
L.TipShowBags = '<좌-클릭> 가방 표시'
L.TipShowMenu = '<우-클릭> 하면 이 창을 설정할 수 있습니다.'
L.TipShowSearch = '검색하려면 클릭.'
L.TipShowFrameConfig = '설정 창 열기'
L.TipDoubleClickSearch = '<알트-드래그> 이동\n<우-클릭> 설정\n<더블-클릭> 검색'
L.Total = '전체'

--itemcount tooltips
L.TipCount1 = '착용: %d'
L.TipCount2 = '가방: %d'
L.TipCount3 = '은행: %d'
L.TipCount4 = '금고: %d'
L.TipDelimiter = '|'

--databroker tooltips
L.TipShowInventory = '<좌 클릭> 인벤토리 온/오프'
L.TipShowBank = '<시프트 좌 클릭> 은행 온/오프'
L.TipShowOptions = '<우 클릭> 설정 창 열기'
