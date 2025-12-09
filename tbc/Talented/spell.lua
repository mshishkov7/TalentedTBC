function Talented:UncompressSpellData(class)
	--Gives data of the format,
	--classTrees      = self:GetTalentInfo(class)
	--treeObj         = self:GetTalentInfo(class)[tab]
	--treeTalents     = self:GetTalentInfo(class)[tab].talents
	--talentObj       = self:GetTalentInfo(class)[tab].talents[index]
	--talentInfoTable = self:GetTalentInfo(class)[tab].talents[index].info
	--talentRow       = self:GetTalentInfo(class)[tab].talents[index].info.row
	--Templates are different. They have the format
	--classTrees      = template
	--treeObj         = ---
	--treeTalents     = template[tab]
	--talentRank      = template[tab][index]
	if not self.spelldata then self.spelldata = {} end
	if not self.spelldata[class] then
		data = Talented:GetTalentInfo(class)
		self.spelldata[class] = data
	else
		data = self.spelldata[class]
	end
	
	if type(data) == "table" then return data end

	self:Debug("UNCOMPRESS CLASSDATA", class)
	data = handle_tabs(strsplit("|", data))
	self.spelldata[class] = data
	if class == select(2, UnitClass"player") then
		self:CheckSpellData(class)
	end
	return data
end

local spellTooltip
local function CreateSpellTooltip()
	local tt = CreateFrame"GameTooltip"
	local lefts, rights = {}, {}
	for i = 1, 5 do
		local left, right = tt:CreateFontString(), tt:CreateFontString()
		left:SetFontObject(GameFontNormal)
		right:SetFontObject(GameFontNormal)
		tt:AddFontStrings(left, right)
		lefts[i], rights[i] = left, right
	end
	tt.lefts, tt.rights = lefts, rights
	function tt:SetSpell(spell)
		self:SetOwner(TalentedFrame)
		self:ClearLines()
		self:SetHyperlink("spell:"..spell)
		return self:NumLines()
	end
	local index
	if CowTip then
		index = function (self, key)
			if not key then return "" end
			local lines = tt:SetSpell(key)
			if not lines then return "" end
			local value
			if lines == 2 and not tt.rights[2]:GetText() then
				value = tt.lefts[2]:GetText()
			else
				value = {}
				for i=2, tt:NumLines() do
					value[i - 1] = {
						left=tt.lefts[i]:GetText(),
						right=tt.rights[i]:GetText(),
					}
				end
			end
			tt:Hide() -- CowTip forces the Tooltip to Show, for some reason
			self[key] = value
			return value
		end
	else
		index = function (self, key)
			if not key then return "" end
			local lines = tt:SetSpell(key)
			if not lines then return "" end
			local value
			if lines == 2 and not tt.rights[2]:GetText() then
				value = tt.lefts[2]:GetText()
			else
				value = {}
				for i=2, tt:NumLines() do
					value[i - 1] = {
						left=tt.lefts[i]:GetText(),
						right=tt.rights[i]:GetText(),
					}
				end
			end
			self[key] = value
			return value
		end
	end
	Talented.spellDescCache = setmetatable({}, { __index = index, })
	CreateSpellTooltip = nil
	return tt
end

function Talented:GetTalentName(class, tab, index)
	local talent = self:GetTalentInfo(class)[tab].talents[index].info
	return talent.name
	-- local spell = self:GetTalentInfo(class)[tab][index].ranks[1]
	-- return (GetSpellInfo(spell))
end

function Talented:GetTalentIcon(class, tab, index)
	local talent = self:GetTalentInfo(class)[tab].talents[index].info
	return talent.icon
	-- local spell = self:GetTalentInfo(class)[tab][index].ranks[1]
	-- return (select(3, GetSpellInfo(spell)))
end

function Talented:GetTalentDesc(class, tab, index, rank)
	if not spellTooltip then
		spellTooltip = CreateSpellTooltip()
	end
	local spell = self:GetTalentInfo(class)[tab].talents[index].info
	return self.spellDescCache[spell]
end

function Talented:GetTalentPos(class, tab, index)
	local talent = self:GetTalentInfo(class)[tab].talents[index].info
	return talent.row, talent.column
end

function Talented:GetTalentPrereqs(class, tab, index)
	local talent = self:GetTalentInfo(class)[tab].talents[index].info
	return talent.prereqs
end

function Talented:GetTalentRanks(class, tab, index)
	local talent = self:GetTalentInfo(class)[tab].talents[index].info
	return talent.ranks --should be #talent.ranks if ranks is an array
end

function Talented:GetTalentLink(template, tab, index, rank)
	-- local data = self:GetTalentInfo(template.class)
	-- local rank = rank or (template[tab] and template[tab][index])
	-- if not rank or rank == 0 then
	-- 	rank = 1
	-- end
	-- return ("|cff71d5ff|Hspell:%d|h[%s]|h|r"):format(data[tab][index].ranks[rank],
	-- 	self:GetTalentName(template.class, tab, index)
	-- )
	local current = self:GetActiveSpec()
	if current == template then
		local link = GetTalentLink(tab, self:GetNewIdx(tab, index)) --note cannot get rank
		return link
	else
		return nil
	end
end
