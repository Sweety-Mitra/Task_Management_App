# Task Management App (Flutter)

## Overview
This is a Task Management mobile application built using Flutter. The app allows users to create, manage, and track tasks with dependencies in a clean and intuitive interface.

---

## Features

### Core Features
- Create, edit, and delete tasks (CRUD)
- Each task includes:
  - Title
  - Description
  - Due Date
  - Status (To-Do, In Progress, Done)
  - Blocked By (optional dependency on another task)

### Functionality
- Task dependency handling (blocked tasks appear greyed out until dependency is completed)
- Search tasks by title
- Filter tasks by status
- Draft persistence (unsaved input remains when navigating away)
- Simulated 2-second delay on create/update with loading indicator
- Prevents multiple submissions during loading
- Local data persistence using SharedPreferences

### UI/UX Highlights
- Clean and modern card-based layout
- Consistent input styling with rounded fields
- Status-based color indicators
- Highlighted search results
- Smooth and responsive interactions

---

## Stretch Goal Implemented
- Debounced search (300ms delay with optimized filtering)

---

## Tech Stack
- Flutter (Dart)
- Provider (State Management)
- SharedPreferences (Local Storage)

---

## How to Run

1. Clone the repository:
   git clone https://github.com/Sweety-Mitra/Task_Management_App.git

2. Navigate to the project folder:
   cd create_task_manager_app

3. Install dependencies:
   flutter pub get

4. Run the app:
   flutter run

---

## Track Chosen
Track B - Mobile Specialist

---

## AI Usage Report

### Helpful Prompts Used
- "Build a Flutter task management app with CRUD and Provider state management"
- "How to implement local storage in Flutter using SharedPreferences"
- "How to implement debounced search in Flutter"
- "How to persist form data when navigating back in Flutter"

These prompts helped accelerate development, especially for structuring the app and handling state efficiently.

---

### Example of AI Limitation / Fix

At one point, AI-generated code for updating UI state did not properly trigger widget rebuilds when search input changed. This caused the highlight feature to not update in real-time.

**Issue:**
- UI was not reacting to updated search text.

**Fix:**
- Replaced `Provider.of(context)` with `context.watch()` to ensure proper widget rebuilds.

This improved responsiveness and ensured correct UI updates.

---

## Key Technical Decision

I chose **Provider** for state management because it is lightweight, easy to scale, and well-suited for managing app-wide state like tasks, filters, and drafts without overcomplicating the architecture.
