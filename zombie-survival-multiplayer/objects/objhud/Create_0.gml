hudHeight = 100;
hudAlpha = 0.95;

// HUD ELEMENTS
var hudVerticalCenter = (global.GUIH - (hudHeight * 0.5));
hudElementHealth = new HUDElementHealth(new Vector2(60, hudVerticalCenter));

hudElementFullness = new HUDElementIconValuePair(new Vector2(160, hudVerticalCenter), sprHunger);
hudElementHydration = new HUDElementIconValuePair(new Vector2(230, hudVerticalCenter), sprHydration);
hudElementEnergy = new HUDElementIconValuePair(new Vector2(300, hudVerticalCenter), sprEnergy);

hudElementAmmo = new HUDElementAmmo(new Vector2(global.GUIW - 100, /*Bottom pivot*/global.GUIH - hudHeight))

initHUDValues = true;

highlightedTargetCollisionPos = new Vector2(0, 0);