# Ghostty Keybind Koan

Practice these exercises in order to build muscle memory.

## Level 1: Tabs

**Exercise 1.1 - Basic Tab Creation**
1. Open Ghostty
2. Create 3 new tabs (`⌘ T`)
3. Jump to tab 1 (`⌘ 1`)
4. Jump to tab 3 (`⌘ 3`)
5. Jump to last tab (`⌘ 9`)

**Exercise 1.2 - Tab Cycling**
1. Create 4 tabs
2. Use only `⌘ Shift [` and `⌘ Shift ]` to visit each tab
3. Close all but one tab (`⌘ W`)

**Exercise 1.3 - Tab Speed Run**
1. Create 5 tabs as fast as possible
2. Jump to each tab by number (1-5)
3. Close them all

---

## Level 2: Splits

**Exercise 2.1 - Basic Splitting**
```
┌─────┬─────┬─────┐
│  1  │  2  │  3  │
└─────┴─────┴─────┘
```
1. Split right (`⌘ D`)
2. Split right again (now you have 3 panes)
3. Navigate through them with `⌘ [` and `⌘ ]`

**Exercise 2.2 - Directional Navigation**
```
┌─────┬─────┬─────┐
│  1  │     │     │
├─────┤  3  │  4  │
│  2  │     │     │
└─────┴─────┴─────┘
```
1. Split right twice (`⌘ D`)
2. Go to leftmost pane
3. Split down (`⌘ Shift D`)
4. Navigate using `⌘ Option ←→↑↓` only
5. Visit each pane using arrow directions

**Exercise 2.3 - Focus Mode**
```
┌──────────┬──────────┐
│    1     │    2     │
├──────────┼──────────┤
│    3     │    4     │
└──────────┴──────────┘
```
1. Create a 2x2 grid (2 vertical, then split each horizontally)
2. Navigate to top-right pane
3. Zoom it (`⌘ Shift Enter`)
4. Unzoom it
5. Navigate to bottom-left
6. Zoom it

**Exercise 2.4 - Split Cleanup**
1. Create multiple splits (any layout)
2. Close them one by one (`⌘ W`)
3. Until you're back to a single pane

---

## Level 3: Navigation & History

**Exercise 3.1 - Command Jumping**
1. Run these commands:
   - `ls -la`
   - `echo "hello"`
   - `pwd`
   - `date`
2. Jump to previous prompt (`⌘ ↑`) repeatedly
3. Jump forward (`⌘ ↓`) to get back

**Exercise 3.2 - Clean Slate**
1. Run several commands to fill the screen
2. Clear the screen (`⌘ K`)
3. Verify it's clean

---

## Level 4: Text & Clipboard

**Exercise 4.1 - Quick Copy**
1. Run: `echo "test output that I want to copy"`
2. Select all (`⌘ A`)
3. Copy (`⌘ C`)
4. Paste it somewhere (`⌘ V`)

---

## Daily Practice Routine

**Morning Warm-up (2 minutes)**
1. Create 5 tabs, jump between them by number
2. Close all but one
3. Create a 2x2 split grid
4. Navigate through splits using arrow directions
5. Clean up

**Advanced Combo Practice**
```
Tab 1:            Tab 2:            Tab 3:
┌─────┬─────┐    ┌───────────┐    ┌───────────┐
│     │     │    │     1     │    │           │
│  1  │  2  │    ├───────────┤    │     1     │
│     │     │    │     2     │    │           │
└─────┴─────┘    └───────────┘    └───────────┘
```
1. Create 3 tabs
2. In tab 1: Create 2 vertical splits
3. In tab 2: Create 2 horizontal splits
4. In tab 3: Keep single pane
5. Switch between tabs and navigate splits
6. Use zoom to focus on different panes
7. Clean up everything

---

## Mastery Test

Can you do this without thinking?
```
Target layout (step 5):
┌───────────┬───────────┐
│           │     2     │
│     1     ├───────────┤
│           │  3 (you)  │
└───────────┴───────────┘
```
1. `⌘ T` → new tab
2. `⌘ D` → split right
3. `⌘ Option →` → move to right pane
4. `⌘ Shift D` → split down
5. `⌘ Option ↓` → move down
6. Run a command, then `⌘ ↑` to jump back
7. `⌘ Shift Enter` → zoom current pane
8. `⌘ A` then `⌘ C` → select and copy all
9. `⌘ Shift Enter` → unzoom
10. `⌘ 1` → jump to first tab
11. Clean up all tabs and splits

If you completed this smoothly, you've mastered the basics!
