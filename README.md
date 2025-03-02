# 🛡 Safeguard: A Secure Bash Mode for Production Systems

**Safeguard** is a Bash script that activates a **safe mode** when working on production systems, preventing accidental deletions or modifications. It restricts destructive commands, modifies the shell prompt, and ensures safer command execution.

## 🚀 Features

- ✅ **Prevents accidental deletions**: Blocks recursive `rm -rf`, while allowing simple file deletion.
- ✅ **Restricts dangerous commands**: Disables `mv`, `chmod`, `chown`, `shutdown`, `reboot`, etc.
- ✅ **Read-only file editing**: Opens `vim` in read-only mode by default.
- ✅ **Custom safe mode prompt**: Shows a **🔒 [SAFE MODE]** indicator.
- ✅ **Auto-logout**: Exits session after 5 minutes of inactivity.
- ✅ **History Protection**: Stores history normally, except `rm *` commands.
- ✅ **Session Logging**: Logs all executed commands (except sensitive ones like passwords).
- ✅ **Easily Deactivatable**: Run `deactivate` to exit safe mode.

## 📥 Installation

### 1️⃣ Download and install safeguard  
```bash
curl -o /usr/local/bin/safeguard https://raw.githubusercontent.com/mohitanand001/safeguard/main/safeguard
chmod +x /usr/local/bin/safeguard
```

### 2️⃣ Ensure it is in your PATH  
```bash
export PATH=$PATH:/usr/local/bin
```

## 🛠 Usage

### 🔹 Activate Safe Mode
Simply run:
```bash
safeguard
```
This will open a **new shell with restricted permissions**.

### 🔹 Deactivate Safe Mode
Exit safe mode by typing:
```bash
deactivate
```
This will **close the child shell** and restore normal behavior.

## 🚦 Restricted Commands

| Command  | Behavior in Safe Mode |
|----------|-----------------------|
| `rm`     | Allowed, but `rm -rf` is blocked |
| `mv`     | **Blocked** |
| `chmod`  | **Blocked** |
| `chown`  | **Blocked** |
| `shutdown` | **Blocked** |
| `reboot` | **Blocked** |

## 🧪 Running Tests

**Automated tests** ensure Safe Mode works as expected.

### 1️⃣ Run tests locally  
```bash
chmod +x test_safeguard.sh
./test_safeguard.sh
```

### 2️⃣ GitHub Actions CI  
Tests automatically run on every **PR & push** using GitHub Actions.

## 🛠️ Contributing

1. **Fork the repo**
2. **Create a new branch**
3. **Make your changes**
4. **Run `./test_safeguard.sh` before submitting**
5. **Submit a pull request** 🎉  

## 📜 License

This project is **open-source** under the **MIT License**.
