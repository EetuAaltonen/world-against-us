function LootTablePool(_roll_chance, _rolls, _entries) constructor
{
	roll_chance = _roll_chance;
	rolls = _rolls;
	entries = _entries;
	probabilitySpectrum = 0;
	is_initialized = false;
	
	Initialize();
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.rolls);
		_struct.rolls = undefined;
		
		ReleaseVariableFromMemory(_struct.entries);
		_struct.entries = undefined;
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			var entryCount = array_length(entries);
			for (var i = 0; i < entryCount; i++)
			{
				var entry = entries[@ i];
				probabilitySpectrum += entry.weight;
			}
			is_initialized = true;
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