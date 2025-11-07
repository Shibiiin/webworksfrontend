# webworksco

A new Flutter project.

## Getting Started

#For Running the application 

Lib -> main.dart
Structure  -> Clean Architecture 
UI's -> Lib -> Web Works Co -> Presentation-> Pages

#Features

**View Creators:** Fetches and displays a list of all creators in a responsive grid.

**View Details:** Click on any creator to navigate to a detailed profile view with smooth hero animations.

**Add Creator: ** Add new creators to the database via a dedicated form.

**Edit Creator:** Update the information for any existing creator.

**Delete Creator:** Remove creators from the database with a confirmation dialog.

**Live API Connection:** Fully integrated with a live Node.js backend deployed on Render.

**Responsive Design:** The UI adapts seamlessly from mobile to desktop screen sizes.

**Search & Filter:** Instantly search by name/designation and filter by status on the dashboard.

**Sort:** Sort the creator list by various criteria (Name, Followers, etc.).

**Animations:** Features custom animations for cards, page transitions, and text for an engaging user experience.

**Error Handling:** Gracefully handles image loading errors and provides user feedback for API actions.


Tech Stack

# Frontend
**Framework:** Flutter
**State Management:** Provider with ChangeNotifier
**API Client:** Dio
**Routing:** go_router


# Backend
**Framework:** Node.js with Express
**Database:** JSON file (`db.json`)
**ID Generation: ** UUID

# Deployment
**Frontend: ** Deployed on
**Github pages**
**Backend: ** Deployed on **Render**
