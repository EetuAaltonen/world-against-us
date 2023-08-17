function LootTablePool(_roll_chance, _rolls, _entries) constructor
{
	roll_chance = _roll_chance;
	rolls = _rolls;
	entries = _entries;
	probabilitySpectrum = 0;
	
	InitProbabilitySpectrum();
	
	static InitProbabilitySpectrum = function()
	{
		var entryCount = array_length(entries);
		for (var i = 0; i < entryCount; i++)
		{
			var entry = entries[@ i];
			probabilitySpectrum += entry.weight;
		}
	}
	
	static RollEntry = function()
	{
		var rolledEntry = undefined;
		var dropIndex = irandom_range(1, probabilitySpectrum);
		var spectrumIndex = 0;
		var entryCount = array_length(entries);
		for (var i = 0; i < entryCount; i++)
		{
			var entry = entries[@ i];
			if (dropIndex >= (1 + spectrumIndex) && dropIndex <= (spectrumIndex + entry.weight))
			{
				rolledEntry = entry;
				break;
			}
			spectrumIndex += entry.weight;
		}
		return rolledEntry;
	}
}