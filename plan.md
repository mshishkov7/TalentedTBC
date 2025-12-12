TalentedClassic TBC Port - Strategic Plan
Context Assessment:
Current Repository Structure:

Era folder - For Classic Era/Anniversary realms (Vanilla 1.15.x)
sod folder - For Season of Discovery
wotlk folder - For Wrath of the Lich King Classic (3.4.x)
No TBC folder currently exists

Key Information:

TBC Anniversary PTR is currently live (version 2.5.5)
Pre-patch launches January 13, 2026
Full TBC Anniversary launch expected early February 2026
You're correct - the Era version is the most actively maintained (latest release September 2024)

Critical API Differences:
Based on my research, the main API changes between vanilla and TBC include:

Lua upgrade from 5.0 to 5.1
UnitAura() API now returns duration/expiration data natively in TBC (wasn't available in vanilla)
Secure template restrictions and combat lockdowns
Backdrop/BackdropTemplate changes
Focus target system addition


STEP-BY-STEP PORTING PLAN
Phase 1: Assessment & Setup
Step 1.1 - Determine Base Version

Start from: Era folder (not wotlk)
Reasoning:

Era is the most recently maintained
It uses modern Classic API calls that are compatible with TBC Anniversary
WotLK version is older and uses deprecated APIs
Era likely already handles modern restrictions Blizzard added to Classic



Step 1.2 - Set Up Testing Environment

Install TBC Anniversary PTR client
Create TBC folder in repository structure (sibling to Era/sod/wotlk)
Copy entire Era folder contents into new tbc folder as starting point


Phase 2: TOC File Configuration
Step 2.1 - Update Interface Version

Change TOC file Interface version from Era's 11502 (Classic 1.15.2) to TBC's 20505 (2.5.5)
Critical: This is the minimum viable change to get addon loading

Step 2.2 - Version Compatibility Check

Look for any WOW_PROJECT_ID checks in code
Era likely checks for WOW_PROJECT_CLASSIC
TBC needs to check for WOW_PROJECT_BURNING_CRUSADE_CLASSIC
Add conditional logic to handle both if code needs different behavior


Phase 3: API Compatibility Review
Step 3.1 - Talent API Functions
Review all uses of these functions (they're core to the addon):

GetNumTalentTabs() - Should work in TBC
GetTalentTabInfo() - Should work in TBC
GetNumTalents() - Should work in TBC
GetTalentInfo() - Should work in TBC
LearnTalent() - Should work in TBC
GetTalentPrereqs() - Should work in TBC

Step 3.2 - Check for Vanilla-Specific Workarounds

Look for any LibClassicDurations usage (NOT needed in TBC)
Remove or make conditional any vanilla-specific buff/debuff duration tracking
TBC natively returns duration data unlike vanilla

Step 3.3 - Backdrop Template Updates

Search for any SetBackdrop() calls
If found, frames need to inherit from BackdropTemplateMixin
Add "BackdropTemplate" to CreateFrame calls where needed

Step 3.4 - Secure Template Compliance

Review any frame modifications during combat
TBC has stricter protected frame rules than vanilla
Ensure no programmatic showing/hiding of frames in combat
No attribute changes to action buttons during combat


Phase 4: TBC-Specific Features
Step 4.1 - Handle Increased Talent Points

TBC has 61 talent points (levels 10-70) vs vanilla's 51 (levels 10-60)
Verify tree depth calculations work for 70-point builds
Check if talent point validation logic needs updates

Step 4.2 - Handle New Races

Draenei and Blood Elves are added in TBC pre-patch
Ensure class-to-race mappings include new races
Paladin now available to Alliance AND Horde
Shaman now available to Horde AND Alliance

Step 4.3 - Update Wowhead Integration

Era version likely uses classic.wowhead.com
TBC should use tbc.wowhead.com for talent link imports/exports
Check talent string format compatibility


Phase 5: Testing Protocol
Step 5.1 - Basic Functionality Testing
Test in this order on PTR:

Addon loads without errors
Talent frame opens correctly
All three talent trees display properly
Hovering over talents shows correct tooltips
Can click talents to spend points
Point validation works (prerequisites, tier requirements)
Can create new templates
Can save templates
Can load templates
Can apply templates (auto-spend points)

Step 5.2 - Edge Case Testing

Test with fresh level 10 character
Test with max level (70) character
Test with partially-spent talents
Test talent respec flow
Test sharing/importing builds
Test macro command /talented apply <template>

Step 5.3 - Cross-Race/Class Testing

Test all 9 classes
Specifically test Draenei Shaman and Blood Elf Paladin
Verify no race-specific issues


Phase 6: Known Issues to Address
Step 6.1 - Hunter Pet Talents

This is a known broken feature in the original addon
Check if Era version has any fixes
May require significant work to implement
Could be marked as "TBC limitation" if not fixable quickly

Step 6.2 - Wowhead Import Issues

Known issue from original addon
TBC talent string format may differ
Test extensively with TBC Wowhead links
May need to update parsing logic


Phase 7: Quality Assurance
Step 7.1 - Code Cleanup

Remove any debugging code
Ensure consistent code style with other versions
Add comments explaining TBC-specific changes

Step 7.2 - Documentation Updates

Update README with TBC support
Document any known TBC-specific issues
Note minimum required game version (2.5.5+)

Step 7.3 - Version Management

Create separate release for TBC
Use version naming like v240xxx-TBC to match Era/SoD pattern
Tag appropriately in git


Phase 8: Pre-Launch Preparation
Step 8.1 - PTR Testing Window

Test thoroughly during PTR (now through early January)
Gather feedback from PTR testers
Fix any critical bugs before Jan 13 pre-patch

Step 8.2 - Release Strategy

Have TBC version ready BEFORE Jan 13 pre-patch
Many players will want it immediately when TBC goes live
Consider beta release to PTR testers first

Step 8.3 - Community Distribution

Publish to CurseForge/WoW Interface
Update GitHub releases
Announce in addon communities


CRITICAL REASONING & WARNINGS
Why Start from Era, Not WotLK:

Era uses modern Classic API - Blizzard has been updating the Classic API iteratively. Era (1.15.x) is closer to TBC (2.5.5) than WotLK (3.4.x) was to original WotLK (3.3.5)
Recent maintenance - Era version was updated September 2024, showing active development and bug fixes
API restrictions alignment - Blizzard added many addon restrictions to Classic over time (like LFG addon blocking). Era version likely already handles these, which TBC Anniversary inherits
Less technical debt - WotLK version is older, may have workarounds for issues that no longer exist

Key Risk Areas:

Backdrop/Template System - This is the #1 killer of addons between versions. Many addons break purely on this.
Combat Restrictions - TBC has stricter rules about what addons can do in combat. Any talent-learning during combat will fail.
Hunter Pet Talents - Already broken in WotLK version, likely complex to fix
LibClassicDurations - If Era version uses this library, it MUST be removed/disabled for TBC as it causes crashes

Success Metrics:

Addon loads without Lua errors ✓
All core features work (view, create, save, load templates) ✓
Can apply templates to auto-learn talents ✓
No crashes or freezes ✓
Compatible with other popular addons ✓


This plan should give you a clear roadmap without diving into code specifics. The key insight is that Era is your base, not WotLK, and the main work will be in API compatibility, TOC updates, and thorough testing rather than major feature rewrites.