# UVM Testbench Architecture
## Instruction Scheduler Project

---

## 1. Overview

This document describes the **UVM-based verification architecture** used to verify the Instruction Scheduler RTL.

The testbench is designed to be:
- Modular and scalable
- Easy to understand and extend
- Suitable for open-source collaboration
- Aligned with industry-standard UVM practices

The UVM environment verifies correct instruction routing, backpressure handling, and protocol correctness.

---

## 2. Verification Strategy

The verification environment uses:
- **Transaction-level modeling**
- **Ready/valid protocol monitoring**
- **Scoreboard-based end-to-end checking**
- **Constrained-random and directed testing**

The scheduler is treated as a **black box**, verified entirely through its interfaces.

---

## 3. UVM Components

### 3.1 Transaction (`instr_xtn`)

The `instr_xtn` class represents a single instruction transaction exchanged between the host and the scheduler.

#### Fields
- `instr` : 32-bit instruction
- `opcode`: 3-bit opcode extracted from `instr[31:29]`

#### Responsibilities
- Encapsulate instruction data
- Provide a common data object for drivers, monitors, and scoreboard
- Enable constrained random generation of opcodes and payloads

---

### 3.2 Host Agent (Active)

The **host agent** models the instruction source driving the scheduler.

#### Components

- **Sequencer**
  - Generates `instr_xtn` transactions
  - Supports random and directed sequences

- **Driver**
  - Drives `in_valid` and `in_instr`
  - Waits for `in_ready` before completing a transfer
  - Models realistic host-side backpressure behavior

- **Monitor**
  - Observes accepted instructions (`in_valid && in_ready`)
  - Publishes transactions to the scoreboard via analysis ports

#### Responsibilities

- Generate instruction traffic
- Respect ready/valid protocol
- Provide reference transactions for end-to-end checking

---

### 3.3 Receiver Agents A–D (Active)

Each receiver agent corresponds to one output stream of the instruction scheduler.

#### Components

- **Monitor**
  - Observes instruction transfers (`out_valid && out_ready`)
  - Captures received instructions
  - Sends observed transactions to the scoreboard

- **Driver**
  - Drives `out_ready`
  - Models downstream backpressure
  - Enables stress testing of scheduler flow control

> Receiver drivers are essential for verifying correct backpressure propagation from output streams to the host.

---

## 4. Environment (`instr_env`)

The environment integrates all agents and provides a single point of configuration.

### Instantiated Components

- `host_agent`
- `recv_agent_a`
- `recv_agent_b`
- `recv_agent_c`
- `recv_agent_d`

### Responsibilities

- Instantiate and configure agents
- Connect analysis ports to the scoreboard
- Provide a scalable structure that can be extended to 8 streams (A–H)

---

## 5. Test (`instr_test`)

The test controls the simulation and defines the verification intent.

### Responsibilities

- Build the environment
- Start host sequences
- Control simulation lifetime using UVM objections

### Test Types

- Random opcode distribution tests
- Directed opcode routing tests
- Backpressure stress tests
- Reset behavior tests

Each test focuses on a specific aspect of scheduler functionality while reusing the same environment.

---

## 6. Top-Level Testbench (`tb_top`)

The top-level module connects the RTL and UVM world.

### Responsibilities

- Clock generation
- Reset generation
- Interface instantiation
- DUT instantiation
- Virtual interface binding using `uvm_config_db`
- Invocation of `run_test()`

---

## 7. Scalability and Extensibility

The testbench is intentionally structured to support:

- Additional output streams (E–H)
- FIFO-based schedulers
- Multi-issue dispatch
- Functional coverage
- Protocol assertions
- DPI based Scoreboard

---











