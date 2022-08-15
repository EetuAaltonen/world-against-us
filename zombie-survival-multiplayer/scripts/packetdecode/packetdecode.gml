function DecodeBuffer(_buffer) {
	buffer_seek(_buffer, buffer_seek_start, 0);
	
	var response = buffer_read(_buffer, buffer_string);
	var data = json_parse(response);
	
	return data;
}