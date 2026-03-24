![ ](ReadMe/ic_dementiaChecker.png)</br>
![ ](ReadMe/DementiaChecker_mockup.png)</br>
# Dementia Checker</br>
### Deep learning-based dementia diagnosis application using intelligence test, sleep, and lifestyle data<br>
ⓒ 2024 Changjin Ha. All Rights Reserved.<br><br>

## 🚀 Tech Stack

### Client (iOS & iPadOS)
- **SwiftUI:** Declarative UI with full iOS 18 Sidebar & iPadOS multi-column support
- **HealthKit:** Extract Apple Watch life-log (activity & sleep) data securely
- **Dependency Management:** Pure SPM (Swift Package Manager) - *Zero CocoaPods architecture*
- **Speech Framework:** `SFSpeechRecognizer` & `AVAudioEngine` for elderly-friendly verbal MMSE assessments (On-device STT)

### Backend (BaaS)
- **Firebase (Auth, Firestore, Storage):** Fully integrated via SPM for user data, diary sync, and digital inheritance

### AI (On-Device CoreML Multi-Modal)
- **CoreML:** 4 On-device models (MMSE, LifeLog, Sleep, Universal)
- **Multi-Modal Inference:** Combine cognitive questionnaire data with physical sensor data for composite assessment

### External API
- **Naver Maps API:** NMaps-based hospital locator for dementia care facilities

## 🏗️ Architecture

```mermaid
graph TD
    %% Data Sources
    subgraph DataSources [📊 Data Sources]
        Survey[MMSE Questionnaire]
        Watch[Apple Watch / HealthKit]
    end

    %% AI Pipeline (Multi-Modal)
    subgraph CoreMLPipeline [🧠 Multi-Modal AI Pipeline]
        ModelMMSE[CoreML: MMSE]
        ModelLife[CoreML: LifeLog]
        ModelSleep[CoreML: Sleep]
        ModelUni[CoreML: Universal Composite]

        Survey --> ModelMMSE
        Watch -->|Activity Data| ModelLife
        Watch -->|Sleep Data| ModelSleep

        ModelMMSE --> ModelUni
        ModelLife --> ModelUni
        ModelSleep --> ModelUni
    end

    %% Client App
    subgraph Client [📱 iOS & iPadOS App]
        UI[SwiftUI / iOS 18 Sidebar]
        Features[Diary, Prevention Puzzles, Inheritance]
        State[State Management]

        ModelUni -->|Composite Assessment| State
        UI <--> State
        Features <--> State
    end

    %% Backend & External
    subgraph Backend [☁️ Firebase & APIs]
        DB[(Firestore)]
        Storage[(Firebase Storage)]
        Auth[Firebase Auth]
        Map[Naver Maps API]
    end

    %% Connections
    State <--> Auth
    State <--> DB
    State <--> Storage
    State --> Map
```

## 🧱 If I were to rebuild it in 2026

| Layer | Original | 2026 Pick | Reason |
|---|---|---|---|
| Concurrency | Completion handlers + DispatchGroup | Swift Concurrency(async/await + actors) | Eliminates callback pyramids; HealthKit has async wrappers |
| CoreML | New instance per call | `lazy var` cached models | Prevents disk re-load on every assessment |
| Speech | SFSpeechRecognizer (network) | SFSpeechRecognizer + `requiresOnDeviceRecognition = true` | HIPAA/GDPR alignment |
| Crypto | CryptoSwift@main | CryptoKit | First-party, hardware-accelerated |
| Firebase | 10.27.0 | 12.x | Current major, App Check aligned |
| JSON | SwiftJSON | Codable | Remove dep, standard Swift |
| MMSE questions | Giant switch statements | JSON asset + Codable structs | Localizble, editable without recompile |
| HealthKit data | God-class with 25 @Published | Split `DailyHealthSummary` + `HistoricalHealthData` | Reduced re-render thrashing |

## ✨ Core Features

<details>
<summary>Show Contents</summary>

#### Home<br>
> Check your latest inspection results, health data at a glance.<br>

![ ](ReadMe/home.png)<br>

#### Hospital Map<br>
> Check the status of nearby dementia hospitals and staff.<br>

![ ](ReadMe/hospitalMap_1.png)<br>
![ ](ReadMe/hospitalMap_2.png)<br>

> And you also can navigate, call, or get so much more information on web.<br>

![ ](ReadMe/hospitalMap_3.png)<br>
![ ](ReadMe/hospitalMap_4.png)<br>
![ ](ReadMe/hospitalMap_5.png)<br>

#### Inspection<br>
> Use your iPhone or iPad to proceed with the MMSE test as it was in reality. <br>

![ ](ReadMe/inspection_1.png)<br>
![ ](ReadMe/inspection_2.png)<br>
![ ](ReadMe/inspection_3.png)<br>
![ ](ReadMe/inspection_4.png)<br>
![ ](ReadMe/inspection_5.png)<br>
![ ](ReadMe/inspection_6.png)<br>
![ ](ReadMe/inspection_7.png)<br>

> As a result of the MMSE test, the test is completed in a blink of an eye using sleep patterns, life log data, and deep learning.<br>

![ ](ReadMe/inspection_8.png)<br>

> Check the test results at a glance and share them.<br>

![ ](ReadMe/inspection_9.png)<br>
![ ](ReadMe/inspection_10.png)<br>
![ ](ReadMe/inspection_11.png)<br>

#### History<br>
> Get your all inspection histories<br>

![ ](ReadMe/history_1.PNG)<br>
![ ](ReadMe/history_2.PNG)<br>

#### Diary<br>
> Once a day, record your day and look back.<br>

![ ](ReadMe/diary_1.png)<br>
![ ](ReadMe/diary_2.png)<br>

#### Improvements Process<br>
> Do you suspect dementia? Proceed with the dementia-improving process! <br>

![ ](ReadMe/improvements_1.png)<br>
![ ](ReadMe/improvements_2.png)<br>
![ ](ReadMe/improvements_3.png)<br>

#### Guardians<br>
> Register a guardian and share your current status.<br>

![ ](ReadMe/guardians.png)<br>

#### Heritage manager<br>
> Register a heritage manager to remove or inherit any data left on the server since your death.<br>

![ ](ReadMe/heritageManager.png)<br> 

#### and so much more.<br>
> There are more to come, including account management, tips for preventing dementia, and more.<br>

![ ](ReadMe/more.png)<br>

#### Compatibility<br>
> Dementia Checker is compatible with these devices.<br>
### iPhone<br>

> iPhone 15 Pro Max </br>
 iPhone 15 Pro </br>
 iPhone 15 Plus </br>
 iPhone 15 </br>
 iPhone 14 Pro Max </br>
 iPhone 14 Pro </br>
 iPhone 14 Plus </br>
 iPhone 14 </br>
 iPhone 13 Pro Max </br>
 iPhone 13 Pro </br>
 iPhone 13 </br>
 iPhone 13 mini </br>
 iPhone 12 Pro Max </br>
 iPhone 12 Pro </br>
 iPhone 12 </br>
 iPhone 12 mini </br>
 iPhone 11 Pro Max </br>
 iPhone 11 Pro </br>
 iPhone 11 </br>
 iPhone Xs Max </br>
 iPhone Xs </br>
 iPhone X<sub>R</sub> </br>
 iPhone SE (3rd-Generation) </br>
 iPhone SE (2nd-Generation) </br>

 #### iPad<br>

> iPad Pro 12.9 (6th-Generation) </br>
 iPad Pro 11 (4th-Generation) </br>
 iPad Pro 12.9 (5th-Generation) </br>
 iPad Pro 11 (3rd-Generation) </br>
 iPad Pro 12.9 (4th-Generation) </br>
 iPad Pro 11 (2nd-Generation) </br>
 iPad Pro 12.9 (3rd-Generation) </br>
 iPad Pro 11 (1st-Generation) </br>
 iPad Pro 12.9 (2nd-Generation) </br>
 iPad Pro 10.5 </br>
 iPad Air (5th-Generation) </br>
 iPad Air (4th-Generation) </br>
 iPad Air (3rd-Generation) </br>
 iPad mini (6th-Generation) </br>
 iPad mini (5th-Generation) </br>
 iPad (10th-Generation) </br>
 iPad (9th-Generation) </br>

 * Required iOS/iPadOS 17.0 or up. </br>
 * 1GB or higher storage required for install application.

</details>
