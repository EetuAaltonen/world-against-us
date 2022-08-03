fireRate = 300; //per minute
fireDelay = TimerRatePerMinute(fireRate);
recoil = 0;

magazineSize = 30;
bulletCount = magazineSize;
bulletAnimations = array_create(magazineSize, -1);
bulletAnimationStep = 0.05;