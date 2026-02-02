# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update 'tasks/lessons.md' with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests -> then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management
1. **Plan First**: Write plan to 'tasks/todo.md' with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review to 'tasks/todo.md'
6. **Capture Lessons**: Update 'tasks/lessons.md' after corrections

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Project Overview

**Movie Knowledge App** - A gamified iOS quiz application for learning movie trivia across 12 themed categories including Classic Cinema, Sci-Fi Spectacles, Animated Adventures, and more. Built with SwiftUI and SwiftData, featuring XP progression, streaks, badges, and a linear unlock system.

## Build & Development Commands

### Building the Project

**Xcode (Recommended):**
```bash
cmd + B              # Build
cmd + R              # Build and Run on simulator
cmd + shift + K      # Clean build folder
cmd + shift + Enter  # Open SwiftUI Preview
```

**Command Line:**
```bash
# Build Debug
xcodebuild -project "Movie-Knowledge-App.xcodeproj" \
  -scheme "Movie-Knowledge-App" \
  -configuration Debug \
  build

# Build Release
xcodebuild -project "Movie-Knowledge-App.xcodeproj" \
  -scheme "Movie-Knowledge-App" \
  -configuration Release \
  build

# Run on Simulator
xcodebuild -project "Movie-Knowledge-App.xcodeproj" \
  -scheme "Movie-Knowledge-App" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  build
```

### Testing

**Note:** No test target currently configured. To add tests, create a new Unit Testing Bundle target in Xcode.

### Requirements
- Xcode 26.2+
- iOS 17.0+ (SwiftUI + SwiftData)
- No external dependencies (Apple frameworks only)

## Architecture Overview

### High-Level Pattern

**MVVM with Service Layer:**
- **Models**: SwiftData persistence layer (7 data models)
- **ViewModels**: `@Observable` classes for reactive state (AppState, QuizViewModel)
- **Views**: SwiftUI declarative UI
- **Services**: Business logic isolation (Progress, XP, Badges, Streaks)

### Data Model Hierarchy

```
UserProfile (root aggregate)
├── CategoryProgress[]      # Completion tracking per category
├── Badge[]                 # Earned achievements
└── DailyLessonRecord[]     # Streak history

CategoryModel
└── SubCategory[]
    └── Challenge[]         # Quiz questions
```

**7 SwiftData Models:**
1. `UserProfile` - User stats, XP, level, streaks, accuracy
2. `CategoryModel` - 12 movie categories with color themes
3. `SubCategory` - Lessons within categories
4. `Challenge` - Individual quiz questions
5. `CategoryProgress` - Per-category completion state
6. `Badge` - Achievement definitions and tracking
7. `DailyLessonRecord` - Daily participation history

### Application Flow

```
1. App Launch (Movie_Knowledge_AppApp.swift)
   └─→ Initialize ModelContainer with 7 models
   └─→ DataSeeder populates initial data if empty
       (12 categories, 150+ questions)

2. MainTabView
   └─→ Initialize AppState after ModelContext ready
   └─→ Lazy-load services (Progress, XP, Badge, Streak)
   └─→ Present 3-tab interface (Home, Learn, Profile)

3. Quiz Flow
   CategoriesView → SubCategoryListView → QuizView → ResultsView
   └─→ Linear progression: complete previous to unlock next
   └─→ XP awards, progress updates, badge checks

4. State Management
   └─→ AppState (@Observable) injected via @Environment
   └─→ Reactive UI updates without Combine/Publishers
```

## Key Architectural Patterns

### State Management

**AppState (Singleton @Observable):**
- Central app state manager injected via `@Environment`
- Manages: selected tab, active category/subcategory, quiz state
- Holds service references: `progressService`, `xpService`, `streakService`, `badgeService`
- Services initialized lazily after ModelContext becomes available

**Important:** This app uses Swift's native `@Observable` macro, **not** Combine/Publisher patterns.

### Navigation

**Tab-Based:**
- Home (stats overview, daily lesson CTA)
- Learn (category tile grid → subcategories → quiz)
- Profile (user stats, badges)

**Quiz Navigation:**
Uses `NavigationStack` with environment-based state passing. AppState tracks `activeCategory` and `activeSubCategory` for navigation coordination.

### Linear Progression System

- **Unlocking**: Subcategories unlock sequentially (must complete previous)
- **XP System**: Easy: 10 XP, Medium: 15 XP, Hard: 20 XP
- **Leveling**: Level = XP ÷ 100 (integer division)
- **Streaks**: Daily participation tracking with longest streak records
- **Badges**: Awarded for category completion, XP milestones, accuracy, streaks

## Code Organization

### Directory Structure

```
Movie-Knowledge-App/
├── Models/
│   ├── ViewModels/        # AppState.swift, QuizViewModel.swift
│   ├── SwiftData/         # Persistent data models
│   └── Enums/             # AppTab, Difficulty, QuestionType
├── Views/
│   ├── Home/              # Home tab with stats
│   ├── Categories/        # Tile grid (recently updated from card cycler)
│   ├── Quiz/              # Quiz interaction
│   │   └── QuestionViews/ # FillBlankView, TrueFalseView, MultipleChoiceView
│   ├── Profile/           # User profile display
│   └── Shared/            # Reusable components, animations
├── Services/              # ProgressService, XPService, StreakService, BadgeService
├── Utilities/             # HapticManager, DesignSystem constants
└── Assets.xcassets/
    ├── outline/           # Heroicon outline assets (default state)
    └── solid/             # Heroicon solid assets (selected state)
```

### Naming Conventions

- **Types**: PascalCase (`CategoryModel`, `AppState`)
- **Properties/Methods**: camelCase (`selectedTab`, `calculateProgress`)
- **Section Markers**: `// MARK: - Description`
- **Private View Helpers**: `private var headerSection: some View`
- **Dependency Injection**: `@Environment` for AppState and modelContext

### SwiftData Usage

**Accessing Context:**
```swift
@Environment(\.modelContext) private var context
```

**Passing to Services:**
```swift
let progressService = ProgressService(context: context)
```

**Model Relationships:**
```swift
// One-to-many with cascade delete
@Relationship(deleteRule: .cascade) var subCategories: [SubCategory]

// One-to-many without delete rule
@Relationship var badges: [Badge]
```

**Auto-Saving:** All writes to SwiftData models automatically persist.

## Design System

See [STYLEGUIDE.md](STYLEGUIDE.md) for comprehensive visual specifications.

**Quick Reference:**
- **Background**: `Color(red: 0.98, green: 0.97, blue: 0.95)` (warm off-white)
- **Cards**: White, 24pt corner radius, 40pt padding
- **Typography**: 42pt Bold titles, 18pt Regular body, system font
- **Shadows**: 8% black @ 20pt blur, 10pt Y offset
- **Animations**: Spring (response: 0.4s, dampingFraction: 0.8)
- **Haptics**: `HapticManager.shared.medium()` on success actions

**Color Theming:**
Each of 12 categories has unique pastel accent colors stored as `(colorRed, colorGreen, colorBlue)` in `CategoryModel`.

## Icon System

**Recent Migration (Jan 2026):** SF Symbols → Heroicons

- **Outline icons** (default): `Assets.xcassets/outline/heroicon-*-outline.imageset`
- **Solid icons** (selected): `Assets.xcassets/solid/heroicon-*-solid.imageset`

**Mapping Logic:** [CategoryTileView.swift:25-58](Movie-Knowledge-App/Views/Categories/CategoryTileView.swift#L25-L58)

Converts SF Symbol names to Heroicon asset names:
```swift
"film.stack" → "heroicon-film-outline" / "heroicon-film-solid"
"sparkles" → "heroicon-sparkles-outline" / "heroicon-sparkles-solid"
```

## Quiz Question Types

**Three Formats:**

1. **MultipleChoiceView**: Question + 4 options (1 correct, 3 distractors)
2. **TrueFalseView**: Statement + True/False buttons
3. **FillBlankView**: Question + text field input

**All Questions Include:**
- Difficulty enum: `.easy`, `.medium`, `.hard`
- XP rewards: 10, 15, 20 respectively
- Explanation text shown post-answer
- Haptic feedback on interaction

**Question Storage:**
```swift
Challenge(
    questionText: String,
    questionType: QuestionType,
    correctAnswer: String,
    wrongAnswers: [String]?,     // nil for True/False
    explanation: String?,
    difficulty: Difficulty
)
```

## Extension Points

### Adding New Categories

1. Update `DataSeeder.swift`:
   ```swift
   let newCategory = CategoryModel(
       title: "Horror Classics",
       subtitle: "Spine-tingling tales",
       tag: "SCARY",
       iconName: "moon.stars",
       colorRed: 0.7, colorGreen: 0.6, colorBlue: 0.8,
       displayOrder: 12
   )
   ```

2. Create subcategories with challenges
3. Add to seeding logic in `seedDataIfNeeded()`

### Adding New Badge Types

Define requirements in [BadgeService.swift](Movie-Knowledge-App/Services/BadgeService.swift):
```swift
Badge(
    title: "New Achievement",
    descriptionText: "Requirement description",
    iconName: "trophy",
    requirement: 100,  // Threshold
    badgeType: .xpMilestone,
    categoryId: nil
)
```

### Adding Question Types

1. Create new view in `Views/Quiz/QuestionViews/`
2. Extend `QuestionType` enum
3. Update `QuizView` switch statement for rendering

### Customizing Themes

Update `Utilities/Constants/DesignSystem.swift` for global design tokens.

## Important Context

### Current State (Jan 2026)

- **Content**: 3 fully-populated categories (Classic Cinema, Sci-Fi, Animated Adventures)
- **Placeholders**: 9 categories with "Coming Soon" content
- **UI**: Tile-based grid view (recently redesigned from card cycler)
- **Testing**: No unit test target configured (future enhancement)

### Recent Updates

**Categories View Redesign:**
- Migrated from single-card swipe interface (`CategoryCyclerView` with drag gestures)
- Now: Scrollable 2-column grid with `CategoryTileView` components
- Icons dynamically switch between outline/solid states on selection
- Spring animations and haptic feedback on tap

### Known Limitations

- No VoiceOver/accessibility optimization yet
- No reduced motion mode support
- No offline mode (all data stored locally via SwiftData)
- No user authentication (single local profile)

## Additional Resources

- **Visual Design**: [STYLEGUIDE.md](STYLEGUIDE.md) - Typography, colors, spacing, animations
- **Bundle ID**: `bensimpson-digital.Movie-Knowledge-App`
- **Deployment Target**: iOS 26.2
- **Platform**: Universal (iPhone + iPad)
