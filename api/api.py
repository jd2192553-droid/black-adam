from flask import Flask, request, Response
import yaml, subprocess, threading, queue, os, json

app = Flask(__name__)

# Path to workflow engine script (same directory)
ENGINE_PATH = os.path.join(os.path.dirname(__file__), 'workflow_engine.py')

def run_workflow(workflow_yaml):
    # Write workflow to a temp file for engine consumption
    temp_path = '/tmp/workflow.yaml'
    with open(temp_path, 'w') as f:
        f.write(workflow_yaml)
    # Execute the workflow engine
    proc = subprocess.Popen(['python3', ENGINE_PATH, temp_path], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    for line in proc.stdout:
        yield line
    proc.wait()

@app.route('/run', methods=['POST'])
def run():
    if 'workflow' not in request.files:
        return 'No workflow uploaded', 400
    workflow_file = request.files['workflow']
    workflow_yaml = workflow_file.read().decode('utf-8')

    def generate():
        for out in run_workflow(workflow_yaml):
            yield out
    return Response(generate(), mimetype='text/plain')

if __name__ == '__main__':
    # Run on 0.0.0.0 so Docker can expose it
    app.run(host='0.0.0.0', port=8000, debug=False)
