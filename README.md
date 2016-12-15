# Hyghlight

Hy builtin keywords generator for highlight.js and may be other highlighting libraries.

## Installation

Install virtual environment and requirements using these commands:

```bash
virtualenv .env --python=python3
. .env/bin/activate
pip install -r requirements.txt
```

## Usage

Generate actual hy.js for highlight.js project:

```bash
hy hyghlight.hy highlight.js > ~/projects/highlight.js/src/languages/hy.js
```

## License

License: MIT (Expat) - as in Hy itself.
