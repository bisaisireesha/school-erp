# Calendar Screen Grid Redesign

Redesign the Calendar screen to feature a full-month grid view matching the Apple Calendar aesthetic shown in the mockups, but adapted for a light theme.

## Proposed Changes

### `lib/screens/calendar/calendar_screen.dart`

- **Layout Update**: Replace the existing custom calendar widget with a `GridView`-based 7-column layout.
- **Theme Adjustments**: 
  - Change the overall calendar background to white.
  - Implement grey grid lines dividing the days (matching standard calendar layouts).
- **Event Display (Pills)**:
  - Populate each calendar cell with the day number.
  - Inject mini "pill" shaped elements inside the cell to represent the events mapped to that day (using data from `_mockEvents` which represents "upcoming events").
  - The pills will be tiny, color-coded based on the event type (Exam, Festival, Holiday, Event).
- **Header**:
  - Add a prominent sticky header displaying the current Month and Year.
  - Render the days of the week (S, M, T, W, T, F, S) above the grid.

## User Review Required

- Is there a specific maximum number of event pills that should be displayed per day before we show a "+X more" indicator? (I will assume 2 or 3 for now due to space constraints in a cell).
- Are we removing the "selected day" detailed list view below the calendar entirely, or keeping it below the new grid? (I will assume we keep a list below the grid that shows the selected date's details).

## Verification Plan

- Run the app and navigate to the Calendar screen.
- Verify that the layout resembles the Apple Calendar grid on a white background with grey lines.
- Verify that events show up as colored pills on their respective dates.
