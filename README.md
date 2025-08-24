# bloggg

A new Flutter project.

## Getting Started

A blogging platform built with Flutter where users can create, edit, and read blogs in a simple, modern UI.
The app uses Provider for state management, Supabase as backend, and follows a clean architecture for scalability.

Features
1.Create & Edit Blogs – Add, update, and delete your own blog posts.
2.Read Blogs – Browse a feed of blog posts.
3.User Authentication – Sign up & log in securely.
4.Online/Offline Support – Works with internet connection checker.
5.Local Storage – Uses Hive/Isar for caching.
6.Modern UI – Material Design 3 with responsive layouts.

Customizations Beyond Tutorial:
This project was inspired by a YouTube tutorial, but I extended it with additional functionality and architectural improvements:
 1.Switched from Bloc (used in the tutorial) to Provider for state management.
 2. Added Edit & Delete Blog options (only available to the blog owner).
 3. Refactored code for better readability and maintainability.

Tech Stack
 1.Frontend: Flutter (Dart)
 2.State Management: Provider
 3.Backend: Supabase
 4.Database: Supabase Postgres + Hive/Isar (local)
 5.Authentication: Supabase Auth
 6.Other Packages:
    image_picker – Upload images
    uuid – Unique IDs
    intl – Date formatting
    internet_connection_checker_plus – Connection status

SCREENSHOTS:
![WhatsApp Image 2025-08-25![WhatsApp Image 2025-08-25 at 12 01 06 AM](https://github.com/user-attachments/assets/e4174cf2-f461-419a-943c-39adb9594b25)
 at 12 00 16 AM](https://github.com/user-attachments/assets/5c645096-9d8c-4ac6-859e-2f472a2fc44e)
![WhatsApp Image 2025-08-25 at 12 00 17 AM](https://github.com/user-attachments/assets/88fec316-513c-4ad1-b694-4f4458d33ba9)
![WhatsApp Image 2025-08-25 at 12 00 17 AM (1)](https://github.com/user-attachments/assets/cf27627e-c089-4e8a-b57d-9c151271c297)
![WhatsApp Image 2025-08-25 at 12 00 18 AM](https://github.com/user-attachments/assets/a44163ba-42aa-4a5d-8fb2-36a9b385f090)
