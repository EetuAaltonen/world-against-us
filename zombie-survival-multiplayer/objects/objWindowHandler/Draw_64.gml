var windowCount = ds_list_size(gameWindows);

for (var i = 0; i < windowCount; i++)
{
	var window = gameWindows[| i];
	window.Draw();
}