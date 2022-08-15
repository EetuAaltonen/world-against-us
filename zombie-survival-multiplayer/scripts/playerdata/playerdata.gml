function PlayerData(_uuid, _position, _vector_speed, _input_map) constructor
{
	uuid = _uuid;
	tick_time = current_time;
    position = _position;
    vector_speed = _vector_speed;
    input_map = _input_map;
}

function InputMap(_key_up, _key_down, _key_left, _key_right) constructor
{
	key_up = _key_up;
    key_down = _key_down;
    key_left = _key_left;
    key_right = _key_right;
}