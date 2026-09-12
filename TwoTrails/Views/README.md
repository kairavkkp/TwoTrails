# Two Trails - Fitness Tracking App

A modern, feature-rich fitness tracking application built with SwiftUI for iOS. Track workouts, monitor progress, and achieve your fitness goals with a beautiful, user-friendly interface.

## 📱 Features

### ✨ User Profiles & Multi-User Support
- **Dual User System**: Separate profiles for "Him" and "Her"
- **Onboarding Experience**: Beautiful first-launch user selection
- **Easy Switching**: Switch between users anytime via Settings
- **Data Preservation**: Each user's data is kept separate and persistent
- **Personalized Themes**: UI colors adapt to the current user

### 🏋️ Exercise Library (100+ Exercises)
- **Comprehensive Database**: 100+ pre-loaded exercises
- **Categories**:
  - Traditional Strength Training (50+ exercises)
  - CrossFit & Functional Fitness (40+ exercises)
  - Yoga & Mobility (6+ exercises)
- **Rich Metadata**:
  - Primary & secondary muscle groups
  - Equipment types (8 categories)
  - Exercise categories (Compound, Isolation, Cardio, Flexibility)
  - Optional instructions
- **Smart Search & Filtering**:
  - Search by exercise name, muscle group, or equipment
  - Filter by 13 muscle group options
  - Filter by 8 equipment types
  - Color-coded muscle tags

### 📅 Flexible Workout Scheduling
- **Custom Weekly Schedule**: Assign workouts (A, B, C) to any day of the week
- **No Fixed Days**: Unlike traditional 3-day splits, you control when you workout
- **Visual Week Grid**: See your entire week at a glance
- **Easy Editing**: Tap-to-assign interface for scheduling workouts
- **Walk Days**: Days without workouts are automatically walk-only days
- **Per-User Schedules**: Each user has their own indepe    ndent schedule

### 📋 Workout Planning & Customization
- **Three Workout Variants** (A, B, C) per user
- **Full Customization**:
  - Edit exercise names and set/rep schemes
  - Add new exercises from the library
  - Reorder exercises with drag-and-drop
  - Delete unwanted exercises
- **Exercise Picker**:
  - Beautiful, searchable exercise browser
  - Equipment icons and muscle tags
  - Filter by muscle group or equipment
  - One-tap exercise selection
- **Custom Plans**: Create and save personalized workout plans
- **Reset Option**: Restore default workouts anytime

### 📊 Progress Tracking & Analytics
- **Today View**: Track daily workouts and walks
  - Quick-log walk minutes (20, 30, 40, 60 min options)
  - Check off exercises as you complete them
  - See completion progress in real-time
  
- **Weekly Stats**:
  - Days with walks (completion rate)
  - Days with gym sessions (completion rate)
  - Total walk minutes
  - Gym workout completion tracking
  
- **Monthly Overview**:
  - Active days count
  - Overall adherence rate percentage
  - Total walk minutes & average per day
  - Total gym sessions completed
  - Total exercises completed
  
- **Streak Tracking**:
  - Current active streak
  - Longest streak (last 90 days)
  - Motivational streak display

### 📈 Beautiful Progress Dashboard
- **Visual Stats**: Progress bars and percentage indicators
- **Color-Coded**: User-specific color themes
- **Pull to Refresh**: Update stats on demand
- **Mini Stat Cards**: Quick overview of key metrics
- **Intuitive Layout**: Easy-to-read dashboard design

### 🎨 Modern Design
- **Custom Theme**: Carefully crafted color palette
  - Paper (#EDEAE1), Card (#F8F6F0), Ink (#2A2820)
  - User-specific accent colors (Him: Blue, Her: Purple)
- **Serif Headlines**: Beautiful typography
- **Smooth Animations**: Polished UI interactions
- **Consistent Design Language**: Cohesive across all screens

### 💾 Data Management
- **Local Storage**: All data saved on-device using UserDefaults
- **Persistent State**: App remembers your selections
- **Workout History**: 14-day history view
- **Legacy Compatibility**: Smooth migration from old data format

### ☁️ Cloud-Ready Architecture
- **Prepared for Sync**: Complete cloud sync infrastructure ready
- **Example Implementations**: Firebase and REST API templates included
- **Protocol-Based**: Easy to swap sync providers
- **Export Functions**: Analytics and workout data can be exported
- **Future-Proof**: Add authentication and sync when needed

## 📂 Project Structure

```
TwoTrails/
├── App/
│   ├── TwoTrailsApp.swift          # App entry point
│   └── ContentView.swift            # Main tab bar container
│
├── Views/
│   ├── TodayView.swift             # Daily workout tracking
│   ├── ProgressView.swift          # Analytics dashboard
│   ├── HistoryView.swift           # 14-day workout history
│   ├── PlanView.swift              # Workout plan management
│   ├── SettingsView.swift          # User settings & switching
│   ├── PersonCard.swift            # Workout card component
│   ├── UserSelectionView.swift    # User selection/onboarding
│   ├── EditWorkoutView.swift      # Workout editor
│   ├── ScheduleEditorView.swift   # Weekly schedule editor
│   └── ExercisePickerView.swift   # Exercise library browser
│
├── Models/
│   ├── Person.swift               # User enum (Him/Her)
│   ├── UserProfile.swift          # User profile model
│   ├── ExerciseLibrary.swift     # Exercise database
│   ├── EnhancedModels.swift      # Set-level tracking models
│   ├── Plan.swift                 # Workout plans & schedule
│   └── DailyLog.swift            # Daily workout log
│
├── Stores/
│   ├── UserManager.swift          # User profile management
│   ├── TrackerStore.swift         # Workout log persistence
│   ├── PlanStore.swift            # Custom workout plans
│   ├── ScheduleStore.swift        # Flexible scheduling
│   └── AnalyticsStore.swift       # Progress calculations
│
├── Persistence/
│   └── LogPersisting.swift        # UserDefaults persistence
│
├── Theme/
│   └── Theme.swift                # Colors & typography
│
└── Documentation/
    └── CloudSyncGuide.swift       # Cloud sync examples
```

## 🎯 How to Use

### First Launch
1. App opens to user selection screen
2. Choose "Him" or "Her"
3. Your selection is saved automatically

### Daily Workflow
1. **Today Tab**: Log your daily workout
   - Select walk duration (20, 30, 40, or 60 min)
   - Check off exercises as you complete them
   - See real-time progress

2. **Progress Tab**: View your stats
   - Check weekly completion rates
   - Monitor monthly adherence
   - Track your streaks

3. **History Tab**: Review past 14 days
   - See which days you walked
   - See which days you completed gym workouts

4. **Plan Tab**: Customize your workouts
   - View your workout schedule
   - Edit weekly schedule (assign A, B, C to days)
   - Customize exercises in each workout
   - Add exercises from 100+ library

5. **Settings Tab**: Manage your profile
   - Switch between users
   - View app version

### Scheduling Workouts
1. Go to Plan tab
2. Tap "Edit Weekly Schedule"
3. For each day:
   - Tap the circles (○) to assign workout A, B, or C
   - Tap the checkmark (✓) for walk-only days
4. Tap "Save"

### Customizing Workouts
1. Go to Plan tab
2. Tap "Edit" on any workout (A, B, or C)
3. Options:
   - **Add Exercise**: Tap + → Search/filter → Select exercise
   - **Edit Exercise**: Tap pencil icon → Modify name/sets
   - **Reorder**: Tap "Edit" → Drag exercises
   - **Delete**: Swipe left or tap "Edit" → Tap red minus
4. Tap "Done" to save

### Switching Users
1. Go to Settings tab
2. Tap "Switch User"
3. Select the other user
4. All data is preserved for both users

## 🛠️ Technical Details

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 6.0+

### Frameworks Used
- **SwiftUI**: Modern declarative UI
- **Combine**: Reactive data flow
- **Foundation**: Core functionality
- **UserDefaults**: Local data persistence

### Data Models

**Core Models:**
```swift
enum Person: String, Codable, CaseIterable, Identifiable, Hashable
struct UserProfile: Codable
struct ExerciseTemplate: Identifiable, Codable, Hashable
struct WorkoutVariant: Codable
struct DailyLog: Codable, Equatable
struct WeeklySchedule: Codable
```

**Analytics Models:**
```swift
struct WeeklyStats: Codable
struct MonthlyStats: Codable
struct StreakData: Codable
struct AnalyticsExport: Codable
```

**Enhanced Models (Future):**
```swift
struct ExerciseSet: Identifiable, Codable, Hashable
struct PlannedExercise: Identifiable, Codable, Hashable
struct EnhancedWorkoutVariant: Identifiable, Codable
```

### State Management
- **@StateObject**: Store singletons (TrackerStore, UserManager, etc.)
- **@EnvironmentObject**: Dependency injection across views
- **@Published**: Reactive data updates
- **UserDefaults**: Simple key-value persistence

### Performance
- **Efficient Storage**: UserDefaults for lightweight data
- **Lazy Loading**: Views load data only when needed
- **Computed Properties**: Stats calculated on-demand
- **Codable**: Fast JSON encoding/decoding

## 🚀 Future Enhancements

### Ready to Implement
The following features have foundational code already built:

1. **Set-Level Tracking**
   - Track weight and reps for each set
   - Volume calculations (weight × reps)
   - Set-by-set completion tracking
   - Rest timer between sets
   - *Models: EnhancedModels.swift*

2. **Cloud Sync**
   - Firebase/Firestore integration
   - Custom REST API sync
   - User authentication
   - Conflict resolution
   - *Guide: CloudSyncGuide.swift*

3. **Advanced Analytics**
   - Volume progression over time
   - Personal records tracking
   - Exercise-specific stats
   - Body weight tracking
   - Photo progress tracking

4. **Workout Timer**
   - Rest period timer
   - Workout duration tracking
   - Audio cues
   - Apple Watch integration

5. **Social Features**
   - Share workouts with partner
   - Workout challenges
   - Progress comparisons

### Potential Additions
- Export data as CSV/PDF
- Custom exercise creation
- Workout notes and photos
- Calendar integration
- HealthKit integration
- Apple Watch companion app
- Widgets for iOS home screen
- Dark mode support
- Localization (multiple languages)

## 📝 Exercise Library Details

### Traditional Strength (50+ exercises)
- **Chest**: Bench press variations, flyes, push-ups
- **Back**: Deadlifts, rows, pull-ups, lat pulldowns
- **Shoulders**: Press variations, raises, face pulls
- **Legs**: Squats, lunges, leg press, leg extensions
- **Arms**: Curls, extensions, dips
- **Core**: Planks, ab wheel, dead bugs

### CrossFit & Functional (40+ exercises)
- **Olympic Lifts**: Clean & jerk, snatch, power clean
- **Kettlebell**: Swings, snatches, Turkish get-ups, goblet squats
- **Gymnastics**: Handstand push-ups, muscle-ups, toes-to-bar, L-sits
- **Cardio**: Burpees, box jumps, rowing, assault bike, jump rope
- **Functional**: Thrusters, wall balls, devil press, man makers
- **Carries**: Farmer's carry, overhead carry, sled push/pull
- **Conditioning**: Battle ropes, tire flips, slam balls

### Yoga & Mobility (6+ exercises)
- Downward dog, pigeon pose, cat-cow stretch
- Foam rolling, child's pose, hip flexor stretch

## 🎨 Design Philosophy

### Color System
- **Paper Background**: Warm off-white (#EDEAE1)
- **Card Surface**: Lighter warm white (#F8F6F0)
- **Ink Text**: Deep charcoal (#2A2820)
- **Soft Ink**: Muted brown (#6B685D)
- **Line Separator**: Light tan (#D8D3C5)
- **Him Accent**: Steel blue (#35566B)
- **Her Accent**: Plum purple (#7C4468)

### Typography
- **Headlines**: Serif font for elegance
- **Body**: San Francisco (system default)
- **Hierarchy**: Clear size/weight distinction

### Layout Principles
- **18pt Padding**: Consistent screen padding
- **10-12pt Corner Radius**: Soft, modern edges
- **Cards**: Elevated surfaces with subtle borders
- **Spacing**: Generous whitespace for clarity

## 📖 Code Examples

### Adding a New Exercise to the Library
```swift
// In ExerciseLibrary.swift
ExerciseTemplate(
    name: "Your Exercise",
    primaryMuscle: .chest,
    secondaryMuscles: [.triceps, .shoulders],
    equipment: .dumbbell,
    category: .compound,
    instructions: "Optional instruction text"
)
```

### Accessing Current User
```swift
@EnvironmentObject var userManager: UserManager

var currentPerson: Person? {
    userManager.currentUser?.person
}
```

### Logging a Workout
```swift
@EnvironmentObject var store: TrackerStore

// Log walk
store.setWalkMinutes(30, date: Date(), person: .him)

// Toggle exercise
store.toggleExercise("exercise_id", date: Date(), person: .him)
```

### Customizing a Workout Plan
```swift
@EnvironmentObject var planStore: PlanStore

// Get current plan
let plan = planStore.getPlan(for: .him)

// Update a variant
planStore.updateVariant(modifiedVariant, key: "A", for: .him)

// Reset to default
planStore.resetToDefault(for: .him)
```

### Scheduling Workouts
```swift
@EnvironmentObject var scheduleStore: ScheduleStore

// Assign workout A to Tuesday (weekday 3)
scheduleStore.assignWorkout("A", to: 3, for: .him)

// Get today's workout
let todayWorkout = scheduleStore.getAssignedWorkout(
    for: Date(), 
    person: .him
)
```

## 🔒 Data Privacy

- **Local Storage Only**: All data stored on device
- **No Network Calls**: Currently 100% offline
- **No Analytics Tracking**: Your data stays private
- **No Third-Party SDKs**: Pure Apple frameworks
- **Export Control**: You control your data

## 🤝 Contributing

This is a personal project, but suggestions are welcome!

## 📄 License

© 2026 Two Trails. All rights reserved.

## 👨‍💻 Development

### Built With
- Swift 6.0
- SwiftUI
- Xcode 15
- iOS 17 SDK

### Architecture
- MVVM pattern
- Protocol-oriented design
- Dependency injection via environment objects
- Codable for persistence
- ObservableObject for state management

## 📞 Support

For issues or questions, please check the code documentation or reach out to the development team.

---

**Version**: 1.0.0  
**Last Updated**: September 12, 2026  
**Platform**: iOS 17.0+

---

## ✅ Feature Checklist

- [x] User profile system
- [x] Multi-user support with data separation
- [x] 100+ exercise library with metadata
- [x] Exercise search and filtering
- [x] Flexible workout scheduling
- [x] Custom workout plans
- [x] Daily workout tracking
- [x] Walk minute logging
- [x] Exercise completion tracking
- [x] Weekly statistics
- [x] Monthly analytics
- [x] Streak tracking
- [x] 14-day history view
- [x] User switching
- [x] Data persistence
- [x] Onboarding experience
- [x] Beautiful UI/UX
- [x] Cloud-ready architecture
- [ ] Set-level tracking (models ready)
- [ ] Cloud synchronization
- [ ] Advanced analytics
- [ ] Workout timer
- [ ] Social features

---

**Built with ❤️ for fitness enthusiasts**
