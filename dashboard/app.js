document.getElementById('runBtn').addEventListener('click', async () => {
  const fileInput = document.getElementById('workflowFile');
  if (!fileInput.files.length) {
    alert('Please select a workflow YAML file.');
    return;
  }
  const file = fileInput.files[0];
  const formData = new FormData();
  formData.append('workflow', file);

  const outputEl = document.getElementById('output');
  outputEl.textContent = 'Uploading workflow...\n';

  const response = await fetch('/run', {
    method: 'POST',
    body: formData,
  });

  if (!response.ok) {
    outputEl.textContent += `Server error: ${response.status}\n`;
    return;
  }

  const reader = response.body.getReader();
  const decoder = new TextDecoder();
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    outputEl.textContent += decoder.decode(value);
    outputEl.scrollTop = outputEl.scrollHeight;
  }
});
