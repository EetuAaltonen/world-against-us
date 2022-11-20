if (IsGUIStateClosed())
{
	if (window_get_cursor()	!= cr_none) { window_set_cursor(cr_none); }
} else {
	if (window_get_cursor()	!= cr_default) { window_set_cursor(cr_default); }
}