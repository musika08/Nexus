<p align="center">
  <h1 align="center"><b>N E X U S</b></h1>
  <p align="center"><b>Ultra-Lightweight Gaming Companion & HUD Quick Settings for Windows Handhelds</b></p>
</p>

<p align="center">
  <a href="https://github.com/musika08/Nexus/releases/latest"><img alt="Download" src="https://img.shields.io/github/v/release/musika08/Nexus?style=for-the-badge&label=download&labelColor=0b1324&color=818cf8"></a>
  <a href="https://github.com/musika08/Nexus/releases"><img alt="Downloads" src="https://img.shields.io/github/downloads/musika08/Nexus/total?style=for-the-badge&label=downloads&labelColor=0b1324&color=6366f1"></a>
  <img alt="Windows 11" src="https://img.shields.io/badge/Windows-11-0d1a33?style=for-the-badge&labelColor=0b1324&color=1e3a8a">
  <img alt="ROG Ally & Ally X" src="https://img.shields.io/badge/Hardware-ROG%20Ally%20%7C%20Ally%20X-red?style=for-the-badge&labelColor=0b1324">
  <a href="https://ko-fi.com/musika"><img alt="Support on Ko-fi" src="https://img.shields.io/badge/support-Ko--fi-818cf8?style=for-the-badge&logo=kofi&logoColor=white&labelColor=0b1324"></a>
</p>

<p align="center">
  <b>Instant response, zero bloat, pure gaming performance.</b><br>
  Nexus replaces heavy OEM suites with a native, ultra-responsive drop-down bar and heads-up overlay.<br>
  Direct hardware ACPI power control, closed-loop Auto-TDP, IMU motion gyro aiming, stick/trigger calibration, dual-color RGB rings, and real-time ETW telemetry.
</p>

<p align="center">
  <a href="#overview">Overview</a> &nbsp;·&nbsp;
  <a href="#core-capabilities">Capabilities</a> &nbsp;·&nbsp;
  <a href="#quick-start">Quick Start</a> &nbsp;·&nbsp;
  <a href="#hardware-controls">Hardware Controls</a> &nbsp;·&nbsp;
  <a href="#faq">FAQ</a> &nbsp;·&nbsp;
  <a href="#support">Support</a> &nbsp;·&nbsp;
  <a href="#license">License</a>
</p>

<br>

<table>
  <tr>
    <td width="25%" valign="top"><b>⚡ Instant Power & Fan Curves</b><br><sub>Direct WMI/ACPI TDP scaling (7W–30W), Closed-Loop Auto-TDP, and real-time dual fan curve controls.</sub></td>
    <td width="25%" valign="top"><b>🎯 Gyro Aim & Deadzones</b><br><sub>Bosch 6-axis IMU motion mouse aiming and MCU-level stick & hair-trigger anti-drift calibration.</sub></td>
    <td width="25%" valign="top"><b>📊 Real-Time ETW Telemetry</b><br><sub>Kernel-level frame pacing overlay without FPS drops, plus AMD Radeon RSR & Anti-Lag switches.</sub></td>
    <td width="25%" valign="top"><b>🌈 Dual-Ring Aura RGB</b><br><sub>Synchronized dual-color breathing, smooth gradient sweeps, customizable speeds, and stealth modes.</sub></td>
  </tr>
</table>

> [!NOTE]
> Designed and optimized specifically for the **ASUS ROG Ally (RC71L)** and **ROG Xbox Ally X (RC73XA)** on Windows 11. Built entirely in native Win32/WPF without heavy runtime runtimes or background daemon bloat.

---

## Overview

Heavy OEM software suites like Armoury Crate consume excessive background RAM, peg CPU threads, and delay your inputs. **Nexus** is engineered from the ground up to give you instant hardware command with razor-sharp latency:

- **Near-Zero Footprint:** Takes ~15–25 MB RAM when active; idles silently with 0% CPU consumption.
- **Direct Hardware Communication:** Talks straight to the ASUS ACPI BIOS driver (`ATKACPI`), MCU USB HID endpoints (`0x0b05/0x1abe`), and AMD display drivers without intermediary daemons.
- **Controller & Touch Native:** Fluid, 60 FPS spring animations, full D-Pad/gamepad navigation, touch tap support, and mouse gliding.
- **Seamless Command Center Integration:** One-tap takeover of the physical Command Center button, or toggle anywhere with `Ctrl + Shift + G`.

---

## Core Capabilities

```
 ┌────────────────────────────────────────────────────────────────────────┐
 │                              N E X U S                                 │
 ├──────────┬──────────────┬──────────┬──────────┬─────────────┬──────────┤
 │   HOME   │   SETTINGS   │  AUDIO   │ CAPTURE  │ PERFORMANCE │ DISPLAY  │
 └──────────┴──────────────┴──────────┴──────────┴─────────────┴──────────┘
```

### 1. ⚡ Power & Closed-Loop Auto-TDP
- **Power Modes:** Switch instantly between Silent (13W), Performance (17W), Turbo (25W/30W), Windows OS, and Manual slider profiles.
- **Closed-Loop Auto-TDP:** Continuously monitors framerate against target FPS (30, 40, 45, or 60 FPS) and dynamically adjusts APU power between 7W and 30W to maximize battery life while maintaining fluid gameplay.
- **Battery Care Mode:** Hardware-level charge limit toggle (80% / 100%) to prolong battery health during plugged-in sessions.

### 2. 🎯 Precision Sticks, Triggers & Gyro Aiming
- **Anti-Drift Stick Calibration:** Set inner deadzones (0%–20%) and outer bounds (80%–100%) directly inside the ROG Ally microcontroller.
- **Hair-Trigger Actuation:** Fine-tune left/right trigger actuation points for hair-trigger responsiveness in shooters.
- **6-Axis Gyro Aim Assist:** Reads the built-in Bosch IMU sensor at 100 Hz, applying exponential smoothing and deadband filtering to translate motion directly into high-precision mouse aiming (with ADS trigger activation).

### 3. 🌈 Dual-Zone Aura RGB Lighting
- **Synchronized Dual-Ring Breathing:** Two distinct colors blend seamlessly on the thumbstick rings simultaneously.
- **Animation Speed & Profiles:** Adjustable cycle durations (Slow, Normal, Fast) with Rainbow, Breathing, Color Cycle, Static, and Battery-Alert presets.
- **Stealth & Sleep Modes:** Independent brightness sliders and instant sleep sync.

### 4. 📊 Kernel-Level Performance HUD & AMD Driver Controls
- **Zero-Impact ETW Telemetry:** Uses Windows kernel Event Tracing (ETW Present events) to read FPS and frame times without injecting intrusive DLL hooks into game processes.
- **Sensor Telemetry:** Live CPU/GPU temperature, clock speeds, package wattage, and battery discharge rates via LibreHardwareMonitor.
- **Radeon Driver Quick Toggles:** Toggle **AMD Radeon Super Resolution (RSR)** and **Radeon Anti-Lag** on the fly without launching the AMD Adrenalin software.

---

## Quick Start

### Installation

1. Download the latest release from the [Releases page](https://github.com/musika08/Nexus/releases/latest).
2. Extract the archive into a folder of your choice.
3. Open PowerShell as Administrator and run:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
   ```
4. Nexus will install into `C:\Program Files\Nexus`, start immediately, and register a scheduled task to launch at user logon with highest privileges.

> [!TIP]
> **Keyboard Shortcut:** Press `Ctrl + Shift + G` at any time from within any game or application to summon or dismiss Nexus. On your ROG Ally, simply tap the dedicated **Command Center** physical button.

### Building from Source

Nexus requires no heavy external IDEs or SDK installations. It compiles directly using the in-box Microsoft .NET Framework C# compiler:

```powershell
# Compile release binary (bin\Nexus.exe)
powershell -NoProfile -ExecutionPolicy Bypass -File build.ps1

# Run full test suite (505 automated unit tests)
powershell -NoProfile -ExecutionPolicy Bypass -File build.ps1 -Tests
```

---

## Hardware Controls & Architecture

Nexus talks directly to hardware through strict abstraction seams:

| Subsystem | Seam / Protocol | Purpose |
|---|---|---|
| **Power & TDP** | `ATKACPI` / `\\.\ATKACPI` WMI | Direct APU SPL/sPPT/fPPT power clamping |
| **Cooling** | ASUS ACPI Method `0x00110024` / `0x00110027` | 8-point dual fan curve programming & RPM telemetry |
| **RGB & Sticks** | USB HID Feature Reports (`0x5A/0xD1`) | MCU-level RGB lighting, deadzones, and trigger thresholds |
| **Motion Gyro** | WinRT Sensor / Bosch `BOSC0200` | 100 Hz motion telemetry mapped to precision mouse input |
| **Display** | CCD (`SetDisplayConfig`) & AMD Registry | Refresh rate switching (60/120 Hz), RSR, and Anti-Lag |
| **Telemetry** | Windows ETW (`EventTrace`) | Non-intrusive present event capture & framerate pacing |

---

## FAQ

<details>
<summary><b>Can I switch back to ASUS Armoury Crate SE?</b></summary>
<br>
Yes! To restore Armoury Crate SE Command Center at any time, run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File uninstall.ps1
```
This safely stops Nexus, restores the original Armoury Crate service hooks, and cleans up scheduled tasks. Your custom deadzones and profiles are safely preserved.
</details>

<details>
<summary><b>Does Nexus interfere with anti-cheat in multiplayer games?</b></summary>
<br>
No. Nexus uses Windows kernel ETW (Event Tracing for Windows) to compute framerates and presents. It never injects foreign DLLs or hooks into game memory, making it 100% compliant with anti-cheat engines (Easy Anti-Cheat, BattlEye, Vanguard).
</details>

<details>
<summary><b>Where are my configuration files stored?</b></summary>
<br>
Nexus stores settings atomically in JSON format inside `C:\ProgramData\Nexus\` (with transparent fallback to `C:\ProgramData\Bar\` for backward compatibility).
</details>

---

## Support

If Nexus makes gaming on your handheld faster and better, consider supporting development:

<p>
  <a href="https://ko-fi.com/musika"><img alt="Support Musika on Ko-fi" src="https://img.shields.io/badge/Support%20Musika%20on%20Ko--fi-818cf8?style=for-the-badge&logo=kofi&logoColor=white"></a>
</p>

---

## License

Nexus is licensed under the [MIT License](LICENSE). 

Third-party dependencies and notices:
- **LibreHardwareMonitorLib**: Mozilla Public License 2.0 (telemetry sensors).
- **FFmpeg**: LGPL / GPL (screen capture).
- Complete third-party license texts are documented in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md).

*Unofficial software; not affiliated with, sponsored, or endorsed by ASUS, Microsoft, or AMD.*
