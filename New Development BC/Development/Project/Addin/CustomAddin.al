controladdin CustomGantt
{
    Scripts =
        'Development/Project/Script/jsgantt.js',
        'Development/Project/Script/gantt.js';

    StyleSheets =
        'Development/Project/Script/jsgantt.css';

    StartupScript =
        'Development/Project/Script/startup.js';

    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;

    event OnControlReady();
    procedure LoadData(Data: Text);
}