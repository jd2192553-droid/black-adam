from flask import Flask, request, Response, jsonify
import subprocess
import os
import sys

app = Flask(__name__, static_folder='../dashboard', static_url_path='')

# Path to workflow engine script (same directory)
ENGINE_PATH = os.path.join(os.path.dirname(__file__), 'workflow_engine.py')

def run_workflow(target):
    # Execute the workflow engine using the same Python interpreter for compatibility
    proc = subprocess.Popen(
        [sys.executable, ENGINE_PATH, target], 
        stdout=subprocess.PIPE, 
        stderr=subprocess.STDOUT, 
        text=True
    )
    for line in proc.stdout:
        yield line
    proc.wait()

@app.route('/')
def index():
    return app.send_static_file('index.html')

@app.route('/run', methods=['POST'])
def run():
    target = None
    
    # Check if the request is multipart (file upload)
    if 'workflow' in request.files:
        workflow_file = request.files['workflow']
        workflow_yaml = workflow_file.read().decode('utf-8')
        
        # Parse target from the YAML content
        for line in workflow_yaml.splitlines():
            if line.strip().startswith("target:"):
                target = line.split(":", 1)[1].strip()
                break
        if not target:
            target = "uploaded_workflow.yaml"
            
    # Check if the request is JSON
    elif request.is_json:
        data = request.get_json()
        target = data.get('target')
        
    # Check if the request is standard form submission
    elif 'target' in request.form:
        target = request.form['target']

    if not target:
        return 'Missing target or workflow file', 400

    def generate():
        for out in run_workflow(target):
            yield out
            
    return Response(generate(), mimetype='text/plain')

if __name__ == '__main__':
    # Run on 0.0.0.0, port 8000
    app.run(host='0.0.0.0', port=8000, debug=True)
