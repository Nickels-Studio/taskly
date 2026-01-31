# Changelog

All notable changes to Taskly are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_No changes yet._

---

## [0.0.2] – 2026-01-31

### Added

- **Calendar tab** – New sidebar tab to view tasks by date. Month grid with navigation, task indicators on dates, and task list for the selected day (defaults to today).
- **Project-colored mesh background** – Project detail screens use a custom mesh background tinted with the project’s color (`ProjectMeshBackgroundView`).
- **Search tasks** – Toolbar search field filters tasks by title, description, or project name on Pending, Today, and Completed tabs. Clear button when search has text.
- **Keyboard shortcuts**
  - **⌘K** – Focus search field
  - **⌘N** – New task (open New Task modal)
  - **⌘⇧N** – New project (open New Project modal from any tab)

### Changed

- **Task detail panel layout** – Task detail panel now overlays on the right instead of resizing the main content. Same behavior on Pending, Today, Completed, Calendar, and project detail views.
- **New Project modal** – Lifted to ContentView so it can be opened globally (e.g. via ⌘⇧N) and still works from the Projects tab.

---

## [0.0.1] – 2026-01-25

Initial release.

### Added

- **Pending, Today, Completed tabs** – Tab-based task organization (replacing Inbox). Pending shows incomplete tasks, Today shows tasks due today, Completed shows completed or past-due tasks.
- **Projects** – Project list with create project, project-scoped task list, and project detail with task list. New Project modal with name, description, and color.
- **Task creation** – New Task modal with title, notes, subtasks, priority, due date, project selection, and flag.
- **Task detail panel** – Slide-in panel for task title, notes, subtasks (add/edit/delete), due date, priority, project, and delete.
- **Task cards** – TaskCard with completion toggle, title, description, due date, project badge, priority, and subtask summary.
- **Mesh background** – Custom mesh gradient background on main content.
- **Sidebar** – Navigation with Pending, Today, Projects, Completed and profile footer.
- **Empty states** – Empty state views for no tasks and no projects.
- **Daily progress footer** – Progress indicator on task list views.
- **SwiftData** – Local persistence for tasks, projects, subtasks, and tags. CloudKit removed in favor of local-only storage.
- **Design system** – ColorPalette, mesh backgrounds, glass-style cards, unified window style.
- Initial commit, entitlements, app icons, Sora font. Basic views: AddTaskBar, DailyProgressFooter, MeshBackgroundView, TaskCard, TaskDetailView, EmptyStateView, SidebarView. User profile in sidebar. Window style: hidden title bar, unified toolbar.

### Changed

- Refactored from Inbox to Pending view and updated task filtering.
- Task filtering logic in ContentView for tab-based visibility.
- Sidebar navigation and SFSymbols updates.
- TaskCard and TaskItemDetailView updated with subtask management (editing, deletion).
- Removed CloudKit integration; app is local-only.
- Removed deprecated Item model; using TaskItem and Project throughout.
- NewTaskModal enhanced with project selection and date-time picker.
- Dependency injection and ViewModelFactory refactored to avoid circular dependencies.

### Fixed

- Conflict resolution (last-write-wins) simplified in ConflictResolutionService.
- TaskService filtering for optional due dates handled in Swift where predicates were limited.

[Unreleased]: https://github.com/Nickels-Studio/taskly/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/Nickels-Studio/taskly/releases/tag/v0.0.2
[0.0.1]: https://github.com/Nickels-Studio/taskly/releases/tag/v0.0.1
