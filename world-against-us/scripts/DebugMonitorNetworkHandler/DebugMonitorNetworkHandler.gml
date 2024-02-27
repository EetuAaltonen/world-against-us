function DebugMonitorNetworkHandler() constructor
{
	// PING
	ping_samples = [];
	ping_samples_max_count = 300;
	ping_samples_max_value = 1;
	ping_sample_interval = 1000;
	
	// OVER TIME PACKET LOSS COUNT
	packet_loss_samples = [];
	packet_loss_samples_max_value = 1;
	
	// DATA RATE
	data_rate_sample_interval = 1000;
	// DATA IN RATE
	data_in_samples = [];
	data_in_samples_max_count = 300;
	data_in_samples_max_value = 1;
	
	
	// DATA OUT RATE
	data_out_samples = [];
	data_out_samples_max_count = 300;
	data_out_samples_max_value = 1;
	
	static ResetNetworkDebugMonitoring = function()
	{
		// PING
		ping_samples = [];
		ping_samples_max_value = 1;
		
		// OVER TIME PACKET LOSS COUNT
		packet_loss_samples = [];
		packet_loss_samples_max_value = 1;
		
		// DATA IN RATE
		data_in_samples = [];
		data_in_samples_max_value = 1;
		
		// DATA OUT RATE
		data_out_samples = [];
		data_out_samples_max_value = 1;
	}
}