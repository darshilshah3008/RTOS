# Custom RTOS (Semaphore-Based) on ARM Cortex-M4

This project implements a lightweight real-time operating system (RTOS) for the ARM Cortex-M4 platform.  
It supports task scheduling, preemption, and task synchronization using **semaphores**, enabling deterministic multitasking without relying on any external RTOS frameworks.

---

## ✅ Features

- Cooperative + preemptive multitasking
- Supports **up to six concurrent tasks**
- Context switching on ARM Cortex-M4
- **SysTick timer–driven scheduling + preemption**
- Binary + counting semaphore support
- wait() / post() inter-task synchronization
- `sleep()` for timed blocking
- Idle task support
- Deterministic task execution

> System concepts align with kernel operations such as scheduling, dispatching, blocking, ready/queued states, and semaphore wake-up queues.

---

## 🧠 Kernel Capabilities

### Task Management
- `createTask(pFn, priority)`
- `destroyTask(pFn)`
- Supports **6 active tasks**
- Task states:
  - **Running**
  - **Ready**
  - **Blocked**
  - **Delayed**

A task control block (TCB) stores task metadata including priority, stack pointer, and status.

### Task Control Functions
- `yield()` – voluntarily give CPU time
- `sleep(time_ms)` – move task to delayed state
- `wait(semaphore)` – block if resource unavailable
- `post(semaphore)` – release semaphore

---

## ⏱ SysTick + Preemption

The RTOS uses the **ARM Cortex-M4 SysTick timer** as its primary time base:

- SysTick triggers periodically (e.g., 1ms)
- Kernel updates sleeping task timers
- Pending semaphore releases wake blocked tasks
- Preemption is performed cooperatively or via SysTick + PendSV

> SysTick drives task timing and triggers context switching when needed. PendSV is used to complete context save/restore.

This provides predictable and deterministic timing behavior.

---

## 🔐 Semaphore Support

- Supports **binary + counting semaphores**
- `wait()` will:
  - Immediately continue if `count > 0`
  - Block the calling task if `count == 0`
- `post()` will:
  - Increment count
  - Release a waiting task if present

This mechanism is used for:
- Producer/consumer patterns
- Critical section protection
- Event signaling

---

## 📐 System Architecture

Application Tasks (up to 6)
│
▼
RTOS Kernel
│
┌──────────────────────┐
│Scheduler (SysTick) │
│Dispatcher (PendSV) │
│Semaphores │
│Sleep Timer │
└──────────────────────┘
│
Hardware Abstraction
│
ARM Cortex-M4


---

## ⚙️ Example Behavior

- Multiple concurrent tasks execute
- Tasks voluntarily yield or are preempted
- Semaphores control shared access
- `sleep()` delays execution predictably
- Tasks wake automatically when delay expires
- Idle task runs when others are blocked

Example applications:
- Multi-rate LED blinking
- Button press handling + debouncing
- Producer–consumer message queue
- Event-driven signaling
