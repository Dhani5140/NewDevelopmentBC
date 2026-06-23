function LoadData(json) {

    if (!json) return;

    const tasks = JSON.parse(json);

    // Render container
    document.body.innerHTML = `
        <div id="ganttChartContainer"
             style="width:100%; height:100%;"></div>
    `;

    // Init jsGantt
    var g = new JSGantt.GanttChart(
        document.getElementById('ganttChartContainer'),
        'day'
    );

    if (!g || !g.getDivId()) {
        console.error("Gantt container not found");
        return;
    }

    // Clean viewer mode
    if (g.setShowRes) g.setShowRes(0);
    if (g.setShowDur) g.setShowDur(0);
    if (g.setShowComp) g.setShowComp(0);
    if (g.setShowStartDate) g.setShowStartDate(0);
    if (g.setShowEndDate) g.setShowEndDate(0);

    // OPTIONAL: matikan sort internal kalau tersedia
    if (g.setUseSort) g.setUseSort(0);

    // Tambahkan task sesuai urutan JSON
    tasks.forEach(function (t, index) {

        const hasDate = t.start && t.end;

        g.AddTaskItemObject({
            pID: index + 1, 
            pName: t.name,
            pStart: hasDate ? t.start : "",
            pEnd: hasDate ? t.end : "",
            pClass: hasDate ? "gtaskblue" : "",
            pLink: "",
            pMile: hasDate && t.start === t.end ? 1 : 0,
            pDuration: t.duration || 0 ,
            pRes: "",
            pComp: t.progress || 0,
            pGroup: 0,
            pParent: 0,
            pOpen: 1
        });
    });

    g.Draw();
    g.DrawDependencies();
}
