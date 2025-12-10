# Talented TBC Anniversary Edition - Migration Plan

This document outlines the steps taken to migrate the Talented addon for the TBC Anniversary realms and the next steps required by the user to complete the migration.

## Phase 1: Initial Code Porting (Completed)

I have performed the initial code migration to make the addon compatible with the modern WoW client used by the TBC Anniversary realms. Here is a summary of the changes:

1.  **Updated `.toc` file**:
    *   Changed `## Interface: 20504` to `## Interface: 30401` to match the modern client.
    *   Updated the version number to `v240101-TBC-Anniversary`.

2.  **Updated Talent Indexing Logic**:
    *   Replaced `tbc/Talented/IndexMatching.lua` with the version from the `wotlk` folder. The modern client uses non-sequential talent indices, and this file contains the necessary logic to handle them.
    *   **Crucially, the *data* in this file is still for WotLK and needs to be updated for TBC.**

3.  **Added a Data Generation Tool**:
    *   Added a new function, `PrintSortedWoWIndices`, to the `DevTools_Dump.lua` file.
    *   Added a new slash command, `/talind`, to allow you to easily run this function from in-game.

## Phase 2: Data Generation and Testing (User Action Required)

The addon will now load, but the talent trees will be incorrect because the talent index data is for the wrong game version. You will need to generate the correct data using the tools I have added.

**Your task is as follows:**

1.  **Log in to the TBC Anniversary client.**
2.  **For each class** (Warrior, Paladin, Hunter, Rogue, Priest, Shaman, Mage, Warlock, Druid), you must log in with a character of that class.
3.  Once in-game, open the chat box and type: `/talind`
4.  This command will print a block of text into your chat window that looks something like this:

    ```lua
        WARRIOR = {
            {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31},
            {32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60},
            {61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89}
        },
    ```

5.  **Copy this entire block of text.**
6.  **Open the file:** `e:\Games\BattleNet\Wow\World of Warcraft\_classic_era_ptr_\Interface\AddOns\TalentedTBC\tbc\Talented\IndexMatching.lua`
7.  **Paste the text** you copied into the `indexToWowIndex` table, replacing the existing entry for that class.
8.  **Repeat this process for all 9 classes.**

## Phase 3: Bug Fixing

After you have updated the `IndexMatching.lua` file with the correct data for all classes, the addon should be mostly functional.

Please test the following:
*   Opening and closing the talent frame.
*   Creating, saving, and loading talent templates.
*   Applying talent points.
*   Importing and exporting templates.

If you encounter any errors (especially Lua errors that pop up on screen), please copy them and provide them to me. I will then fix the remaining bugs.
