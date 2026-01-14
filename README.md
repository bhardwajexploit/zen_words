# 📱 QuoteVault — AI-Powered Quote App

QuoteVault is a modern, cloud-based quote discovery and collection app built using **Flutter** and **Supabase**.  
It allows users to explore quotes, save favorites, organize collections, and generate beautiful shareable quote cards.

This project was developed as part of a mobile engineering assignment to demonstrate **AI-assisted development, clean architecture, and full-stack mobile engineering**.

---

## ✨ Features

### 🔐 Authentication & Accounts
- Email & password sign-up
- Login & logout
- Password reset
- Session persistence (users stay logged in)
- User profile (email + name)

Powered by **Supabase Auth**

---

### 📚 Quote Discovery
- Home feed of quotes
- Pull-to-refresh
- Search by quote text
- Search by author
- Loading & empty states
- Quote of the Day logic (changes daily)

Quotes are loaded from **Supabase Database**.

---

### ❤️ Favorites & Collections
- Save quotes to favorites
- View all favorites
- Create custom collections
- Add/remove quotes from collections
- Cloud-synced per user

Supabase tables used:
- `user_favorites`
- `collections`
- `collection_quotes`

All data is protected using Supabase Row-Level Security (RLS).

---

### 🖼️ Quote Sharing
- Generate beautiful quote cards
- 3 different share card styles
- Share quote as an image via system share sheet
- Rendered using Flutter canvas snapshot (`RepaintBoundary`)

---

### 🎨 Personalization
- Light & Dark mode
- Pink themed design system
- User preferences stored locally using GetStorage

---

### ☁️ Cloud Sync
- Favorites & collections persist across devices
- Supabase Auth + Database keeps everything in sync

---

### 🧪 Quote of the Day
- Daily quote is deterministic (same for all users each day)
- Changes automatically every day using date-based logic

---

## ⚠️ Features Not Implemented

These features were documented but not completed due to time and platform constraints:

| Feature | Status |
|-------|--------|
| Browse by category UI | ZenQuotes API does not provide categories |
| Push notifications | Logic prepared but Android requires desugaring |
| Notification time selector | Storage + logic done, native scheduling incomplete |
| Save quote card to gallery | Removed due to deprecated plugins |
| Plain text share | Image share implemented instead |
| Font size slider | Not added |
| Multiple color themes | Light, Dark & Pink only |
| Settings sync to Supabase | Local only |
| Home screen widget | Not implemented |

All incomplete features are documented transparently for evaluation.

---

## 🧱 Architecture

The app follows a clean layered structure:

UI → Controller → Repository → Supabase
Project structure:

lib/
├── core/
│   ├── theme/
│   ├── constants/
│   └── storage/
│
├── data/
│   └── remote/        
│
├── model/
│
├── screens/
│   ├── auth/
│   ├── dashboard/
│   ├── collections/
│   ├── splash/
│   └── settings/
│
├── services/
│
└── notifications/


State management & navigation: **GetX**

---

## 🧬 AI-Driven Development

This project was built using AI tools extensively.

**AI tools used**
- ChatGPT
- Cursor
- Claude
- Supabase AI Docs
- Figma Make / Stitch

AI was used for:
- Flutter architecture
- Supabase RLS & queries
- UI design
- State management
- Debugging
- Share card rendering
- Notification logic
- Documentation

This allowed faster iteration, fewer bugs, and production-grade structure.

---

## 🎨 Design

UI was designed using **Stitch / Figma Make** and implemented in Flutter with:
- Glassmorphism
- Soft gradients
- Rounded cards
- Playful pink theme
- Custom typography

**Design Link:**  
https://stitch.withgoogle.com/projects/6978933305466600354

---

## 🗄️ Supabase Setup

Tables used:

### `quotes`
```sql
id, quote, author
user_favorites
id, user_id, quote, author, created_at

collections
id, user_id, name, created_at

collection_quotes
id, collection_id, quote, author

Enable Row Level Security:
user_id = auth.uid()

▶️ How to Run

Add your Supabase keys inside SupabaseService.init()

Run:
flutter pub get
flutter run

🎥 Loom Video
https://www.loom.com/share/7bef7b265e0c4b628bc6b5dd3f77eb33

The video will demonstrate:

Authentication

Browsing & search

Favorites & collections

Share card generation

Theme switching

AI-assisted workflow

