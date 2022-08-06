hudHeight = 80;

heartBaseScale = 0.5;
heartPulseScale = 0.7;
heartScale = heartBaseScale;

beatRate = 70; // per minute
pulseDelay = 10; // in frames

pulseTimer = TimerRatePerMinute(beatRate);

pulseLinePoints = ds_list_create();
pulseIndicatorSize = 8;
initPulseLine = true;

// STYLES
colHUDBg = make_colour_rgb(0, 0, 0);
alphaHUGBg = 0.8;

scaleHUDIcons = 0.35;

colPulseLine = make_colour_rgb(53, 138, 0);
colPulsePointer = make_colour_rgb(55, 255, 0);
