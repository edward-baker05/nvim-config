
# Add Cluedo Suggestion Mechanics

## Context

Cluedo's suggestion mechanic is missing. When a player enters a room, they should be allowed to name a suspect + weapon (the room is implicit), other players attempt to refute with a matching card, and the suggested suspect gets "dragged" into the room. The user wants:

- Suggestions allowed **only on the first time a player enters a given room** (including when dragged in by another player's suggestion).
- Weapons aren't placed on the board yet — all six weapons are legal for now, but leave a clean hook to filter later.
- No large structural rewrites.

Relevant current state:
- `TokenMovementScript.CanGuess` exists but is never checked.
- `RoomScript.EnterRoom(player, roomID)` teleports a player inside and unconditionally sets `CanGuess = true`.
- `Deck` deals hands and keeps a solution envelope; `Deck.GetCharacterHand(name)` returns a player's cards.
- `GameManagerScript.playerScripts` is private — needs an accessor to iterate refuters.
- `cards.json` has 6 characters, 6 weapons, 9 rooms. Room ID 11 (Stairwell) isn't a room card and should be ignored for suggestions.
- Existing `PlayTurn` room-detection is half-implemented: the "reached door" branch never actually fires (the nested equality is comparing a room ID to the PlayerID currently on that tile). This needs a small fix to make suggestions reachable.

## Design Overview

Turn flow for a player:

1. `PlayTurn` starts. If `CurrentRoomID > 0` (they start inside a room — either they walked in last turn or got dragged in), run `HandleRoomTurn(CurrentRoomID)` and end the turn.
2. Otherwise they move normally. When they step onto a door tile (`_tileValueUnderPlayer > 1`), set `CurrentRoomID = _tileValueUnderPlayer` — next loop iteration handles the room.
3. `HandleRoomTurn(roomID)`:
   - Teleport inside via existing `RoomScript.EnterRoom`.
   - If `roomID ∉ _visitedRooms` and it's a suggestible room: mark visited, set `CanGuess = true`, run `MakeSuggestion(roomID)`.
4. `MakeSuggestion(roomID)`:
   - Build legal characters (all 6) and legal weapons (all 6 for now, via `GetLegalWeapons(roomID)`).
   - AI: random pick + small delay.
   - Human: `UiManager.PromptSuggestion(...)`, wait on `_suggestionSubmitted` flag (mirrors existing `rollRequested` pattern).
   - Call `ResolveSuggestion`.
5. `ResolveSuggestion(character, weapon, roomID)`:
   - Drag the suggested character's token into this room via `target.DragIntoRoom(roomID)` (teleport + set `CurrentRoomID`; don't touch their `_visitedRooms`).
   - Iterate other players via `GameManagerScript.Instance.PlayersInTurnOrderStartingAfter(this)` (canonical turn order, skip suggester). For each:
     - Collect matching cards (character name / weapon name / room-card name).
     - AI refuter: auto-pick first match. Human refuter: `UiManager.PromptCardReveal(...)`.
     - First reveal wins; surface it to the suggester via `UiManager.ShowRevealedCard(...)` (or `Debug.Log` fallback).

## Files to Modify

### `matts-ui/Assets/Main Game/Scripts/TokenMovementScript.cs`
- Add `private HashSet<int> _visitedRooms = new();`
- Add `public int CurrentRoomID { get; private set; } = 0;` — authoritative room-state flag; survives "dragged in" since `_tileValueUnderPlayer` wouldn't.
- Add submission API:
  ```csharp
  private bool _suggestionSubmitted;
  private string _suggestedCharacter, _suggestedWeapon;
  public void SubmitSuggestion(string character, string weapon) { ... _suggestionSubmitted = true; }
  ```
- Rework the room-detection block in `PlayTurn` (lines 156-171): at the top of the while loop check `CurrentRoomID > 0` → run `HandleRoomTurn` and `break`. After movement + tile-pickup, if `_tileValueUnderPlayer > 1`, set `CurrentRoomID = _tileValueUnderPlayer`.
- Add coroutines: `HandleRoomTurn(int roomID)`, `MakeSuggestion(int roomID)`, `ResolveSuggestion(string character, string weapon, int roomID)`.
- Add `public void DragIntoRoom(int roomID)` — sets `CurrentRoomID`, calls `RoomScript.EnterRoom(this, roomID)`.
- Add `private List<string> GetLegalWeapons(int roomID)` — currently returns `Deck.AllWeaponNames`; marked TODO for future per-room filtering.

### `matts-ui/Assets/Main Game/Scripts/RoomScript.cs`
- Add `public static readonly Dictionary<int, string> RoomIdToName` mapping IDs 2-10 to their card names (`"Study"`, `"Hall"`, `"Lounge"`, `"Library"`, `"Dining Room"`, `"Billiard Room"`, `"Conservatory"`, `"Ballroom"`, `"Kitchen"`). Stairwell (11) intentionally absent → non-suggestible.
- Remove `player.CanGuess = true;` (line 78) — that flag is now owned by `TokenMovementScript`.

### `matts-ui/Assets/Main Game/Scripts/GameManagerScript.cs`
- Lift the hardcoded `characterOrder` string array (currently local to `MainLoop`, lines 99-106) to a `private static readonly string[] CharacterOrder` field so both `MainLoop` and refutation can share it.
- Expose helpers:
  ```csharp
  public TokenMovementScript GetPlayerByCharacterName(string name) =>
      playerScripts.FirstOrDefault(p => p.CharacterName == name);

  public IEnumerable<TokenMovementScript> PlayersInTurnOrderStartingAfter(TokenMovementScript suggester) {
      // Walk CharacterOrder starting from the slot after suggester, wrap once,
      // skip the suggester. Used by ResolveSuggestion to iterate refuters.
  }
  ```

### `matts-ui/Assets/Main Game/Scripts/DeckScript.cs`
- Add `public static IReadOnlyList<string> AllWeaponNames { get; private set; }`, populated in `InitializeAndDeal` before `MakeEnvelope` removes one weapon. Same symmetric additions for `AllCharacterNames` and `AllRoomNames` are cheap and make the suggestion/refutation lookups self-contained.

### `matts-ui/Assets/Main Game/Scripts/UiManager.cs`
- Add prefab hooks (designer wires in Inspector):
  - `public GameObject suggestionPanelPrefab;` — expected children: two `TMP_Dropdown`s (`CharacterDropdown`, `WeaponDropdown`) and a `Button` (`SubmitButton`).
  - `public GameObject cardRevealPrefab;` — a simple modal with a `TextMeshProUGUI` label and a dismiss `Button`.
- Add `PromptSuggestion(TokenMovementScript, string roomName, List<string> characters, List<string> weapons)` — instantiates panel, populates dropdowns, hooks Submit → `player.SubmitSuggestion(...)` and destroys panel. If `suggestionPanelPrefab` is null, log a warning and auto-submit a random suggestion so the flow keeps running for testing.
- Add `PromptCardReveal(TokenMovementScript refuter, List<Card> matches, Action<Card> onPicked)` — reuses the existing hand-display pattern (instantiate cards from `cardPrefabs`, click to pick). AI path doesn't use this.
- Add `ShowRevealedCard(Card card, TokenMovementScript toPlayer)` — instantiates `cardRevealPrefab` for the suggester; falls back to `Debug.Log` if prefab null.

## Legal-Weapons Hook

`TokenMovementScript.GetLegalWeapons(int roomID)` is the single choke point. Current body:
```csharp
// TODO: once weapons are physical objects on the board, restrict
// to weapons currently in roomID (or apply other legality rules).
return new List<string>(Deck.AllWeaponNames);
```

## Critical Files
- `matts-ui/Assets/Main Game/Scripts/TokenMovementScript.cs` — primary logic
- `matts-ui/Assets/Main Game/Scripts/RoomScript.cs` — room name map, drop `CanGuess` side-effect
- `matts-ui/Assets/Main Game/Scripts/GameManagerScript.cs` — expose player list
- `matts-ui/Assets/Main Game/Scripts/DeckScript.cs` — expose `AllWeaponNames` etc.
- `matts-ui/Assets/Main Game/Scripts/UiManager.cs` — suggestion + reveal prompts

## Verification

1. Start a game with at least one human and one AI.
2. Walk the human token onto a room's door tile. Expect: token teleports inside; suggestion UI appears (or debug-log fallback auto-submits). After submit, the suggested character's token teleports into the room, then refuters are iterated and the first match is revealed.
3. Move out and re-enter the same room on a later turn → no suggestion offered.
4. As an AI, suggest a human character → human token teleports. On the human's next turn, if they had never visited that room, a suggestion is offered; if they had, it's skipped.
5. Step onto a Stairwell (roomID 11) → teleport happens, no suggestion (not a card room).
6. Watch `Debug.Log` output for refutation rotation order and the revealed card.
