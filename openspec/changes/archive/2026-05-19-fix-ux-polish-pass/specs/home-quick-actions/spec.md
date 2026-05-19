## MODIFIED Requirements

### Requirement: Quick action tile descriptions are fully visible
Each quick action tile SHALL render its title and subtitle without truncation or clipping at all supported screen widths (>=320dp). The subtitle SHALL allow up to 2 lines and the tile height SHALL grow to fit content.

#### Scenario: Long subtitle on narrow screen
- **WHEN** the home screen renders on a 320dp-wide device with the "Suggest Improvement" tile
- **THEN** the full label "Suggest Improvement" (or its Malayalam equivalent) SHALL be visible without ellipsis or horizontal clipping

#### Scenario: All four subtitles visible
- **WHEN** the quick actions grid is shown
- **THEN** the subtitles for Issue, Idea, Suggest, and Appreciate tiles SHALL each be fully readable (no ellipsis)
