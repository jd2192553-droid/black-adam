// Aegis Dashboard App Logic

// Tab Switching
const tabButtons = document.querySelectorAll('.tab-btn');
const tabContents = document.querySelectorAll('.tab-content');

tabButtons.forEach(btn => {
    btn.addEventListener('click', () => {
        tabButtons.forEach(b => b.classList.remove('active'));
        tabContents.forEach(c => c.classList.remove('active'));
        
        btn.classList.add('active');
        document.getElementById(btn.dataset.tab).classList.add('active');
    });
});

// Update File Input Name
const fileInput = document.getElementById('workflowFile');
const fileNameText = document.getElementById('fileNameText');

fileInput.addEventListener('change', () => {
    if (fileInput.files.length) {
        fileNameText.textContent = fileInput.files[0].name;
    } else {
        fileNameText.textContent = "No file chosen";
    }
});

// Run Security Audit Scan
const runBtn = document.getElementById('runBtn');
const targetInput = document.getElementById('targetInput');
const outputEl = document.getElementById('output');
const metricsCard = document.getElementById('metricsCard');

runBtn.addEventListener('click', async () => {
    let bodyData;
    let headers = {};
    const isFileUpload = fileInput.files.length > 0;

    if (isFileUpload) {
        const file = fileInput.files[0];
        bodyData = new FormData();
        bodyData.append('workflow', file);
    } else {
        const target = targetInput.value.trim();
        if (!target) {
            alert('Please specify a target or upload a workflow YAML.');
            return;
        }
        bodyData = JSON.stringify({ target: target });
        headers['Content-Type'] = 'application/json';
    }

    // Reset UI State
    runBtn.disabled = true;
    runBtn.textContent = 'Auditing Target...';
    outputEl.textContent = '[*] Launching execution sandbox...\n';
    metricsCard.classList.add('hidden');
    
    // Reset Tables and Lists
    resetReports();

    try {
        const response = await fetch('/run', {
            method: 'POST',
            headers: headers,
            body: bodyData,
        });

        if (!response.ok) {
            outputEl.textContent += `[-] Server error: ${response.status} (${response.statusText})\n`;
            runBtn.disabled = false;
            runBtn.textContent = 'Start Security Audit';
            return;
        }

        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';
        let structuredReport = null;

        while (true) {
            const { done, value } = await reader.read();
            if (done) break;

            const textChunk = decoder.decode(value, { stream: true });
            buffer += textChunk;
            
            // Check if there is a structured JSON payload in the buffer
            // We search for lines starting with "REPORT_JSON:"
            const lines = buffer.split('\n');
            buffer = lines.pop(); // Keep the last incomplete line in buffer

            for (const line of lines) {
                if (line.startsWith('REPORT_JSON:')) {
                    const jsonStr = line.replace('REPORT_JSON:', '').trim();
                    try {
                        structuredReport = JSON.parse(jsonStr);
                    } catch (e) {
                        console.error('Failed to parse report JSON', e);
                    }
                } else {
                    outputEl.textContent += line + '\n';
                }
            }
            outputEl.scrollTop = outputEl.scrollHeight;
        }

        // Parse any remaining buffer
        if (buffer) {
            if (buffer.startsWith('REPORT_JSON:')) {
                const jsonStr = buffer.replace('REPORT_JSON:', '').trim();
                try {
                    structuredReport = JSON.parse(jsonStr);
                } catch (e) {
                    console.error('Failed to parse report JSON', e);
                }
            } else {
                outputEl.textContent += buffer;
            }
        }

        // Render structured results if parsed successfully
        if (structuredReport) {
            renderResults(structuredReport);
        } else {
            outputEl.textContent += '\n[-] Could not parse structured report from engine output.';
        }

    } catch (err) {
        outputEl.textContent += `\n[-] Network error: ${err.message}\n`;
    } finally {
        runBtn.disabled = false;
        runBtn.textContent = 'Start Security Audit';
    }
});

function resetReports() {
    // Reset Ports Table
    const portsTableBody = document.querySelector('#portsTable tbody');
    portsTableBody.innerHTML = `<tr><td colspan="5" class="table-empty">No scan data available. Start an audit.</td></tr>`;

    // Reset Findings List
    const findingsList = document.getElementById('findingsList');
    findingsList.innerHTML = `<div class="table-empty">No scan data available. Start an audit.</div>`;
}

function renderResults(report) {
    // 1. Populate Metrics Card
    metricsCard.classList.remove('hidden');
    
    const critVal = report.summary.critical || 0;
    const highVal = report.summary.high || 0;
    const medVal = report.summary.medium || 0;
    const lowVal = report.summary.low || 0;
    const totalIssues = critVal + highVal + medVal + lowVal;

    document.getElementById('valCritical').textContent = critVal;
    document.getElementById('valHigh').textContent = highVal;
    document.getElementById('valMedium').textContent = medVal;
    document.getElementById('valLow').textContent = lowVal;
    document.getElementById('chartTotal').textContent = totalIssues;

    // Donut Chart updates
    // Total circumference of circle (r=80) is 2 * Math.PI * 80 ≈ 502.4
    const totalCircumference = 502.4;
    
    const highSeg = document.getElementById('chartHigh');
    const medSeg = document.getElementById('chartMedium');
    const lowSeg = document.getElementById('chartLow');

    if (totalIssues > 0) {
        const highShare = highVal / totalIssues;
        const medShare = medVal / totalIssues;
        const lowShare = lowVal / totalIssues;

        const highLength = highShare * totalCircumference;
        const medLength = medShare * totalCircumference;
        const lowLength = lowShare * totalCircumference;

        // Set dash array: "segmentLength restOfCircumference"
        highSeg.style.strokeDasharray = `${highLength} ${totalCircumference}`;
        
        medSeg.style.strokeDasharray = `${medLength} ${totalCircumference}`;
        medSeg.style.strokeDashoffset = -highLength;

        lowSeg.style.strokeDasharray = `${lowLength} ${totalCircumference}`;
        lowSeg.style.strokeDashoffset = -(highLength + medLength);
    } else {
        highSeg.style.strokeDasharray = `0 ${totalCircumference}`;
        medSeg.style.strokeDasharray = `0 ${totalCircumference}`;
        lowSeg.style.strokeDasharray = `0 ${totalCircumference}`;
    }

    // 2. Populate Services & Ports Table
    const portsTableBody = document.querySelector('#portsTable tbody');
    if (report.ports && report.ports.length > 0) {
        portsTableBody.innerHTML = '';
        report.ports.forEach(p => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td style="font-weight: 600; color: #a5b4fc;">${p.port}</td>
                <td>TCP</td>
                <td><span style="background: rgba(255,255,255,0.05); padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem;">${p.service}</span></td>
                <td style="font-family: var(--font-mono); font-size: 0.8rem; color: #38bdf8;">${p.version}</td>
                <td><span class="badge-role" style="background: rgba(16, 185, 129, 0.15); color: #34d399;">${p.status}</span></td>
            `;
            portsTableBody.appendChild(tr);
        });
    } else {
        portsTableBody.innerHTML = `<tr><td colspan="5" class="table-empty">No active open ports discovered.</td></tr>`;
    }

    // 3. Populate Findings & Remediation Card List
    const findingsList = document.getElementById('findingsList');
    if (report.findings && report.findings.length > 0) {
        findingsList.innerHTML = '';
        report.findings.forEach(f => {
            const card = document.createElement('div');
            card.className = `finding-card ${f.severity.toLowerCase()}`;
            card.innerHTML = `
                <div class="finding-header">
                    <div class="finding-title-group">
                        <h4>${f.title}</h4>
                        <span>ID: ${f.id}</span>
                    </div>
                    <span class="badge-severity ${f.severity.toLowerCase()}">${f.severity}</span>
                </div>
                <p class="finding-desc">${f.description}</p>
                <div class="finding-remediation">
                    <strong>🛡️ Recommended Remediation:</strong>
                    <span>${f.remediation}</span>
                </div>
            `;
            findingsList.appendChild(card);
        });
    } else {
        findingsList.innerHTML = `<div class="table-empty">🎉 No security issues detected. Target is secure.</div>`;
    }
}
