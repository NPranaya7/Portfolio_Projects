***************************************************************************************************************************************************************************************
# 🧑‍💻 Git Workflow Guide

Here is a outline of standard Git workflow for feature development, including branch creation, staging, committing, pushing, and pull request processes.

---

## 🌱 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

---

## 🌿 2. Create and Switch to a New Branch

```bash
git checkout -b my-feature-branch
```

> Creates a new branch and switches to it.

Use meaningful branch names like:
- `feature/user-profile`
- `fix/login-bug`

---

## ✍️ 3. Make Changes in Your Editor

Check what has been modified:

```bash
git status
```

---

## ➕ 4. Stage Your Changes

```bash
git add .
```

- `.` adds all modified/created files.
- You can also add specific files: `git add filename.py`

---

## ✅ 5. Commit Your Changes

```bash
git commit -m "Add a meaningful commit message"
```

Examples:
- `"Fix navbar alignment on mobile"`
- `"Add input validation to login form"`

---

## 🚀 6. Push the Branch to GitHub

```bash
git push -u origin my-feature-branch
```

- The `-u` flag sets the upstream branch for easy future pushes.

---

## 🔁 7. Pull Latest Changes from Main (Before Merging)

```bash
git checkout main
git pull origin main
git checkout my-feature-branch
git merge main
```

> Keeps your branch updated and avoids merge conflicts.

---

## 🧪 8. Test Your Code

Run and verify that your changes work correctly.

---

## 🔁 9. Push Any New Changes

```bash
git add .
git commit -m "Update after testing"
git push
```

---

## 📦 10. Open a Pull Request on GitHub

- Go to GitHub
- Click **"Compare & pull request"**
- Add a title and description
- Assign reviewers if needed

---

## 🧼 11. Clean Up After Merge (Optional)

```bash
git checkout main
git pull origin main
git branch -d my-feature-branch               # Deletes local branch
git push origin --delete my-feature-branch    # Deletes remote branch
```

---

## ✅ Done!
You're now ready to follow a clean and professional Git workflow for all your projects 🚀
