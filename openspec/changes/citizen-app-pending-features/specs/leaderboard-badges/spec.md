## ADDED Requirements

### Requirement: Citizen can view the constituency leaderboard
A leaderboard screen SHALL display citizens ranked by `contribution_count`, fetched from the constituency leaderboard API (or derived from available data if the dedicated endpoint is not yet available).

#### Scenario: Leaderboard loads
- **WHEN** the citizen opens the leaderboard screen
- **THEN** citizens are listed in descending order of contribution count with rank number, name, avatar, and contribution count

#### Scenario: Current citizen highlighted
- **WHEN** the leaderboard is displayed
- **THEN** the logged-in citizen's entry is visually highlighted regardless of rank position

#### Scenario: Leaderboard feature flagged off
- **WHEN** the `leaderboard_enabled` app config flag is `false`
- **THEN** the leaderboard entry point is hidden from the UI

### Requirement: Citizens earn badges based on contribution milestones
The citizen's profile screen SHALL display earned badges computed from their `contribution_count`.

#### Scenario: Badge thresholds
- **WHEN** a citizen's `contribution_count` reaches a threshold (e.g., 1=Starter, 5=Active, 10=Champion, 25=Leader, 50=Legend)
- **THEN** the corresponding badge icon and label are shown on their profile

#### Scenario: No badges yet
- **WHEN** a citizen has `contribution_count = 0`
- **THEN** a "Submit your first contribution to earn a badge" message is shown instead of badges

### Requirement: Contribution count updates after each successful submission
After a successful concern, idea, or appreciation submission, the local `contribution_count` SHALL be incremented immediately to reflect the new badge state without requiring a profile refresh.

#### Scenario: Count incremented after submission
- **WHEN** a submission completes successfully
- **THEN** the local `contribution_count` in the user state is incremented by 1 and badges are recalculated
