if (pulseTimer <= 0 && pulseTimer > -pulseDelay)
{
	heartScale = 2.2;
} else if (pulseTimer <= -pulseDelay) {
	heartScale = 2;
	pulseTimer = TimerRatePerMinute(beatRate, pulseDelay);
}
pulseTimer --;
