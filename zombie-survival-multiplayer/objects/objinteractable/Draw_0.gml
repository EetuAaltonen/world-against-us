if (global.HighlightHandlerRef.highlightedInstanceId == id)
{
	shader_set(shdrHighlightInstance);

	var texture = sprite_get_texture(sprite_index, image_index);
	var textureWidth = texture_get_texel_width(texture);
	var textureHeight = texture_get_texel_height(texture);

	shader_set_uniform_f(uniformHandler, textureWidth, textureHeight);
	draw_self();

	shader_reset();
} else {
	draw_self();
}