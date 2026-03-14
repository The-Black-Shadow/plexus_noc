# Plexus NOC

A **Network Operation Controller** (NOC) dashboard built with Flutter, following Clean Architecture principles with `flutter_bloc` for state management.

## Getting Started

```bash
flutter pub get
flutter run
```

## Architecture Overview

This project uses a **feature-first Clean Architecture** structure:

```
lib/
 ├ core/           # Shared utilities, theme, constants, networking
 ├ features/       # Feature modules (auth, device_monitoring, settings, …)
 │   └ feature/
 │       ├ data/           # DataSources, Models, Repository implementations
 │       ├ domain/         # Entities, Repository interfaces, UseCases
 │       └ presentation/   # Bloc/Cubit, Pages, Widgets
 └ injection_container.dart
```

---

## Isolate Strategy — Mock Device Simulation

### Problem

The mock device datasource simulates **100 network devices** with two high-frequency timers running on the main thread:

| Timer              | Interval   | Work                                                       |
| ------------------ | ---------- | ---------------------------------------------------------- |
| Telemetry tick     | 1 second   | Recalculates CPU & memory for every online device          |
| Status toggle      | 10 seconds | Randomly toggles 1–3 devices online/offline + fires alerts |

This creates **continuous computation every second** (100 Random calls, 100 map mutations, list copies) that competes with Flutter's UI rendering, causing frame drops and jank — especially on lower-end devices.

### Solution

All simulation logic is offloaded to a **background Dart isolate** via `Isolate.spawn`. The main-thread `MockDeviceDataSource` becomes a thin proxy.

```
┌─────────────────────────────────┐   SendPort    ┌────────────────────────────┐
│  MockDeviceDataSource           │◄──────────────│  _isolateEntryPoint()      │
│  (main thread — thin proxy)     │   JSON maps   │  (background isolate)      │
│                                 │               │                            │
│  ReceivePort → decode →         │               │  Owns:                     │
│   _deviceStreamController       │               │   • Random instance        │
│   _alertStreamController        │               │   • Timer.periodic (1s)    │
│                                 │               │   • Timer.periodic (10s)   │
│  Exposes unchanged interface:   │               │   • 100-device list        │
│   getRealtimeDevicesStream()    │               │   • All mutation logic     │
│   getRealtimeAlertsStream()     │               │                            │
└─────────────────────────────────┘               └────────────────────────────┘
```

**Data flow:**
1. The isolate generates / mutates device data and encodes it as `List<Map<String, dynamic>>`.
2. It sends messages via `SendPort` with a `type` field (`'devices'` or `'alert'`).
3. The main-thread proxy decodes JSON maps into `DeviceModel` / `AlertEntity` and pushes them to broadcast `StreamController`s.
4. Blocs and repositories consume the streams as before — **zero API changes**.

### Why This Is Good

| Benefit                      | Explanation                                                                                                    |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------- |
| **Eliminates UI jank**       | Timer callbacks and 100-device mutations no longer block the main thread's rendering pipeline.                  |
| **Scalable**                 | The device count can grow (500, 1000+) without degrading UI performance — compute stays off the main thread.    |
| **Zero breaking changes**    | `DeviceRemoteDataSource` interface is unchanged; repositories, use cases, and blocs are completely untouched.   |
| **Clean Architecture**       | The isolate is an implementation detail of the data layer — domain and presentation layers have no knowledge of it. |
| **Simple lifecycle**         | `dispose()` calls `Isolate.kill()` for immediate cleanup; no complex shutdown handshake needed.                  |
| **Production-ready pattern** | When replacing mocks with real WebSocket/API data, the same isolate pattern can parse heavy JSON payloads off the main thread. |

### Key File

- [`mock_device_datasource.dart`](lib/features/device_monitoring/data/datasources/mock_device_datasource.dart)
