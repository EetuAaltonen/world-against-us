if (pulseTimer > 0 && pulseTimer <= pulseDelay)
{
	heartScale = heartPulseScale;
} else if (pulseTimer <= 0)
{
	heartScale = heartBaseScale;
	pulseTimer = TimerRatePerMinute(beatRate);
}
pulseTimer--;
