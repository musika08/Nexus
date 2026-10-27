# Third-party notices

Code from G-Helper (GPL-3.0, https://github.com/seerge/g-helper) will be included by later tasks.
Each included part will be listed here with its source file and licence.

## Ported from Overdrive / Traction (GPL-3.0, the owner's Decky plugins)

- `src/CommandCenterSwitch.cs`: Overdrive `helper/src/CommandCenterPlugin.cs` (commit 465bef4) and `py_modules/overdrive/cc_switch.py`.
- `src/ServiceControl.cs`: Overdrive/Traction `helper/src/ServiceHardware.cs` Stop/Start, which follow G-Helper `app/Helpers/ProcessHelper.cs` (StopDisableService/StartEnableService).
- `src/ArmouryRecord.cs`: reads the record format of Overdrive `py_modules/overdrive/armoury_record.py` (read only).
- `src/Device.cs`: Overdrive `helper/src/HelperMain.cs` IsAlly/ReadProductName.

## Taken from PresentMon (MIT, https://github.com/GameTechDev/PresentMon)

- `src/Perf/FrameCounter.cs`: the ETW provider GUIDs, event ids, keywords and the DXGI Present_Start field layout
  from `PresentData/ETW/Microsoft_Windows_DXGI.h` (layout from tag v1.6.0), `Microsoft_Windows_D3D9.h` and
  `Microsoft_Windows_DxgKrnl.h`; the session set-up and keyword patches from `PresentData/PresentMonTraceSession.cpp`;
  the frame rules (process id from the event header, DXGI_PRESENT_TEST skipped, DxgKrnl-only presents for other
  runtimes) from `PresentData/PresentMonTraceConsumer.cpp`. Re-written in C#; no PresentMon code is copied verbatim.

```
Copyright (C) 2017-2024 Intel Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
OR OTHER DEALINGS IN THE SOFTWARE.
```

## LibreHardwareMonitor (MPL-2.0, https://github.com/LibreHardwareMonitor/LibreHardwareMonitor)

- Version 0.9.6 (release LibreHardwareMonitor.zip). Game Bar ships `LibreHardwareMonitorLib.dll` and the libraries it
  needs from that release, unmodified, beside `Bar.exe`, and loads it at run time for CPU/GPU load, temperature and
  power readings (`src/Perf/Sensors.cs`). No LibreHardwareMonitor source code is included in Game Bar.
- Licence: Mozilla Public License 2.0, https://mozilla.org/MPL/2.0/. The source code of LibreHardwareMonitor is
  available from the project's repository above (tag v0.9.6).
- The bundled dependency DLLs come from the same release, unmodified, and keep their own licences. Their licence
  texts are in `third_party/licenses/` and ship beside `Bar.exe` as `licenses\` (build.ps1 and install.ps1 copy them):
  - HidSharp 2.6.4 (Copyright (c) 2010-2025 James F. Bellinger, http://software.seekye.com/hidsharp): Apache License
    2.0, `licenses\HidSharp-Apache-2.0.txt`.
  - Microsoft.Bcl.AsyncInterfaces, Microsoft.Bcl.HashCode and the System.* packages (Microsoft Corporation / .NET
    Foundation and Contributors): MIT, `licenses\dotnet-MIT.txt`.
  - BlackSharp.Core, DiskInfoToolkit and RAMSPDToolkit-NDD (Florian K., https://github.com/Blacktempel): MPL-2.0, as
    LibreHardwareMonitor; sources at https://github.com/Blacktempel/BlackSharp, /DiskInfoToolkit and /RAMSPDToolkit.
- Its driver, PawnIO (https://github.com/namazso/PawnIO.Setup, installer 2.2.0), is not shipped with Game Bar; the owner
  installs it separately.

## FFmpeg (GPL-3.0, https://ffmpeg.org)

- Version 9.0.2, "release essentials" Windows build by gyan.dev (https://www.gyan.dev/ffmpeg/builds/). Game Bar ships
  `ffmpeg.exe` unmodified beside `Bar.exe` and runs it as a separate program for recordings (Capture); Game Bar does
  not link to it.
- This build is licensed under the GNU General Public License version 3; the licence text ships beside it as
  `FFmpeg-LICENSE.txt`. FFmpeg's source code is available from https://ffmpeg.org/download.html, and the build's
  configuration and sources are listed on the gyan.dev builds page.
