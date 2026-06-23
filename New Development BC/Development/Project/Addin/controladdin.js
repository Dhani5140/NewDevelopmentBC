let ganttInstance = null;

function LoadData(json) {
    const tasks = JSON.parse(json);

    renderTree(tasks);
    renderGantt(tasks);
}

function renderTree(tasks) {
    const container = document.getElementById("taskTree");
    container.innerHTML = "";

    tasks.forEach(t => {
        const row = document.createElement("div");
        row.className = "task-row level-" + (t.level || 0);
        row.innerText = t.name;
        container.appendChild(row);
    });
}

function renderGantt(tasks) {
    if (ganttInstance)
        document.getElementById("gantt").innerHTML = "";

    ganttInstance = new Gantt("#gantt", tasks, {
        view_mode: "Week"
    });
}

Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnControlReady', []);
