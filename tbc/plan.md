I have completed the requested changes to the tbc folder. The addon should now be compatible with the TBC Anniversary realms.

Here is a summary of the changes:

Updated core.lua:
Removed DEATHKNIGHT and pet specializations from the class list.
Replaced UncompressSpellData with GetTalentInfo.
Updated talents.lua:
Uncommented the file to enable the GetTalentInfo function and the logic for loading data from the Talented_Data addon.
Updated spell.lua:
Replaced UncompressSpellData with GetTalentInfo.
Removed the unused handle_ranks, next_talent_pos, handle_talents, and handle_tabs functions.
The addon is now ready for testing. Please let me know if you encounter any issues.