# Aegis - Automated Security Audit Dashboard

Aegis is a Windows-compatible web-based dashboard and API that simulates automated reconnaissance, security audits, and vulnerability analysis inside a sandboxed environment.

## File Structure

```text
project/
├── api/
│   ├── api.py                 # Flask server (routes, static serving)
│   ├── workflow_engine.py     # Mock audit logs and findings engine
│   └── requirements.txt       # Python dependencies
├── dashboard/
│   ├── index.html             # Main dashboard UI
│   ├── style.css              # Premium dark glassmorphic styling
│   └── app.js                 # Event handlers and rendering logic
├── docker/
│   ├── Dockerfile             # Docker container definition
│   └── entrypoint.sh          # Container startup script
├── workflows/
│   └── workflow.yaml          # Sample YAML configuration file
└── run.ps1                    # Local PowerShell runner script
```

## Getting Started (Local Run)

You can run Aegis locally on Windows without installing Docker. It will automatically create a virtual environment, install Flask, and open the dashboard in your default browser.

1. Open PowerShell.
2. Navigate to the project root directory.
3. Run the local runner script:
   ```powershell
   ./run.ps1
   ```
4. Access the web interface at [http://localhost:8000](http://localhost:8000).

## Running in Docker

Aegis can be containerized inside an isolated sandbox using the provided Docker configuration.

1. Build the Docker image:
   ```bash
   docker build -t aegis-dashboard -f docker/Dockerfile .
   ```
2. Run the container exposing port 8000:
   ```bash
   docker run -d -p 8000:8000 --name aegis-container aegis-dashboard
   ```
3. Open your browser and navigate to [http://localhost:8000](http://localhost:8000).
