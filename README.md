# RubyPyMill
Running Notebooks the Ruby Way — RubyPyMill and the Art of PoC Automation

## Background and Purpose
RubyPyMill is a lightweight runner and automation starter that allows Ruby
to control Papermill (a Python Notebook runner).

Its purpose is to bridge insights born from Proof of Concept (PoC) work
into real-world systems.

PoC is not the end — it is the beginning of organizational knowledge circulation.

By connecting Ruby’s expressive power with Python’s execution ecosystem,
RubyPyMill enables a development cycle where teams collaborate with data
in a Ruby-native way.

## Design Philosophy — Inspired by Ruby 4.0 @30
RubyPyMill follows Ruby 4.0’s philosophy of “multi-language collaboration”.

- Ruby is responsible for DSLs, orchestration, and control.
- Python is responsible for execution, computation, and visualization via notebooks.

By clearly separating these roles and bridging them automatically,
RubyPyMill enables reproducible notebook execution from the Ruby ecosystem.

“Ruby aims to connect people with people, and tools with tools.”  
— Yukihiro “Matz” Matsumoto

## Project Structure
| Directory | Description |
|----------|-------------|
| .vscode/ | VS Code settings (extensions, lint/format, tasks, debug) |
| .github/workflows/ | CI for Ruby and Python |
| bin/ | CLI entry point (`ruby_pymill`) |
| lib/ | RubyPyMill core library |
| py/ | Python-side environment (Papermill execution) |
| examples/ | Example notebooks, parameters, and outputs |

## Setup

### Ruby
```bash
bundle install
```

### Python
```bash
python -m venv .venv

# macOS / Linux
source .venv/bin/activate

# Windows (PowerShell)
.\.venv\Scripts\activate

pip install -r py/requirements.txt
python -m ipykernel install --user --name rpymill
```

## Basic Usage (CLI)
```bash
bundle exec ruby bin/ruby_pymill exec <input.ipynb> \
  --output <output.ipynb> \
  [--kernel rpymill] \
  [--params params.json] \
  [--cell_tags "parameters,setup,analysis"] \
  [--dry-run]
```

## Processing Overview
1. Load the notebook as JSON.
2. Filter cells by specified tags (the `parameters` cell is always preserved).
3. Generate a temporary filtered notebook.
4. Execute the filtered notebook once using Papermill.
5. Save the executed result as an output notebook.

RubyPyMill acts as a higher-level orchestration layer on top of Papermill,
ensuring logical structure, reproducibility, and Ruby-friendly control.

## Example: Ruby vs Python Radar Chart
The `examples/` directory includes a notebook that compares Ruby and Python strengths
using a radar chart.

This example demonstrates:
- Parameter injection via JSON
- Tag-based execution control
- Separation of preview and output generation
- Reproducible notebook execution via RubyPyMill

For a detailed explanation in Japanese, see `README.jp.md`.

## Programmatic Usage (Experimental)
RubyPyMill is primarily designed as a CLI tool.

Internally, it exposes a Ruby execution API (`RubyPyMill::API`),
which allows direct invocation from Ruby code.

This enables integration with batch jobs, schedulers,
or future web APIs.

The CLI is considered the stable interface.
The Ruby API is experimental and may change.

## License
MIT License  
Copyright (c) 2025 Hiroshi Inoue / OSS-Vision
